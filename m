Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D0273522
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Feb 2024 12:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709122894; cv=none; b=nvD/1JbIAncmD3XLrcZooqOI4hDnVSPFkHEaTxQd3Zb2LBO3q5aRaqLOt4Ta4Erss2Kvcm/wzV0xSC1v5+BVy/qNo6AlWcsVlkO97FP6HBMJRvm18iY7/RF+pOA82/YXPDEiGZNdSrh0c5TweF70jS/TN/u9bLDsFTrnep+lJUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709122894; c=relaxed/simple;
	bh=2CxAmbr3cGlbEhn1tZbAqSP/gS9A4m3a5/CCUjLigKY=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s5Lg8EDNpfEtjJ8mKp+iLLXiBN04hg5RHhkgYMXUaiwTIEo94MbZoMe+h40dQO7v/kGxRycmRCf4d4po85m88qsIQ0R6Baru5Tqg87dSkSuH2OMxUK2uKRdQWRq0KW21IcGZfnn31cdAMXJg0o9JA5aGn1zgcPhEfGyRjtcU9J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=KRlTrwfG; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="KRlTrwfG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=34SXBjZ2+V1vTffmQkiJxq58ojDr8P1EqNjGZtg/ueU=; b=KRlTrwfGWOc2tdoTVBpswfEPqz
	Z/0zBG4xvvAnDxQ3hLXIMCgp8eY3Q/lelHCufDQnLsCVCWodKBnn6j6jYjZC3qqh/5QnUwS2xj7U7
	A7KNIRh0EaClxV7sqgOOwNshwgIsdAd9Iq8ADwlg4qFzQkSV999jX4zRuFNUyQpFwOuJCCdx6upA/
	+Ef/UsMX/uBWPZSLQPtnNUyr0HMlX8QMcaF0Zbkl1ee+HIaWkJU6YVcpApR2ad36syewQnO9mI8Qe
	nJ3yvzcftoBwdCDgsOB5JxFKfHmdvEDqgdb6ivf1AnUPkA9zhAIX9qxXRnHz4RT1LWexfeVbLWFgr
	o5edV8qA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rfIwD-000000003LL-1v1W
	for netfilter-devel@vger.kernel.org;
	Wed, 28 Feb 2024 13:21:29 +0100
Date: Wed, 28 Feb 2024 13:21:29 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] nft: Fix for broken recover_rule_compat()
Message-ID: <Zd8lSShzA4NJrp-C@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
References: <20240227184057.6017-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227184057.6017-1-phil@nwl.cc>

On Tue, Feb 27, 2024 at 07:40:57PM +0100, Phil Sutter wrote:
> When IPv4 rule generator was changed to emit payload instead of
> meta expressions for l4proto matches, the code reinserting
> NFTNL_RULE_COMPAT_* attributes into rules being reused for counter
> zeroing was broken by accident.
> 
> Make rule compat recovery aware of the alternative match, basically
> reinstating the effect of commit 7a373f6683afb ("nft: Fix -Z for rules
> with NFTA_RULE_COMPAT") but add a test case this time to make sure
> things stay intact.
> 
> Fixes: 69278f9602b43 ("nft: use payload matching for layer 4 protocol")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
