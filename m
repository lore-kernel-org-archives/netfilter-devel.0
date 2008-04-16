From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Something like a bug
Date: Wed, 16 Apr 2008 16:48:45 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804161648200.29182@fbirervta.pbzchgretzou.qr>
References: <dbdd0cc00804140027y54a00ca7pdef3b091dde33bf6@mail.gmail.com>  <4804CE07.3060507@netfilter.org> <dbdd0cc00804150900r64924253g14e0d52a5d14ff1c@mail.gmail.com> <alpine.LNX.1.10.0804151921170.13202@fbirervta.pbzchgretzou.qr>
 <4806038C.6090502@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Rick Xu <rickxbx@gmail.com>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47357 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764807AbYDPOsr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Apr 2008 10:48:47 -0400
In-Reply-To: <4806038C.6090502@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-04-16 15:47, Pablo Neira Ayuso wrote:
>
>You seem to be more familiar with autostuff than me. I'd appreciate a
>patch for this. Thanks.

Index: configure.in
===================================================================
--- configure.in	(revision 7496)
+++ configure.in	(working copy)
@@ -1,10 +1,10 @@
 dnl Process this file with autoconf to create configure.
 
-AC_INIT
+AC_INIT(libnfnetlink, 0.0.34)
 
 AC_CANONICAL_SYSTEM
 
-AM_INIT_AUTOMAKE(libnfnetlink, 0.0.34)
+AM_INIT_AUTOMAKE
 
 AC_PROG_CC
 AC_EXEEXT
