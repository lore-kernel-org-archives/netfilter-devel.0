Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A52822338
	for <netfilter-devel@vger.kernel.org>; Mon, 12 May 2025 21:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747086344; cv=none; b=IXS7G4FhQ6iMXTNnFfRYQ7WQT6lQDghmo1jGQWrGXXRd68DNtrdbTModvAcNLsRO0dO2ZVNiIO6tDDnw/yvlekFzilY2WoA8in2pYFLECL5c2M/q770avOlU1V1qP4kXbFEQi3bps8Do7fCaDoIlSif3BTTCedGn+X5LStYeot8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747086344; c=relaxed/simple;
	bh=IDvpsSiVkFIBqJsipefg4ONFGeVfzcRkUrk59oXCPIg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hkguhKt1pOERfM9Oc/m3tmSz+rQjimWTi52Ogusvvse7bqpPiWI1LqNsSF0frf27XNcyYoyW5pMTi/EOu4k9MbP8Cl4ef3MsmvqM6HM+HN9nA+v4bMIF6sGfIas1bDI1+wgyLz7x1lY/T3imWk0uyXeUETa3upLD/mLD7Bp13Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pS3qRENK; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lX/50sjU; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pS3qRENK";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lX/50sjU"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 29D1260279; Mon, 12 May 2025 23:45:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747086338;
	bh=pHVnAoo6/4/Q18moLyncMxR8nc1bgz9QB9va2gZ0wrI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pS3qRENKFpZQRPGk4JlN0k9Cb1ABTwZTMpkQeJnz53Y21yeUJ5RkADmLyLOIE4giW
	 gJed4a9CRFqsNOnR1CR3vaGOnba4y0EJbGAjgiUiygMwv/Zk/JfH2U6RPGGN0nOH1K
	 haPny41hgvSUJ8imRQgjdLOXJ9DT37tVjM0ov4zsngleUXX7fpwkWbabk85RLOWDGB
	 zZLU0xoUm8TPmERcOGvoG9ULB+opuqhOMIh/y9A2B/l9GpmPt39Z2xy7x7oLVFnG0O
	 cHnfNsa9HZ4j4TQPWSTQgUL017OHMdqr4/8Sa5gXvVl2wyfTdR99ZpweRARnQe1x/j
	 Stz8XyTzoHaXg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 984D860276;
	Mon, 12 May 2025 23:45:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747086337;
	bh=pHVnAoo6/4/Q18moLyncMxR8nc1bgz9QB9va2gZ0wrI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lX/50sjUYF5S7rfCGG0APaq8SMzj0iLfG1qNaCpceFLoid0NrEyK7n+073Apj8FB4
	 jdqZS4yI9sc7YwVWEnO/yR4KmWSOTIugKe1kF/Q21+mvFw5+Zy3Si8Olcv+ieZm643
	 DV/yTVYRb0x0FHF8fGus2C0RHWa/uY8jyITX8mDonqtqis1+HRGMhfmbGlEGvpX+MI
	 WLPU1CKYsZWL71SDts9yzzHrOon5u1L9lN3w782MCkyRGkrPNYTMSm00EVcMtfL2bE
	 DTMVtinB2+z9r14dX98ohdbbyljKi1/YSe+hvwFIcyVwBvDc2oIP2QgBQSaorehHes
	 H7HzZuPsRM3lQ==
Date: Mon, 12 May 2025 23:45:34 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 0/6] Add test for parse_flags_array()
Message-ID: <aCJrwrJVOasoVfC1@calendula>
References: <20250507222830.22525-1-phil@nwl.cc>
 <20250508214722.20808-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250508214722.20808-1-phil@nwl.cc>

On Thu, May 08, 2025 at 11:47:16PM +0200, Phil Sutter wrote:
> The function introduced in previous patch relaxes JSON syntax in parsing
> selected properties which usually contain an array as value to also
> accept a string representing the only array element.
> 
> The test asserting correct parsing of such properties exposed JSON
> printer's limitation in some properties to not reduce the array value
> when possible.
> 
> To make things consistent, This series enhances the JSON printer by
> support for array reduction where missing (patches 2-4), then introduces
> a shared routine to combine the common idiom in patch 5. Patch 6 finally
> adds the actual shell test case. Patch 1 is merely fallout, a trivial
> fix identified when working on the test implementation.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
