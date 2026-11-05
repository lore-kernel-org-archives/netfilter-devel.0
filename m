Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793881812;
	b=Z82I67jOo6zTMKzvfSFBB2+FvIubakaxTTaMJHBlSVFXbtXfMiQU1kyKIAcHlmEwhH9o
	 e0vrvAD1YHeM8U7S7uvonKkIs8g/m1Yr7U+gQjyt6XLClkG/xhW+tTSHI050O/3uxUu7I
	 gCM9jv+NubPYesmbOjdNsKoQPaJzybm2uH7uX0m3NfiWTCQ2lfrOxwAhq1yBYzwIpaiMR
	 vhgARN7TxWmZ34HuF4MlqMHXebZzu37oN2mGgcgP8CCAJP6+cahF+XV34EQAkixA6OGyD
	 YJBie5ZiXtI/qj6pOaSXM7dvaMjaXexzuUbmwtjVJn4uSu5qy8c441s2vObEDGpbPIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793881812;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=QakUyBDErgRXiJ0ckzUn1Er0kMcNvtv0U8whHoiAyx0=;
	b=CW+Q74mUpFG/gCf8GOMAi0HXE5f0TPTgo1sHYoIlWTVhe5kZR5N6IDIprc3kJRLkUQOm
	 5Sq1TL+yR4P4qkNAL6AgdU36E1SEby2m3aTJ7lsngTkW1AYfsO5tDuo+wCFSk0TNqNCH7
	 M1Dg52naTG6sniwi1IoFjjvd1Tt23iSkQl9XsvWFE0aH/pLNnMVWMnqp6A998mr5T2lxz
	 Kow4m1254kISCt7QbFbc2kmjKY/Kj8XfCKO8Nq4hWoPPAecKal8/faSt+V9i+jQIi47HC
	 orCuvGZxiLz2/BZWn2u6k9S2R58MuFrN24rpvZa2XRIajJeTa4azoZ2MnEhbWmdFk3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=I4oqW2lx;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 2B505606A32E;
	Thu,  5 Nov 2026 12:30:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B505606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=I4oqW2lx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793881808;
	bh=QakUyBDErgRXiJ0ckzUn1Er0kMcNvtv0U8whHoiAyx0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I4oqW2lxhBpda3ZMqlF0pnEVvYTTO2EArEb6C6K4zh2HiyEeh8kOMqyuJw7MATnIS
	 dEhIEGGH/v8xhpTJlF0Xrtr3tRYwbqmQ3RBUmxuqTk29tivKssyuDFCBjlDP739/Ph
	 RjH/GZPGFjQXUMpP1dQf40bKaVsEEvXIiP6GffjuY9PWuVyPcgH4qfY3PRdKSQkJPx
	 5KGD/L3SRhlHXcurmHjhUXCmwq5J3Ooh7j3D4S50IPv5971AzLXbmhMSRJcv26q7lS
	 wWs0tYDNwQil36n+PVbQXKRiAYjmJipxnkkd1mQgwTKy2l6DkVBNtJ5XD3hPQT0O0z
	 lKBxDErODFjZA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 5C93560052;
	Thu,  5 Nov 2026 13:30:08 +0100 (CET)
Date: Thu, 5 Nov 2026 13:30:05 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Henry Martin <bsdhenrymartin@gmail.com>
Cc: fw@strlen.de, davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
	pabeni@redhat.com, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_tables: fix pernet use-after-free on
 UNREGISTER rebroadcast
Message-ID: <aux2zX3dLKYnzG56@chamomile>
References: <20261105114817.3033625-1-bsdhenrymartin@gmail.com>
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
In-Reply-To: <20261105114817.3033625-1-bsdhenrymartin@gmail.com>

On Thu, Nov 05, 2026 at 07:48:17PM +0800, Henry Martin wrote:
> A device unregistered outside its netns teardown can be stuck in
> netdev_wait_allrefs_any() while the pernet exit handlers of its
> netns run to completion.  The nftables pernet storage is freed on
> that path.  The rebroadcasts then hit the nf_tables netdev
> notifiers (base chain, flowtable, offload), which read the freed
> storage via nft_pernet() and take commit_mutex on it, e.g. on
> mainline v7.4-rc1 (KASAN build):
> 
>     BUG: KASAN: slab-use-after-free in nf_tables_netdev_event+0x17c
>     Read of size 8 at addr ffff88811061c980 by task ip/422
>     Call Trace:
>      nf_tables_netdev_event+0x17c/0x1c0
>     Freed by task 62:
>      kfree+0x161/0x450
>      net_passive_dec+0xe5/0x180
>      cleanup_net+0x45a/0x780

Could ypu pass on a reproducer?

> Skip the rebroadcasts in all three notifiers, which are the only
> NETDEV_UNREGISTER events delivered with reg_state ==
> NETREG_UNREGISTERED.  This mirrors commit fd0909e963ed8
> ("netdev-genl: ignore NETDEV_UNREGISTER rebroadcasts").
> 
> This issue was discovered by Tencent CodeBuddy Security.
> 
> Fixes: 8a4fc54b07d75 ("net: get rid of rtnl_lock_unregistering()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
> ---
>  net/netfilter/nf_tables_api.c     | 9 +++++++++
>  net/netfilter/nf_tables_offload.c | 8 ++++++++
>  net/netfilter/nft_chain_filter.c  | 9 +++++++++
>  3 files changed, 26 insertions(+)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 59ac623e6805f..e43a1b9fefc36 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -9902,6 +9902,15 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
>  	    event != NETDEV_CHANGENAME)
>  		return NOTIFY_DONE;
>  
> +	/* netdev_wait_allrefs_any() rebroadcasts NETDEV_UNREGISTER
> +	 * while waiting for the last references to be dropped; the
> +	 * netns and its nftables pernet storage may already be torn
> +	 * down by then.
> +	 */
> +	if (event == NETDEV_UNREGISTER &&
> +	    READ_ONCE(dev->reg_state) == NETREG_UNREGISTERED)
> +		return NOTIFY_DONE;
> +
>  	net = dev_net(dev);
>  	nft_net = nft_pernet(net);
>  	mutex_lock(&nft_net->commit_mutex);
> diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
> index 0ac3c26dfb3d1..d360e233d0366 100644
> --- a/net/netfilter/nf_tables_offload.c
> +++ b/net/netfilter/nf_tables_offload.c
> @@ -672,6 +672,14 @@ static int nft_offload_netdev_event(struct notifier_block *this,
>  	if (event != NETDEV_UNREGISTER)
>  		return NOTIFY_DONE;
>  
> +	/* netdev_wait_allrefs_any() rebroadcasts NETDEV_UNREGISTER
> +	 * while waiting for the last references to be dropped; the
> +	 * netns and its nftables pernet storage may already be torn
> +	 * down by then.
> +	 */
> +	if (READ_ONCE(dev->reg_state) == NETREG_UNREGISTERED)
> +		return NOTIFY_DONE;
> +
>  	nft_net = nft_pernet(net);
>  	mutex_lock(&nft_net->commit_mutex);
>  	chain = __nft_offload_get_chain(nft_net, dev);
> diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
> index e04e689f22284..b3cfe8d426753 100644
> --- a/net/netfilter/nft_chain_filter.c
> +++ b/net/netfilter/nft_chain_filter.c
> @@ -412,6 +412,15 @@ static int nf_tables_netdev_event(struct notifier_block *this,
>  	    event != NETDEV_CHANGENAME)
>  		return NOTIFY_DONE;
>  
> +	/* netdev_wait_allrefs_any() rebroadcasts NETDEV_UNREGISTER
> +	 * while waiting for the last references to be dropped; the
> +	 * netns and its nftables pernet storage may already be torn
> +	 * down by then.
> +	 */
> +	if (event == NETDEV_UNREGISTER &&
> +	    READ_ONCE(dev->reg_state) == NETREG_UNREGISTERED)
> +		return NOTIFY_DONE;
> +
>  	nft_net = nft_pernet(dev_net(dev));
>  	mutex_lock(&nft_net->commit_mutex);
>  
> -- 
> 2.43.7
> 
