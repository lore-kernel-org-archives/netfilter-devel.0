Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE72540856;
	Fri, 25 Jul 2025 23:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753486651; cv=none; b=X9pwcSi9nLO0368POsTkPTREz2iAoW3L/Eeo3BiUwAKJRr+RdozUoExRrDg6UOU2ohP7XFscyl7P/ZuLSbPBQrEK6MfLia9Jja6Ihvzuwe/GdAoolRiaQBwIVZUyxLAhb7vwzCETX4dsKms1vGOKrATntOmobGuibbtcs3NBJKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753486651; c=relaxed/simple;
	bh=iwU3MNj25OyYz+V4+g9uFUZzTexbqcYEbZHp1a3m4zM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WdVUtaamNdCs3lb/3EvLUUB55VmucMjZopKMpOHDA5i0eBpnkIQ5eZo8Tgx1v8JLsYxpAs0b7MPECUmYoN2MBHQDuQ7j3u2svGcx6BmWZkNbYy0IjW+AZbzkU71G836nlMLFrFQLfVKMIW0Zu2gf52DqyWv3FEV7ckCDHeY+6bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L5DAWBra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L5DAWBra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E21C4CEE7;
	Fri, 25 Jul 2025 23:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753486650;
	bh=iwU3MNj25OyYz+V4+g9uFUZzTexbqcYEbZHp1a3m4zM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=L5DAWBraOACXIW0NnGzFnmjhkQ0a+zQQcAgwwX4i192KjY71kADZIM6cy+pFLBvm0
	 98ylm21zdn6XR+HoN/xoixHapi/BE1qvsRmNrqDQjuMf+cnTpkOFnDGabnRvawMw2p
	 hvsB9iLGekWaMnMHrBmWkEvhUhelbxda+9I7D1gR/t7QWBMPRg+wwq6ZnHoA2Kn0NN
	 vsh7ker3LykgjqD1jXJdAN6YRQS6hAnYQ5pfdNZFOuWLPN1UjcEARN2HgQklOeicro
	 YAWl37ahHKz15PV83BG+Wu1+zpPSEfgWsR1V8ETUAvpYLopmSMB3EodzSe1t0+RM9M
	 kKEbcB/6497HA==
Date: Fri, 25 Jul 2025 16:37:29 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
 fw@strlen.de, horms@kernel.org
Subject: Re: [PATCH net-next 13/19] netfilter: nft_set: remove one argument
 from lookup and update functions
Message-ID: <20250725163729.268cb252@kernel.org>
In-Reply-To: <20250725170340.21327-14-pablo@netfilter.org>
References: <20250725170340.21327-1-pablo@netfilter.org>
	<20250725170340.21327-14-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 25 Jul 2025 19:03:34 +0200 Pablo Neira Ayuso wrote:
> diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> index 08fb6720673f..36a4de11995b 100644
> --- a/net/netfilter/nft_set_pipapo.c
> +++ b/net/netfilter/nft_set_pipapo.c
> @@ -407,8 +407,9 @@ int pipapo_refill(unsigned long *map, unsigned int len, unsigned int rules,
>   *
>   * Return: true on match, false otherwise.
>   */
> -bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
> -		       const u32 *key, const struct nft_set_ext **ext)
> +const struct nft_set_ext *
> +nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
> +		  const u32 *key)

Warning: ../net/netfilter/nft_set_pipapo_avx2.c:1151 Excess function parameter 'ext' description in 'nft_pipapo_avx2_lookup'
Warning: ../net/netfilter/nft_set_pipapo.c:412 Excess function parameter 'ext' description in 'nft_pipapo_lookup'

Hopefully this doesn't bubble up to htmldocs.
Please follow up with the fix.
