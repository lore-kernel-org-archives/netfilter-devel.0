Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A60BC61DF5
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 12:54:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343883AbjKVMyw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 07:54:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343884AbjKVMyr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 07:54:47 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1737819D
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 04:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zT7EnA9xkGqJ62ueSnC9ZYRuNqDSJMAX6zk3gXRgrVQ=; b=Q+PWO5TtJ7UoaRW7b0svCNn5Ah
        JrITj7lV6XX2URGhG80j5AF6FAahLXFkv2fJlSaiAiBqdLQ1vjEPf7yNLJ9rgcA8iDMhLwTgVMvGF
        PH5R4UiOsISuAty7qyhkxTYXiA9sV/Nyw1NUShFUPN6nJy/oj6n/NwXuQ8wmbTuAR5IQ/MsokqVeH
        F7YgLovIt9vsJ3errXQmiWMD5k/zgE8NPS+s0oVJdDHRFJ+EuPfu2howIMlBGjeL9epurGuxfsgST
        edBfBDG0bwxkGSW1Fik3Nv3qs43Kln5lja9CjS+qDSYxlqAacJRvqngGg8WSfi4sRbDMSndgIVm+Z
        vg7m8Xsg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1r5mkU-0005S9-Bw
        for netfilter-devel@vger.kernel.org; Wed, 22 Nov 2023 13:54:34 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 01/12] Makefile: Install arptables-translate link and man page
Date:   Wed, 22 Nov 2023 14:02:11 +0100
Message-ID: <20231122130222.29453-2-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231122130222.29453-1-phil@nwl.cc>
References: <20231122130222.29453-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

While at it, introduce a variable to hold the various semantic links to
xtables-translate.8 man page.

Fixes: 5b7324e0675e3 ("nft-arp: add arptables-translate")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/Makefile.am         | 11 +++++++----
 iptables/xtables-translate.8 | 12 ++++++++----
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index 8a7227024987f..0f8b430c20213 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -69,10 +69,12 @@ man_MANS         = iptables.8 iptables-restore.8 iptables-save.8 \
 dist_sbin_SCRIPTS = iptables-apply
 dist_pkgdata_DATA = iptables.xslt
 
+xlate_man_links = iptables-translate.8 ip6tables-translate.8 \
+		  iptables-restore-translate.8 ip6tables-restore-translate.8 \
+		  ebtables-translate.8 arptables-translate.8
+
 if ENABLE_NFTABLES
-man_MANS	+= iptables-translate.8 ip6tables-translate.8 \
-		   iptables-restore-translate.8 ip6tables-restore-translate.8 \
-		   xtables-monitor.8 ebtables-translate.8
+man_MANS	+= ${xlate_man_links} xtables-monitor.8
 
 dist_man_MANS	 = xtables-nft.8 xtables-translate.8 xtables-legacy.8 \
 		   arptables-nft.8 arptables-nft-restore.8 arptables-nft-save.8 \
@@ -97,6 +99,7 @@ x_sbin_links  = iptables-nft iptables-nft-restore iptables-nft-save \
 		arptables-nft arptables \
 		arptables-nft-restore arptables-restore \
 		arptables-nft-save arptables-save \
+		arptables-translate \
 		ebtables-nft ebtables \
 		ebtables-nft-restore ebtables-restore \
 		ebtables-nft-save ebtables-save \
@@ -108,7 +111,7 @@ iptables-extensions.8: iptables-extensions.8.tmpl ../extensions/matches.man ../e
 		-e '/@MATCH@/ r ../extensions/matches.man' \
 		-e '/@TARGET@/ r ../extensions/targets.man' $< >$@;
 
-iptables-translate.8 ip6tables-translate.8 iptables-restore-translate.8 ip6tables-restore-translate.8 ebtables-translate.8:
+${xlate_man_links}:
 	${AM_VERBOSE_GEN} echo '.so man8/xtables-translate.8' >$@
 
 ip6tables.8 ip6tables-apply.8 ip6tables-restore.8 ip6tables-save.8:
diff --git a/iptables/xtables-translate.8 b/iptables/xtables-translate.8
index ba16c5257c4a5..fe1278874b4da 100644
--- a/iptables/xtables-translate.8
+++ b/iptables/xtables-translate.8
@@ -30,10 +30,12 @@ iptables-translate \(em translation tool to migrate from iptables to nftables
 ip6tables-translate \(em translation tool to migrate from ip6tables to nftables
 .P
 ebtables-translate \(em translation tool to migrate from ebtables to nftables
+.P
+arptables-translate \(em translation tool to migrate from arptables to nftables
 .SH DESCRIPTION
 There is a set of tools to help the system administrator translate a given
-ruleset from \fBiptables(8)\fP, \fBip6tables(8)\fP and \fBebtables(8)\fP to
-\fBnftables(8)\fP.
+ruleset from \fBiptables(8)\fP, \fBip6tables(8)\fP, \fBebtables(8)\fP and
+\fBarptables(8)\fP to \fBnftables(8)\fP.
 
 The available commands are:
 
@@ -47,11 +49,13 @@ ip6tables\-translate
 ip6tables\-restore\-translate
 .IP \[bu] 2
 ebtables\-translate
+.IP \[bu] 2
+arptables\-translate
 
 .SH USAGE
 They take as input the original
-\fBiptables(8)\fP/\fBip6tables(8)\fP/\fBebtables(8)\fP syntax and
-output the native \fBnftables(8)\fP syntax.
+\fBiptables(8)\fP/\fBip6tables(8)\fP/\fBebtables(8)\fP/\fBarptables(8)\fP
+syntax and output the native \fBnftables(8)\fP syntax.
 
 The \fBiptables-restore-translate\fP tool reads a ruleset in the syntax
 produced by \fBiptables-save(8)\fP. Likewise, the
-- 
2.41.0

