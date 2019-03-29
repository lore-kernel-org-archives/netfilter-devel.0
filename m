Return-Path: <SRS0=SelT=SA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00702C10F05
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Mar 2019 10:59:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCAD7217F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Mar 2019 10:59:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbfC2K7t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Mar 2019 06:59:49 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:53508 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727788AbfC2K7t (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Mar 2019 06:59:49 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1h9pEh-0004en-5h; Fri, 29 Mar 2019 11:59:47 +0100
Message-ID: <f882918e408247a4e0e8d0007feead5bbf311003.camel@sipsolutions.net>
Subject: Re: [PATCH RFC 4/4] netfilter: nf_tables: add netlink description
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     netdev@vger.kernel.org
Date:   Fri, 29 Mar 2019 11:59:46 +0100
In-Reply-To: <20180207013713.2432-5-pablo@netfilter.org>
References: <20180207013713.2432-1-pablo@netfilter.org>
         <20180207013713.2432-5-pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 2018-02-07 at 02:37 +0100, Pablo Neira Ayuso wrote:
> 
> +static const struct nl_desc_attr nft_nldesc_table_attrs[NFTA_TABLE_MAX + 1] = {
> +	NLDESC_ATTR_STRING(NFTA_TABLE_NAME, NFT_NAME_MAXLEN - 1),
> +	NLDESC_ATTR_U32_MAX(NFTA_TABLE_FLAGS, NFT_TABLE_F_DORMANT),
> +	NLDESC_ATTR_U32(NFTA_TABLE_USE),
> +	NLDESC_ATTR_U64(NFTA_TABLE_HANDLE),
> +	NLDESC_ATTR_PAD(NFTA_TABLE_PAD),
> +};

This part I don't really like so much. Yes, it's >1yo, so we didn't have
all the stuff at the time.

But this is _lots_ of code, and most of it is already encoded in the
nla_policy for all those attributes. I think we really need to find a
way to unify the two sets of data.

I'd actually be happy to *just* expose the policy with all its nested
elements/objects in there. That'd probably be also almost enough for
you? And that way you don't need to maintain the same descriptions twice
(and we *will* get it wrong if we do that).

For genl sub-families, I'd also say that the whole thing could be
exposed within the genl family, so I think we'd want to express this as
some kind of helper logic to export the policy data.

I'm not entirely sure what the whole story with your "objects" is
though. Aren't those just nested attributes of sort?

I see e.g.

> 
> +static const struct nl_desc_attr nft_nldesc_set_desc_attrs[NFTA_SET_DESC_MAX + 1] = {
> +       NLDESC_ATTR_U32(NFTA_SET_DESC_SIZE),
> +};

This is policy data - like I said above we should unify the two.

> +static const struct nl_desc_obj nft_nldesc_set_desc[] = {
> +       NLDESC_OBJ(NFT_SET_DESC, nft_nldesc_set_desc_attrs, NFTA_SET_DESC_MAX),

This is some kind of "object", which I'm not sure I understand, but
NFTA_SET_DESC_MAX is just the policy data of what the max attribute is
for this thing.

> +static const struct nl_desc_attr nft_nldesc_set_attrs[NFTA_SET_MAX + 1] = {
...
> +       NLDESC_ATTR_NESTED(NFTA_SET_DESC, nft_nldesc_set_desc),

and here this is again just a policy thing, more or less.

So it seems to me that without even having an object enum, we'd get the
same kind of data by

struct nla_policy nft_policy_set_desc[NFTA_SET_DESC_MAX + 1] = {
	[NFTA_SET_DESC_SIZE] = { .type = NLA_U32 },
};

struct nla_policy nft_policy_set[NFTA_SET_MAX + 1] = {
	[NFTA_SET_DESC] = NLA_POLICY_NESTED(nft_policy_set_desc),
};

Except we don't have an "object ID" (and obviously also that we can use
the same data to actually parse/validate messages, and so don't end up
with bad situations of nldesc saying one thing and the policy another.)



So ... Assuming I write some code to expose the policy (which I plan on
doing), what would this still be able to expose in addition?

johannes

