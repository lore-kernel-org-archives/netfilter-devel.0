From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [iptables-compat PATCH 2/3] nft-shared: make compare_matches as public
Date: Fri, 22 Aug 2014 11:29:14 +0200
Message-ID: <1408699755-17785-3-git-send-email-giuseppelng@gmail.com>
References: <1408699755-17785-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:63735 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023AbaHVJZj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Aug 2014 05:25:39 -0400
Received: by mail-wg0-f46.google.com with SMTP id m15so10204336wgh.29
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Aug 2014 02:25:38 -0700 (PDT)
In-Reply-To: <1408699755-17785-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This permits to compare two xtables_ebt_entry's matches reusing compare_matches.

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft-shared.c | 4 ++--
 iptables/nft-shared.h | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 6b1381c..4045a03 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -708,8 +708,8 @@ struct nft_family_ops *nft_family_ops_lookup(int family)
 	return NULL;
 }
 
-static bool
-compare_matches(struct xtables_rule_match *mt1, struct xtables_rule_match *mt2)
+bool compare_matches(struct xtables_rule_match *mt1,
+		     struct xtables_rule_match *mt2)
 {
 	struct xtables_rule_match *mp1;
 	struct xtables_rule_match *mp2;
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 3f7fa19..ec69d0c 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -130,6 +130,7 @@ struct nft_handle;
 bool nft_ipv46_rule_find(struct nft_family_ops *ops, struct nft_rule *r,
 			 struct iptables_command_state *cs);
 
+bool compare_matches(struct xtables_rule_match *mt1, struct xtables_rule_match *mt2);
 bool compare_targets(struct xtables_target *tg1, struct xtables_target *tg2);
 
 struct addr_mask {
-- 
1.8.3.2

