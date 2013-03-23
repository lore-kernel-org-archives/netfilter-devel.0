From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH 1/3 nfnetlink_acct] numerous changes and improvements to the
 kernel code
Date: Sat, 23 Mar 2013 12:17:09 +0000
Message-ID: <514D9D45.6090804@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:39175 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3CWMRc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Mar 2013 08:17:32 -0400
Received: by mail-la0-f42.google.com with SMTP id fe20so8891592lab.1
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Mar 2013 05:17:30 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following is a first patch of a series of 3 patches dealing with the
following kernel changes to nfnetlink_acct:

* fmt and bthr (format and bytes threshold) properties have been added to
  the nfacct object.

* ability to change all nfacct object properties (with the exception of
  name) has been added.

* as a result of the above, a full save/restore is now possible, even if
  the accounting object is in use by iptables.

Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 include/uapi/linux/netfilter/nfnetlink_acct.h |    2 +
 net/netfilter/nfnetlink_acct.c                |   63 ++++++++++++++++++++++++-
 2 files changed, 64 insertions(+), 1 deletion(-)

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
index 589d686..bcd4ae8 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -32,6 +32,8 @@ static LIST_HEAD(nfnl_acct_list);
 struct nf_acct {
 	atomic64_t		pkts;
 	atomic64_t		bytes;
+	atomic64_t		bthr;
+	atomic_t		fmt;
 	struct list_head	head;
 	atomic_t		refcnt;
 	char			name[NFACCT_NAME_MAX];
@@ -63,9 +65,55 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
 
 	if (matching) {
 		if (nlh->nlmsg_flags & NLM_F_REPLACE) {
-			/* reset counters if you request a replacement. */
+			/* reset counters if you request a replacement */
+			if (!tb[NFACCT_PKTS]) {
+				/*
+				 * Prevent resetting the packets counter if
+				 * either fmt or bthr are specified.
+				 *
+				 * This is done for backward compatibility,
+				 * otherwise resetting these counters should
+				 * only be allowed when tb[NFACCT_PKTS] is
+				 * explicitly specified and == 0.
+				 *
+				 */
+				if (!tb[NFACCT_FMT] &&
+				    !tb[NFACCT_BTHR]) {
 			atomic64_set(&matching->pkts, 0);
+				}
+			} else {
+				atomic64_set(&matching->pkts,
+				be64_to_cpu(nla_get_be64(tb[NFACCT_PKTS])));
+			}
+			if (!tb[NFACCT_BYTES]) {
+				/*
+				 * Prevent resetting the packets counter if
+				 * either fmt or bthr are specified.
+				 *
+				 * This is done for backward compatibility,
+				 * otherwise resetting these counters should
+				 * only be allowed when tb[NFACCT_BYTES] is
+				 * explicitly specified and == 0.
+				 *
+				 */
+				if (!tb[NFACCT_FMT] &&
+				    !tb[NFACCT_BTHR]) {
 			atomic64_set(&matching->bytes, 0);
+				}
+			} else {
+				atomic64_set(&matching->bytes,
+				be64_to_cpu(nla_get_be64(tb[NFACCT_BYTES])));
+			}
+			/* ...and change the format... */
+			if (tb[NFACCT_FMT]) {
+				atomic_set(&matching->fmt,
+				be32_to_cpu(nla_get_be32(tb[NFACCT_FMT])));
+			}
+			/* ... as well as the bytes threshold */
+			if (tb[NFACCT_BTHR]) {
+				atomic64_set(&matching->bthr,
+				be64_to_cpu(nla_get_be64(tb[NFACCT_BTHR])));
+			}
 			return 0;
 		}
 		return -EBUSY;
@@ -85,6 +133,14 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
 		atomic64_set(&nfacct->pkts,
 			     be64_to_cpu(nla_get_be64(tb[NFACCT_PKTS])));
 	}
+	if (tb[NFACCT_FMT]) {
+		atomic_set(&nfacct->fmt,
+			   be32_to_cpu(nla_get_be32(tb[NFACCT_FMT])));
+	}
+	if (tb[NFACCT_BTHR]) {
+		atomic64_set(&nfacct->bthr,
+			     be64_to_cpu(nla_get_be64(tb[NFACCT_BTHR])));
+	}
 	atomic_set(&nfacct->refcnt, 1);
 	list_add_tail_rcu(&nfacct->head, &nfnl_acct_list);
 	return 0;
@@ -121,6 +177,9 @@ nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	}
 	if (nla_put_be64(skb, NFACCT_PKTS, cpu_to_be64(pkts)) ||
 	    nla_put_be64(skb, NFACCT_BYTES, cpu_to_be64(bytes)) ||
+	    nla_put_be64(skb, NFACCT_BTHR,
+			 cpu_to_be64(atomic64_read(&acct->bthr))) ||
+	    nla_put_be32(skb, NFACCT_FMT, htonl(atomic_read(&acct->fmt))) ||
 	    nla_put_be32(skb, NFACCT_USE, htonl(atomic_read(&acct->refcnt))))
 		goto nla_put_failure;
 
@@ -265,6 +324,8 @@ static const struct nla_policy nfnl_acct_policy[NFACCT_MAX+1] = {
 	[NFACCT_NAME] = { .type = NLA_NUL_STRING, .len = NFACCT_NAME_MAX-1 },
 	[NFACCT_BYTES] = { .type = NLA_U64 },
 	[NFACCT_PKTS] = { .type = NLA_U64 },
+	[NFACCT_BTHR] = { .type = NLA_U64 },
+	[NFACCT_FMT] = { .type = NLA_U32 },
 };
 
 static const struct nfnl_callback nfnl_acct_cb[NFNL_MSG_ACCT_MAX] = {


