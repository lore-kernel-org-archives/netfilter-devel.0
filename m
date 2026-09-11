Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB76A242D62;
	Fri, 11 Sep 2026 00:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789087780; cv=none; b=bo4l1fG1qWMbqsMjji8obznc7u/jtSlYCemrTqrWMRo16vtUQosETWUSN+ivGgc37xXW4NfmNFvOlxGu6gFITEKJ2arsjn8BygWC62sY8jPr7MV8ZyLNd0gMODWqQXhZ5zrek1pC+b8gXr0MSskyWPtg/8uH4DhVlzYncc8YTpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789087780; c=relaxed/simple;
	bh=J9JrAviEfMdIyV64ouQa+AlbVuuJmaLF4JmBfCIjzzQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UiNi5rYkHAoUwurvYaeoMcQ2+RI7YEHTjSzTmQIWj7wZzIeJsXsaoK3bxnJj0OTE+XjhumEkcfEEl0uQVso+lS+pGrtW+to3gLjp4dHA44fsRHcMjUv9YGBnvl0Zxaw2lw+UMv7/DP8a4julrQJsBGwLCiIMgovuBWrBq3X4eDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C3lAF5Dt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C3lAF5Dt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E7A1F000FF;
	Fri, 11 Sep 2026 00:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789087779;
	bh=J9JrAviEfMdIyV64ouQa+AlbVuuJmaLF4JmBfCIjzzQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=C3lAF5DtmLfF+7wb8YGIr11kixUnUFpfxmLhD2QVOMmj81p8uLmAI84oyAp2mEVkP
	 x9qXd/Tpw29jr1groJNHbighIJ1Dtvq7m/l7V5+ZRWN2jTiXjCHPL1LbuAHvI3tVjE
	 PgOlUuqLx04F7F+Hap9PpLbMv+5k5O/UEvXXJtNPz4pTojplZcjVWlmXqUneG+3bci
	 MUgP9dyXdi6Z3L4lrFUxGn+MYKrF5OCahssoqX9vCTt+sySm09qBlXZ4Ybkbyy/qVG
	 9l/ztxWfwNh9mYr5z+vn5dl6CLgErn6yQIH+bC+c/FOTuMEyiGmv3l1Eloenb2liGh
	 ly4zfvfM3f8/g==
Date: Thu, 10 Sep 2026 17:49:38 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
 horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 0/7] Netfilter/IPVS fixes for net
Message-ID: <20260910174938.1beb1544@kernel.org>
In-Reply-To: <20260909221844.1650275-1-pablo@netfilter.org>
References: <20260909221844.1650275-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 10 Sep 2026 00:18:37 +0200 Pablo Neira Ayuso wrote:
> The following patchset provides fixes for Netfilter/IPVS:

Sorry for the delay, patchwork breakage on Sunday created a persistent
backlog for our CI, which will only fully clear on the weekend :/
The last commit seems unnecessary, if not more of them..
