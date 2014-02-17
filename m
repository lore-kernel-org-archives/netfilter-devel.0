From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] netlink: meta: fix wrong type in attributes
Date: Mon, 17 Feb 2014 22:03:01 +0100
Message-ID: <20140217210301.GI31125@breakpoint.cc>
References: <1392652085-8225-1-git-send-email-fw@strlen.de>
 <20140217172559.GA9866@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50502 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751100AbaBQVDC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:03:02 -0500
Content-Disposition: inline
In-Reply-To: <20140217172559.GA9866@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> On Mon, Feb 17, 2014 at 04:48:05PM +0100, Florian Westphal wrote:
> > We segfault on 'list filter' when meta expr is used as _u8
> > returns invalid register 0.
> 
> This seems to only affect the master branch. Not sure how many people
> are using that and if its worth doing a new release. I'd rather merge
> the next-3.14 branch and have people use that.

I am now on 0545e0c13b as head but I still get segfault:

$ nft add rule filter output meta  mark set 42
$ nft list table -> segv

.. and my patch should still apply afaics.
