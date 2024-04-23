Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368BC20B3E;
	Tue, 23 Apr 2024 20:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713905540; cv=none; b=KP35+Vp3Mf484yRHm+F+K73ovm+bfiHvcvOmAS3DzxXcnNb1Lm1X7zcZiUU6QaSmw4g9mXCTcOO8rF6RJrL8hKVSkq4HcwpRA6xRwAvXLRg+GcmQG7wQKwQfQVNOr7yFQP4gttjjziF6GUiSjA4nPYH4QQiLmEvd66keY6SSZTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713905540; c=relaxed/simple;
	bh=zvNqaxYezO5KYpnZSUD51TDSRefEBFV6Og5zBvNQxBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BpTTIcZZJ+MJSXqc5vx1+ZuKTe4gvQ81zelpm9rBZ2QHf0uHjUyhVNvNZZf1Vn5mxCcD7/ntN96XmO5tIG0pbv28sc5RJp/0QYqV/j/JIQnJCHCRcelHIK2451v3BPqPBq5kiH9z+0rnQyQZt/VBANbOBMBongYFE00nN2uu2Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pUO7jd9Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pUO7jd9Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F7CC116B1;
	Tue, 23 Apr 2024 20:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713905539;
	bh=zvNqaxYezO5KYpnZSUD51TDSRefEBFV6Og5zBvNQxBQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pUO7jd9QSDcGzIBnH6FdyBSLBvAJgX7+f8ozew8fK89ze1lWHTIWINP2aQ09loCLx
	 BKKmOGxmxAJC8/JMUfhnLdvyV+3NpcCbz0A2nLrWxMAn73w5AUDRUfwjq9SCkDUxO0
	 ckhZ9mB15GADIKQO7hNP3wWIhMGc9ijmXJ6K8ZgAo3yaAayvJQ9DDSVXxhaZ7z9pp0
	 nosUPQBmQsiz/jX4gjchDYvcba+STtlhTtNIa+3+O14g2REnOJZOnoSJiAjtd3RI8F
	 MmyjFN2zwUPwwkK0mr6+zAzBW6xeqkft97YJvniukrjmf2rOusUD0VQC3SJ5lpnvNE
	 YJ7v0J++3ZnrA==
Date: Tue, 23 Apr 2024 13:52:18 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH net-next 0/7] selftest: netfilter: additional cleanups
Message-ID: <20240423135218.7f4af1b7@kernel.org>
In-Reply-To: <20240423194221.GA6732@breakpoint.cc>
References: <20240423130604.7013-1-fw@strlen.de>
	<20240423095043.2f8d46fc@kernel.org>
	<20240423194221.GA6732@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 23 Apr 2024 21:42:21 +0200 Florian Westphal wrote:
> > The main thing that seems to be popping up in the netdev runner is:
> > 
> > # TEST: performance
> > #   net,port                                                      [SKIP]
> > #   perf not supported
> > 
> > What is "perf" in this case? Some NFT module? the perf tool is
> > installed, AFAICT..  
> 
> Its looking for the pktgen wrapper script
> (pktgen_bench_xmit_mode_netif_receive.sh).
> 
> I don't think it makes too much sense to have that run as part of the CI.
> 
> I can either remove this or move it under some special commandline
> option, or I can look into this and see if I can get it to run.

Hm, never used it myself but it makes me think of the extended ksft
vars:

 | TEST_PROGS_EXTENDED, TEST_GEN_PROGS_EXTENDED mean it is the
 | executable which is not tested by default.

https://docs.kernel.org/dev-tools/kselftest.html?highlight=test_progs_extended#contributing-new-tests-details
