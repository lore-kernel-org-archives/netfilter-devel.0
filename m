From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [patch] iptables out-of-tree build directory
Date: Mon, 12 May 2008 10:28:34 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805121018530.25441@fbirervta.pbzchgretzou.qr>
References: <1210547721.23433.33.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	Henrik Nordstrom <henrik@henriknordstrom.net>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37573 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbYELI2f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2008 04:28:35 -0400
In-Reply-To: <1210547721.23433.33.camel@henriknordstrom.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2008-05-12 01:15, Henrik Nordstrom wrote:

>The attached patch fixes iptables out-of-tree compiles which otherwise
>failed in extensions/ complaining about not finding xtables.h
>
>
>mkdir build
>cd build
>../iptables/configure
>make

Thanks for noticing!
-I../ is rather hackish, though. Following patch is the proper
thing (IMO):

===
commit 333c904234d9320aca2494cf86595b9639b03f3e
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Mon May 12 10:25:15 2008 +0200

    Makefile: fix out-of-topdir compilation
    
    Reported by: Henrik Nordstrom
    
    When xtables.h is not already found in /usr/include, compilation
    would fail when ${top_srcdir} != ${top_builddir}.
---
 extensions/GNUmakefile.in |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 31e6fb7..9c46ab1 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -1,5 +1,7 @@
 # -*- Makefile -*-
 
+top_builddir := @top_builddir@
+builddir     := @builddir@
 top_srcdir  := @top_srcdir@
 srcdir      := @srcdir@
 ksourcedir  := @ksourcedir@
@@ -16,7 +18,7 @@ LDFLAGS        := @LDFLAGS@
 regular_CFLAGS := @regular_CFLAGS@
 kinclude_CFLAGS := @kinclude_CFLAGS@
 
-AM_CFLAGS      := ${regular_CFLAGS} -I${top_srcdir}/include ${kinclude_CFLAGS}
+AM_CFLAGS      := ${regular_CFLAGS} -I${top_builddir}/include -I${top_srcdir}/include ${kinclude_CFLAGS}
 AM_DEPFLAGS     = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
 
 ifeq (${V},)
