From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 4/5] netfilter: nfnetlink_queue: add skb info attribute
Date: Tue, 16 Apr 2013 08:55:22 -0700
Message-ID: <1366127722.4459.139.camel@edumazet-glaptop>
References: <1366126328-25874-1-git-send-email-fw@strlen.de>
	 <1366126328-25874-5-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:56513 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933991Ab3DPPzZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Apr 2013 11:55:25 -0400
Received: by mail-pd0-f175.google.com with SMTP id g10so363670pdj.20
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Apr 2013 08:55:24 -0700 (PDT)
In-Reply-To: <1366126328-25874-5-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 2013-04-16 at 17:32 +0200, Florian Westphal wrote:
> Once we allow userspace to receive gso/gro packets, userspace
> needs to be able to determine when checksums appear to be
> broken, but are not.
> 
> NFQA_SKB_CSUMNOTREADY means 'checksums will be fixed in kernel
> later, pretend they are ok'.
> 
> NFQA_SKB_GSO could be used for statistics, or to determine when
> packet size exceeds mtu.
> 
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  
> +static int nfqnl_put_packet_info(struct sk_buff *nlskb, struct sk_buff *packet)
> +{
> +	__u32 flags = 0;
> +
> +	if (skb_is_gso(packet))
> +		flags = NFQA_SKB_GSO;
 
> +	if (packet->ip_summed == CHECKSUM_PARTIAL)
> +		flags |= NFQA_SKB_CSUMNOTREADY;
> +
> +	return nla_put_be32(nlskb, NFQA_SKB_INFO, htonl(flags));

Maybe you could avoid sending NFQA_SKB_INFO if flags == 0 ?



