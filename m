Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5F35C352A1
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Dec 2022 17:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiLGRpN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 12:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiLGRpJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 12:45:09 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8528D52145
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 09:45:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VLujoHbiT7UPZTAooUpgTEkhg00EmypQGV0Xdj5r8FE=; b=bl5IShhXz9B+G0CvYkAtp4O9/2
        kB4gFuj/DXvTP+vgPRv00eW+dOFmVXTl+yhPrmBmapTyy7PzhBpuzCk6w/cZ7Yiylias3EhQb+3cO
        UhWtVBlGEOFMrBn09n59ulVyMLroEfkYBI4R+oz+zpi9JJ2YWm8DYfV7huGVSMmZ/NTU+KbDj359T
        vZj55TsK8u6nPwcE4bJEb0vMhk/d4gGiVNxchlwuxIiTe/j6QuCM6Rgui4okDdXSlMPcHoet+e2d4
        +73bDYtC9foiUFzKZdbTxS8ERNrlNblx7Fv1uQUr6g8gBT7iFZqIyEN/zccwNZ1P54FJqk3g5fIig
        z5nb1uZA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p2yTh-0000hM-UU
        for netfilter-devel@vger.kernel.org; Wed, 07 Dec 2022 18:45:05 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 06/11] iptables/Makefile: Split nft-variant man page list
Date:   Wed,  7 Dec 2022 18:44:25 +0100
Message-Id: <20221207174430.4335-7-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221207174430.4335-1-phil@nwl.cc>
References: <20221207174430.4335-1-phil@nwl.cc>
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
index 406147f00f43d..b0f81d14a6451 100644
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

