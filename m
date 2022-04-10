Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E9B2C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 10 Apr 2022 18:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236284AbiDJSWG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 10 Apr 2022 14:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbiDJSWF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Apr 2022 14:22:05 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613C322531
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Apr 2022 11:19:52 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ndcAA-0004rD-KS; Sun, 10 Apr 2022 20:19:50 +0200
Date:   Sun, 10 Apr 2022 20:19:50 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nf-next] netfilter: nft_fib: reverse path filter for
 policy-based routing on iif
Message-ID: <20220410181950.GH5623@breakpoint.cc>
References: <20220330222713.867-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330222713.867-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> If policy-based routing using the iif selector is used, then the fib
> expression fails to look up for the reverse path from the prerouting
> hook because the input interface cannot be inferred. In order to support
> this scenario, extend the fib expression to allow to use after the route
> lookup, from the forward chain.

LGTM,
Acked-by: Florian Westphal <fw@strlen.de>
