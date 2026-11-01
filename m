Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793575442;
	b=TMtDGlTbljt5zGCZHkr+mXZnDo3NnaCROOw3/KZb/Trz266BHKSDLhmvt+LKEsE3tKY7
	 0+eioznLEwzd76jjt5lJfhRwdoDsXSTUgVLS5B3B+a2R6WQMnoSZ2LQv49F0XtmAzkEqd
	 ens9UUkMC2+zfqKlnWoaVZMSRwRXg5TIt6VJKc/h5daOOMTsuULNMB0TViW+T7MOiOE+D
	 bYK7wTYGnPyBKYZGpk6rkj1CoISyi6nGOMr3rH6+5zrqVt1PWJFbxO9UKwThh+tA5hyOz
	 rxU0hLs3jozCOpSUj6n2bPuYpBQ6X//YE6bysnTZULvXMF8o0azqJfvBMAzAy91RXqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793575442;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=Ge9MIPB42VbouvDG+bVn+6h7dY6h9nMEzIi4vXf4uCU=;
	b=r0GB5lY3JkW7Jy0VaTsydlZk7ZBObAPGtZIrMl90uPJzKeHlfd2QZYxzPrqhks7W1s7N
	 sUxLIHYbUCMMWMWH0gfAi4zIoT6Sr9mPI9ATpz+yndId70imn2+q/bvLRg/etVf3eonRu
	 ca9/OCDy4o5EdrGbNIlfLsfuvWhYQJKtPmzmBLmNZP0sccirgc8elr52Ui2LoVCYljBQd
	 i1q0fm9+ZyKVKWVhiWSXX2c3LNYIhiDlZlRusEzGvmL++AbA5phEamLJE3d6r8vBC5CnP
	 y7Zdhxc3gH8wK66ScD3J4AArfANimsZFNd0Ja/nrAG7+wV/HjeaLtxGEFvow1XrZOrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=GtuIWiEH;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 5C40F606A324;
	Sun,  1 Nov 2026 23:24:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C40F606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=GtuIWiEH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793575438;
	bh=Ge9MIPB42VbouvDG+bVn+6h7dY6h9nMEzIi4vXf4uCU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GtuIWiEH+TEt4WOI6KMRoYXq78BIB6FQO4enG0iZPWcUr0DUilzAHoTcXl2ezriUz
	 0ahO428Rox8GqDoGv/bjHuLRKsDfMgnbHot4m7h1LmXTt2xaZ9EixAm0uuFfP/UpoI
	 4vIiysVYik55P+8Czf02TpV7q+8GZECC5eRULDREKcCIJhJvp32mZcao2bgx4k0Fwk
	 L/YBdE1XleEAwT3g865vKkcBhprRlUNKk1VxmB2bLxijhGZJHzNUbrRPNix7fu7Xym
	 sY4SE2of6zvcT5vtxc2SO/FBAwftf4E6r1NspPhvT3wuaj5vns+ut/wG1GdgmREIu0
	 Vq+SwuhFL0IVA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 6790260078;
	Mon,  2 Nov 2026 00:23:58 +0100 (CET)
Date: Mon, 2 Nov 2026 00:23:55 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Xingyuan Mo <hdthky0@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	"open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
	"open list:NETFILTER" <coreteam@netfilter.org>,
	"open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH nf] netfilter: nf_tables: fix flow rule leak in
 nft_delrule() error path
Message-ID: <aufKCw9iv5pMj2fy@chamomile>
References: <20261028062204.1079089-1-hdthky0@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261028062204.1079089-1-hdthky0@gmail.com>

On Wed, Oct 28, 2026 at 02:22:42PM +0800, Xingyuan Mo wrote:
> On the nf_tables_delrule_deactivate() failure path, nft_trans_destroy()
> frees the transaction but not the attached HW offload flow rule. Destroy
> the flow after the transaction to avoid memory leak.

For the record, alternative proposed patch:

https://patch.msgid.link/netfilter-devel/20261028112535.115054-1-pablo@netfilter.org

> Fixes: 63b48c73ff56 ("netfilter: nf_tables_offload: undo updates if transaction fails")
> Assisted-by: opencode:deepseek-v4
> Signed-off-by: Xingyuan Mo <hdthky0@gmail.com>
> ---
>  net/netfilter/nf_tables_api.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 59ac623e6805..ec56ea8c8436 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -752,7 +752,7 @@ static struct nft_trans *nft_trans_rule_add(struct nft_ctx *ctx, int msg_type,
>  
>  static int nft_delrule(struct nft_ctx *ctx, struct nft_rule *rule)
>  {
> -	struct nft_flow_rule *flow;
> +	struct nft_flow_rule *flow = NULL;
>  	struct nft_trans *trans;
>  	int err;
>  
> @@ -773,6 +773,8 @@ static int nft_delrule(struct nft_ctx *ctx, struct nft_rule *rule)
>  	err = nf_tables_delrule_deactivate(ctx, rule);
>  	if (err < 0) {
>  		nft_trans_destroy(trans);
> +		if (flow)
> +			nft_flow_rule_destroy(flow);
>  		return err;
>  	}
>  	nft_rule_expr_deactivate(ctx, rule, NFT_TRANS_PREPARE);
> -- 
> 2.43.0
> 
