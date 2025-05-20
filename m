Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD71425E828
	for <netfilter-devel@vger.kernel.org>; Tue, 20 May 2025 15:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747754733; cv=none; b=i77CWjeDlOungZ9OlNUybyNBKgOSCndt2ZRxGJ2lGmnbGWb4rbUEGKOSBvqC1lcD/N/4lOXH06RWlRm6JBzJwH077vjlXc9XhkTI3cT+HBYE2gQtqYB0vQAXppVFU/sDTYrfH7AqJYcoQ7a8R+CcvwZo5XfCcu5bn/zF2ykoNQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747754733; c=relaxed/simple;
	bh=/Hn9jZPkBYNflu8lu900KS2n/duUa6O2kShkNEEWC/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oGdTFqEwXO7eCZzKPm5tbhDuO2/ckggNezscHCWu6glLmgv5bs7s5Lo2pCi1aIyTgI8WLZFHvgK8lcbozDFoZ9bB2mdAWJtaycY1xgLw44AOU/1YiLOqSB4agcujNJ23vWphi/pvHrZRbKgzolKezz4149OO1dDunpg15ywlrJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oUtvpwBg; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TgCfpK+8; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oUtvpwBg";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TgCfpK+8"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 0A95360708; Tue, 20 May 2025 17:25:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747754722;
	bh=DYJln7IFAY7pVIhdFbNPo0OI7OSzlZw6zgqHWdFL6r8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oUtvpwBgXq0wuYvB92o+aCgwTu5OMu+caIEnzYonPXgb3kkQXJERLB3Whs2Vp59Vj
	 m3I0x7MQpYeG4PtMpFPBRwCT5kH5FfrFTxQupPyQXhKYHUzjd5iihHklDOe99FDRZ3
	 Q3A7N5oXQpFL9n90ZxP3YPqyCcrcPbdi/rTrPgRx3cX43gHULx7a1eusREEKF/KwP1
	 I4yzj5abYGmMkRLWhhCcddrpDfOZDuAgOU7/p3Hs4O9Tcy5gs4sEpcprjcckazRSDN
	 9Q3+OsgHSa+3qH5UyCjJVGkPy5qFmgNuIPC2NyWUzWad9t08kffzuMV9weU8QO0X/t
	 nQKdkwBKR5tdA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 66EE260708;
	Tue, 20 May 2025 17:25:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747754721;
	bh=DYJln7IFAY7pVIhdFbNPo0OI7OSzlZw6zgqHWdFL6r8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TgCfpK+8gnXGZ1VLkRPvu6z2ZBJ8Wd2FEWlaQqyL/BnS01hTtkXQCsUK/f6K8+1wt
	 go9RaVSULyTcHqHujc5Hbg0ksjEj1cJeL0CZ7I+7+S4ExRvUTdRkUiNS6L1huWiEC9
	 02a9yRNQCW+NUILWGtdH6vUFxiBUqxFN+CoB4SqGq3k/KeuDy6JDDgFUYI/dYI2ka6
	 ft6Ghs3cVOScESbyDf9t/nECt1V7k8GZXmLVK6p+XJgkbiETluc3CIFQH6+JBtv5ff
	 dHVhDNDhIIxCosOSZJ0jN8Ct40MQX6ZuBxyMUWk376hpWdeCcXQvoi9edMtvFNXBg0
	 N1kCQ/LDWl6ig==
Date: Tue, 20 May 2025 17:25:19 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/5] netfilter: resolve fib+vrf issues
Message-ID: <aCye31skU39ExbuK@calendula>
References: <20250515180657.4037-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250515180657.4037-1-fw@strlen.de>

Hi Florian,

On Thu, May 15, 2025 at 08:06:47PM +0200, Florian Westphal wrote:
> This series resolves various issues with the FIB expression
> when used with VRFs.
> 
> First patch adds 'fib type' tests.
> Second patch moves a VRF+fib test to nft_fib.sh where it belongs.
> 
> The 3rd patch fixes an inconistency where, in a VRF setup,
> ipv4 and ipv6 fib provide different results for the same address
> type (locally configured); this changes nft_fib_ipv6 to behave like ipv4.
> 
> 4th patch fixes l3mdev handling in FIB, especially 'fib type' insist
> a locally configured addess in the VRF is not local (result is
> 'unicast') unless the 'iif' keyword is given because of conditional
> initialisation of the .l3mdev member.
> 
> Last patch adds more type and oif fib tests for VRFs, both when incoming
> interface is part of a VRF and when its not.
> 
> I'm targetting nf-next because we're too late in this cycle.

Could you rebase and resubmit? This is causing interference:

commit 7c8b89ec506e35aea3565461c12c57142a452d35
Author:     Hangbin Liu <liuhangbin@gmail.com>
AuthorDate: Thu May 8 08:19:09 2025 +0000

    selftests: netfilter: remove rp_filter configuration
    
    Remove the rp_filter configuration in netfilter lib, as setup_ns already
    sets it appropriately by default

Thanks.
