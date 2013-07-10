From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH v3 kernel 2/29] bugfix: restore pkts/bytes counters in NLM_F_REPLACE
Date: Wed, 10 Jul 2013 19:25:00 +0100
Message-ID: <1373480727-11254-3-git-send-email-michael.zintakis@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:56777 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab3GJSZl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:25:41 -0400
Received: by mail-la0-f48.google.com with SMTP id lx15so5933017lab.7
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 11:25:39 -0700 (PDT)
In-Reply-To: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* allow packet and byte counters to be replaced in NLM_F_REPLACE mode,
allowing 'restore' to function properly

Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 net/netfilter/nfnetlink_acct.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 526abd7..c14046c 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -67,9 +67,16 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
 
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
+				atomic64_set(&matching->pkts, 0);
+				atomic64_set(&matching->bytes, 0);
+			}
 			return 0;
 		}
 		return -EBUSY;
-- 
1.8.3.1

