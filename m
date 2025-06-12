Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC6318CC1D
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2025 19:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749757070; cv=none; b=PWycpQkhHR/hOJc/INL/ymehDakRrtqIobi1xw5qmBGANCtoZvqUr6AAP92z02/7RLAkauMP/2FJ2zG/4S0oOkGkT/Bg05gC+ScXVUSpFyrSOh7kvB4qsmjP4HuDRvWyoLG211ZH8YVura158hJ7xRXqogd81GpZVsU2boDAMbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749757070; c=relaxed/simple;
	bh=6YpfugL/An2lVwi8m0tG0FNfE86jPkiKlY3Bvy19lZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O2bEcBcgP4NFs6Q695NdiPdFCqNYT3cXKbtH8N8KIxULMCU7ieRONXjbZVHtJowx01T2jUpxvHYYrgIqrd38DLupsISBJeMppPFzbn0VDZ3SHWtQlOF/bmU6mGJd0ujoxSDrs2Nv/E8QfW0xPYfPg9otVvQR7rRMyOw1X7EFXus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=eIIW+cBi; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rYf+wFCm; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="eIIW+cBi";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rYf+wFCm"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 55C9A60564; Thu, 12 Jun 2025 21:37:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749757067;
	bh=ABLmCioMSi+IXhMgUPTeV2W0IZFufmoYrtVtqDCmtak=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eIIW+cBiWxpm4MNP29XFvWJKh9fGWjFF+yXVhIb+w9zNA0+EBjzgGv4C/eaPzCSir
	 lcnoRCVpzfjkHSixvsxMiZfgP3F5HsmquTnF8KvogR53HFFDUcT0IyJLKDkt9OTDs+
	 uwzlTRDIbNum67L5ihrzYWSRvTKfEID3mZ1ijnA9wRkdbr82gQd8dQK/O6ugsA/8la
	 HLPMYCW0JF7VNQgB0pje/2FUPQwpuWuE1vQ7neyjYBrgto2+h1dQbKI/41ugq2bwDc
	 +vR/03y912bBLTev9/FmSPw+B2CQuh24SxQAHB9ze5sHb7yHA2DDnYrgbGoMAz8zb+
	 XGhuJZwD0UG/g==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BACC760327;
	Thu, 12 Jun 2025 21:37:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749757066;
	bh=ABLmCioMSi+IXhMgUPTeV2W0IZFufmoYrtVtqDCmtak=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rYf+wFCmrRPBeopWiFOvZmktCBKbeVe+lrjE4+Zw5OtiyaCe/ATdYjQxV8U8Qb/AE
	 zhtsi3mUn/blxwQ6GnKYq/xKLlGqMNdZL89yxTKFyl4QGx9noaiFt6XWYYVdEatRSc
	 a+QS/QzvJOHe4SwykyxEZ725vSUcY5obh2/goKYLYC8MNevzh3Za6dyImMtMNJD3LA
	 OrDQxapreGT0iKZuXSmwkNnM7Co+vyhQ5jphNFvGoedPl1m5ltcxxI4OJx+jjUpuUh
	 W5uGJCKboiNlYrcIxyBPXyYK+Oa7aR9BVUxZYMH5qUy4AhiIau7RQhSLOUDv94Rsg5
	 yMV0T+Rolt00A==
Date: Thu, 12 Jun 2025 21:37:43 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 0/7] Misc fixes
Message-ID: <aEsshy3Re3E6j0XE@calendula>
References: <20250612115218.4066-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250612115218.4066-1-phil@nwl.cc>

On Thu, Jun 12, 2025 at 01:52:11PM +0200, Phil Sutter wrote:
> Patch 1 is the most relevant one as an upcoming kernel fix will trigger
> the bug being fixed by it.
> 
> Patches 2-5 are related to monitor testsuite, either fixing monitor
> output or adjusting the test cases.
> 
> Patch 6 adjusts the shell testsuite for use with recent kernels (having
> name-based interface hooks).
> 
> Patch 7 is an accidental discovery, probably I missed to add a needed
> .json.output file when implementing new tests.

Series LGTM: Please keep test 0050_rule1 in place, I would prefer not
to lose coverage for very old bugs. Please double-check other test
updates in 6/7.

Aside from that silly nitpick of mine:

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks
