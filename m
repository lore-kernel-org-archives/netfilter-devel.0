Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B985C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Feb 2022 14:14:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239062AbiBAOOr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Feb 2022 09:14:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239128AbiBAOOq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Feb 2022 09:14:46 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B96EC061714
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Feb 2022 06:14:46 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nEtvg-0004bP-0g; Tue, 01 Feb 2022 15:14:44 +0100
Date:   Tue, 1 Feb 2022 15:14:43 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pham Thanh Tuyen <phamtyn@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: PROBLEM: Injected conntrack lost helper
Message-ID: <20220201141443.GC18351@breakpoint.cc>
References: <f9fb5616-0b37-d76b-74e5-53751d473432@gmail.com>
 <3f416429-b1be-b51a-c4ef-6274def33258@iogearbox.net>
 <0f4edf58-7b4e-05e8-3f13-d34819b8d5db@gmail.com>
 <20220131112050.GQ25922@breakpoint.cc>
 <2ea7f9da-22be-17db-88d7-10738b95faf3@gmail.com>
 <YfkLnyQopoKnRU17@salvia>
 <20220201120454.GB18351@breakpoint.cc>
 <bca957db-0774-e337-fc3a-ada0c4325fe9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bca957db-0774-e337-fc3a-ada0c4325fe9@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pham Thanh Tuyen <phamtyn@gmail.com> wrote:
> Previously I also thought ct->status |= IPS_HELPER; is ok, but after
> internal pointer assigning with RCU_INIT_POINTER() need external pointer
> assigning with rcu_assign_pointer() in __nf_ct_try_assign_helper() function.

I'm not following.

__nf_ct_try_assign_helper() doesn't do anything once that flag is set,
so how could the helper get lost later?
