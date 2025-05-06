Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F23280003;
	Tue,  6 May 2025 13:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746537092; cv=none; b=aZEm/a10xtI+w3RJnJl2UVytFIDlN+kCh0up+biR5xL70xOUyoPCHzJwG961ifTq9f7bHHpNo6gaWIwy/QymeKABKBkrJCCZ83jhdm1/TNZ41lACk19+3SktudXDIe7it9xeE/j7C7VDuYl3XdwyEyY9fDtlsA9f2b8xJXRDOWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746537092; c=relaxed/simple;
	bh=Ru8GEfjobKh/eKJnXQs806zGlXmZXUBLV7rlfClj2F4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YeujHV1jaD3Cqc+qrWdJVIRYxvWjMHPqowyicqLvczCRBQKOwiizg1uzOTIrKz37q7suOTvOqok1boxh97PQRdraHuRNWegtWAUrsggmE0MG6qnYGT+CvWp0N9/aG9o/exh2zdBc5eiyu/ZaziWKhiZFgznYJv35mMMLl9bsRTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I8IoX8lF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I8IoX8lF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D707C4CEE4;
	Tue,  6 May 2025 13:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746537091;
	bh=Ru8GEfjobKh/eKJnXQs806zGlXmZXUBLV7rlfClj2F4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=I8IoX8lFYge36zjjsdGsdCn0scug3D95RuHvZ6zfvfs3AO/Gbm01hsiBtlfp+kvF0
	 rT//Q4hXOo7/pokDoVeHTw9TPH8YQXaOdhDDqClqvINXmICLJAkSgsQgx9oPs9FTrm
	 TNZFdAIQPPY9VjTW1vv1oixTsJgAnh/Ga0BLNsyg1QRT/5e2Zb0FHCQ+TXrA1IYXKK
	 rkRQO81WYn7QrwycIMEMeUa8g7R4F1EXgoGPBxtHywIE4fZNP9bMl6qYttphcPaGi9
	 LsRC5EW32vEsQEgS6Woo+t49BjxyVB4wamYQKVn/Oa0yaNL6p5WisUiejjEuH2W2RF
	 FEEpRwStloKrQ==
Date: Tue, 6 May 2025 06:11:25 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
 fw@strlen.de, horms@kernel.org
Subject: Re: [PATCH nf-next 2/7] selftests: netfilter: add conntrack stress
 test
Message-ID: <20250506061125.1a244d12@kernel.org>
In-Reply-To: <20250505234151.228057-3-pablo@netfilter.org>
References: <20250505234151.228057-1-pablo@netfilter.org>
	<20250505234151.228057-3-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  6 May 2025 01:41:46 +0200 Pablo Neira Ayuso wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> Add a new test case to check:
>  - conntrack_max limit is effective
>  - conntrack_max limit cannot be exceeded from within a netns
>  - resizing the hash table while packets are inflight works
>  - removal of all conntrack rules disables conntrack in netns
>  - conntrack tool dump (conntrack -L) returns expected number
>    of (unique) entries
>  - procfs interface - if available - has same number of entries
>    as conntrack -L dump
> 
> Expected output with selftest framework:
>  selftests: net/netfilter: conntrack_resize.sh
>  PASS: got 1 connections: netns conntrack_max is pernet bound
>  PASS: got 100 connections: netns conntrack_max is init_net bound
>  PASS: dump in netns had same entry count (-C 1778, -L 1778, -p 1778, /proc 0)
>  PASS: dump in netns had same entry count (-C 2000, -L 2000, -p 2000, /proc 0)
>  PASS: test parallel conntrack dumps
>  PASS: resize+flood
>  PASS: got 0 connections: conntrack disabled
>  PASS: got 1 connections: conntrack enabled
> ok 1 selftests: net/netfilter: conntrack_resize.sh

This test seems quite flaky on debug kernels:

https://netdev.bots.linux.dev/contest.html?test=conntrack-resize-sh&executor=vmksft-nf-dbg

# FAIL: proc inconsistency after uniq filter for nsclient2-whtRtS: 1968 != 1945
