Return-Path: <SRS0=c7vx=XW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4874C4360C
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Sep 2019 14:05:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2863217D7
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Sep 2019 14:05:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfI0OFW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Sep 2019 10:05:22 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:50018 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbfI0OFW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Sep 2019 10:05:22 -0400
Received: from localhost ([::1]:34876 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iDqs5-0006wS-65; Fri, 27 Sep 2019 16:05:21 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 02/12] nft: family_ops: Pass nft_handle to 'rule_find' callback
Date:   Fri, 27 Sep 2019 16:04:23 +0200
Message-Id: <20190927140433.9504-3-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190927140433.9504-1-phil@nwl.cc>
References: <20190927140433.9504-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In order to prepare for rules containing set references, nft handle has
to be passed to nft_rule_to_iptables_command_state() in order to let it
access the set in cache.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-arp.c    | 4 ++--
 iptables/nft-bridge.c | 4 ++--
 iptables/nft-shared.c | 7 +++----
 iptables/nft-shared.h | 4 ++--
 iptables/nft.c        | 2 +-
 5 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index d9a5f861eecb1..78bcc3b4b6ffc 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -655,7 +655,7 @@ static bool nft_arp_is_same(const void *data_a,
 				  (unsigned char *)b->arp.outiface_mask);
 }
 
-static bool nft_arp_rule_find(struct nft_family_ops *ops, struct nftnl_rule *r,
+static bool nft_arp_rule_find(struct nft_handle *h, struct nftnl_rule *r,
 			      void *data)
 {
 	const struct iptables_command_state *cs = data;
@@ -676,7 +676,7 @@ static bool nft_arp_rule_find(struct nft_family_ops *ops, struct nftnl_rule *r,
 
 	ret = true;
 out:
-	ops->clear_cs(&this);
+	h->ops->clear_cs(&this);
 	return ret;
 }
 
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 0fc21b3a3c0d6..73bca2f38101e 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -537,7 +537,7 @@ static bool nft_bridge_is_same(const void *data_a, const void *data_b)
 	return strcmp(a->in, b->in) == 0 && strcmp(a->out, b->out) == 0;
 }
 
-static bool nft_bridge_rule_find(struct nft_family_ops *ops, struct nftnl_rule *r,
+static bool nft_bridge_rule_find(struct nft_handle *h, struct nftnl_rule *r,
 				 void *data)
 {
 	struct iptables_command_state *cs = data;
@@ -568,7 +568,7 @@ static bool nft_bridge_rule_find(struct nft_family_ops *ops, struct nftnl_rule *
 
 	ret = true;
 out:
-	ops->clear_cs(&this);
+	h->ops->clear_cs(&this);
 	return ret;
 }
 
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 6fd8ade5a1e59..b6d85f1af1da9 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -982,8 +982,7 @@ void nft_ipv46_parse_target(struct xtables_target *t, void *data)
 	cs->target = t;
 }
 
-bool nft_ipv46_rule_find(struct nft_family_ops *ops,
-			 struct nftnl_rule *r, void *data)
+bool nft_ipv46_rule_find(struct nft_handle *h, struct nftnl_rule *r, void *data)
 {
 	struct iptables_command_state *cs = data, this = {};
 	bool ret = false;
@@ -994,7 +993,7 @@ bool nft_ipv46_rule_find(struct nft_family_ops *ops,
 #ifdef DEBUG_DEL
 	nft_rule_print_save(r, NFT_RULE_APPEND, 0);
 #endif
-	if (!ops->is_same(cs, &this))
+	if (!h->ops->is_same(cs, &this))
 		goto out;
 
 	if (!compare_matches(cs->matches, this.matches)) {
@@ -1014,7 +1013,7 @@ bool nft_ipv46_rule_find(struct nft_family_ops *ops,
 
 	ret = true;
 out:
-	ops->clear_cs(&this);
+	h->ops->clear_cs(&this);
 	return ret;
 }
 
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 0d0b3dff2b4d4..9b51a39d23f16 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -104,7 +104,7 @@ struct nft_family_ops {
 	void (*rule_to_cs)(const struct nftnl_rule *r,
 			   struct iptables_command_state *cs);
 	void (*clear_cs)(struct iptables_command_state *cs);
-	bool (*rule_find)(struct nft_family_ops *ops, struct nftnl_rule *r,
+	bool (*rule_find)(struct nft_handle *h, struct nftnl_rule *r,
 			  void *data);
 	int (*xlate)(const void *data, struct xt_xlate *xl);
 };
@@ -165,7 +165,7 @@ void save_matches_and_target(const struct iptables_command_state *cs,
 struct nft_family_ops *nft_family_ops_lookup(int family);
 
 void nft_ipv46_parse_target(struct xtables_target *t, void *data);
-bool nft_ipv46_rule_find(struct nft_family_ops *ops, struct nftnl_rule *r,
+bool nft_ipv46_rule_find(struct nft_handle *h, struct nftnl_rule *r,
 			 void *data);
 
 bool compare_matches(struct xtables_rule_match *mt1, struct xtables_rule_match *mt2);
diff --git a/iptables/nft.c b/iptables/nft.c
index 34a93d7e79c7c..b877f9aaf6dee 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2336,7 +2336,7 @@ nft_rule_find(struct nft_handle *h, struct nftnl_chain *c, void *data, int rulen
 
 	r = nftnl_rule_iter_next(iter);
 	while (r != NULL) {
-		found = h->ops->rule_find(h->ops, r, data);
+		found = h->ops->rule_find(h, r, data);
 		if (found)
 			break;
 		r = nftnl_rule_iter_next(iter);
-- 
2.23.0

