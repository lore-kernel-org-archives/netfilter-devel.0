Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE5D29A2;
	Thu, 14 Aug 2025 00:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755133062; cv=none; b=NxITwBxXdjHJZgIAyjGTCFbmcYHRlo3qpH0dGmmR4z9/MU2qSt+dQCP+nBbqT9A+sv2fH8sLqqn4Yp9vkuI00J6AmOS9leWwmbu608aVnDh4BVYZSEP5CxL9LBfZc8gt0/YIdtjPNst5ZmWxYE4OE6fkZcMCKorvFzWwS3oXDEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755133062; c=relaxed/simple;
	bh=+IMn7C7Sq7bYpHjCzCPlaS5XdaZQiDEZ1iugmJAtHog=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J0PiAewlnW9yyaofWhQT6PzZ/H2+yzOyTKmQ/mTycmyS8aTaJVn+SKlusfvoYQCcvD6GJyjRDNJgX4C0dDKy4JSu0DbtUH+Ya2WRfmqssFq38kaLL/pq5vWU2o+G/5jH3Dwc+DGiqu6EEwcTUCkNNThOeg/G5UIOXRTPLaECDF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jHgwLrac; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jHgwLrac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22FA7C4CEEB;
	Thu, 14 Aug 2025 00:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755133061;
	bh=+IMn7C7Sq7bYpHjCzCPlaS5XdaZQiDEZ1iugmJAtHog=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jHgwLracLj2YbX6WDRy0A4VQVgtQT1qXrNFyJAt+GbhZB7mGmr3RiSjOojOjW5vO/
	 oaL/zI8FfYZxdtJ1czykMF0XWbQGVzf5Vhzqi6s6UYgpA/JYxpbeBCTmni72XF37HT
	 Bl09K7vU7fMF1vARG3t6qdh+a9pYA5A20d7/nYB4Ac2eszh/WuBKj4mlN2W4t4Qna1
	 ABVfNLomGg1snZPFGrVZKychbQzfjXUvhJxvZRLk8ADWTRlTJM/EGlOJ2hku0RXVsR
	 UB37HG7X9+YwYVjQOIGuwsRJ/zhJKYGDS9ndJOt6tthi8FWRQ01/9Mcr/Xa8OSNxNw
	 nPZPna1zGI/BA==
Date: Wed, 13 Aug 2025 17:57:40 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Stanislav Fomichev <sdf@fomichev.me>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, ayush.sawal@chelsio.com, andrew+netdev@lunn.ch,
 gregkh@linuxfoundation.org, horms@kernel.org, dsahern@kernel.org,
 pablo@netfilter.org, kadlec@netfilter.org, steffen.klassert@secunet.com,
 mhal@rbox.co, abhishektamboli9@gmail.com, linux-kernel@vger.kernel.org,
 linux-staging@lists.linux.dev, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, herbert@gondor.apana.org.au
Subject: Re: [PATCH net-next 1/7] net: Add skb_dst_reset and skb_dst_restore
Message-ID: <20250813175740.4c24e747@kernel.org>
In-Reply-To: <20250812155245.507012-2-sdf@fomichev.me>
References: <20250812155245.507012-1-sdf@fomichev.me>
	<20250812155245.507012-2-sdf@fomichev.me>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 12 Aug 2025 08:52:39 -0700 Stanislav Fomichev wrote:
> +/**
> + * skb_dst_reset() - return current dst_entry value and clear it
> + * @skb: buffer
> + *
> + * Resets skb dst_entry without adjusting its reference count. Useful in
> + * cases where dst_entry needs to be temporarily reset and restored.
> + * Note that the returned value cannot be used directly because it
> + * might contain SKB_DST_NOREF bit.
> + *
> + * When in doubt, prefer skb_dst_drop() over skb_dst_reset() to correctly
> + * handle dst_entry reference counting.

thoughts on prefixing these two new helpers with __ to hint that
they are low level and best avoided?

> + *
> + * Returns: original skb dst_entry.
> + */
> +static inline unsigned long skb_dst_reset(struct sk_buff *skb)
> +{
> +	unsigned long refdst = skb->_skb_refdst;
> +
> +	skb->_skb_refdst = 0;
> +	return refdst;
> +}
> +
> +/**
> + * skb_dst_restore() - restore skb dst_entry saved via skb_dst_reset

saved -> removed ?
Also I think for better kdoc linking it's good to add () after function
names

> + * @skb: buffer

kdoc missing for refdst

> + */
> +static inline void skb_dst_restore(struct sk_buff *skb, unsigned long refdst)
> +{
> +	skb->_skb_refdst = refdst;
