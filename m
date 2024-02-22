Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB743FB31
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Feb 2024 10:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708599183; cv=none; b=s9lV2Mc/hCEVfAsiZDAW4NTrJIzNge3hxNKUwZsyTmadV60nerqj7Yu0jnZNH37oq+cZrsgTmIsXS6VG0KcY+I+/LISrFV4q3hRLVwkU+heEsCKr0xsuEnddUB0oIcRPJg6JGEHJy2fNiQg0ImNdmiUzjn0fg041Tvxuc2AgVWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708599183; c=relaxed/simple;
	bh=y1ynW5i1LcBqur/4TUCb1UZRKE0NqXPLk0ou0eC8YUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TCBOqgdSYLQLge8MPem8j1BzX8Db2QnMdHvoqwGiyC7j2MzSv2Qyen1Wngqf+hXynQ0IHUXFJcKfjC7yGeiwCZtfdUtV/W5wX9c0GK38VkBjmnNQVM98srw6U+8FAaSH0EXrgY/EK0OsKDiidbebaUBRE7EOlDus09Rj0Lvpyr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=58902 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rd6h5-00Cnri-Lm; Thu, 22 Feb 2024 11:52:50 +0100
Date: Thu, 22 Feb 2024 11:52:46 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ignat Korchagin <ignat@cloudflare.com>
Cc: kadlec@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, kernel-team@cloudflare.com,
	jgriege@cloudflare.com
Subject: Re: [PATCH v3] netfilter: nf_tables: allow NFPROTO_INET in
 nft_(match/target)_validate()
Message-ID: <ZdcnfnoEE10cV7gL@calendula>
References: <20240222103308.7910-1-ignat@cloudflare.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240222103308.7910-1-ignat@cloudflare.com>
X-Spam-Score: -1.7 (-)

Hi Ignat,

On Thu, Feb 22, 2024 at 10:33:08AM +0000, Ignat Korchagin wrote:
> Commit d0009effa886 ("netfilter: nf_tables: validate NFPROTO_* family") added
> some validation of NFPROTO_* families in the nft_compat module, but it broke
> the ability to use legacy iptables modules in dual-stack nftables.
> 
> While with legacy iptables one had to independently manage IPv4 and IPv6
> tables, with nftables it is possible to have dual-stack tables sharing the
> rules. Moreover, it was possible to use rules based on legacy iptables
> match/target modules in dual-stack nftables.
> 
> As an example, the program from [2] creates an INET dual-stack family table
> using an xt_bpf based rule, which looks like the following (the actual output
> was generated with a patched nft tool as the current nft tool does not parse
> dual stack tables with legacy match rules, so consider it for illustrative
> purposes only):
> 
> table inet testfw {
>   chain input {
>     type filter hook prerouting priority filter; policy accept;
>     bytecode counter packets 0 bytes 0 accept
>   }
> }

This nft command does not exist in tree, this does not restores fine
with nft -f. It provides a misleading hint to the reader.

I am fine with restoring this because you use it, but you have to find
a better interface than using nft_compat to achieve this IMO.

The upstream consensus this far is not to expose nft_compat features
through userspace nft. But as said, I understand and I am fine with
restoring kernel behaviour so you can keep going with your out-of-tree
patch.

Thanks !

> After d0009effa886 ("netfilter: nf_tables: validate NFPROTO_* family") we get
> EOPNOTSUPP for the above program.
> 
> Fix this by allowing NFPROTO_INET for nft_(match/target)_validate(), but also
> restrict the functions to classic iptables hooks.
> 
> Changes in v3:
>   * clarify that upstream nft will not display such configuration properly and
>     that the output was generated with a patched nft tool
>   * remove example program from commit description and link to it instead
>   * no code changes otherwise
> 
> Changes in v2:
>   * restrict nft_(match/target)_validate() to classic iptables hooks
>   * rewrite example program to use unmodified libnftnl
> 
> Fixes: d0009effa886 ("netfilter: nf_tables: validate NFPROTO_* family")
> Link: https://lore.kernel.org/all/Zc1PfoWN38UuFJRI@calendula/T/#mc947262582c90fec044c7a3398cc92fac7afea72 [1]
> Link: https://lore.kernel.org/all/20240220145509.53357-1-ignat@cloudflare.com/ [2]
> Reported-by: Jordan Griege <jgriege@cloudflare.com>
> Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
> ---
>  net/netfilter/nft_compat.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
> index 1f9474fefe84..d3d11dede545 100644
> --- a/net/netfilter/nft_compat.c
> +++ b/net/netfilter/nft_compat.c
> @@ -359,10 +359,20 @@ static int nft_target_validate(const struct nft_ctx *ctx,
>  
>  	if (ctx->family != NFPROTO_IPV4 &&
>  	    ctx->family != NFPROTO_IPV6 &&
> +	    ctx->family != NFPROTO_INET &&
>  	    ctx->family != NFPROTO_BRIDGE &&
>  	    ctx->family != NFPROTO_ARP)
>  		return -EOPNOTSUPP;
>  
> +	ret = nft_chain_validate_hooks(ctx->chain,
> +				       (1 << NF_INET_PRE_ROUTING) |
> +				       (1 << NF_INET_LOCAL_IN) |
> +				       (1 << NF_INET_FORWARD) |
> +				       (1 << NF_INET_LOCAL_OUT) |
> +				       (1 << NF_INET_POST_ROUTING));
> +	if (ret)
> +		return ret;
> +
>  	if (nft_is_base_chain(ctx->chain)) {
>  		const struct nft_base_chain *basechain =
>  						nft_base_chain(ctx->chain);
> @@ -610,10 +620,20 @@ static int nft_match_validate(const struct nft_ctx *ctx,
>  
>  	if (ctx->family != NFPROTO_IPV4 &&
>  	    ctx->family != NFPROTO_IPV6 &&
> +	    ctx->family != NFPROTO_INET &&
>  	    ctx->family != NFPROTO_BRIDGE &&
>  	    ctx->family != NFPROTO_ARP)
>  		return -EOPNOTSUPP;
>  
> +	ret = nft_chain_validate_hooks(ctx->chain,
> +				       (1 << NF_INET_PRE_ROUTING) |
> +				       (1 << NF_INET_LOCAL_IN) |
> +				       (1 << NF_INET_FORWARD) |
> +				       (1 << NF_INET_LOCAL_OUT) |
> +				       (1 << NF_INET_POST_ROUTING));
> +	if (ret)
> +		return ret;
> +
>  	if (nft_is_base_chain(ctx->chain)) {
>  		const struct nft_base_chain *basechain =
>  						nft_base_chain(ctx->chain);
> -- 
> 2.39.2
> 
