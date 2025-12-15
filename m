Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5AD212552;
	Mon, 15 Dec 2025 14:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765810451; cv=none; b=dlC2F6FrJxuJyWzDyA7P5mynXmyhVujWqCRyarI3/iwWwrLqfcNbGNLQ35HFq6ZLdd10IIyqxBwSvKwRwmwTKMBBvjE7yldf7j1Eo5llohf75FK9OLTZTWZQr2juUCzCZ0HOMfLT4UXyrR2MzQeoV3GmdLdBHy40cXs/v9uOLkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765810451; c=relaxed/simple;
	bh=ARCFJ4UaENCh2gfJ1dvzIvibZmHssKvXiaXSgTeZ/NA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HrPrtPqVCqHZDRqi9rbsRlpYKXOlhEraka0jIu7XAOVONKPDC9MuXwpG3ymAvX3WgCQgNWhl4lgJK2Il5J853iZ47EeymxGIjAThyISRCQmauOo8kr37i1oErShXWyIERrBMygrD6z9vGnzn9d+pTBujJX4XPYISgqsX15Xt4uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CyDG9oiw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CyDG9oiw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB76EC4CEF5;
	Mon, 15 Dec 2025 14:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765810450;
	bh=ARCFJ4UaENCh2gfJ1dvzIvibZmHssKvXiaXSgTeZ/NA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CyDG9oiwCBUhjtkbn+tAN/W/rpOEiCieHXkiJgWdHLti0InwQDmX7lHxCJT7Ur/HT
	 xnh9Lhb8G1QCB2g68ddAWcVcGryBIak1WY9C6bhNLKnofzdpOogiqHYY2YCixU8JAj
	 B6NVEV//BvfIK/9BasUxADTY6guwZc74ISQfSs2BpX7et+4CO6b98wDAfA3W254uNk
	 Oj60PXAwtk9xdFZUOQIDkRdsufjTqRVUAtGH8MgxwDXkg719puOAIORvJrRZHGFg+t
	 KoFgW2F9AtK0zgUhBpwQd6loFkbciWhLAfCbfWyD89jYYbDaOemDDXUapl8lZ9yKU7
	 ZEhFG6xXdfnlw==
Date: Mon, 15 Dec 2025 14:54:05 +0000
From: Simon Horman <horms@kernel.org>
To: Anders Grahn <anders.grahn@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Anders Grahn <anders.grahn@westermo.com>,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_counter: Fix reset of counters on 32bit
 archs
Message-ID: <aUAhDdMGykBb2BOg@horms.kernel.org>
References: <20251215121258.843823-1-anders.grahn@westermo.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215121258.843823-1-anders.grahn@westermo.com>

On Mon, Dec 15, 2025 at 01:12:57PM +0100, Anders Grahn wrote:
> nft_counter_reset() calls u64_stats_add() with a negative value to reset
> the counter. This will work on 64bit archs, hence the negative value
> added will wrap as a 64bit value which then can wrap the stat counter as
> well.
> 
> On 32bit archs, the added negative value will wrap as a 32bit value and
> _not_ wrapping the stat counter properly. In most cases, this would just
> lead to a very large 32bit value being added to the stat counter.
> 
> Fix by introducing u64_stats_sub().
> 
> Fixes: 4a1d3acd6ea8 ("netfilter: nft_counter: Use u64_stats_t for statistic")

Nit: there is a minor mismatch in the subject of the Fixes tag and
     git history: the trailing '.'
     I would go for this. But perhaps it doesn't matter.

Fixes: 4a1d3acd6ea8 ("netfilter: nft_counter: Use u64_stats_t for statistic.")

> Signed-off-by: Anders Grahn <anders.grahn@westermo.com>

...
