Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212EB1AD3EB;
	Wed, 25 Sep 2024 11:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727265548; cv=none; b=QVt20YP792wZ/M0B2nDRIA79+W8U2MDRGwpmGAy3J5jnqqt41E1hdjSCbfFPGDbCxDGAb6itQQxiC65f52U0rvyP9NixAVpYAox+Evbo5PGnUfx//3juGEce8JtfhSGRPkprPuf1OF62d1trNoTTwWBJy8ncn/Loqt3I0yThCD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727265548; c=relaxed/simple;
	bh=PkRn6B9qktnCgt3WPUj+Onnd2cdwn+uHLAqfIQhypuo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uNog1TsMelXycvsODGBzmsev9feGSII4Yh2sxSuBvTIvdw6plhVYAsBVUJHxWH5c1/x3ecbwyyhPcPDcQFIFb7mUqTMdb9SDon5uh3X3QDbKU0Cvy30BnRjfVK5U5Bu0YtDC0qSbjWqX9+8C223uvF+/g1fnJWo8WRL3Db78WA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=53292 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1stQfT-0005hv-Pc; Wed, 25 Sep 2024 13:58:53 +0200
Date: Wed, 25 Sep 2024 13:58:50 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Florian Westphal <fw@strlen.de>, kadlec@netfilter.org,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.11 049/244] netfilter: nf_tables: don't
 initialize registers in nft_do_chain()
Message-ID: <ZvP6-utbwqWmP5_0@calendula>
References: <20240925113641.1297102-1-sashal@kernel.org>
 <20240925113641.1297102-49-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240925113641.1297102-49-sashal@kernel.org>
X-Spam-Score: -1.9 (-)

Hi Sasha,

This commit requires:

commit 14fb07130c7ddd257e30079b87499b3f89097b09
Author: Florian Westphal <fw@strlen.de>
Date:   Tue Aug 20 11:56:13 2024 +0200

    netfilter: nf_tables: allow loads only when register is initialized

so either drop it or pull-in this dependency for 6.11

Thanks.

On Wed, Sep 25, 2024 at 07:24:30AM -0400, Sasha Levin wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> [ Upstream commit c88baabf16d1ef74ab8832de9761226406af5507 ]
> 
> revert commit 4c905f6740a3 ("netfilter: nf_tables: initialize registers in
> nft_do_chain()").
> 
> Previous patch makes sure that loads from uninitialized registers are
> detected from the control plane. in this case rule blob auto-zeroes
> registers.  Thus the explicit zeroing is not needed anymore.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  net/netfilter/nf_tables_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
> index a48d5f0e2f3e1..75598520b0fa0 100644
> --- a/net/netfilter/nf_tables_core.c
> +++ b/net/netfilter/nf_tables_core.c
> @@ -256,7 +256,7 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
>  	const struct net *net = nft_net(pkt);
>  	const struct nft_expr *expr, *last;
>  	const struct nft_rule_dp *rule;
> -	struct nft_regs regs = {};
> +	struct nft_regs regs;
>  	unsigned int stackptr = 0;
>  	struct nft_jumpstack jumpstack[NFT_JUMP_STACK_SIZE];
>  	bool genbit = READ_ONCE(net->nft.gencursor);
> -- 
> 2.43.0
> 
