Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B58DBC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Oct 2021 12:01:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F15261215
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Oct 2021 12:01:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbhJDMDK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Oct 2021 08:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233076AbhJDMDI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Oct 2021 08:03:08 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46DB7C061745
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Oct 2021 05:01:19 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mXMeh-0004p3-UV; Mon, 04 Oct 2021 14:01:15 +0200
Date:   Mon, 4 Oct 2021 14:01:15 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Juhee Kang <claudiajkang@gmail.com>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, luciano.coelho@nokia.com
Subject: Re: [PATCH nf] netfilter: xt_IDLETIMER: fix panic that occurs when
 timer_type has garbage value
Message-ID: <20211004120115.GL2935@breakpoint.cc>
References: <20211004115101.1579-1-claudiajkang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004115101.1579-1-claudiajkang@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Juhee Kang <claudiajkang@gmail.com> wrote:
> Currently, when the rule related to IDLETIMER is added, idletimer_tg timer 
> structure is initialized by kmalloc on executing idletimer_tg_create 
> function. However, in this process timer->timer_type is not defined to 
> a specific value. Thus, timer->timer_type has garbage value and it occurs 
> kernel panic. So, this commit fixes the panic by initializing 
> timer->timer_type using kzalloc instead of kmalloc.
> 
> Test commands:
>     # iptables -A OUTPUT -j IDLETIMER --timeout 1 --label test
>     $ cat /sys/class/xt_idletimer/timers/test
>       Killed
> 
> Splat looks like:
>     BUG: KASAN: user-memory-access in alarm_expires_remaining+0x49/0x70
>     Read of size 8 at addr 0000002e8c7bc4c8 by task cat/917
>     CPU: 12 PID: 917 Comm: cat Not tainted 5.14.0+ #3 79940a339f71eb14fc81aee1757a20d5bf13eb0e
>     Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
>     Call Trace:
>      dump_stack_lvl+0x6e/0x9c
>      kasan_report.cold+0x112/0x117
>      ? alarm_expires_remaining+0x49/0x70
>      __asan_load8+0x86/0xb0
>      alarm_expires_remaining+0x49/0x70
>      idletimer_tg_show+0xe5/0x19b [xt_IDLETIMER 11219304af9316a21bee5ba9d58f76a6b9bccc6d]

> Fixes: 0902b469bd250 ("netfilter: xtables: idletimer target implementation")

Hmm, I don't think so.

Probably:
Fixes: 68983a354a65 ("netfilter: xtables: Add snapshot of hardidletimer target")

?
