Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A7D18FDD2;
	Thu,  8 Aug 2024 15:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130893; cv=none; b=C2cJ/kO/Cuuup+yQHG1k5AnOVZvFTeae9MfhzvenClGiJKlFirbXzEIGOhr0IEcDwhHGPyGZKOF3AONamV+0zgEsCeLB7V4XMEjIo53dhRck+LwBQaJ9/G9npDmN3XBg4GnX4wBsgPJ3812gp+4eu04F/qmiuBZ7SE0A7QfToxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130893; c=relaxed/simple;
	bh=0uRnuvNXuYYOvZYAENADyANn3mrdqebJ+KvoYZLO/38=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gTXPr3JyhP5tcMOI1e6qawhkaSTif3SWmKbkXmHEzwBX3F7ZmXf4fkKoKRHiLaPowtyQ1CRabwXDv6gvRzxnBs7qb5+bjIXk1AlkHVJhR2ZLQXdce1sOzlQLkUadZrnC+rN15QKE8ulQXX25mL+P4+xrIInyOR5xGlGFFbu+HCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NH5UbwiJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NH5UbwiJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DBBC4AF09;
	Thu,  8 Aug 2024 15:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723130892;
	bh=0uRnuvNXuYYOvZYAENADyANn3mrdqebJ+KvoYZLO/38=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NH5UbwiJEVnv+xzM3zISyAdZbeXRXqdJSbiNOJj+OnpNN8JbQ+5seOwetuxFyZKd3
	 OA4kdjKAniJSyl7Lzy/QYqS5HIUKh/YVzWhUdsV2hn+w6wC392KV+PoyTAxTFt1Os7
	 VHCF6Ecn8q19rdcJif0Iwv7woP+Nrs4zqH06oI5f7ZbWipMRWDEDcsl+aQwHE8h081
	 1zyFnaFVbxZPajfQRYpYfHiiBMxSfeO+l1RTuUni7J1ZbWtJzYlmcjbrsw7wPVDrFQ
	 V12OqPty+tH+j0cW/oN+62fuHjTiYOiZclJtSK1tkegYMWsBJ/SpwoV0kMC46ZmxbJ
	 krnVloKYki42Q==
Date: Thu, 8 Aug 2024 16:28:08 +0100
From: Simon Horman <horms@kernel.org>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] netfilter: nf_tables: Add __percpu annotation to *stats
 pointer in nf_tables_updchain()
Message-ID: <20240808152808.GB3075665@kernel.org>
References: <20240806102808.804619-1-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240806102808.804619-1-ubizjak@gmail.com>

On Tue, Aug 06, 2024 at 12:26:58PM +0200, Uros Bizjak wrote:
> Compiling nf_tables_api.c results in several sparse warnings:
> 
> nf_tables_api.c:2740:23: warning: incorrect type in assignment (different address spaces)
> nf_tables_api.c:2752:38: warning: incorrect type in assignment (different address spaces)
> nf_tables_api.c:2798:21: warning: incorrect type in argument 1 (different address spaces)
> 
> Add __percpu annotation to *stats pointer to fix these warnings.
> 
> Found by GCC's named address space checks.
> 
> There were no changes in the resulting object files.
> 
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> ---
>  net/netfilter/nf_tables_api.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 481ee78e77bc..805227131f10 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -2642,7 +2642,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
>  	struct nft_table *table = ctx->table;
>  	struct nft_chain *chain = ctx->chain;
>  	struct nft_chain_hook hook = {};
> -	struct nft_stats *stats = NULL;
> +	struct nft_stats __percpu *stats = NULL;
>  	struct nft_hook *h, *next;
>  	struct nf_hook_ops *ops;
>  	struct nft_trans *trans;

Thanks, I agree that users of this local variable expect it
to be annotated as __percpu.

Reviewed-by: Simon Horman <horms@kernel.org>

