Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291111BC35
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Apr 2024 12:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712925321; cv=none; b=Q32q2DnBSbAGYhAX/OBI05gF7IZRpUSKOQiO66xU/Sz9PaMSW2IM+6/CLdnCuz1f+ELxKoOWigpcp2eZM0jbtTl61rKwdYMLoVJ4QSGKEyev4MVk+msjdE9kISUfLUplJuIoog/vZ+4bpZq+bLiiQy6YzyD88047QxP9CkGtjMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712925321; c=relaxed/simple;
	bh=n1Zl8ngw3hXRSDaBar60E9cUhY1GG9Ywz04n+K15cwU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mgi6c4DSyn6PAumSOW7l9B6jGZRA4iDiTNUIDmppmAC5BCaTCGoOOxFsGFL13zpUP5YEN7txpFOuelIvmibiEV+XpWS6iXqY+DQD54OUnyUjbVRO9QuCIURmJWsvBdF6p8k/JNkRQOox1kSiiByKW8Hrn6W/00fEuE/Z7hD1p2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=d+F2tyr6; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="d+F2tyr6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kreKK5XrbqpV6k5fFR6SiMjJF+8MnOIc5iBrM8/OWI4=; b=d+F2tyr6w9nNAgDr7gdKQwIYZW
	lsMdjiVoCkrJPTSNAw4LJcBTHYE5bV+wS8fHC3LPLxXiF2IzTASPiB40aQlTnWAOzmlpa3Hogp8uk
	nBd8b0wcSh7N2gJpNgaot1pwMqGtWP0sqXcFGmXoe7OtsZwinG+x0kkx2t/Ps1sOd7wICGzrQRcO1
	GU36qX5WH2aUpBbFp51dmw+c2agbt5nRrBQj1YIuNcOjD8aI8JGikX5ZKFHQIXq+Y8ez40iMDQ+LW
	H/PCExj0nQ85VIE4U2IstTshQPGG0/zVYQX3eQ74eW73MeFa9QAPPphRUaTus+iWPO0lzpDEFQO5a
	IExjroDA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rvG7g-000000003wB-3L5P;
	Fri, 12 Apr 2024 14:35:16 +0200
Date: Fri, 12 Apr 2024 14:35:16 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2 0/5] json: Accept more than two operands in binary
 expressions
Message-ID: <ZhkqhMKoaPq_rCOI@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20240322160645.18331-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240322160645.18331-1-phil@nwl.cc>

On Fri, Mar 22, 2024 at 05:06:40PM +0100, Phil Sutter wrote:
> This needed rebase of patch 1 to cover for intermediate changes got a
> bit out of hand and resulted in this series:
> 
> Patch 2 fixes a bug in set element sorting triggered by binop expression
> elements being treated equal in value if the LHS parts match.
> 
> Patch 3 collates general bugs in recorded JSON equivalents for py
> testsuite.
> 
> Patch 4 adds detection of needless recorded JSON outputs to
> nft-tests.py, patch 5 then performs the cleanup to eliminate the
> warnings it generates.
> 
> Phil Sutter (5):
>   json: Accept more than two operands in binary expressions
>   mergesort: Avoid accidental set element reordering
>   tests: py: Fix some JSON equivalents
>   tests: py: Warn if recorded JSON output matches the input
>   tests: py: Drop needless recorded JSON outputs

Series applied.
