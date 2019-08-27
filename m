Return-Path: <SRS0=TL01=WX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B2B4C3A5A3
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Aug 2019 11:35:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49178206BF
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Aug 2019 11:35:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbfH0Lf2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Aug 2019 07:35:28 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:59248 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbfH0Lf1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Aug 2019 07:35:27 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1i2Zl0-0004ro-Fl; Tue, 27 Aug 2019 13:35:26 +0200
Date:   Tue, 27 Aug 2019 13:35:26 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 14/14] nft: bridge: Rudimental among extension
 support
Message-ID: <20190827113526.GA937@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190821092602.16292-1-phil@nwl.cc>
 <20190821092602.16292-15-phil@nwl.cc>
 <20190827104919.r3p3giv6hmnzmcbr@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827104919.r3p3giv6hmnzmcbr@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Tue, Aug 27, 2019 at 12:49:19PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Aug 21, 2019 at 11:26:02AM +0200, Phil Sutter wrote:
> [...]
> > +/* Make sure previous payload expression(s) is/are consistent and extract if
> > + * matching on source or destination address and if matching on MAC and IP or
> > + * only MAC address. */
> > +static int lookup_analyze_payloads(const struct nft_xt_ctx *ctx,
> > +				   bool *dst, bool *ip)
> > +{
> > +	int val, val2 = -1;
> > +
> > +	if (ctx->flags & NFT_XT_CTX_PREV_PAYLOAD) {
> 
> Can you probably achieve this by storing protocol context?
> 
> Something like storing the current network base in the nft_xt_ctx
> structure, rather than the last payload that you have seen.
> 
> From the context you annotate, then among will find the information
> that it needs in the context.
> 
> We can reuse this context later on to generate native tcp/udp/etc.
> matching.

Sorry, I don't understand your approach. With protocol context as it is
used in nftables in mind, I don't see how that applies here. For among
match, we simply have a payload match for MAC address and optionally a
second one for IP address. These are not related apart from the fact
that among allows to match only source or only destination addresses.
The problem lookup_analyze_payloads() solves is:

1) Are we matching MAC only or MAC and IP?
2) Are we matching source or destination?
3) Is everything consistent, i.e., no IP match without MAC one and no
   mixed source/destination matches?

If (3) evaluates false, there may be a different extension this lookups
suits for, but currently such a lookup is simply ignored.

> [...]
> > +static int __add_nft_among(struct nft_handle *h, const char *table,
> > +			   struct nftnl_rule *r, struct nft_among_pair *pairs,
> > +			   int cnt, bool dst, bool inv, bool ip)
> > +{
> > +	uint32_t set_id, type = 9, len = 6;
> > +	/*			!dst, dst */
> > +	int eth_addr_off[] = { 6, 0 };
> > +	int ip_addr_off[] = { 12, 16 };
> > +	struct nftnl_expr *e;
> > +	struct nftnl_set *s;
> > +	int idx = 0;
> > +
> > +	if (ip) {
> > +		type = type << 6 | 7;
> > +		len += 4 + 2;
> > +	}
> 
> Magic numbers, please help me understand this.

Ah, sorry. The 'type' values are TYPE_LLADDR and TYPE_IPADDR from
nftables' enum datatypes. Seems like neither kernel nor libnftnl care
about it, so this is useful only to make nft list things correctly.

Values added to 'len' are four bytes IPv4 address length and two bytes
padding. I'll try to find more illustrative ways to write them.

> I think this is the way to go, let's just sort out these few glitches.

OK, cool. I started implementing the inline anonymous set idea already,
but kernel code becomes pretty ugly when trying to create a new set from
within expr_ops->init. :(

Thanks, Phil
