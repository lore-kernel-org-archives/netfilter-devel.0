From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [CTNETLINK] Rework conntrack fields dumping logic on events
Date: Fri, 10 Nov 2006 02:20:21 +0100
Message-ID: <4553D3D5.40408@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010907000408020402090009"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------010907000408020402090009
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


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

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------010907000408020402090009
Content-Type: text/plain;
 name="03events.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03events.patch"

[CTNETLINK] Rework conntrack fields dumping logic on events

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

This patch also replace IPCT_HELPINFO by IPCT_HELPER since we want to track
the helper assignation process, not the changes in the private information
held by the helper.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: linux-2.6.git/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- linux-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2006-11-08 23:55:49.000000000 +0100
+++ linux-2.6.git/net/netfilter/nf_conntrack_netlink.c	2006-11-10 01:02:19.000000000 +0100
@@ -329,8 +329,6 @@ static int ctnetlink_conntrack_event(str
 	} else  if (events & (IPCT_NEW | IPCT_RELATED)) {
 		type = IPCTNL_MSG_CT_NEW;
 		flags = NLM_F_CREATE|NLM_F_EXCL;
-		/* dump everything */
-		events = ~0UL;
 		group = NFNLGRP_CONNTRACK_NEW;
 	} else  if (events & (IPCT_STATUS | IPCT_PROTOINFO)) {
 		type = IPCTNL_MSG_CT_NEW;
@@ -365,28 +363,35 @@ static int ctnetlink_conntrack_event(str
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
Index: linux-2.6.git/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- linux-2.6.git.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-11-08 23:54:55.000000000 +0100
+++ linux-2.6.git/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-11-10 01:02:21.000000000 +0100
@@ -319,8 +319,6 @@ static int ctnetlink_conntrack_event(str
 	} else if (events & (IPCT_NEW | IPCT_RELATED)) {
 		type = IPCTNL_MSG_CT_NEW;
 		flags = NLM_F_CREATE|NLM_F_EXCL;
-		/* dump everything */
-		events = ~0UL;
 		group = NFNLGRP_CONNTRACK_NEW;
 	} else if (events & (IPCT_STATUS | IPCT_PROTOINFO)) {
 		type = IPCTNL_MSG_CT_NEW;
@@ -355,28 +353,35 @@ static int ctnetlink_conntrack_event(str
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

--------------010907000408020402090009--
