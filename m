From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: rpfilter: fix incorrect loopback packet
 judgment
Date: Mon, 16 Jan 2017 14:26:18 +0100
Message-ID: <20170116132618.GA20958@salvia>
References: <1483793358-30619-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54894 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751338AbdAPN01 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Jan 2017 08:26:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C624B392E09
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 14:26:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ABACEA7EE4
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 14:26:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8B517A7BE9
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 14:26:23 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1483793358-30619-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jan 07, 2017 at 08:49:18PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> Currently, we check the existing rtable in PREROUTING hook, if RTCF_LOCAL
> is set, we assume that the packet is loopback.
> 
> But this assumption is incorrect, for example, a packet encapsulated
> in ipsec transport mode was received and routed to local, after
> decapsulation, it would be delivered to local again, and the rtable
> was not dropped, so RTCF_LOCAL check would trigger. But actually, the
> packet was not loopback.
> 
> So for these normal loopback packets, we can check whether the in device
> is IFF_LOOPBACK or not. For these locally generated broadcast/multicast,
> we can check whether the skb->pkt_type is PACKET_LOOPBACK or not.
> 
> Finally, there's a subtle difference between nft fib expr and xtables
> rpfilter extension, user can add the following nft rule to do strict
> rpfilter check:
>   # nft add rule x y meta iif eth0 fib saddr . iif oif != eth0 drop
> 
> So when the packet is loopback, it's better to store the in device
> instead of the LOOPBACK_IFINDEX, otherwise, after adding the above
> nft rule, locally generated broad/multicast packets will be dropped
> incorrectly.

Applied, thanks.
