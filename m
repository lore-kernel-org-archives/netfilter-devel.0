Return-Path: <SRS0=NVo7=VU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C69C7618B
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 15:24:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AF7B223A0
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 15:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbfGWPY4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 11:24:56 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:48684 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbfGWPY4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 11:24:56 -0400
Received: from localhost ([::1]:33542 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hpwet-0001ct-Ld; Tue, 23 Jul 2019 17:24:55 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/2] doc: Install ip{6,}tables-restore-translate.8 man pages
Date:   Tue, 23 Jul 2019 17:24:41 +0200
Message-Id: <20190723152441.7360-2-phil@nwl.cc>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190723152441.7360-1-phil@nwl.cc>
References: <20190723152441.7360-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Just like in b738ca3677785 ("doc: Install ip{6,}tables-translate.8
manpages"), create man pages for *-restore-translate tools as semantic
links to xtables-translate.8.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/.gitignore  | 2 ++
 iptables/Makefile.am | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/iptables/.gitignore b/iptables/.gitignore
index c638139b8a1d0..d46adc8a32f02 100644
--- a/iptables/.gitignore
+++ b/iptables/.gitignore
@@ -3,6 +3,7 @@
 /ip6tables-restore
 /ip6tables-static
 /ip6tables-translate.8
+/ip6tables-restore-translate.8
 /iptables
 /iptables.8
 /iptables-extensions.8
@@ -13,6 +14,7 @@
 /iptables-restore.8
 /iptables-static
 /iptables-translate.8
+/iptables-restore-translate.8
 /iptables-xml
 /iptables-xml.1
 /xtables-multi
diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index 11abb23977e8c..d2207a47a7a26 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -62,6 +62,7 @@ man_MANS         = iptables.8 iptables-restore.8 iptables-save.8 \
 if ENABLE_NFTABLES
 man_MANS	+= xtables-nft.8 xtables-translate.8 xtables-legacy.8 \
                    iptables-translate.8 ip6tables-translate.8 \
+		   iptables-restore-translate.8 ip6tables-restore-translate.8 \
                    xtables-monitor.8 \
                    arptables-nft.8 arptables-nft-restore.8 arptables-nft-save.8 \
                    ebtables-nft.8
@@ -98,7 +99,7 @@ iptables-extensions.8: iptables-extensions.8.tmpl ../extensions/matches.man ../e
 		-e '/@MATCH@/ r ../extensions/matches.man' \
 		-e '/@TARGET@/ r ../extensions/targets.man' $< >$@;
 
-iptables-translate.8 ip6tables-translate.8:
+iptables-translate.8 ip6tables-translate.8 iptables-restore-translate.8 ip6tables-restore-translate.8:
 	${AM_VERBOSE_GEN} echo '.so man8/xtables-translate.8' >$@
 
 pkgconfig_DATA = xtables.pc
-- 
2.22.0

