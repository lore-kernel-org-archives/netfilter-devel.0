Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7CE6FC5
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Aug 2025 22:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756334892; cv=none; b=u60R2kwkxOIYGEgAV+mrV/jtKUiWZ7d9qsx5ujc08zo8cgPlkLqlg+CFguGlsZ1901Urd4G2pwx63Q33ssg/J5zCGWXkGMukqe2PtWfJk++OImSVyLHhd3kNk2ElTXL7EBmUzKmkudhZx1MPbML6P6Kqn95EX7F7ieZ1z3rcijI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756334892; c=relaxed/simple;
	bh=Z6VmhIniThUlk94KyCUA97Xli1jK+QcKG89vea0Skek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sxJRwTFFRaearIOLuL77XC6CkuDEz1WxxFBJo3bYMbrJz7Q2wQHZ6q5kDQJSr+iSBhNNNO9LJpx60i1u4bBkaQkJxzDAYnTdNTJa/2/Rj0zgquBpNfRJ2hvkUmm2FBuxTQ2ea2gAK6Q8fkqQQx6esPinx4gPici7ZnPX7gUmFls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Qzf3hn3q; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lFqXULkn; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Qzf3hn3q";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lFqXULkn"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 4526760745; Thu, 28 Aug 2025 00:48:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756334888;
	bh=yvS2CdxZxYGO2RyyXWMvM0jJkzhIkWHXb7vOn8u1INA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qzf3hn3qHeuDfZ7tsUIM7lgCDx38iiszcyYZevjRAhN1TtlUb69san38qTyEA246I
	 sxJkp+I+oNJ9TQ8hjAoWcUkpHPAvhw/xTm2Avam/SUyLnKmYI1wjM2/cBpAm9ejXxF
	 34xSidjdtDF8sp+ZQSLQjSHh+rjoAMrZwVsrLNn6bZaplTe9kFkf1RxV3tLBZpdc7n
	 tmbywAlbx81qIOi9peJo7pLMU8y+msnBm/rQS6KUH3IaegZA3mBxmNKB5mfce53DOU
	 WLuVmL4h/woJla7LDPWHU5DuFtsAerT4dHZrpYngoy7rIyiTVU2nKcGN5vtPL0WpaY
	 pK6JV6UDwoe1w==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C29656071F;
	Thu, 28 Aug 2025 00:48:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756334887;
	bh=yvS2CdxZxYGO2RyyXWMvM0jJkzhIkWHXb7vOn8u1INA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lFqXULkncs/vOkq73AQ9XJXfKzPhriT/lATk3G1Xy1DeEXU3ES7T4cv6EdCq+h5V+
	 K05/HsMYhX1P5xOT/+gJBPvvcw7Nk2FlsGkqL14UEpNM0ln/jnZ9w8H1t+Nj/oMySK
	 7+5EpqZ91lmnAudmkxpqZ6Wx2L1aP7FyZ6LjvN2KNX22MZ8AE9ezlO9sezAoB4DwT/
	 QVjQYFdbf5oZv1EUwVwayDsg7LJXK4jvm+A5C/jhRF1nD/D2s0dbQFVFOylg8VsWaM
	 yPuVJuzAGKKKkCgJ+r9WE8pxzUHt5OXuedsibzl0KfK2f7622JvrBVZMgDSogq7PsW
	 l6FHcYmgtx9vg==
Date: Thu, 28 Aug 2025 00:48:05 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH] udata: Introduce NFTNL_UDATA_TABLE_NFT{VER,BLD}
Message-ID: <aK-LJaptoYyZhmbe@calendula>
References: <20250813170703.28510-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250813170703.28510-1-phil@nwl.cc>

On Wed, Aug 13, 2025 at 07:07:03PM +0200, Phil Sutter wrote:
> Register these table udata types here to avoid accidental overlaps.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks.
