From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 0/7] netfilter: ebtables: CONFIG_COMPAT support
Date: Mon, 8 Feb 2010 00:28:36 +0100
Message-ID: <20100207232836.GC27427@Chamillionaire.breakpoint.cc>
References: <alpine.LSU.2.01.1002050807580.16226@obet.zrqbmnf.qr>
 <20100205140021.GB21611@Chamillionaire.breakpoint.cc>
 <4B6C5231.7040702@pandora.be>
 <20100205.100241.17593999.davem@davemloft.net>
 <4B6D69D3.7050008@pandora.be>
 <20100207223802.GA27427@Chamillionaire.breakpoint.cc>
 <4B6F4A8E.4040507@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, netfilter-devel@vger.kernel.org
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:46187 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751298Ab0BGX2h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Feb 2010 18:28:37 -0500
Content-Disposition: inline
In-Reply-To: <4B6F4A8E.4040507@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bart De Schuymer <bdschuym@pandora.be> wrote:
> I think it's best to have the compat code in the fast path, since that's
> the code that will be needed in the future on those machines (I'll make
> the userspace workaround a compile-time option that is turned off by
> default in the next release of ebtables).
> Shouldn't it be possible for the compat code to know when a certain
> wrong size is due to the userspace workaround?
> If that situation is the
> case, then the compat code can execute the "native" getsockopt instead
> of producing a kernel error message...

This is what I plan to do in the next revision.

I'll send this particular change as a patch of its own
on top of the main compat hunk to ease review.

Thanks,
	Florian
