From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] [RFC] xt_owner: enable xt_owner on INPUT chain
Date: Fri, 30 Aug 2013 17:08:37 +0200
Message-ID: <20130830150837.GN32493@breakpoint.cc>
References: <1377866623-25948-1-git-send-email-valentina.giusti@bmw-carit.de>
 <20130830145437.GA7648@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: valentina.giusti@bmw-carit.de, netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:45378 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752653Ab3H3PIm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Aug 2013 11:08:42 -0400
Content-Disposition: inline
In-Reply-To: <20130830145437.GA7648@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Oester <kernel@linuxace.com> wrote:
> On Fri, Aug 30, 2013 at 02:43:42PM +0200, valentina.giusti@bmw-carit.de wrote:
> > I'm working on getting the owner extension also on the INPUT chain.
> > 
> > In the meanwhile, could anybody please give feedback and tell me if this is the
> > right direction?
> 
> What about the (common) case of no local socket?  I think that's why the owner
> match was restricted to output|postrouting in the first place, no?

No, it was restricted because skb->sk is only set for locally generated
outgoing packets.  As Valentina explained, with tcp early demux skb->sk
will already be set for incoming tcp packets when the packet traverses
the INPUT chain.
