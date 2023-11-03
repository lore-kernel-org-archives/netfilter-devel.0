Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87E04C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 16:36:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbjKCQgD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 12:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234355AbjKCQgD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 12:36:03 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A7AFB
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 09:36:00 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qyx9L-0006tW-3w; Fri, 03 Nov 2023 17:35:59 +0100
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables] arptables-nft: remove ARPT_INV flags usage
Date:   Fri,  3 Nov 2023 17:33:22 +0100
Message-ID: <20231103163548.27178-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231103163519.GE8035@breakpoint.cc>
References: <20231103163519.GE8035@breakpoint.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

ARPT_ and IPT_INV flags are not interchangeable, e.g.:
define IPT_INV_SRCDEVADDR	0x0080
define ARPT_INV_SRCDEVADDR	0x0010

as these flags can be tested by libarp_foo.so such checks can yield
incorrect results.

Because arptables-nft uses existing code, e.g. xt_mark, it makes
sense to unify this completely by converting the last users of
ARPT_INV_ constants.

Note that arptables-legacy does not do run-time module loading via
dlopen(). Functionaliy implemented by "extensions" in the
arptables-legacy git tree are built-in, so this doesn't break
arptables-legacy binaries.

Fixes: 44457c080590 ("xtables-arp: Don't use ARPT_INV_*")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libarpt_mangle.c | 4 ++--
 iptables/nft-arp.c          | 2 +-
 iptables/xshared.h          | 4 +++-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/extensions/libarpt_mangle.c b/extensions/libarpt_mangle.c
index 765edf34781f..a846e97ec8f2 100644
--- a/extensions/libarpt_mangle.c
+++ b/extensions/libarpt_mangle.c
@@ -77,7 +77,7 @@ arpmangle_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (e->arp.arhln_mask == 0)
 			xtables_error(PARAMETER_PROBLEM,
 				      "no --h-length defined");
-		if (e->arp.invflags & ARPT_INV_ARPHLN)
+		if (e->arp.invflags & IPT_INV_ARPHLN)
 			xtables_error(PARAMETER_PROBLEM,
 				      "! --h-length not allowed for "
 				      "--mangle-mac-s");
@@ -95,7 +95,7 @@ arpmangle_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (e->arp.arhln_mask == 0)
 			xtables_error(PARAMETER_PROBLEM,
 				      "no --h-length defined");
-		if (e->arp.invflags & ARPT_INV_ARPHLN)
+		if (e->arp.invflags & IPT_INV_ARPHLN)
 			xtables_error(PARAMETER_PROBLEM,
 				      "! hln not allowed for --mangle-mac-d");
 		if (e->arp.arhln != 6)
diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index aed39ebdd516..535dd6b83237 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -490,7 +490,7 @@ static void nft_arp_post_parse(int command,
 					 &args->d.naddrs);
 
 	if ((args->s.naddrs > 1 || args->d.naddrs > 1) &&
-	    (cs->arp.arp.invflags & (ARPT_INV_SRCIP | ARPT_INV_TGTIP)))
+	    (cs->arp.arp.invflags & (IPT_INV_SRCIP | IPT_INV_DSTIP)))
 		xtables_error(PARAMETER_PROBLEM,
 			      "! not allowed with multiple"
 			      " source or destination IP addresses");
diff --git a/iptables/xshared.h b/iptables/xshared.h
index a200e0d620ad..5586385456a4 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -80,7 +80,9 @@ struct xtables_target;
 #define ARPT_OPTSTRING	OPTSTRING_COMMON "R:S::" "h::l:nvx" /* "m:" */
 #define EBT_OPTSTRING	OPTSTRING_COMMON "hv"
 
-/* define invflags which won't collide with IPT ones */
+/* define invflags which won't collide with IPT ones.
+ * arptables-nft does NOT use the legacy ARPT_INV_* defines.
+ */
 #define IPT_INV_SRCDEVADDR	0x0080
 #define IPT_INV_TGTDEVADDR	0x0100
 #define IPT_INV_ARPHLN		0x0200
-- 
2.41.0

