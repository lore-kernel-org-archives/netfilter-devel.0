From: Peter Korsgaard <jacmet@sunsite.dk>
Subject: Re: [PATCH] libxt_TCPMSS.c: unbreak build without ipv6 after ea2a02f7
Date: Fri, 22 Jul 2011 12:25:36 +0200
Message-ID: <874o2ezk67.fsf@macbook.be.48ers.dk>
References: <1311312260-16102-1-git-send-email-jacmet@sunsite.dk>
	<alpine.LNX.2.01.1107221157540.17453@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59874 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab1GVKZ6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Jul 2011 06:25:58 -0400
Received: by wwe5 with SMTP id 5so2057990wwe.1
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Jul 2011 03:25:57 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1107221157540.17453@frira.zrqbmnf.qr> (Jan
	Engelhardt's message of "Fri, 22 Jul 2011 11:59:38 +0200 (CEST)")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>>>>> "Jan" == Jan Engelhardt <jengelh@medozas.de> writes:

Hi,

 Jan> On Friday 2011-07-22 07:24, Peter Korsgaard wrote:
 >> ea2a02f7 (libxt_TCPMSS: use guided option parser) added an netinet/ip6.h
 >> include, which is not available on systems without ipv6.

 Jan> I can understand that some implementations omit symbols that are a 
 Jan> runtime dependency (such as in6addr_any) from the library, but structs 
 Jan> are for free, so what broken libc does forget those?

uClibc. It doesn't even install netinet/{ip6,icmp6}.h if ipv6 support
isn't enabled:

http://git.uclibc.org/uClibc/tree/Makefile.in#n249

 >> +#define IPHDRSIZE	20	/* sizeof(struct iphdr) */
 >> +#define IP6HDRSIZE	40	/* sizeof(struct ip6_hdr) */

 Jan> That would put a hard assumption on the implementation, which does
 Jan> not seem the right thing to do.

But those structs define the network format of ipv4 and ipv6 headers, so
they are not likely to change.

-- 
Bye, Peter Korsgaard
