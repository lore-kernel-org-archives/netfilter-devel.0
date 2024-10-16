Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98721D8E1D
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2024 13:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729085738; cv=none; b=FigbMnGgax1RoALdK+4gCg1D6OHHM8copbT0DwHG09dnKekZvmBUbqY9pxA6UF96Qg4RDS6Ic4cINQkQgZpYltg0RZvsIwRIk2J22euOH5n+OUzztAyOSFC049wZyF3IHvseEC7OZUP3cCojHaduA8ASSufPgPstVWi7U5cXSQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729085738; c=relaxed/simple;
	bh=S64sdFr7KzO8IxibfW5iV3kV6EAbwlkjpPOJXF84nTI=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sG1w1rGhb7H4njnWiXzvRbTYrs6QKUFyYTDWgFGeuaqz8xWuA6SHkHHzRwOMXeTsLIAPticNKDv3kWvikXbAxafl30soXbSWIg6+gb5Ji8lnE3ze6NoJfdwUs5CIqIQISss6esXYKx07Is7TkAAVQkD9S6hmS+B6nZSI5FpyVnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=GMBDNX98; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="GMBDNX98"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ssLHRb7jgCHBaW26oB959By3PO99h0x15xTDs9OseEs=; b=GMBDNX98faAdDaAq9AzBMtKnos
	egwXsfe9XC53EJ2K2iG1TsqAVpPugXVtV/5io7ZNz6WIZ0Vp2C+GQtgxN4lR0SamapJM4ppcTg2db
	iCxyWegi2Ce1urRg+afBHfzIXf2n76RNZFGuxkzFNMvt6x8be2q+sNkJIlmN80YLKZfaJFMUeouEZ
	zJMUcxb+ZMTypRVyfaX7pl5ULQaSg2setvXXlMC9vsZAwgY2ZZQMpJRPgOeyn5sWma4oe5dFLmTXA
	AsLr1Ox1e0zr/2+MOKio47QfdFBEANuGi1eQ4kX4RS/DJnh6aGGcadQ4Fub5+e2h8vtUQPMUUzppb
	NK9FY3tA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t14Bb-000000000y7-0FH4
	for netfilter-devel@vger.kernel.org;
	Wed, 16 Oct 2024 15:35:35 +0200
Date: Wed, 16 Oct 2024 15:35:35 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 1/3] ebtables: Fix for -S with rule number
Message-ID: <Zw_BJ6wD-91J_2zl@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
References: <20241009172740.2369-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009172740.2369-1-phil@nwl.cc>

On Wed, Oct 09, 2024 at 07:27:38PM +0200, Phil Sutter wrote:
> For NFT_COMPAT_RULE_SAVE, one has to store the rule number, not its
> index in nft_cmd object.
> 
> Fixes: 58d364c7120b5 ("ebtables: Use do_parse() from xshared")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Series applied.
