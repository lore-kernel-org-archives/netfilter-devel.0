From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] libxt_TCPMSS.c: unbreak build without ipv6 after
 ea2a02f7
Date: Fri, 22 Jul 2011 12:31:04 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1107221227180.4330@frira.zrqbmnf.qr>
References: <1311312260-16102-1-git-send-email-jacmet@sunsite.dk> <alpine.LNX.2.01.1107221157540.17453@frira.zrqbmnf.qr> <874o2ezk67.fsf@macbook.be.48ers.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Peter Korsgaard <jacmet@sunsite.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:52225 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab1GVKbF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Jul 2011 06:31:05 -0400
In-Reply-To: <874o2ezk67.fsf@macbook.be.48ers.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-07-22 12:25, Peter Korsgaard wrote:

> >> +#define IPHDRSIZE	20	/* sizeof(struct iphdr) */
> >> +#define IP6HDRSIZE	40	/* sizeof(struct ip6_hdr) */
>
> Jan> That would put a hard assumption on the implementation, which does
> Jan> not seem the right thing to do.
>
>But those structs define the network format of ipv4 and ipv6 headers, so
>they are not likely to change.

I was pondering on a hypothetical implementation with CHAR_BIT=16.

How about 
http://dev.medozas.de/gitweb.cgi?p=iptables;a=commitdiff;h=4d8656ad9d0afd04820f125a85a7b673c7e74fe6
