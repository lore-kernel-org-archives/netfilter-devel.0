Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA8D1E3DCD
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Oct 2025 21:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759873332; cv=none; b=DAs7SuB173wUVZUk6KFVkNW6dL+xq9ZDPQovQxoSdZ42Xd3bbX5ghS3sfFUUnHSwaE91fpj9gFNsWuIX/nsaqKBE9qhWlsoit0cVq6fRocwTqOLkWfM9c2ES5N6NCYs3HLPbzI9e67aD3Y3GhrD9tx0fo7iYBDorFOPeD6ylcMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759873332; c=relaxed/simple;
	bh=dl7eZAuzSVOB6EAdKEjpoT9nx5chVdEW0TcofLp+KWI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n4LVSJf9GzM4oEZlgvIzqrSeXMo/uAyMK06yu/7KI09xnnJl+7CG/ZVHRXRq+vRuKJ1z+D/hcQzGG/5OPiJQjpxpSDDMY3aOqYtSYB1wvSYGuKZdLLNguOervVJjnU2yhmn7fAumviJ7S/FVc82TfNKvztJgWb9gO9VcQu7jmTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Mvirqsew; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Mvirqsew; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Mvirqsew";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Mvirqsew"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id A8B8560269; Tue,  7 Oct 2025 23:42:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1759873327;
	bh=sF1G4hiLHV9NzSWdnSrHm6RMAPEHT0vSbnKjU92fICU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Mvirqsew8jPAcJtgwKPMHZNU8o205PTcP/1SupaTskL8cDONnslXjFHftxFzNOfCS
	 kvc5Bg3uvWD1rQGkLkalESKNwjMVdtguAbaNWOThY9dOgn6ZBBplsE4M6HUDHaG9+P
	 EAtdlzWs7nxFWr978OxHxX4L9fjj5i8GyBx1uLadxej/DNNDPHz2IEIxCf97YbA6P5
	 sVWeOrVc1Y2CKqPTz797r3YBHFxcqjfmH/9ip2qIyKY8M4dKGytD2rhYJ8V+meKTdC
	 j3D+h5ff5GdICkTihObVxUWWFbip6+hUdcuE6mtEDl4rQbhxLbTjqY3sdkAz12ae9z
	 cqkgHr9FwuveA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1FB7D60264;
	Tue,  7 Oct 2025 23:42:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1759873327;
	bh=sF1G4hiLHV9NzSWdnSrHm6RMAPEHT0vSbnKjU92fICU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Mvirqsew8jPAcJtgwKPMHZNU8o205PTcP/1SupaTskL8cDONnslXjFHftxFzNOfCS
	 kvc5Bg3uvWD1rQGkLkalESKNwjMVdtguAbaNWOThY9dOgn6ZBBplsE4M6HUDHaG9+P
	 EAtdlzWs7nxFWr978OxHxX4L9fjj5i8GyBx1uLadxej/DNNDPHz2IEIxCf97YbA6P5
	 sVWeOrVc1Y2CKqPTz797r3YBHFxcqjfmH/9ip2qIyKY8M4dKGytD2rhYJ8V+meKTdC
	 j3D+h5ff5GdICkTihObVxUWWFbip6+hUdcuE6mtEDl4rQbhxLbTjqY3sdkAz12ae9z
	 cqkgHr9FwuveA==
Date: Tue, 7 Oct 2025 23:42:05 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH] utils: Drop asterisk from end of
 NFTA_DEVICE_PREFIX strings
Message-ID: <aOWJLfLGdbT5eDST@calendula>
References: <20251007155935.1324-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251007155935.1324-1-phil@nwl.cc>

On Tue, Oct 07, 2025 at 05:58:26PM +0200, Phil Sutter wrote:
> The asterisk left in place becomes part of the prefix by accident and is thus
> both included when matching interface names as well as dumped back to user
> space.
> 
> Fixes: f30eae26d813e ("utils: Add helpers for interface name wildcards")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> This code is currently unused by nftables at least since it builds the
> netlink message itself.

This was moved to nftables, and no release was made to include it?
Would it possible to remove it from libnftnl?

Thanks.
