Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14626C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Feb 2022 10:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236086AbiBAK3z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Feb 2022 05:29:55 -0500
Received: from mail.netfilter.org ([217.70.188.207]:41636 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234907AbiBAK3z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Feb 2022 05:29:55 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 58D346018B;
        Tue,  1 Feb 2022 11:29:51 +0100 (CET)
Date:   Tue, 1 Feb 2022 11:29:51 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Pham Thanh Tuyen <phamtyn@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: PROBLEM: Injected conntrack lost helper
Message-ID: <YfkLnyQopoKnRU17@salvia>
References: <f9fb5616-0b37-d76b-74e5-53751d473432@gmail.com>
 <3f416429-b1be-b51a-c4ef-6274def33258@iogearbox.net>
 <0f4edf58-7b4e-05e8-3f13-d34819b8d5db@gmail.com>
 <20220131112050.GQ25922@breakpoint.cc>
 <2ea7f9da-22be-17db-88d7-10738b95faf3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2ea7f9da-22be-17db-88d7-10738b95faf3@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Feb 01, 2022 at 10:08:55AM +0700, Pham Thanh Tuyen wrote:
> When the conntrack is created, the extension is created before the conntrack
> is assigned confirmed and inserted into the hash table. But the function
> ctnetlink_setup_nat() causes loss of helper in the mentioned situation. I
> mention the template because it's seamless in the
> __nf_ct_try_assign_helper() function. Please double check.

Conntrack entries that are created via ctnetlink as IPS_CONFIRMED always
set on.

The helper code is only exercised from the packet path for conntrack
entries that are newly created.
