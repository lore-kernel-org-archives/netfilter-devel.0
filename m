From: Chris Vine <chris@cvine.freeserve.co.uk>
Subject: Re: xt_recent fails with kernel 3.19.0
Date: Thu, 12 Feb 2015 21:34:10 +0000
Message-ID: <20150212213410.5a91da77@bother.homenet>
References: <20150212102553.0bd25767@bother.homenet>
	<20150212105145.5e0177c0@bother.homenet>
	<20150212110931.6db17d7c@bother.homenet>
	<20150212113643.GA13795@breakpoint.cc>
	<20150212115202.GD22887@breakpoint.cc>
	<20150212170412.2317d1e3@bother.homenet>
	<20150212170931.GF22887@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpout4.wanadoo.co.uk ([80.12.242.68]:35269 "EHLO
	smtpout.wanadoo.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbbBLVeH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2015 16:34:07 -0500
In-Reply-To: <20150212170931.GF22887@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 12 Feb 2015 18:09:31 +0100
Florian Westphal <fw@strlen.de> wrote:
[snip]
> > This patch seems to be doing
> > something different, and I note that nstamps_max_mask is
> > unconditionally set later in recent_mt_check() anyway.
> 
> No, its only set if recent_table_lookup returns NULL.
> We return soon after we bump the refcnt when we take this branch.

You probably are working on a more up-to-date branch.  Your patch
assigning to nstamps_max_mask is only executed if recent_table_lookup()
does not return NULL.  In the 3.19.0 kernel, the assignment to
nstamps_max_mask in line 404 also only occurs if recent_table_lookup()
does not return NULL.
 
> > Can the check for the value of hit_count simply be omitted?  In what
> > circumstances can it be anything other than true?
> 
> You mean when nstamp_mask > t->nstamps_max_mask is false?
> 
> e.g.
> iptables -A foo -m recent --hitcount 5
> iptables -A foo -m recent --hitcount 4
> 
> (2nd rule finds existing table with mask 7).

There's the rub I suspect, but as I say, I don't know your code.  Let's
leave it at that: if I apply the off-by-one patch it works for me
(provided I don't change settings, which I don't in ordinary usage).  I
will wait for whatever you and/or others come up with in due course to
solve it.

Chris
