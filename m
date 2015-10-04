From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: ctnetlink: remove function inline declaration
Date: Sun,  4 Oct 2015 20:58:48 +0200
Message-ID: <1443985128-17389-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42208 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbbJDSv6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 Oct 2015 14:51:58 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@soleta.eu>

These functions are part of the control plane, so they are not performance
critical, and more importantly we should let the compiler should decide for us.

No changes wrt. size:

$ size net/netfilter/nf_conntrack_netlink.o
   text    data     bss     dec     hex filename
  19556     180       0   19736    4d18 net/netfilter/nf_conntrack_netlink.o

Signed-off-by: Pablo Neira Ayuso <pablo@soleta.eu>
---
 net/netfilter/nf_conntrack_netlink.c | 115 ++++++++++++++---------------------
 1 file changed, 47 insertions(+), 68 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index eb67bf8..58311d2 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -4,7 +4,7 @@
  * (C) 2001 by Jay Schulist <jschlst@samba.org>
  * (C) 2002-2006 by Harald Welte <laforge@gnumonks.org>
  * (C) 2003 by Patrick Mchardy <kaber@trash.net>
- * (C) 2005-2012 by Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2005-2015 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * Initial connection tracking via netlink development funded and
  * generally made possible by Network Robots, Inc. (www.networkrobots.com)
@@ -58,10 +58,9 @@ MODULE_LICENSE("GPL");
 
 static char __initdata version[] = "0.93";
 
-static inline int
-ctnetlink_dump_tuples_proto(struct sk_buff *skb,
-			    const struct nf_conntrack_tuple *tuple,
-			    struct nf_conntrack_l4proto *l4proto)
+static int ctnetlink_dump_tuples_proto(struct sk_buff *skb,
+				       const struct nf_conntrack_tuple *tuple,
+				       struct nf_conntrack_l4proto *l4proto)
 {
 	int ret = 0;
 	struct nlattr *nest_parms;
@@ -83,10 +82,9 @@ nla_put_failure:
 	return -1;
 }
 
-static inline int
-ctnetlink_dump_tuples_ip(struct sk_buff *skb,
-			 const struct nf_conntrack_tuple *tuple,
-			 struct nf_conntrack_l3proto *l3proto)
+static int ctnetlink_dump_tuples_ip(struct sk_buff *skb,
+				    const struct nf_conntrack_tuple *tuple,
+				    struct nf_conntrack_l3proto *l3proto)
 {
 	int ret = 0;
 	struct nlattr *nest_parms;
@@ -106,9 +104,8 @@ nla_put_failure:
 	return -1;
 }
 
-static int
-ctnetlink_dump_tuples(struct sk_buff *skb,
-		      const struct nf_conntrack_tuple *tuple)
+static int ctnetlink_dump_tuples(struct sk_buff *skb,
+				 const struct nf_conntrack_tuple *tuple)
 {
 	int ret;
 	struct nf_conntrack_l3proto *l3proto;
@@ -127,9 +124,8 @@ ctnetlink_dump_tuples(struct sk_buff *skb,
 	return ret;
 }
 
-static inline int
-ctnetlink_dump_zone_id(struct sk_buff *skb, int attrtype,
-		       const struct nf_conntrack_zone *zone, int dir)
+static int ctnetlink_dump_zone_id(struct sk_buff *skb, int attrtype,
+				  const struct nf_conntrack_zone *zone, int dir)
 {
 	if (zone->id == NF_CT_DEFAULT_ZONE_ID || zone->dir != dir)
 		return 0;
@@ -141,8 +137,7 @@ nla_put_failure:
 	return -1;
 }
 
-static inline int
-ctnetlink_dump_status(struct sk_buff *skb, const struct nf_conn *ct)
+static int ctnetlink_dump_status(struct sk_buff *skb, const struct nf_conn *ct)
 {
 	if (nla_put_be32(skb, CTA_STATUS, htonl(ct->status)))
 		goto nla_put_failure;
@@ -152,8 +147,7 @@ nla_put_failure:
 	return -1;
 }
 
-static inline int
-ctnetlink_dump_timeout(struct sk_buff *skb, const struct nf_conn *ct)
+static int ctnetlink_dump_timeout(struct sk_buff *skb, const struct nf_conn *ct)
 {
 	long timeout = ((long)ct->timeout.expires - (long)jiffies) / HZ;
 
@@ -168,8 +162,7 @@ nla_put_failure:
 	return -1;
 }
 
-static inline int
-ctnetlink_dump_protoinfo(struct sk_buff *skb, struct nf_conn *ct)
+static int ctnetlink_dump_protoinfo(struct sk_buff *skb, struct nf_conn *ct)
 {
 	struct nf_conntrack_l4proto *l4proto;
 	struct nlattr *nest_proto;
@@ -193,7 +186,7 @@ nla_put_failure:
 	return -1;
 }
 
-static inline int
+static int
 ctnetlink_dump_helpinfo(struct sk_buff *skb, const struct nf_conn *ct)
 {
 	struct nlattr *nest_helper;
@@ -300,8 +293,7 @@ nla_put_failure:
 }
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-static inline int
-ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct)
+static int ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct)
 {
 	if (nla_put_be32(skb, CTA_MARK, htonl(ct->mark)))
 		goto nla_put_failure;
@@ -315,8 +307,7 @@ nla_put_failure:
 #endif
 
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
-static inline int
-ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
+static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 {
 	struct nlattr *nest_secctx;
 	int len, ret;
@@ -380,8 +371,7 @@ ctnetlink_dump_labels(struct sk_buff *skb, const struct nf_conn *ct)
 
 #define master_tuple(ct) &(ct->master->tuplehash[IP_CT_DIR_ORIGINAL].tuple)
 
-static inline int
-ctnetlink_dump_master(struct sk_buff *skb, const struct nf_conn *ct)
+static int ctnetlink_dump_master(struct sk_buff *skb, const struct nf_conn *ct)
 {
 	struct nlattr *nest_parms;
 
@@ -426,8 +416,8 @@ nla_put_failure:
 	return -1;
 }
 
-static inline int
-ctnetlink_dump_ct_seq_adj(struct sk_buff *skb, const struct nf_conn *ct)
+static int ctnetlink_dump_ct_seq_adj(struct sk_buff *skb,
+				     const struct nf_conn *ct)
 {
 	struct nf_conn_seqadj *seqadj = nfct_seqadj(ct);
 	struct nf_ct_seqadj *seq;
@@ -446,8 +436,7 @@ ctnetlink_dump_ct_seq_adj(struct sk_buff *skb, const struct nf_conn *ct)
 	return 0;
 }
 
-static inline int
-ctnetlink_dump_id(struct sk_buff *skb, const struct nf_conn *ct)
+static int ctnetlink_dump_id(struct sk_buff *skb, const struct nf_conn *ct)
 {
 	if (nla_put_be32(skb, CTA_ID, htonl((unsigned long)ct)))
 		goto nla_put_failure;
@@ -457,8 +446,7 @@ nla_put_failure:
 	return -1;
 }
 
-static inline int
-ctnetlink_dump_use(struct sk_buff *skb, const struct nf_conn *ct)
+static int ctnetlink_dump_use(struct sk_buff *skb, const struct nf_conn *ct)
 {
 	if (nla_put_be32(skb, CTA_USE, htonl(atomic_read(&ct->ct_general.use))))
 		goto nla_put_failure;
@@ -538,8 +526,7 @@ nla_put_failure:
 	return -1;
 }
 
-static inline size_t
-ctnetlink_proto_size(const struct nf_conn *ct)
+static size_t ctnetlink_proto_size(const struct nf_conn *ct)
 {
 	struct nf_conntrack_l3proto *l3proto;
 	struct nf_conntrack_l4proto *l4proto;
@@ -556,8 +543,7 @@ ctnetlink_proto_size(const struct nf_conn *ct)
 	return len;
 }
 
-static inline size_t
-ctnetlink_acct_size(const struct nf_conn *ct)
+static size_t ctnetlink_acct_size(const struct nf_conn *ct)
 {
 	if (!nf_ct_ext_exist(ct, NF_CT_EXT_ACCT))
 		return 0;
@@ -567,8 +553,7 @@ ctnetlink_acct_size(const struct nf_conn *ct)
 	       ;
 }
 
-static inline int
-ctnetlink_secctx_size(const struct nf_conn *ct)
+static int ctnetlink_secctx_size(const struct nf_conn *ct)
 {
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
 	int len, ret;
@@ -584,8 +569,7 @@ ctnetlink_secctx_size(const struct nf_conn *ct)
 #endif
 }
 
-static inline size_t
-ctnetlink_timestamp_size(const struct nf_conn *ct)
+static size_t ctnetlink_timestamp_size(const struct nf_conn *ct)
 {
 #ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
 	if (!nf_ct_ext_exist(ct, NF_CT_EXT_TSTAMP))
@@ -596,8 +580,7 @@ ctnetlink_timestamp_size(const struct nf_conn *ct)
 #endif
 }
 
-static inline size_t
-ctnetlink_nlmsg_size(const struct nf_conn *ct)
+static size_t ctnetlink_nlmsg_size(const struct nf_conn *ct)
 {
 	return NLMSG_ALIGN(sizeof(struct nfgenmsg))
 	       + 3 * nla_total_size(0) /* CTA_TUPLE_ORIG|REPL|MASTER */
@@ -891,8 +874,8 @@ out:
 	return skb->len;
 }
 
-static inline int
-ctnetlink_parse_tuple_ip(struct nlattr *attr, struct nf_conntrack_tuple *tuple)
+static int ctnetlink_parse_tuple_ip(struct nlattr *attr,
+				    struct nf_conntrack_tuple *tuple)
 {
 	struct nlattr *tb[CTA_IP_MAX+1];
 	struct nf_conntrack_l3proto *l3proto;
@@ -921,9 +904,8 @@ static const struct nla_policy proto_nla_policy[CTA_PROTO_MAX+1] = {
 	[CTA_PROTO_NUM]	= { .type = NLA_U8 },
 };
 
-static inline int
-ctnetlink_parse_tuple_proto(struct nlattr *attr,
-			    struct nf_conntrack_tuple *tuple)
+static int ctnetlink_parse_tuple_proto(struct nlattr *attr,
+				       struct nf_conntrack_tuple *tuple)
 {
 	struct nlattr *tb[CTA_PROTO_MAX+1];
 	struct nf_conntrack_l4proto *l4proto;
@@ -1050,9 +1032,8 @@ static const struct nla_policy help_nla_policy[CTA_HELP_MAX+1] = {
 				    .len = NF_CT_HELPER_NAME_LEN - 1 },
 };
 
-static inline int
-ctnetlink_parse_help(const struct nlattr *attr, char **helper_name,
-		     struct nlattr **helpinfo)
+static int ctnetlink_parse_help(const struct nlattr *attr, char **helper_name,
+				struct nlattr **helpinfo)
 {
 	int err;
 	struct nlattr *tb[CTA_HELP_MAX+1];
@@ -1465,8 +1446,8 @@ ctnetlink_setup_nat(struct nf_conn *ct, const struct nlattr * const cda[])
 #endif
 }
 
-static inline int
-ctnetlink_change_helper(struct nf_conn *ct, const struct nlattr * const cda[])
+static int ctnetlink_change_helper(struct nf_conn *ct,
+				   const struct nlattr * const cda[])
 {
 	struct nf_conntrack_helper *helper;
 	struct nf_conn_help *help = nfct_help(ct);
@@ -1526,8 +1507,8 @@ ctnetlink_change_helper(struct nf_conn *ct, const struct nlattr * const cda[])
 	return -EOPNOTSUPP;
 }
 
-static inline int
-ctnetlink_change_timeout(struct nf_conn *ct, const struct nlattr * const cda[])
+static int ctnetlink_change_timeout(struct nf_conn *ct,
+				    const struct nlattr * const cda[])
 {
 	u_int32_t timeout = ntohl(nla_get_be32(cda[CTA_TIMEOUT]));
 
@@ -1546,8 +1527,8 @@ static const struct nla_policy protoinfo_policy[CTA_PROTOINFO_MAX+1] = {
 	[CTA_PROTOINFO_SCTP]	= { .type = NLA_NESTED },
 };
 
-static inline int
-ctnetlink_change_protoinfo(struct nf_conn *ct, const struct nlattr * const cda[])
+static int ctnetlink_change_protoinfo(struct nf_conn *ct,
+				      const struct nlattr * const cda[])
 {
 	const struct nlattr *attr = cda[CTA_PROTOINFO];
 	struct nlattr *tb[CTA_PROTOINFO_MAX+1];
@@ -1573,8 +1554,8 @@ static const struct nla_policy seqadj_policy[CTA_SEQADJ_MAX+1] = {
 	[CTA_SEQADJ_OFFSET_AFTER]	= { .type = NLA_U32 },
 };
 
-static inline int
-change_seq_adj(struct nf_ct_seqadj *seq, const struct nlattr * const attr)
+static int change_seq_adj(struct nf_ct_seqadj *seq,
+			  const struct nlattr * const attr)
 {
 	int err;
 	struct nlattr *cda[CTA_SEQADJ_MAX+1];
@@ -2409,10 +2390,9 @@ static struct nfq_ct_hook ctnetlink_nfqueue_hook = {
  * EXPECT
  ***********************************************************************/
 
-static inline int
-ctnetlink_exp_dump_tuple(struct sk_buff *skb,
-			 const struct nf_conntrack_tuple *tuple,
-			 enum ctattr_expect type)
+static int ctnetlink_exp_dump_tuple(struct sk_buff *skb,
+				    const struct nf_conntrack_tuple *tuple,
+				    enum ctattr_expect type)
 {
 	struct nlattr *nest_parms;
 
@@ -2429,10 +2409,9 @@ nla_put_failure:
 	return -1;
 }
 
-static inline int
-ctnetlink_exp_dump_mask(struct sk_buff *skb,
-			const struct nf_conntrack_tuple *tuple,
-			const struct nf_conntrack_tuple_mask *mask)
+static int ctnetlink_exp_dump_mask(struct sk_buff *skb,
+				   const struct nf_conntrack_tuple *tuple,
+				   const struct nf_conntrack_tuple_mask *mask)
 {
 	int ret;
 	struct nf_conntrack_l3proto *l3proto;
-- 
2.1.4

