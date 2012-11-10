From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: UDP packets sent with wrong source address after routing
 change [AV#3431]
Date: Sat, 10 Nov 2012 15:07:20 +0100
Message-ID: <20121110140720.GA9610@1984>
References: <alpine.DEB.2.02.1211081627150.6644@lap-x201>
 <alpine.LNX.2.01.1211081829150.28568@nerf07.vanv.qr>
 <alpine.DEB.2.00.1211081823030.5637@chris-desktop.fen.aptivate.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
To: Chris Wilson <chris@aptivate.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36683 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356Ab2KJOHb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 10 Nov 2012 09:07:31 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1211081823030.5637@chris-desktop.fen.aptivate.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 08, 2012 at 06:37:24PM +0000, Chris Wilson wrote:
[...]
> >>Another option which doesn't violate layering might be to update
> >>the NAT rule when the outgoing address is known (after routing),
> >
> >That is what MASQUERADE is usually for.
> 
> Unfortunately I am using MASQUERADE and this still happens. If it
> could just be fixed in the MASQUERADE target that would be a big
> win.

MASQUERADE already cleans up the entries in the conntrack table once
you get your device down, that code is still there in 2.6.18:

http://lxr.linux.no/#linux+v2.6.18/net/ipv4/netfilter/ipt_MASQUERADE.c#L111
