From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] libxt_TCPMSS.c: unbreak build without ipv6 after
 ea2a02f7
Date: Fri, 22 Jul 2011 11:59:38 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1107221157540.17453@frira.zrqbmnf.qr>
References: <1311312260-16102-1-git-send-email-jacmet@sunsite.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Peter Korsgaard <jacmet@sunsite.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38097 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564Ab1GVJ7j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Jul 2011 05:59:39 -0400
In-Reply-To: <1311312260-16102-1-git-send-email-jacmet@sunsite.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-07-22 07:24, Peter Korsgaard wrote:

>ea2a02f7 (libxt_TCPMSS: use guided option parser) added an netinet/ip6.h
>include, which is not available on systems without ipv6.

I can understand that some implementations omit symbols that are a 
runtime dependency (such as in6addr_any) from the library, but structs 
are for free, so what broken libc does forget those?

>+#define IPHDRSIZE	20	/* sizeof(struct iphdr) */
>+#define IP6HDRSIZE	40	/* sizeof(struct ip6_hdr) */

That would put a hard assumption on the implementation, which does not 
seem the right thing to do.
