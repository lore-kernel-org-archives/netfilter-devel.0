Return-Path: <SRS0=6+Vk=V4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF3D6C433FF
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Jul 2019 16:39:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82225206A2
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Jul 2019 16:39:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729812AbfGaQjr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Jul 2019 12:39:47 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:40922 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729461AbfGaQjr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Jul 2019 12:39:47 -0400
Received: from localhost ([::1]:54012 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hsrdh-0005kJ-D0; Wed, 31 Jul 2019 18:39:45 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/5] doc: Clean generated *-restore-translate man pages
Date:   Wed, 31 Jul 2019 18:39:11 +0200
Message-Id: <20190731163915.22232-2-phil@nwl.cc>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190731163915.22232-1-phil@nwl.cc>
References: <20190731163915.22232-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since they are generated, one has to specify them in CLEANFILES. While
being at it, introduce a variable holding them to improve readability a
bit.

Fixes: 3dfb01cf14d72 ("doc: Install ip{6,}tables-restore-translate.8 man pages")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/Makefile.am | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index 21ac7f08b7c1f..da07b9a4b5a2f 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -47,6 +47,9 @@ xtables_nft_multi_SOURCES += xshared.c
 xtables_nft_multi_LDADD   += ../libxtables/libxtables.la -lm
 endif
 
+XTABLES_XLATE_8_LINKS = iptables-translate.8 ip6tables-translate.8 \
+			iptables-restore-translate.8 ip6tables-restore-translate.8
+
 sbin_PROGRAMS    = xtables-legacy-multi
 if ENABLE_NFTABLES
 sbin_PROGRAMS	+= xtables-nft-multi
@@ -56,14 +59,13 @@ man_MANS         = iptables.8 iptables-restore.8 iptables-save.8 \
                    ip6tables-save.8 iptables-extensions.8
 if ENABLE_NFTABLES
 man_MANS	+= xtables-nft.8 xtables-translate.8 xtables-legacy.8 \
-                   iptables-translate.8 ip6tables-translate.8 \
-		   iptables-restore-translate.8 ip6tables-restore-translate.8 \
+                   ${XTABLES_XLATE_8_LINKS} \
                    xtables-monitor.8 \
                    arptables-nft.8 arptables-nft-restore.8 arptables-nft-save.8 \
                    ebtables-nft.8
 endif
 CLEANFILES       = iptables.8 xtables-monitor.8 \
-		   iptables-translate.8 ip6tables-translate.8
+		   ${XTABLES_XLATE_8_LINKS}
 
 vx_bin_links   = iptables-xml
 if ENABLE_IPV4
@@ -93,7 +95,7 @@ iptables-extensions.8: iptables-extensions.8.tmpl ../extensions/matches.man ../e
 		-e '/@MATCH@/ r ../extensions/matches.man' \
 		-e '/@TARGET@/ r ../extensions/targets.man' $< >$@;
 
-iptables-translate.8 ip6tables-translate.8 iptables-restore-translate.8 ip6tables-restore-translate.8:
+${XTABLES_XLATE_8_LINKS}:
 	${AM_VERBOSE_GEN} echo '.so man8/xtables-translate.8' >$@
 
 pkgconfig_DATA = xtables.pc
-- 
2.22.0

