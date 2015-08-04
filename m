From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 2/3] netfilter: factor out packet duplication for
 IPv4/IPv6
Date: Tue, 4 Aug 2015 13:48:10 +0200
Message-ID: <20150804114810.GE20471@breakpoint.cc>
References: <1438684042-13709-1-git-send-email-pablo@netfilter.org>
 <1438684042-13709-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38689 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933134AbbHDLsM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2015 07:48:12 -0400
Content-Disposition: inline
In-Reply-To: <1438684042-13709-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Extracted from the xtables TEE target. This creates two new modules for IPv4
> and IPv6 that are shared between the TEE target and the new nf_tables dup
> expressions.

> diff --git a/net/ipv4/netfilter/nf_dup_ipv4.c b/net/ipv4/netfilter/nf_dup_ipv4.c
> new file mode 100644
> index 0000000..feba24a
> --- /dev/null
> +++ b/net/ipv4/netfilter/nf_dup_ipv4.c
> +unsigned int nf_dup_ipv4(struct sk_buff *skb, unsigned int hooknum,
> +			 const struct in_addr *gw, int oif)
> +{
> +	struct iphdr *iph;
> +
> +	if (__this_cpu_read(nf_skb_duplicated))
> +		return XT_CONTINUE;

Nit: seems function doesn't need to return anything.
So the use of XT_* outisde xt core can be avoided.
