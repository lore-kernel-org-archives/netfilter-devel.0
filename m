From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: add overflow checks in xt_bpf.c
Date: Mon, 4 Dec 2017 11:36:03 +0100
Message-ID: <20171204103603.GA16237@salvia>
References: <20171201004607.7389-1-jannh@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Willem de Bruijn <willemb@google.com>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        coreteam@netfilter.org, netfilter-devel@vger.kernel.org
To: Jann Horn <jannh@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46386 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753700AbdLDKgK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Dec 2017 05:36:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E61CB2519A8
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Dec 2017 11:36:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C0C47DA80E
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Dec 2017 11:36:08 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171201004607.7389-1-jannh@google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 01, 2017 at 01:46:07AM +0100, Jann Horn wrote:
> Check whether inputs from userspace are too long (explicit length field too
> big or string not null-terminated) to avoid out-of-bounds reads.
> 
> As far as I can tell, this can at worst lead to very limited kernel heap
> memory disclosure or oopses.
> 
> This bug can be triggered by an unprivileged user even if the xt_bpf module
> is not loaded: iptables is available in network namespaces, and the xt_bpf
> module can be autoloaded.
> 
> Triggering the bug with a classic BPF filter with fake length 0x1000 causes
> the following KASAN report:
> 
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in bpf_prog_create+0x84/0xf0
> Read of size 32768 at addr ffff8801eff2c494 by task test/4627
> 
> CPU: 0 PID: 4627 Comm: test Not tainted 4.15.0-rc1+ #1
> [...]
> Call Trace:
>  dump_stack+0x5c/0x85
>  print_address_description+0x6a/0x260
>  kasan_report+0x254/0x370
>  ? bpf_prog_create+0x84/0xf0
>  memcpy+0x1f/0x50
>  bpf_prog_create+0x84/0xf0
>  bpf_mt_check+0x90/0xd6 [xt_bpf]
> [...]
> Allocated by task 4627:
>  kasan_kmalloc+0xa0/0xd0
>  __kmalloc_node+0x47/0x60
>  xt_alloc_table_info+0x41/0x70 [x_tables]
> [...]
> The buggy address belongs to the object at ffff8801eff2c3c0
>                 which belongs to the cache kmalloc-2048 of size 2048
> The buggy address is located 212 bytes inside of
>                 2048-byte region [ffff8801eff2c3c0, ffff8801eff2cbc0)
> [...]
> ==================================================================

Applied, thanks.
