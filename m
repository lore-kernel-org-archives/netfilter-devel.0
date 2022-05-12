Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E00EAC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 May 2022 13:27:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238625AbiELN14 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 May 2022 09:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354467AbiELN1q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 May 2022 09:27:46 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8020E53707
        for <netfilter-devel@vger.kernel.org>; Thu, 12 May 2022 06:27:20 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1np8qc-0001nI-Sa; Thu, 12 May 2022 15:27:18 +0200
Date:   Thu, 12 May 2022 15:27:18 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH v2 1/2] netfilter: nf_tables: Introduce
 expression flags
Message-ID: <Yn0LNg9/HK6IWTdH@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220512123003.29903-1-phil@nwl.cc>
 <20220512123003.29903-2-phil@nwl.cc>
 <Ynz+wzEIfokNqi0B@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ynz+wzEIfokNqi0B@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 12, 2022 at 02:34:11PM +0200, Pablo Neira Ayuso wrote:
> On Thu, May 12, 2022 at 02:30:02PM +0200, Phil Sutter wrote:
> > Allow dumping some info bits about expressions to user space.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  include/net/netfilter/nf_tables.h        | 1 +
> >  include/uapi/linux/netfilter/nf_tables.h | 1 +
> >  net/netfilter/nf_tables_api.c            | 4 ++++
> >  3 files changed, 6 insertions(+)
> > 
> > diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> > index 20af9d3557b9d..78db54737de00 100644
> > --- a/include/net/netfilter/nf_tables.h
> > +++ b/include/net/netfilter/nf_tables.h
> > @@ -346,6 +346,7 @@ struct nft_set_estimate {
> >   */
> >  struct nft_expr {
> >  	const struct nft_expr_ops	*ops;
> > +	u32				flags;
> 
> Could you add a new structure? Add struct nft_expr_dp and use it from
> nft_rule_dp, so it is only the control plan representation that stores
> this flag.
> 
> It will be a bit more work, but I think it is worth to keep the size
> of the datapath representation as small as possible.

Sounds reasonable, but will get ugly: expr->ops->size includes struct
nft_expr size already, also real per-expr size is aligned to that
struct's size.

We could make expr->ops->size the real (unaligned) size value and change
size calculation in nf_tables_newrule() to add struct and alignment.
Then nf_tables_commit_chain_prepare() could iterate over the rule's
expressions and do its own size calculation for chain->blob_next size.

Do you see a better way to solve this?

Thanks, Phil
