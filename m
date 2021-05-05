Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57682C433B4
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 May 2021 20:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DD26613DD
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 May 2021 20:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbhEEUbV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 May 2021 16:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233965AbhEEUbU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 May 2021 16:31:20 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3D2C061574
        for <netfilter-devel@vger.kernel.org>; Wed,  5 May 2021 13:30:23 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1leO9z-0006IF-Tz; Wed, 05 May 2021 22:30:19 +0200
Date:   Wed, 5 May 2021 22:30:19 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 3/3] exthdr: Implement SCTP Chunk matching
Message-ID: <20210505203019.GC12364@breakpoint.cc>
References: <20210504170148.25226-1-phil@nwl.cc>
 <20210504170148.25226-3-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504170148.25226-3-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Extend exthdr expression to support scanning through SCTP packet chunks
> and matching on fixed fields' values.

LGTM,
Acked-by: Florian Westphal <fw@strlen.de>
