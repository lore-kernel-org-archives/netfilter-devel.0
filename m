Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6547125BA;
	Wed, 28 Aug 2024 22:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724885381; cv=none; b=SifwoRkjHwsn8Qb9fXU1s1odSzZvDOhNppd17RqJxEudoCKOxnBoT/Ps0PJQXtUD+fzeAYqtDOk6h4NbGdPB9i+XOu1sZIJEExyrg+WPvX9gjzH+mKX3t/mcrP6Qr53UvDW276ZRzcsLCQ+qtWJErJwjjIhpBad97ohDWyk+Vy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724885381; c=relaxed/simple;
	bh=4egG1FpImnoFP3Y6GdC1UWfhcNBEe+WLTr0+obxTxcw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RCNvQj6Ns2EjrenVg/SnRsTaRSZcTLzH3JQmsvqQoSgkZdF5USATuVGxwC5xorxikjvjBxhhdvsAI/csMjLlbMiLIVQPaBGhvai6TCiMkGZBTRpnrVI1hnD1NGPDop9K+6lV4s2t9/EgfFRhRNV6EV7zTACvIJZwMzQXCTDlQwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BIFUYZQP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BIFUYZQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F2EC4CEC0;
	Wed, 28 Aug 2024 22:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724885381;
	bh=4egG1FpImnoFP3Y6GdC1UWfhcNBEe+WLTr0+obxTxcw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BIFUYZQPPIoabWZPX2llog3Uc15dMRJT6/KIVwxem5fQyClJ3/ulKKX3KyHIafQa8
	 LUM17yFLa4e1GG3iwVENnmb0hEiEg+5peJq+mHcd5hnLfI6ROlhQP6NTFz1Tr1+aFl
	 kbscZqcrI86mxGX0scXUqYCKbqxtRDE9ZmStcaNTVQ5ihRSfudrfu/i0kjhdiYRDf7
	 kiaakga5Kxgl/a9p/LEFobim7FcSnsX+uyvuTwJNxX2b/aWZo4b3LFMOhHKdgsof+D
	 5Hg+9wiqS4+09ZDhBb9hNgNiW7DTzO4SatIkdeL9EPYqvMrElyp46H1eZ9mattx0au
	 iC83IhuwJW//w==
Date: Wed, 28 Aug 2024 15:49:40 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>, "David S. Miller"
 <davem@davemloft.net>
Subject: Re: [PATCH net-next] selftests: netfilter: nft_queue.sh: reduce
 test file size for debug build
Message-ID: <20240828154940.447ddc7d@kernel.org>
In-Reply-To: <20240827090023.8917-1-fw@strlen.de>
References: <20240826192500.32efa22c@kernel.org>
	<20240827090023.8917-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 27 Aug 2024 11:00:12 +0200 Florian Westphal wrote:
> The sctp selftest is very slow on debug kernels.

I think there may be something more going on here? :(

For reference net-next-2024-08-27--12-00 is when this fix got queued:

https://netdev.bots.linux.dev/contest.html?executor=vmksft-nf-dbg&test=nft-queue-sh

Since then we still see occasional flakes. But take a look at 
the runtime. If it's happy the test case takes under a minute.
When it's unhappy it times out (after 5 minutes). I'll increase
the timeout to 10 minutes, but 1min vs 5min feels like it may
be getting stuck rather than being slow..
