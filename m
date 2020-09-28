Return-Path: <SRS0=suW2=DF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 280EAC2D0A8
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Sep 2020 08:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D933D20738
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Sep 2020 08:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgI1IT2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Sep 2020 04:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgI1IT2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Sep 2020 04:19:28 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AA0C0613CE
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2020 01:19:27 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kMoNZ-0002uj-1r; Mon, 28 Sep 2020 10:19:25 +0200
Date:   Mon, 28 Sep 2020 10:19:25 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] evaluate: Reject quoted strings containing only
 wildcard
Message-ID: <20200928081925.GZ19674@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200924170639.15842-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924170639.15842-1-phil@nwl.cc>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 24, 2020 at 07:06:39PM +0200, Phil Sutter wrote:
> Fix for an assertion fail when trying to match against an all-wildcard
> interface name:
> 
> | % nft add rule t c iifname '"*"'
> | nft: expression.c:402: constant_expr_alloc: Assertion `(((len) + (8) - 1) / (8)) > 0' failed.
> | zsh: abort      nft add rule t c iifname '"*"'
> 
> Fix this by detecting the string in expr_evaluate_string() and returning
> an error message:
> 
> | % nft add rule t c iifname '"*"'
> | Error: All-wildcard strings are not supported
> | add rule t c iifname "*"
> |                      ^^^
> 

Note that all this is pretty inconsistent: The above happens only for
quoted asterisks. Unquoted ones cause a different error (at least no
assertion fail):

| % nft add rule t c iifname '*'
| Error: datatype mismatch, expected network interface name, expression has type integer
| add rule t c iifname *
|              ~~~~~~~ ^

What puzzles me is that we have:

| wildcard_expr           :       ASTERISK
|                         {
|                                 struct expr *expr;
| 
|                                 expr = constant_expr_alloc(&@$, &integer_type,
|                                                            BYTEORDER_HOST_ENDIAN,
|                                                            0, NULL);
|                                 $$ = prefix_expr_alloc(&@$, expr, 0);
|                         }
|                         ;

Yet when trying to use it as a prefix, it is rejected:

| % nft add rule t c ip saddr '*'
| Error: datatype mismatch, expected IPv4 address, expression has type integer
| add rule t c ip saddr *
|              ~~~~~~~~ ^

So is this wildcard_expr simply broken or didn't I find correct way to use it
yet?

Cheers, Phil
