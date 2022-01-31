Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5036C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Jan 2022 11:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358458AbiAaLcP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 Jan 2022 06:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379455AbiAaLaU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Jan 2022 06:30:20 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B4DC0617BF
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jan 2022 03:20:52 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nEUjq-0004l4-83; Mon, 31 Jan 2022 12:20:50 +0100
Date:   Mon, 31 Jan 2022 12:20:50 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pham Thanh Tuyen <phamtyn@gmail.com>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: PROBLEM: Injected conntrack lost helper
Message-ID: <20220131112050.GQ25922@breakpoint.cc>
References: <f9fb5616-0b37-d76b-74e5-53751d473432@gmail.com>
 <3f416429-b1be-b51a-c4ef-6274def33258@iogearbox.net>
 <0f4edf58-7b4e-05e8-3f13-d34819b8d5db@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f4edf58-7b4e-05e8-3f13-d34819b8d5db@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pham Thanh Tuyen <phamtyn@gmail.com> wrote:

[ moving to netfilter-devel ]

> > > My name is Pham Thanh Tuyen. I found a bug related to the ctnetlink
> > > and conntrack subsystems. Details are as follows:
> > > 
> > > 1. Summary: Injected conntrack lost helper
> > > 
> > > 2. Description: When a conntrack whose helper is injected from
> > > userspace, the ctnetlink creates helper for it but NAT then loses
> > > the helper in case the user defined helper explicitly with CT
> > > target.

Hmm.  If you insert a conntrack entry from userspace, it will already
be confirmed, so nat rules will have no effect, and template CT rules
are irrelevant wrt. to the helper, as extension can only be created if
the conntrack is not in the hash yet.

Can you describe the steps to reproduce this bug?
