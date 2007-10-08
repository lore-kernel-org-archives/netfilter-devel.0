From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 10/13] iptables socket match
Date: Mon, 08 Oct 2007 10:32:57 +0200
Message-ID: <4709EB39.4010504@trash.net>
References: <20071002203942.11052.7303.stgit@nessa.odu> <20071002204451.11052.79411.stgit@nessa.odu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55891 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbXJHIfW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2007 04:35:22 -0400
In-Reply-To: <20071002204451.11052.79411.stgit@nessa.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

KOVACS Krisztian wrote:
> +config NETFILTER_XT_MATCH_SOCKET
> +	tristate '"socket" match support'
> +	depends on NETFILTER_TPROXY
> +	depends on NETFILTER_XTABLES

EXPERIMENTAL please.

> +static bool
> +socket_match(const struct sk_buff *skb,
> +	     const struct net_device *in,
> +	     const struct net_device *out,
> +	     const struct xt_match *match,
> +	     const void *matchinfo,
> +	     int offset,
> +	     unsigned int protoff,
> +	     bool *hotdrop)
> +{
> +	const struct iphdr *iph = ip_hdr(skb);
> +	struct udphdr _hdr, *hp;
> +	struct sock *sk;
> +
> +	/* TCP/UDP only */
> +	if (iph->protocol != IPPROTO_TCP && iph->protocol != IPPROTO_UDP)
> +		return false;


How about making sure that its only used in a -p udp or -p tcp
rule in ->checkentry() instead?
