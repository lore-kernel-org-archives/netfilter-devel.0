From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [iptables 3/3] nft-shared: make compare_matches as public
Date: Fri,  7 Mar 2014 20:33:25 +0100
Message-ID: <1394220805-18021-4-git-send-email-giuseppelng@gmail.com>
References: <1394220805-18021-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:45587 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbaCGTcs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 14:32:48 -0500
Received: by mail-ea0-f179.google.com with SMTP id q10so2513165ead.24
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Mar 2014 11:32:47 -0800 (PST)
In-Reply-To: <1394220805-18021-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This permits to compare two xtables_ebt_entry's matches reusing compare_matches.

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft-shared.c | 4 ++--
 iptables/nft-shared.h | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index e2bc802..d59abd4 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -690,8 +690,8 @@ struct nft_family_ops *nft_family_ops_lookup(int family)
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
index 145f19d..b80b7c0 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -128,6 +128,7 @@ struct nft_handle;
 bool nft_ipv46_rule_find(struct nft_family_ops *ops, struct nft_rule *r,
 			 struct iptables_command_state *cs);
 
+bool compare_matches(struct xtables_rule_match *mt1, struct xtables_rule_match *mt2);
 bool compare_targets(struct xtables_target *tg1, struct xtables_target *tg2);
 
 struct addr_mask {
-- 
1.8.3.2

