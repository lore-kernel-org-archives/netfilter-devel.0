Return-Path: <SRS0=MMpb=TO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40971C04AB4
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 May 2019 19:31:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1469B2166E
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 May 2019 19:31:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfENTb5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 May 2019 15:31:57 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:48852 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbfENTb5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 May 2019 15:31:57 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hQd9W-0003Px-SM; Tue, 14 May 2019 21:31:54 +0200
Date:   Tue, 14 May 2019 21:31:54 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2 nft WIP v2] jump: Allow jump to a variable when using
 nft input files
Message-ID: <20190514193154.GY4851@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20190514152542.23406-1-ffmancera@riseup.net>
 <20190514152542.23406-2-ffmancera@riseup.net>
 <1772a0cf-6cd0-171f-8db0-038cd823ac9c@riseup.net>
 <20190514161719.GX4851@orbyte.nwl.cc>
 <f39036b3-e82f-f0e7-369f-472c9935849f@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f39036b3-e82f-f0e7-369f-472c9935849f@riseup.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Fernando,

On Tue, May 14, 2019 at 06:24:48PM +0200, Fernando Fernandez Mancera wrote:
> Hi Phil,
> 
> On 5/14/19 6:17 PM, Phil Sutter wrote:
> > Hi Fernando,
> > 
> > On Tue, May 14, 2019 at 05:43:39PM +0200, Fernando Fernandez Mancera wrote:
> >> This last patch does not work. The first one works fine with a string as
> >> chain name.
> >>
> > [...]
> >> [...]
> >> This error comes from symbol_parse() at expr_evaluate_symbol() after the
> >> expr_evaluate() call added in the first patch.
> > 
> > Yes, symbol_expr is used only for symbolic constants, therefore
> > symbol_parse() is very restrictive.
> > 
> > [...]>>> diff --git a/src/parser_bison.y b/src/parser_bison.y
> >>> index 69b5773..42fd71f 100644
> >>> --- a/src/parser_bison.y
> >>> +++ b/src/parser_bison.y
> >>> @@ -3841,7 +3841,13 @@ verdict_expr		:	ACCEPT
> >>>  			}
> >>>  			;
> >>>  
> >>> -chain_expr		:	identifier
> >>> +chain_expr		:	variable_expr
> >>> +			{
> >>> +				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
> >>> +						       current_scope(state),
> >>> +						       $1->sym->identifier);
> >>> +			}
> > 
> > I didn't test it, but you can probably just drop the curly braces and
> > everything inside here. 'variable_expr' already turns into an
> > expression (a variable_expr, not symbol_expr), which is probably what
> > you want.
> > 
> 
> I tried that first and I got the same error. I have tried it again.. and
> I am getting the same error.
> 
> file.nft:1:15-17: Error: Can't parse symbolic netfilter verdict expressions
> define dest = ber
>               ^^^

OK, at least it didn't get worse. :)

I looked at the code and it seems you need to implement a 'parse'
callback for struct verdict_type. I guess existing 'parse' callback in
struct integer_type is a good example of how to do it - basically you
need to convert the symbol expression into a constant expression.

Sorry if that's not much help, I'm not really familiar with these
details. :)

Cheers, Phil
