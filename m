From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nft_reject: restrict to
 INPUT/FORWARD/OUTPUT
Date: Thu, 25 Aug 2016 12:56:24 +0200
Message-ID: <20160825105624.GA5242@salvia>
References: <1471798938-28241-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50488 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755951AbcHYK5C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Aug 2016 06:57:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C5D92F9465
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2016 12:56:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C96D2114D64
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2016 12:56:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 153E26DB34
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2016 12:56:29 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1471798938-28241-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 22, 2016 at 01:02:18AM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> After I add the nft rule "nft add rule filter prerouting reject
> with tcp reset", kernel panic happened on my system:
>   NULL pointer dereference at ...
>   IP: [<ffffffff81b9db2f>] nf_send_reset+0xaf/0x400
>   Call Trace:
>   [<ffffffff81b9da80>] ? nf_reject_ip_tcphdr_get+0x160/0x160
>   [<ffffffffa0928061>] nft_reject_ipv4_eval+0x61/0xb0 [nft_reject_ipv4]
>   [<ffffffffa08e836a>] nft_do_chain+0x1fa/0x890 [nf_tables]
>   [<ffffffffa08e8170>] ? __nft_trace_packet+0x170/0x170 [nf_tables]
>   [<ffffffffa06e0900>] ? nf_ct_invert_tuple+0xb0/0xc0 [nf_conntrack]
>   [<ffffffffa07224d4>] ? nf_nat_setup_info+0x5d4/0x650 [nf_nat]
>   [...]
> 
> Because in the PREROUTING chain, routing information is not exist,
> then we will dereference the NULL pointer and oops happen.
> 
> So we restrict reject expression to INPUT, FORWARD and OUTPUT chain.
> This is consistent with iptables REJECT target.

Good catch, applied, thanks.
