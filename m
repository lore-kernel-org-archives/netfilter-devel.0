Return-Path: <SRS0=asLr=ZK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E798C432C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Nov 2019 14:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F47B20722
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Nov 2019 14:37:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbfKROhc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Nov 2019 09:37:32 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:34064 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726739AbfKROhc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Nov 2019 09:37:32 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iWi9i-0006YW-2P; Mon, 18 Nov 2019 15:37:30 +0100
Date:   Mon, 18 Nov 2019 15:37:30 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v2] parser_bison: Avoid set references in odd places
Message-ID: <20191118143730.GG17739@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20191118140718.91492-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191118140718.91492-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Mon, Nov 18, 2019 at 03:07:18PM +0100, Pablo Neira Ayuso wrote:
> From: Phil Sutter <phil@nwl.cc>
> 
> With set references being recognized by symbol_expr and that being part
> of primary_expr as well as primary_rhs_expr, they could basically occur
> anywhere while in fact they are allowed only in quite a few spots.
> 
> Untangle things a bit by introducing set_ref_expr and adding that only
> in places where it is needed to pass testsuites.
> 
> Make sure we still allow to define variables as set references, eg.
> 
> 	define xyz = @setref
> 
> And allow to use them from set expressions and statements.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: Extend Phil's original patch to support for set reference from
>     variable definitions. We have no test to cover this, I will follow
>     up with a patch for this.

That's great! I tried to allow for that but struggled with reduce/reduce
conflicts and ultimately gave up. Glad you found a solution.

Thanks, Phil
