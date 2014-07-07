From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 2/7] autotool conversion: use pkg-config to find 'libmnl',
 libnftnl' and 'ncurses'.
Date: Mon, 7 Jul 2014 15:08:32 +0200 (CEST)
Message-ID: <alpine.LSU.2.11.1407071505120.20461@nerf08.vanv.qr>
References: <1404728169-7899-1-git-send-email-giorgio.nicole@arcor.de> <1404728169-7899-3-git-send-email-giorgio.nicole@arcor.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Giorgio Dal Molin <giorgio.nicole@arcor.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:57683 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbaGGNId (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2014 09:08:33 -0400
In-Reply-To: <1404728169-7899-3-git-send-email-giorgio.nicole@arcor.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2014-07-07 12:16, Giorgio Dal Molin wrote:
>-	     AC_MSG_ERROR([No suitable version of libnftnl found]))
>+dnl Check for package libnftnl
>+PKG_CHECK_MODULES(LIBMNL, [libmnl], , AC_MSG_ERROR([No suitable version of libmnl found]))
>+AC_SUBST(LIBMNL_CFLAGS)
>+AC_SUBST(LIBMNL_LIBS)

Substing CFLAGS and LIBS is not needed; this is already included
in PKG_CHECK_MODULES.

>--- /dev/null
>+++ b/src/Makefile.am
>@@ -0,0 +1,45 @@
>+sbin_PROGRAMS = nft
>+
>+nft_CFLAGS =	-fno-strict-aliasing							\
>+		-Wall									\
>+		-Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations		\
>+		-Wdeclaration-after-statement -Wsign-compare -Winit-self		\
>+		-Wformat-nonliteral -Wformat-security -Wmissing-format-attribute	\
>+		-Wcast-align -Wundef -Wbad-function-cast				\
>+		-Waggregate-return -Wunused -Wwrite-strings				\
>+		@LIBMNL_CFLAGS@ @LIBNFTNL_CFLAGS@
>+
>+nft_CPPFLAGS = -I${srcdir}/../include @DEBUG_CPPFLAGS@

As the pkg-config CFLAGS are really just CPPFLAGS, @LIBMNL_CFLAGS@
and @LIBNFTNL_CFLAGS@ should be put into nft_CPPFLAGS instead. In
fact, you can just use ${LIBMNL_CFLAGS} and ${LIBNFTNL_CFLAGS} (same
for _LIBS) instead, which ensures that you can override them at make
time. Also, if nft_CPPFLAGS is not strictly necessary, use
AM_CPPFLAGS (and AM_CFLAGS) instead.

See also the autotooling I had done earlier
and which you and me have talked about ;)

