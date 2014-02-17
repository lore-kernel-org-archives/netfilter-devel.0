From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] netlink: meta: fix wrong type in attributes
Date: Mon, 17 Feb 2014 23:49:00 +0100
Message-ID: <20140217224859.GA19420@localhost>
References: <1392652085-8225-1-git-send-email-fw@strlen.de>
 <20140217172559.GA9866@macbook.localnet>
 <20140217210301.GI31125@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40446 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbaBQWtM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:49:12 -0500
Content-Disposition: inline
In-Reply-To: <20140217210301.GI31125@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 17, 2014 at 10:03:01PM +0100, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> > On Mon, Feb 17, 2014 at 04:48:05PM +0100, Florian Westphal wrote:
> > > We segfault on 'list filter' when meta expr is used as _u8
> > > returns invalid register 0.
> > 
> > This seems to only affect the master branch. Not sure how many people
> > are using that and if its worth doing a new release. I'd rather merge
> > the next-3.14 branch and have people use that.
> 
> I am now on 0545e0c13b as head but I still get segfault:
> 
> $ nft add rule filter output meta  mark set 42
> $ nft list table -> segv
> 
> .. and my patch should still apply afaics.

I'm going to apply your patch to master. Thanks Florian.
