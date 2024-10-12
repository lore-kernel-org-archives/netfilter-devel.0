Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A851482F5
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 10:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728729095; cv=none; b=UwcToU/rnAcZN9oUE29O01AX/+0CQGgYshtd+gTvDgq1rfYqDT4PCLOEfLnT2nWnTQ1+KELY/i99Q52lbRm7sTio74fRanuC2yoL3ufJw7mYa9XkssNrmo79BM+CTVfdkuKVZ4nxGytPgRaWj8XRxrs+GtdeVaaEotZLn2Xir2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728729095; c=relaxed/simple;
	bh=1/JGmkwFzSw2vSbW1AGZmVApuV+dtWqA39Uh+kn7m5I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N+cWClQjETm7BwmbJXnyK1g+QczCGzjazwv22KDOUEx9mfK3ezn27WMnxTnw8fDr4k+FX2nGY8XVluWEs23fGsTKk4a5QIHNooIFUYMomleDFgkEJZig38GLHCZbd/HgXGMr2O4qZonEECkgtk1g+1ixjZSAYZIuJZQh7u+yiYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=RNYQ5qr7; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="RNYQ5qr7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZZeNqGaUbBxh871fMgj1VkxnhK+5IuS0yVc5CT8KtaA=; b=RNYQ5qr7GLxrh6OZBot5ImPPjM
	KMtvIRut5KL1nvhU9M7+uXRpm4XnBI06HG/g+w7LNiSZsAiw/RW6dPjs9UFKO8kIMD0La9igJ00eU
	6uEBvrKBzmwyb6mgxbeUygeZPsodqTPPCtSYQ2O0zeGRp8NDPTxPOAr5DxxhdHFDr6Z1nKmYPr1rW
	Uc7stlnrUEFBSN9r4/Nxcg2Tb2YRI/wKnadQ1jLf4/bPdrDZP0oCktDhQFJGZ6/PTQG1qafZifS4y
	6UnIHZq0jgDUYwlCkH19CwswgoFO+jOcpEscF6LMw6Bm3oRFgsoir8EYHi1pqh7LBOnfU2GznEOw0
	FkM9iWOQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1szZPA-000000003zB-2zjO;
	Sat, 12 Oct 2024 12:31:24 +0200
Date: Sat, 12 Oct 2024 12:31:24 +0200
From: Phil Sutter <phil@nwl.cc>
To: Duncan Roe <duncan_roe@optusnet.com.au>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue] build: add missing backslash to
 build_man.sh
Message-ID: <ZwpP_HuPrGSSOidp@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Duncan Roe <duncan_roe@optusnet.com.au>, pablo@netfilter.org,
	netfilter-devel@vger.kernel.org
References: <20241004040639.14989-1-duncan_roe@optusnet.com.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241004040639.14989-1-duncan_roe@optusnet.com.au>

On Fri, Oct 04, 2024 at 02:06:39PM +1000, Duncan Roe wrote:
> Search for exact match of ".RI" had a '\' to escape '.' from the regexp
> parser but was missing another '\' to escape the 1st '\' from shell.
> Had not yet caused a problem but might as well do things correctly.
> 
> Fixes: 6d17e6daa175
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>

Patch applied, thanks!
