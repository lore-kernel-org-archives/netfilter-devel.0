From: Andy Loukes <andy@navaho.co.uk>
Subject: connection leak in 2.6.1rc2 with fragmented packets
Date: Mon, 12 Jan 2004 16:34:05 +0000 (GMT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0401091600090.16623@picea.navaho>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

We've found another, this time more subtle, memory leak

if (just for testing) I set ip_conntrack_max to 100

I have the following config on the router:
3: eth1: <BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast qlen 1000
    inet 172.16.0.254/24 brd 172.16.0.255 scope global eth1
5: eth3: <BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast qlen 1000
    inet 172.17.0.254/24 brd 172.17.0.255 scope global eth3

I then have one machine plugged in on each subnet

from a machine inet 172.16.0.12/24
if I do a normal ping  I see the number of active ip-conntrack objects 
shoot up and then drop back down to the original number.

if I ping with a 2500 byte packet it goes up but drops to a number 1 more 
than previously.

If I do a flood ping it goes up to over 100 and drops to 100 and then 
stays there. Meanwhile /proc/net/ip_conntrack has just one entry.

I'm looking at this line:
# name            <active_objs> <num_objs> <objsize> <objperslab> 
<pagesperslab> : tunables <batchcount> <limit> <sharedfactor> : slabdata 
<active_slabs> <num_slabs> <sharedavail>
ip_conntrack         100    108    320   12    1 : tunables   54   27    0 
: slabdata      9      9      0

On our main firewall this means that after a few days it looks like this:

# awk '/#|connt/' /proc/slabinfo 
# name            <active_objs> <num_objs> <objsize> <objperslab> 
<pagesperslab> : tunables <batchcount> <limit> <sharedfactor> : slabdata 
<active_slabs> <num_slabs> <sharedavail>
ip_conntrack       24823  25428    320   12    1 : tunables   54   27    0 
: slabdata   2119   2119      0

# wc -l /proc/net/ip_conntrack
    492 /proc/net/ip_conntrack

Anyone have any ideas about this?


-- 
Andy Loukes
http://www.navaho.co.uk				Complete Appliance Technology
