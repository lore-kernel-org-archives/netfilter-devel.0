From: Ana Rey <anarey@gmail.com>
Subject: [PATCH] iptables-compat: homogenize error messages with 'R' option
Date: Wed,  5 Nov 2014 16:46:34 +0100
Message-ID: <1415202394-11031-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:56496 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbaKEPqk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:46:40 -0500
Received: by mail-wi0-f175.google.com with SMTP id ex7so12801992wid.14
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Nov 2014 07:46:39 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There is a difference between error messages in iptables and
iptables-compat:

 # iptables -R INPUT 23 -s 192.168.2.140 -j ACCEPT
iptables: Index of replacement too big.
 # iptables-compat -R INPUT 23 -s 192.168.2.140 -j ACCEPT
iptables: No chain/target/match by that name.

Now, iptables-compat shows the same error message than iptables in
this case.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 iptables/nft.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 6cb03a0..64222af 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2358,7 +2358,7 @@ const char *nft_strerror(int err)
 	    { nft_chain_user_add, EEXIST, "Chain already exists" },
 	    { nft_rule_add, E2BIG, "Index of insertion too big" },
 	    { nft_rule_check, ENOENT, "Bad rule (does a matching rule exist in that chain?)" },
-	    { nft_rule_replace, E2BIG, "Index of replacement too big" },
+	    { nft_rule_replace, ENOENT, "Index of replacement too big" },
 	    { nft_rule_delete_num, E2BIG, "Index of deletion too big" },
 /*	    { TC_READ_COUNTER, E2BIG, "Index of counter too big" },
 	    { TC_ZERO_COUNTER, E2BIG, "Index of counter too big" }, */
-- 
1.7.10.4

