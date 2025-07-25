Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6855825F994;
	Fri, 25 Jul 2025 23:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753487106; cv=none; b=SDSR5UvTumiDJ4tubuovIxlZR7jgDb4V2N9GkjSU4m56rZyX/0xW1dN5aOJKkSaOrV7/eCLLFg9aS+7j2NSi0Uc/2fprS3nX4yYzKYwGGnCo32pC3aztyI/Byx9FRGEs3bA8OrhKrqplTV4mzSbmSi7fVxdZxk1pKKNrcUyTpzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753487106; c=relaxed/simple;
	bh=3rdziaczc0a/lJCeDUd7v4a7aJxVb4hsGLAW/6wcH5E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RFzFF+wrGX7WVitjtI6fHNw4scgUYjnxz8SHFT268Mv1umCV7cRAuvOf6kcIMXpf1Fz4Y3Yl7fPMkB8IHe6ZyCytocVxZe7S5We543GFKVcLz3gxOwHk+BX2dT6gYtcJxzkCpNjje5qRqC4LHzOw7aYcvCilEh6QcgIwZR1XagI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tmxiU7LU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tmxiU7LU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9947DC4CEE7;
	Fri, 25 Jul 2025 23:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753487105;
	bh=3rdziaczc0a/lJCeDUd7v4a7aJxVb4hsGLAW/6wcH5E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=tmxiU7LUQNhMwDiUCxLyfnCgfL8dfSAilwn4J6+pThtI4f9Wrasr7O5nqKgDXVZi4
	 DdBnz39RFV+HVf1pz9+gF6lhTyEljhuK7agSIATFrOQJbVzJTKzS8XISCYNlZcBapG
	 gzpAlBNSBZJU2npK2e6gz7+gfoPTc7E3exvYEzp83qPIQlpT40LQ058LvV1+UTkTlB
	 5jNpKm/bcHxSbU4aWQ63MhDo2bGSbc4vzbv1jInXbm04t0i98SpyHs+yAuNNw5JFl+
	 T1vXVobyWtqnlRbDAaPe1QRCLRaZGRwKT7zadqP5JKDigYUKURekw0Gjb7EaJxO78b
	 247t5qoBbpkaQ==
Date: Fri, 25 Jul 2025 16:45:04 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
 fw@strlen.de, horms@kernel.org
Subject: Re: [PATCH net-next 13/19] netfilter: nft_set: remove one argument
 from lookup and update functions
Message-ID: <20250725164504.2c68da9a@kernel.org>
In-Reply-To: <20250725163729.268cb252@kernel.org>
References: <20250725170340.21327-1-pablo@netfilter.org>
	<20250725170340.21327-14-pablo@netfilter.org>
	<20250725163729.268cb252@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 25 Jul 2025 16:37:29 -0700 Jakub Kicinski wrote:
> On Fri, 25 Jul 2025 19:03:34 +0200 Pablo Neira Ayuso wrote:
> > diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> > index 08fb6720673f..36a4de11995b 100644
> > --- a/net/netfilter/nft_set_pipapo.c
> > +++ b/net/netfilter/nft_set_pipapo.c
> > @@ -407,8 +407,9 @@ int pipapo_refill(unsigned long *map, unsigned int len, unsigned int rules,
> >   *
> >   * Return: true on match, false otherwise.
> >   */
> > -bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
> > -		       const u32 *key, const struct nft_set_ext **ext)
> > +const struct nft_set_ext *
> > +nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
> > +		  const u32 *key)  
> 
> Warning: ../net/netfilter/nft_set_pipapo_avx2.c:1151 Excess function parameter 'ext' description in 'nft_pipapo_avx2_lookup'
> Warning: ../net/netfilter/nft_set_pipapo.c:412 Excess function parameter 'ext' description in 'nft_pipapo_lookup'
> 
> Hopefully this doesn't bubble up to htmldocs.
> Please follow up with the fix.

Ah, I take that back, looks like the next two commits fix these.
Bad squash perhaps..
