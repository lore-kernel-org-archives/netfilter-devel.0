Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A335A3F074C
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 15:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770304885; cv=none; b=szEX1XR0Z/JB8hqr0KxJaRxJgVv3x8cj7AKHrDwDylqg6GhDKHb7+CMHf8d5Z5JZ3lCuoqDGaTn5Ue/BMbpXv/TKS/83e77AcDqqrl2nT8zU67uFtD/j4GcTirX/jemsM2MGgQKTnvrRlmmLBQQoH3ghmDn11jxC1zDkO6PdT9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770304885; c=relaxed/simple;
	bh=kPqJmFfaMEIlHCHqcy+SY/6Ra519FKa760lRiFVx6ws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BuOXvkPmYrdcczPr7HrqDpyelg45UnUGaKl9Xv3qjfvvpTM4UVvBN8G6Q8PphZ8gpFmO2s/UDBYNY+B0Oa6YAvB7YyERNOuW9mw+0de43171PuGtDrlhJwgWoHTY6RevXqoxLIpG7aD15mW3zYSuYeTRxYkZMJ6BuCMEhmCDjSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=h6ZsCd4m; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="h6ZsCd4m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=eEp2T4ggvebisSyHSs7kQwk8dSKTCvKGHfEMRpu0m7g=; b=h6ZsCd4mkK5is5Nny9pe8J+QZ1
	bb6ZzazUELju5KI7VzxlTGFvikqUiMQIbUtN1m/E3c+LuNgLRaY0Utw6KWPIvy5P7LJjzP2atQUHs
	KKChgjcfuu0NExQLWwI3P1l/QiayU8l8R6d2jEnAGrkXNf4EXKKVdQZe76BHdrg+++ciycS9ghpPt
	PDbB4y46sNlOmWUWO9Jer8TbActcd/ED9CvEjXZIkD9BJBI/r1zehH85JIMR0z2jAbNZc6whJAaYj
	DREImSaRaOh4dPUEe3KmnR3EceaG6cfhkm4x4b2WGw3LhDCZliaLAdp5aHboeix50cy0oxxY4ftZG
	b8MVx3JA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vo1Aa-000000003JY-0yqG;
	Thu, 05 Feb 2026 16:21:24 +0100
Date: Thu, 5 Feb 2026 16:21:24 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 0/4] Inspect and improve test suite code coverage
Message-ID: <aYS1dK59EWOxXBW_@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20260127222916.31806-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127222916.31806-1-phil@nwl.cc>

On Tue, Jan 27, 2026 at 11:29:12PM +0100, Phil Sutter wrote:
> While inspecting the test suites' code coverage using --coverage gcc
> option and gcov(r) for analysis, I noticed that 'nft monitor' processes
> did not influence the stats at all. It appears that a process receiving
> SIGTERM or SIGINT (via kill or ctrl-c) does not dump profiling data at
> exit. Installing a signal handler for those signals which calls exit()
> resolves this, so patch 1 of this series implements --enable-profiling
> into configure which also conditionally enables said signal handler.
> 
> Patches 2 and 4 fix for zero test coverage of src/nftrace.c and
> src/xt.c, bumping stats to ~90% for both.
> 
> Patch 3 fixes for ignored comment matches in translated iptables-nft
> rules. This is required for patch 4 which uses a comment match to check
> whether nft is built with translation support.
> 
> Phil Sutter (4):
>   configure: Implement --enable-profiling option
>   tests: shell: Add a simple test for nftrace
>   xt: Print comment match data as well
>   tests: shell: Add a basic test for src/xt.c

Applied patches 2-4.
