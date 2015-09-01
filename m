From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCHv2 nf-next 3/5] netfilter: nfnetlink_queue_ct: export functions
Date: Tue, 1 Sep 2015 09:41:46 +0900
Message-ID: <20150901004146.GD2642@gmail.com>
References: <20150824231038.GA20038@gmail.com>
 <20150824231520.GC20038@gmail.com>
 <20150826190553.GA18429@salvia>
 <20150901003436.GA2642@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33169 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbbIAAlv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Aug 2015 20:41:51 -0400
Received: by paczk9 with SMTP id zk9so7816577pac.0
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2015 17:41:51 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150901003436.GA2642@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch exports functions in nfnetlink_queue_ct to use not only
from nfqueue, and move nfnetlink_queue_ct, conntrack attachement
basis, to nf_conntrack_netlink from nfnetlink_queue_core.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 include/linux/netfilter.h                 |    1 -
 net/netfilter/Makefile                    |    2 +-
 net/netfilter/core.c                      |    3 ---
 net/netfilter/nf_conntrack_netlink_core.c |    3 +++
 net/netfilter/nfnetlink_queue_ct.c        |    7 +++++++
 5 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index d788ce6..b93422f 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -385,7 +385,6 @@ struct nfq_ct_hook {
 	void (*seq_adjust)(struct sk_buff *skb, struct nf_conn *ct,
 			   enum ip_conntrack_info ctinfo, s32 off);
 };
-extern struct nfq_ct_hook __rcu *nfq_ct_hook;
 #else
 static inline void nf_ct_attach(struct sk_buff *new, struct sk_buff *skb) {}
 #endif
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 05a7746..194dfa6 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -11,7 +11,6 @@ obj-$(CONFIG_NETFILTER) = netfilter.o
 obj-$(CONFIG_NETFILTER_NETLINK) += nfnetlink.o
 obj-$(CONFIG_NETFILTER_NETLINK_ACCT) += nfnetlink_acct.o
 nfnetlink_queue-y := nfnetlink_queue_core.o
-nfnetlink_queue-$(CONFIG_NETFILTER_NETLINK_QUEUE_CT) += nfnetlink_queue_ct.o
 obj-$(CONFIG_NETFILTER_NETLINK_QUEUE) += nfnetlink_queue.o
 obj-$(CONFIG_NETFILTER_NETLINK_LOG) += nfnetlink_log.o
 
@@ -26,6 +25,7 @@ obj-$(CONFIG_NF_CT_PROTO_UDPLITE) += nf_conntrack_proto_udplite.o
 
 # netlink interface for nf_conntrack
 nf_conntrack_netlink-y := nf_conntrack_netlink_core.o
+nf_conntrack_netlink-$(CONFIG_NETFILTER_NETLINK_QUEUE_CT) += nfnetlink_queue_ct.o
 obj-$(CONFIG_NF_CT_NETLINK) += nf_conntrack_netlink.o
 obj-$(CONFIG_NF_CT_NETLINK_TIMEOUT) += nfnetlink_cttimeout.o
 obj-$(CONFIG_NF_CT_NETLINK_HELPER) += nfnetlink_cthelper.o
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 0b939b7..aa68a76 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -385,9 +385,6 @@ void nf_conntrack_destroy(struct nf_conntrack *nfct)
 }
 EXPORT_SYMBOL(nf_conntrack_destroy);
 
-struct nfq_ct_hook __rcu *nfq_ct_hook __read_mostly;
-EXPORT_SYMBOL_GPL(nfq_ct_hook);
-
 #endif /* CONFIG_NF_CONNTRACK */
 
 #ifdef CONFIG_NF_NAT_NEEDED
diff --git a/net/netfilter/nf_conntrack_netlink_core.c b/net/netfilter/nf_conntrack_netlink_core.c
index 94a6654..63e1f11 100644
--- a/net/netfilter/nf_conntrack_netlink_core.c
+++ b/net/netfilter/nf_conntrack_netlink_core.c
@@ -2134,6 +2134,9 @@ ctnetlink_alloc_expect(const struct nlattr *const cda[], struct nf_conn *ct,
 		       struct nf_conntrack_tuple *mask);
 
 #ifdef CONFIG_NETFILTER_NETLINK_QUEUE_CT
+
+extern struct nfq_ct_hook __rcu *nfq_ct_hook __read_mostly;
+
 static size_t
 ctnetlink_nfqueue_build_size(const struct nf_conn *ct)
 {
diff --git a/net/netfilter/nfnetlink_queue_ct.c b/net/netfilter/nfnetlink_queue_ct.c
index 2a30618..299b5a8 100644
--- a/net/netfilter/nfnetlink_queue_ct.c
+++ b/net/netfilter/nfnetlink_queue_ct.c
@@ -14,6 +14,8 @@
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nfnetlink_queue.h>
 
+struct nfq_ct_hook __rcu *nfq_ct_hook __read_mostly;
+
 struct nf_conn *nfqnl_ct_get(struct sk_buff *entskb, size_t *size,
 			     enum ip_conntrack_info *ctinfo)
 {
@@ -34,6 +36,7 @@ struct nf_conn *nfqnl_ct_get(struct sk_buff *entskb, size_t *size,
 	}
 	return ct;
 }
+EXPORT_SYMBOL_GPL(nfqnl_ct_get);
 
 struct nf_conn *
 nfqnl_ct_parse(const struct sk_buff *skb, const struct nlattr *attr,
@@ -53,6 +56,7 @@ nfqnl_ct_parse(const struct sk_buff *skb, const struct nlattr *attr,
 
 	return ct;
 }
+EXPORT_SYMBOL_GPL(nfqnl_ct_parse);
 
 int nfqnl_ct_put(struct sk_buff *skb,
 		 struct nf_conn *ct, int type,
@@ -84,6 +88,7 @@ int nfqnl_ct_put(struct sk_buff *skb,
 nla_put_failure:
 	return -1;
 }
+EXPORT_SYMBOL_GPL(nfqnl_ct_put);
 
 void nfqnl_ct_seq_adjust(struct sk_buff *skb, struct nf_conn *ct,
 			 enum ip_conntrack_info ctinfo, int diff)
@@ -97,6 +102,7 @@ void nfqnl_ct_seq_adjust(struct sk_buff *skb, struct nf_conn *ct,
 	if ((ct->status & IPS_NAT_MASK) && diff)
 		nfq_ct->seq_adjust(skb, ct, ctinfo, diff);
 }
+EXPORT_SYMBOL_GPL(nfqnl_ct_seq_adjust);
 
 int nfqnl_attach_expect(struct nf_conn *ct, const struct nlattr *attr,
 			u32 portid, u32 report)
@@ -112,3 +118,4 @@ int nfqnl_attach_expect(struct nf_conn *ct, const struct nlattr *attr,
 
 	return nfq_ct->attach_expect(attr, ct, portid, report);
 }
+EXPORT_SYMBOL_GPL(nfqnl_attach_expect);
-- 
1.7.10.4

