Return-Path: <SRS0=49hf=R5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71343C43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 07:47:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C1F320828
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 07:47:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731088AbfCZHrY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 03:47:24 -0400
Received: from ja.ssi.bg ([178.16.129.10]:53716 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725535AbfCZHrY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 03:47:24 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x2Q7k7hv002750;
        Tue, 26 Mar 2019 09:46:07 +0200
Date:   Tue, 26 Mar 2019 09:46:07 +0200 (EET)
From:   Julian Anastasov <ja@ssi.bg>
To:     Jacky Hu <hengqing.hu@gmail.com>
cc:     jacky.hu@walmart.com, jason.niesz@walmart.com,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH v6] ipvs: allow tunneling with gue encapsulation
In-Reply-To: <20190326012831.352-1-hengqing.hu@gmail.com>
Message-ID: <alpine.LFD.2.21.1903260930270.2201@ja.home.ssi.bg>
References: <20190326012831.352-1-hengqing.hu@gmail.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Tue, 26 Mar 2019, Jacky Hu wrote:

> ipip packets are blocked in some public cloud environments, this patch
> allows gue encapsulation with the tunneling method, which would make
> tunneling working in those environments.
> 
> Signed-off-by: Jacky Hu <hengqing.hu@gmail.com>
> ---
>  include/net/ip_vs.h             |  5 ++
>  include/uapi/linux/ip_vs.h      | 11 +++++
>  net/netfilter/ipvs/ip_vs_ctl.c  | 35 +++++++++++++-
>  net/netfilter/ipvs/ip_vs_xmit.c | 86 +++++++++++++++++++++++++++++++--
>  4 files changed, 132 insertions(+), 5 deletions(-)
> 

> diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
> index 473cce2a5231..36819c2fabf1 100644
> --- a/net/netfilter/ipvs/ip_vs_xmit.c
> +++ b/net/netfilter/ipvs/ip_vs_xmit.c

> @@ -1054,11 +1104,21 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
>  	if (IS_ERR(skb))
>  		goto tx_error;
>  
> -	if (iptunnel_handle_offloads(skb, __tun_gso_type_mask(AF_INET, cp->af)))
> +	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE)
> +		gso_type = SKB_GSO_UDP_TUNNEL;
> +	else
> +		gso_type = __tun_gso_type_mask(AF_INET, cp->af);

	Looks like we should request the IP segmentation. Looking
at skb_udp_tunnel_segment() we call the proper gso_inner_segment
handler but ipip_gso_segment() still requires its bit in gso_type.
So, in both functions we should do:

	gso_type = __tun_gso_type_mask();
	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE)
		gso_type |= SKB_GSO_UDP_TUNNEL;

	Probably, it can be tested with local client sending large
TCP packets...

> @@ -1134,17 +1197,32 @@ ip_vs_tunnel_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
>  	 */
>  	max_headroom = LL_RESERVED_SPACE(tdev) + sizeof(struct ipv6hdr);
>  
> +	tun_type = cp->dest->tun_type;
> +
> +	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE)
> +		max_headroom += sizeof(struct udphdr) + sizeof(struct guehdr);
> +
>  	skb = ip_vs_prepare_tunneled_skb(skb, cp->af, max_headroom,
>  					 &next_protocol, &payload_len,
>  					 &dsfield, &ttl, NULL);
>  	if (IS_ERR(skb))
>  		goto tx_error;
>  
> -	if (iptunnel_handle_offloads(skb, __tun_gso_type_mask(AF_INET6, cp->af)))
> +	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE)
> +		gso_type = SKB_GSO_UDP_TUNNEL;
> +	else
> +		gso_type = __tun_gso_type_mask(AF_INET6, cp->af);

	Here too

> +	if (iptunnel_handle_offloads(skb, gso_type))
>  		goto tx_error;

Regards

--
Julian Anastasov <ja@ssi.bg>
