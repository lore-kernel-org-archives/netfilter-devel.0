Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5051523E33E;
	Wed, 12 Mar 2025 15:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741793861; cv=none; b=O5r1ZfhkQyexgWJjcXOGcCN6NJ+dwWA5iA0CjKHOb5vd7aC+ljvp8b5U3pIPexUGoatlz8erv5WuUEy4Y6DFpy61hfHVr41h7diGfJ7icdkHSIjaigdeNh7+f8IpS/shPsCoLp8Hv1A3qu5wzJGl82NDmCCy9VIMznsk9CVQkFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741793861; c=relaxed/simple;
	bh=MIMRJHeLqPj9YK2SqWO3AWK7QuqZO5t8gr5q7INTS+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VHXnpii22w4wmJdKp+Nbf3d4Q4t6rOclXOGh34owBqsV/x3ksS8x7+leUe6JMrmvM1bM/pMFEB2HYaDf47vTymrwX0e0SIDt832Lw6oXy4/t6vnVuNOyrwYHi3ukrreGQmtwVqji/UHTwvVBfNACaKoBsq0ZoXRZOEWByYtDlwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=g8U7nk3l; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Y3lEvQj3; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="g8U7nk3l";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Y3lEvQj3"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 3211660295; Wed, 12 Mar 2025 16:37:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741793855;
	bh=FFGSVd9gGUh4YEdCjnzb9tDocLTTagr5nr1xrAINXfs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g8U7nk3l7+PlPWj3Y3kbM+KcfToxIMW0QfzCgbuMvpSiNuZ3JEBUgj5Y+DM3MkUMA
	 i9LKun7J9GJBr5neIP7cgo7KBPRQVPuovERyTnU9A8OedA3YhVLRc4Av63lECu9w9o
	 SIdZbSnQig/foI3voT4r971rihBb9N19XCdiPzXYP28NGPU0XHNlUVBFG6Y4S9peqR
	 1KuKKHVDTxxdDXY1Egvz2LP1gKyhtMGMHNItIAcokEUuk5CelQhB2uSp2/SCbZNQtu
	 mVQ5qJFrx47LM9/U6/PwbSl8uisV8d6a+vHeJmnvg3iUp0qprVXI7pCRNxcLemAqHn
	 0L3s3tS30DoWg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DA7D260295;
	Wed, 12 Mar 2025 16:37:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741793853;
	bh=FFGSVd9gGUh4YEdCjnzb9tDocLTTagr5nr1xrAINXfs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y3lEvQj3MV1oWWuwr8fyXOUyEH6/kmp8PieZncTgWBwfrjIPbZQHJXyjEgv7lsLZN
	 0i4OUMNV//AA0vqTHO7PV+PZMXzE9uVubXRPz6QdGQgSSTOgdRw+f5l0Tqc2i3svcS
	 dTFDGGPVhZD6v4ucMrGjX1cBwvudf/NqQ2keGC9dms1rnEhsq4ptomZ+r7rHgRnbYV
	 UcRMQg9kK2jTiL7Cfgc6X28xG5rgmSIeBR0fKKVvhfl2w8KVOnd3ghHUdOmeSELhjk
	 nUWmU1jz3pYHT+Gv6jF1g3em1J3cTVjZWPBiV6z4AVBPuFnJ35QNqpkcotQ0xsknbd
	 iY/GMLfRY6Wsg==
Date: Wed, 12 Mar 2025 16:37:29 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: lirongqing <lirongqing@baidu.com>
Cc: kadlec@netfilter.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH] net/netfilter: use kvfree_rcu to simplify the code
Message-ID: <Z9GqOZIlyVPj0eNl@calendula>
References: <20250122074450.3185-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250122074450.3185-1-lirongqing@baidu.com>

> diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
> index 2b8aac2..c751b0a 100644
> --- a/include/linux/netfilter.h
> +++ b/include/linux/netfilter.h
> @@ -111,28 +111,17 @@ struct nf_hook_entry {
>  	void				*priv;
>  };
>  
> -struct nf_hook_entries_rcu_head {
> -	struct rcu_head head;
> -	void	*allocation;
> -};
> -
>  struct nf_hook_entries {
>  	u16				num_hook_entries;
> +	struct rcu_head rcu;

This structure is accessed from the packet path.

>  	/* padding */
>  	struct nf_hook_entry		hooks[];
>  
>  	/* trailer: pointers to original orig_ops of each hook,
> -	 * followed by rcu_head and scratch space used for freeing
> -	 * the structure via call_rcu.
>  	 *
>  	 *   This is not part of struct nf_hook_entry since its only
>  	 *   needed in slow path (hook register/unregister):
>  	 * const struct nf_hook_ops     *orig_ops[]
> -	 *
> -	 *   For the same reason, we store this at end -- its
> -	 *   only needed when a hook is deleted, not during
> -	 *   packet path processing:
> -	 * struct nf_hook_entries_rcu_head     head

I think it is convenient to keep struct rcu_head at the end of it.
