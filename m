From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_nat: fix race when unloading protocol
 modules
Date: Fri, 12 Apr 2013 12:13:13 +0200
Message-ID: <20130412101313.GA6967@localhost>
References: <1365690159-31122-1-git-send-email-fw@strlen.de>
 <20130411144404.GA12554@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44952 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab3DLKNT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Apr 2013 06:13:19 -0400
Content-Disposition: inline
In-Reply-To: <20130411144404.GA12554@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 11, 2013 at 04:44:05PM +0200, Patrick McHardy wrote:
> On Thu, Apr 11, 2013 at 04:22:39PM +0200, Florian Westphal wrote:
> > following oops was reported:
> > RIP: 0010:[<ffffffffa03227f2>]  [<ffffffffa03227f2>] nf_nat_cleanup_conntrack+0x42/0x70 [nf_nat]
> > RSP: 0018:ffff880202c63d40  EFLAGS: 00010246
> > RAX: 0000000000000000 RBX: ffff8801ac7bec28 RCX: ffff8801d0eedbe0
> > RDX: dead000000200200 RSI: 0000000000000011 RDI: ffffffffa03265b8
> > [..]
> > Call Trace:
> >  [..]
> >  [<ffffffffa02febed>] destroy_conntrack+0xbd/0x110 [nf_conntrack]
> > 
> > Happens when a conntrack timeout expires right after first part
> > of the nat cleanup has completed (bysrc hash removal), but before
> > part 2 has completed (re-initialization of nat area).
> > 
> > [ destroy callback tries to delete bysrc again ]
> > 
> > Patrick suggested to just remove the affected conntracks -- the
> > connections won't work properly anyway without nat transformation.
> > 
> > So, lets do that.
> > 
> > Reported-by: CAI Qian <caiqian@redhat.com>
> > Cc: Patrick McHardy <kaber@trash.net>
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> Looks good to me.
> 
> Acked-by: Patrick McHardy <kaber@trash.net>

Applied, thanks!
