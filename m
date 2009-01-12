From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables -git automake warnings
Date: Mon, 12 Jan 2009 07:11:06 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901120710590.21692@fbirervta.pbzchgretzou.qr>
References: <496AD8C7.2020208@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46445 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbZALGLI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2009 01:11:08 -0500
In-Reply-To: <496AD8C7.2020208@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-01-12 06:44, Patrick McHardy wrote:
> Makefile.am:97: `%'-style pattern rules are a GNU make extension

parent f38ae2530b523f2b293e19021fab8ddae9f8435b (v1.4.3-rc1-18-gf38ae25)
commit 3e95daeb83446a61afa86914c9f1a03fa257537d
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Mon Jan 12 07:10:51 2009 +0100

build: remove non-portable rule

>Makefile.am:97: `%'-style pattern rules are a GNU make extension

(iptables still requires GNU make for extensions/, because it is
so much easier to write.)

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index d5f8875..4852d2a 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -94,9 +94,6 @@ iptables.8: ${srcdir}/iptables.8.in extensions/matches4.man extensions/targets4.
 ip6tables.8: ${srcdir}/ip6tables.8.in extensions/matches6.man extensions/targets6.man
 	${AM_VERBOSE_GEN} sed -e 's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' -e '/@MATCH@/ r extensions/matches6.man' -e '/@TARGET@/ r extensions/targets6.man' $< >$@;
 
-extensions/%:
-	${MAKE} ${AM_MAKEFLAGS} -C $(@D) $(@F)
-
 pkgconfig_DATA = xtables.pc
 
 .PHONY: tarball
-- 
# Created with git-export-patch
