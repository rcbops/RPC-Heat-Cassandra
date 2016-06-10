# Warning. Only use this when starting a new cluster and data loss is not
# a concern.
import pprint
import subprocess
import time
from salt.client.api import APIClient

client = APIClient()

print "Refreshing pillar information."
resp = client.localClient.cmd('*', 'saltutil.refresh_pillar')
pprint.pprint(resp)

print "Updating the salt mine."
resp = client.localClient.cmd('*', 'mine.update')
pprint.pprint(resp)

print "Gathering the cassandra minions"
resp = client.localClient.cmd(
    'roles:cassandra', 'test.ping', expr_form='grain'
)
minions = resp.keys()
minions.sort()
pprint.pprint(minions)

print "Applying cassandra highstate"
subprocess.call(['salt', '-G', 'roles:cassandra', 'state.highstate'])

print "Stopping all cassandra services"
subprocess.call(['salt', '-G', 'roles:cassandra', 'service.stop', 'cassandra'])

print "Just to be sure..."
subprocess.call(['salt', '-G', 'roles:cassandra', 'cmd.run', 'pkill -f java'])

print "Starting the cluster. This will run one minion at a time."
for minion in minions:
    subprocess.call(
        ['salt', minion, 'state.sls', 'cassandra.cassandra.start_cluster']
    )

print "Adding security hardening."
subprocess.call(
    ['salt', '-G', 'roles:cassandra', 'state.sls', 'cassandra.hardening']
)
