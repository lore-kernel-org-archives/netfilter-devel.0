From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] netfilter: don't track ICMPv6 negotiation message.
Date: Tue, 27 Jan 2009 19:07:08 +0900 (JST)
Message-ID: <200901271007.n0RA78tA025130@toshiba.co.jp>
References: <200901231110.n0NBARDe000646@toshiba.co.jp>
	<1232793178-10922-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: yasuyuki.kozakai@toshiba.co.jp, kaber@trash.net,
	netfilter-devel@vger.kernel.org
To: eric@inl.fr
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from inet-tsb5.toshiba.co.jp ([202.33.96.24]:58166 "EHLO
	imx2.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbZA0KHM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Jan 2009 05:07:12 -0500
Received: from arc1.toshiba.co.jp ([133.199.194.235])
	by imx2.toshiba.co.jp  with ESMTP id n0RA79oR005323
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2009 19:07:09 +0900 (JST)
Received: (from root@localhost)
	by arc1.toshiba.co.jp  id n0RA79f6027312
	for netfilter-devel@vger.kernel.org; Tue, 27 Jan 2009 19:07:09 +0900 (JST)
Received: from mx12.toshiba.co.jp (localhost [127.0.0.1])
	by ovp2.toshiba.co.jp  with ESMTP id n0RA79w8012229
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2009 19:07:09 +0900 (JST)
In-Reply-To: <1232793178-10922-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Can you s/autoconfiguration/Stateless Address Autoconfiguration, MLD, and MLDv2/
in commit log ?

Others are fine to me.

-- Yasuyuki Kozakai

From: Eric Leblond <eric@inl.fr>
Date: Sat, 24 Jan 2009 11:32:58 +0100

> This patch removes connection tracking handling for ICMPv6 messages
> related to autoconfiguration. They can be tracked because they are
> massively using multicast (on pre-defined address). But they are not
> invalid.
> 
> Signed-off-by: Eric Leblond <eric@inl.fr>
> ---
>  net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   21 +++++++++++++++++++++
>  1 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
> index 6f859c1..94ace19 100644
> --- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
> +++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
> @@ -53,6 +53,17 @@ static const u_int8_t invmap[] = {
>  	[ICMPV6_NI_REPLY - 128]		= ICMPV6_NI_QUERY +1
>  };
>  
> +static const u_int8_t noct_valid_new[] = {
> +	[ICMPV6_MGM_QUERY - 130] = 1,
> +	[ICMPV6_MGM_REPORT -130] = 1,
> +	[ICMPV6_MGM_REDUCTION - 130] = 1,
> +	[NDISC_ROUTER_SOLICITATION - 130] = 1,
> +	[NDISC_ROUTER_ADVERTISEMENT - 130] = 1,
> +	[NDISC_NEIGHBOUR_SOLICITATION - 130] = 1,
> +	[NDISC_NEIGHBOUR_ADVERTISEMENT - 130] = 1,
> +	[ICMPV6_MLD2_REPORT - 130] = 1
> +};
> +
>  static bool icmpv6_invert_tuple(struct nf_conntrack_tuple *tuple,
>  				const struct nf_conntrack_tuple *orig)
>  {
> @@ -182,6 +193,7 @@ icmpv6_error(struct net *net, struct sk_buff *skb, unsigned int dataoff,
>  {
>  	const struct icmp6hdr *icmp6h;
>  	struct icmp6hdr _ih;
> +	int type;
>  
>  	icmp6h = skb_header_pointer(skb, dataoff, sizeof(_ih), &_ih);
>  	if (icmp6h == NULL) {
> @@ -199,6 +211,15 @@ icmpv6_error(struct net *net, struct sk_buff *skb, unsigned int dataoff,
>  		return -NF_ACCEPT;
>  	}
>  
> +	type = icmp6h->icmp6_type - 130;
> +	if (type >= 0 && type < sizeof(noct_valid_new)
> +	    && noct_valid_new[type]) {
> +		skb->nfct = &nf_conntrack_untracked.ct_general;
> +		skb->nfctinfo = IP_CT_NEW;
> +		nf_conntrack_get(skb->nfct);
> +		return NF_ACCEPT;
> +	}
> +
>  	/* is not error message ? */
>  	if (icmp6h->icmp6_type >= 128)
>  		return NF_ACCEPT;
> -- 
> 1.5.6.3
> 
