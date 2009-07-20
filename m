From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] Only build iptables-xml when shared libraries are
 enabled
Date: Mon, 20 Jul 2009 11:06:09 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0907201103440.27235@fbirervta.pbzchgretzou.qr>
References: <4A63F63D.8000904@snapgear.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53316 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbZGTJGL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jul 2009 05:06:11 -0400
In-Reply-To: <4A63F63D.8000904@snapgear.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2009-07-20 06:44, Philip Craig wrote:

>
>
>
>Only build iptables-xml when shared libraries are enabled
>
>There is no static version of iptables-xml currently.

Naah:
-rwxr-xr-x 1 jengelh users 209336 Jul 16 19:41 iptables-xml

(look at the size, it has obviously been compiled with
./configure --disable-shared)

>I'm building for a target that has no libdl.
>@@ -81,7 +81,7 @@ ip6tables_static_SOURCES    = ${ip6tables_multi_SOURCES} xtables.c
> ip6tables_static_CFLAGS     = ${ip6tables_multi_CFLAGS} -DNO_SHARED_LIBS=1
> ip6tables_static_LDADD      = libiptc/libip6tc.la extensions/libext6.a -lm
> 
>-bin_PROGRAMS     = iptables-xml
>+bin_PROGRAMS     =
> sbin_PROGRAMS    =
> noinst_PROGRAMS  =
> man_MANS         = iptables.8 iptables-restore.8 iptables-save.8 \

Since there is no mention of -ldl for `grep iptables.xml Makefile.am`
(instead we need to change something else), I declare this patch
not applicable.

Static, as far as iptables is concerned, only means that extensions
are built-in. It still uses libc and so on. Maybe should rename that
to avoid confusion..
