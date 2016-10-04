From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nft_limit: fix divded by zero panic
Date: Tue, 4 Oct 2016 08:59:37 +0200
Message-ID: <20161004065937.GA13178@salvia>
References: <1474980559-4104-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35376 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752029AbcJDG7q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Oct 2016 02:59:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6CC4526E2F
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Oct 2016 08:59:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 62E61BAC3F
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Oct 2016 08:59:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 22A11BAC3F
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Oct 2016 08:59:42 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1474980559-4104-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 27, 2016 at 08:49:19PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> After I input the following nftables rule, a panic happened on my system:
>   # nft add rule filter OUTPUT limit rate 0xf00000000 bytes/second
> 
>   divide error: 0000 [#1] SMP
>   [ ... ]
>   RIP: 0010:[<ffffffffa059035e>]  [<ffffffffa059035e>]
>   nft_limit_pkt_bytes_eval+0x2e/0xa0 [nft_limit]
>   Call Trace:
>   [<ffffffffa05721bb>] nft_do_chain+0xfb/0x4e0 [nf_tables]
>   [<ffffffffa044f236>] ? nf_nat_setup_info+0x96/0x480 [nf_nat]
>   [<ffffffff81753767>] ? ipt_do_table+0x327/0x610
>   [<ffffffffa044f677>] ? __nf_nat_alloc_null_binding+0x57/0x80 [nf_nat]
>   [<ffffffffa058b21f>] nft_ipv4_output+0xaf/0xd0 [nf_tables_ipv4]
>   [<ffffffff816f4aa2>] nf_iterate+0x62/0x80
>   [<ffffffff816f4b33>] nf_hook_slow+0x73/0xd0
>   [<ffffffff81703d0d>] __ip_local_out+0xcd/0xe0
>   [<ffffffff81701d90>] ? ip_forward_options+0x1b0/0x1b0
>   [<ffffffff81703d3c>] ip_local_out+0x1c/0x40
> 
> This is because divisor is 64-bit, but we treat it as a 32-bit integer,
> then 0xf00000000 becomes zero, i.e. divisor becomes 0.

Applied, thanks!
