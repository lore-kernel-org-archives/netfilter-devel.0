From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nft_set_bitmap: free dummy elements when
 destroy the set
Date: Tue, 25 Apr 2017 11:06:44 +0200
Message-ID: <20170425090644.GA2894@salvia>
References: <1492270656-1664-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43794 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1177029AbdDYJHE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Apr 2017 05:07:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0828E6D587
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 11:06:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EE107FF2C0
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 11:06:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 811D4468
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 11:06:41 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1492270656-1664-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Apr 15, 2017 at 11:37:36PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> We forget to free dummy elements when deleting the set. So when I was
> running nft-test.py, I saw many kmemleak warnings:
>   kmemleak: 1344 new suspected memory leaks ...
>   # cat /sys/kernel/debug/kmemleak
>   unreferenced object 0xffff8800631345c8 (size 32):
>   comm "nft", pid 9075, jiffies 4295743309 (age 1354.815s)
>   hex dump (first 32 bytes):
>     f8 63 13 63 00 88 ff ff 88 79 13 63 00 88 ff ff  .c.c.....y.c....
>     04 0c 00 00 00 00 00 00 00 00 00 00 08 03 00 00  ................
>   backtrace:
>     [<ffffffff819059da>] kmemleak_alloc+0x4a/0xa0
>     [<ffffffff81288174>] __kmalloc+0x164/0x310
>     [<ffffffffa061269d>] nft_set_elem_init+0x3d/0x1b0 [nf_tables]
>     [<ffffffffa06130da>] nft_add_set_elem+0x45a/0x8c0 [nf_tables]
>     [<ffffffffa0613645>] nf_tables_newsetelem+0x105/0x1d0 [nf_tables]
>     [<ffffffffa05fe6d4>] nfnetlink_rcv+0x414/0x770 [nfnetlink]
>     [<ffffffff817f0ca6>] netlink_unicast+0x1f6/0x310
>     [<ffffffff817f10c6>] netlink_sendmsg+0x306/0x3b0
>   ...

Applied, thanks.
