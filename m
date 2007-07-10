From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: xt_connlimit 20070707 kernel
Date: Tue, 10 Jul 2007 15:30:09 +0900 (JST)
Message-ID: <200707100630.l6A6UB8Q000847@toshiba.co.jp>
References: <Pine.LNX.4.64.0707041708010.1536@fbirervta.pbzchgretzou.qr>
	<468E3E06.3080305@trash.net>
	<Pine.LNX.4.64.0707071950170.1536@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
To: jengelh@computergmbh.de
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707071950170.1536@fbirervta.pbzchgretzou.qr>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


From: Jan Engelhardt <jengelh@computergmbh.de>
Date: Mon, 9 Jul 2007 17:10:52 +0200 (CEST)

> +	} else {
> +		struct nf_conntrack_l3proto *l3proto;
> +		struct nf_conntrack_l4proto *l4proto;
> +
> +		l3proto = __nf_ct_l3proto_find(match->family);
> +		if (l3proto == NULL)
> +			goto hotdrop;
> +		l4proto = __nf_ct_l4proto_find(match->family, match->proto);
> +		if (l4proto == NULL)
> +			goto hotdrop;
> +		if (nf_ct_get_tuple(skb, 0, 0, match->family, match->proto,
> +		    &tuple, NULL, NULL) != 0)
> +			goto hotdrop;

The second argument is the offset to network protocol header,
skb_network_offset(skb) (it is 0 in most cases, but it is more logical).

The third argument is the offset to the transport protocol header. In the case
of IPv4, you can use ip_hdrlen(). About IPv6, you can use
nf_ct_ipv6_skip_exthdr(), but you also need to export the symbol of
nf_ct_ipv6_skip_exthdr().

IIRC nf_conntrack_proto_icmp[v6].c do same things. If I have any time
at late night today, I'll write a generic function for them.

-- Yasuyuki Kozakai
