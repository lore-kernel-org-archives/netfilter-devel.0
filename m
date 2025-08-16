Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5934423D291
	for <netfilter-devel@vger.kernel.org>; Sat, 16 Aug 2025 14:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755354357; cv=none; b=kZLmYeykpne/zepCemf3/G26MIRIZ6xjmmLuAy+lkxJRy696R7xiY7XDmA5X7bZ8fISQQc96JSFGfw//J56s4nYxH8+Osn3KJwkIKOp2h2OiJHXPRNgokjHvXwIkGooNRI7vNNxc6R8RDaSxMISUWc0bXUeBigaCW3j6zZSM1+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755354357; c=relaxed/simple;
	bh=jb0QgzsegstPsJo7wP8GyaK9G2o9/oVVHqUNwfYgvXQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p/1ivGzuCw5uxT+QgixgfnZBxDM1/tYjxiGvgCO1Lz5ozXMzh31eWRtqxDWOtIeZ4d0Eu9QWuTy3U+aVaR+dTg59mD48eBXwdkEMHZnv7Qi+a+2Id/eX5zSgyVm4tsYbkWMzzx0WVJLu4Y2qa2V9r1p/WUb5FbTUK/JC7hUgSl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0DF57602B6; Sat, 16 Aug 2025 16:25:46 +0200 (CEST)
Date: Sat, 16 Aug 2025 16:25:44 +0200
From: Florian Westphal <fw@strlen.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH nf-next v2 3/3] netfilter: nft_set_pipapo: Use nested-BH
 locking for nft_pipapo_scratch
Message-ID: <aKCU6GGY05WO3p_7@strlen.de>
References: <20250815160937.1192748-1-bigeasy@linutronix.de>
 <20250815160937.1192748-4-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250815160937.1192748-4-bigeasy@linutronix.de>

Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> @@ -1170,20 +1170,18 @@ nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
>  	}
>  
>  	m = rcu_dereference(priv->match);
> -
> +	scratch = *raw_cpu_ptr(m->scratch);
> +	if (unlikely(!scratch)) {
> +		local_bh_enable();
> +		return false;

The function has been changed upstream to return a pointer.

> +	}
> +	__local_lock_nested_bh(&scratch->bh_lock);
>  	/* Note that we don't need a valid MXCSR state for any of the
>  	 * operations we use here, so pass 0 as mask and spare a LDMXCSR
>  	 * instruction.
>  	 */
>  	kernel_fpu_begin_mask(0);

Not sure this is correct.  If RT allows to migrate in BH before
the local lock is taken, then the if (unlikely(!irq_fpu_usable()))
check needs to be done after the local lock was taken, no?

I will place a pending pipapo change in the nf-next:testing
branch shortly in case you need to resend.

If its fine as-is, I can also rebase the pending pipapo_avx2 patches.

Let me know.
