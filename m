Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18756212548;
	Tue,  3 Feb 2026 13:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770126902; cv=none; b=VRxLzFdcoWNhA8RHmRlqBfog0/MOEsLVFTrr5Ygdg0Dj5EmMmIsP13jh88mWiIvSDK1v1uQpuwv1D2gRde2rQyodkr3ukolM1tIddJOwBVypYYErzf0mSVL2Lmg1f1n94yO3i7yMRMouMfAVq7sX7mU3kWnwoRHre89KfzQPAag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770126902; c=relaxed/simple;
	bh=IBIRN87f5gYXDRbNBgXqXufgoE2d6GCMY7PNczz36mI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i6zU3EMxMbxCT0S21Nq6EyryCIPKI4G1scqWsCaXUAiREk51Y8vsoFgf+CBeYP03H16iNS4hsxXtzRQLxnm7cUgyYVdlM+KsU2ZrFuyi1P9W+o0HKtRDq0K9U3ifg0KGgcvC9oL4Urv4W+hOVKxB+uvFeNhA7P+/pgL2FWJ5Tiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 572446033F; Tue, 03 Feb 2026 14:54:58 +0100 (CET)
Date: Tue, 3 Feb 2026 14:54:58 +0100
From: Florian Westphal <fw@strlen.de>
To: anders.grahn@gmail.com
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3] netfilter: nft_counter: Fix reset of counters on
 32bit archs
Message-ID: <aYH-Mr0Hy7EfivBt@strlen.de>
References: <20260203134831.1205444-1-anders.grahn@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260203134831.1205444-1-anders.grahn@gmail.com>

anders.grahn@gmail.com <anders.grahn@gmail.com> wrote:
> From: Anders Grahn <anders.grahn@gmail.com>
> 
> nft_counter_reset() calls u64_stats_add() with a negative value to reset
> the counter. This will work on 64bit archs, hence the negative value
> added will wrap as a 64bit value which then can wrap the stat counter as
> well.
> 
> On 32bit archs, the added negative value will wrap as a 32bit value and
> _not_ wrapping the stat counter properly. In most cases, this would just
> lead to a very large 32bit value being added to the stat counter.
> 
> Fix by introducing u64_stats_sub().

Thanks Anders.

I will apply this in the next days unless there is a NACK from
netdev maintainers.

