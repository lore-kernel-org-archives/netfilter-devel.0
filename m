Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A7F2628D;
	Tue, 19 May 2026 00:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779148912; cv=none; b=FGpIbq6Abo5rvFlOzn9YHk8gMEa3vYZvYQKSFzn7UWQ0mVcm3IvpsNq00IFs4FiuFPdMPGkg1sTbRNuKvCww+uGM5M2SEHmRSQ0oei+cAvqt9+5r0o3rjgr4cs2iHbviPT3RH9X9fFTzG65HlZNyaOPNwq4jltN4KC5wKXlamzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779148912; c=relaxed/simple;
	bh=Vx1T2sVOPlK1K93Q6Zt3mokeNmHHMEja+xsRuFpHJBs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bVrKktwImA434N/kBoCQiyJFPZphCXhGdUGpUmvd2r1PVPzU14U52W8NhHXVe7GcPE2dIFVTmAZD6jQsnt7vY61TdJQctFWvJcLnEylIBBLcDkjRqLobFY2eg7YazGEo2caC2Kv4JjVpHrsnSxJdjHCDY+9Ee361pY604SF6krQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K/FL+if2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K/FL+if2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54CF8C2BCB7;
	Tue, 19 May 2026 00:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779148911;
	bh=Vx1T2sVOPlK1K93Q6Zt3mokeNmHHMEja+xsRuFpHJBs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=K/FL+if2QZag8duyhhqmM5wLu9pl8sAups8YUG8O8C8c0nLOMAYuxMg1A5ifO/Dx0
	 d7/tt+AMMrsD064ssEkc1y5o6+fXY7qizJbUmvsPEkE6BMTH90weEajGJ7fT5JJIDH
	 qex717vLnwRj0xiEMQqcCm9OGzopKv8WKZu8gA6f21IqTLZWywfCSKktkeCFRm61VK
	 xQb24OvpcmwTaa9opS9zZM40Zu98jshWelMQZfS+GfpafMSw1UEjY5nLTx8TMSzjhY
	 MjXxi60dTq53iFfLoD5RD68ntP8ECZUc8EytytjDnwDtajfIM6miRiaTYEbHnTp1zR
	 qCIX9wLSeyl5A==
Date: Mon, 18 May 2026 17:01:50 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
 fw@strlen.de, horms@kernel.org
Subject: Re: [PATCH net 12/12] netfilter: nf_queue: hold bridge skb->dev
 while queued
Message-ID: <20260518170150.06a575c3@kernel.org>
In-Reply-To: <20260516115627.967773-13-pablo@netfilter.org>
References: <20260516115627.967773-1-pablo@netfilter.org>
	<20260516115627.967773-13-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 16 May 2026 13:56:27 +0200 Pablo Neira Ayuso wrote:
> diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
> index d17035d14d96..3978c3174cdb 100644
> --- a/include/net/netfilter/nf_queue.h
> +++ b/include/net/netfilter/nf_queue.h
> @@ -14,6 +14,7 @@ struct nf_queue_entry {
>  	struct list_head	list;
>  	struct rhash_head	hash_node;
>  	struct sk_buff		*skb;
> +	struct net_device	*skb_dev;
>  	unsigned int		id;
>  	unsigned int		hook_index;	/* index in hook_entries->hook[] */
>  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
> diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
> index a6c81c04b3a5..57b450024a99 100644
> --- a/net/netfilter/nf_queue.c
> +++ b/net/netfilter/nf_queue.c
> @@ -61,6 +61,7 @@ static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
>  	struct nf_hook_state *state = &entry->state;
>  
>  	/* Release those devices we held, or Alexey will kill me. */
> +	dev_put(entry->skb_dev);
>  	dev_put(state->in);
>  	dev_put(state->out);
>  	if (state->sk)
> @@ -102,6 +103,7 @@ bool nf_queue_entry_get_refs(struct nf_queue_entry *entry)
>  	if (state->sk && !refcount_inc_not_zero(&state->sk->sk_refcnt))
>  		return false;
>  
> +	dev_hold(entry->skb_dev);
>  	dev_hold(state->in);
>  	dev_hold(state->out);

Please follow up and add a ref tracker to this?
