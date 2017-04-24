From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: Wrong icmp6 checksum for ICMPV6_TIME_EXCEED
 in reverse SNATv6 path
Date: Mon, 24 Apr 2017 10:43:12 +0200
Message-ID: <20170424084312.GA3597@salvia>
References: <22774.51265.265373.257836@gargle.gargle.HOWL>
 <22776.44325.616928.335465@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Dave Johnson <dave-kernel@centerclick.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54880 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1166973AbdDXInR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Apr 2017 04:43:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3C526523C1
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Apr 2017 10:43:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2AFB2FF2D9
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Apr 2017 10:43:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E825CFF2C0
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Apr 2017 10:43:08 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <22776.44325.616928.335465@gargle.gargle.HOWL>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 20, 2017 at 08:44:21AM -0400, Dave Johnson wrote:
> 
> When recalculating the outer ICMPv6 checksum for a reverse path NATv6
> such as ICMPV6_TIME_EXCEED nf_nat_icmpv6_reply_translation() was
> accessing data beyond the headlen of the skb for non-linear skb.  This
> resulted in incorrect ICMPv6 checksum as garbage data was used.
> 
> Signed-off-by: Dave Johnson <dave-kernel@centerclick.org>
> ---
> diff -rup linux-4.9.23.orig/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c linux-4.9.23/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
> --- linux-4.9.23.orig/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c	2017-04-18 01:12:30.000000000 -0400
> +++ linux-4.9.23/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c	2017-04-20 08:13:41.070493666 -0400
> @@ -229,7 +229,12 @@ int nf_nat_icmpv6_reply_translation(stru
>  		return 0;
>  
>  	if (skb->ip_summed != CHECKSUM_PARTIAL) {
> -		struct ipv6hdr *ipv6h = ipv6_hdr(skb);
> +		struct ipv6hdr *ipv6h;
> +
> +		if (!skb_make_writable(skb, skb->len))

can we just make sure what we need is linear? I mean, just the ipv6
header that is what we need, instead of the entire skbuff.
