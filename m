Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C4914EC62
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Oct 2024 20:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729714396; cv=none; b=qTEf3o32q6AQ0t8qMBvOnS++so+GXy6vl1NPzMf40IBE4XuFNpYQKCMHMKFE3ECRK3VhWaGziZhQpj8DgqX3QpkpWAXZVEaWH5Edu6eZaeO5N4fTAkJHLGivXoJUQz/Lsgu8tEx3R82SItytogviRiJBwrB4HQZqPMxOLXXXhq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729714396; c=relaxed/simple;
	bh=PC15L+WqCofB2Mocmjv8fhgRO06xEaGkxJS8T1lBDb8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tGDLFEBfsgar/FWnVqhlzJw5aAxmD6SEnnHgxVMsCuWYD1kOHGs/kyIIpQYMepWUZ5ZyQmh0gmQocY2Xeh8gM1Z3SBo3b/eMdUFpubuk4xTL7SQlvCtjdTp3WFNY/JoXQBaTvmmNLqSGxKM8Cx8AEIJ4/xHPBIyiynVG7fPgE80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t3hj6-0007np-6T; Wed, 23 Oct 2024 22:13:04 +0200
Date: Wed, 23 Oct 2024 22:13:04 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH] Introduce struct nftnl_str_array
Message-ID: <20241023201304.GA29876@breakpoint.cc>
References: <20241023200049.22598-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023200049.22598-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> This data structure holds an array of allocated strings for use in
> nftnl_chain and nftnl_flowtable structs. For convenience, implement
> functions to clear, populate and iterate over contents.
> 
> While at it, extend chain and flowtable tests to cover these attributes,
> too.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  include/internal.h         |  1 +
>  src/Makefile.am            |  1 +
>  src/chain.c                | 90 ++++++------------------------------
>  src/flowtable.c            | 94 ++++++--------------------------------
>  src/utils.c                |  1 +
>  tests/nft-chain-test.c     | 37 ++++++++++++++-
>  tests/nft-flowtable-test.c | 21 +++++++++
>  7 files changed, 86 insertions(+), 159 deletions(-)

I don't see str_array.c here, missing 'git add'?
