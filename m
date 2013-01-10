From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [libnftables PATCH] rule: Add a function to get rule's family
Date: Thu, 10 Jan 2013 16:29:05 +0200
Message-ID: <1357828145-18588-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:33322 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033Ab3AJO3J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2013 09:29:09 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/libnftables/rule.h | 2 ++
 src/libnftables.map        | 1 +
 src/rule.c                 | 6 ++++++
 3 files changed, 9 insertions(+)

diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
index a944c00..310262a 100644
--- a/include/libnftables/rule.h
+++ b/include/libnftables/rule.h
@@ -28,6 +28,8 @@ void *nft_rule_attr_get(struct nft_rule *r, uint16_t attr);
 const char *nft_rule_attr_get_str(struct nft_rule *r, uint16_t attr);
 uint64_t nft_rule_attr_get_u64(struct nft_rule *r, uint16_t attr);
 
+uint8_t nft_rule_get_family(struct nft_rule *r);
+
 void nft_rule_add_expr(struct nft_rule *r, struct nft_rule_expr *expr);
 
 void nft_rule_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_rule *t);
diff --git a/src/libnftables.map b/src/libnftables.map
index a62f200..3dad5fa 100644
--- a/src/libnftables.map
+++ b/src/libnftables.map
@@ -47,6 +47,7 @@ global:
   nft_rule_attr_get;
   nft_rule_attr_get_u64;
   nft_rule_attr_get_str;
+  nft_rule_get_family;
   nft_rule_snprintf;
   nft_rule_nlmsg_build_hdr;
   nft_rule_nlmsg_build_payload;
diff --git a/src/rule.c b/src/rule.c
index dd05412..0bbeeb2 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -140,6 +140,12 @@ uint64_t nft_rule_attr_get_u64(struct nft_rule *r, uint16_t attr)
 }
 EXPORT_SYMBOL(nft_rule_attr_get_u64);
 
+uint8_t nft_rule_get_family(struct nft_rule *r)
+{
+	return r->family;
+}
+EXPORT_SYMBOL(nft_rule_get_family);
+
 struct nlmsghdr *
 nft_rule_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family,
 			  uint16_t type, uint32_t seq)
-- 
1.8.0.2

