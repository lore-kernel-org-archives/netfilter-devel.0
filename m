From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] bridge: netfilter: orphan skb before invoking ip
 netfilter hooks
Date: Sun, 27 Oct 2013 21:46:04 +0100
Message-ID: <20131027204604.GA9753@localhost>
References: <1382643162-20009-1-git-send-email-fw@strlen.de>
 <1382645650.7572.68.camel@edumazet-glaptop.roam.corp.google.com>
 <20131024210023.GA6543@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33269 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982Ab3J0UqJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Oct 2013 16:46:09 -0400
Content-Disposition: inline
In-Reply-To: <20131024210023.GA6543@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 24, 2013 at 11:00:23PM +0200, Florian Westphal wrote:
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
[...]
> > > it re-uses existing skb->sk if possible, assuming ->sk was set by
> > > tcp early demux.
> > 
> > s/tcp/ip/ since it also can work for UDP sockets in net-next
> 
> True.  Pablo, could you amend this bit if you decide to apply this
> to -next tree (i guess -next is fine)?

Amended and applied, thanks Florian!
