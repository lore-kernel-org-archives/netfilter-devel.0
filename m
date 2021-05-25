Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0614AC47084
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 May 2021 10:30:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC4B3613F4
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 May 2021 10:30:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbhEYKcK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 May 2021 06:32:10 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:54950 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231859AbhEYKbe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 May 2021 06:31:34 -0400
Received: from madeliefje.horms.nl (tulip.horms.nl [83.161.246.101])
        by kirsty.vergenet.net (Postfix) with ESMTPA id D3E8025AD66;
        Tue, 25 May 2021 20:30:03 +1000 (AEST)
Received: by madeliefje.horms.nl (Postfix, from userid 7100)
        id F28493850; Tue, 25 May 2021 12:30:01 +0200 (CEST)
Date:   Tue, 25 May 2021 12:30:01 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     lvs-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net] ipvs: ignore IP_VS_SVC_F_HASHED flag when adding
 service
Message-ID: <20210525103001.GA3365@vergenet.net>
References: <20210524195457.125514-1-ja@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524195457.125514-1-ja@ssi.bg>
Organisation: Horms Solutions BV
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
> 
> Reported-and-tested-by: syzbot+e562383183e4b1766930@syzkaller.appspotmail.com
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Julian Anastasov <ja@ssi.bg>

Reviewed-by: Simon Horman <horms@verge.net.au>

