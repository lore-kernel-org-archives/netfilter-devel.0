Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA72CC4708D
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 11:07:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F22761028
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 11:07:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233845AbhE0LJM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 May 2021 07:09:12 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60654 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbhE0LJL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 May 2021 07:09:11 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3162364416;
        Thu, 27 May 2021 13:06:36 +0200 (CEST)
Date:   Thu, 27 May 2021 13:07:35 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net] ipvs: ignore IP_VS_SVC_F_HASHED flag when adding
 service
Message-ID: <20210527110735.GA6710@salvia>
References: <20210524195457.125514-1-ja@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210524195457.125514-1-ja@ssi.bg>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, May 24, 2021 at 10:54:57PM +0300, Julian Anastasov wrote:
> syzbot reported memory leak [1] when adding service with
> HASHED flag. We should ignore this flag both from sockopt
> and netlink provided data, otherwise the service is not
> hashed and not visible while releasing resources.
> 
> [1]
> BUG: memory leak
> unreferenced object 0xffff888115227800 (size 512):
>   comm "syz-executor263", pid 8658, jiffies 4294951882 (age 12.560s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff83977188>] kmalloc include/linux/slab.h:556 [inline]
>     [<ffffffff83977188>] kzalloc include/linux/slab.h:686 [inline]
>     [<ffffffff83977188>] ip_vs_add_service+0x598/0x7c0 net/netfilter/ipvs/ip_vs_ctl.c:1343
>     [<ffffffff8397d770>] do_ip_vs_set_ctl+0x810/0xa40 net/netfilter/ipvs/ip_vs_ctl.c:2570
>     [<ffffffff838449a8>] nf_setsockopt+0x68/0xa0 net/netfilter/nf_sockopt.c:101
>     [<ffffffff839ae4e9>] ip_setsockopt+0x259/0x1ff0 net/ipv4/ip_sockglue.c:1435
>     [<ffffffff839fa03c>] raw_setsockopt+0x18c/0x1b0 net/ipv4/raw.c:857
>     [<ffffffff83691f20>] __sys_setsockopt+0x1b0/0x360 net/socket.c:2117
>     [<ffffffff836920f2>] __do_sys_setsockopt net/socket.c:2128 [inline]
>     [<ffffffff836920f2>] __se_sys_setsockopt net/socket.c:2125 [inline]
>     [<ffffffff836920f2>] __x64_sys_setsockopt+0x22/0x30 net/socket.c:2125
>     [<ffffffff84350efa>] do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
>     [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

Applied, thanks.
