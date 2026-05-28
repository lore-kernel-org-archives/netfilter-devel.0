Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7880E31195C
	for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 07:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779954413; cv=none; b=gLBzd8E+HlelJuGSdRdU9tWCz5pKriv0EjCGQhEmXtXuq1be2P+0sFzXtcGmp6P4WDeFVgtMcphN2GhZZMXL4oLHgYYKZcA5Cc2dr7qsbdA3UE283K4V+kuAZvir63hgcUQ1DAs+mNWYYo5pWQBJC1pVNMOBY/aBiS7BcCbAiB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779954413; c=relaxed/simple;
	bh=kqd0XNH3/BUvHkv0YeyaJRpUAmjkcpR6sTZpn10OkdE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dkd9P4Nnb/UyqLsNFmo69OITVo+3x8ggeMoaqcQ0fMLFhv9KADCs4lSe7S5m1vjf1jgo2C+7K6LBnfEM1mZ0U1Nio5yph/hGjcCMA1f173UNkLygoXiN+GBVD/b6Lcxrb/uWbPZ4n7x/fCeo5CPeuJ92bjbpEX1X14LXcgat9A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A5659604A0; Thu, 28 May 2026 09:46:50 +0200 (CEST)
Date: Thu, 28 May 2026 09:46:50 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2] scanner: Accept all statements' first words in
 all scopes
Message-ID: <ahfy6vvK8dhvBig-@strlen.de>
References: <20260508111538.3783172-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508111538.3783172-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> To fix for token lookahead with exclusive start conditions, we must
> accept all keywords which may immediately follow the exclusive scope in
> that scope as well. This affects basically the first word of every
> statement which may follow a limit statement.
> 
> Add a test case to make sure things stay that way. A few quirks exist
> though:
> - xt statement would need special testing since having it in a rule is
>   supposed to fail the command
> - The parser formally accepts nonsensical things like strings, numbers
>   and variable references on LHS, but these seem to be needed for the
>   data part in map elements only
> 
> Suggested-by: Florian Westphal <fw@strlen.de>
> Fixes: 9d105581b5f1b ("scanner: Introduce SCANSTATE_RATE")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Is there anything missing here or were you waiting for a formal ack?

Acked-by: Florian Westphal <fw@strlen.de>
