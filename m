From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: ipsec nat issue
Date: Fri, 12 Oct 2012 22:28:41 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1210122226130.11967@nerf07.vanv.qr>
References: <50787C14.7060009@earthlink.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Stephen Clark <sclark46@earthlink.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:54329 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab2JLU2n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Oct 2012 16:28:43 -0400
In-Reply-To: <50787C14.7060009@earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2012-10-12 22:22, Stephen Clark wrote:

> Hello,
>
> I have the following setup:
>
> ipsec tunnel 10.255.3.128/25 - pub add1 <-> pub add2 - 10.255.5.128/25
>
> trying to SNAT remote private address 10.255.5.128/25 to make it appear like it
> was local 10.255.3.254

The left endpoint has 10.255.3.128/25 declared as local, so if the left 
side is to respond to packets which have 10.255.3.254 as source address, 
that reply will be delivered on its own side (the left side), and never 
the tunnel.

This is like trying to SNAT all your home traffic that is supposed to go 
to the internet to 192.168.1.1 -- unroutable for the Internet.
