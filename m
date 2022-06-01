Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80FBECCA468
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Jun 2022 13:48:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353300AbiFANsI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Jun 2022 09:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242256AbiFANsH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Jun 2022 09:48:07 -0400
X-Greylist: delayed 58542 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 01 Jun 2022 06:48:05 PDT
Received: from mail1.systemli.org (mail1.systemli.org [93.190.126.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E5F48E53
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2022 06:48:05 -0700 (PDT)
From:   Nick Hainke <vincent@systemli.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1654091281;
        bh=4VJm2xH/OX33gjkkv9Rks5/zxx5Tr1fOZsu/8Cp6gVw=;
        h=From:To:Cc:Subject:Date:From;
        b=fz80rA4dvPSNDGqikSmGIX3KUr2S1bibjFWdeadLlWA53pCwsnuqEhonEihm8uVH+
         8mFOzpfyKT8e404KLZMuxfQoVs3ZAuff68nmnpEymAMvsMsiCQcpueDrCMxfMZS9dE
         NEwOseoPMF0q0wE393zw2uHuQCtYUQ+7g5xeSs7vot5ffOn7vE/BHhr67fJJt5DPOl
         Kpyv4t8jNg4jd0RG4EaSMwF+BJoB/06g6D7RFG9COyCPiUjgjuteIZ0+gua/0gMZgm
         YRyC4b+miSL6ONLSfzMoqdTIu4+39D3kaIN9YHe0XXKzlnnEi5/SyggD8zMWCF07UM
         k8KxPNex6Pn5Q==
To:     netfilter-devel@vger.kernel.org
Cc:     Nick Hainke <vincent@systemli.org>
Subject: [PATCH] Revert "Simplify static build extension loading"
Date:   Wed,  1 Jun 2022 15:47:43 +0200
Message-Id: <20220601134743.14415-1-vincent@systemli.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This reverts commit 6c689b639cf8e2aeced8685eca2915892d76ad86.

The stubs broke the libiptext used in firewall3 by OpenWrt.

Signed-off-by: Nick Hainke <vincent@systemli.org>
---
 include/xtables.h               | 7 -------
 iptables/ip6tables-standalone.c | 3 +++
 iptables/iptables-restore.c     | 4 ++++
 iptables/iptables-save.c        | 4 ++++
 iptables/iptables-standalone.c  | 2 ++
 iptables/xtables-arp.c          | 4 +++-
 iptables/xtables-eb.c           | 4 +++-
 iptables/xtables-monitor.c      | 2 ++
 iptables/xtables-restore.c      | 2 ++
 iptables/xtables-save.c         | 2 ++
 iptables/xtables-standalone.c   | 2 ++
 iptables/xtables-translate.c    | 2 ++
 12 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/include/xtables.h b/include/xtables.h
index c2694b7b..b0965b95 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -597,13 +597,6 @@ static inline void xtables_print_mark_mask(unsigned int mark,
 	extern void init_extensionsb(void);
 #else
 #	define _init __attribute__((constructor)) _INIT
-#	define EMPTY_FUNC_DEF(x) static inline void x(void) {}
-	EMPTY_FUNC_DEF(init_extensions)
-	EMPTY_FUNC_DEF(init_extensions4)
-	EMPTY_FUNC_DEF(init_extensions6)
-	EMPTY_FUNC_DEF(init_extensionsa)
-	EMPTY_FUNC_DEF(init_extensionsb)
-#	undef EMPTY_FUNC_DEF
 #endif
 
 extern const struct xtables_pprot xtables_chain_protos[];
diff --git a/iptables/ip6tables-standalone.c b/iptables/ip6tables-standalone.c
index 7c8bb0c2..105b83ba 100644
--- a/iptables/ip6tables-standalone.c
+++ b/iptables/ip6tables-standalone.c
@@ -52,8 +52,11 @@ ip6tables_main(int argc, char *argv[])
 				ip6tables_globals.program_version);
 		exit(1);
 	}
+
+#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensions();
 	init_extensions6();
+#endif
 
 	ret = do_command6(argc, argv, &table, &handle, false);
 	if (ret) {
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 4410a587..4cf0d3da 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -384,8 +384,10 @@ iptables_restore_main(int argc, char *argv[])
 				iptables_globals.program_version);
 		exit(1);
 	}
+#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensions();
 	init_extensions4();
+#endif
 
 	ret = ip46tables_restore_main(&ipt_restore_cb, argc, argv);
 
@@ -416,8 +418,10 @@ ip6tables_restore_main(int argc, char *argv[])
 				ip6tables_globals.program_version);
 		exit(1);
 	}
+#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensions();
 	init_extensions6();
+#endif
 
 	ret = ip46tables_restore_main(&ip6t_restore_cb, argc, argv);
 
diff --git a/iptables/iptables-save.c b/iptables/iptables-save.c
index a8dded63..a114e98b 100644
--- a/iptables/iptables-save.c
+++ b/iptables/iptables-save.c
@@ -227,8 +227,10 @@ iptables_save_main(int argc, char *argv[])
 				iptables_globals.program_version);
 		exit(1);
 	}
+#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensions();
 	init_extensions4();
+#endif
 
 	ret = do_iptables_save(&ipt_save_cb, argc, argv);
 
@@ -271,8 +273,10 @@ ip6tables_save_main(int argc, char *argv[])
 				ip6tables_globals.program_version);
 		exit(1);
 	}
+#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensions();
 	init_extensions6();
+#endif
 
 	ret = do_iptables_save(&ip6t_save_cb, argc, argv);
 
diff --git a/iptables/iptables-standalone.c b/iptables/iptables-standalone.c
index 0f263f6f..8c67ea4d 100644
--- a/iptables/iptables-standalone.c
+++ b/iptables/iptables-standalone.c
@@ -53,8 +53,10 @@ iptables_main(int argc, char *argv[])
 				iptables_globals.program_version);
 				exit(1);
 	}
+#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensions();
 	init_extensions4();
+#endif
 
 	ret = do_command4(argc, argv, &table, &handle, false);
 	if (ret) {
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 71518a9c..01b8b702 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -99,8 +99,10 @@ int nft_init_arp(struct nft_handle *h, const char *pname)
 			arptables_globals.program_version);
 		exit(1);
 	}
+
+#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensions();
-	init_extensionsa();
+#endif
 
 	if (nft_init(h, NFPROTO_ARP) < 0)
 		xtables_error(OTHER_PROBLEM,
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 3d15063e..429b3cf7 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -667,8 +667,10 @@ int nft_init_eb(struct nft_handle *h, const char *pname)
 			ebtables_globals.program_version);
 		exit(1);
 	}
+
+#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensions();
-	init_extensionsb();
+#endif
 
 	if (nft_init(h, NFPROTO_BRIDGE) < 0)
 		xtables_error(OTHER_PROBLEM,
diff --git a/iptables/xtables-monitor.c b/iptables/xtables-monitor.c
index 905bb7fe..852dc084 100644
--- a/iptables/xtables-monitor.c
+++ b/iptables/xtables-monitor.c
@@ -624,11 +624,13 @@ int xtables_monitor_main(int argc, char *argv[])
 				xtables_globals.program_version);
 		exit(1);
 	}
+#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensions();
 	init_extensions4();
 	init_extensions6();
 	init_extensionsa();
 	init_extensionsb();
+#endif
 
 	if (nft_init(&h, AF_INET)) {
 		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 1363f96a..c99e77bb 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -358,6 +358,7 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 		p.in = stdin;
 	}
 
+#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensions();
 	switch (family) {
 	case NFPROTO_IPV4:
@@ -376,6 +377,7 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 		fprintf(stderr, "Unknown family %d\n", family);
 		return 1;
 	}
+#endif
 
 	if (nft_init(&h, family) < 0) {
 		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 5a82cac5..afe4f833 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -199,6 +199,7 @@ xtables_save_main(int family, int argc, char *argv[],
 		exit(1);
 	}
 
+#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensions();
 	switch (family) {
 	case NFPROTO_IPV4:
@@ -228,6 +229,7 @@ xtables_save_main(int family, int argc, char *argv[],
 		fprintf(stderr, "Unknown family %d\n", family);
 		return 1;
 	}
+#endif
 
 	if (nft_init(&h, family) < 0) {
 		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
diff --git a/iptables/xtables-standalone.c b/iptables/xtables-standalone.c
index 117b0c69..cdb60603 100644
--- a/iptables/xtables-standalone.c
+++ b/iptables/xtables-standalone.c
@@ -67,6 +67,7 @@ xtables_main(int family, const char *progname, int argc, char *argv[])
 		exit(1);
 	}
 	xt_params->program_name = progname;
+#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensions();
 	switch (family) {
 	case NFPROTO_IPV4:
@@ -82,6 +83,7 @@ xtables_main(int family, const char *progname, int argc, char *argv[])
 		init_extensionsb();
 		break;
 	}
+#endif
 
 	if (nft_init(&h, family) < 0) {
 		fprintf(stderr, "%s: Failed to initialize nft: %s\n",
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index d1e87f16..18edf22f 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -485,6 +485,7 @@ static int xtables_xlate_main_common(struct nft_handle *h,
 			xtables_globals.program_version);
 		return 1;
 	}
+#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensions();
 	switch (family) {
 	case NFPROTO_IPV4:
@@ -503,6 +504,7 @@ static int xtables_xlate_main_common(struct nft_handle *h,
 		fprintf(stderr, "Unknown family %d\n", family);
 		return 1;
 	}
+#endif
 
 	if (nft_init(h, family) < 0) {
 		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
-- 
2.36.1

