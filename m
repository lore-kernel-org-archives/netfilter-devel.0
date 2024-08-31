Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CA219BB7
	for <netfilter-devel@vger.kernel.org>; Sat, 31 Aug 2024 09:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725095993; cv=none; b=mv6iANBDZfzuJRD4bBbSPxcixZYocIpHV8VLfx3ltrBShx6Nud1EAo3djOw19fxa0MAT7CYtkEkOI9nEjayFQEGFQE9cPdphq0A2qVk7SxqyKvOLp6TCCtXhrBZPOOz/P8/vDPwfxv47t5xsxpeGKlWSTzorvp9cOxBwW/NakKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725095993; c=relaxed/simple;
	bh=miDHNGKrNDoVd32LuD28cQvB1pRz8n5Lg5lNUcxDb84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lf/n8clXmB87rQQEQK/GAwqCUjmoP4MsMDVgSBPlNVac6ImgbEWT9Zxnzbe60XZODWd3Wu8j/Psn/Ce5YJsa7acfDL+Q4V4bFNHH6hRjEQ+OPSqyDSpgB0eAWoJM7glzGRABXggwtQ18wVl7ahhZ7kfmMnjKfWsnRs5pbbeUs1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ls8Mlvdv; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ls8Mlvdv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rUafOJIHWyfc2fPdyTwOCLS1q/ao6g95+4fp/yRr4rg=; b=ls8MlvdvrNX+iTurOKdbV+nZuE
	XrjZizML8WN25nsS8Q4vDEMUSPBlR96gDDNMB3DIsoIHODGHwSKVmj0Psrg5rwJDg3/VVDoj+JUq2
	R/QBbzjzplDNtvfLlgrs+OUmoDANJMU9wfCiDvkUoRKRbtPsxIXpudSFdy+yWZfZlRNT93wh1SLtd
	kcFAYwHpLvOkqXHWCr77lhgeZOkr9n5nLG7rFwgAYPMyq2Fq0gqg5QS8BKrjnbq7cOzZ4IVY6g3BQ
	2lbi6wRGMJdClZE/7V9A7/P2kVnVSbdAB2s2bFk4w+3kU8lO00ngH35LEAwlBgxjOfI74YowStJEs
	a6E5CaCg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1skKGk-000000001sb-0vtD;
	Sat, 31 Aug 2024 11:19:42 +0200
Date: Sat, 31 Aug 2024 11:19:42 +0200
From: Phil Sutter <phil@nwl.cc>
To: mpagano@gentoo.org
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] ipset: Fix implicit declaration of function basename
Message-ID: <ZtLgLiB8B0LpzWmw@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, mpagano@gentoo.org,
	netfilter-devel@vger.kernel.org
References: <20240830153119.1136721-1-mpagano@gentoo.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240830153119.1136721-1-mpagano@gentoo.org>

On Fri, Aug 30, 2024 at 11:31:19AM -0400, mpagano@gentoo.org wrote:
> From: Mike Pagano <mpagano@gentoo.org>
> 
> basename(3) is defined in libgen.h in MUSL. 
> Include libgen.h where basename(3) is used.

On my glibc-based system, basename(3) suggests to include libgen.h, too.

> Signed-off-by: Mike Pagano <mpagano@gentoo.org>

Acked-by: Phil Sutter <phil@nwl.cc>
