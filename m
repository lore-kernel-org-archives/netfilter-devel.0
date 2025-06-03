Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35EF1DDC1A
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Jun 2025 18:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748976169; cv=none; b=UAP2HLvZCZ7AJ5rGBOsjhACjOzx/o3hyFNSZkKAXfgamfFKu7moRDMvgFLRS8nfYwX+9IZ35gb4RtsJYQfXGwc6On6edk/CsLDdU6BKWew8C0E6wO6s16UZBrJPV+D4Lwr1tMH9p8N3/hyOWsyPi2lCYr9Pme3ecrZ/kT39Sg0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748976169; c=relaxed/simple;
	bh=eiFDmMd60KYvkOCJ68CYNGtCepbefxe/4aH9GuEoXq8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K8lVQIA6e4m5lnWHUW430inMkevlZXvMayFrRTwM3/QpRO4XB552bisdXP+oLxFb5EaG/jK7xEfUA1GviMaJLSuKzP0Zh1kMxOsJKjWRxtoGSwsIDhBkPTlh0VwOMW/q0vFmeisRcDvamSi1PZp6OZH7pgC1Lz6tIHc98b3y5Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=W0QdsK9r; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="W0QdsK9r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LrdwOk7Eq6taKTfH3ltvU72KatDLIIOO36CklgZMSPM=; b=W0QdsK9r45iFhTQdITrZfLQIRg
	KpsZ4SpqxMRD2XiNdGjLb2X0k2GULu4+mxsfBanoT6xPneHp9jGkIss7QS6hwgQshactrV1gITr4R
	EYi60sKCIi4enUNyCVn6oAskC4gHyPdVFXK82GJhMHvAXZW5sqZWJ5onQ+qMDzA8v+YKPIg+Qi+cE
	s5jc0BL1pwdYZMrDtUeIpzPD2sydBp8IWdzghVjrxUsxnrDiOQxggFpTXQ6rLbQLDUOI698jOHdk9
	+WcoqfYMvR0zWputdZY/xV4aURh0P0teI6XvHn2Z25Frmre6Q/do7SuNi4ISG6YGykQoUMej2g0c4
	kdeAUjdQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uMWb0-000000007kJ-1vCi;
	Tue, 03 Jun 2025 20:42:46 +0200
Date: Tue, 3 Jun 2025 20:42:46 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] json: prevent null deref if chain->policy is not set
Message-ID: <aD9CJl6mJ7iAHvwf@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20250602122235.10923-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250602122235.10923-1-fw@strlen.de>

On Mon, Jun 02, 2025 at 02:22:33PM +0200, Florian Westphal wrote:
> The two commits mentioned below resolved null dererence crashes when
> resolved a null dereference crash when the policy resp. priority keyword
> was missing in the chain / flowtable specification.
> 
> Same issue exists in the json output path, so apply similar fix
> there and extend the existing test cases.
> 
> Fixes: 5b37479b42b3 ("nftables: don't crash in 'list ruleset' if policy is not set")
> Fixes: b40bebbcee36 ("rule: do not crash if to-be-printed flowtable lacks priority")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Phil Sutter <phil@nwl.cc>

Thanks, Phil
