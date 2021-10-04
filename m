Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E776C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Oct 2021 13:45:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15878611CA
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Oct 2021 13:45:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237939AbhJDNrQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Oct 2021 09:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237840AbhJDNrN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Oct 2021 09:47:13 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B04D6C0007E8
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Oct 2021 06:06:15 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mXNfZ-0005Jr-Cc; Mon, 04 Oct 2021 15:06:13 +0200
Date:   Mon, 4 Oct 2021 15:06:13 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Juhee Kang <claudiajkang@gmail.com>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, manojbm@codeaurora.org
Subject: Re: [PATCH nf v2] netfilter: xt_IDLETIMER: fix panic that occurs
 when timer_type has garbage value
Message-ID: <20211004130613.GM2935@breakpoint.cc>
References: <20211004121438.1839-1-claudiajkang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004121438.1839-1-claudiajkang@gmail.com>
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

Reviewed-by: Florian Westphal <fw@strlen.de>
