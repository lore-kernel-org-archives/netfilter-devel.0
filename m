Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23E2CC4743C
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Jun 2021 11:40:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3565611AB
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Jun 2021 11:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236155AbhFNLmL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 07:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236569AbhFNLkt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 07:40:49 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81F2C0611C3
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Jun 2021 04:34:06 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1lskqx-0003tR-EN; Mon, 14 Jun 2021 13:34:03 +0200
Date:   Mon, 14 Jun 2021 13:34:03 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] evaluate: restore interval + concatenation in
 anonymous set
Message-ID: <20210614113403.GP22614@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20210611171538.14049-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611171538.14049-1-pablo@netfilter.org>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Fri, Jun 11, 2021 at 07:15:38PM +0200, Pablo Neira Ayuso wrote:
> Perform the table and set lookup only for non-anonymous sets, where the
> incremental cache update is required.
> 
> The problem fixed by 7aa08d45031e ("evaluate: Perform set evaluation on
> implicitly declared (anonymous) sets") resurrected after the cache
> rework.
> 
>  # nft add rule x y tcp sport . tcp dport vmap { ssh . 0-65535 : accept, 0-65535 . ssh : accept }
>  BUG: invalid range expression type concat
>  nft: expression.c:1422: range_expr_value_low: Assertion `0' failed.
>  Abort
> 
> Add a test case to make sure this does not happen again.
> 
> Fixes: 5ec5c706d993 ("cache: add hashtable cache for table")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

This triggers a warning:

evaluate.c: In function 'set_evaluate':
evaluate.c:3870:13: warning: 'table' may be used uninitialized in this function [-Wmaybe-uninitialized]
 3870 |         if (set_cache_find(table, set->handle.set.name) == NULL)
      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Cheers, Phil
