Return-Path: <SRS0=iy/8=SN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00AB9C10F13
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 19:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB4FE2083E
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 19:26:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfDKT0w (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Apr 2019 15:26:52 -0400
Received: from mail.us.es ([193.147.175.20]:52490 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726702AbfDKT0w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Apr 2019 15:26:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5EAE339626B
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Apr 2019 21:26:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4993BDA704
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Apr 2019 21:26:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3F5AEDA701; Thu, 11 Apr 2019 21:26:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 33BD2DA704;
        Thu, 11 Apr 2019 21:26:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 11 Apr 2019 21:26:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0F9374265A31;
        Thu, 11 Apr 2019 21:26:48 +0200 (CEST)
Date:   Thu, 11 Apr 2019 21:26:47 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH RFC 4/4] netfilter: nf_tables: add netlink description
Message-ID: <20190411192647.xsnhno6gcf5fen5u@salvia>
References: <20180207013713.2432-1-pablo@netfilter.org>
 <20180207013713.2432-5-pablo@netfilter.org>
 <f882918e408247a4e0e8d0007feead5bbf311003.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f882918e408247a4e0e8d0007feead5bbf311003.camel@sipsolutions.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Mar 29, 2019 at 11:59:46AM +0100, Johannes Berg wrote:
> On Wed, 2018-02-07 at 02:37 +0100, Pablo Neira Ayuso wrote:
> > 
> > +static const struct nl_desc_attr nft_nldesc_table_attrs[NFTA_TABLE_MAX + 1] = {
> > +	NLDESC_ATTR_STRING(NFTA_TABLE_NAME, NFT_NAME_MAXLEN - 1),
> > +	NLDESC_ATTR_U32_MAX(NFTA_TABLE_FLAGS, NFT_TABLE_F_DORMANT),
> > +	NLDESC_ATTR_U32(NFTA_TABLE_USE),
> > +	NLDESC_ATTR_U64(NFTA_TABLE_HANDLE),
> > +	NLDESC_ATTR_PAD(NFTA_TABLE_PAD),
> > +};
> 
> This part I don't really like so much. Yes, it's >1yo, so we didn't have
> all the stuff at the time.

I'm glad to receive feedback, even 1 year later :-)

> But this is _lots_ of code, and most of it is already encoded in the
> nla_policy for all those attributes. I think we really need to find a
> way to unify the two sets of data.

We could probably extract this from the nla_policy if we extend it. I
can have a look...

> I'd actually be happy to *just* expose the policy with all its nested
> elements/objects in there. That'd probably be also almost enough for
> you?

Exposing commands is also important, I know of people poking for
commands to see if they are available or not.

I think we should full description to userspace, not only policies.

> And that way you don't need to maintain the same descriptions twice
> (and we *will* get it wrong if we do that).
> 
> For genl sub-families, I'd also say that the whole thing could be
> exposed within the genl family, so I think we'd want to express this as
> some kind of helper logic to export the policy data.
> 
> I'm not entirely sure what the whole story with your "objects" is
> though. Aren't those just nested attributes of sort?
> 
> I see e.g.
> 
> > 
> > +static const struct nl_desc_attr nft_nldesc_set_desc_attrs[NFTA_SET_DESC_MAX + 1] = {
> > +       NLDESC_ATTR_U32(NFTA_SET_DESC_SIZE),
> > +};
> 
> This is policy data - like I said above we should unify the two.
> 
> > +static const struct nl_desc_obj nft_nldesc_set_desc[] = {
> > +       NLDESC_OBJ(NFT_SET_DESC, nft_nldesc_set_desc_attrs, NFTA_SET_DESC_MAX),
> 
> This is some kind of "object", which I'm not sure I understand, but
> NFTA_SET_DESC_MAX is just the policy data of what the max attribute is
> for this thing.
> 
> > +static const struct nl_desc_attr nft_nldesc_set_attrs[NFTA_SET_MAX + 1] = {
> ...
> > +       NLDESC_ATTR_NESTED(NFTA_SET_DESC, nft_nldesc_set_desc),
> 
> and here this is again just a policy thing, more or less.
> 
> So it seems to me that without even having an object enum, we'd get the
> same kind of data by
> 
> struct nla_policy nft_policy_set_desc[NFTA_SET_DESC_MAX + 1] = {
> 	[NFTA_SET_DESC_SIZE] = { .type = NLA_U32 },
> };
> 
> struct nla_policy nft_policy_set[NFTA_SET_MAX + 1] = {
> 	[NFTA_SET_DESC] = NLA_POLICY_NESTED(nft_policy_set_desc),
> };
> 
> Except we don't have an "object ID" (and obviously also that we can use
> the same data to actually parse/validate messages, and so don't end up
> with bad situations of nldesc saying one thing and the policy another.)

The object ID is needed by userspace, to build a flat table, and look
up for the nested IDs, to express the graph. We can probably place
this in the policy.

> So ... Assuming I write some code to expose the policy (which I plan on
> doing), what would this still be able to expose in addition?

This would be incomplete, since commands are an essential part too,
and relation of attributes with commands are also too.
