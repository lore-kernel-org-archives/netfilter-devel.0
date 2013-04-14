From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH nfnetlink_acct v2 2/2] add fmt & bthr properties to nfacct
Date: Sun, 14 Apr 2013 10:54:03 +0100
Message-ID: <516A7CBB.3010407@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:52853 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab3DNJyQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Apr 2013 05:54:16 -0400
Received: by mail-lb0-f172.google.com with SMTP id u10so3778317lbi.17
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Apr 2013 02:54:14 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* fmt and bthr (format and bytes threshold) properties have been added to
  the nfacct object.

* ability to change all nfacct object properties (with the exception of
  name) has been added.

Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 include/uapi/linux/netfilter/nfnetlink_acct.h |    2 +
 net/netfilter/nfnetlink_acct.c                |   49 +++++++++++++++++++++++--
 2 files changed, 48 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/netfilter/nfnetlink_acct.h b/include/uapi/linux/netfilter/nfnetlink_acct.h
index c7b6269..f07e825 100644
--- a/include/uapi/linux/netfilter/nfnetlink_acct.h
+++ b/include/uapi/linux/netfilter/nfnetlink_acct.h
@@ -18,6 +18,8 @@ enum nfnl_acct_type {
 	NFACCT_NAME,
 	NFACCT_PKTS,
 	NFACCT_BYTES,
+	NFACCT_BTHR,
+	NFACCT_FMT,
 	NFACCT_USE,
 	__NFACCT_MAX
 };
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index c8d1282..cd69d85 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -32,6 +32,8 @@ static LIST_HEAD(nfnl_acct_list);
 struct nf_acct {
 	atomic64_t		pkts;
 	atomic64_t		bytes;
+	u64			bthr;
+	u32			fmt;
 	struct list_head	head;
 	atomic_t		refcnt;
 	char			name[NFACCT_NAME_MAX];
@@ -67,9 +69,39 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
 
 	if (matching) {
 		if (nlh->nlmsg_flags & NLM_F_REPLACE) {
-			/* reset counters if you request a replacement. */
-			atomic64_set(&matching->pkts, 0);
-			atomic64_set(&matching->bytes, 0);
+			/* (re)set counters if you request a replacement */
+			if (tb[NFACCT_PKTS] && tb[NFACCT_BYTES]) {
+				atomic64_set(&matching->pkts,
+				be64_to_cpu(nla_get_be64(tb[NFACCT_PKTS])));
+				atomic64_set(&matching->bytes,
+				be64_to_cpu(nla_get_be64(tb[NFACCT_BYTES])));
+			} else {
+				/*
+				 * Prevent resetting the packet & byte counters
+				 * if either fmt or bthr are specified.
+				 *
+				 * This is done for backward compatibility,
+				 * otherwise resetting these counters should
+				 * only be allowed when tb[NFACCT_PKTS] and
+				 * tb[NFACCT_BYTES] are explicitly specified
+				 * and == 0.
+				 *
+				 */
+				if (!tb[NFACCT_FMT] && !tb[NFACCT_BTHR]) {
+					atomic64_set(&matching->pkts, 0);
+					atomic64_set(&matching->bytes, 0);
+				}
+			}
+			/* ...and change the format... */
+			if (tb[NFACCT_FMT]) {
+				matching->fmt =
+				be32_to_cpu(nla_get_be32(tb[NFACCT_FMT]));
+			}
+			/* ... as well as the bytes threshold */
+			if (tb[NFACCT_BTHR]) {
+				matching->bthr =
+				be64_to_cpu(nla_get_be64(tb[NFACCT_BTHR]));
+			}
 			return 0;
 		}
 		return -EBUSY;
@@ -89,6 +121,13 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
 		atomic64_set(&nfacct->pkts,
 			     be64_to_cpu(nla_get_be64(tb[NFACCT_PKTS])));
 	}
+
+	if (tb[NFACCT_FMT])
+		nfacct->fmt = be32_to_cpu(nla_get_be32(tb[NFACCT_FMT]));
+
+	if (tb[NFACCT_BTHR])
+		nfacct->bthr = be64_to_cpu(nla_get_be64(tb[NFACCT_BTHR]));
+
 	atomic_set(&nfacct->refcnt, 1);
 	list_add_tail_rcu(&nfacct->head, &nfnl_acct_list);
 	return 0;
@@ -125,6 +164,8 @@ nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	}
 	if (nla_put_be64(skb, NFACCT_PKTS, cpu_to_be64(pkts)) ||
 	    nla_put_be64(skb, NFACCT_BYTES, cpu_to_be64(bytes)) ||
+	    nla_put_be64(skb, NFACCT_BTHR, cpu_to_be64(acct->bthr)) ||
+	    nla_put_be32(skb, NFACCT_FMT, htonl(acct->fmt)) ||
 	    nla_put_be32(skb, NFACCT_USE, htonl(atomic_read(&acct->refcnt))))
 		goto nla_put_failure;
 
@@ -269,6 +310,8 @@ static const struct nla_policy nfnl_acct_policy[NFACCT_MAX+1] = {
 	[NFACCT_NAME] = { .type = NLA_NUL_STRING, .len = NFACCT_NAME_MAX-1 },
 	[NFACCT_BYTES] = { .type = NLA_U64 },
 	[NFACCT_PKTS] = { .type = NLA_U64 },
+	[NFACCT_BTHR] = { .type = NLA_U64 },
+	[NFACCT_FMT] = { .type = NLA_U32 },
 };
 
 static const struct nfnl_callback nfnl_acct_cb[NFNL_MSG_ACCT_MAX] = {

