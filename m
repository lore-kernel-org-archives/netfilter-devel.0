From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH -next] Revert "netfilter: tproxy: do not assign
 timewait sockets to skb->sk"
Date: Thu, 20 Jun 2013 12:36:17 +0200
Message-ID: <20130620103617.GF2124@breakpoint.cc>
References: <1369792719-3945-1-git-send-email-fw@strlen.de>
 <20130620102234.GA19823@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:36127 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757733Ab3FTKgT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:36:19 -0400
Content-Disposition: inline
In-Reply-To: <20130620102234.GA19823@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, May 29, 2013 at 03:58:39AM +0200, Florian Westphal wrote:
> > This reverts commit d503b30bd648b3cb4e5f50b65d27e389960cc6d9.
> > 
> > Nowadays we have early socket demux; all the input code paths
> > should handle "skb->sk points to timewait sock" properly.
> 
> I'm fine with this but I think that we should have some nf_sock_put
> definition somewhere else. Using the tproxy namespace from xt_socket
> doesn't seem nice to me.

I'll respin this revert to use sock_edemux() in its place instead,
afaics we should be able to use that as replacement.

Thanks.
