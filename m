From: Florian Westphal <fw@strlen.de>
Subject: Re: xt_recent fails with kernel 3.19.0
Date: Thu, 12 Feb 2015 22:40:30 +0100
Message-ID: <20150212214030.GH22887@breakpoint.cc>
References: <20150212102553.0bd25767@bother.homenet>
 <20150212105145.5e0177c0@bother.homenet>
 <20150212110931.6db17d7c@bother.homenet>
 <20150212113643.GA13795@breakpoint.cc>
 <20150212115202.GD22887@breakpoint.cc>
 <20150212170412.2317d1e3@bother.homenet>
 <20150212170931.GF22887@breakpoint.cc>
 <20150212213410.5a91da77@bother.homenet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Chris Vine <chris@cvine.freeserve.co.uk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:46601 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751199AbbBLVkc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2015 16:40:32 -0500
Content-Disposition: inline
In-Reply-To: <20150212213410.5a91da77@bother.homenet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Chris Vine <chris@cvine.freeserve.co.uk> wrote:
> On Thu, 12 Feb 2015 18:09:31 +0100
> Florian Westphal <fw@strlen.de> wrote:
> [snip]
> > > This patch seems to be doing
> > > something different, and I note that nstamps_max_mask is
> > > unconditionally set later in recent_mt_check() anyway.
> > 
> > No, its only set if recent_table_lookup returns NULL.
> > We return soon after we bump the refcnt when we take this branch.
> 
> You probably are working on a more up-to-date branch.  Your patch
> assigning to nstamps_max_mask is only executed if recent_table_lookup()
> does not return NULL.  In the 3.19.0 kernel, the assignment to
> nstamps_max_mask in line 404 also only occurs if recent_table_lookup()
> does not return NULL.

Thats what I meant -- line 404 is ONLY executed if the table doesn't
exist, so we need to assign it in case we have a table and we want
to increase the upper limit of the _existing_ table.

Unless someone spots an issue with this approach i'll submit this
formally tomorrow.
