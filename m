From: Karlis Peisenieks <karlis@mt.lv>
Subject: recent in_range fix uncovered another bug?
Date: Wed, 10 Sep 2003 14:05:55 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030910110555.GA30240@mt.lv>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="k1lZvvs/B4yU6o8G"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: coreteam@netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello!

I came across "lockup" in conntrack code using 2.4 kernel with bridge 
netfilter (which is standart in 2.6 kernel) patch applied. Lockup can be 
reproduced by pinging some host over bridge interface if the host is 
unreachable in the beginning (e.g. ARP does not resolve) and then 
becomes reachable (ARP resolves).

Here is what happens:

- echo request is conntrack-ed, new conntrack is created
- bridge netfilter code "sabotages" in post-routing hook, so it can 
process the rest of hooks when actual outgoing interface is determined
- neigbour code takes over packet and holds it until ARP is resolved, 
conntrack for packet is "hanging in the air"
- above repeats for _every_ echo request packet created

At this point ARP gets resolved

- neighbour code "flushes" its queue, sending packets one by one to 
bridge interface
- bridge code determines outgoing interface and calls IP post-routing 
hook
- nat code creates null-binding
- post-routing hook confirms conntrack, it gets linked in lists
- packet is queued for hw interface

- neighbour code sends second packet
- all goes as above up to creating of null-binding
- in ip_nat_setup_info loop that is calling get_unique_tuple loops 
forever because:

- find_appropriate_src finds existing src-mainp (which is not doing 
anything anyway) and decides to use it
- ip_conntrack_alter_reply fails because it finds conntrack looking 
exactly the same as this (remember - that conntrack got confirmed when 
sending first packet) and thinks that get_unique_tuple will return 
better unique tuple.

So problem here are 2 equal conntrack-s, that should normaly be one, but
as confirmation of first got delayed (because of bridge interface
standing in the middle), second one got created.

It did not happen before in_range logic fix because every time 
completely new manip was created (with different icmp id) which made 
those conntracks different.

I hope the problem is more or less clear :). What should be fixed here? 
I doubt it is bridge code (although this "sabotage" is evil - at least 
in how it makes code hard to understand), because there can be other 
cases when packet can be delayed (e.g. with ip_queue?) without 
conntrack confirmation.

Quick and dirty fix to avoid lockup was to avoid ip_nat_setup_info 
looping forever. Patch attached.


Karlis

--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="nat.patch"

diff -u -r1.3.4.8 ip_nat_core.c
--- ip_nat_core.c	2 Sep 2003 10:21:18 -0000	1.3.4.8
+++ ip_nat_core.c	10 Sep 2003 09:22:50 -0000
@@ -516,6 +516,7 @@
 	struct ip_conntrack_tuple new_tuple, inv_tuple, reply;
 	struct ip_conntrack_tuple orig_tp;
 	struct ip_nat_info *info = &conntrack->nat.info;
+	int i;
 
 	MUST_BE_WRITE_LOCKED(&ip_nat_lock);
 	IP_NF_ASSERT(hooknum == NF_IP_PRE_ROUTING
@@ -557,7 +558,9 @@
 	}
 #endif
 
+	i = 0;
 	do {
+		if (i++ == 3) return NF_DROP;
 		if (!get_unique_tuple(&new_tuple, &orig_tp, mr, conntrack,
 				      hooknum)) {
 			DEBUGP("ip_nat_setup_info: Can't get unique for %p.\n",

--k1lZvvs/B4yU6o8G--
