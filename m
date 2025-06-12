Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112622063D2
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2025 20:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749759411; cv=none; b=qsI8XdQOjAwAuTSTkRzp1cQC880rdxf+7zZt9ffyWRs5ARs6QJC5KK5HayQ/+5F/RwWMyBWfZX/Khp6g4dJ9xZodeGwzH7mUSmpDCGAiCYNKL3V63LECHRZw2SaFg/Hko2hO68TWJI7tULqBeu8qFLgxrU8QZiNB7aIp3KISKyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749759411; c=relaxed/simple;
	bh=p+/xibTHboauTZSjc7baJeZmJTe7HVLfXeMKSEvIetg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z23rkQtLTp3AuFbaHR/QFwvdKGTgxcP/Xrowyk0iTXFT5rahK+m2H6FEqpopR0hfAViVbbWo5N0lV4JtJVrHfP6kVEFCQfq1BNfauvImiLK+aoXP2Ax4oCuqB1qapgjNX+Ez1eEydSoJ/sIlWNpoL61ns6sAUKI3J6eIj6yiL0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Up/Ip0LV; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Up/Ip0LV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WECv705qXh65ug31v9vz+HDs+6Qr6+TnV5ySFFhNzRg=; b=Up/Ip0LV28VjSCY0B4kQ0Xfk/b
	/5MOVFcn+1JLFF2rbK93IZoD2XprXtQCxbGVbcbHsab3uif7g6Eq5Ehz1k/jivarzXHAVTa4vUbAA
	mhasX7/iomLRfkJ0EldBHTR5YSR2qLum87z7Amb0UizMZ/jjkhAzDAMxAGmne+fYQNS95XU3hjMnu
	S1VM/U2P3szSWgxat7V14XuD5qgrsO9wipuhhdoCLVutN/xpzofufK0KoBgwiBcY1f5sHKqFrMqeW
	aomq/nUZbyxufgJ9clbCkJchXoXPTFPi2c+c9k7FLJLcUfP0+6ATeQEFU5VYaPqgq5TJT/GA/31fE
	Wb3Ndrsg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uPoLv-0000000009w-1uU9;
	Thu, 12 Jun 2025 22:16:47 +0200
Date: Thu, 12 Jun 2025 22:16:47 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 0/7] Misc fixes
Message-ID: <aEs1r3c_3KIEwVpk@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250612115218.4066-1-phil@nwl.cc>
 <aEsshy3Re3E6j0XE@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aEsshy3Re3E6j0XE@calendula>

On Thu, Jun 12, 2025 at 09:37:43PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jun 12, 2025 at 01:52:11PM +0200, Phil Sutter wrote:
> > Patch 1 is the most relevant one as an upcoming kernel fix will trigger
> > the bug being fixed by it.
> > 
> > Patches 2-5 are related to monitor testsuite, either fixing monitor
> > output or adjusting the test cases.
> > 
> > Patch 6 adjusts the shell testsuite for use with recent kernels (having
> > name-based interface hooks).
> > 
> > Patch 7 is an accidental discovery, probably I missed to add a needed
> > .json.output file when implementing new tests.
> 
> Series LGTM: Please keep test 0050_rule1 in place, I would prefer not
> to lose coverage for very old bugs. Please double-check other test
> updates in 6/7.

ACK, will do.

> Aside from that silly nitpick of mine:
> 
> Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks for your review! I'll push the series along with the other crash
fix once done with the above.

Thanks, Phil
