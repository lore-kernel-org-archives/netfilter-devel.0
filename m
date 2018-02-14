From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net v3] netfilter: nat: cope with negative port range
Date: Wed, 14 Feb 2018 20:55:35 +0100
Message-ID: <20180214195535.frlds4kbjrwqjd2d@salvia>
References: <bd5880d8f24f13db563631219bb69c4b1d7fa03f.1518625200.git.pabeni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Eric Dumazet <eric.dumazet@gmail.com>
To: Paolo Abeni <pabeni@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35648 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030369AbeBNTzj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Feb 2018 14:55:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 65CD0FFB64
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 20:55:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 552D2DA3AE
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 20:55:38 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <bd5880d8f24f13db563631219bb69c4b1d7fa03f.1518625200.git.pabeni@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 14, 2018 at 05:21:19PM +0100, Paolo Abeni wrote:
> syzbot reported a division by 0 bug in the netfilter nat code:
> 
> divide error: 0000 [#1] SMP KASAN
> Dumping ftrace buffer:
>     (ftrace buffer empty)
> Modules linked in:
> CPU: 1 PID: 4168 Comm: syzkaller034710 Not tainted 4.16.0-rc1+ #309
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:nf_nat_l4proto_unique_tuple+0x291/0x530
> net/netfilter/nf_nat_proto_common.c:88
> RSP: 0018:ffff8801b2466778 EFLAGS: 00010246
> RAX: 000000000000f153 RBX: ffff8801b2466dd8 RCX: ffff8801b2466c7c
> RDX: 0000000000000000 RSI: ffff8801b2466c58 RDI: ffff8801db5293ac
> RBP: ffff8801b24667d8 R08: ffff8801b8ba6dc0 R09: ffffffff88af5900
> R10: ffff8801b24666f0 R11: 0000000000000000 R12: 000000002990f153
> R13: 0000000000000001 R14: 0000000000000000 R15: ffff8801b2466c7c
> FS:  00000000017e3880(0000) GS:ffff8801db500000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000208fdfe4 CR3: 00000001b5340002 CR4: 00000000001606e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   dccp_unique_tuple+0x40/0x50 net/netfilter/nf_nat_proto_dccp.c:30
>   get_unique_tuple+0xc28/0x1c10 net/netfilter/nf_nat_core.c:362
>   nf_nat_setup_info+0x1c2/0xe00 net/netfilter/nf_nat_core.c:406
>   nf_nat_redirect_ipv6+0x306/0x730 net/netfilter/nf_nat_redirect.c:124
>   redirect_tg6+0x7f/0xb0 net/netfilter/xt_REDIRECT.c:34
>   ip6t_do_table+0xc2a/0x1a30 net/ipv6/netfilter/ip6_tables.c:365
>   ip6table_nat_do_chain+0x65/0x80 net/ipv6/netfilter/ip6table_nat.c:41
>   nf_nat_ipv6_fn+0x594/0xa80 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c:302
>   nf_nat_ipv6_local_fn+0x33/0x5d0
> net/ipv6/netfilter/nf_nat_l3proto_ipv6.c:407
>   ip6table_nat_local_fn+0x2c/0x40 net/ipv6/netfilter/ip6table_nat.c:69
>   nf_hook_entry_hookfn include/linux/netfilter.h:120 [inline]
>   nf_hook_slow+0xba/0x1a0 net/netfilter/core.c:483
>   nf_hook include/linux/netfilter.h:243 [inline]
>   NF_HOOK include/linux/netfilter.h:286 [inline]
>   ip6_xmit+0x10ec/0x2260 net/ipv6/ip6_output.c:277
>   inet6_csk_xmit+0x2fc/0x580 net/ipv6/inet6_connection_sock.c:139
>   dccp_transmit_skb+0x9ac/0x10f0 net/dccp/output.c:142
>   dccp_connect+0x369/0x670 net/dccp/output.c:564
>   dccp_v6_connect+0xe17/0x1bf0 net/dccp/ipv6.c:946
>   __inet_stream_connect+0x2d4/0xf00 net/ipv4/af_inet.c:620
>   inet_stream_connect+0x58/0xa0 net/ipv4/af_inet.c:684
>   SYSC_connect+0x213/0x4a0 net/socket.c:1639
>   SyS_connect+0x24/0x30 net/socket.c:1620
>   do_syscall_64+0x282/0x940 arch/x86/entry/common.c:287
>   entry_SYSCALL_64_after_hwframe+0x26/0x9b
> RIP: 0033:0x441c69
> RSP: 002b:00007ffe50cc0be8 EFLAGS: 00000217 ORIG_RAX: 000000000000002a
> RAX: ffffffffffffffda RBX: ffffffffffffffff RCX: 0000000000441c69
> RDX: 000000000000001c RSI: 00000000208fdfe4 RDI: 0000000000000003
> RBP: 00000000006cc018 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000538 R11: 0000000000000217 R12: 0000000000403590
> R13: 0000000000403620 R14: 0000000000000000 R15: 0000000000000000
> Code: 48 89 f0 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 46 02 00 00 48 8b
> 45 c8 44 0f b7 20 e8 88 97 04 fd 31 d2 41 0f b7 c4 4c 89 f9 <41> f7 f6 48
> c1 e9 03 48 b8 00 00 00 00 00 fc ff df 0f b6 0c 01
> RIP: nf_nat_l4proto_unique_tuple+0x291/0x530
> net/netfilter/nf_nat_proto_common.c:88 RSP: ffff8801b2466778
> 
> The problem is that currently we don't have any check on the
> configured port range. A port range == -1 triggers the bug, while
> other negative values may require a very long time to complete the
> following loop.
> 
> This commit addresses the issue swapping the two ends on negative
> ranges. The check is performed in nf_nat_l4proto_unique_tuple() since
> the nft nat loads the port values from nft registers at runtime.

Applied, thanks.
