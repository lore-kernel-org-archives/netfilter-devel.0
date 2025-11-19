Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA79126B756;
	Wed, 19 Nov 2025 15:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763567931; cv=none; b=YSAwxZ72iEe0nCJowI2vu8YgSn//RWRZEu/x6wUk1jjpoO7Ka+gQlNcvGBpIbnBMQk+rlLoNcCQcA83+wIqGSN3/I2ieuqU6lLEv5pFLMaGrpTFS1uE1bKGl/cFcGghqToYphHTdkWMFQPbLCBg97aXNIjIx5a1s2e30Vg3G2uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763567931; c=relaxed/simple;
	bh=6vLC6YaxhbpO4KhU1y6WX8knA7FPQ/aQlIxjc9YztW0=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dyyfdhTg4ur1RdlZ5g+emPUhmguEeTHfKOjY1Uiwr4CDAkKmJ1tT8yjAel4M+d6jgW60jkTOSYXsBr3f+GYbP/LMOlkPs+ScwZHq4LG8W5lAo++0qS9F27PByxtJwL9sbbhwmrYhFMyIhP89eJ+Q83fevPufYlFw7Fz54oWrA88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 90C71601F1; Wed, 19 Nov 2025 16:58:44 +0100 (CET)
Date: Wed, 19 Nov 2025 16:58:46 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: Soft lock-ups caused by iptables
Message-ID: <aR3pNvwbvqj_mDu4@strlen.de>
References: <20251118221735.GA5477@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <aR3ZFSOawH-y_A3q@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aR3ZFSOawH-y_A3q@orbyte.nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> On nftables side, maybe we could annotate chains with a depth value once
> validated to skip digging into them again when revisiting from another
> jump?

Yes, but you also need to annotate the type of the last base chain origin,
else you might skip validation of 'chain foo' because its depth value says its
fine but new caller is coming from filter, not nat, and chain foo had
masquerade expression.
