Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 897CCC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Mar 2022 13:26:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348649AbiCON15 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Mar 2022 09:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348648AbiCON14 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Mar 2022 09:27:56 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 973833464B
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2022 06:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4cDKYXMGWG/qUUjuQG9/fpyc1xqgnmUp79viVN7475o=; b=kWXUxEhLhYWJdVmShVgKj1zyBD
        58Neg+i9p9dkCbtQ5faVV2g4KLz0/cgDszJJ35Ai2OHLPWmk2thG2xOK1U8IwY5qBJPgVG+N6UmWS
        PuwwG2xjSy6UuYzIbbKs8ESobvgFdk7BvOxIlio/zrMHCPgPWFiP+JalidriAEcO0fqgdvazRCWex
        uaqt89qgnGW+T/m7v62U8MjVhPnxs5p2iFZ3LKvOzKWVidUJWJplsEIr6gClgqddsLhXs/PLArFDg
        ED15tFs9+wbHs0bHEryL1/mQqUTLeSuccoExQhxBZYVGqkGzAWbvRN6QyGn0hknbzLwz9HpJ9ef10
        fyFZVgdg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nU7CE-0000sQ-UG; Tue, 15 Mar 2022 14:26:43 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Etienne <champetier.etienne@gmail.com>
Subject: [iptables PATCH 2/5] Simplify static build extension loading
Date:   Tue, 15 Mar 2022 14:26:16 +0100
Message-Id: <20220315132619.20256-3-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220315132619.20256-1-phil@nwl.cc>
References: <20220315132619.20256-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead of guarding all calls to init_extensions*(), define stubs if not
used.

While at it, also add the missing prototypes for arp- and ebtables
extension initializers.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/xtables.h               | 9 +++++++++
 iptables/ip6tables-standalone.c | 3 ---
 iptables/iptables-restore.c     | 4 ----
 iptables/iptables-save.c        | 4 ----
 iptables/iptables-standalone.c  | 2 --
 iptables/xtables-arp.c          | 3 ---
 iptables/xtables-eb.c           | 3 ---
 iptables/xtables-monitor.c      | 2 --
 iptables/xtables-restore.c      | 2 --
 iptables/xtables-save.c         | 2 --
 iptables/xtables-standalone.c   | 2 --
 iptables/xtables-translate.c    | 2 --
 12 files changed, 9 insertions(+), 29 deletions(-)

diff --git a/include/xtables.h b/include/xtables.h
index ca674c2663eb4..044f191f313cc 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -595,8 +595,17 @@ static inline void xtables_print_mark_mask(unsigned int mark,
 	extern void init_extensions(void);
 	extern void init_extensions4(void);
 	extern void init_extensions6(void);
+	extern void init_extensionsa(void);
+	extern void init_extensionsb(void);
 #else
 #	define _init __attribute__((constructor)) _INIT
+#	define EMPTY_FUNC_DEF(x) static inline void x(void) {}
+	EMPTY_FUNC_DEF(init_extensions)
+	EMPTY_FUNC_DEF(init_extensions4)
+	EMPTY_FUNC_DEF(init_extensions6)
+	EMPTY_FUNC_DEF(init_extensionsa)
+	EMPTY_FUNC_DEF(init_extensionsb)
+#	undef EMPTY_FUNC_DEF
 #endif
 
 extern const struct xtables_pprot xtables_chain_protos[];
diff --git a/iptables/ip6tables-standalone.c b/iptables/ip6tables-standalone.c
index 105b83ba54010..7c8bb0c2748a9 100644
--- a/iptables/ip6tables-standalone.c
+++ b/iptables/ip6tables-standalone.c
@@ -52,11 +52,8 @@ ip6tables_main(int argc, char *argv[])
 				ip6tables_globals.program_version);
 		exit(1);
 	}
-
-#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensions();
 	init_extensions6();
-#endif
 
 	ret = do_command6(argc, argv, &table, &handle, false);
 	if (ret) {
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 1917fb2315665..d8f65ce1335ea 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -383,10 +383,8 @@ iptables_restore_main(int argc, char *argv[])
 				iptables_globals.program_version);
 		exit(1);
 	}
-#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensions();
 	init_extensions4();
-#endif
 
 	ret = ip46tables_restore_main(&ipt_restore_cb, argc, argv);
 
@@ -417,10 +415,8 @@ ip6tables_restore_main(int argc, char *argv[])
 				ip6tables_globals.program_version);
 		exit(1);
 	}
-#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensions();
 	init_extensions6();
-#endif
 
 	ret = ip46tables_restore_main(&ip6t_restore_cb, argc, argv);
 
diff --git a/iptables/iptables-save.c b/iptables/iptables-save.c
index a114e98bb62dc..a8dded639cbad 100644
--- a/iptables/iptables-save.c
+++ b/iptables/iptables-save.c
@@ -227,10 +227,8 @@ iptables_save_main(int argc, char *argv[])
 				iptables_globals.program_version);
 		exit(1);
 	}
-#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensions();
 	init_extensions4();
-#endif
 
 	ret = do_iptables_save(&ipt_save_cb, argc, argv);
 
@@ -273,10 +271,8 @@ ip6tables_save_main(int argc, char *argv[])
 				ip6tables_globals.program_version);
 		exit(1);
 	}
-#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensions();
 	init_extensions6();
-#endif
 
 	ret = do_iptables_save(&ip6t_save_cb, argc, argv);
 
diff --git a/iptables/iptables-standalone.c b/iptables/iptables-standalone.c
index 8c67ea4d9a2fb..0f263f6fd45e4 100644
--- a/iptables/iptables-standalone.c
+++ b/iptables/iptables-standalone.c
@@ -53,10 +53,8 @@ iptables_main(int argc, char *argv[])
 				iptables_globals.program_version);
 				exit(1);
 	}
-#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensions();
 	init_extensions4();
-#endif
 
 	ret = do_command4(argc, argv, &table, &handle, false);
 	if (ret) {
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 805fb19a5f937..9c44cfc2e46f7 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -205,10 +205,7 @@ int nft_init_arp(struct nft_handle *h, const char *pname)
 			arptables_globals.program_version);
 		exit(1);
 	}
-
-#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensionsa();
-#endif
 
 	if (nft_init(h, NFPROTO_ARP) < 0)
 		xtables_error(OTHER_PROBLEM,
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 1e5b50ba5b0ab..dcb707f6a66e2 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -668,10 +668,7 @@ int nft_init_eb(struct nft_handle *h, const char *pname)
 			ebtables_globals.program_version);
 		exit(1);
 	}
-
-#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensionsb();
-#endif
 
 	if (nft_init(h, NFPROTO_BRIDGE) < 0)
 		xtables_error(OTHER_PROBLEM,
diff --git a/iptables/xtables-monitor.c b/iptables/xtables-monitor.c
index 73dc80c24d722..72d5e04bf40bf 100644
--- a/iptables/xtables-monitor.c
+++ b/iptables/xtables-monitor.c
@@ -625,11 +625,9 @@ int xtables_monitor_main(int argc, char *argv[])
 				xtables_globals.program_version);
 		exit(1);
 	}
-#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensions();
 	init_extensions4();
 	init_extensions6();
-#endif
 
 	if (nft_init(&h, AF_INET)) {
 		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 81b25a43c9a04..c6a5ffedc5cb0 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -363,11 +363,9 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 	switch (family) {
 	case NFPROTO_IPV4:
 	case NFPROTO_IPV6: /* fallthough, same table */
-#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 		init_extensions();
 		init_extensions4();
 		init_extensions6();
-#endif
 		break;
 	case NFPROTO_ARP:
 	case NFPROTO_BRIDGE:
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 03d2b980d5371..9bbe8511e7114 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -202,11 +202,9 @@ xtables_save_main(int family, int argc, char *argv[],
 	switch (family) {
 	case NFPROTO_IPV4:
 	case NFPROTO_IPV6: /* fallthough, same table */
-#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 		init_extensions();
 		init_extensions4();
 		init_extensions6();
-#endif
 		d.commit = true;
 		break;
 	case NFPROTO_ARP:
diff --git a/iptables/xtables-standalone.c b/iptables/xtables-standalone.c
index 5482a85689d79..06fedf261d68b 100644
--- a/iptables/xtables-standalone.c
+++ b/iptables/xtables-standalone.c
@@ -67,7 +67,6 @@ xtables_main(int family, const char *progname, int argc, char *argv[])
 		exit(1);
 	}
 	xt_params->program_name = progname;
-#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	switch (family) {
 	case NFPROTO_IPV4:
 	case NFPROTO_IPV6:
@@ -79,7 +78,6 @@ xtables_main(int family, const char *progname, int argc, char *argv[])
 		init_extensionsa();
 		break;
 	}
-#endif
 
 	if (nft_init(&h, family) < 0) {
 		fprintf(stderr, "%s: Failed to initialize nft: %s\n",
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 6a1cdac14a7da..c518433463dea 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -488,11 +488,9 @@ static int xtables_xlate_main_common(struct nft_handle *h,
 	switch (family) {
 	case NFPROTO_IPV4:
 	case NFPROTO_IPV6: /* fallthrough: same table */
-#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensions();
 	init_extensions4();
 	init_extensions6();
-#endif
 		break;
 	case NFPROTO_ARP:
 	case NFPROTO_BRIDGE:
-- 
2.34.1

