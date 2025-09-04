Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6602367DC
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Sep 2025 15:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756998945; cv=none; b=KAVAo429I1Ap5BWg5dDOjmCkPWo9ghIE7xR2rP7Mc+GeKfN6xx38sCTwiPi/F65RvwIhEjacyuBd24xkKEIeiX9icsUtNqzn2bzjmeC+eREz4fwdOaH3ynkqRG+0Ok7NSAAYcBmEDVHZOClqkytq2CrFWycxptndVAT4anL2J6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756998945; c=relaxed/simple;
	bh=vvUQyotZBAxswRQEyf3tqzvhHzDXv/oVsvPOly4Fe9k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FUAmMTkhvw/Pe5B4OCANuJRC2r00wx6tD+sl+kXMDsnsM2BAR1HcuvlKgSAnF9lTI7gJeyG3cYbq704Ie+TVyu5qEvjQeMSd2xb4zAR6Y0CZCk0PfzTgOj6jMEsBpA0YwD3Pi6THV6khEtR7u8MPXfURFFiYWllRuKbwhcpNTu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=iRXf+JDS; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="iRXf+JDS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PBA02jHpKlHFeLMs76cg0ElnuYBRxjrOiyIITNKOPO8=; b=iRXf+JDS6uELRTr6N0DYU+5WQM
	HvhJjh5M8ZgkhE6C2JhFi94hWVHw3lqqmJ7tz65p3mJI/EvVayRlQfT661IMtb2G3gLqQr3v/VkHd
	LYEO15bjMTeL65r5m/PKlCrHGWn8XXVMst7wvSJig2XOvHqPfQFW7kPfk79pgGEHSPoCBs4vT2RYV
	xc+fJ0UL6zys4HaSaxUhzfawwzfFa4ExIFTjT7zwtIVT7FbZWJJqZuBU1JzaLi5LaXOus6mQba6g3
	TfduT2YCbJswnxoIPOjBGnXGlWbuK+QefvI1xGYB4sb/viltmoUi/bbDnj55ETbmpPbVpaISBo+Ts
	RkQWuing==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uuBgZ-000000001Mw-406u;
	Thu, 04 Sep 2025 17:15:40 +0200
Date: Thu, 4 Sep 2025 17:15:39 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v3 00/11] Run all test suites via 'make check'
Message-ID: <aLmtG3euLlPaGbZ6@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250903172259.26266-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903172259.26266-1-phil@nwl.cc>

On Wed, Sep 03, 2025 at 07:22:48PM +0200, Phil Sutter wrote:
> Help me (and maybe others) to not occasionally forget to run this or
> that test suite in this or that mode:
> 
> Have test suites execute all variants by default (patches 5 and 6),
> make sure their exit codes
> match Automake expectations (patch 7) and register them with Automake
> (patch 11). Also fix for running 'make check' as non-root (patches 8 and
> 9) and calling build test suite from outside its directory (patch 10).
> 
> The first four patches are fallout from enabling all variants by default
> in monitor test suite, which includes implementing previously missing
> JSON echo testing.
> 
> Changes since v2:
> - Drop the need for RUN_FULL_TESTSUITE env var by making the "all
>   variants" mode the default in all test suites
> - Implement JSON echo testing into monitor test suite, stored JSON
>   output matches echo output after minor adjustment
> 
> Changes since v1:
> - Also integrate build test suite
> - Populate TESTS variable only for non-distcheck builds, so 'make
>   distcheck' does not run any test suite
> 
> Phil Sutter (11):
>   tests: monitor: Label diffs to help users
>   tests: monitor: Fix regex collecting expected echo output
>   tests: monitor: Test JSON echo mode as well
>   tests: monitor: Extend debug output a bit

Applied these four patches as they are pretty harmless and not related
to the remaining series.

Cheers, Phil
