Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A00736F8FE;
	Mon, 12 Oct 2026 07:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791790239; cv=none; b=MZxnBSWlRzqcT6Q/wHfqK6AUtGNIN6jN6VlSM9ATkgf6Om7vocd+H2DFP6Pt/SgtlW3CDW5LnB8CZkr9ifsGZS7mr7ANVKdKc+1Ko9TxcLSBYHSKiU2rALiuxa2aZsZJ1sWThXfjfN3u7iCLI0KYwwYFwAH4sp93GCbRnSvr6Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791790239; c=relaxed/simple;
	bh=gp7PRv3WjAiMJrp0DvXpRvTv3mwC8R3NiezXzUE7FxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=g/0dixHBq9TEMKoSNALm0KEp5fL8DXFvMAzXUdCVB5jVTgssMz6eSWoG9juIwgWiD8OQFBLGayLxH2dohQTtni2KLLX60Vpib/F1tsjlyNKv7XlY32Qe8kUdIV/LDgqCJVKrdcDdHWLqkAHq22V7axhaUxHi14hfziv0loLs2lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lyvDdFcJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lyvDdFcJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86B11F0089E;
	Mon, 12 Oct 2026 07:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791790238;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lyvDdFcJ1mHVYVQ190Nc0LXAcbD3tesD/0/fnIy1MNYYBgXIdDi6ligSIKeddFwsS
	 vKm60IMUkvmR/gSwKX85bzhQBDiciR/mH8rdCSy4RpWZimrmvBNcd4IBf5+9NopQfn
	 Udk+pn6c0NVSsUhCvZJxj6lrAae0kTawYDfh4DxU1Uwn/nPDjatyFmcD0943Xzcy7D
	 WHaZ/I8XvTHDe3c5AJ6mAj5ExjDcl+WqHcQnOT/MsvwedLKNc9Nf6/GY7Fty5A3DsW
	 NU0fJVsPuJ8S7tkz/vs0Qhg0ehFT8RBQN70NPwEgIfkHiO8mBRLqn7cKwsBXG6l5X/
	 4qU0djbai33Eg==
From: netdev-bot+sinfo@kernel.org
To: Guo Zihao <guozh23@xiaopeng.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf-next v3 1/2] netfilter: ebtables: ebt_802_3: check the
 LLC fields before reading them
Date: Mon, 12 Oct 2026 07:30:37 +0000
Message-ID: <179179023747.2527009.10483751544394941789@kernel.org>
In-Reply-To: <20261012072449.3240201-1-guozh23@xiaopeng.com>
References: <20261012072449.3240201-1-guozh23@xiaopeng.com>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

 - Whether the issue was actually triggered, or is only theoretical
   (e.g. found by code inspection). If it was triggered please include
   the symptoms, like the stack trace or error messages.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
