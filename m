Return-Path: <SRS0=IJRP=TQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA1DDC04AAF
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 May 2019 14:39:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9690520848
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 May 2019 14:39:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727342AbfEPOjt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 May 2019 10:39:49 -0400
Received: from mail.us.es ([193.147.175.20]:52860 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727339AbfEPOjt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 May 2019 10:39:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D11E76CB70
        for <netfilter-devel@vger.kernel.org>; Thu, 16 May 2019 16:39:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C1E82DA712
        for <netfilter-devel@vger.kernel.org>; Thu, 16 May 2019 16:39:45 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B7830DA711; Thu, 16 May 2019 16:39:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 858A8DA703;
        Thu, 16 May 2019 16:39:43 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 16 May 2019 16:39:43 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 606D04265A31;
        Thu, 16 May 2019 16:39:43 +0200 (CEST)
Date:   Thu, 16 May 2019 16:39:42 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 2/2 nft] jump: Allow goto and jump to a variable using
 nft input files
Message-ID: <20190516143942.tfjxdyi6vj66u3wn@salvia>
References: <20190514211340.913-2-ffmancera@riseup.net>
 <20190515105850.GA4851@orbyte.nwl.cc>
 <347917dc-086b-998c-dd2f-b5e4a87b38b1@riseup.net>
 <20190515111232.lu3ifr72mlhfriqc@salvia>
 <20190515114617.GB4851@orbyte.nwl.cc>
 <20190515152132.267ryecqod3xenyj@salvia>
 <20190515192600.GC4851@orbyte.nwl.cc>
 <902d698b-a25c-0567-1338-b2d8c0bd91cb@riseup.net>
 <20190515203149.GD4851@orbyte.nwl.cc>
 <91e43f5d-c082-48d0-1fa0-fe2d18923dfa@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91e43f5d-c082-48d0-1fa0-fe2d18923dfa@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 16, 2019 at 01:58:17PM +0200, Fernando Fernandez Mancera wrote:
> Hi!
> 
> On 5/15/19 10:31 PM, Phil Sutter wrote:
> > Hi,
> > 
> > On Wed, May 15, 2019 at 09:56:11PM +0200, Fernando Fernandez Mancera wrote:
> >> Hi Phil,
> >>
> >> On 5/15/19 9:26 PM, Phil Sutter wrote:
> >>> Hi Pablo,
> >>>
> >>> On Wed, May 15, 2019 at 05:21:32PM +0200, Pablo Neira Ayuso wrote:
> >>>> On Wed, May 15, 2019 at 01:46:17PM +0200, Phil Sutter wrote>> [...]
> >>>> '@<something>' is currently allowed, as any arbitrary string can be
> >>>> placed in between strings - although in some way this is taking us
> >>>> back to the quote debate that needs to be addressed. If we want to
> >>>> disallow something enclosed in quotes then we'll have to apply this
> >>>> function everywhere we allow variables.
> >>>
> >>> Oh, sorry. I put those ticks in there just to quote the value, not as
> >>> part of the value. The intention was to point out that something like:
> >>>
> >>> | define foo = @set1
> >>> | add rule ip t c jump $foo
> >>>
> >>> Might pass evaluation stage and since there is a special case for things
> >>> starting with '@' in symbol_expr, the added rule would turn into
> >>>
> >>> | add rule ip t c jump set1
> >>>
> >>> We could detect this situation by checking expr->symtype.
> >>>
> >>
> >> I agree about that. We could check if the symbol type is SYMBOL_VALUE.
> >> But I am not sure about where should we do it, maybe in the parser?
> >>
> >>> On the other hand, can we maybe check if given string points to an
> >>> *existing* chain in verdict_type_parse()? Or will that happen later
> >>> anyway?
> >>>
> >>
> >> It happens later, right now if the given string does not point to an
> >> existing chain it returns the usual error for this situation. e.g
> > 
> > I just played around a bit and could provoke some segfaults:
> > 
> > * define foo = @set1 (a set named 'set1' must exist)
> > * define foo = { 1024 }
> > * define foo = *
> > 
> > I didn't check how we could avoid those. Maybe this is even follow-up
> > work, but we should definitely try to address those eventually.
> > 
> 
> I have been working on fixing this. I propose the following fix.
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 8394037..edab370 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -1950,6 +1950,12 @@ static int stmt_evaluate_verdict(struct eval_ctx
> *ctx, struct stmt *stmt)
>                 if (stmt->expr->chain != NULL) {
>                         if (expr_evaluate(ctx, &stmt->expr->chain) < 0)
>                                 return -1;
> +                       if (stmt->expr->chain->etype != EXPR_SYMBOL ||
> +                           stmt->expr->chain->symtype != SYMBOL_VALUE) {
> +                               BUG("invalid verdict chain expression %s\n",
> +                                   expr_name(stmt->expr->chain));

Instead of BUG(), I'd suggest you do proper error reporting.

> +                               return -1;
> +                       }
>                 }
>                 break;
>         case EXPR_MAP:
> 
> That works for all the cases that you mentioned above. What do you think?
> 
> Thanks :-)
> 
> > Cheers, Phil
> > 
