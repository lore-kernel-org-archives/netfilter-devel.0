Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88AF2C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 15:46:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiLHPq5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 10:46:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbiLHPqt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 10:46:49 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9A05444F
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Dec 2022 07:46:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QUeG2pQ8rKUHBI6mkDJW3sRbxtHruGV9T2BNWrTTij4=; b=GZ+YMjKN6gG0TolEI7hWbABZWS
        SXrnseqIKnwKUrF7vy488Oh6vjmjQRplAXMeF+VfgZloVdloKWCVswbfp0Pp1AhuhcFF+QDEFDCKU
        Qyk157T4MJhEalULi6BBPE8+Or8CawGSmzif+iAVdrvJ8WLJyWTCHJZ2HAaY90GY12PTZqLU/JZW9
        CuKzwIfWn9Oo2/Y7vIRTTs/kTiCCAlB5cKLidDangEo/zKfxRyZOhCsUhBjY2wHWDuNhDcUBF4Nm0
        TSE+C22s79xIHhaLOzJBGby2VJI0H2jJ61lPKI26BZm74Z7Nuyd2ZFLGHTlSwiNGc6vu4knEtLLFL
        MPXbQMKA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p3J6a-0005fE-FT; Thu, 08 Dec 2022 16:46:36 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH v2 06/11] iptables/Makefile: Split nft-variant man page list
Date:   Thu,  8 Dec 2022 16:46:11 +0100
Message-Id: <20221208154616.14622-7-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221208154616.14622-1-phil@nwl.cc>
References: <20221208154616.14622-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Some of them are not generated and must therefore be distributed. Hence
add them to a 'dist_man_MANS' variable. This leaves only generated
entries in the non-dist one, so use that to reduce the CLEANFILES list.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/Makefile.am | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index 77202ad80934f..7ca2b1a4ba762 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -66,19 +66,15 @@ man_MANS         = iptables.8 iptables-restore.8 iptables-save.8 \
 sbin_SCRIPTS     = iptables-apply
 
 if ENABLE_NFTABLES
-man_MANS	+= xtables-nft.8 xtables-translate.8 xtables-legacy.8 \
-                   iptables-translate.8 ip6tables-translate.8 \
+man_MANS	+= iptables-translate.8 ip6tables-translate.8 \
 		   iptables-restore-translate.8 ip6tables-restore-translate.8 \
-                   xtables-monitor.8 \
-                   arptables-nft.8 arptables-nft-restore.8 arptables-nft-save.8 \
-                   ebtables-nft.8
+		   xtables-monitor.8
+
+dist_man_MANS	 = xtables-nft.8 xtables-translate.8 xtables-legacy.8 \
+		   arptables-nft.8 arptables-nft-restore.8 arptables-nft-save.8 \
+		   ebtables-nft.8
 endif
-CLEANFILES       = iptables.8 xtables-monitor.8 \
-		   iptables-xml.1 iptables-apply.8 \
-		   iptables-extensions.8 iptables-extensions.8.tmpl \
-		   iptables-restore.8 iptables-save.8 \
-		   iptables-restore-translate.8 ip6tables-restore-translate.8 \
-		   iptables-translate.8 ip6tables-translate.8
+CLEANFILES       = ${man_MANS} iptables-extensions.8.tmpl
 
 vx_bin_links   = iptables-xml
 if ENABLE_IPV4
-- 
2.38.0

