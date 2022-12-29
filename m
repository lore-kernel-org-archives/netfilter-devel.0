Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE079C3DA79
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Dec 2022 16:35:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233335AbiL2QfW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Dec 2022 11:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233476AbiL2QfT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Dec 2022 11:35:19 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F55311C26
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Dec 2022 08:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=szYfgaJSL7/lRHiZKa4OTMcLChpn2iPfLlMB9IzVyBA=; b=qxkGofjfk8cqRuRg6LAXwhuR6v
        mwYA0yltc/8qCK6+OANbGkWYb7hZSJW0T5lUp9IwL7aj/hN3XgJIHyiRaEaa00jukFWjOeoZmf+4h
        WcSpAmK6+8cAh5m7Jwb7QTih6F3twSgBgtmuQ6C2nbmmmLWZrvNjzPwPTQlHm47A7kaRAtHrglk7x
        ZebQ7s3ETpZaquz0Rzbi46UX/vU+knINFs6d+E4Ljm8GSBkLthvvDOYBkYZPTw+EX6s5HZbepLZa0
        ByRpdf8e8o6PX+Bij5lLZYf2Zx8Fg7yKuMCeUZAJFGeLx4g7evc8CiYZ6yyngV9Tdh2YYAfpUJPBw
        exjFxRkw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pAvsA-00D08G-Eq
        for netfilter-devel@vger.kernel.org; Thu, 29 Dec 2022 16:35:14 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 3/3] build: support for Linux 6.2
Date:   Thu, 29 Dec 2022 16:35:07 +0000
Message-Id: <20221229163507.352888-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221229163507.352888-1-jeremy@azazel.net>
References: <20221229163507.352888-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

`prandom_u32_max` was deprecated in favour of `get_random_u32_below`,
and removed in 6.2-rc1.  Replace the three occurrences of it in the
TARPIT extension, and ad compat support for earlier kernels.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac                | 2 +-
 extensions/compat_xtables.h | 4 ++++
 extensions/xt_TARPIT.c      | 6 +++---
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/configure.ac b/configure.ac
index d582ca8e92d0..a13988ff4a4b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -58,7 +58,7 @@ AS_IF([test -n "$kbuilddir"], [
 		yoff
 	], [
 		echo "$kmajor.$kminor.$kmicro.$kstable in $kbuilddir";
-		if test "$kmajor" -gt 6 -o "$kmajor" -eq 6 -a "$kminor" -gt 1; then
+		if test "$kmajor" -gt 6 -o "$kmajor" -eq 6 -a "$kminor" -gt 2; then
 			yon
 			echo "WARNING: That kernel version is not officially supported yet. Continue at own luck.";
 			yoff
diff --git a/extensions/compat_xtables.h b/extensions/compat_xtables.h
index 1feea880057d..848d3bff50d8 100644
--- a/extensions/compat_xtables.h
+++ b/extensions/compat_xtables.h
@@ -48,4 +48,8 @@ static inline struct net *par_net(const struct xt_action_param *par)
 #	define proc_release release
 #endif
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(6, 2, 0)
+#	define get_random_u32_below prandom_u32_max
+#endif
+
 extern void *HX_memmem(const void *, size_t, const void *, size_t);
diff --git a/extensions/xt_TARPIT.c b/extensions/xt_TARPIT.c
index 22e61255f5ca..c3875bc0f47f 100644
--- a/extensions/xt_TARPIT.c
+++ b/extensions/xt_TARPIT.c
@@ -107,8 +107,8 @@ static bool xttarpit_honeypot(struct tcphdr *tcph, const struct tcphdr *oth,
 		tcph->syn     = true;
 		tcph->ack     = true;
 		tcph->window  = oth->window &
-			(prandom_u32_max(0x20) - 0xf);
-		tcph->seq     = htonl(prandom_u32_max(~oth->seq + 1));
+			(get_random_u32_below(0x20) - 0xf);
+		tcph->seq     = htonl(get_random_u32_below(~oth->seq + 1));
 		tcph->ack_seq = htonl(ntohl(oth->seq) + oth->syn);
 	}
 
@@ -117,7 +117,7 @@ static bool xttarpit_honeypot(struct tcphdr *tcph, const struct tcphdr *oth,
 		tcph->syn     = false;
 		tcph->ack     = true;
 		tcph->window  = oth->window &
-			(prandom_u32_max(0x20) - 0xf);
+			(get_random_u32_below(0x20) - 0xf);
 		tcph->ack_seq = payload > 100 ?
 			htonl(ntohl(oth->seq) + payload) :
 			oth->seq;
-- 
2.39.0

