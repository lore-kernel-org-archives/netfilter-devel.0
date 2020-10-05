Return-Path: <SRS0=VfFo=DM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E4F3C4363A
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Oct 2020 21:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57A372078E
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Oct 2020 21:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgJEVHi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Oct 2020 17:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgJEVHi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Oct 2020 17:07:38 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4330AC0613CE
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Oct 2020 14:07:38 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kPXhn-0001J5-Ie; Mon, 05 Oct 2020 23:07:35 +0200
Date:   Mon, 5 Oct 2020 23:07:35 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH 1/3] nft: Make batch_add_chain() return the
 added batch object
Message-ID: <20201005210735.GC5213@breakpoint.cc>
References: <20201005144858.11578-1-phil@nwl.cc>
 <20201005144858.11578-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005144858.11578-2-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Do this so in a later patch the 'skip' field can be adjusted.
> 
> While being at it, simplify a few callers and eliminate the need for a
> 'ret' variable.

Reviewed-by: Florian Westphal <fw@strlen.de>
