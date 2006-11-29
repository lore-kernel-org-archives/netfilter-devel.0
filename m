From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 25/33]: ctnetlink: rework conntrack fields dumping logic
	on events
Date: Wed, 29 Nov 2006 03:09:22 +0100 (MET)
Message-ID: <20061129020922.21082.13986.sendpatchset@localhost.localdomain>
References: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: ctnetlink: rework conntrack fields dumping logic on events

               |   NEW   | UPDATE  | DESTROY |
     ----------------------------------------|
     tuples    |    Y    |    Y    |    Y    |
     status    |    Y    |    Y    |    N    |
     timeout   |    Y    |    Y    |    N    |
     protoinfo |    S    |    S    |    N    |
     helper    |    S    |    S    |    N    |
     mark      |    S    |    S    |    N    |
     counters  |    F    |    F    |    Y    |

 Leyend:
         Y: yes
         N: no
         S: iif the field is set
	 F: iif overflow

This patch also replace IPCT_HELPINFO by IPCT_HELPER since we want to
track the helper assignation process, not the changes in the private
information held by the helper.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 29bacca329c6e3b2c1db0dcf5e9af0c25f62e499
tree 10e555cb146f9d240e5a0493b6f4c6ec1d96a343
parent 9f1f643dcb442e2bd19afd3fec8d1a3958cf5629
author Pablo Neira Ayuso <pablo@netfilter.org> Tue, 28 Nov 2006 23:13:15 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 29 Nov 2006 02:32:51 +0100

 net/ipv4/netfilter/ip_conntrack_netlink.c |   49 ++++++++++++++++-------------
 net/netfilter/nf_conntrack_netlink.c      |   49 ++++++++++++++++-------------
 2 files changed, 54 insertions(+), 44 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index d5d2efd..5fcf91d 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -320,8 +320,6 @@ static int ctnetlink_conntrack_event(str
 	} else if (events & (IPCT_NEW | IPCT_RELATED)) {
 		type = IPCTNL_MSG_CT_NEW;
 		flags = NLM_F_CREATE|NLM_F_EXCL;
-		/* dump everything */
-		events = ~0UL;
 		group = NFNLGRP_CONNTRACK_NEW;
 	} else if (events & (IPCT_STATUS | IPCT_PROTOINFO)) {
 		type = IPCTNL_MSG_CT_NEW;
@@ -356,28 +354,35 @@ static int ctnetlink_conntrack_event(str
 	if (ctnetlink_dump_tuples(skb, tuple(ct, IP_CT_DIR_REPLY)) < 0)
 		goto nfattr_failure;
 	NFA_NEST_END(skb, nest_parms);
-	
-	/* NAT stuff is now a status flag */
-	if ((events & IPCT_STATUS || events & IPCT_NATINFO)
-	    && ctnetlink_dump_status(skb, ct) < 0)
-		goto nfattr_failure;
-	if (events & IPCT_REFRESH
-	    && ctnetlink_dump_timeout(skb, ct) < 0)
-		goto nfattr_failure;
-	if (events & IPCT_PROTOINFO
-	    && ctnetlink_dump_protoinfo(skb, ct) < 0)
-		goto nfattr_failure;
-	if (events & IPCT_HELPINFO
-	    && ctnetlink_dump_helpinfo(skb, ct) < 0)
-		goto nfattr_failure;
 
-	if (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
-	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0)
-		goto nfattr_failure;
+	if (events & IPCT_DESTROY) {
+		if (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
+		    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0)
+			goto nfattr_failure;
+	} else {
+		if (ctnetlink_dump_status(skb, ct) < 0)
+			goto nfattr_failure;
 
-	if (events & IPCT_MARK
-	    && ctnetlink_dump_mark(skb, ct) < 0)
-		goto nfattr_failure;
+		if (ctnetlink_dump_timeout(skb, ct) < 0)
+			goto nfattr_failure;
+
+		if (events & IPCT_PROTOINFO
+		    && ctnetlink_dump_protoinfo(skb, ct) < 0)
+		    	goto nfattr_failure;
+
+		if ((events & IPCT_HELPER || ct->helper)
+		    && ctnetlink_dump_helpinfo(skb, ct) < 0)
+		    	goto nfattr_failure;
+
+		if ((events & IPCT_MARK || ct->mark)
+		    && ctnetlink_dump_mark(skb, ct) < 0)
+		    	goto nfattr_failure;
+
+		if (events & IPCT_COUNTER_FILLING &&
+		    (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
+		     ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0))
+			goto nfattr_failure;
+	}
 
 	nlh->nlmsg_len = skb->tail - b;
 	nfnetlink_send(skb, 0, group, 0);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index ba77183..e3a7204 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -331,8 +331,6 @@ static int ctnetlink_conntrack_event(str
 	} else  if (events & (IPCT_NEW | IPCT_RELATED)) {
 		type = IPCTNL_MSG_CT_NEW;
 		flags = NLM_F_CREATE|NLM_F_EXCL;
-		/* dump everything */
-		events = ~0UL;
 		group = NFNLGRP_CONNTRACK_NEW;
 	} else  if (events & (IPCT_STATUS | IPCT_PROTOINFO)) {
 		type = IPCTNL_MSG_CT_NEW;
@@ -367,28 +365,35 @@ static int ctnetlink_conntrack_event(str
 	if (ctnetlink_dump_tuples(skb, tuple(ct, IP_CT_DIR_REPLY)) < 0)
 		goto nfattr_failure;
 	NFA_NEST_END(skb, nest_parms);
-	
-	/* NAT stuff is now a status flag */
-	if ((events & IPCT_STATUS || events & IPCT_NATINFO)
-	    && ctnetlink_dump_status(skb, ct) < 0)
-		goto nfattr_failure;
-	if (events & IPCT_REFRESH
-	    && ctnetlink_dump_timeout(skb, ct) < 0)
-		goto nfattr_failure;
-	if (events & IPCT_PROTOINFO
-	    && ctnetlink_dump_protoinfo(skb, ct) < 0)
-		goto nfattr_failure;
-	if (events & IPCT_HELPINFO
-	    && ctnetlink_dump_helpinfo(skb, ct) < 0)
-		goto nfattr_failure;
 
-	if (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
-	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0)
-		goto nfattr_failure;
+	if (events & IPCT_DESTROY) {
+		if (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
+		    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0)
+			goto nfattr_failure;
+	} else {
+		if (ctnetlink_dump_status(skb, ct) < 0)
+			goto nfattr_failure;
 
-	if (events & IPCT_MARK
-	    && ctnetlink_dump_mark(skb, ct) < 0)
-		goto nfattr_failure;
+		if (ctnetlink_dump_timeout(skb, ct) < 0)
+			goto nfattr_failure;
+
+		if (events & IPCT_PROTOINFO
+		    && ctnetlink_dump_protoinfo(skb, ct) < 0)
+		    	goto nfattr_failure;
+
+		if ((events & IPCT_HELPER || nfct_help(ct))
+		    && ctnetlink_dump_helpinfo(skb, ct) < 0)
+		    	goto nfattr_failure;
+
+		if ((events & IPCT_MARK || ct->mark)
+		    && ctnetlink_dump_mark(skb, ct) < 0)
+		    	goto nfattr_failure;
+
+		if (events & IPCT_COUNTER_FILLING &&
+		    (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
+		     ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0))
+			goto nfattr_failure;
+	}
 
 	nlh->nlmsg_len = skb->tail - b;
 	nfnetlink_send(skb, 0, group, 0);
