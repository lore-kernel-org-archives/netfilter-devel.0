From: Jan Engelhardt <jengelh@medozas.de>
Subject: build: pkg-config file should provide CFLAGS
Date: Thu, 12 Feb 2009 01:37:31 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902120137200.21248@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55093 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158AbZBLAhd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 19:37:33 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


commit b83f1f8f2d15602a76f3af882914995ab11687fb
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Feb 12 01:36:21 2009 +0100

build: pkg-config file should provide CFLAGS

When libxtables and its header files are installed in a non-default
directory, -I/-L is needed.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 xtables.pc.in |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/xtables.pc.in b/xtables.pc.in
index 7246d7b..6960e4f 100644
--- a/xtables.pc.in
+++ b/xtables.pc.in
@@ -8,4 +8,5 @@ includedir=@includedir@
 Name:		xtables
 Description:	Shared Xtables code for extensions and iproute2
 Version:	@PACKAGE_VERSION@
-Libs:		-lxtables
+Libs:		-l${libdir} -lxtables
+Cflags:		-I${includedir}
-- 
# Created with git-export-patch

