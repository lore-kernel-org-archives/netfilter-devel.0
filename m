Return-Path: <SRS0=jECH=SL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CC02C10F0E
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 13:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3B022084F
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 13:59:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfDIN71 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 09:59:27 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:34168 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbfDIN71 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 09:59:27 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hDrHZ-0005GY-QS; Tue, 09 Apr 2019 15:59:25 +0200
Date:   Tue, 9 Apr 2019 15:59:25 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de, arturo@netfilter.org
Subject: Re: [PATCH nft] evaluate: disallow anonymous set with empty elements
Message-ID: <20190409135925.GQ4851@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, fw@strlen.de, arturo@netfilter.org
References: <20190409105936.23422-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190409105936.23422-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Tue, Apr 09, 2019 at 12:59:36PM +0200, Pablo Neira Ayuso wrote:
> Restrict this, the brackets have explicit semantics since they tell the
> kernel to represent this value as a set, which is too costly. Set for
> one single element are overkill.
> 
>  # nft add rule x y ct state { established } counter
>  Error: anonymous set with single element makes no sense, remove brackets wrapping this value
>  add rule x y ct state { established } counter
>                        ^^^^^^^^^^^^^^^
> 
> Instead, the preferred way to express this is:
> 
>  # nft add rule x y ct state established counter
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> I know this may break stuff outthere, but probably it's still early to
> fix this. If we keep allowing this and transparently turn this into a
> value, people will likely never understand the bracket semantics.
> Brackets are not just syntaxic sugar.

Your point makes sense, understanding that within a rule curly braces
are not a block delimiter but a set definition is key to getting along
with nft syntax.

OTOH I like how we radically optimize anonymous sets. This allows to
have rather "dumb" scripts and get by without a performance penalty.

Could we maybe find a middle ground where nft still does these
optimizations but prints warnings so users are notified? We might even
introduce -W flag to customize behaviour (-W all (default), -W error
(strict mode), -W none (suppress any non-fatal output on stderr)).

Just an idea, not sure if feasible.

Cheers, Phil
