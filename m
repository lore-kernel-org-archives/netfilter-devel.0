Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0620028980F
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2026 09:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773221928; cv=none; b=FOF8QPzW5tLqa1AnFwlpyYZjO2JgDlqKQ/S4WgjZtPFM5nQ4p+lM7a4HM1+fEWPtGzWoIWvCv2dMxKtuBYZABBcyKWCBCknLyQkokE/AS8BPjPx02ND6N28/+xlKrz3CA/jUeazLi0uitCeE6R4Mvyky4pSOsYDPPErQqYXPA9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773221928; c=relaxed/simple;
	bh=8M4BJpaphTCW0L70AWE06tZUOWYafxDskdIIlXr0UMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OpvvOV4DrYMa6hf1DkKEE1ILQoEljCbcyJy/L84JlzADT6OlrhmZ5IKT6AkAtRFVNcczN00V9kHbpgF7meaQI9laTQPC+SNSekxldXuTWWkL4MCii4ncnWA5/gI2o70zGYuHMQ6uulF6pH5un2YQWBXKEbm7v4DWw9G8LDdg598=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OF2qH+og; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OF2qH+og"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 594CE602B4;
	Wed, 11 Mar 2026 10:38:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773221925;
	bh=+0mGr2DHrueRMJ6WgXfPnjD2RUzyWMMC89pMe3yx5wc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OF2qH+ogOQs1Jl+M9XQPsokcvdxHoYglUunlFH475QOIdeP67HbWUlvWmz8jL0xec
	 CwdOFmEcazEkG3Cgi0OVQp0x4tas91+jP6n9sSaZxHcqNRFxe+YHRM8mCldbvdBXZs
	 em1f0PRqrVWLmmoCO/AHxX4G0+wZ1C4fsUP3Xww7kDURXJ7QRWnEjlZ05vJcZY7AMQ
	 da4mqHB4rrL5gpyObzWfPxjHo4j/9Zk3RPRmDMUXtabMjRYWwo5m1uV+n9U/5vd5zc
	 rKQoPV7pJ/5etClkvny8s368sJLzThPQAbSJL4YMpDI+CKZGeAqef+NErDa4lidzcy
	 mEpKfWB1jkyBA==
Date: Wed, 11 Mar 2026 10:38:42 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 3/5] cache: Relax chain_cache_dump filter application
Message-ID: <abE4Ik-Qorwr471H@chamomile>
References: <20260310231115.25638-1-phil@nwl.cc>
 <20260310231115.25638-4-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260310231115.25638-4-phil@nwl.cc>

On Wed, Mar 11, 2026 at 12:11:13AM +0100, Phil Sutter wrote:
> While populating chain cache, a filter was only effective if it limited
> fetching to both a table and a chain. Make it apply to 'list chains'
> command as well which at most specifies a family and table.
> 
> Since the code is OK with filter->list fields being NULL, merely check
> for filter to be non-NULL (which is the case if nft_cache_update() is
> called by nft_cmd_enoent_chain()).

Fixes: 17297d1acbbf ("cache: Filter chain list on kernel side")

> Signed-off-by: Phil Sutter <phil@nwl.cc>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
