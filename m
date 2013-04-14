From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH nfnetlink_acct v2 1/2] nfnl_acct_new: add packet/byte values
 check
Date: Sun, 14 Apr 2013 10:53:39 +0100
Message-ID: <516A7CA3.1020206@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:36231 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab3DNJx7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Apr 2013 05:53:59 -0400
Received: by mail-lb0-f182.google.com with SMTP id z13so3684948lbh.41
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Apr 2013 02:53:58 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* check that in nfnetlink_acct.c::nfnl_acct_new both packet and byte
  values are specified and return EINVAL if that is not the case

Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 net/netfilter/nfnetlink_acct.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index dc3fd5d..c8d1282 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -45,7 +45,9 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
 	struct nf_acct *nfacct, *matching = NULL;
 	char *acct_name;
 
-	if (!tb[NFACCT_NAME])
+	if (!tb[NFACCT_NAME] ||
+	    (tb[NFACCT_BYTES] && !tb[NFACCT_PKTS]) ||
+	    (!tb[NFACCT_BYTES] && tb[NFACCT_PKTS]))
 		return -EINVAL;
 
 	acct_name = nla_data(tb[NFACCT_NAME]);

