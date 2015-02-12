From: Florian Westphal <fw@strlen.de>
Subject: Re: xt_recent fails with kernel 3.19.0
Date: Thu, 12 Feb 2015 12:36:43 +0100
Message-ID: <20150212113643.GA13795@breakpoint.cc>
References: <20150212102553.0bd25767@bother.homenet>
 <20150212105145.5e0177c0@bother.homenet>
 <20150212110931.6db17d7c@bother.homenet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Chris Vine <chris@cvine.freeserve.co.uk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:45397 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752691AbbBLLgp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2015 06:36:45 -0500
Content-Disposition: inline
In-Reply-To: <20150212110931.6db17d7c@bother.homenet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Chris Vine <chris@cvine.freeserve.co.uk> wrote:
> > > info->name); if (t != NULL) {
> > > -		if (info->hit_count > t->nstamps_max_mask) {
> > > +		if (info->hit_count > t->nstamps_max_mask + 1) {
> > >  			pr_info("hitcount (%u) is larger than
> > > packets to be remembered (%u) for table %s\n", info->hit_count,
> > > t->nstamps_max_mask + 1, info->name);
> > 
> > Scrub that.  This now fails when SSH_TRIES is set to other than a
> > power of two boundary.  There seems to be something fundamentally
> > wrong with the heuristic employed here.
> 
> On more testing I am wrong about that.  You seem to need to rmmod
> xt_recent to get it to flush the previous setting.  With that done, the
> patch does indeed seem to work with any values of SSH_TRIES.

Grrr.  Right.  This is because if you have single

-m recent  --name DEFAULT ..

iptables-save > foo
then edit foo to bump the hitcount, then run
iptables-restore < foo

we'll find the existing DEFAULT entry with the old hitcount.

It works for something like 11 -> 13 since we're internally
tracking a count of 16 (mask 15).

I don't see a simple fix except your patch above plus

-static unsigned int ip_pkt_list_tot __read_mostly;
+static unsigned int ip_pkt_list_tot __read_mostly = 32;

To work around this.
This causes us to ignore hitcount in the check completely, at additional
memory cost.

I'll see if we can fix this in a better way.
