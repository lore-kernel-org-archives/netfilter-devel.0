Return-Path: <SRS0=SDnU=YX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCBA4CA9EC5
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 17:27:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 876B12087E
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 17:27:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfJ3R1L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Oct 2019 13:27:11 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45108 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726488AbfJ3R1L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Oct 2019 13:27:11 -0400
Received: from localhost ([::1]:58198 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iPrkT-0007li-J6; Wed, 30 Oct 2019 18:27:09 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v3 01/12] nft: family_ops: Pass nft_handle to 'add' callback
Date:   Wed, 30 Oct 2019 18:26:50 +0100
Message-Id: <20191030172701.5892-2-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191030172701.5892-1-phil@nwl.cc>
References: <20191030172701.5892-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In order for add_match() to create anonymous sets when converting
xtables matches it needs access to nft handle. So pass it along from
callers of family ops' add callback.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-arp.c    | 2 +-
 iptables/nft-bridge.c | 5 +++--
 iptables/nft-ipv4.c   | 4 ++--
 iptables/nft-ipv6.c   | 4 ++--
 iptables/nft-shared.h | 4 ++--
 iptables/nft.c        | 5 +++--
 iptables/nft.h        | 2 +-
 7 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 7068f82c5495a..de7743392afa1 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -126,7 +126,7 @@ static bool need_devaddr(struct arpt_devaddr_info *info)
 	return false;
 }
 
-static int nft_arp_add(struct nftnl_rule *r, void *data)
+static int nft_arp_add(struct nft_handle *h, struct nftnl_rule *r, void *data)
 {
 	struct iptables_command_state *cs = data;
 	struct arpt_entry *fw = &cs->arp;
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 2e4b309b86135..0fc21b3a3c0d6 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -126,7 +126,8 @@ static int _add_action(struct nftnl_rule *r, struct iptables_command_state *cs)
 	return add_action(r, cs, false);
 }
 
-static int nft_bridge_add(struct nftnl_rule *r, void *data)
+static int nft_bridge_add(struct nft_handle *h,
+			  struct nftnl_rule *r, void *data)
 {
 	struct iptables_command_state *cs = data;
 	struct ebt_match *iter;
@@ -182,7 +183,7 @@ static int nft_bridge_add(struct nftnl_rule *r, void *data)
 
 	for (iter = cs->match_list; iter; iter = iter->next) {
 		if (iter->ismatch) {
-			if (add_match(r, iter->u.match->m))
+			if (add_match(h, r, iter->u.match->m))
 				break;
 		} else {
 			if (add_target(r, iter->u.watcher->t))
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 4497eb9b9347c..57d1b3c6d2d0c 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -26,7 +26,7 @@
 #include "nft.h"
 #include "nft-shared.h"
 
-static int nft_ipv4_add(struct nftnl_rule *r, void *data)
+static int nft_ipv4_add(struct nft_handle *h, struct nftnl_rule *r, void *data)
 {
 	struct iptables_command_state *cs = data;
 	struct xtables_rule_match *matchp;
@@ -77,7 +77,7 @@ static int nft_ipv4_add(struct nftnl_rule *r, void *data)
 	add_compat(r, cs->fw.ip.proto, cs->fw.ip.invflags & XT_INV_PROTO);
 
 	for (matchp = cs->matches; matchp; matchp = matchp->next) {
-		ret = add_match(r, matchp->match->m);
+		ret = add_match(h, r, matchp->match->m);
 		if (ret < 0)
 			return ret;
 	}
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index cacb1c9e141f2..0e2c4a2946e25 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -25,7 +25,7 @@
 #include "nft.h"
 #include "nft-shared.h"
 
-static int nft_ipv6_add(struct nftnl_rule *r, void *data)
+static int nft_ipv6_add(struct nft_handle *h, struct nftnl_rule *r, void *data)
 {
 	struct iptables_command_state *cs = data;
 	struct xtables_rule_match *matchp;
@@ -66,7 +66,7 @@ static int nft_ipv6_add(struct nftnl_rule *r, void *data)
 	add_compat(r, cs->fw6.ipv6.proto, cs->fw6.ipv6.invflags & XT_INV_PROTO);
 
 	for (matchp = cs->matches; matchp; matchp = matchp->next) {
-		ret = add_match(r, matchp->match->m);
+		ret = add_match(h, r, matchp->match->m);
 		if (ret < 0)
 			return ret;
 	}
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index e236a981119ac..b4a62619c09b6 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -35,6 +35,7 @@
 #define FMT(tab,notab) ((format) & FMT_NOTABLE ? (notab) : (tab))
 
 struct xtables_args;
+struct nft_handle;
 struct xt_xlate;
 
 enum {
@@ -69,7 +70,7 @@ struct nft_xt_ctx {
 };
 
 struct nft_family_ops {
-	int (*add)(struct nftnl_rule *r, void *data);
+	int (*add)(struct nft_handle *h, struct nftnl_rule *r, void *data);
 	bool (*is_same)(const void *data_a,
 			const void *data_b);
 	void (*print_payload)(struct nftnl_expr *e,
@@ -163,7 +164,6 @@ void save_matches_and_target(const struct iptables_command_state *cs,
 
 struct nft_family_ops *nft_family_ops_lookup(int family);
 
-struct nft_handle;
 void nft_ipv46_parse_target(struct xtables_target *t, void *data);
 bool nft_ipv46_rule_find(struct nft_family_ops *ops, struct nftnl_rule *r,
 			 void *data);
diff --git a/iptables/nft.c b/iptables/nft.c
index 3c230c121f8b9..bb0f9dfcd558f 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -930,7 +930,8 @@ static int add_nft_limit(struct nftnl_rule *r, struct xt_entry_match *m)
 	return 0;
 }
 
-int add_match(struct nftnl_rule *r, struct xt_entry_match *m)
+int add_match(struct nft_handle *h,
+	      struct nftnl_rule *r, struct xt_entry_match *m)
 {
 	struct nftnl_expr *expr;
 	int ret;
@@ -1152,7 +1153,7 @@ nft_rule_new(struct nft_handle *h, const char *chain, const char *table,
 	nftnl_rule_set_str(r, NFTNL_RULE_TABLE, table);
 	nftnl_rule_set_str(r, NFTNL_RULE_CHAIN, chain);
 
-	if (h->ops->add(r, data) < 0)
+	if (h->ops->add(h, r, data) < 0)
 		goto err;
 
 	return r;
diff --git a/iptables/nft.h b/iptables/nft.h
index 4b8b3033a56c0..94dc72d88b7db 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -135,7 +135,7 @@ int nft_rule_zero_counters(struct nft_handle *h, const char *chain, const char *
  */
 int add_counters(struct nftnl_rule *r, uint64_t packets, uint64_t bytes);
 int add_verdict(struct nftnl_rule *r, int verdict);
-int add_match(struct nftnl_rule *r, struct xt_entry_match *m);
+int add_match(struct nft_handle *h, struct nftnl_rule *r, struct xt_entry_match *m);
 int add_target(struct nftnl_rule *r, struct xt_entry_target *t);
 int add_jumpto(struct nftnl_rule *r, const char *name, int verdict);
 int add_action(struct nftnl_rule *r, struct iptables_command_state *cs, bool goto_set);
-- 
2.23.0

