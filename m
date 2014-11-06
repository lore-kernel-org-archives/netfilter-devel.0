From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH nft 5/5] build: autotools conversion
Date: Thu, 6 Nov 2014 21:29:56 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1411062115320.30895@nerf08.vanv.qr>
References: <1415298349-985-1-git-send-email-pablo@netfilter.org> <1415298349-985-6-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:57312 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaKFUaA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Nov 2014 15:30:00 -0500
In-Reply-To: <1415298349-985-6-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2014-11-06 19:25, Pablo Neira Ayuso wrote:

>+AM_CPPFLAGS += -DDEFAULT_INCLUDE_PATH="\"${sysconfdir}\"" -D__USE_GNU

feature_test_macros(7) specifies _GNU_SOURCE rather than __USE_GNU.

>+AM_CFLAGS = -Wall	\
>+	    -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations	\
>+	    -Wdeclaration-after-statement -Wsign-compare -Winit-self		\
>+	    -Wformat-nonliteral -Wformat-security -Wmissing-format-attribute	\
>+	    -Wcast-align -Wundef -Wbad-function-cast # -Wshadow			\
>+	    -Waggregate-return -Wunused -Wwrite-strings				\
>+	    ${LIBMNL_CFLAGS} ${LIBNFTNL_CFLAGS}

You have a # in there, which causes the remaining -W and -I from 
LIBMNL_CFLAGS to be absent from the compilation line.

LIBMNL_CFLAGS and LIBNFTNL_CFLAGS should be in AM_CPPFLAGS because
they are, well, cppflags. (It's a pkgconfig "bug").
This was properly done in the original autotools submissions.

>--- /dev/null
>+++ b/m4/.gitignore
>@@ -0,0 +1,2 @@
>+*
>+!.gitignore

The last entry is not needed, because .gitignore would already be 
unignored because it is tracked.

  /lt*.m4
  /libtool.m4

as in the original submission would ensure that no more files are 
ignored than absolutely necessary, so as to be aware of potential 
additional files popping up.

>--- a/src/scanner.l
>+++ b/src/scanner.l
>@@ -169,6 +169,7 @@ ip6addr		({v680}|{v67}|{v66}|{v65}|{v64}|{v63}|{v62}|{v61}|{v60})
> addrstring	({macaddr}|{ip4addr}|{ip6addr})
> 
> %option prefix="nft_"
>+%option outfile="lex.yy.c"
> %option reentrant
> %option noyywrap
> %option nounput

Why is this needed? The default output filename is already lex.yy.c
(and ylwrap will rename it anyway).

