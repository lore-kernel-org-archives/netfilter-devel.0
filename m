Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CD74683;
	Mon, 14 Oct 2024 21:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728940182; cv=none; b=hsx+C06beMsCvhXkVXul6rq5RhbLXVcCSof+Sx6BFzbPJhcBuwFqOZ6KQVOxnZUmStlMBioP/Tym4URfHUgCYl3AXTKA6bQ1g3JGqiNHeKRaph//efPgJR4/2Yujio5y7cIZriaGjM1DB7zmweThAiuXNpJcpB2eZjB3ntR7foM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728940182; c=relaxed/simple;
	bh=J2kiYfTnDUzyhTQDWC3k2ekSCzLeZU1UIpZWgTm4AVQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uK7HeY9iZ+EVG1V5ZFePGtpVglMx8h0/AqL/88g0XsdPJXZ1Fe4+l3hvHuWtYGIfiHEO+jHeInBV3Tl4Gh+ehrboBdU+C44KlV8gz53LbAUHN4vFRh2Oi6nxddIt1//im9RKE1szmG3kwSzqzovxEehjhl0F1UFsi+AWwAT1vXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t0SJh-0002CH-2d; Mon, 14 Oct 2024 23:09:25 +0200
Date: Mon, 14 Oct 2024 23:09:25 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	fw@strlen.de
Subject: Re: [PATCH net-next 0/9] Netfilter updates for net-net
Message-ID: <20241014210925.GA7558@breakpoint.cc>
References: <20241014111420.29127-1-pablo@netfilter.org>
 <20241014131026.18abcc6b@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014131026.18abcc6b@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jakub Kicinski <kuba@kernel.org> wrote:
> > 5) Use kfree_rcu() instead of call_rcu() + kmem_cache_free(), from Julia Lawall.
> 
> Hi! Are you seeing any failures in nft_audit? I haven't looked closely
> but it seems that this PR causes: 
> 
> <snip>
> # testing for cmd: nft reset quotas t1 ... OK
> # testing for cmd: nft reset quotas t2 ... OK
> # testing for cmd: nft reset quotas ... OK
> # testing for cmd: nft delete rule t1 c1 handle 4 ... OK
> # testing for cmd: nft delete rule t1 c1 handle 5; delete rule t1 c1 handle 6 ... OK
> # testing for cmd: nft flush chain t1 c2 ... OK
> # testing for cmd: nft flush table t2 ... OK
> # testing for cmd: nft delete chain t2 c2 ... OK
> # testing for cmd: nft delete element t1 s { 22 } ... OK
> # testing for cmd: nft delete element t1 s { 80, 443 } ... FAIL
> # -table=t1 family=2 entries=2 op=nft_unregister_setelem
> # +table=t1 family=2 entries=1 op=nft_unregister_setelem
> # testing for cmd: nft flush set t1 s2 ... FAIL

My fault, Pablo, please toss all of my patches.

I do not know when I will resend, so do not wait.
