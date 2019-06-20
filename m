Return-Path: <SRS0=UCdS=UT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C77C43613
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jun 2019 12:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E85762080C
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jun 2019 12:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731784AbfFTMJQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jun 2019 08:09:16 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:49642 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730596AbfFTMJQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jun 2019 08:09:16 -0400
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 5083025AD85;
        Thu, 20 Jun 2019 22:09:14 +1000 (AEST)
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id EC4DF94048B; Thu, 20 Jun 2019 14:09:11 +0200 (CEST)
Date:   Thu, 20 Jun 2019 14:09:11 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     lvs-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net] ipvs: fix tinfo memory leak in start_sync_thread
Message-ID: <20190620120757.jxzypo25e3gdvrnx@verge.net.au>
References: <20190618200736.7531-1-ja@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618200736.7531-1-ja@ssi.bg>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 18, 2019 at 11:07:36PM +0300, Julian Anastasov wrote:
> syzkaller reports for memory leak in start_sync_thread [1]
> 
> As Eric points out, kthread may start and stop before the
> threadfn function is called, so there is no chance the
> data (tinfo in our case) to be released in thread.
> 
> Fix this by releasing tinfo in the controlling code instead.
> 
> [1]
> BUG: memory leak
> unreferenced object 0xffff8881206bf700 (size 32):
>  comm "syz-executor761", pid 7268, jiffies 4294943441 (age 20.470s)
>  hex dump (first 32 bytes):
>    00 40 7c 09 81 88 ff ff 80 45 b8 21 81 88 ff ff  .@|......E.!....
>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  backtrace:
>    [<0000000057619e23>] kmemleak_alloc_recursive include/linux/kmemleak.h:55 [inline]
>    [<0000000057619e23>] slab_post_alloc_hook mm/slab.h:439 [inline]
>    [<0000000057619e23>] slab_alloc mm/slab.c:3326 [inline]
>    [<0000000057619e23>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
>    [<0000000086ce5479>] kmalloc include/linux/slab.h:547 [inline]
>    [<0000000086ce5479>] start_sync_thread+0x5d2/0xe10 net/netfilter/ipvs/ip_vs_sync.c:1862
>    [<000000001a9229cc>] do_ip_vs_set_ctl+0x4c5/0x780 net/netfilter/ipvs/ip_vs_ctl.c:2402
>    [<00000000ece457c8>] nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
>    [<00000000ece457c8>] nf_setsockopt+0x4c/0x80 net/netfilter/nf_sockopt.c:115
>    [<00000000942f62d4>] ip_setsockopt net/ipv4/ip_sockglue.c:1258 [inline]
>    [<00000000942f62d4>] ip_setsockopt+0x9b/0xb0 net/ipv4/ip_sockglue.c:1238
>    [<00000000a56a8ffd>] udp_setsockopt+0x4e/0x90 net/ipv4/udp.c:2616
>    [<00000000fa895401>] sock_common_setsockopt+0x38/0x50 net/core/sock.c:3130
>    [<0000000095eef4cf>] __sys_setsockopt+0x98/0x120 net/socket.c:2078
>    [<000000009747cf88>] __do_sys_setsockopt net/socket.c:2089 [inline]
>    [<000000009747cf88>] __se_sys_setsockopt net/socket.c:2086 [inline]
>    [<000000009747cf88>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2086
>    [<00000000ded8ba80>] do_syscall_64+0x76/0x1a0 arch/x86/entry/common.c:301
>    [<00000000893b4ac8>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Reported-by: syzbot+7e2e50c8adfccd2e5041@syzkaller.appspotmail.com
> Suggested-by: Eric Biggers <ebiggers@kernel.org>
> Fixes: 998e7a76804b ("ipvs: Use kthread_run() instead of doing a double-fork via kernel_thread()")
> Signed-off-by: Julian Anastasov <ja@ssi.bg>

Thanks Julian.

Pablo, please consider this for inclusion in nf.

Acked-by: Simon Horman <horms@verge.net.au>
