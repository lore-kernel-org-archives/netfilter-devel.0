From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 24/24] v1.5.2
Date: Tue, 4 Mar 2008 17:22:18 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803041721320.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35297 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762873AbYCDQWU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:22:20 -0500
In-Reply-To: <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


It's just here for completeness. :-)

===
commit b567100706830bb8917220d81350edc6623e8189
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Tue Mar 4 04:50:11 2008 +0100

    Xtables 1.5.2
---
 configure.ac |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/configure.ac b/configure.ac
index 829027e..2fdec4a 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,5 +1,5 @@
 
-AC_INIT([iptables], [1.4.1])
+AC_INIT([xtables], [1.5.2])
 AC_CONFIG_HEADERS([config.h])
 AC_PROG_INSTALL
 AM_INIT_AUTOMAKE
