Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F021C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Jun 2022 18:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237441AbiFBSY1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Jun 2022 14:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237363AbiFBSY0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Jun 2022 14:24:26 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FA58720F
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2022 11:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YCDzxrPJXnfEJ5TbPH72OW70xIfViV4fVolMFQ8h6PM=; b=LAOMsI7WrZSIM8p3gNqzhdreJX
        zUYpepQzeG71vdKy6QUsdRaW8atu1XjYNlzxEFaCYZA/tyXYU7wjv+QZI0Lzn7UU4W2KQ8JgFetZQ
        EXauFDx7uoJ2xJXZbO5eI/ZRzG66UrWpAzYYEJ6uLjnTsCHvz0/60NLFEt7tEP91xerUyyauwgQ79
        tEtEj/Gc7frYs3/axl2nMn75+Vh1XuUAnPMy+mmubT5EWOj8WcC4yz7gRleYF7Qp4I94jHoQdVLG8
        tPqQDPFG1jvr2dzBZmwVqadzU9TONUkcv4kuhoGSp8RyIi9Was1WFlFbg0tEStC+BJq8n5YRwGfyC
        TWPreiBg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nwpUa-0004Hj-Ub; Thu, 02 Jun 2022 20:24:20 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Nick <vincent@systemli.org>, Jan Engelhardt <jengelh@inai.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables PATCH] libxtables: Unexport init_extensions*() declarations
Date:   Thu,  2 Jun 2022 20:24:12 +0200
Message-Id: <20220602182412.4630-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The functions are used for static builds to initialize extensions after
libxtables init. Regular library users should not need them, but the
empty declarations introduced in #else case (and therefore present in
user's env) may clash with existing symbol names.

Avoid problems and guard the whole block declaring the function
prototypes and mangling extensions' _init functions by XTABLES_INTERNAL.

Reported-by: Nick <vincent@systemli.org>
Fixes: 6c689b639cf8e ("Simplify static build extension loading")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/xtables.h | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/include/xtables.h b/include/xtables.h
index c2694b7b28886..f1937f3ea0530 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -585,27 +585,6 @@ static inline void xtables_print_mark_mask(unsigned int mark,
 	xtables_print_val_mask(mark, mask, NULL);
 }
 
-#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
-#	ifdef _INIT
-#		undef _init
-#		define _init _INIT
-#	endif
-	extern void init_extensions(void);
-	extern void init_extensions4(void);
-	extern void init_extensions6(void);
-	extern void init_extensionsa(void);
-	extern void init_extensionsb(void);
-#else
-#	define _init __attribute__((constructor)) _INIT
-#	define EMPTY_FUNC_DEF(x) static inline void x(void) {}
-	EMPTY_FUNC_DEF(init_extensions)
-	EMPTY_FUNC_DEF(init_extensions4)
-	EMPTY_FUNC_DEF(init_extensions6)
-	EMPTY_FUNC_DEF(init_extensionsa)
-	EMPTY_FUNC_DEF(init_extensionsb)
-#	undef EMPTY_FUNC_DEF
-#endif
-
 extern const struct xtables_pprot xtables_chain_protos[];
 extern uint16_t xtables_parse_protocol(const char *s);
 
@@ -663,9 +642,30 @@ void xtables_announce_chain(const char *name);
 #		define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
 #	endif
 
+#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
+#	ifdef _INIT
+#		undef _init
+#		define _init _INIT
+#	endif
+	extern void init_extensions(void);
+	extern void init_extensions4(void);
+	extern void init_extensions6(void);
+	extern void init_extensionsa(void);
+	extern void init_extensionsb(void);
+#else
+#	define _init __attribute__((constructor)) _INIT
+#	define EMPTY_FUNC_DEF(x) static inline void x(void) {}
+	EMPTY_FUNC_DEF(init_extensions)
+	EMPTY_FUNC_DEF(init_extensions4)
+	EMPTY_FUNC_DEF(init_extensions6)
+	EMPTY_FUNC_DEF(init_extensionsa)
+	EMPTY_FUNC_DEF(init_extensionsb)
+#	undef EMPTY_FUNC_DEF
+#endif
+
 extern void _init(void);
 
-#endif
+#endif /* XTABLES_INTERNAL */
 
 #ifdef __cplusplus
 } /* extern "C" */
-- 
2.34.1

