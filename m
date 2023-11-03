Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C3CC4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 16:57:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbjKCQ5q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 12:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjKCQ5p (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 12:57:45 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884BCD57
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 09:57:42 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qyxUK-0006ym-HF; Fri, 03 Nov 2023 17:57:40 +0100
Date:   Fri, 3 Nov 2023 17:57:40 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v3 1/2] json: drop handling missing json() hook in
 expr_print_json()
Message-ID: <20231103165740.GF8035@breakpoint.cc>
References: <20231103162937.3352069-1-thaller@redhat.com>
 <20231103162937.3352069-2-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231103162937.3352069-2-thaller@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thomas Haller <thaller@redhat.com> wrote:
> --- a/src/expression.c
> +++ b/src/expression.c
> @@ -321,6 +321,7 @@ static const struct expr_ops symbol_expr_ops = {
>  	.type		= EXPR_SYMBOL,
>  	.name		= "symbol",
>  	.print		= symbol_expr_print,
> +	.json		= NULL, /* expr_print_json() must never be called. */

I'd suggest to add a json callback that BUG()s instead,
with a comment explaining that these do not exist anymore
after the initial eval stage.  (symbols will be resolved
to numeric value for example).
