Return-Path: <SRS0=/ozj=TY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8870C072B5
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 10:29:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4C0020879
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 10:29:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390247AbfEXK3y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 May 2019 06:29:54 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:54878 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390156AbfEXK3y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 May 2019 06:29:54 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hU7SQ-0003OY-Kn; Fri, 24 May 2019 12:29:50 +0200
Date:   Fri, 24 May 2019 12:29:50 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v3 1/2] jump: Introduce chain_expr in jump and goto
 statements
Message-ID: <20190524102950.GH17768@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org
References: <20190516204559.28910-1-ffmancera@riseup.net>
 <20190521092837.vd3egt54lvdhynqi@salvia>
 <1ff8b9ea-ce19-301f-e683-790417a179a7@riseup.net>
 <6570754e-30ab-b24b-4f4d-507a6ac74edf@riseup.net>
 <5d9f68a9-a90f-37bf-8ee7-61b7d2ccb324@riseup.net>
 <20190524092148.wagryvqpj3l64hge@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190524092148.wagryvqpj3l64hge@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Fri, May 24, 2019 at 11:21:48AM +0200, Pablo Neira Ayuso wrote:
> On Fri, May 24, 2019 at 09:29:34AM +0200, Fernando Fernandez Mancera wrote:
> > On 5/24/19 9:17 AM, Fernando Fernandez Mancera wrote:
> > > Hi Pablo,
> > > 
> > > On 5/21/19 9:38 PM, Fernando Fernandez Mancera wrote:
> > >> Hi Pablo,
> > >>
> > >> On 5/21/19 11:28 AM, Pablo Neira Ayuso wrote:
> > >>> On Thu, May 16, 2019 at 10:45:58PM +0200, Fernando Fernandez Mancera wrote:
> > >>>> Now we can introduce expressions as a chain in jump and goto statements. This
> > >>>> is going to be used to support variables as a chain in the following patches.
> > >>>
> > >>> Something is wrong with json:
> > >>>
> > >>> json.c: In function ‘verdict_expr_json’:
> > >>> json.c:683:11: warning: assignment from incompatible pointer type
> > >>> [-Wincompatible-pointer-types]
> > >>>      chain = expr->chain;
> > >>>            ^
> > >>> parser_json.c: In function ‘json_parse_verdict_expr’:
> > >>> parser_json.c:1086:8: warning: passing argument 3 of
> > >>> ‘verdict_expr_alloc’ from incompatible pointer type
> > >>> [-Wincompatible-pointer-types]
> > >>>         chain ? xstrdup(chain) : NULL);
> > >>>         ^~~~~
> > >>>
> > >>> Most likely --enable-json missing there.
> > >>>
> > >>
> > >> Sorry, I am going to fix that.
> > >> [...]
> > > 
> > > I am compiling nftables with:
> > > 
> > > $ ./configure --enable-json
> > > $ make
> > > 
> > > And I am not getting any error, am I missing something? Thanks! :-)
> > > 
> > 
> > Fixed, the option is --with-json. Why isn't it "--enable-json" as other
> > features?

It is actually not that uniform. While we have:

--enable-debug
--enable-man-doc
--enable-python

we also have:

--with-mini-gmp
--with-cli
--with-xtables
--with-json

and all of them just enable/disable something, unlike --with-python-bin.

> We can just update this to accept both, either --with-json or
> --enable-json.

For consistency, we should turn all of the above --with flags into
--enable ones, but there's of course the compatibility problem.

What do you think, is it feasible to change all the above and introduce
--with aliases for them?

Cheers, Phil

