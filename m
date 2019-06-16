Return-Path: <SRS0=UO6N=UP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23B78C31E50
	for <netfilter-devel@archiver.kernel.org>; Sun, 16 Jun 2019 23:48:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E41732084B
	for <netfilter-devel@archiver.kernel.org>; Sun, 16 Jun 2019 23:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfFPXsT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 16 Jun 2019 19:48:19 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:41388 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726038AbfFPXsT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 16 Jun 2019 19:48:19 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hcesj-0001FC-D6; Mon, 17 Jun 2019 01:48:17 +0200
Date:   Mon, 17 Jun 2019 01:48:17 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] datatype: fix print of raw numerical symbol values
Message-ID: <20190616234817.ipy4hwxzhukwgjlw@breakpoint.cc>
References: <20190616085549.1087-1-fw@strlen.de>
 <20190616233356.a3yu333bn4evktn4@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190616233356.a3yu333bn4evktn4@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > This means we now respect format specifier as well:
> > 	chain in_public {
> >                 arp operation 1-2 accept
> >                 arp operation 256-512 accept
> >                 meta mark "0x00000001"
> 
> Hm, why is "1" turned into "0x00000001"?

Because it will now respect basefmt, and that is:

const struct datatype mark_type = {
	...
        .basefmt        = "0x%.8Zx",

> >   Note there is a discrepancy between output when we have a symbol and
> >   when we do not.
> > 
> >   Example, add rule:
> >   meta mark "foo"
> > 
> >   (with '1 "foo"' in rt_marks), nft will print quotes when symbol
> >   printing is inhibited via -n, but elides them in case the symbol
> >   is not available.
> 
> Then, we also need a patch to regard NFT_CTX_OUTPUT_NUMERIC_ALL, right?

Not sure what you mean.

symbolic_constant_print()

does:

 if (no_symbol_found)
	return print_raw();
 if (quotes)
	 nft_print(octx, "\"");
 if (nft_output_numeric_symbol(octx))
	 expr_basetype(expr)->print(expr, octx);
 else
	  nft_print(octx, "%s", s->identifier);
  ...

 maybe either do:

 if (no_symbol_found) {
	 if (quotes)
		 ....
	print_raw();
    ...
    return;
 }

(i.e., print quotes if no symbol found), or

if (nft_output_numeric_symbol(octx)) {
   expr_basetype(expr)->print(expr, octx);
} else {
   if (quotes) ..
	  nft_print(octx, "\"%s\"", s->identifier);
   else
	   nft_print(octx, "%s", s->identifier);
}

i.e., only print the "" if we found a symbol translation.
