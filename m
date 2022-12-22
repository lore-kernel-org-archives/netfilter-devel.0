Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D9C3C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Dec 2022 16:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235310AbiLVQ0I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Dec 2022 11:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235418AbiLVQ0B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Dec 2022 11:26:01 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A596726129
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Dec 2022 08:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1leF7hsEceX9hFZ6sZM061ViWutSeYyM3AeHyIpvefc=; b=Ex7YWxiKWyB+K32HJ7rkFClNU/
        v6IoN6XtJrUQrx9/43UEQ9H6shy4ba27taM9EXNAPqg/hcwSwmF1+kroXcAHWMoS9MaqlCMEkJkJJ
        byb0f2hIFFfj63NwK4CUxbxIS8ZtuB7qn5icF7CRSUUgiTEZNl29PxsqZa4Lw7RLgtI3BARdPv/Nm
        26efjVfg41wrEezAGc/v8z12Iy/DN724lZ+Dv6toT/he/lwvW9oyMDRXBDKA1Ur1IqU7dpjs2KKa4
        cbOomIXSzexvXSSKhrqW1AhsTX+ZtMurgZImMSaYi55hlF1m7Mntqwf9gDhFnFMWaeXb/O8jXzhe1
        2JdoEo9w==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p8OOE-0007LJ-FC
        for netfilter-devel@vger.kernel.org; Thu, 22 Dec 2022 17:25:50 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/3] ebtables-translate: Install symlink
Date:   Thu, 22 Dec 2022 17:25:41 +0100
Message-Id: <20221222162541.30207-3-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221222162541.30207-1-phil@nwl.cc>
References: <20221222162541.30207-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Make this officially a tool, we have enough test coverage in place. Also
update xtables-translate.8 to mention it at least and generate
ebtables-translate.8 which points to it.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/.gitignore          |  1 +
 iptables/Makefile.am         |  6 +++---
 iptables/xtables-translate.8 | 13 +++++++++----
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/iptables/.gitignore b/iptables/.gitignore
index 245e1245727bd..8141e34d8b629 100644
--- a/iptables/.gitignore
+++ b/iptables/.gitignore
@@ -1,3 +1,4 @@
+/ebtables-translate.8
 /ip6tables
 /ip6tables.8
 /ip6tables-apply.8
diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index 4353dd0094c9e..1f37640f263c9 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -69,7 +69,7 @@ dist_pkgdata_DATA = iptables.xslt
 if ENABLE_NFTABLES
 man_MANS	+= iptables-translate.8 ip6tables-translate.8 \
 		   iptables-restore-translate.8 ip6tables-restore-translate.8 \
-		   xtables-monitor.8
+		   xtables-monitor.8 ebtables-translate.8
 
 dist_man_MANS	 = xtables-nft.8 xtables-translate.8 xtables-legacy.8 \
 		   arptables-nft.8 arptables-nft-restore.8 arptables-nft-save.8 \
@@ -89,7 +89,7 @@ endif
 if ENABLE_NFTABLES
 x_sbin_links  = iptables-nft iptables-nft-restore iptables-nft-save \
 		ip6tables-nft ip6tables-nft-restore ip6tables-nft-save \
-		iptables-translate ip6tables-translate \
+		iptables-translate ip6tables-translate ebtables-translate \
 		iptables-restore-translate ip6tables-restore-translate \
 		arptables-nft arptables \
 		arptables-nft-restore arptables-restore \
@@ -105,7 +105,7 @@ iptables-extensions.8: iptables-extensions.8.tmpl ../extensions/matches.man ../e
 		-e '/@MATCH@/ r ../extensions/matches.man' \
 		-e '/@TARGET@/ r ../extensions/targets.man' $< >$@;
 
-iptables-translate.8 ip6tables-translate.8 iptables-restore-translate.8 ip6tables-restore-translate.8:
+iptables-translate.8 ip6tables-translate.8 iptables-restore-translate.8 ip6tables-restore-translate.8 ebtables-translate.8:
 	${AM_VERBOSE_GEN} echo '.so man8/xtables-translate.8' >$@
 
 ip6tables.8 ip6tables-apply.8 ip6tables-restore.8 ip6tables-save.8:
diff --git a/iptables/xtables-translate.8 b/iptables/xtables-translate.8
index 3dc72760e8636..a048e8c9ced77 100644
--- a/iptables/xtables-translate.8
+++ b/iptables/xtables-translate.8
@@ -28,9 +28,12 @@
 iptables-translate \(em translation tool to migrate from iptables to nftables
 .P
 ip6tables-translate \(em translation tool to migrate from ip6tables to nftables
+.P
+ebtables-translate \(em translation tool to migrate from ebtables to nftables
 .SH DESCRIPTION
 There is a set of tools to help the system administrator translate a given
-ruleset from \fBiptables(8)\fP and \fBip6tables(8)\fP to \fBnftables(8)\fP.
+ruleset from \fBiptables(8)\fP, \fBip6tables(8)\fP and \fBebtables(8)\fP to
+\fBnftables(8)\fP.
 
 The available commands are:
 
@@ -42,9 +45,12 @@ iptables-restore-translate
 ip6tables-translate
 .IP \[bu]
 ip6tables-restore-translate
+.IP \[bu] 2
+ebtables-translate
 
 .SH USAGE
-They take as input the original \fBiptables(8)\fP/\fBip6tables(8)\fP syntax and
+They take as input the original
+\fBiptables(8)\fP/\fBip6tables(8)\fP/\fBebtables(8)\fP syntax and
 output the native \fBnftables(8)\fP syntax.
 
 The \fBiptables-restore-translate\fP tool reads a ruleset in the syntax
@@ -117,8 +123,7 @@ Some (few) extensions may be not supported (or fully-supported) for whatever
 reason (for example, they were considered obsolete, or we didn't have the time
 to work on them).
 
-There are no translations available for \fBebtables(8)\fP and
-\fBarptables(8)\fP.
+There is no translation available for \fBarptables(8)\fP.
 
 To get up-to-date information about this, please head to
 \fBhttps://wiki.nftables.org/\fP.
-- 
2.38.0

