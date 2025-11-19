Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CB31DDC28;
	Wed, 19 Nov 2025 14:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763563805; cv=none; b=cHnGDj7kR4BvxYkapNaK6NS6ISnO9kz/c1zj7GMAW/pd1KKP6pxaRGDtoxMCF93f5mg62QTqbBXtM5IQB78qNG1CefytNQrr/83gAmo0+cdIALfD2meSyK2xOo9TdO7zGfN/fVQtcBAhpuXsprysPKKbRfIfjcwhPB7i3zobdys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763563805; c=relaxed/simple;
	bh=nlGsuxDbBUvtko/C6ulfDV3R9btGGY1QhicP8kVQGxo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e7/Ei5dLSqSnZ+4LQWESo/8pf7U7grdewx+uvd/ec25isRft199XHG/EW93Z4lhOREaCQGrfPaj2iLhXx1tKrEHdRQnvH6sroF2qG8B8V1sfwacnwlVx18Glfk5neop1e+X166GSdcpyBlP59WMBKfR5Kykc1/4e59txj5F8/Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=WR0vdcVr; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="WR0vdcVr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nlGsuxDbBUvtko/C6ulfDV3R9btGGY1QhicP8kVQGxo=; b=WR0vdcVrYrWfM5M0KdsFKkPSow
	brvU4uzFheM6ABGTeHczHHGB9bLUtCnnqAVIRG0JcTq3yk2XBIRzs8idbiCds3HHwDVPBT7qJr9/C
	JY6JFaeQlejEw6DXqcq8AoiSG1Te+WPsgygmybxClENx3YdFMyC+eVCPtoCsnzigfRl9N+ZYo1GAf
	BSnhUG4mDTPPMJP8Ev9PdCnBf3A9bfq44QxHf/j7nXJtHiYBGEtVOTV2rU9CtxdVNqhOwkzFTyTZB
	P6BVtP7BAzt+wAudrpcEyEnO9mKLg7DSknAe8yPR7jvo6tISwn6cxYPbrEBD2Z12j3S9DQTa86ssu
	OD++FMvQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vLjVN-000000003pC-2ClU;
	Wed, 19 Nov 2025 15:49:57 +0100
Date: Wed, 19 Nov 2025 15:49:57 +0100
From: Phil Sutter <phil@nwl.cc>
To: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: Soft lock-ups caused by iptables
Message-ID: <aR3ZFSOawH-y_A3q@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org
References: <20251118221735.GA5477@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251118221735.GA5477@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>

Hi,

On Tue, Nov 18, 2025 at 02:17:35PM -0800, Hamza Mahfooz wrote:
> I am able to consistly repro several cpu soft lock-ups that seem to all
> end up in either in nft_chain_validate(), nft_match_validate(), or
> nft_match_validate(), see below for examples. Also, this doesn't seem
> to be a recent regression since I am able to repro it as far back as
> v5.15.184. The repro steps are rather convoluted (involving a config
> with a ~40k iptables rules and 2 vCPUs) so I am happy to test any
> patches. You can find the config I used to build the 6.18 kernel at [1].

Nftables ruleset validation code was refactored in v6.10 with commit
cff3bd012a95 ("netfilter: nf_tables: prefer nft_chain_validate"). This
is also present in v5.15.184, so in order to estimate whether a bug is
"new" or "old", better really use old kernels not recent minor releases
of old major ones. :)

Anyway, basically what happens is that nft_chain_validate() iterates
over each rule's expressions calling their 'validate' callback if
present. With nft_immediate, this leads to a recursive call to
nft_chain_validate() if the verdict is a jump/goto call. There is a
recursion limit involved, but chains are potentially revalidated
multiple times to cover all possible flow paths (e.g. with consecutive
rules jumping to the same chain).

So, how many --jump/--goto calls does your 40k iptables dump contain? Is
this a (penetration) test or an actual ruleset in use? While it might be
possible to reduce the overhead involved with this chain validation,
maybe you want to consider using ipset (or better, nftables and its
verdict maps) to improve the ruleset in general?

On nftables side, maybe we could annotate chains with a depth value once
validated to skip digging into them again when revisiting from another
jump?

Cheers, Phil
