From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables PATCH 1/3] xtables: arp: Store target entry properly and compare them relevantly
Date: Thu,  3 Oct 2013 12:52:55 +0300
Message-ID: <1380793977-9730-2-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1380793977-9730-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:10353 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab3JCJxF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Oct 2013 05:53:05 -0400
In-Reply-To: <1380793977-9730-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fixes a segfault issue when deleting a rule.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft-arp.c     | 44 +++++++++++++++++++++-----------------------
 iptables/nft-shared.h  |  4 ++--
 iptables/xtables-arp.c |  8 ++++----
 3 files changed, 27 insertions(+), 29 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 10c7b63..0460066 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -276,17 +276,16 @@ static void nft_arp_parse_meta(struct nft_rule_expr *e, uint8_t key,
 	fw->arp.invflags |= ipt_to_arpt_flags(flags);
 }
 
-static void nft_arp_parse_target(struct xtables_target *t, void *data)
+static void nft_arp_parse_target(struct xtables_target *target, void *data)
 {
 	struct arpt_entry *fw = data;
-	size_t size = sizeof(struct arpt_entry);
-	struct xt_entry_target **target;
+	struct xt_entry_target **t;
 
-	fw->target_offset = size;
-	fw->next_offset = size + t->t->u.target_size;
+	fw->target_offset = offsetof(struct arpt_entry, elems);
+	fw->next_offset = fw->target_offset + target->t->u.target_size;
 
-	target = (void *) fw + fw->target_offset;
-	*target = t->t;
+	t = (void *) &fw->elems;
+	*t = target->t;
 }
 
 static void nft_arp_parse_immediate(const char *jumpto, bool nft_goto,
@@ -297,10 +296,13 @@ static void nft_arp_parse_immediate(const char *jumpto, bool nft_goto,
 
 	target = xtables_find_target(XT_STANDARD_TARGET,
 				     XTF_LOAD_MUST_SUCCEED);
-	size = sizeof(struct xt_entry_target) + target->size;
+
+	size = XT_ALIGN(sizeof(struct xt_entry_target)) + target->size;
+
 	target->t = xtables_calloc(1, size);
 	target->t->u.target_size = size;
 	strcpy(target->t->u.user.name, jumpto);
+	target->t->u.user.revision = target->revision;
 
 	nft_arp_parse_target(target, data);
 }
@@ -598,16 +600,11 @@ static bool nft_arp_rule_find(struct nft_family_ops *ops, struct nft_rule *r,
 	struct arpt_entry *fw = data;
 	struct xt_entry_target *t_fw, *t_this;
 	char *targname_fw, *targname_this;
-	struct xtables_target *target_fw, *target_this;
 	struct arpt_entry this = {};
 
 	/* Delete by matching rule case */
 	nft_rule_to_arpt_entry(r, &this);
 
-	DEBUGP("comparing with... ");
-
-/*	nft_rule_print_save(&this, r, NFT_RULE_APPEND, 0); */
-
 	if (!ops->is_same(fw, &this))
 		return false;
 
@@ -617,19 +614,20 @@ static bool nft_arp_rule_find(struct nft_family_ops *ops, struct nft_rule *r,
 	targname_fw = t_fw->u.user.name;
 	targname_this = t_this->u.user.name;
 
-	target_fw = xtables_find_target(targname_fw, XTF_TRY_LOAD);
-	target_this = xtables_find_target(targname_this, XTF_TRY_LOAD);
-
-	if (target_fw != NULL && target_this != NULL) {
-		if (!compare_targets(target_fw, target_this)) {
+	if (!strcmp(targname_fw, targname_this) &&
+	    (!strcmp(targname_fw, "mangle") ||
+	    !strcmp(targname_fw, "CLASSIFY"))) {
+		if (memcmp(t_fw->data, t_this->data,
+		    t_fw->u.user.target_size - sizeof(*t_fw)) != 0) {
 			DEBUGP("Different target\n");
 			return false;
 		}
-	} else {
-		if (strcmp(targname_fw, targname_this) != 0) {
-			DEBUGP("Different verdict\n");
-			return false;
-		}
+		return true;
+	}
+
+	if (strcmp(targname_fw, targname_this) != 0) {
+		DEBUGP("Different verdict\n");
+		return false;
 	}
 
 	return true;
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 3d1f433..7260fdd 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -178,11 +178,11 @@ extern char *opcodes[];
 
 #include <linux/netfilter_arp/arp_tables.h>
 
-static inline struct xt_entry_target *nft_arp_get_target(struct arpt_entry *fw) 
+static inline struct xt_entry_target *nft_arp_get_target(struct arpt_entry *fw)
 {
 	struct xt_entry_target **target;
 
-	target = (void *) fw + fw->target_offset;
+	target = (void *) &fw->elems;
 
 	return *target;
 }
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 407fb06..8072d90 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -819,12 +819,12 @@ generate_entry(const struct arpt_entry *fw,
 
 	size = sizeof(struct arpt_entry);
 
-	e = xtables_malloc(size + target->u.target_size);
+	e = xtables_malloc(size);
 	*e = *fw;
-	e->target_offset = size;
-	e->next_offset = size + target->u.target_size;
+	e->target_offset = offsetof(struct arpt_entry, elems);
+	e->next_offset = e->target_offset + target->u.target_size;
 
-	t = (void *) e + e->target_offset;
+	t = (void *) &e->elems;
 	*t = target;
 
 	return e;
-- 
1.8.3.2

