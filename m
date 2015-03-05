From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3] netfilter: nf_tables: check for overflow of rule
 dlen field
Date: Thu, 5 Mar 2015 17:13:53 +0000
Message-ID: <20150305171352.GD29092@acer.localdomain>
References: <1425413060-6187-1-git-send-email-kaber@trash.net>
 <1425413060-6187-3-git-send-email-kaber@trash.net>
 <20150305163127.GA6878@salvia>
 <20150305163122.GW29092@acer.localdomain>
 <20150305171150.GA7275@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62055 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757757AbbCERN7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Mar 2015 12:13:59 -0500
Content-Disposition: inline
In-Reply-To: <20150305171150.GA7275@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05.03, Pablo Neira Ayuso wrote:
> > > Should we use -EOVERFLOW instead as we use in other nf_tables spots?
> > > 
> > > The error in userspace will be: "Value too large for defined data type".
> > 
> > I think the difference here is that we don't use a userspace provided
> > value but overflow because of the size of kernel internal structures and
> > the data type limit.
> 
> OK, we also have it when we pass too large amount of data for a
> register IIRC.

Sure. But that's data we pass, in that size. In this case its data
the kernel allocates, the amount of which is defined purely by
the kernel.

> > I don't have any strong feelings either way, but I think its different
> > from the cases where we use EOVERFLOW so far.
> 
> I don't have any strong opinion, just asking. You know we shouldn't
> change this afterwards.
> 
> Let me know.

I think this case shouldn't exist at all since it codifies kernel
internals into the API. Today we might accept 128 expressions, the
other day just 100, all depending on 32 or 64 bit systems. Its not
good.

The problem is I also don't want to increase the maximum rule size
to more than 4k since this will run into issues with memory
fragmentation. I think we need to decrease NFT_EXPR_MAXNUM, its
unreasonable large, and then add a per expression maximum size.

For now I'd say apply it as it is, keep the different errno code
since its a really different case, and we'll fix up the underlying
problem after a bit more of thought.
