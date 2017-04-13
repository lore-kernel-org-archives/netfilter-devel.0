From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] hash: generate a random seed if seed option is empty
Date: Thu, 13 Apr 2017 23:04:22 +0200
Message-ID: <20170413210422.GA2111@salvia>
References: <1491208197-5493-1-git-send-email-zlpnobody@163.com>
 <20170413205709.GA2039@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, laura.garcia@zevenet.com,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38986 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751808AbdDMVE3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 17:04:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A6FFEB7100
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 23:04:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 984EFDA729
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 23:04:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B8B3EDA807
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 23:04:21 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170413205709.GA2039@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 13, 2017 at 10:57:09PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Apr 03, 2017 at 04:29:57PM +0800, Liping Zhang wrote:
> > From: Liping Zhang <zlpnobody@gmail.com>
> > 
> > Typing the "nft add rule x y ct mark set jhash ip saddr mod 2" will
> > not generate a random seed, instead, the seed will always be zero.
> > 
> > So if seed option is empty, we shoulde not set the NFTA_HASH_SEED
> > attribute, then a random seed will be generted in the kernel.
> > 
> > Also: just to keep it simple, "seed 0" is equal to "seed opt is empty",
> > since this is not a big problem.
> > 
> > Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
> > ---
> >  Note, another kernel patch is necessary to avoid the annoying warning
> >  from "nft-test.py ip/hash.t":
> >  ip/hash.t: WARNING: line: 5: 'src/nft add rule --debug=netlink ip test-ip4
> >  pre ct mark set jhash ip saddr . ip daddr mod 2': 'ct mark set jhash ip saddr
> >  . ip daddr mod 2' mismatches 'ct mark set jhash ip saddr . ip daddr mod 2
> >  seed 0xd6ab633c'
> > 
> >  src/netlink_linearize.c    | 3 ++-
> >  tests/py/ip/hash.t         | 1 +
> >  tests/py/ip/hash.t.payload | 7 +++++++
> >  3 files changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
> > index b2f27b7..0dba658 100644
> > --- a/src/netlink_linearize.c
> > +++ b/src/netlink_linearize.c
> > @@ -139,7 +139,8 @@ static void netlink_gen_hash(struct netlink_linearize_ctx *ctx,
> >  	}
> >  	netlink_put_register(nle, NFTNL_EXPR_HASH_DREG, dreg);
> >  	nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_MODULUS, expr->hash.mod);
> > -	nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_SEED, expr->hash.seed);
> > +	if (expr->hash.seed)
> > +		nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_SEED, expr->hash.seed);
> 
> I prefer we have a hash.seed_set, instead of relying on 0 meaning
> "unset".
> 
> I'm thinking of people willing to implement some sort of poor man
> symmetric hashing with two rules, one per each direction. The seed
> needs to be the same so the jhash is consistent.

I'm thinking of things like:

        iif eth0 jhash ip saddr . tcp dport seed 0xdeadbeef
        iif eth1 jhash ip daddr . tcp sport seed 0xdeadbeef

I think may be useful in case of several uplinks are available, and
you want something a bit more configurable that symhash, at the cost
of having two rules, one per direction.
