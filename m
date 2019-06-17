Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB98C31E57
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 09:54:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1606320848
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 09:54:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbfFQJyv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 05:54:51 -0400
Received: from mail.us.es ([193.147.175.20]:46586 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727483AbfFQJyv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 05:54:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2E4FE117734
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2019 11:54:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1DB63DA708
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2019 11:54:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 13296DA701; Mon, 17 Jun 2019 11:54:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0CEA3DA709;
        Mon, 17 Jun 2019 11:54:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 17 Jun 2019 11:54:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D7C5E4265A2F;
        Mon, 17 Jun 2019 11:54:46 +0200 (CEST)
Date:   Mon, 17 Jun 2019 11:54:46 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] datatype: fix print of raw numerical symbol values
Message-ID: <20190617095446.gqcdjai2cvljkayy@salvia>
References: <20190616085549.1087-1-fw@strlen.de>
 <20190616233356.a3yu333bn4evktn4@salvia>
 <20190616234817.ipy4hwxzhukwgjlw@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190616234817.ipy4hwxzhukwgjlw@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 17, 2019 at 01:48:17AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > This means we now respect format specifier as well:
> > > 	chain in_public {
> > >                 arp operation 1-2 accept
> > >                 arp operation 256-512 accept
> > >                 meta mark "0x00000001"
> > 
> > Hm, why is "1" turned into "0x00000001"?
> 
> Because it will now respect basefmt, and that is:
> 
> const struct datatype mark_type = {
> 	...
>         .basefmt        = "0x%.8Zx",

We don't want this, right? I mean, no quotes in that case.

> > >   Note there is a discrepancy between output when we have a symbol and
> > >   when we do not.
> > > 
> > >   Example, add rule:
> > >   meta mark "foo"
> > > 
> > >   (with '1 "foo"' in rt_marks), nft will print quotes when symbol
> > >   printing is inhibited via -n, but elides them in case the symbol
> > >   is not available.
> > 
> > Then, we also need a patch to regard NFT_CTX_OUTPUT_NUMERIC_ALL, right?
> 
> Not sure what you mean.

I mean:

# nft list ruleset
table ip x {
        chain y {
                meta mark "test"
        }
}
# nft list ruleset -n
table ip x {
        chain y {
                meta mark "20"
        }
}

This output with -n should not print quotes, ie. no "20".

> symbolic_constant_print()
> 
> does:
> 
>  if (no_symbol_found)
> 	return print_raw();
>  if (quotes)
> 	 nft_print(octx, "\"");
>  if (nft_output_numeric_symbol(octx))
> 	 expr_basetype(expr)->print(expr, octx);
>  else
> 	  nft_print(octx, "%s", s->identifier);
>   ...
> 
>  maybe either do:
> 
>  if (no_symbol_found) {
> 	 if (quotes)
> 		 ....
> 	print_raw();
>     ...
>     return;
>  }
> 
> (i.e., print quotes if no symbol found), or
> 
> if (nft_output_numeric_symbol(octx)) {
>    expr_basetype(expr)->print(expr, octx);
> } else {
>    if (quotes) ..
> 	  nft_print(octx, "\"%s\"", s->identifier);
>    else
> 	   nft_print(octx, "%s", s->identifier);
> }
> 
> i.e., only print the "" if we found a symbol translation.

Agreed :-).

BTW, this probably takes me back to the proposal not to strip off
quotes from the scanner step. Hence, quoted strings will trigger a
rt_mark lookup, otherwise we assume this is a 32-bit integer mark
type. I'm refering to the parser side, so meta mark "0x20" means:
Search for 0x20 key in rt_marks.
