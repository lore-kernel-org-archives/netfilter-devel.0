Return-Path: <SRS0=uYLw=7H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51263C433E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 May 2020 15:46:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E91C2053B
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 May 2020 15:46:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391055AbgEYPqX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 May 2020 11:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390951AbgEYPqW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 May 2020 11:46:22 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF791C061A0E
        for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2020 08:46:22 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jdFIu-00060P-Cs; Mon, 25 May 2020 17:46:16 +0200
Date:   Mon, 25 May 2020 17:46:16 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/2] evaluate: Perform set evaluation on implicitly
 declared (anonymous) sets
Message-ID: <20200525154616.GT17795@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <cover.1590324033.git.sbrivio@redhat.com>
 <a2c6c6ba6295d9027fa149cc68b072a8e1209261.1590324033.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2c6c6ba6295d9027fa149cc68b072a8e1209261.1590324033.git.sbrivio@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, May 24, 2020 at 03:00:26PM +0200, Stefano Brivio wrote:
> If a set is implicitly declared, set_evaluate() is not called as a
> result of cmd_evaluate_add(), because we're adding in fact something
> else (e.g. a rule). Expression-wise, evaluation still happens as the
> implicit set expression is eventually found in the tree and handled
> by expr_evaluate_set(), but context-wise evaluation (set_evaluate())
> is skipped, and this might be relevant instead.
> 
> This is visible in the reported case of an anonymous set including
> concatenated ranges:
> 
>   # nft add rule t c ip saddr . tcp dport { 192.0.2.1 . 20-30 } accept
>   BUG: invalid range expression type concat
>   nft: expression.c:1160: range_expr_value_low: Assertion `0' failed.
>   Aborted
> 
> because we reach do_add_set() without properly evaluated flags and
> set description, and eventually end up in expr_to_intervals(), which
> can't handle that expression.
> 
> Explicitly call set_evaluate() as we add anonymous sets into the
> context, and instruct the same function to skip expression-wise set
> evaluation if the set is anonymous, as that happens later anyway as
> part of the general tree evaluation.
> 
> Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Reported-by: Phil Sutter <phil@nwl.cc>
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>

Acked-by: Phil Sutter <phil@nwl.cc>
