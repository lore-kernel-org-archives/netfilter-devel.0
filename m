Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDBC1D432D
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Sep 2025 21:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757971174; cv=none; b=j7r42E+GqGhsCY/ESLgxZGVeZtSNReF+M6bscYzCvSPqyyoHyXWSLowVkGZ8PtUUrRHjNkpg1Y+tbRMSn76fHHMhb9cDiAbeF5MuuiavT8sVRpYPeZZQkh81cH/yGFHOWe8yzf3R6Cge07+2bew9JXx3ZNVRyf3coOPXCTymwyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757971174; c=relaxed/simple;
	bh=3lgmxg7ZE+SfCE9nPeIzJbhAduBdD6AHuUMTFqX8cAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RguAR8c4lvKK8lQAdDVO32UTsInm3jBzPV+U4VblKotuwz8Z7IwwNKrD4B/q/xm6waOc+SKuXNyhhoAvPMwSLr5ZXIOIbuvqilBpxhSkCQKdN9PUsD6/+WB4tbLXJeIVvmtGuXTB5lnyx862hVy0DCxzvXXvbh5f1+Sm1YLQ+z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LGw8qz7B; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=WCMmxIrM; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LGw8qz7B";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="WCMmxIrM"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 43FEC60264; Mon, 15 Sep 2025 23:19:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757971170;
	bh=5XHQLQ7b2Z336m3dDcHKbXBH+FhO4w1lwClR5ghswK0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LGw8qz7BkDRpuCqi7wszFLNBfEOnWgkyo/XLopP8pwlE36cSm1C3YmENg+id5UaoE
	 Iei0fAee9bHWyPT22mff6cVzujsSVNDiBTzgbU9p3VrImfydKsKjVwEgT4HfYMy0Qw
	 B17YQaZc4DLLzDIq6yOwc9aHBgMF/4swR39CBMBV4YA2AjW5G75ZZGjX1p2dD/OEe7
	 31FVXvltecpbeUTyZu5G6CJKJdC4lTMzcXHfaGXIW6Fys1Ic5LLcJCf2Y9DZbmPogQ
	 6lwLv0WzNZDV3BT5/rYC5wdHRenoQB6rYxjn3gvmhWK2+NiBdyNRa6S5qDB0SROPsF
	 oFwdnIzM2j1AQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6D5CA60253;
	Mon, 15 Sep 2025 23:19:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757971169;
	bh=5XHQLQ7b2Z336m3dDcHKbXBH+FhO4w1lwClR5ghswK0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WCMmxIrMzIdz+kW9Jd1FBUGt9thLSJkCk/aisGDIO/pkMBSanx3tJctMHsutCMELZ
	 yclLi19iJd0C8wPa10j/XgefoF+nFZZxfl8fTvMxCKurzD3ULZqWJJqKoxKB/7ljbi
	 dFjtpdktmbsECWJHVlBjGA68gnyhM8fa9j4WbvjDc9wufzYfen/y2ecjhQ7xbifG/B
	 KBInO5XcjRw99+1Cn/XBrau1b0DKkJx7b2Dh0YUAhB5NbMqZf4X9/t63enM6q1wuM2
	 s9XSES8+cLj/JLZL6hL2uAOTaJJ9C3e5iA/21/bXoFnplcTZRplkw2InmpmqN2x2fz
	 CX9eJ8Q1ZwT/w==
Date: Mon, 15 Sep 2025 23:19:27 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl RFC] data_reg: Improve data reg value printing
Message-ID: <aMiC3xCrX_8T8rxe@calendula>
References: <20250911141503.17828-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250911141503.17828-1-phil@nwl.cc>

Hi Phil,

On Thu, Sep 11, 2025 at 04:11:45PM +0200, Phil Sutter wrote:
> The old code printing each field with data as u32 value is problematic
> in two ways:
> 
> A) Field values are printed in host byte order which may not be correct
>    and output for identical data will divert between machines of
>    different Endianness.
> 
> B) The actual data length is not clearly readable from given output.
> 
> This patch won't entirely fix for (A) given that data may be in host
> byte order but it solves for the common case of matching against packet
> data.
> 
> Fixing for (B) is crucial to see what's happening beneath the bonnet.
> The new output will show exactly what is used e.g. by a cmp expression.

Could you fix this from libnftables? ie. add print functions that have
access to the byteorder, so print can do accordingly.
