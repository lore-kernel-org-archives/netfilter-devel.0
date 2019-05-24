Return-Path: <SRS0=/ozj=TY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AD4BC072B5
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 19:21:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41D782175B
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 19:21:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391167AbfEXTVv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 May 2019 15:21:51 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:55731 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727344AbfEXTVu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 May 2019 15:21:50 -0400
Received: from [31.4.219.201] (helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1hUFlD-0002rB-TQ; Fri, 24 May 2019 21:21:49 +0200
Date:   Fri, 24 May 2019 21:21:46 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: kill anon sets with one element
Message-ID: <20190524192146.phnh4cqwelnpxdrp@salvia>
References: <20190519171838.3811-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190519171838.3811-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, May 19, 2019 at 07:18:38PM +0200, Florian Westphal wrote:
> convert "ip saddr { 1.1.1.1 }" to "ip saddr 1.1.1.1".
> Both do the same, but second form is faster since no single-element
> anon set is created.
> 
> Fix up the remaining test cases to expect transformations of the form
> "meta l4proto { 33-55}" to "meta l4proto 33-55".

Last time we discussed this I think we agreed to spew a warning for
this to educate people on this.

My concern is: This is an optimization, are we going to do transparent
optimizations of the ruleset? I would like to explore at some point
automatic transformations for rulesets, also spot shadowed rules,
overlaps, and other sort of inconsistencies.

Are we going to do all that transparently?

Asking this because this is an optimization after all, and I'm not
sure I want to step in into making optimizations transparently. Even
if this one is fairly trivial.

I also don't like this path because we introduce one more assymmetry
between what the user adds a what the user fetches from the kernel.

Thanks.
