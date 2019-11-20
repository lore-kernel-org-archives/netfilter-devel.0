Return-Path: <SRS0=UIY/=ZM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9291C432C0
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 12:53:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F8E32251D
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 12:53:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728457AbfKTMxL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Nov 2019 07:53:11 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:38662 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727644AbfKTMxL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Nov 2019 07:53:11 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iXPTo-0000BP-Qr; Wed, 20 Nov 2019 13:53:08 +0100
Date:   Wed, 20 Nov 2019 13:53:08 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?utf-8?Q?J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>
Subject: Re: [PATCH nft 2/3] src: Add support for concatenated set ranges
Message-ID: <20191120125308.GK8016@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?utf-8?Q?J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>
References: <20191119010712.39316-1-sbrivio@redhat.com>
 <20191119010712.39316-3-sbrivio@redhat.com>
 <20191119221238.GF8016@orbyte.nwl.cc>
 <20191120124954.0740a1a5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120124954.0740a1a5@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, Nov 20, 2019 at 12:49:54PM +0100, Stefano Brivio wrote:
> On Tue, 19 Nov 2019 23:12:38 +0100
> Phil Sutter <phil@nwl.cc> wrote:
> > On Tue, Nov 19, 2019 at 02:07:11AM +0100, Stefano Brivio wrote:
> > [...]
> > > diff --git a/src/netlink.c b/src/netlink.c
> > > index 7306e358..b8bfd199 100644
> > > --- a/src/netlink.c
> > > +++ b/src/netlink.c  
> > [...]
> > > @@ -199,10 +210,39 @@ static void netlink_gen_concat_data(const struct expr *expr,
> > >  		memset(data, 0, sizeof(data));
> > >  		offset = 0;
> > >  		list_for_each_entry(i, &expr->expressions, list) {
> > > -			assert(i->etype == EXPR_VALUE);
> > > -			mpz_export_data(data + offset, i->value, i->byteorder,
> > > -					div_round_up(i->len, BITS_PER_BYTE));
> > > -			offset += netlink_padded_len(i->len) / BITS_PER_BYTE;
> > > +			if (i->etype == EXPR_RANGE) {
> > > +				const struct expr *e;
> > > +
> > > +				if (is_range_end)
> > > +					e = i->right;
> > > +				else
> > > +					e = i->left;
> > > +
> > > +				offset += netlink_export_pad(data + offset,
> > > +							     e->value, e);
> > > +			} else if (i->etype == EXPR_PREFIX) {
> > > +				if (is_range_end) {
> > > +					mpz_t v;
> > > +
> > > +					mpz_init_bitmask(v, i->len -
> > > +							    i->prefix_len);
> > > +					mpz_add(v, i->prefix->value, v);
> > > +					offset += netlink_export_pad(data +
> > > +								     offset,
> > > +								     v, i);  
> > 
> > Given the right-alignment, maybe introduce __netlink_gen_concat_data()
> > to contain the loop body?
> 
> While at it, I would also drop the if (1) that makes this function not
> so pretty. It was introduced by 53fc2c7a7998 ("netlink: move data
> related functions to netlink.c") where data was turned from a allocated
> buffer to VLA, but I don't see a reason why we can't do:
> 
> 	unsigned int len = expr->len / BITS_PER_BYTE, offset = 0;
> 	unsigned char data[len];

ACK!

> So, the whole thing would look like (together with the other change
> you suggest):
> 
> --
> static int netlink_gen_concat_data_expr(const struct expr *i,
> 					unsigned char *data)
> {
> 	if (i->etype == EXPR_RANGE) {
> 		const struct expr *e;
> 
> 		if (i->flags & EXPR_F_INTERVAL_END)
> 			e = i->right;
> 		else
> 			e = i->left;
> 
> 		return netlink_export_pad(data, e->value, e);
> 	}
> 
> 	if (i->etype == EXPR_PREFIX) {
> 		if (i->flags & EXPR_F_INTERVAL_END) {
> 			int count;
> 			mpz_t v;
> 
> 			mpz_init_bitmask(v, i->len - i->prefix_len);
> 			mpz_add(v, i->prefix->value, v);
> 			count = netlink_export_pad(data, v, i);
> 			mpz_clear(v);
> 			return count;
> 		}
> 
> 		return netlink_export_pad(data, i->prefix->value, i);
> 	}
> 
> 	assert(i->etype == EXPR_VALUE);
> 
> 	return netlink_export_pad(data, i->value, i);
> }

I would even:

| static int
| netlink_gen_concat_data_expr(const struct expr *i, unsigned char *data)
| {
| 	mpz_t *valp = NULL;
| 
| 	switch (i->etype) {
| 	case EXPR_RANGE:
| 		i = (i->flags & EXPR_F_INTERVAL_END) ? i->right : i->left;
| 		break;
| 	case EXPR_PREFIX:
| 		if (i->flags & EXPR_F_INTERVAL_END) {
| 			int count;
| 			mpz_t v;
| 
| 			mpz_init_bitmask(v, i->len - i->prefix_len);
| 			mpz_add(v, i->prefix->value, v);
| 			count = netlink_export_pad(data, v, i);
| 			mpz_clear(v);
| 			return count;
| 		}
| 		valp = &i->prefix->value;
| 		break;
| 	case EXPR_VALUE:
| 		break;
| 	default:
| 		BUG("invalid expression type '%s' in set", expr_ops(i)->name);
| 	}
| 
| 	return netlink_export_pad(data, valp ? *valp : i->value, i);
| }

But that's up to you. :)

> static void netlink_gen_concat_data(const struct expr *expr,
> 				    struct nft_data_linearize *nld)
> {
> 	unsigned int len = expr->len / BITS_PER_BYTE, offset = 0;
> 	unsigned char data[len];
> 	const struct expr *i;
> 
> 	memset(data, 0, len);
> 
> 	list_for_each_entry(i, &expr->expressions, list)
> 		offset += netlink_gen_concat_data_expr(i, data + offset);
> 
> 	memcpy(nld->value, data, len);
> 	nld->len = len;
> }
> --
> 
> Is that better?

Looks great, thanks!

[...]
> > So this is the fifth copy of the same piece of code. :(
> > 
> > Isn't there a better way to solve that?
> 
> I couldn't think of any.

I guess we would need an intermediate state which is 'multiton_rhs_expr
DOT multiton_rhs_expr'. Might turn into a mess as well. :)

> > If not, we could at least introduce a function compound_expr_alloc_or_add().
> 
> Right, added. The only ugly aspect is that we also need to update the
> location of $3 here, and I don't think we should export
> location_update() from parser_bison.y, so this function needs to be in
> parser_byson.y itself, I guess.

Yes, that's fine with me. It's just my c'n'p aversion which got worse
when spending time with iptables code.

[..]
> > > -	if (set->flags & NFT_SET_INTERVAL &&
> > > +	if (set->flags & NFT_SET_INTERVAL && !(set->flags & NFT_SET_SUBKEY) &&  
> > 
> > Maybe introduce set_is_non_concat_range() or something? Maybe even a
> > macro, it's just about:
> > 
> > | return set->flags & (NFT_SET_INTERVAL | NFT_SET_SUBKEY) == NFT_SET_INTERVAL;
> 
> I'm adding that as static inline together with the other set_is_*()
> functions in rule.h, it looks consistent.

ACK!

[...]
> > I don't understand this algorithm.
> 
> It basically does the same thing as the function you wrote below, but
> instead of shifting 'start' and 'end', 'step' is increased, and set
> onto them, so that at every iteration we have the resulting mask
> available in 'base'.
> 
> That's not actually needed here, though. It's a left-over from a
> previous idea of generating composing netmasks in nftables rather than
> in the set. I'll switch to the "obvious" implementation.
> 
> > Intuitively, I would just:
> > 
> > | int tmp = len;
> > | while (start != end && !(start & 1) && (end & 1) && tmp) {
> > |	start >>= 1;
> > |	end >>= 1;
> > |	tmp--;
> > | }
> > | return (tmp && start == end) ? len - tmp : -1;
> > 
> > Is that slow when dealing with gmp?
> 
> I don't think so, it also avoid copies and allocations, while shifting
> and setting bits have comparable complexities. I'd go with the gmp
> version of this.

OK, thanks for explaining!

Cheers, Phil
