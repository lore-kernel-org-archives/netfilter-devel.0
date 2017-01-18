From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 2/2] netfilter: nft_meta: deal with
 PACKET_LOOPBACK in netdev family
Date: Wed, 18 Jan 2017 20:33:44 +0100
Message-ID: <20170118193344.GB14270@salvia>
References: <1483796035-54792-1-git-send-email-zlpnobody@163.com>
 <1483796035-54792-2-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34030 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753440AbdARTmd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2017 14:42:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6E4DA13C0C4
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 20:33:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5E3361B3010
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 20:33:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 49D4035AA
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 20:33:49 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1483796035-54792-2-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jan 07, 2017 at 09:33:55PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> After adding the following nft rule, then ping 224.0.0.1:
>   # nft add rule netdev t c pkttype host counter
> 
> The warning complain message will be printed out again and again:
>   WARNING: CPU: 0 PID: 10182 at net/netfilter/nft_meta.c:163 \
>            nft_meta_get_eval+0x3fe/0x460 [nft_meta]
>   [...]
>   Call Trace:
>   <IRQ>
>   dump_stack+0x85/0xc2
>   __warn+0xcb/0xf0
>   warn_slowpath_null+0x1d/0x20
>   nft_meta_get_eval+0x3fe/0x460 [nft_meta]
>   nft_do_chain+0xff/0x5e0 [nf_tables]
> 
> So we should deal with PACKET_LOOPBACK in netdev family too. For ipv4,
> convert it to PACKET_BROADCAST/MULTICAST according to the destination
> address's type; For ipv6, convert it to PACKET_MULTICAST directly.

Also applied, thanks.
