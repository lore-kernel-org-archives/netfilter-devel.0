From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [RFC conntrackd PATCH] conntrackd: add basic systemd notification
 support
Date: Mon, 19 Oct 2015 02:03:14 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1510190200280.20626@nerf40.vanv.qr>
References: <20151016120800.15632.42888.stgit@r2d2.cica.es> <alpine.LSU.2.20.1510161607550.18200@nerf40.vanv.qr> <CAOkSjBh7hyB_QAidiXsoBtCOj9xG8y0cUcu-ERZTCZQsnHXRJA@mail.gmail.com> <alpine.LSU.2.20.1510162326001.24538@nerf40.vanv.qr> <20151017105720.GA1462@salvia>
 <alpine.LSU.2.20.1510190049380.21673@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:38037 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbbJSADP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 Oct 2015 20:03:15 -0400
In-Reply-To: <alpine.LSU.2.20.1510190049380.21673@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2015-10-19 00:50, Jan Engelhardt wrote:
>On Saturday 2015-10-17 12:57, Pablo Neira Ayuso wrote:
>>Something like this (that we already have in nftables) should be fine:
>>
>> AC_ARG_ENABLE([debug],
>>-             AS_HELP_STRING([--enable-debug], [Enable debugging]),
>>-             [with_debug=no],
>>+             AS_HELP_STRING([--enable-debug], [Disable debugging]),
>>+             AS_IF([test "x$enable_debug" = "xno"], [with_debug=no],
>>[with_debug=yes]),
>>              [with_debug=yes])
>
>Well the whole AS_IF part is not really needed, because you
>are already testing in AM_CONDITIONAL:

That is to say, I find that something like the following would be
quite sufficient.


commit d0e677da000b1034df13718d4388ca78fbea97e6
Author: Jan Engelhardt <jengelh@inai.de>
Date:   Mon Oct 19 01:59:33 2015 +0200

    build: simplify parsing of --enable-debug

diff --git a/configure.ac b/configure.ac
index 0d7e6ed..780a3e6 100644
--- a/configure.ac
+++ b/configure.ac
@@ -24,10 +24,8 @@ AC_DEFINE([_STDC_FORMAT_MACROS], [], [printf-style format macros])
 
 AC_ARG_ENABLE([debug],
 	      AS_HELP_STRING([--enable-debug], [Disable debugging]),
-	      AS_IF([test "x$enable_debug" = "xno"], [with_debug=no], [with_debug=yes]),
-	      [with_debug=yes])
-AC_SUBST(with_debug)
-AM_CONDITIONAL([BUILD_DEBUG], [test "x$with_debug" != xno])
+	      [enable_debug="$enableval"], [enable_debug=yes])
+AM_CONDITIONAL([BUILD_DEBUG], [test "x$enable_debug" != xno])
 
 # Checks for programs.
 AC_PROG_CC
@@ -135,5 +133,5 @@ AC_OUTPUT
 echo "
 nft configuration:
   cli support:			${with_cli}
-  enable debugging:		${with_debug}
+  enable debugging:		${enable_debug}
   use mini-gmp:			${with_mini_gmp}"
