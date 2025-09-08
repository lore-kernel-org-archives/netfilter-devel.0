Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B90B211499
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Sep 2025 10:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757327412; cv=none; b=N84jwtXEYwc5hTjntDeqWQ5bVUis8rbchCwLA+sJh63+sT9IFJ8Au71dJyfGpIeE9IL+lERnh84FpR+V9o4feAZfqO+vx/Eu8VEVXR4s4RCNgthF7/nA/d0vS25KZAFMn0V4uUE5/3NGc8ThFvNRqI65phNSe8VeCzQ59oiTTWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757327412; c=relaxed/simple;
	bh=pX11919m384I/1iiqFcxLY8YYm7FvOvl/Tlkdu5WQMc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NdmJeV/0tWtBgk1V+A1DdcL+ix3NMNQSU5GM3pWtSBJG8/UaFljJk+H6sEJCsTaOTAw3l5cNF/WfKxHrSVBEKvlQQgXX/yVUqCycQUBDIi4XINzlxOz4G1PK0HI8kRvIQm+PGeKeb84PO+39if081ZCWDLpsTgEME8ftCYTUpi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=hEpJi1qF; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=hEpJi1qF; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="hEpJi1qF";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="hEpJi1qF"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id AAFDB606E8; Mon,  8 Sep 2025 12:30:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757327408;
	bh=pX11919m384I/1iiqFcxLY8YYm7FvOvl/Tlkdu5WQMc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hEpJi1qFbLFn0Jgljigor6J5QkEGaVoaxDnhm8xJCz7AmFcJ4jZFuV6rWNPWQKjF6
	 vJyZhKRNZJc/MaIsq2tfVzIQPKzP6bcPljAmffh40FNIUuV1VnGpCVWQ9+1YuFBb8l
	 8CtzZTnCso6EKnWUfddoRb/PK+FvYzpUZvutVvvc8nG2gfb2uH8cqxTinpz0VGdxLu
	 V6R533AHJkcjbKk1FJOcRkYpN8+/N+GPJ3gSFFNlQYbD49uEbKxoUwUyHWK4RwgXkm
	 AccDULnU2Lum1iYhozBbWHBP26MRP4KYOxwQmh685Gp8epTJeOJOUPtokVc+rWQwAU
	 5zNaDO2kAupCw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1530F6068A;
	Mon,  8 Sep 2025 12:30:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757327408;
	bh=pX11919m384I/1iiqFcxLY8YYm7FvOvl/Tlkdu5WQMc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hEpJi1qFbLFn0Jgljigor6J5QkEGaVoaxDnhm8xJCz7AmFcJ4jZFuV6rWNPWQKjF6
	 vJyZhKRNZJc/MaIsq2tfVzIQPKzP6bcPljAmffh40FNIUuV1VnGpCVWQ9+1YuFBb8l
	 8CtzZTnCso6EKnWUfddoRb/PK+FvYzpUZvutVvvc8nG2gfb2uH8cqxTinpz0VGdxLu
	 V6R533AHJkcjbKk1FJOcRkYpN8+/N+GPJ3gSFFNlQYbD49uEbKxoUwUyHWK4RwgXkm
	 AccDULnU2Lum1iYhozBbWHBP26MRP4KYOxwQmh685Gp8epTJeOJOUPtokVc+rWQwAU
	 5zNaDO2kAupCw==
Date: Mon, 8 Sep 2025 12:30:05 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 4/5] monitor: Inform JSON printer when reporting an
 object delete event
Message-ID: <aL6wLZRvbubwsBdh@calendula>
References: <20250829142513.4608-1-phil@nwl.cc>
 <20250829142513.4608-5-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250829142513.4608-5-phil@nwl.cc>

On Fri, Aug 29, 2025 at 04:25:12PM +0200, Phil Sutter wrote:
> Since kernel commit a1050dd07168 ("netfilter: nf_tables: Reintroduce
> shortened deletion notifications"), type-specific data is no longer
> dumped when notifying for a deleted object. JSON output was not aware of
> this and tried to print bogus data.

Fixes: e70354f53e9f ("libnftables: Implement JSON output support")

> Signed-off-by: Phil Sutter <phil@nwl.cc>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
