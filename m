From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: don't setup nat info for confirmed ct
Date: Mon, 15 May 2017 18:36:43 +0200
Message-ID: <20170515163643.GA3863@salvia>
References: <20170506122802.5630-1-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:54429 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757952AbdEOQgt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 May 2017 12:36:49 -0400
Content-Disposition: inline
In-Reply-To: <20170506122802.5630-1-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, May 06, 2017 at 08:28:02PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> We cannot setup nat info if the ct has been confirmed already, else,
> different cpu may race to handle the same ct. In extreme situation,
> we may hit the "BUG_ON(nf_nat_initialized(ct, maniptype))" in the
> nf_nat_setup_info.
> 
> Also running the following commands will easily hit NF_CT_ASSERT in
> nf_conntrack_alter_reply:
>   # nft flush ruleset
>   # ping -c 2 -W 1 1.1.1.111 &
>   # nft add table t
>   # nft add chain t c {type nat hook postrouting priority 0 \;}
>   # nft add rule t c snat to 4.5.6.7
>   WARNING: CPU: 1 PID: 10065 at net/netfilter/nf_conntrack_core.c:1472
>   nf_conntrack_alter_reply+0x9a/0x1a0 [nf_conntrack]
>   [...]
>   Call Trace:
>    nf_nat_setup_info+0xad/0x840 [nf_nat]
>    ? deactivate_slab+0x65d/0x6c0
>    nft_nat_eval+0xcd/0x100 [nft_nat]
>    nft_do_chain+0xff/0x5d0 [nf_tables]
>    ? mark_held_locks+0x6f/0xa0
>    ? __local_bh_enable_ip+0x70/0xa0
>    ? trace_hardirqs_on_caller+0x11f/0x190
>    ? ipt_do_table+0x310/0x610
>    ? trace_hardirqs_on+0xd/0x10
>    ? __local_bh_enable_ip+0x70/0xa0
>    ? ipt_do_table+0x32b/0x610
>    ? __lock_acquire+0x2ac/0x1580
>    ? ipt_do_table+0x32b/0x610
>    nft_nat_do_chain+0x65/0x80 [nft_chain_nat_ipv4]
>    nf_nat_ipv4_fn+0x1ae/0x240 [nf_nat_ipv4]
>    nf_nat_ipv4_out+0x4a/0xf0 [nf_nat_ipv4]
>    nft_nat_ipv4_out+0x15/0x20 [nft_chain_nat_ipv4]
>    nf_hook_slow+0x2c/0xf0
>    ip_output+0x154/0x270
> 
> So for the confirmed ct, just ignore it and return NF_ACCEPT.

Applied, thanks.
