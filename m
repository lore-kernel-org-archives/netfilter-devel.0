From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_ct_dccp/sctp: fix memory leak after
 netns cleanup
Date: Tue, 27 Jun 2017 17:57:57 +0200
Message-ID: <20170627155757.GA4859@salvia>
References: <1496575054-17168-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <zlpnobody@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48644 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751492AbdF0P6D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jun 2017 11:58:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 37623EAA62
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jun 2017 17:57:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 25733CFDE9
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jun 2017 17:57:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C7E87D1D92
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jun 2017 17:57:48 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1496575054-17168-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jun 04, 2017 at 07:17:34PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> After running the following commands for a while, kmemleak reported that
> "1879 new suspected memory leaks" happened:
>   # while : ; do
>   ip netns add test
>   ip netns delete test
>   done
> 
>   unreferenced object 0xffff88006342fa38 (size 1024):
>   comm "ip", pid 15477, jiffies 4295982857 (age 957.836s)
>   hex dump (first 32 bytes):
>     b8 b0 4d a0 ff ff ff ff c0 34 c3 59 00 88 ff ff  ..M......4.Y....
>     04 00 00 00 a4 01 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff8190510a>] kmemleak_alloc+0x4a/0xa0
>     [<ffffffff81284130>] __kmalloc_track_caller+0x150/0x300
>     [<ffffffff812302d0>] kmemdup+0x20/0x50
>     [<ffffffffa04d598a>] dccp_init_net+0x8a/0x160 [nf_conntrack]
>     [<ffffffffa04cf9f5>] nf_ct_l4proto_pernet_register_one+0x25/0x90
>   ...
>   unreferenced object 0xffff88006342da58 (size 1024):
>   comm "ip", pid 15477, jiffies 4295982857 (age 957.836s)
>   hex dump (first 32 bytes):
>     10 b3 4d a0 ff ff ff ff 04 35 c3 59 00 88 ff ff  ..M......5.Y....
>     04 00 00 00 a4 01 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff8190510a>] kmemleak_alloc+0x4a/0xa0
>     [<ffffffff81284130>] __kmalloc_track_caller+0x150/0x300
>     [<ffffffff812302d0>] kmemdup+0x20/0x50
>     [<ffffffffa04d6a9d>] sctp_init_net+0x5d/0x130 [nf_conntrack]
>     [<ffffffffa04cf9f5>] nf_ct_l4proto_pernet_register_one+0x25/0x90
>   ...
> 
> This is because we forgot to implement the get_net_proto for sctp and
> dccp, so we won't invoke the nf_ct_unregister_sysctl to free the
> ctl_table when do netns cleanup. Also note, we will fail to register
> the sysctl for dccp/sctp either due to the lack of get_net_proto.

Applied to nf, thanks.
