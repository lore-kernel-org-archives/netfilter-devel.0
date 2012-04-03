From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] netfilter: conntrack: drop malformed IPv4 packets
Date: Tue, 03 Apr 2012 21:41:19 +0200
Message-ID: <1333482079.18626.323.camel@edumazet-glaptop>
References: <1333481769-16747-1-git-send-email-kadlec@blackhole.kfki.hu>
	 <1333481769-16747-2-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:41917 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab2DCTlX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Apr 2012 15:41:23 -0400
Received: by wejx9 with SMTP id x9so43902wej.19
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Apr 2012 12:41:22 -0700 (PDT)
In-Reply-To: <1333481769-16747-2-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 2012-04-03 at 21:36 +0200, Jozsef Kadlecsik wrote:
> It was reported that the Linux kernel sometimes logs:
> 
> klogd: [2629147.402413] kernel BUG at net / netfilter /
> nf_conntrack_proto_tcp.c: 447!
> klogd: [1072212.887368] kernel BUG at net / netfilter /
> nf_conntrack_proto_tcp.c: 392
> 
> ipv4_get_l4proto() in nf_conntrack_l3proto_ipv4.c and tcp_error() in
> nf_conntrack_proto_tcp.c should catch malformed packets, so the errors
> at the indicated lines - TCP options parsing - should not happen.
> However, tcp_error() relies on the "dataoff" offset to the TCP header,
> calculated by ipv4_get_l4proto().  But ipv4_get_l4proto() does not check
> bogus ihl values in IPv4 packets, which then can slip through tcp_error()
> and get caught at the TCP options parsing routines.
> 
> The patch fixes ipv4_get_l4proto() by dropping packets with bogus
> ihl value.
> 
> The patch closes netfilter bugzilla id 771.
> 
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> ---
>  net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
> index de9da21..c93d052 100644
> --- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
> +++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
> @@ -84,6 +84,14 @@ static int ipv4_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
>  	*dataoff = nhoff + (iph->ihl << 2);
>  	*protonum = iph->protocol;
>  
> +	/* Check bogus IP headers */
> +	if (*dataoff > skb->len) {
> +		pr_debug("nf_conntrack_ipv4: drop bogus IPv4 packet: "
> +			 "nhoff %u, ihl %u, skblen %u\n",
> +			 nhoff, iph->ihl << 2, skb->len);
> +		return -NF_ACCEPT;

		return -NF_DROP; ?
		
> +	}
> +
>  	return NF_ACCEPT;
>  }
>  


