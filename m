From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] netlink: meta: fix wrong type in attributes
Date: Tue, 18 Feb 2014 11:02:06 +0100
Message-ID: <20140218100206.GA4275@localhost>
References: <1392652085-8225-1-git-send-email-fw@strlen.de>
 <20140217172559.GA9866@macbook.localnet>
 <20140217210301.GI31125@breakpoint.cc>
 <20140218012705.GA12893@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43716 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030AbaBRKCP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:02:15 -0500
Content-Disposition: inline
In-Reply-To: <20140218012705.GA12893@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 18, 2014 at 01:27:08AM +0000, Patrick McHardy wrote:
> On Mon, Feb 17, 2014 at 10:03:01PM +0100, Florian Westphal wrote:
> > Patrick McHardy <kaber@trash.net> wrote:
> > > On Mon, Feb 17, 2014 at 04:48:05PM +0100, Florian Westphal wrote:
> > > > We segfault on 'list filter' when meta expr is used as _u8
> > > > returns invalid register 0.
> > > 
> > > This seems to only affect the master branch. Not sure how many people
> > > are using that and if its worth doing a new release. I'd rather merge
> > > the next-3.14 branch and have people use that.
> > 
> > I am now on 0545e0c13b as head but I still get segfault:
> > 
> > $ nft add rule filter output meta  mark set 42
> > $ nft list table -> segv
> > 
> > .. and my patch should still apply afaics.
> 
> Right, we've fixed that for other types. Please push your patch to master.
> 
> We should probably add a big warning to libnftnl for these cases or
> even an assert() since its misuse of the API that leads to hard to
> debug problems.

Indeed. I started a patch for that here but failed to find time so far
to finish it, it should help to catch wrong API uses.
