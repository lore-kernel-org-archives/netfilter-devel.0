From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [libnfacct PATCH] Add include needed for integer types
 definition.
Date: Sun, 4 Nov 2012 18:10:48 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1211041808430.22736@nerf07.vanv.qr>
References: <1352022711.11805.8.camel@tourtet> <1352022852-29382-1-git-send-email-eric@regit.org> <1352022852-29382-2-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:54935 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab2KDRKu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 Nov 2012 12:10:50 -0500
In-Reply-To: <1352022852-29382-2-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2012-11-04 10:54, Eric Leblond wrote:

>---
> include/libnetfilter_acct/libnetfilter_acct.h |    1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/include/libnetfilter_acct/libnetfilter_acct.h b/include/libnetfilter_acct/libnetfilter_acct.h
>index a326c3c..48fe8f4 100644
>--- a/include/libnetfilter_acct/libnetfilter_acct.h
>+++ b/include/libnetfilter_acct/libnetfilter_acct.h
>@@ -2,6 +2,7 @@
> #define _LIBNETFILTER_ACCT_H_
> 
> #include <sys/types.h>
>+#include <inttypes.h>
> #include <linux/netfilter/nfnetlink_acct.h>

The intXX_t pieces are standardized in <stdint.h>
(Or, to cater for C++,

#if defined(__cplusplus) && \
    (__cplusplus >= 201100L || defined(__GXX_EXPERIMENTAL_CXX0X__))
#	include <cstdint>
#else
#	include <stdint.h>
#endif

