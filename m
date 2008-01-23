From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] [NETFILTER]: xt_TCPMSS: Consider incoming device's
 MTU in clamp-to-pmtu
Date: Wed, 23 Jan 2008 15:20:42 +0100
Message-ID: <47974D3A.1020705@trash.net>
References: <Pine.LNX.4.64.0801201318040.14598@fbirervta.pbzchgretzou.qr> <47935127.30902@trash.net> <Pine.LNX.4.64.0801222204290.9183@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jaco Kroon <jaco@uls.co.za>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46494 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbYAWOVX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2008 09:21:23 -0500
In-Reply-To: <Pine.LNX.4.64.0801222204290.9183@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> +static u_int16_t tcpmss_reverse_mtu4(const struct iphdr *iph)
> +{
> +	struct rtable *rt = NULL;
> +	struct flowi fl = {.nl_u = {.ip4_u = {
> +		.daddr = iph->saddr,
> +		.tos   = RT_TOS(iph->tos),
> +		.scope = RT_SCOPE_UNIVERSE,
> +	}}};
> +
> +	ip_route_output_key(&rt, &fl);
> +	if (rt == NULL)
> +		return ~(u_int16_t)0;
> +	return dst_mtu(&rt->u.dst);

This leaks the dst_entry.

>  #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
> +static u_int16_t tcpmss_reverse_mtu6(const struct ipv6hdr *iph)
> +{
> +	struct rtable *rt = NULL;
> +	struct flowi fl = {.nl_u = {.ip6_u = {
> +		.daddr     = iph->saddr,
> +		.flowlabel = ((iph->flow_lbl[0] << 16) |
> +		             (iph->flow_lbl[1] << 8) | iph->flow_lbl[2]) &
> +		             0x00FFFFFF,
> +	}}};
> +
> +	ip_route_output_key(&rt, &fl);
> +	if (rt == NULL)
> +		return ~(u_int16_t)0;
> +	return dst_mtu(&rt->u.dst);

This also leaks and you probably want to do IPv6 routing :) But the
patch should use the ->route function from nf_af_info anyways
to avoid adding module dependencies.
