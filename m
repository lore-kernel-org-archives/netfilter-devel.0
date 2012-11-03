From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 1/4] Add configure flag to disable NFACCT build
Date: Sat, 3 Nov 2012 17:02:22 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1211031702030.15964@nerf07.vanv.qr>
References: <1351942382-24791-1-git-send-email-eric@regit.org>  <1351942382-24791-2-git-send-email-eric@regit.org>  <alpine.LNX.2.01.1211031537300.14935@nerf07.vanv.qr> <1351958461.11805.1.camel@tourtet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:49868 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756390Ab2KCQC2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 Nov 2012 12:02:28 -0400
In-Reply-To: <1351958461.11805.1.camel@tourtet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2012-11-03 17:01, Eric Leblond wrote:
>> >+AS_IF([test "x$enable_nfacct" = "xyes"], [
>> >+    PKG_CHECK_MODULES([LIBNETFILTER_ACCT], [libnetfilter_acct >= 1.0.1])
>> >+    AC_DEFINE([BUILD_NFACCT], [1], [Building nfacct module])
>> >+])
>> >+AM_CONDITIONAL([BUILD_NFACCT], [test "x$enable_nfacct" = "xyes"])

>> As far as I remember, AM conditionals do not automatically
>> become C macros. Can you check config.h?
>
>Yeah, that's why I've added AC_DEFINE when the module is built.

I completely missed that. Sorry for the noise.
