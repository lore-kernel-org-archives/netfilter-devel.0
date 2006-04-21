From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Rsend : Transmit mark to userspace during conntrack
	event
Date: Sat, 22 Apr 2006 01:54:43 +0200
Message-ID: <444970C3.5000202@trash.net>
References: <1145223945.5659.4.camel@porky>
	<1145652932.5191.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070504060604020807070404"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1145652932.5191.6.camel@localhost.localdomain>
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
--------------070504060604020807070404
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Eric Leblond wrote:
>>When userspace listen to conntrack event, the connection mark was not
>>sent in the ctnetlink message. The following patch transmits the
>>connection mark to userspace.

Thanks Eric. After looking at xt_CONNMARK I think I know why the
mark wasn't included in the update messages, we didn't even had
notifications for changes. I've queued this patch instead.


--------------070504060604020807070404
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: ctnetlink: fix conntrack mark change notifications

The connection mark was not included in event messages and changes didn't
cause event delivery.

Based on patch by Eric Leblond <eric@inl.fr>

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f62ae14f884c89b9e34417435265780ead18976e
tree 93bedfa47324e1819751854359e97e8c9a15b620
parent d3adb6926baf464a3dfc5130a67fe5bb02319ab7
author Patrick McHardy <kaber@trash.net> Sat, 22 Apr 2006 01:55:07 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 22 Apr 2006 01:55:07 +0200

 include/linux/netfilter/nf_conntrack_common.h |    4 ++++
 net/ipv4/netfilter/ip_conntrack_netlink.c     |    6 +++++-
 net/netfilter/nf_conntrack_netlink.c          |    6 +++++-
 net/netfilter/xt_CONNMARK.c                   |    8 ++++++--
 4 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index 3ff88c8..4884455 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -121,6 +121,10 @@ enum ip_conntrack_events
 	/* Counter highest bit has been set */
 	IPCT_COUNTER_FILLING_BIT = 11,
 	IPCT_COUNTER_FILLING = (1 << IPCT_COUNTER_FILLING_BIT),
+
+	/* Connection mark */
+	IPCT_MARK_BIT = 12,
+	IPCT_MARK = (1 << IPCT_MARK_BIT),
 };
 
 enum ip_conntrack_expect_events {
diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index 01bd7ca..0fee630 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -333,7 +333,8 @@ static int ctnetlink_conntrack_event(str
 		      IPCT_PROTOINFO |
 		      IPCT_HELPER |
 		      IPCT_HELPINFO |
-		      IPCT_NATINFO)) {
+		      IPCT_NATINFO |
+		      IPCT_MARK)) {
 		type = IPCTNL_MSG_CT_NEW;
 		group = NFNLGRP_CONNTRACK_UPDATE;
 	} else 
@@ -380,6 +381,9 @@ static int ctnetlink_conntrack_event(str
 	if (events & IPCT_HELPINFO
 	    && ctnetlink_dump_helpinfo(skb, ct) < 0)
 		goto nfattr_failure;
+	if (events & IPCT_MARK
+	    && ctnetlink_dump_mark(skb, ct) < 0)
+		goto nfattr_failure;
 
 	if (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
 	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0)
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index bd10eb9..36ff941 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -342,7 +342,8 @@ static int ctnetlink_conntrack_event(str
 		      IPCT_PROTOINFO |
 		      IPCT_HELPER |
 		      IPCT_HELPINFO |
-		      IPCT_NATINFO)) {
+		      IPCT_NATINFO |
+		      IPCT_MARK)) {
 		type = IPCTNL_MSG_CT_NEW;
 		group = NFNLGRP_CONNTRACK_UPDATE;
 	} else
@@ -389,6 +390,9 @@ static int ctnetlink_conntrack_event(str
 	if (events & IPCT_HELPINFO
 	    && ctnetlink_dump_helpinfo(skb, ct) < 0)
 		goto nfattr_failure;
+	if (events & IPCT_MARK
+	    && ctnetlink_dump_mark(skb, ct) < 0)
+		goto nfattr_failure;
 
 	if (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
 	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0)
diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index 60c375d..f0bb6d6 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -52,13 +52,17 @@ target(struct sk_buff **pskb,
 	    switch(markinfo->mode) {
 	    case XT_CONNMARK_SET:
 		newmark = (*ctmark & ~markinfo->mask) | markinfo->mark;
-		if (newmark != *ctmark)
+		if (newmark != *ctmark) {
 		    *ctmark = newmark;
+		    ip_conntrack_event_cache(IPCT_MARK, *pskb);
+		}
 		break;
 	    case XT_CONNMARK_SAVE:
 		newmark = (*ctmark & ~markinfo->mask) | ((*pskb)->nfmark & markinfo->mask);
-		if (*ctmark != newmark)
+		if (*ctmark != newmark) {
 		    *ctmark = newmark;
+		    ip_conntrack_event_cache(IPCT_MARK, *pskb);
+		}
 		break;
 	    case XT_CONNMARK_RESTORE:
 		nfmark = (*pskb)->nfmark;

--------------070504060604020807070404--
