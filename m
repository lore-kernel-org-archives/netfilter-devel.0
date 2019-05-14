Return-Path: <SRS0=MMpb=TO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DEE2C04AB4
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 May 2019 16:17:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20B7A205C9
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 May 2019 16:17:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbfENQRV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 May 2019 12:17:21 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:48504 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725901AbfENQRV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 May 2019 12:17:21 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hQa7D-0001de-NQ; Tue, 14 May 2019 18:17:19 +0200
Date:   Tue, 14 May 2019 18:17:19 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2 nft WIP v2] jump: Allow jump to a variable when using
 nft input files
Message-ID: <20190514161719.GX4851@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20190514152542.23406-1-ffmancera@riseup.net>
 <20190514152542.23406-2-ffmancera@riseup.net>
 <1772a0cf-6cd0-171f-8db0-038cd823ac9c@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1772a0cf-6cd0-171f-8db0-038cd823ac9c@riseup.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Fernando,

On Tue, May 14, 2019 at 05:43:39PM +0200, Fernando Fernandez Mancera wrote:
> This last patch does not work. The first one works fine with a string as
> chain name.
> 
[...]
> 
> But when trying to execute "# nft -f file.nft", being file.nft:
> 
> > define dest = ber
> > add rule ip foo bar jump $dest
> 
> I am getting the following error:
> 
> file.nft:3:26-30: Error: Can't parse symbolic netfilter verdict expressions
> add rule ip foo bar jump $dest
> 			 ^^^^^
> This error comes from symbol_parse() at expr_evaluate_symbol() after the
> expr_evaluate() call added in the first patch.

Yes, symbol_expr is used only for symbolic constants, therefore
symbol_parse() is very restrictive.

[...]
> > diff --git a/src/parser_bison.y b/src/parser_bison.y
> > index 69b5773..42fd71f 100644
> > --- a/src/parser_bison.y
> > +++ b/src/parser_bison.y
> > @@ -3841,7 +3841,13 @@ verdict_expr		:	ACCEPT
> >  			}
> >  			;
> >  
> > -chain_expr		:	identifier
> > +chain_expr		:	variable_expr
> > +			{
> > +				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
> > +						       current_scope(state),
> > +						       $1->sym->identifier);
> > +			}

I didn't test it, but you can probably just drop the curly braces and
everything inside here. 'variable_expr' already turns into an
expression (a variable_expr, not symbol_expr), which is probably what
you want.

> > +			|	identifier
> >  			{
> >  				$$ = constant_expr_alloc(&@$, &string_type,
> >  							 BYTEORDER_HOST_ENDIAN,
> > 
> 

Cheers, Phil
