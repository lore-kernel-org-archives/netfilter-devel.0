From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [iptables PATCH] nft: replace nft_rule_attr_get_u8
Date: Mon, 24 Mar 2014 11:59:46 +0100
Message-ID: <1395658786-3862-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:60551 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaCXK6z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Mar 2014 06:58:55 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so4321726eei.0
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Mar 2014 03:58:54 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since the family declaration has been modified in libnftnl,
from commit 3cd9cd06625f8181c713489cec2c1ce6722a7e16
the assertion is failed for {ip,ip6,arp}tables-compat
when printing rules.

iptables-compat -L
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
libnftnl: attribute 0 assertion failed in rule.c:273

ip6tables-compat -L
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
libnftnl: attribute 0 assertion failed in rule.c:273

arptables-compat -L
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
libnftnl: attribute 0 assertion failed in rule.c:273

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft-arp.c        | 2 +-
 iptables/nft-shared.c     | 2 +-
 iptables/nft.c            | 2 +-
 iptables/xtables-events.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index a494ee6..5d44caf 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -369,7 +369,7 @@ void nft_rule_to_arpt_entry(struct nft_rule *r, struct arpt_entry *fw)
 {
 	struct nft_rule_expr_iter *iter;
 	struct nft_rule_expr *expr;
-	int family = nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY);
+	int family = nft_rule_attr_get_u32(r, NFT_RULE_ATTR_FAMILY);
 
 	iter = nft_rule_expr_iter_create(r);
 	if (iter == NULL)
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index d59abd4..395a4cc 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -458,7 +458,7 @@ void nft_rule_to_iptables_command_state(struct nft_rule *r,
 {
 	struct nft_rule_expr_iter *iter;
 	struct nft_rule_expr *expr;
-	int family = nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY);
+	int family = nft_rule_attr_get_u32(r, NFT_RULE_ATTR_FAMILY);
 
 	iter = nft_rule_expr_iter_create(r);
 	if (iter == NULL)
diff --git a/iptables/nft.c b/iptables/nft.c
index 8bb5c64..26942d8 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1045,7 +1045,7 @@ nft_rule_print_save(const void *data,
 		    unsigned int format)
 {
 	const char *chain = nft_rule_attr_get_str(r, NFT_RULE_ATTR_CHAIN);
-	int family = nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY);
+	int family = nft_rule_attr_get_u32(r, NFT_RULE_ATTR_FAMILY);
 	struct nft_family_ops *ops;
 
 	/* print chain name */
diff --git a/iptables/xtables-events.c b/iptables/xtables-events.c
index 535dd91..552ce56 100644
--- a/iptables/xtables-events.c
+++ b/iptables/xtables-events.c
@@ -75,7 +75,7 @@ static int rule_cb(const struct nlmsghdr *nlh, int type)
 		goto err_free;
 	}
 
-	family = nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY);
+	family = nft_rule_attr_get_u32(r, NFT_RULE_ATTR_FAMILY);
 	switch (family) {
 	case AF_INET:
 	case AF_INET6:
-- 
1.8.3.2

