Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 271B9C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Mar 2022 13:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348629AbiCON1l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Mar 2022 09:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348643AbiCON1k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Mar 2022 09:27:40 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F45042ED0
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2022 06:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=G73oRvZPYxhDY0BoB/iHKeJUhaiuLD6Pg5rsfD+AgCQ=; b=NStQVklBWymc7xWFQieTiLGkei
        hSKzAhTlC2WBtPAvSZWZLGtxOv/u3RPw9Fn9MjwWo61WCu2ad98GQG1BnAi7pA8RFGVr9wFsa/Czr
        KRxIkZ57CMNRKUlY9ecy1DokYN8KQAba4Cfdkw8SZLGwUZWSywUSwWN5ggAuZOP14rNnMAJOo6V37
        RDApVls8ndpnELZVhXtfSHFGN1/iDk1AdHHxsUqlvWqugld7+9VfW04Sdi0aXbtWA67nRxF2w3VHI
        ucjxJ/ELq6O4s9sbVJi8n5B4paFnFjgIZbYLx+iHOaCGqRuod2DYpn79//L1Cl00hYpATmbTdsPCb
        YuNYP2SQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nU7By-0000rA-Vw; Tue, 15 Mar 2022 14:26:27 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Etienne <champetier.etienne@gmail.com>
Subject: [iptables PATCH 4/5] nft: Review static extension loading
Date:   Tue, 15 Mar 2022 14:26:18 +0100
Message-Id: <20220315132619.20256-5-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220315132619.20256-1-phil@nwl.cc>
References: <20220315132619.20256-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Combine the init_extensions() call common to all families, do not load
IPv6 extensions for iptables and vice versa, drop the outdated comment
about "same table".

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-restore.c    | 7 +++----
 iptables/xtables-save.c       | 8 ++++----
 iptables/xtables-standalone.c | 7 +++----
 iptables/xtables-translate.c  | 7 +++----
 4 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 0250ed7dd8d66..b3cf401794198 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -360,19 +360,18 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 		p.in = stdin;
 	}
 
+	init_extensions();
 	switch (family) {
 	case NFPROTO_IPV4:
-	case NFPROTO_IPV6: /* fallthough, same table */
-		init_extensions();
 		init_extensions4();
+		break;
+	case NFPROTO_IPV6:
 		init_extensions6();
 		break;
 	case NFPROTO_ARP:
-		init_extensions();
 		init_extensionsa();
 		break;
 	case NFPROTO_BRIDGE:
-		init_extensions();
 		init_extensionsb();
 		break;
 	default:
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 3b6b7e25063fe..5a82cac5dd7c0 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -199,16 +199,17 @@ xtables_save_main(int family, int argc, char *argv[],
 		exit(1);
 	}
 
+	init_extensions();
 	switch (family) {
 	case NFPROTO_IPV4:
-	case NFPROTO_IPV6: /* fallthough, same table */
-		init_extensions();
 		init_extensions4();
+		d.commit = true;
+		break;
+	case NFPROTO_IPV6:
 		init_extensions6();
 		d.commit = true;
 		break;
 	case NFPROTO_ARP:
-		init_extensions();
 		init_extensionsa();
 		break;
 	case NFPROTO_BRIDGE: {
@@ -220,7 +221,6 @@ xtables_save_main(int family, int argc, char *argv[],
 			d.format &= ~FMT_NOCOUNTS;
 			d.format |= FMT_C_COUNTS | FMT_EBT_SAVE;
 		}
-		init_extensions();
 		init_extensionsb();
 		break;
 	}
diff --git a/iptables/xtables-standalone.c b/iptables/xtables-standalone.c
index 3faae02d408cc..117b0c69dd14f 100644
--- a/iptables/xtables-standalone.c
+++ b/iptables/xtables-standalone.c
@@ -67,19 +67,18 @@ xtables_main(int family, const char *progname, int argc, char *argv[])
 		exit(1);
 	}
 	xt_params->program_name = progname;
+	init_extensions();
 	switch (family) {
 	case NFPROTO_IPV4:
-	case NFPROTO_IPV6:
-		init_extensions();
 		init_extensions4();
+		break;
+	case NFPROTO_IPV6:
 		init_extensions6();
 		break;
 	case NFPROTO_ARP:
-		init_extensions();
 		init_extensionsa();
 		break;
 	case NFPROTO_BRIDGE:
-		init_extensions();
 		init_extensionsb();
 		break;
 	}
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 07a9c1bec0bc5..d1e87f167df74 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -485,19 +485,18 @@ static int xtables_xlate_main_common(struct nft_handle *h,
 			xtables_globals.program_version);
 		return 1;
 	}
+	init_extensions();
 	switch (family) {
 	case NFPROTO_IPV4:
-	case NFPROTO_IPV6: /* fallthrough: same table */
-		init_extensions();
 		init_extensions4();
+		break;
+	case NFPROTO_IPV6:
 		init_extensions6();
 		break;
 	case NFPROTO_ARP:
-		init_extensions();
 		init_extensionsa();
 		break;
 	case NFPROTO_BRIDGE:
-		init_extensions();
 		init_extensionsb();
 		break;
 	default:
-- 
2.34.1

