Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E206C433B4
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 May 2021 20:30:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E8D461421
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 May 2021 20:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbhEMUbT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 May 2021 16:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbhEMUbS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 May 2021 16:31:18 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CEFC061574
        for <netfilter-devel@vger.kernel.org>; Thu, 13 May 2021 13:30:07 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lhHyA-00037W-Ma; Thu, 13 May 2021 22:30:06 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/2] netfilter: add and use nft_set_do_lookup helper
Date:   Thu, 13 May 2021 22:29:55 +0200
Message-Id: <20210513202956.22709-2-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210513202956.22709-1-fw@strlen.de>
References: <20210513202956.22709-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Followup patch will add a CONFIG_RETPOLINE wrapper to avoid
the ops->lookup() indirection cost for retpoline builds.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables_core.h | 7 +++++++
 net/netfilter/nft_lookup.c             | 4 ++--
 net/netfilter/nft_objref.c             | 4 ++--
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index fd10a7862fdc..5eb699454490 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -88,6 +88,13 @@ extern const struct nft_set_type nft_set_bitmap_type;
 extern const struct nft_set_type nft_set_pipapo_type;
 extern const struct nft_set_type nft_set_pipapo_avx2_type;
 
+static inline bool
+nft_set_do_lookup(const struct net *net, const struct nft_set *set,
+		  const u32 *key, const struct nft_set_ext **ext)
+{
+	return set->ops->lookup(net, set, key, ext);
+}
+
 struct nft_expr;
 struct nft_regs;
 struct nft_pktinfo;
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index a479f8a1270c..1a8581879af5 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -33,8 +33,8 @@ void nft_lookup_eval(const struct nft_expr *expr,
 	const struct net *net = nft_net(pkt);
 	bool found;
 
-	found = set->ops->lookup(net, set, &regs->data[priv->sreg], &ext) ^
-				 priv->invert;
+	found =	nft_set_do_lookup(net, set, &regs->data[priv->sreg], &ext) ^
+				  priv->invert;
 	if (!found) {
 		ext = nft_set_catchall_lookup(net, set);
 		if (!ext) {
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index 7e47edee88ee..94b2327e71dc 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -9,7 +9,7 @@
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
-#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_core.h>
 
 #define nft_objref_priv(expr)	*((struct nft_object **)nft_expr_priv(expr))
 
@@ -110,7 +110,7 @@ static void nft_objref_map_eval(const struct nft_expr *expr,
 	struct nft_object *obj;
 	bool found;
 
-	found = set->ops->lookup(net, set, &regs->data[priv->sreg], &ext);
+	found = nft_set_do_lookup(net, set, &regs->data[priv->sreg], &ext);
 	if (!found) {
 		ext = nft_set_catchall_lookup(net, set);
 		if (!ext) {
-- 
2.26.3

