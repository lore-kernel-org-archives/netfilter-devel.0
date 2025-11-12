Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCD92C375E;
	Wed, 12 Nov 2025 23:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762989027; cv=none; b=aol8hoZNhbgiyzhHU/jEnQ3n6luR3E3aE/3Hdy2aMbbVG2JcvQOrkCiwGOYx6TfT3mtAOTNmIDjP6LDaUpECCIxYVezvck+wHK4Gn9LlUsEINtPik2Us9BKtbFTjR24Z2WJ+tBiapolLJfD+WTwhULkIJLeln13F0vQK6ISfeyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762989027; c=relaxed/simple;
	bh=Gsx3zSy57rq++hugpVFLbKz3EFbiM2+8RVOotUfTjj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RnbWc04w3In7jA7hiGTNwE96c/Q8mYEr19rf9SVoM4rf+6ksvyQ/clQSoCw8zPhco8Hb3sH+V+KEl5RAuxmBE6aL+/iowWdNv0vuRNC1G6tkw3qnH/QnusoxoxYnG9Xt8Tfm1Hv3GJqf+/+qjeIO7nMozWhpIuFbMyEpqwBo/As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7F5226045F; Thu, 13 Nov 2025 00:10:16 +0100 (CET)
Date: Thu, 13 Nov 2025 00:10:16 +0100
From: Florian Westphal <fw@strlen.de>
To: Scott Mitchell <scott.k.mitch1@gmail.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, phil@nwl.cc,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Scott Mitchell <scott_mitchell@apple.com>
Subject: Re: [PATCH] netfilter: nfnetlink_queue: optimize verdict lookup with
 hash table
Message-ID: <aRUT2PIAqo3VY9SJ@strlen.de>
References: <20251112160333.30883-1-scott_mitchell@apple.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112160333.30883-1-scott_mitchell@apple.com>

Scott Mitchell <scott.k.mitch1@gmail.com> wrote:
>  static inline u_int8_t instance_hashfn(u_int16_t queue_num)
>  {
>  	return ((queue_num >> 8) ^ queue_num) % INSTANCE_BUCKETS;
> @@ -114,13 +153,63 @@ instance_lookup(struct nfnl_queue_net *q, u_int16_t queue_num)
>  	return NULL;
>  }
>  
> +static int
> +nfqnl_hash_resize(struct nfqnl_instance *inst, u32 hash_size)
> +{
> +	struct hlist_head *new_hash, *old_hash;
> +	struct nf_queue_entry *entry;
> +	unsigned int h, hash_mask;
> +
> +	/* lock scope includes kcalloc/kfree to bound memory if concurrent resizes.
> +	 * lock scope could be reduced to exclude the  kcalloc/kfree at the cost
> +	 * of increased code complexity (re-check of hash_size) and relaxed memory
> +	 * bounds (concurrent resize may each do allocations). since resize is
> +	 * expected to be rare, the broader lock scope is simpler and preferred.
> +	 */

I'm all for simplicity. but I don't see how concurrent resizes are
possible.  NFQNL_MSG_CONFIG runs under nfnetlink subsystem mutex.

Or did I miss something?

> +	new_hash = kcalloc(hash_size, sizeof(*new_hash), GFP_ATOMIC);

Since the hash table could be large I would prefer if this could
be GFP_KERNEL_ACCOUNT + kvcalloc to permit vmalloc fallback.

> +	if (nfqa[NFQA_CFG_HASH_SIZE]) {
> +		hash_size = ntohl(nla_get_be32(nfqa[NFQA_CFG_HASH_SIZE]));
> +	}

Nit, no { } here.
