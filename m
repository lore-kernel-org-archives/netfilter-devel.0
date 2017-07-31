From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V3] netfilter: x_tables: Fix use-after-free in
 ipt_do_table.
Date: Mon, 31 Jul 2017 20:24:28 +0200
Message-ID: <20170731182428.GA24605@salvia>
References: <20170727022204.17843-1-ap420073@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
To: Taehee Yoo <ap420073@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39612 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751227AbdGaSYk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Jul 2017 14:24:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5CBE43025A5
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 20:24:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4E439D1CA9
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 20:24:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2A9C8DA46B
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 20:24:24 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170727022204.17843-1-ap420073@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 27, 2017 at 11:22:04AM +0900, Taehee Yoo wrote:
> If verdict is NF_STOLEN in the SYNPROXY target,
> the skb is consumed.
> However, ipt_do_table() always tries to get ip header from the skb.
> So that, KASAN triggers the use-after-free message.
> 
> We can reproduce this message using below command.
>   # iptables -I INPUT -p tcp -j SYNPROXY --mss 1460
> 
> [ 193.542265] BUG: KASAN: use-after-free in ipt_do_table+0x1405/0x1c10
> [ ... ]
> [ 193.578603] Call Trace:
> [ 193.581590] <IRQ>
> [ 193.584107] dump_stack+0x68/0xa0
> [ 193.588168] print_address_description+0x78/0x290
> [ 193.593828] ? ipt_do_table+0x1405/0x1c10
> [ 193.598690] kasan_report+0x230/0x340
> [ 193.603194] __asan_report_load2_noabort+0x19/0x20
> [ 193.608950] ipt_do_table+0x1405/0x1c10
> [ 193.613591] ? rcu_read_lock_held+0xae/0xd0
> [ 193.618631] ? ip_route_input_rcu+0x27d7/0x4270
> [ 193.624348] ? ipt_do_table+0xb68/0x1c10
> [ 193.629124] ? do_add_counters+0x620/0x620
> [ 193.634234] ? iptable_filter_net_init+0x60/0x60
> [ ... ]
> 
> After this patch, only when verdict is XT_CONTINUE,
> ipt_do_table() tries to get ip header.
> Also arpt_do_table() is modified because it has same bug.

Applied, thanks.
