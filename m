Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6935C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Dec 2021 22:44:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbhLOWoQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Dec 2021 17:44:16 -0500
Received: from mail.netfilter.org ([217.70.188.207]:56274 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbhLOWoM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Dec 2021 17:44:12 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 72E4B625C5;
        Wed, 15 Dec 2021 23:41:42 +0100 (CET)
Date:   Wed, 15 Dec 2021 23:44:07 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] netfilter: nftables: fix use-after-free in
 nft_set_catchall_destroy()
Message-ID: <Ybpvt4NgxoSlfbAQ@salvia>
References: <20211213134544.2823107-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211213134544.2823107-1-eric.dumazet@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Dec 13, 2021 at 05:45:44AM -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> We need to use list_for_each_entry_safe() iterator
> because we can not access @catchall after kfree_rcu() call.
> 
> syzbot reported:
> 
> BUG: KASAN: use-after-free in nft_set_catchall_destroy net/netfilter/nf_tables_api.c:4486 [inline]
> BUG: KASAN: use-after-free in nft_set_destroy net/netfilter/nf_tables_api.c:4504 [inline]
> BUG: KASAN: use-after-free in nft_set_destroy+0x3fd/0x4f0 net/netfilter/nf_tables_api.c:4493
> Read of size 8 at addr ffff8880716e5b80 by task syz-executor.3/8871

Applied to nf, thanks
