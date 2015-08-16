From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] tests: validate generated netlink instructions
Date: Sun, 16 Aug 2015 19:30:03 +0100
Message-ID: <20150816183002.GF17659@macbook.localdomain>
References: <1437096699-8832-1-git-send-email-fw@strlen.de>
 <20150720125004.GA7402@salvia>
 <20150720151046.GD11985@breakpoint.cc>
 <20150720170538.GA22735@salvia>
 <20150720183536.GE11985@breakpoint.cc>
 <20150812173453.GA30926@salvia>
 <20150812174624.GA31166@breakpoint.cc>
 <20150816181439.GD17659@macbook.localdomain>
 <20150816182059.GD31357@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52333 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbbHPSaI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Aug 2015 14:30:08 -0400
Content-Disposition: inline
In-Reply-To: <20150816182059.GD31357@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16.08, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> > I also have patches for this, but some corner cases and not working correctly
> > yet. I'm looking forward to your patches.
> 
> Any example?
> 
> I'm curious to see if my patches handles those :-)

Unfortunately not right now, new notebook and the data is not fully synced yet :)

My general approach is to generate shift expressions for data that is not byte
aligned, then have the shifts transfered to the constant side during bitop eval.

The cases which do not work fully correctly are those where the length of the
constant side needs to be increased to contain the shifted value. It will
incorrectly accept too large values for the field in question. F.i.
ip totlength is 4 bit wide and needs to be shifted by 4 bit, so my simple
approach of adding 4 to expr->len will allow values up to 255 from the user.

I'll send my patches over tommorrow so you can see if there's anything you
can use :)
