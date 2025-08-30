Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A5A2AE89;
	Sat, 30 Aug 2025 01:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756518986; cv=none; b=Q4Wpw8Bh//9F0XaTqmm9yU3nHpK639pE7FHg7duWNrkaO1KhmKDCTvEnhXhFfoIqB4IyB4vkwjAF9uQIN7OczhCMQaGNJJO0joIdU8BKcXuBsQWMB+/NZQdpeSub4A8MlZJngoeBfwtEAhf5DdPPFab1hTYHPxle7hq1F6RJ9L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756518986; c=relaxed/simple;
	bh=lAdavuYfj4GlZbEeJeoqCtMB93ChCR4EeFMr4U6saKI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AZ/4pVqbzBwpe7goV3IFjZOQE77+vxa0reGuDndkqt36HK8tYikjGK8zkqEOm5TXAkFd1LdgmYUg6EJmyXTdAV/WbROUBcWwv76CahnkNbNOjCxEFXDsehdTb2rpQRIZvAX8ofMB3f3FpjdQHIrxBPTZhA6TusAFQQQxnOD4WYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jo16q0N4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jo16q0N4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A29C4CEF0;
	Sat, 30 Aug 2025 01:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756518985;
	bh=lAdavuYfj4GlZbEeJeoqCtMB93ChCR4EeFMr4U6saKI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jo16q0N4pzYjZN7AzuxlQdMIYgpCZYwog8/eaa6meh99/j4/Z4KXZWh2mdZXfj1w9
	 IqMzG5uGA18lC876evz/MhseWIIdWHwOJzRuUxRmNeksgzq25L6CGoes6c9JMdCNCA
	 KqNDES/+IQRVqqmrgOAR/9Z2X66gsup2qVT29CKRv7ieUmOt0SE8LoOkGTbIOfAdm+
	 LN90WWHeQWaJqPDNVN+HD5Mp+lKt0Rqg6EEl5bF1yYOfPhq9CxxZuqNKIpjGNfyCFB
	 6JCH6kpCm0r72rZoRzM+2Q3DywuTa97+0JXw6iOYxuow/yxX0eDUWU/ZqPZ7ZgHQ1x
	 eHchgUGmxJi9Q==
Date: Fri, 29 Aug 2025 18:56:24 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 <netfilter-devel@vger.kernel.org>, pablo@netfilter.org
Subject: Re: [PATCH net] netfilter: nft_flowtable.sh: re-run with random mtu
 sizes
Message-ID: <20250829185624.16d49050@kernel.org>
In-Reply-To: <20250828214918.3385-1-fw@strlen.de>
References: <20250828214918.3385-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 28 Aug 2025 23:49:18 +0200 Florian Westphal wrote:
> But all logs I saw show same scenario:
> 1. Failing tests have pmtu discovery off (i.e., ip fragmentation)
> 2. The test file is much larger than first-pass default (2M Byte)
> 3. peers have much larger MTUs compared to the 'network'.
> 
> These errors are very reproducible when re-running the test with
> the same commandline arguments.
> 
> The timeout became much more prominent with
> 1d2fbaad7cd8 ("tcp: stronger sk_rcvbuf checks"): reassembled packets
> typically have a skb->truesize more than double the skb length.
> 
> As that commit is intentional and pmtud-off with
> large-tcp-packets-as-fragments is not normal adjust the test to use a
> smaller file for the pmtu-off subtests.
> 
> While at it, add more information to pass/fail messages and
> also run the dscp alteration subtest with pmtu discovery enabled.

Thank you for fixing!
