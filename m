Return-Path: <SRS0=46WK=DW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0C52C433E7
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Oct 2020 11:41:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75B2920B1F
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Oct 2020 11:41:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729968AbgJOLlw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Oct 2020 07:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728083AbgJOLlu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Oct 2020 07:41:50 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B997C061755
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2020 04:41:49 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kT1dS-0008OR-Qm; Thu, 15 Oct 2020 13:41:30 +0200
Date:   Thu, 15 Oct 2020 13:41:30 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Kavana Ravindra <kavana.c.ravindra@gmail.com>
Cc:     zhe.he@windriver.com, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, davem@davemloft.net, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, Masaya.Takahashi@sony.com,
        Oleksiy.Avramchenko@sony.com, Shingo.Takeuchi@sony.com,
        Srinavasa.Nagaraju@sony.com, Soumya.Khasnis@sony.com
Subject: Re: [PATCH] netfilter: conntrack: Fix kmemleak false positive reports
Message-ID: <20201015114130.GF16895@breakpoint.cc>
References: <20201015110305.GA19762@tsappmail.ltts.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015110305.GA19762@tsappmail.ltts.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Kavana Ravindra <kavana.c.ravindra@gmail.com> wrote:
> unreferenced object 0xffff9643edb89900 (size 256):
>   comm "sd-resolve", pid 220, jiffies 4295016710 (age 208.256s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 03 00 74 f3 ba b1 b6 b5  ..........t.....
>     65 3e 00 00 00 00 00 00 90 f9 a0 ed 43 96 ff ff  e>..........C...
>   backtrace:
>     [<0000000070d5b185>] kmem_cache_alloc+0x146/0x200
>     [<0000000007a27faa>] __nf_conntrack_alloc.isra.13+0x4d/0x170 [nf_conntrack]
>     [<00000000ecc5b0ec>] init_conntrack+0x6a/0x2f0 [nf_conntrack]
>     [<000000003d38809f>] nf_conntrack_in+0x2c5/0x360 [nf_conntrack]
>     [<000000001fe154e3>] ipv4_conntrack_local+0x5d/0x70 [nf_conntrack_ipv4]
>     [<0000000027adadb2>] nf_hook_slow+0x48/0xd0
>     [<000000009893511f>] __ip_local_out+0xbd/0xf0
>     [<00000000d68cbd2f>] ip_local_out+0x1c/0x50
>     [<00000000995e2f37>] ip_send_skb+0x19/0x40
>     [<000000003d95f220>] udp_send_skb.isra.5+0x157/0x360
>     [<00000000ebc25968>] udp_sendmsg+0x9d8/0xc10
>     [<000000003bef56ec>] inet_sendmsg+0x3e/0xf0
>     [<000000008d23e405>] sock_sendmsg+0x1d/0x30
>     [<000000008c297097>] ___sys_sendmsg+0x108/0x2b0
>     [<00000000f15a806c>] __sys_sendmmsg+0xba/0x1c0
>     [<00000000e195d2cf>] __x64_sys_sendmmsg+0x24/0x30
> 
> In __nf_conntrack_confirm, object ct can be referenced to by the stack variable
> ct and the members of ct->tuplehash. kmemleak needs at least one of them to find
> the ct object during scan.
> 
> When the ct object is moved from the unconfirmed hlist to the confirmed hlist.
> kmemleak cannot see ct object if things happen in the following order and thus
> give the above false positive report.
> 1) The ct object is removed from the unconfirmed hlist.
> 2) kmemleak scans data/bss sections(heap scan passes without heap reference).
> 3) The ct object is added to confirmed hlist and the variable ct is destroyed as
>    the function returns.
> 4) kmemleak scans task stacks(stack scan passes without stack reference).
> 
> This patch marks ct object as not a leak.

Same comment as last time -- can't kmemleak be fixed to require two
passes before reporting this as leaked?
