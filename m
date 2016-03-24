From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ipv4: fix NULL dereference
Date: Thu, 24 Mar 2016 21:22:05 +0100
Message-ID: <20160324202205.GA2167@salvia>
References: <1458743250-4003-1-git-send-email-zlpwmdx@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
	davem@davemloft.net, kernel@kyup.com,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpwmdx@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57775 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbcCXUWO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Mar 2016 16:22:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 735E180B1B
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Mar 2016 21:22:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 151A4120402
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Mar 2016 21:22:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 30080120400
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Mar 2016 21:22:11 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1458743250-4003-1-git-send-email-zlpwmdx@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 23, 2016 at 10:27:30PM +0800, Liping Zhang wrote:
> diff --git a/net/ipv4/netfilter/ipt_SYNPROXY.c b/net/ipv4/netfilter/ipt_SYNPROXY.c
> index 7b8fbb3..6b4f501 100644
> --- a/net/ipv4/netfilter/ipt_SYNPROXY.c
> +++ b/net/ipv4/netfilter/ipt_SYNPROXY.c
> @@ -18,10 +18,10 @@
>  #include <net/netfilter/nf_conntrack_synproxy.h>
>  
>  static struct iphdr *
> -synproxy_build_ip(struct sk_buff *skb, __be32 saddr, __be32 daddr)
> +synproxy_build_ip(struct net *net, struct sk_buff *skb, __be32 saddr,
> +		  __be32 daddr)
>  {
>  	struct iphdr *iph;
> -	struct net *net = sock_net(skb->sk);
>  
>  	skb_reset_network_header(skb);
>  	iph = (struct iphdr *)skb_put(skb, sizeof(*iph));
> @@ -91,7 +91,8 @@ synproxy_send_client_synack(const struct synproxy_net *snet,
>  		return;
>  	skb_reserve(nskb, MAX_TCP_HEADER);
>  
> -	niph = synproxy_build_ip(nskb, iph->daddr, iph->saddr);
> +	niph = synproxy_build_ip(nf_ct_net(snet->tmpl), nskb, iph->daddr,
> +				 iph->saddr);
>  
>  	skb_reset_transport_header(nskb);
>  	nth = (struct tcphdr *)skb_put(nskb, tcp_hdr_size);
> @@ -132,7 +133,8 @@ synproxy_send_server_syn(const struct synproxy_net *snet,
>  		return;
>  	skb_reserve(nskb, MAX_TCP_HEADER);
>  
> -	niph = synproxy_build_ip(nskb, iph->saddr, iph->daddr);
> +	niph = synproxy_build_ip(nf_ct_net(snet->tmpl), nskb, iph->saddr,
> +				 iph->daddr);

Could you also pass net as parameter to synproxy_send_server_syn() ?

par->net provides this from synproxy_tg4().

Thanks.
