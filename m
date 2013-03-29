From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH iptables] nfnl_osf: use the right nfnetlink lib
Date: Fri, 29 Mar 2013 16:20:37 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1303291620200.11529@nerf07.vanv.qr>
References: <1364566870-7320-1-git-send-email-nicolas.dichtel@6wind.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:46806 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754333Ab3C2PUj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Mar 2013 11:20:39 -0400
In-Reply-To: <1364566870-7320-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2013-03-29 15:21, Nicolas Dichtel wrote:

>If the user specify libnfnetlink_LIBS during the configure, we must use it.
>
>Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>---
> utils/Makefile.am | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/utils/Makefile.am b/utils/Makefile.am
>index f1bbfc5..8a85396 100644
>--- a/utils/Makefile.am
>+++ b/utils/Makefile.am
>@@ -7,4 +7,4 @@ AM_CPPFLAGS = ${regular_CPPFLAGS} -I${top_builddir}/include \
> sbin_PROGRAMS = nfnl_osf
> pkgdata_DATA = pf.os
> 
>-nfnl_osf_LDADD = -lnfnetlink
>+nfnl_osf_LDADD = ${libnfnetlink_LIBS} -lnfnetlink

You really should remove -lnfnetlink :)
