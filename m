Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39F12C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Apr 2022 13:16:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234163AbiDYNTI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Apr 2022 09:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbiDYNTE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Apr 2022 09:19:04 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57CA618371
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2022 06:16:00 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1niyZK-00045b-QO; Mon, 25 Apr 2022 15:15:58 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/4] netfilter: conntrack: un-inline nf_ct_ecache_ext_add
Date:   Mon, 25 Apr 2022 15:15:42 +0200
Message-Id: <20220425131544.27860-3-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220425131544.27860-1-fw@strlen.de>
References: <20220425131544.27860-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Only called when new ct is allocated or the extension isn't present.
This function will be extended, place this in the conntrack module
instead of inlining.

The callers already depend on nf_conntrack module.
Return value is changed to bool, noone used the returned pointer.

Make sure that the core drops the newly allocated conntrack
if the extension is requested but can't be added.
This makes it necessary to ifdef the section, as the stub
always returns false we'd drop every new conntrack if the
the ecache extension is disabled in kconfig.

Add from data path (xt_CT, nft_ct) is unchanged.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_ecache.h | 30 ++++-----------------
 net/netfilter/nf_conntrack_core.c           | 14 +++++++---
 net/netfilter/nf_conntrack_ecache.c         | 22 +++++++++++++++
 3 files changed, 38 insertions(+), 28 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index b57d73785e4d..2e3d58439e34 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -36,31 +36,6 @@ nf_ct_ecache_find(const struct nf_conn *ct)
 #endif
 }
 
-static inline struct nf_conntrack_ecache *
-nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask, gfp_t gfp)
-{
-#ifdef CONFIG_NF_CONNTRACK_EVENTS
-	struct net *net = nf_ct_net(ct);
-	struct nf_conntrack_ecache *e;
-
-	if (!ctmask && !expmask && net->ct.sysctl_events) {
-		ctmask = ~0;
-		expmask = ~0;
-	}
-	if (!ctmask && !expmask)
-		return NULL;
-
-	e = nf_ct_ext_add(ct, NF_CT_EXT_ECACHE, gfp);
-	if (e) {
-		e->ctmask  = ctmask;
-		e->expmask = expmask;
-	}
-	return e;
-#else
-	return NULL;
-#endif
-}
-
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 
 /* This structure is passed to event handler */
@@ -89,6 +64,7 @@ void nf_ct_deliver_cached_events(struct nf_conn *ct);
 int nf_conntrack_eventmask_report(unsigned int eventmask, struct nf_conn *ct,
 				  u32 portid, int report);
 
+bool nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask, gfp_t gfp);
 #else
 
 static inline void nf_ct_deliver_cached_events(const struct nf_conn *ct)
@@ -103,6 +79,10 @@ static inline int nf_conntrack_eventmask_report(unsigned int eventmask,
 	return 0;
 }
 
+static inline bool nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask, gfp_t gfp)
+{
+	return false;
+}
 #endif
 
 static inline void
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 6e59a35a29b9..b3b1cc77ee0b 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1701,7 +1701,9 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 	struct nf_conn *ct;
 	struct nf_conn_help *help;
 	struct nf_conntrack_tuple repl_tuple;
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
 	struct nf_conntrack_ecache *ecache;
+#endif
 	struct nf_conntrack_expect *exp = NULL;
 	const struct nf_conntrack_zone *zone;
 	struct nf_conn_timeout *timeout_ext;
@@ -1734,10 +1736,16 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 	nf_ct_tstamp_ext_add(ct, GFP_ATOMIC);
 	nf_ct_labels_ext_add(ct);
 
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
 	ecache = tmpl ? nf_ct_ecache_find(tmpl) : NULL;
-	nf_ct_ecache_ext_add(ct, ecache ? ecache->ctmask : 0,
-				 ecache ? ecache->expmask : 0,
-			     GFP_ATOMIC);
+
+	if (!nf_ct_ecache_ext_add(ct, ecache ? ecache->ctmask : 0,
+				  ecache ? ecache->expmask : 0,
+				  GFP_ATOMIC)) {
+		nf_conntrack_free(ct);
+		return ERR_PTR(-ENOMEM);
+	}
+#endif
 
 	cnet = nf_ct_pernet(net);
 	if (cnet->expect_count) {
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 0d075161ae3a..0ed4cf2464c9 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -298,6 +298,28 @@ void nf_conntrack_ecache_work(struct net *net, enum nf_ct_ecache_state state)
 	}
 }
 
+bool nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask, gfp_t gfp)
+{
+	struct net *net = nf_ct_net(ct);
+	struct nf_conntrack_ecache *e;
+
+	if (!ctmask && !expmask && net->ct.sysctl_events) {
+		ctmask = ~0;
+		expmask = ~0;
+	}
+	if (!ctmask && !expmask)
+		return false;
+
+	e = nf_ct_ext_add(ct, NF_CT_EXT_ECACHE, gfp);
+	if (e) {
+		e->ctmask  = ctmask;
+		e->expmask = expmask;
+	}
+
+	return e != NULL;
+}
+EXPORT_SYMBOL_GPL(nf_ct_ecache_ext_add);
+
 #define NF_CT_EVENTS_DEFAULT 1
 static int nf_ct_events __read_mostly = NF_CT_EVENTS_DEFAULT;
 
-- 
2.35.1

