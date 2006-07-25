From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/8][CTNETLINK] Rework conntrack fields dumping logic on
	events
Date: Tue, 25 Jul 2006 15:26:47 +0200
Message-ID: <44C61C17.5040800@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040505030401000002050508"
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
--------------040505030401000002050508
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

What do we dump on conntrack events? Good question, the following table 
should clarify 8)

                |   NEW   | UPDATE  | DESTROY |
      ----------------------------------------|
      tuples    |    Y    |    Y    |    Y    |
      status    |    Y    |    Y    |    N    |
      timeout   |    Y    |    Y    |    N    |
      protoinfo |    Y    |    Y    |    N    |
      helper    |    S    |    S    |    N    |
      counters  |    N    |    N    |    Y    |
      mark      |    S    |    S    |    N    |

  Leyend:
          Y: yes
          N: no
          S: iif the field is set

This patch also replace IPCT_HELPINFO by IPCT_HELPER since we want to 
track the helper assignation process, not the changes in the private 
information held by the helper.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------040505030401000002050508
Content-Type: text/plain;
 name="06events.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="06events.patch"

[CTNETLINK] Rework conntrack fields dumping logic on events

What do we dump on conntrack events? Good question,
the following table should clarify 8)

               |   NEW   | UPDATE  | DESTROY |
     ----------------------------------------|

     tuples    |    Y    |    Y    |    Y    |
     status    |    Y    |    Y    |    N    |
     timeout   |    Y    |    Y    |    N    |
     protoinfo |    Y    |    Y    |    N    |
     helper    |    S    |    S    |    N    |
     counters  |    N    |    N    |    Y    |
     mark      |    S    |    S    |    N    |

 Leyend:
         Y: yes
         N: no
         S: iif the field is set

This patch also replace IPCT_HELPINFO by IPCT_HELPER since we want to track
the helper assignation process, not the changes in the private information
held by the helper.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-2.6.orig/net/netfilter/nf_conntrack_netlink.c	2006-07-24 18:40:19.000000000 +0200
+++ net-2.6/net/netfilter/nf_conntrack_netlink.c	2006-07-25 01:14:43.000000000 +0200
@@ -336,8 +336,9 @@ static int ctnetlink_conntrack_event(str
 	} else  if (events & (IPCT_NEW | IPCT_RELATED)) {
 		type = IPCTNL_MSG_CT_NEW;
 		flags = NLM_F_CREATE|NLM_F_EXCL;
-		/* dump everything */
-		events = ~0UL;
+		events |= IPCT_REFRESH | 
+			  IPCT_STATUS |
+			  IPCT_PROTOINFO;
 		group = NFNLGRP_CONNTRACK_NEW;
 	} else  if (events & (IPCT_STATUS |
 		      IPCT_PROTOINFO |
@@ -345,6 +346,9 @@ static int ctnetlink_conntrack_event(str
 		      IPCT_HELPINFO |
 		      IPCT_NATINFO)) {
 		type = IPCTNL_MSG_CT_NEW;
+		events |= IPCT_REFRESH |
+			  IPCT_STATUS |
+			  IPCT_PROTOINFO;
 		group = NFNLGRP_CONNTRACK_UPDATE;
 	} else
 		return NOTIFY_DONE;
@@ -367,6 +371,26 @@ static int ctnetlink_conntrack_event(str
 	nfmsg->version	= NFNETLINK_V0;
 	nfmsg->res_id	= 0;
 
+	/*
+	 * What do we dump on conntrack events? Good question,
+	 * the following table should clarify 8)
+	 *
+	 *                |   NEW   | UPDATE  | DESTROY |
+	 *      ----------------------------------------|
+	 * 	tuples    |    Y    |    Y    |    Y    |
+	 * 	status    |    Y    |    Y    |    N    |
+	 * 	timeout   |    Y    |    Y    |    N    |
+	 *      protoinfo |    Y    |    Y    |    N    |
+	 *      helper    |    S    |    S    |    N    |
+	 * 	counters  |    N    |    N    |    Y    |
+	 * 	mark      |    S    |    S    |    N    |
+	 *
+	 * Leyend:
+	 *         Y: yes
+	 *         N: no
+	 *         S: iif the field is set
+	 */
+
 	nest_parms = NFA_NEST(skb, CTA_TUPLE_ORIG);
 	if (ctnetlink_dump_tuples(skb, tuple(ct, IP_CT_DIR_ORIGINAL)) < 0)
 		goto nfattr_failure;
@@ -387,15 +411,17 @@ static int ctnetlink_conntrack_event(str
 	if (events & IPCT_PROTOINFO
 	    && ctnetlink_dump_protoinfo(skb, ct) < 0)
 		goto nfattr_failure;
-	if (events & IPCT_HELPINFO
+	if ((events & IPCT_HELPER || nfct_help(ct))
 	    && ctnetlink_dump_helpinfo(skb, ct) < 0)
 		goto nfattr_failure;
 
-	if (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
-	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0)
+	/* this connection has died or counters wrapped around */
+	if ((events & IPCT_DESTROY || events & IPCT_COUNTER_FILLING)
+	    && (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
+		ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0))
 		goto nfattr_failure;
 
-	if (events & IPCT_MARK
+	if ((events & IPCT_MARK || ct->mark)
 	    && ctnetlink_dump_mark(skb, ct) < 0)
 		goto nfattr_failure;
 
Index: net-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- net-2.6.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-07-25 01:14:51.000000000 +0200
+++ net-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-07-25 01:20:21.000000000 +0200
@@ -326,8 +326,9 @@ static int ctnetlink_conntrack_event(str
 	} else if (events & (IPCT_NEW | IPCT_RELATED)) {
 		type = IPCTNL_MSG_CT_NEW;
 		flags = NLM_F_CREATE|NLM_F_EXCL;
-		/* dump everything */
-		events = ~0UL;
+		events |= IPCT_REFRESH |
+			  IPCT_STATUS |
+			  IPCT_PROTOINFO;
 		group = NFNLGRP_CONNTRACK_NEW;
 	} else if (events & (IPCT_STATUS |
 		      IPCT_PROTOINFO |
@@ -335,6 +336,9 @@ static int ctnetlink_conntrack_event(str
 		      IPCT_HELPINFO |
 		      IPCT_NATINFO)) {
 		type = IPCTNL_MSG_CT_NEW;
+		events |= IPCT_REFRESH |
+			  IPCT_STATUS |
+			  IPCT_PROTOINFO;
 		group = NFNLGRP_CONNTRACK_UPDATE;
 	} else 
 		return NOTIFY_DONE;
@@ -357,6 +361,25 @@ static int ctnetlink_conntrack_event(str
 	nfmsg->version	= NFNETLINK_V0;
 	nfmsg->res_id	= 0;
 
+	/*
+	 * What do we dump on conntrack events? Good question,
+	 * the following table should clarify 8)
+	 *     |   NEW   | UPDATE  | DESTROY |
+	 *     ----------------------------------------|
+	 *     tuples    |    Y    |    Y    |    Y    |
+	 *     status    |    Y    |    Y    |    N    |
+	 *     timeout   |    Y    |    Y    |    N    |
+	 *     protoinfo |    Y    |    Y    |    N    |
+	 *     helper    |    S    |    S    |    N    |
+	 *     counters  |    N    |    N    |    Y    |
+	 *     mark      |    S    |    S    |    N    |
+	 *
+	 * Leyend:
+	 *        Y: yes
+	 *        N: no
+	 *        S: iif the field is set
+	 */
+
 	nest_parms = NFA_NEST(skb, CTA_TUPLE_ORIG);
 	if (ctnetlink_dump_tuples(skb, tuple(ct, IP_CT_DIR_ORIGINAL)) < 0)
 		goto nfattr_failure;
@@ -377,15 +400,17 @@ static int ctnetlink_conntrack_event(str
 	if (events & IPCT_PROTOINFO
 	    && ctnetlink_dump_protoinfo(skb, ct) < 0)
 		goto nfattr_failure;
-	if (events & IPCT_HELPINFO
+	if ((events & IPCT_HELPER || ct->helper)
 	    && ctnetlink_dump_helpinfo(skb, ct) < 0)
 		goto nfattr_failure;
 
-	if (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
-	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0)
+	/* this connection has died or counters wrapped around */
+	if ((events & IPCT_DESTROY || events & IPCT_COUNTER_FILLING)
+	    && (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
+		ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0))
 		goto nfattr_failure;
 
-	if (events & IPCT_MARK
+	if ((events & IPCT_MARK || ct->mark)
 	    && ctnetlink_dump_mark(skb, ct) < 0)
 		goto nfattr_failure;
 

--------------040505030401000002050508--
