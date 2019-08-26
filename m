Return-Path: <SRS0=4EdP=WW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FEE8C3A59F
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Aug 2019 15:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0528520874
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Aug 2019 15:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732654AbfHZPkI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Aug 2019 11:40:08 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:57150 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732638AbfHZPkI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Aug 2019 11:40:08 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1i2H6E-00028q-Gf; Mon, 26 Aug 2019 17:40:06 +0200
Date:   Mon, 26 Aug 2019 17:40:06 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 14/14] nft: bridge: Rudimental among extension
 support
Message-ID: <20190826154006.GD14469@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190821092602.16292-1-phil@nwl.cc>
 <20190821092602.16292-15-phil@nwl.cc>
 <20190824165333.l4qyhk3fyzglstmp@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190824165333.l4qyhk3fyzglstmp@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Aug 24, 2019 at 06:53:34PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Aug 21, 2019 at 11:26:02AM +0200, Phil Sutter wrote:
> [...]
> > +/* XXX: move this into libnftnl, replacing nftnl_set_lookup() */
> > +static struct nftnl_set *nft_set_byname(struct nft_handle *h,
> > +					const char *table, const char *set)
> 
> Probably extend libnftnl to allow to take a pointer to a nftnl_set
> object, as an alternative to the set name? The idea is that this
> set object now belongs to the lookup extension, so this extension will
> take care of releasing it from the destroy path.
> 
> Then, the lookup extension will have a pointer to the anonymous set so
> you could then skip the cache code (and all the updates to have access
> to it).

Sounds like a nice approach! So I would add a new
NFTNL_EXPR_LOOKUP_SET_PTR to link the set and introduce
NFTA_LOOKUP_ANON_SET (or so) which starts a nested attribute filled
simply by nftnl_set_nlmsg_build_payload()? Kernel code would have to be
extended accordingly, of course.

Seems like I can't reuse nftnl_set_nlmsg_parse() since
mnl_attr_parse_nested() would have to be called. But I guess outsourcing
the attribute handling from the further and introducing a second wrapper
would do.

Also, this would limit ebtables-nft among match to kernels supporting
this new way of anon set creating.

> Anonymous sets can only be attached to one rule and they go away when
> the rule is released. Then, flushing the rule would also release this
> object.

Luckily, in kernel space it seems like anonymous sets are released
automatically if the referencing rule is removed.

Cheers, Phil
