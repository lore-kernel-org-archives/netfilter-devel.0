Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D65F8C432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 17:58:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B541F2068F
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 17:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfKUR6J (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 12:58:09 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:41782 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726279AbfKUR6J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 12:58:09 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iXqiV-0006fW-Gx; Thu, 21 Nov 2019 18:58:07 +0100
Date:   Thu, 21 Nov 2019 18:58:07 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?utf-8?Q?J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>
Subject: Re: [PATCH nft 2/3] src: Add support for concatenated set ranges
Message-ID: <20191121175807.GF3074@orbyte.nwl.cc>
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
 <20191120125308.GK8016@orbyte.nwl.cc>
 <20191121180938.381eabab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121180938.381eabab@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, Nov 21, 2019 at 06:09:38PM +0100, Stefano Brivio wrote:
> On Wed, 20 Nov 2019 13:53:08 +0100
> Phil Sutter <phil@nwl.cc> wrote:
> 
> > On Wed, Nov 20, 2019 at 12:49:54PM +0100, Stefano Brivio wrote:
> >
> > > On Tue, 19 Nov 2019 23:12:38 +0100
> > > Phil Sutter <phil@nwl.cc> wrote:
> > [...]
> >
> > > So, the whole thing would look like (together with the other change
> > > you suggest):
> > > 
> > > --
> > > static int netlink_gen_concat_data_expr(const struct expr *i,
> > > 					unsigned char *data)
> > > {
> > > 	if (i->etype == EXPR_RANGE) {
> > > 		const struct expr *e;
> > > 
> > > 		if (i->flags & EXPR_F_INTERVAL_END)
> > > 			e = i->right;
> > > 		else
> > > 			e = i->left;
> > > 
> > > 		return netlink_export_pad(data, e->value, e);
> > > 	}
> > > 
> > > 	if (i->etype == EXPR_PREFIX) {
> > > 		if (i->flags & EXPR_F_INTERVAL_END) {
> > > 			int count;
> > > 			mpz_t v;
> > > 
> > > 			mpz_init_bitmask(v, i->len - i->prefix_len);
> > > 			mpz_add(v, i->prefix->value, v);
> > > 			count = netlink_export_pad(data, v, i);
> > > 			mpz_clear(v);
> > > 			return count;
> > > 		}
> > > 
> > > 		return netlink_export_pad(data, i->prefix->value, i);
> > > 	}
> > > 
> > > 	assert(i->etype == EXPR_VALUE);
> > > 
> > > 	return netlink_export_pad(data, i->value, i);
> > > }  
> > 
> > I would even:
> > 
> > | static int
> > | netlink_gen_concat_data_expr(const struct expr *i, unsigned char *data)
> > | {
> > | 	mpz_t *valp = NULL;
> > | 
> > | 	switch (i->etype) {
> > | 	case EXPR_RANGE:
> > | 		i = (i->flags & EXPR_F_INTERVAL_END) ? i->right : i->left;
> > | 		break;
> > | 	case EXPR_PREFIX:
> > | 		if (i->flags & EXPR_F_INTERVAL_END) {
> > | 			int count;
> > | 			mpz_t v;
> > | 
> > | 			mpz_init_bitmask(v, i->len - i->prefix_len);
> > | 			mpz_add(v, i->prefix->value, v);
> > | 			count = netlink_export_pad(data, v, i);
> > | 			mpz_clear(v);
> > | 			return count;
> > | 		}
> > | 		valp = &i->prefix->value;
> > | 		break;
> > | 	case EXPR_VALUE:
> > | 		break;
> > | 	default:
> > | 		BUG("invalid expression type '%s' in set", expr_ops(i)->name);
> > | 	}
> > | 
> > | 	return netlink_export_pad(data, valp ? *valp : i->value, i);
> > | }
> > 
> > But that's up to you. :)
> 
> I think it's nicer with a switch and that BUG() is more helpful than a
> random assert, but I personally find that ternary condition on valp a
> bit difficult to follow.

Yes, I overdid it a bit there trying to have a single call to
netlink_export_pad(). You found a good middle-ground!

[...]
> > > > So this is the fifth copy of the same piece of code. :(
> > > > 
> > > > Isn't there a better way to solve that?  
> > > 
> > > I couldn't think of any.  
> > 
> > I guess we would need an intermediate state which is 'multiton_rhs_expr
> > DOT multiton_rhs_expr'. Might turn into a mess as well. :)
> 
> I just tried to add that, and kept losing myself in the middle of it.
> It might be me, but it doesn't sound that promising when it comes to
> readability later.

I suspected that already. :)

> I guess we already have enough levels of indirection here -- I'd just
> go with the compound_expr_alloc_or_add() you suggested.
> 
> > > > Intuitively, I would just:
> > > > 
> > > > | int tmp = len;
> > > > | while (start != end && !(start & 1) && (end & 1) && tmp) {
> > > > |	start >>= 1;
> > > > |	end >>= 1;
> > > > |	tmp--;
> > > > | }
> > > > | return (tmp && start == end) ? len - tmp : -1;
> > > > 
> > > > Is that slow when dealing with gmp?  
> > > 
> > > I don't think so, it also avoid copies and allocations, while shifting
> > > and setting bits have comparable complexities. I'd go with the gmp
> > > version of this.  
> 
> Actually, I need to preserve the original elements, so the two copies
> are needed anyway -- other than that, I basically recycled your
> function.

*Obviously* my algorithm assumed pass-by-value. ;)

Thanks, Phil
