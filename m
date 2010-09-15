From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/4] libiptc: add Libs.private to pkgconfig files
Date: Wed, 15 Sep 2010 20:53:47 +0200
Message-ID: <1284576828-32412-5-git-send-email-jengelh@medozas.de>
References: <1284576828-32412-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46822 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162Ab0IOSx5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Sep 2010 14:53:57 -0400
In-Reply-To: <1284576828-32412-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is needed when doing static linking.
(pkg-config --static --libs libiptc)

References: http://bugzilla.netfilter.org/show_bug.cgi?id=675
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 libiptc.pc.in |    1 +
 xtables.pc.in |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/libiptc.pc.in b/libiptc.pc.in
index 63a459a..99a3544 100644
--- a/libiptc.pc.in
+++ b/libiptc.pc.in
@@ -8,4 +8,5 @@ Name:		libiptc
 Description:	iptables ruleset ADT and kernel interface
 Version:	@PACKAGE_VERSION@
 Libs:		-L${libdir} -liptc
+Libs.private:	-lip4tc -lip6tc
 Cflags:		-I${includedir}
diff --git a/xtables.pc.in b/xtables.pc.in
index fa6f33b..43f35d5 100644
--- a/xtables.pc.in
+++ b/xtables.pc.in
@@ -10,3 +10,4 @@ Description:	Shared Xtables code for extensions and iproute2
 Version:	@PACKAGE_VERSION@
 Cflags:		-I${includedir}
 Libs:		-L${libdir} -lxtables
+Libs.private:	-ldl
-- 
1.7.1

