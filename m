Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F5EC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Mar 2022 13:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbiCQNJ0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Mar 2022 09:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiCQNJZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Mar 2022 09:09:25 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 890D8FD6D6
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Mar 2022 06:08:08 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5B4D4601DC;
        Thu, 17 Mar 2022 14:05:41 +0100 (CET)
Date:   Thu, 17 Mar 2022 14:08:05 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 1/2] netfilter: nf_tables: registers should not go
 over NFT_REG32_NUM
Message-ID: <YjMytcHwaltpwTPP@salvia>
References: <20220317123937.21345-1-pablo@netfilter.org>
 <20220317125313.GB9722@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220317125313.GB9722@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 17, 2022 at 01:53:13PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Bail out in case userspace uses registers over maximum number of register.
> > 
> > Fixes: 49499c3e6e18 ("netfilter: nf_tables: switch registers to 32 bit addressing")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  net/netfilter/nf_tables_api.c | 23 ++++++++++++++++++-----
> >  1 file changed, 18 insertions(+), 5 deletions(-)
> > 
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index d71a33ae39b3..829ecd310ae6 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -9275,17 +9275,24 @@ int nft_parse_u32_check(const struct nlattr *attr, int max, u32 *dest)
> >  }
> >  EXPORT_SYMBOL_GPL(nft_parse_u32_check);
> >  
> > -static unsigned int nft_parse_register(const struct nlattr *attr)
> > +static unsigned int nft_parse_register(const struct nlattr *attr, u32 *preg)
> >  {
> >  	unsigned int reg;
> >  
> >  	reg = ntohl(nla_get_be32(attr));
> > +	if (reg >= NFT_REG32_NUM)
> > +		return -ERANGE;
> > +
> 
> This breaks userspace.
> 
> NFT_REG32_00 is 8, so this makes NFT_REG32_13, 14 and 15 invalid.

Sending v2. Thanks for reviewing
