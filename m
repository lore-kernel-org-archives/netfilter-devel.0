From: Eric Leblond <eric@regit.org>
Subject: [libnftables PATCH 4/4] rule: change type of function to use const
Date: Sat,  6 Jul 2013 17:33:16 +0200
Message-ID: <1373124796-6810-4-git-send-email-eric@regit.org>
References: <1373124677-6626-1-git-send-email-eric@regit.org>
 <1373124796-6810-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:59763 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab3GFPdu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Jul 2013 11:33:50 -0400
In-Reply-To: <1373124796-6810-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The function nft_rule_attr_is_set() is doing no modification so it
is possible to type it to const.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/libnftables/rule.h | 2 +-
 src/rule.c                 | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
index ab61eb8..5496561 100644
--- a/include/libnftables/rule.h
+++ b/include/libnftables/rule.h
@@ -26,7 +26,7 @@ enum {
 };
 
 void nft_rule_attr_unset(struct nft_rule *r, uint16_t attr);
-bool nft_rule_attr_is_set(struct nft_rule *r, uint16_t attr);
+bool nft_rule_attr_is_set(const struct nft_rule *r, uint16_t attr);
 void nft_rule_attr_set(struct nft_rule *r, uint16_t attr, const void *data);
 void nft_rule_attr_set_u32(struct nft_rule *r, uint16_t attr, uint32_t val);
 void nft_rule_attr_set_u64(struct nft_rule *r, uint16_t attr, uint64_t val);
diff --git a/src/rule.c b/src/rule.c
index 9dc82b8..dc98a8f 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -73,7 +73,7 @@ void nft_rule_free(struct nft_rule *r)
 }
 EXPORT_SYMBOL(nft_rule_free);
 
-bool nft_rule_attr_is_set(struct nft_rule *r, uint16_t attr)
+bool nft_rule_attr_is_set(const struct nft_rule *r, uint16_t attr)
 {
 	return r->flags & (1 << attr);
 }
-- 
1.8.3.2

