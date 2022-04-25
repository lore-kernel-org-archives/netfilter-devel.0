Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5896FC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Apr 2022 13:16:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236216AbiDYNTJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Apr 2022 09:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234947AbiDYNTI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Apr 2022 09:19:08 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D978B17E0A
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2022 06:16:04 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1niyZP-00045k-05; Mon, 25 Apr 2022 15:16:03 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/4] netfilter: conntrack: add nf_conntrack_events autodetect mode
Date:   Mon, 25 Apr 2022 15:15:43 +0200
Message-Id: <20220425131544.27860-4-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220425131544.27860-1-fw@strlen.de>
References: <20220425131544.27860-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This adds the new nf_conntrack_events=2 mode and makes it the
default.

This leverages the earlier flag in struct net to allow to avoid
the event extension as long as no event listener is active in
the namespace.

This avoids, for most cases, allocation of ct->ext area.
A followup patch will take further advantage of this by avoiding
calls down into the event framework if the extension isn't present.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../networking/nf_conntrack-sysctl.rst        |  5 +++-
 net/netfilter/nf_conntrack_core.c             |  3 ++-
 net/netfilter/nf_conntrack_ecache.c           | 27 ++++++++++++++-----
 net/netfilter/nf_conntrack_standalone.c       |  2 +-
 4 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index 311128abb768..834945ebc4cd 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -34,10 +34,13 @@ nf_conntrack_count - INTEGER (read-only)
 
 nf_conntrack_events - BOOLEAN
 	- 0 - disabled
-	- not 0 - enabled (default)
+	- 1 - enabled
+	- 2 - auto (default)
 
 	If this option is enabled, the connection tracking code will
 	provide userspace with connection tracking events via ctnetlink.
+	The default allocates the extension if a userspace program is
+	listening to ctnetlink events.
 
 nf_conntrack_expect_max - INTEGER
 	Maximum size of expectation table.  Default value is
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index b3b1cc77ee0b..e7eeac4372df 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1739,7 +1739,8 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	ecache = tmpl ? nf_ct_ecache_find(tmpl) : NULL;
 
-	if (!nf_ct_ecache_ext_add(ct, ecache ? ecache->ctmask : 0,
+	if ((ecache || net->ct.sysctl_events) &&
+	    !nf_ct_ecache_ext_add(ct, ecache ? ecache->ctmask : 0,
 				  ecache ? ecache->expmask : 0,
 				  GFP_ATOMIC)) {
 		nf_conntrack_free(ct);
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 0ed4cf2464c9..cfcb7d12c5ea 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -303,12 +303,27 @@ bool nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask, gfp_t gfp
 	struct net *net = nf_ct_net(ct);
 	struct nf_conntrack_ecache *e;
 
-	if (!ctmask && !expmask && net->ct.sysctl_events) {
-		ctmask = ~0;
-		expmask = ~0;
+	switch (net->ct.sysctl_events) {
+	case 0:
+		 /* assignment via template / ruleset? ignore sysctl. */
+		if (ctmask || expmask)
+			break;
+		return true;
+	case 2: /* autodetect: no event listener, don't allocate extension. */
+		if (!READ_ONCE(net->ct.ctnetlink_has_listener))
+			return true;
+		fallthrough;
+	case 1:
+		/* always allocate an extension. */
+		if (!ctmask && !expmask) {
+			ctmask = ~0;
+			expmask = ~0;
+		}
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return true;
 	}
-	if (!ctmask && !expmask)
-		return false;
 
 	e = nf_ct_ext_add(ct, NF_CT_EXT_ECACHE, gfp);
 	if (e) {
@@ -320,7 +335,7 @@ bool nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask, gfp_t gfp
 }
 EXPORT_SYMBOL_GPL(nf_ct_ecache_ext_add);
 
-#define NF_CT_EVENTS_DEFAULT 1
+#define NF_CT_EVENTS_DEFAULT 2
 static int nf_ct_events __read_mostly = NF_CT_EVENTS_DEFAULT;
 
 void nf_conntrack_ecache_pernet_init(struct net *net)
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 3e1afd10a9b6..948884deaca5 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -693,7 +693,7 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dou8vec_minmax,
 		.extra1 	= SYSCTL_ZERO,
-		.extra2 	= SYSCTL_ONE,
+		.extra2		= SYSCTL_TWO,
 	},
 #endif
 #ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
-- 
2.35.1

