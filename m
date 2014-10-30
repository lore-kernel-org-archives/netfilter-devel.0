From: Ana Rey <anarey@gmail.com>
Subject: [PATCH] iptables-compat: homogenize error messages
Date: Thu, 30 Oct 2014 09:31:56 +0100
Message-ID: <1414657916-21718-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:41787 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbaJ3Ibs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Oct 2014 04:31:48 -0400
Received: by mail-wg0-f43.google.com with SMTP id y10so675550wgg.16
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2014 01:31:47 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There are some differences between error messages in iptables and
iptables-compat:

 # iptables -C INPUT -s 192.168.2.102 -j ACCEPT
iptables: Bad rule (does a matching rule exist in that chain?).
 # iptables-compat -C INPUT -s 192.168.2.102 -j ACCEPT
iptables: No chain/target/match by that name.

 # iptables -N new_chain
 # iptables -N new_chain
iptables: Chain already exists.
 # iptables-compat -N new_chain
 # iptables-compat -N new_chain
iptables: File exists.

Now, iptables-compat shows the same error messages than iptables in
those cases.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 iptables/nft.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/iptables/nft.c b/iptables/nft.c
index ac72bfa..1a2c438 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1298,6 +1298,8 @@ int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *tabl
 	struct nft_chain *c;
 	int ret;
 
+	nft_fn = nft_chain_user_add;
+
 	/* If built-in chains don't exist for this table, create them */
 	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
 		nft_xt_builtin_init(h, table);
@@ -2344,10 +2346,12 @@ const char *nft_strerror(int err)
 	  {
 	    { nft_chain_user_del, ENOTEMPTY, "Chain is not empty" },
 	    { nft_chain_user_del, EINVAL, "Can't delete built-in chain" },
+	    { nft_chain_user_del, EBUSY, "Directory not empty" },
 	    { nft_chain_user_del, EMLINK,
 	      "Can't delete chain with references left" },
 	    { nft_chain_user_add, EEXIST, "Chain already exists" },
 	    { nft_rule_add, E2BIG, "Index of insertion too big" },
+	    { nft_rule_check, ENOENT, "Bad rule (does a matching rule exist in that chain?)" },
 	    { nft_rule_replace, E2BIG, "Index of replacement too big" },
 	    { nft_rule_delete_num, E2BIG, "Index of deletion too big" },
 /*	    { TC_READ_COUNTER, E2BIG, "Index of counter too big" },
-- 
1.7.10.4

