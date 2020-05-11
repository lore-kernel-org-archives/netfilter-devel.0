Return-Path: <SRS0=NFxu=6Z=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA2DCC54E8E
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 May 2020 13:38:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCA0E206B7
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 May 2020 13:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729995AbgEKNid (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 May 2020 09:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729912AbgEKNic (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 May 2020 09:38:32 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79494C061A0C
        for <netfilter-devel@vger.kernel.org>; Mon, 11 May 2020 06:38:32 -0700 (PDT)
Received: from localhost ([::1]:42694 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jY8db-00026a-9v; Mon, 11 May 2020 15:38:31 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/2] nft: Merge nft_*_rule_find() functions
Date:   Mon, 11 May 2020 15:38:16 +0200
Message-Id: <20200511133817.11106-1-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Both ebtables and arptables are fine with using nft_ipv46_rule_find()
instead of their own implementations. Take the chance and move the
former into nft.c as a static helper since it is used in a single place,
only. Then get rid of the callback from family_ops.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-arp.c    | 28 ----------------------------
 iptables/nft-bridge.c | 38 --------------------------------------
 iptables/nft-ipv4.c   |  1 -
 iptables/nft-ipv6.c   |  1 -
 iptables/nft-shared.c | 39 ---------------------------------------
 iptables/nft-shared.h |  4 ----
 iptables/nft.c        | 41 ++++++++++++++++++++++++++++++++++++++++-
 7 files changed, 40 insertions(+), 112 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 9a831efd07a28..23ab73cba649e 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -635,33 +635,6 @@ static bool nft_arp_is_same(const void *data_a,
 				  (unsigned char *)b->arp.outiface_mask);
 }
 
-static bool nft_arp_rule_find(struct nft_handle *h, struct nftnl_rule *r,
-			      struct nftnl_rule *rule)
-{
-	struct iptables_command_state _cs = {}, *cs = &_cs;
-	struct iptables_command_state this = {};
-	bool ret = false;
-
-	/* Delete by matching rule case */
-	nft_rule_to_iptables_command_state(h, r, &this);
-	nft_rule_to_iptables_command_state(h, rule, cs);
-
-	if (!nft_arp_is_same(&cs->arp, &this.arp))
-		goto out;
-
-	if (!compare_targets(cs->target, this.target))
-		goto out;
-
-	if (this.jumpto && strcmp(cs->jumpto, this.jumpto) != 0)
-		goto out;
-
-	ret = true;
-out:
-	h->ops->clear_cs(&this);
-	h->ops->clear_cs(cs);
-	return ret;
-}
-
 static void nft_arp_save_chain(const struct nftnl_chain *c, const char *policy)
 {
 	const char *chain = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
@@ -684,6 +657,5 @@ struct nft_family_ops nft_family_ops_arp = {
 	.post_parse		= NULL,
 	.rule_to_cs		= nft_rule_to_iptables_command_state,
 	.clear_cs		= nft_clear_iptables_command_state,
-	.rule_find		= nft_arp_rule_find,
 	.parse_target		= nft_ipv46_parse_target,
 };
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 39a2f704000c7..18f5e78f1b3a2 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -756,43 +756,6 @@ static bool nft_bridge_is_same(const void *data_a, const void *data_b)
 	return strcmp(a->in, b->in) == 0 && strcmp(a->out, b->out) == 0;
 }
 
-static bool nft_bridge_rule_find(struct nft_handle *h, struct nftnl_rule *r,
-				 struct nftnl_rule *rule)
-{
-	struct iptables_command_state _cs = {}, *cs = &_cs;
-	struct iptables_command_state this = {};
-	bool ret = false;
-
-	nft_rule_to_ebtables_command_state(h, r, &this);
-	nft_rule_to_ebtables_command_state(h, rule, cs);
-
-	DEBUGP("comparing with... ");
-
-	if (!nft_bridge_is_same(cs, &this))
-		goto out;
-
-	if (!compare_matches(cs->matches, this.matches)) {
-		DEBUGP("Different matches\n");
-		goto out;
-	}
-
-	if (!compare_targets(cs->target, this.target)) {
-		DEBUGP("Different target\n");
-		goto out;
-	}
-
-	if (cs->jumpto != NULL && strcmp(cs->jumpto, this.jumpto) != 0) {
-		DEBUGP("Different verdict\n");
-		goto out;
-	}
-
-	ret = true;
-out:
-	h->ops->clear_cs(&this);
-	h->ops->clear_cs(cs);
-	return ret;
-}
-
 static int xlate_ebmatches(const struct iptables_command_state *cs, struct xt_xlate *xl)
 {
 	int ret = 1, numeric = cs->options & OPT_NUMERIC;
@@ -974,6 +937,5 @@ struct nft_family_ops nft_family_ops_bridge = {
 	.post_parse		= NULL,
 	.rule_to_cs		= nft_rule_to_ebtables_command_state,
 	.clear_cs		= ebt_cs_clean,
-	.rule_find		= nft_bridge_rule_find,
 	.xlate			= nft_bridge_xlate,
 };
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 69691fe28cf80..ba789da0c5973 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -457,6 +457,5 @@ struct nft_family_ops nft_family_ops_ipv4 = {
 	.parse_target		= nft_ipv46_parse_target,
 	.rule_to_cs		= nft_rule_to_iptables_command_state,
 	.clear_cs		= nft_clear_iptables_command_state,
-	.rule_find		= nft_ipv46_rule_find,
 	.xlate			= nft_ipv4_xlate,
 };
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 76f2613d95c6a..84bcf1c53f48c 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -409,6 +409,5 @@ struct nft_family_ops nft_family_ops_ipv6 = {
 	.parse_target		= nft_ipv46_parse_target,
 	.rule_to_cs		= nft_rule_to_iptables_command_state,
 	.clear_cs		= nft_clear_iptables_command_state,
-	.rule_find		= nft_ipv46_rule_find,
 	.xlate			= nft_ipv6_xlate,
 };
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index bfc7bc2203239..53cd4cae9ef7c 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -989,45 +989,6 @@ void nft_ipv46_parse_target(struct xtables_target *t, void *data)
 	cs->target = t;
 }
 
-bool nft_ipv46_rule_find(struct nft_handle *h, struct nftnl_rule *r,
-			 struct nftnl_rule *rule)
-{
-	struct iptables_command_state _cs = {}, this = {}, *cs = &_cs;
-	bool ret = false;
-
-	nft_rule_to_iptables_command_state(h, r, &this);
-	nft_rule_to_iptables_command_state(h, rule, cs);
-
-	DEBUGP("comparing with... ");
-#ifdef DEBUG_DEL
-	nft_rule_print_save(h, r, NFT_RULE_APPEND, 0);
-#endif
-	if (!h->ops->is_same(cs, &this))
-		goto out;
-
-	if (!compare_matches(cs->matches, this.matches)) {
-		DEBUGP("Different matches\n");
-		goto out;
-	}
-
-	if (!compare_targets(cs->target, this.target)) {
-		DEBUGP("Different target\n");
-		goto out;
-	}
-
-	if ((!cs->target || !this.target) &&
-	    strcmp(cs->jumpto, this.jumpto) != 0) {
-		DEBUGP("Different verdict\n");
-		goto out;
-	}
-
-	ret = true;
-out:
-	h->ops->clear_cs(&this);
-	h->ops->clear_cs(cs);
-	return ret;
-}
-
 void nft_check_xt_legacy(int family, bool is_ipt_save)
 {
 	static const char tables6[] = "/proc/net/ip6_tables_names";
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 89e9d0b9be335..cb60e685872dd 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -109,8 +109,6 @@ struct nft_family_ops {
 	void (*rule_to_cs)(struct nft_handle *h, const struct nftnl_rule *r,
 			   struct iptables_command_state *cs);
 	void (*clear_cs)(struct iptables_command_state *cs);
-	bool (*rule_find)(struct nft_handle *h, struct nftnl_rule *r,
-			  struct nftnl_rule *rule);
 	int (*xlate)(const void *data, struct xt_xlate *xl);
 };
 
@@ -171,8 +169,6 @@ void save_matches_and_target(const struct iptables_command_state *cs,
 struct nft_family_ops *nft_family_ops_lookup(int family);
 
 void nft_ipv46_parse_target(struct xtables_target *t, void *data);
-bool nft_ipv46_rule_find(struct nft_handle *h, struct nftnl_rule *r,
-			 struct nftnl_rule *rule);
 
 bool compare_matches(struct xtables_rule_match *mt1, struct xtables_rule_match *mt2);
 bool compare_targets(struct xtables_target *tg1, struct xtables_target *tg2);
diff --git a/iptables/nft.c b/iptables/nft.c
index 3c0daa8d42529..e65eb91c1c504 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2120,6 +2120,45 @@ static int __nft_rule_del(struct nft_handle *h, struct nftnl_rule *r)
 	return 1;
 }
 
+static bool nft_rule_cmp(struct nft_handle *h, struct nftnl_rule *r,
+			 struct nftnl_rule *rule)
+{
+	struct iptables_command_state _cs = {}, this = {}, *cs = &_cs;
+	bool ret = false;
+
+	h->ops->rule_to_cs(h, r, &this);
+	h->ops->rule_to_cs(h, rule, cs);
+
+	DEBUGP("comparing with... ");
+#ifdef DEBUG_DEL
+	nft_rule_print_save(h, r, NFT_RULE_APPEND, 0);
+#endif
+	if (!h->ops->is_same(cs, &this))
+		goto out;
+
+	if (!compare_matches(cs->matches, this.matches)) {
+		DEBUGP("Different matches\n");
+		goto out;
+	}
+
+	if (!compare_targets(cs->target, this.target)) {
+		DEBUGP("Different target\n");
+		goto out;
+	}
+
+	if ((!cs->target || !this.target) &&
+	    strcmp(cs->jumpto, this.jumpto) != 0) {
+		DEBUGP("Different verdict\n");
+		goto out;
+	}
+
+	ret = true;
+out:
+	h->ops->clear_cs(&this);
+	h->ops->clear_cs(cs);
+	return ret;
+}
+
 static struct nftnl_rule *
 nft_rule_find(struct nft_handle *h, struct nftnl_chain *c,
 	      struct nftnl_rule *rule, int rulenum)
@@ -2138,7 +2177,7 @@ nft_rule_find(struct nft_handle *h, struct nftnl_chain *c,
 
 	r = nftnl_rule_iter_next(iter);
 	while (r != NULL) {
-		found = h->ops->rule_find(h, r, rule);
+		found = nft_rule_cmp(h, r, rule);
 		if (found)
 			break;
 		r = nftnl_rule_iter_next(iter);
-- 
2.25.1

