From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH nft userspace] nft: connlabel matching support
Date: Sun, 16 Feb 2014 20:41:05 +0000
Message-ID: <20140216204104.GA21419@macbook.localnet>
References: <1392504432-20918-1-git-send-email-fw@strlen.de>
 <20140216085319.GA26751@macbook.localnet>
 <20140216110152.GD28751@breakpoint.cc>
 <20140216111252.GA29491@macbook.localnet>
 <20140216165957.GA2408@breakpoint.cc>
 <20140216172339.GA18357@macbook.localnet>
 <20140216175132.GB2408@breakpoint.cc>
 <544ec23c-621a-456c-9e65-ea67703f7aee@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42572 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbaBPUlK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Feb 2014 15:41:10 -0500
Content-Disposition: inline
In-Reply-To: <544ec23c-621a-456c-9e65-ea67703f7aee@email.android.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Feb 16, 2014 at 05:53:33PM +0000, Patrick McHardy wrote:
> On 16. Februar 2014 17:51:32 GMT+00:00, Florian Westphal <fw@strlen.de> wrote:
> >> > As a side note, experimenting a bit with tcp flags:
> >> > 
> >> > add rule filter output tcp flags & (syn|ack) == (syn|ack)
> >> > 
> >> > works fine with current master branch.  But list shows
> >> > 
> >> > "tcp flags & 18 == 18", i.e. no symbol translation.
> >> > 
> >> > Shouldn't it restore the symbolic names?
> >> > I think this is the very same problem that I had with my connlabel
> >> > dabbling, so it would be nice if it could be solved in generic way.
> >> 
> >> Most likely. Please see if the attached patch solves this.
> >
> >No:
> >add rule filter output tcp flags & (syn|ack) == (syn|ack)
> >list table filter
> >tcp flags & 18 == 18
> >
> >The expression works.
> 
> I'll look into it in about an hour.

It requires a bit more work. I'm half way through, but if this is holding
you up, I'd suggest to just proceed as if it were working already.
