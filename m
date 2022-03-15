Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC7C5C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Mar 2022 13:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238908AbiCON2C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Mar 2022 09:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345854AbiCON2B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Mar 2022 09:28:01 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35CE45AFB
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2022 06:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vyhzT+RkqU7CkBwPMS7SDdap8c+4zOHqOUsmCxDb+Rw=; b=R5f62UQr7KB8PT/i0MVTZmqdol
        Gen6oXiMC60EHNOeSzCVlNd86c3p+Wp4OWmhAQvInDiagZ0mqBSXPqbkvD7nUiVlsXjdO2wxGvmSY
        u1qOOrm71JCjpyxBhtq467vG/n44myFM6m1vABbQjG8ysbxnChKCNtI1zhs1QjIUuBfij5OSve9hc
        eP9rbmP48kWkY8nfH6WWj1I9hYC/5sXnZ0swgk1zD5ZheZB+sGdpkTXQVDW2PXUB+BYG7O4hNTEaQ
        EemuMONAa95bF1e2dufghVZ40bjGeSwNlfZVzqlC7moYKZGDQWZlEquKRa+g3aszi+WqDeQtV8ndv
        Vh/wvlkA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nU7CK-0000sk-Ba; Tue, 15 Mar 2022 14:26:48 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Etienne <champetier.etienne@gmail.com>
Subject: [iptables PATCH 3/5] xtables: Call init_extensions{,a,b}() for static builds
Date:   Tue, 15 Mar 2022 14:26:17 +0100
Message-Id: <20220315132619.20256-4-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220315132619.20256-1-phil@nwl.cc>
References: <20220315132619.20256-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Etienne <champetier.etienne@gmail.com>

Add calls to arp- and ebtables-specific extension loaders where missing.
Also consistently call init_extensions() for them, as some extensions
(ebtables 'limit' and arptables 'CLASSIFY' and 'MARK') live in libxt_*
files.

Signed-off-by: Etienne <champetier.etienne@gmail.com>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since nfbz:
- rebased onto previous commit
- avoid mixing declaration and code in xtables_save_main()
- add a more descriptive commit message
---
 iptables/xtables-arp.c        |  1 +
 iptables/xtables-eb.c         |  1 +
 iptables/xtables-monitor.c    |  2 ++
 iptables/xtables-restore.c    |  5 +++++
 iptables/xtables-save.c       |  4 ++++
 iptables/xtables-standalone.c |  5 +++++
 iptables/xtables-translate.c  | 11 ++++++++---
 7 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 9c44cfc2e46f7..68514297f381f 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -205,6 +205,7 @@ int nft_init_arp(struct nft_handle *h, const char *pname)
 			arptables_globals.program_version);
 		exit(1);
 	}
+	init_extensions();
 	init_extensionsa();
 
 	if (nft_init(h, NFPROTO_ARP) < 0)
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index dcb707f6a66e2..a7bfb9c5c60b8 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -668,6 +668,7 @@ int nft_init_eb(struct nft_handle *h, const char *pname)
 			ebtables_globals.program_version);
 		exit(1);
 	}
+	init_extensions();
 	init_extensionsb();
 
 	if (nft_init(h, NFPROTO_BRIDGE) < 0)
diff --git a/iptables/xtables-monitor.c b/iptables/xtables-monitor.c
index 72d5e04bf40bf..8a04f4d1490c1 100644
--- a/iptables/xtables-monitor.c
+++ b/iptables/xtables-monitor.c
@@ -628,6 +628,8 @@ int xtables_monitor_main(int argc, char *argv[])
 	init_extensions();
 	init_extensions4();
 	init_extensions6();
+	init_extensionsa();
+	init_extensionsb();
 
 	if (nft_init(&h, AF_INET)) {
 		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index c6a5ffedc5cb0..0250ed7dd8d66 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -368,7 +368,12 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 		init_extensions6();
 		break;
 	case NFPROTO_ARP:
+		init_extensions();
+		init_extensionsa();
+		break;
 	case NFPROTO_BRIDGE:
+		init_extensions();
+		init_extensionsb();
 		break;
 	default:
 		fprintf(stderr, "Unknown family %d\n", family);
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 9bbe8511e7114..3b6b7e25063fe 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -208,6 +208,8 @@ xtables_save_main(int family, int argc, char *argv[],
 		d.commit = true;
 		break;
 	case NFPROTO_ARP:
+		init_extensions();
+		init_extensionsa();
 		break;
 	case NFPROTO_BRIDGE: {
 		const char *ctr = getenv("EBTABLES_SAVE_COUNTER");
@@ -218,6 +220,8 @@ xtables_save_main(int family, int argc, char *argv[],
 			d.format &= ~FMT_NOCOUNTS;
 			d.format |= FMT_C_COUNTS | FMT_EBT_SAVE;
 		}
+		init_extensions();
+		init_extensionsb();
 		break;
 	}
 	default:
diff --git a/iptables/xtables-standalone.c b/iptables/xtables-standalone.c
index 06fedf261d68b..3faae02d408cc 100644
--- a/iptables/xtables-standalone.c
+++ b/iptables/xtables-standalone.c
@@ -75,8 +75,13 @@ xtables_main(int family, const char *progname, int argc, char *argv[])
 		init_extensions6();
 		break;
 	case NFPROTO_ARP:
+		init_extensions();
 		init_extensionsa();
 		break;
+	case NFPROTO_BRIDGE:
+		init_extensions();
+		init_extensionsb();
+		break;
 	}
 
 	if (nft_init(&h, family) < 0) {
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index c518433463dea..07a9c1bec0bc5 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -488,12 +488,17 @@ static int xtables_xlate_main_common(struct nft_handle *h,
 	switch (family) {
 	case NFPROTO_IPV4:
 	case NFPROTO_IPV6: /* fallthrough: same table */
-	init_extensions();
-	init_extensions4();
-	init_extensions6();
+		init_extensions();
+		init_extensions4();
+		init_extensions6();
 		break;
 	case NFPROTO_ARP:
+		init_extensions();
+		init_extensionsa();
+		break;
 	case NFPROTO_BRIDGE:
+		init_extensions();
+		init_extensionsb();
 		break;
 	default:
 		fprintf(stderr, "Unknown family %d\n", family);
-- 
2.34.1

