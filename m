From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [PATCH 2/3] nft-shared: make compare_matches as public
Date: Wed,  1 Oct 2014 16:47:09 +0200
Message-ID: <1412174830-3620-2-git-send-email-giuseppelng@gmail.com>
References: <1412174830-3620-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:38993 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaJAOnM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:43:12 -0400
Received: by mail-wi0-f171.google.com with SMTP id ho1so845666wib.4
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Oct 2014 07:43:11 -0700 (PDT)
In-Reply-To: <1412174830-3620-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This permits to compare two xtables_ebt_entry's matches reusing compare_matches.

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft-shared.c | 4 ++--
 iptables/nft-shared.h | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 03f15b4..db1424f 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -720,8 +720,8 @@ struct nft_family_ops *nft_family_ops_lookup(int family)
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
index ecb486c..789aaeb 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -134,6 +134,7 @@ struct nft_handle;
 bool nft_ipv46_rule_find(struct nft_family_ops *ops, struct nft_rule *r,
 			 struct iptables_command_state *cs);
 
+bool compare_matches(struct xtables_rule_match *mt1, struct xtables_rule_match *mt2);
 bool compare_targets(struct xtables_target *tg1, struct xtables_target *tg2);
 
 struct addr_mask {
-- 
1.8.3.2

