From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] bridge: netfilter: fix module autoload in compat case
Date: Wed, 22 Feb 2012 16:14:32 +0100
Message-ID: <1329923672-20054-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:55975 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752120Ab2BVPMg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Feb 2012 10:12:36 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We expected 0 if module doesn't exist, which is no longer the case
(42046e2e45c109ba703993c510401a11f716c8df,
netfilter: x_tables: return -ENOENT for non-existant matches/targets).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 xt_find_match/target could be made static now, but that should
 happen in -next.

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 5864cc4..8aa4ad0 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1893,10 +1893,7 @@ static int compat_mtw_from_user(struct compat_ebt_entry_mwt *mwt,
 
 	switch (compat_mwt) {
 	case EBT_COMPAT_MATCH:
-		match = try_then_request_module(xt_find_match(NFPROTO_BRIDGE,
-						name, 0), "ebt_%s", name);
-		if (match == NULL)
-			return -ENOENT;
+		match = xt_request_find_match(NFPROTO_BRIDGE, name, 0);
 		if (IS_ERR(match))
 			return PTR_ERR(match);
 
@@ -1915,10 +1912,7 @@ static int compat_mtw_from_user(struct compat_ebt_entry_mwt *mwt,
 		break;
 	case EBT_COMPAT_WATCHER: /* fallthrough */
 	case EBT_COMPAT_TARGET:
-		wt = try_then_request_module(xt_find_target(NFPROTO_BRIDGE,
-						name, 0), "ebt_%s", name);
-		if (wt == NULL)
-			return -ENOENT;
+		wt = xt_request_find_target(NFPROTO_BRIDGE, name, 0);
 		if (IS_ERR(wt))
 			return PTR_ERR(wt);
 		off = xt_compat_target_offset(wt);
-- 
1.7.3.4

