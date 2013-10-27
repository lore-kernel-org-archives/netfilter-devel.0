From: Patrick McHardy <kaber@trash.net>
Subject: Re: conntrack, idle TCP connection and keep-alives
Date: Sun, 27 Oct 2013 19:32:44 +0000
Message-ID: <20131027193243.GA16338@macbook.localnet>
References: <526C22B8.5030102@torlan.ru>
 <20131027153408.GA20634@home>
 <20131027180129.GC27597@macbook.localnet>
 <20131027183825.GA17696@macbook.localnet>
 <alpine.DEB.2.10.1310272007460.7234@blackhole.kfki.hu>
 <20131027192019.GD32366@macbook.localnet>
 <526D6825.2090505@torlan.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Phil Oester <kernel@linuxace.com>,
	netfilter-devel@vger.kernel.org
To: WGH <wgh@torlan.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65262 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab3J0Tct (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Oct 2013 15:32:49 -0400
Content-Disposition: inline
In-Reply-To: <526D6825.2090505@torlan.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 27, 2013 at 11:23:17PM +0400, WGH wrote:
> On 27.10.2013 23:20, Patrick McHardy wrote:
> > On Sun, Oct 27, 2013 at 08:14:19PM +0100, Jozsef Kadlecsik wrote:
> >> I think a single flag could be sufficient: if the timer in conntrack goes 
> >> off and the entry is in the ESTABLISHED state and this flag is not set, 
> >> then send a TCP keepalive packet and start the timer with a short timeout. 
> >> If we receive the reply packet, then the long ESTABLISHED timeout value 
> >> can be restored and the flag cleared.
> > Sure, I think we wouldn't even need that flag, we can just send the keepalive
> > and set a short timeout. If a RST is received, the connection is killed
> > anyway, otherwise it will be refreshed with the ESTABLISHED timeout.
> >
> > But we do need a timestamp value to pass PAWS.
> I believe you forgot the third scenario: neither ACK nor RST is received
> in reply.

Actually no, "... and set a short timeout ...".
