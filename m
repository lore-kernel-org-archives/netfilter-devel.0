From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH nf-next] netfilter: meta: add PRANDOM support
Date: Tue, 16 Feb 2016 13:48:58 +0100
Message-ID: <56C31ABA.1050801@iogearbox.net>
References: <1455624554-16005-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:36397 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095AbcBPMtA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Feb 2016 07:49:00 -0500
In-Reply-To: <1455624554-16005-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On 02/16/2016 01:09 PM, Florian Westphal wrote:
> Can be used to randomly match a packet, e.g. for statistical traffic
> sampling.
>
> See commit 3ad0040573b0c00f8848
> ("bpf: split state from prandom_u32() and consolidate {c, e}BPF prngs")
> for more info why this doesn't use prandom_u32 directly.
>
> Unlike bpf nft_meta can be built as a module, so add an EXPORT_SYMBOL
> for prandom_seed_full_state too.
>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Signed-off-by: Florian Westphal <fw@strlen.de>
[...]
> @@ -241,6 +248,7 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
>   {
>   	struct nft_meta *priv = nft_expr_priv(expr);
>   	unsigned int len;
> +	static bool prand_inited __read_mostly;
>
>   	priv->key = ntohl(nla_get_be32(tb[NFTA_META_KEY]));
>   	switch (priv->key) {
> @@ -277,6 +285,13 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
>   	case NFT_META_OIFNAME:
>   		len = IFNAMSIZ;
>   		break;
> +	case NFT_META_PRANDOM:
> +		if (!prand_inited) {
> +			prandom_seed_full_state(&nft_prandom_state);
> +			prand_inited = true;
> +		}

Should this be: prandom_init_once() ?

> +		len = sizeof(u32);
> +		break;
>   	default:
>   		return -EOPNOTSUPP;
>   	}
>

Thanks,
Daniel
