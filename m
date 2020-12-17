Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6A5DC4361B
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Dec 2020 18:44:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABB40238EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Dec 2020 18:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729062AbgLQSop (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Dec 2020 13:44:45 -0500
Received: from correo.us.es ([193.147.175.20]:59996 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728926AbgLQSop (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Dec 2020 13:44:45 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4AAD618CDD2
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2020 19:43:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3B8C5DA73D
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2020 19:43:45 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2FA39DA704; Thu, 17 Dec 2020 19:43:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E8999DA704;
        Thu, 17 Dec 2020 19:43:42 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 17 Dec 2020 19:43:42 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id BEB91426CC85;
        Thu, 17 Dec 2020 19:43:42 +0100 (CET)
Date:   Thu, 17 Dec 2020 19:44:00 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH v2] netfilter: ipset: fix shift-out-of-bounds in
 htable_bits()
Message-ID: <20201217184400.GB17365@salvia>
References: <4d915d3a-6a95-7784-4057-2faa17a061@blackhole.kfki.hu>
 <e954ad22-83dc-e553-37a3-f0adb11cebb2@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e954ad22-83dc-e553-37a3-f0adb11cebb2@virtuozzo.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 17, 2020 at 05:53:18PM +0300, Vasily Averin wrote:
> htable_bits() can call jhash_size(32) and trigger shift-out-of-bounds
> 
> UBSAN: shift-out-of-bounds in net/netfilter/ipset/ip_set_hash_gen.h:151:6
> shift exponent 32 is too large for 32-bit type 'unsigned int'
> CPU: 0 PID: 8498 Comm: syz-executor519
>  Not tainted 5.10.0-rc7-next-20201208-syzkaller #0
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x107/0x163 lib/dump_stack.c:120
>  ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
>  __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:395
>  htable_bits net/netfilter/ipset/ip_set_hash_gen.h:151 [inline]
>  hash_mac_create.cold+0x58/0x9b net/netfilter/ipset/ip_set_hash_gen.h:1524
>  ip_set_create+0x610/0x1380 net/netfilter/ipset/ip_set_core.c:1115
>  nfnetlink_rcv_msg+0xecc/0x1180 net/netfilter/nfnetlink.c:252
>  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
>  nfnetlink_rcv+0x1ac/0x420 net/netfilter/nfnetlink.c:600
>  netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
>  netlink_sendmsg+0x907/0xe40 net/netlink/af_netlink.c:1919
>  sock_sendmsg_nosec net/socket.c:652 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:672
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2345
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2399
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2432
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> This patch replaces htable_bits() by simple fls(hashsize - 1) call:
> it alone returns valid nbits both for round and non-round hashsizes.
> It is normal to set any nbits here because it is validated inside
> following htable_size() call which returns 0 for nbits>31.

Applied, thanks.
