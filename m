From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nf_tables: check tprot_set first when
 we use xt.thoff
Date: Thu, 22 Sep 2016 17:26:13 +0200
Message-ID: <20160922152613.GC17824@salvia>
References: <1474093880-21022-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45512 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933343AbcIVP01 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Sep 2016 11:26:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 91832C1087
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 17:26:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7EF7DDA818
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 17:26:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B4231DA816
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 17:26:22 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1474093880-21022-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Sep 17, 2016 at 02:31:20PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> pkt->xt.thoff is not always set properly, but we use it without any check.
> For payload expr, it will cause wrong results. For nftrace, we may notify
> the wrong network or transport header to the user space, furthermore,
> input the following nft rules, warning message will be printed out:
>   # nft add rule arp filter output meta nftrace set 1
> 
>   WARNING: CPU: 0 PID: 13428 at net/netfilter/nf_tables_trace.c:263
>   nft_trace_notify+0x4a3/0x5e0 [nf_tables]
>   Call Trace:
>   [<ffffffff813d58ae>] dump_stack+0x63/0x85
>   [<ffffffff810a4c0b>] __warn+0xcb/0xf0
>   [<ffffffff810a4d3d>] warn_slowpath_null+0x1d/0x20
>   [<ffffffffa0589703>] nft_trace_notify+0x4a3/0x5e0 [nf_tables]
>   [ ... ]
>   [<ffffffffa05690a8>] nft_do_chain_arp+0x78/0x90 [nf_tables_arp]
>   [<ffffffff816f4aa2>] nf_iterate+0x62/0x80
>   [<ffffffff816f4b33>] nf_hook_slow+0x73/0xd0
>   [<ffffffff81732bbf>] arp_xmit+0x8f/0xb0
>   [ ... ]
>   [<ffffffff81732d36>] arp_solicit+0x106/0x2c0
> 
> So before we use pkt->xt.thoff, check the tprot_set first.

Applied, thanks a lot.
