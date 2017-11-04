From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH RFC,WIP 4/5] netfilter: nf_tables: flow offload expression
Date: Sat, 4 Nov 2017 02:19:17 +0100
Message-ID: <20171104011917.GJ9424@breakpoint.cc>
References: <20171103152636.9967-1-pablo@netfilter.org>
 <20171103152636.9967-5-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171103152636.9967-5-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> +static void nft_flow_offload_eval(const struct nft_expr *expr,
> +				  struct nft_regs *regs,
> +				  const struct nft_pktinfo *pkt)
> +{
[..]
> +	if (test_bit(IPS_HELPER_BIT, &ct->status))
> +		goto out;
> +
> +	if (ctinfo == IP_CT_NEW ||
> +	    ctinfo == IP_CT_RELATED)
> +		goto out;

Would it make sense to delay offload decision until l4 tracker has
set ASSURED bit?
