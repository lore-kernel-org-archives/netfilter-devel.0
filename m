Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518171F03F3
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Sep 2025 21:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759266383; cv=none; b=ENOtK7uMOaqUX5pWP3hFj2gm8ngfqCULiLBGXHeDqQ2zF5wy684gNUIR2clq4Pw1QI3l1nlQN9DAupLoUpTxGkiy1cFyGzvOzlMgzMt6IxZegCg6aCquyLmMGPrprIqMrBgXVdAhs3oMpIZF3z694a+Gzq+ZkQKhhh3uGGD9dYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759266383; c=relaxed/simple;
	bh=TOs+fzqwbq1f6u6SdTUVdvzuVwq+r0vrUbwu6hyvWM8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QSE1N7lJ0MwosGa9lZ8l2OLgI6Q/RpQNiOX5FFCmoIuDkGYWG3a3f6HXadKGNUz1PiuXoQmt/GqwHaqh5X10wfR+ztcsn6NPG3nspoNb09ABG2n7RN5MOkS/sgPj172jLUN3aygpvO4noWNx372A+QI/kZ+jJjCvqjOdKVRlr8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=MYzBAyeF; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="MYzBAyeF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Zto61LRpiCQeHDD4MbytBLgPJKHBb1Vw5xu9lpWE1aQ=; b=MYzBAyeFnvDIDAd71a4Cubsm2m
	rc0Blvaybe2yW9XSwEVNURBR/mxVlsmqFT0S9Hc9rjv4+lGDHm5wdBnRv+zm3Dksw4iR9G5nEgXaL
	gPLsWVsbGvurVJlJYwlBqJ4+zYsQCmabUnFi4DKI7gHM8BMxltcq3eDhdoIjgFiyakhaelnnDTtgO
	7aTNQAkxE6ysICta4AbjyjmJlxFP0LrtXgMcVhttowW/B+AaaSAzovm2zts4XFMftvamjj9pjREuK
	S+m6kQjDM2qZGC4no6yAvVgWP3Pai22g2zK8Wpv1Zx1Ys/wk74XO47h0qPnpA8+xbu4YAJSXLblQS
	EFP/AdLw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1v3hY9-000000000UQ-3Aq0;
	Tue, 30 Sep 2025 23:06:17 +0200
Date: Tue, 30 Sep 2025 23:06:17 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH v4] utils: Add helpers for interface name
 wildcards
Message-ID: <aNxGSUjprdnHadCD@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250731221756.24340-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250731221756.24340-1-phil@nwl.cc>

On Fri, Aug 01, 2025 at 12:17:48AM +0200, Phil Sutter wrote:
> Support simple (suffix) wildcards in NFTNL_{CHAIN,FLOWTABLE}_DEVICES
> identified by NFTA_DEVICE_PREFIX attribute. Add helpers converting to
> and from the human-readable asterisk-suffix notation.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
