From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_tables: fix oops when inserting an
 element into a verdict map
Date: Wed, 9 Nov 2016 00:05:42 +0100
Message-ID: <20161108230542.GA31399@salvia>
References: <1478414401-21488-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, dalegaard@gmail.com,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58810 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750926AbcKHXGC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Nov 2016 18:06:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1279A392E1B
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2016 00:06:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 00CB4DA80B
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2016 00:06:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E71CFDA7E0
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2016 00:05:57 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1478414401-21488-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Nov 06, 2016 at 02:40:01PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> Dalegaard says:
>  The following ruleset, when loaded with 'nft -f bad.txt'
>  ----snip----
>  flush ruleset
>  table ip inlinenat {
>    map sourcemap {
>      type ipv4_addr : verdict;
>    }
> 
>    chain postrouting {
>      ip saddr vmap @sourcemap accept
>    }
>  }
>  add chain inlinenat test
>  add element inlinenat sourcemap { 100.123.10.2 : jump test }
>  ----snip----
> 
>  results in a kernel oops:
>  BUG: unable to handle kernel paging request at 0000000000001344
>  IP: [<ffffffffa07bf704>] nf_tables_check_loops+0x114/0x1f0 [nf_tables]
>  [...]
>  Call Trace:
>   [<ffffffffa07c2aae>] ? nft_data_init+0x13e/0x1a0 [nf_tables]
>   [<ffffffffa07c1950>] nft_validate_register_store+0x60/0xb0 [nf_tables]
>   [<ffffffffa07c74b5>] nft_add_set_elem+0x545/0x5e0 [nf_tables]
>   [<ffffffffa07bfdd0>] ? nft_table_lookup+0x30/0x60 [nf_tables]
>   [<ffffffff8132c630>] ? nla_strcmp+0x40/0x50
>   [<ffffffffa07c766e>] nf_tables_newsetelem+0x11e/0x210 [nf_tables]
>   [<ffffffff8132c400>] ? nla_validate+0x60/0x80
>   [<ffffffffa030d9b4>] nfnetlink_rcv+0x354/0x5a7 [nfnetlink]
> 
> Because we forget to fill the net pointer in bind_ctx, so dereferencing
> it may cause kernel crash.

Applied, thanks for fixing up this, that was fast.
