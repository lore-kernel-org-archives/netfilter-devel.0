Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD4D4DA9D1;
	Mon, 21 Sep 2026 20:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790024163; cv=none; b=GNh/cxCw2Sw8q05FTQA0fNUVt+LJ49n88hI+hTYOVEZ5+VOxmrgAtFPRS9gDnO5tFoCn2G+SMwlQk4ilEcVdaUcDKWvLCR5loNvN8rDBh0gv6Kpa0vtyWTAFQDqsxHq5sIQbDlH/zlrLrxmiNTHtqAR+eRMMdNA/RVQCbXUycNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790024163; c=relaxed/simple;
	bh=+i6cRpNtBEzHYMrpNf00y+lGjF2sIw5lD6SYbb1JnjY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FYc2YR2rjU7ekHauq8TkZBQhRzcZ3Ng9uxqlJtv4N0tmvuHJ84TFnb5obQjVtHRTf1mArXdaIJy7dgCDTxhyI3EH7LAtS5DcEG9zd/VpjlrzC7KL1Rp7CtmkKDNzevB8m765uoN8HnkRFQYl+E+H9kX2IGY5LZX6FdBX4tA5P2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JZHzjVqc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JZHzjVqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77741F00898;
	Mon, 21 Sep 2026 20:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790024162;
	bh=+i6cRpNtBEzHYMrpNf00y+lGjF2sIw5lD6SYbb1JnjY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=JZHzjVqcphhmaSGc9M47n3RqNjQ4E4jg7Fu4R/3t143TilfS8/DBAQlF5JWXT69Xh
	 v3FxjPLmikEOb1gNGhwUwLAyaBrEKNj6awko1hEV7eyVVO3S0wWxmS7K5jikyeDK0G
	 q/pPngimJVrKb6u5HFHgK3ELNu9NRR8n+RhdfNlPRxPI95vjyBHwoZ7hvItH/jNe42
	 tTtARvxJadkwMQ3VXK5YqUERKZ5HVkcRDCeGmJ8oNTU3zGBGgBJnsjFTAyLsbaBXAb
	 K9W+fwgMU6Av3oQ3igWpSeaNRh9XVeiHCOWACoNTlin/dWWNlZCbUeysfXSJ/im4kx
	 zQZOINXw52E6Q==
Date: Mon, 21 Sep 2026 13:56:01 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
 horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: my summary of LLM judgement in this PR [was Re: [PATCH net
 01/10] netfilter: flowtable: publish HW_DEAD after worker is done]
Message-ID: <20260921135601.7c38826d@kernel.org>
In-Reply-To: <aqz8rw-6wovytXle@chamomile>
References: <20260916231652.127456-2-pablo@netfilter.org>
	<20260918020406.3513303-1-kuba@kernel.org>
	<aqz4cRSbfcJI1Gvs@chamomile>
	<aqz8rw-6wovytXle@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 18 Sep 2026 10:56:15 +0200 Pablo Neira Ayuso wrote:
> I'm sure these tools can help us get things better, I understand too
> we have to try them all so we can evaluate. But I'm starting to wonder
> if it is worth stalling the pipeline and retrigger a PR continuosly,
> when we can follow up for those that we deem to be addressed.

Yes, always your call. FWIW I'm also trying to get an AI reviewer
for netdev subsystems, we'll see if I can get it done before rage
quitting
