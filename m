From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH v3 kernel 16/29] add permanent byte/packet format capability to nfacct
Date: Wed, 10 Jul 2013 19:25:14 +0100
Message-ID: <1373480727-11254-17-git-send-email-michael.zintakis@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:60504 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab3GJS0W (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:26:22 -0400
Received: by mail-la0-f46.google.com with SMTP id eg20so6113643lab.33
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 11:26:20 -0700 (PDT)
In-Reply-To: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* add a 'fmt' variable to each nfacct object, allowing a permanent packets
and bytes formatting to be stored. The two packet and byte formats are
independent of each other.

Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 include/uapi/linux/netfilter/nfnetlink_acct.h |  1 +
 net/netfilter/nfnetlink_acct.c                | 28 +++++++++++++++++++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nfnetlink_acct.h b/include/uapi/linux/netfilter/nfnetlink_acct.h
index c7b6269..0b65f9c1 100644
--- a/include/uapi/linux/netfilter/nfnetlink_acct.h
+++ b/include/uapi/linux/netfilter/nfnetlink_acct.h
@@ -19,6 +19,7 @@ enum nfnl_acct_type {
 	NFACCT_PKTS,
 	NFACCT_BYTES,
 	NFACCT_USE,
+	NFACCT_FMT,
 	__NFACCT_MAX
 };
 #define NFACCT_MAX (__NFACCT_MAX - 1)
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index c14046c..92ecad1 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -32,6 +32,7 @@ static LIST_HEAD(nfnl_acct_list);
 struct nf_acct {
 	atomic64_t		pkts;
 	atomic64_t		bytes;
+	u16			fmt;
 	struct list_head	head;
 	atomic_t		refcnt;
 	char			name[NFACCT_NAME_MAX];
@@ -74,8 +75,26 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
 				atomic64_set(&matching->bytes,
 				be64_to_cpu(nla_get_be64(tb[NFACCT_BYTES])));
 			} else {
-				atomic64_set(&matching->pkts, 0);
-				atomic64_set(&matching->bytes, 0);
+				/*
+				 * Prevent resetting the packet & byte counters
+				 * if any other parameters are specified.
+				 *
+				 * This is done for backward compatibility,
+				 * otherwise resetting these counters should
+				 * only be allowed when tb[NFACCT_PKTS] and
+				 * tb[NFACCT_BYTES] are explicitly specified
+				 * and == 0.
+				 *
+				 */
+				if (!tb[NFACCT_FMT]) {
+					atomic64_set(&matching->pkts, 0);
+					atomic64_set(&matching->bytes, 0);
+				}
+			}
+			/* ...and change the format... */
+			if (tb[NFACCT_FMT]) {
+				matching->fmt =
+				be16_to_cpu(nla_get_be16(tb[NFACCT_FMT]));
 			}
 			return 0;
 		}
@@ -96,6 +115,9 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
 		atomic64_set(&nfacct->pkts,
 			     be64_to_cpu(nla_get_be64(tb[NFACCT_PKTS])));
 	}
+	if (tb[NFACCT_FMT]) {
+		nfacct->fmt = be16_to_cpu(nla_get_be16(tb[NFACCT_FMT]));
+	}
 	atomic_set(&nfacct->refcnt, 1);
 	list_add_tail_rcu(&nfacct->head, &nfnl_acct_list);
 	return 0;
@@ -132,6 +154,7 @@ nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	}
 	if (nla_put_be64(skb, NFACCT_PKTS, cpu_to_be64(pkts)) ||
 	    nla_put_be64(skb, NFACCT_BYTES, cpu_to_be64(bytes)) ||
+	    nla_put_be16(skb, NFACCT_FMT, htons(acct->fmt)) ||
 	    nla_put_be32(skb, NFACCT_USE, htonl(atomic_read(&acct->refcnt))))
 		goto nla_put_failure;
 
@@ -279,6 +302,7 @@ static const struct nla_policy nfnl_acct_policy[NFACCT_MAX+1] = {
 	[NFACCT_NAME] = { .type = NLA_NUL_STRING, .len = NFACCT_NAME_MAX-1 },
 	[NFACCT_BYTES] = { .type = NLA_U64 },
 	[NFACCT_PKTS] = { .type = NLA_U64 },
+	[NFACCT_FMT] = { .type = NLA_U16 },
 };
 
 static const struct nfnl_callback nfnl_acct_cb[NFNL_MSG_ACCT_MAX] = {
-- 
1.8.3.1

