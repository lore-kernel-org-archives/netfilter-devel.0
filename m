From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_tables: add optional user data area to
 rules
Date: Wed, 26 Feb 2014 13:42:46 +0100
Message-ID: <20140226124246.GA5253@localhost>
References: <1393379592-16312-1-git-send-email-pablo@netfilter.org>
 <20140226120506.GC24874@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55139 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbaBZMmz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Feb 2014 07:42:55 -0500
Content-Disposition: inline
In-Reply-To: <20140226120506.GC24874@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 26, 2014 at 12:05:06PM +0000, Patrick McHardy wrote:
> On Wed, Feb 26, 2014 at 02:53:12AM +0100, Pablo Neira Ayuso wrote:
> > This allows us to store user comment strings, but it could be also
> > used to store any kind of information that the user application needs
> > to link to the rule.
> > 
> >  struct nft_rule {
> >  	struct list_head		list;
> > -	u64				handle:46,
> > -					genmask:2,
> > -					dlen:16;
> > +	u64				handle;
> > +	u32				dlen;
> > +	u32				genmask:2,
> > +					ulen:30;
> 
> This increases the size of the rule by 8 bytes.

Yup, spent some minutes in front of this but I didn't find a better
way.

> I'd suggest to scrape that off elsewhere. First of all, we probably
> don't need 16 bytes for the rule length, 12 == 4k should be enough.

Considered that, but my main concern was the xtables compatibility
layer. I guess 4K is fine in terms of matches/target there. Assuming
120 bytes per match, we get 34, which sounds quite a lot.

Good, I think we can scratch those 4 bits.

> The other 4 bits could be taken from the handle I suppose, 2^42
> should still be enough. Assuming 1000 new rules per second it would
> still last for 139 years :)

Ah good too. Someone else will have to fix this by that time, I
already reserved a deckchair with popcorns in Mars for year 2153.

Will send a v2. Thanks.
