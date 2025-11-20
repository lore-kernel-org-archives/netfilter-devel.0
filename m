Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34E22475D0;
	Thu, 20 Nov 2025 21:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763672858; cv=none; b=hYT0Rnpye9JlCQeG1CMFHH1jWtEuRL+ee+6ggvtWcduSG5mnnHMt4DosR1XMo+oVy3us3dflX1zqwmb4/JVK8efNzRGOT9AXG+WWMq2nE0Aj+nj9oc3CGQliPFV4rnEQsOvzOdphAPpytR+XPM5LRxyt75uqPg4A8P/yD60elc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763672858; c=relaxed/simple;
	bh=yGJcjq6BoC3jarzu2fgmWMTqIX5GqH+X7G8e59XBdq0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pwrSdGMczB6Eb0Le35alv4oM5l/Cvso0SLEZwLI1uGpNCc97fqlKGsAyxduoatH0PWZKdseiuA4Ts3+De7PeaSSOxYIEUVpKJqYbRMH0LLb19HkMfFT2D/9Sq3L0M1ozQecfSrsGD8L9v/vranO/u7muTWOkf7tKksMeSvyStzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=e/4wLg7C; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="e/4wLg7C"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 70AF66027B;
	Thu, 20 Nov 2025 22:07:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1763672853;
	bh=yGJcjq6BoC3jarzu2fgmWMTqIX5GqH+X7G8e59XBdq0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e/4wLg7Cw9z++/aewxTzJVf65fBkdx4NVJHI2a0LtVA9UOZ3MNJ9quujW6xprBpm5
	 Akgw3946OngeboOyD3BxYmmF0HNFmAvu79hZpc6bicofG8lSSq01a99Nj3XbRLKpV8
	 ds/qfbUCoA1DaiwRVH/l7oJaJ0yVEP7XwkCcxt6B34io3saJZexb15YGvj1eHi6jtu
	 11zmE9tqr7bDNWgoJ+0eagLGQnxtqsfPFg5gq0MP9vBnK2TZjENx0alJuPYr8PHPC1
	 Hz4+o1Cw+i5hrLOofgn1n9SjQfouI0StHufYGFCTEPjIONoT9TxHZL6VOTGr/VVvln
	 xAVPg9Kd3JzjA==
Date: Thu, 20 Nov 2025 22:07:30 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netdev@vger.kernel.org, Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: Soft lock-ups caused by iptables
Message-ID: <aR-DEpU5rSz_VWy5@calendula>
References: <20251118221735.GA5477@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <aR3ZFSOawH-y_A3q@orbyte.nwl.cc>
 <aR3pNvwbvqj_mDu4@strlen.de>
 <aR4Ildw_PYHPAkPo@orbyte.nwl.cc>
 <aR5ObjGO4SaD3GkX@calendula>
 <aR7grVC-kLg76kvE@strlen.de>
 <20251120203836.GA31922@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251120203836.GA31922@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>

Hi,

On Thu, Nov 20, 2025 at 12:38:36PM -0800, Hamza Mahfooz wrote:
[...]
> FWIW This patch seems to resolve the issue, assuming you intended to
> include the following:

Could you also give a try to this small patch:

https://lore.kernel.org/netfilter-devel/aR27zHy5Mp4x-rrL@strlen.de/T/#mc6b8e6b02a4a46a62f443912d8122c8529df0c88
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20251119124205.124376-1-pablo@netfilter.org/
(patchwork.ozlabs.org is a bit slow today)
