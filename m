From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH v3 kernel 19/29] add byte threshold capability to nfacct
Date: Wed, 10 Jul 2013 19:25:17 +0100
Message-ID: <1373480727-11254-20-git-send-email-michael.zintakis@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:64347 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab3GJS0c (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:26:32 -0400
Received: by mail-lb0-f181.google.com with SMTP id w10so5909331lbi.26
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 11:26:31 -0700 (PDT)
In-Reply-To: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* add a 'bthr' variable to each nfacct object, allowing a bytes 'threshold'
to be stored and then reported if/when traffic breaches it.

Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 include/uapi/linux/netfilter/nfnetlink_acct.h |  9 ++++++
 net/netfilter/nfnetlink_acct.c                | 43 ++++++++++++++++++++++++++-
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nfnetlink_acct.h b/include/uapi/linux/netfilter/nfnetlink_acct.h
index 0b65f9c1..e972970 100644
--- a/include/uapi/linux/netfilter/nfnetlink_acct.h
+++ b/include/uapi/linux/netfilter/nfnetlink_acct.h
@@ -19,10 +19,19 @@ enum nfnl_acct_type {
 	NFACCT_PKTS,
 	NFACCT_BYTES,
 	NFACCT_USE,
+	NFACCT_BTHR,
 	NFACCT_FMT,
+	NFACCT_FLAGS,
+	NFACCT_CMD,
 	__NFACCT_MAX
 };
 #define NFACCT_MAX (__NFACCT_MAX - 1)
 
+enum nfnl_acct_flags {
+	NFACCT_FLAG_BIT_BTHR 	= 0,
+	NFACCT_FLAG_BTHR	= (1 << NFACCT_FLAG_BIT_BTHR),
+	NFACCT_FLAG_BIT_MAX	= 1,
+	NFACCT_FLAG_MAX		= (1 << NFACCT_FLAG_BIT_MAX),
+};
 
 #endif /* _UAPI_NFNL_ACCT_H_ */
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 92ecad1..18cd28e 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -32,7 +32,9 @@ static LIST_HEAD(nfnl_acct_list);
 struct nf_acct {
 	atomic64_t		pkts;
 	atomic64_t		bytes;
+	u64			bthr;
 	u16			fmt;
+	u16			flags;
 	struct list_head	head;
 	atomic_t		refcnt;
 	char			name[NFACCT_NAME_MAX];
@@ -44,6 +46,7 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
 	     const struct nlmsghdr *nlh, const struct nlattr * const tb[])
 {
 	struct nf_acct *nfacct, *matching = NULL;
+	unsigned int flags = 0, cmd = 0;
 	char *acct_name;
 
 	if (!tb[NFACCT_NAME] ||
@@ -51,6 +54,21 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
 	    (!tb[NFACCT_BYTES] && tb[NFACCT_PKTS]))
 		return -EINVAL;
 
+	if (tb[NFACCT_CMD]) {
+		if (!tb[NFACCT_FLAGS])
+			return -EINVAL;
+
+		cmd = be16_to_cpu(nla_get_be16(tb[NFACCT_CMD]));
+		flags = be16_to_cpu(nla_get_be16(tb[NFACCT_FLAGS]));
+
+		if (cmd & NFACCT_FLAG_BTHR &&
+		    ((flags & NFACCT_FLAG_BTHR && !tb[NFACCT_BTHR]) ||
+		     (!(flags & NFACCT_FLAG_BTHR) && tb[NFACCT_BTHR])))
+			return -EINVAL;
+
+	} else if (tb[NFACCT_FLAGS])
+		return -EINVAL;
+
 	acct_name = nla_data(tb[NFACCT_NAME]);
 	if (strlen(acct_name) == 0)
 		return -EINVAL;
@@ -86,7 +104,7 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
 				 * and == 0.
 				 *
 				 */
-				if (!tb[NFACCT_FMT]) {
+				if (!tb[NFACCT_FMT] && !cmd) {
 					atomic64_set(&matching->pkts, 0);
 					atomic64_set(&matching->bytes, 0);
 				}
@@ -96,6 +114,17 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
 				matching->fmt =
 				be16_to_cpu(nla_get_be16(tb[NFACCT_FMT]));
 			}
+			/* ... and finally set the bytes threshold */
+			if (cmd & NFACCT_FLAG_BTHR) {
+				if (flags & NFACCT_FLAG_BTHR) {
+					matching->bthr = be64_to_cpu(
+					  nla_get_be64(tb[NFACCT_BTHR]));
+					matching->flags |= NFACCT_FLAG_BTHR;
+				} else {
+					matching->bthr = 0;
+					matching->flags &= ~NFACCT_FLAG_BTHR;
+				}
+			}
 			return 0;
 		}
 		return -EBUSY;
@@ -118,6 +147,13 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
 	if (tb[NFACCT_FMT]) {
 		nfacct->fmt = be16_to_cpu(nla_get_be16(tb[NFACCT_FMT]));
 	}
+	if (cmd & NFACCT_FLAG_BTHR && flags & NFACCT_FLAG_BTHR) {
+		if (tb[NFACCT_BTHR])
+			nfacct->bthr = be64_to_cpu(
+				nla_get_be64(tb[NFACCT_BTHR]));
+
+		nfacct->flags |= flags & NFACCT_FLAG_BTHR;
+	}
 	atomic_set(&nfacct->refcnt, 1);
 	list_add_tail_rcu(&nfacct->head, &nfnl_acct_list);
 	return 0;
@@ -154,7 +190,9 @@ nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	}
 	if (nla_put_be64(skb, NFACCT_PKTS, cpu_to_be64(pkts)) ||
 	    nla_put_be64(skb, NFACCT_BYTES, cpu_to_be64(bytes)) ||
+	    nla_put_be64(skb, NFACCT_BTHR, cpu_to_be64(acct->bthr)) ||
 	    nla_put_be16(skb, NFACCT_FMT, htons(acct->fmt)) ||
+	    nla_put_be16(skb, NFACCT_FLAGS, htons(acct->flags)) ||
 	    nla_put_be32(skb, NFACCT_USE, htonl(atomic_read(&acct->refcnt))))
 		goto nla_put_failure;
 
@@ -302,7 +340,10 @@ static const struct nla_policy nfnl_acct_policy[NFACCT_MAX+1] = {
 	[NFACCT_NAME] = { .type = NLA_NUL_STRING, .len = NFACCT_NAME_MAX-1 },
 	[NFACCT_BYTES] = { .type = NLA_U64 },
 	[NFACCT_PKTS] = { .type = NLA_U64 },
+	[NFACCT_BTHR] = { .type = NLA_U64 },
 	[NFACCT_FMT] = { .type = NLA_U16 },
+	[NFACCT_FLAGS] = { .type = NLA_U16 },
+	[NFACCT_CMD] = { .type = NLA_U16 },
 };
 
 static const struct nfnl_callback nfnl_acct_cb[NFNL_MSG_ACCT_MAX] = {
-- 
1.8.3.1

