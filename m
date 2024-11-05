Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C13216458
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Nov 2024 23:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730848889; cv=none; b=H1ZuvjLSZQhfM72LD2i7XtIGo+nCSXmA75vxZ9Aypd21U437kXMNX1IoOjqUvozkJCL7suKYk3otbshWN3QoRXSwV4qhkzvbsVaGunqjVnqyk6hVX8ogt8fn9bn9RgGWrv4q6g0HxL8RxbkCc1j59kZA0uL080ELV4ETQnHh2QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730848889; c=relaxed/simple;
	bh=Kpbtk66mUUXcvQdJs7QxwafOOE4b6VWfRbVB/jQWyg4=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I1e/GymDHLEQsVJqJtt5LXC0H0bTQFx/nI1r2LQOlYkTp3z4rM4VC+GyZ85QPIcJNyoa5I7ylBinnHgjIPCb8+/qrxz6PPVI29FNUdn/lUIsiwknpBXFaRxPOXSggd7rntXWyvAD6GBhkZoMWioQrtaGdEIKZJ9nWm6tFFIpUd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=53320 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t8SrR-006pzL-OF; Wed, 06 Nov 2024 00:21:23 +0100
Date: Wed, 6 Nov 2024 00:21:21 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [conntrack-tools PATCH] src: Eliminate warnings with
 -Wcalloc-transposed-args
Message-ID: <ZyqocRah5QRXwr19@calendula>
References: <20241105215450.6122-1-phil@nwl.cc>
 <Zyqlyj0FKU7XeUD5@calendula>
 <ZyqnjF-rGIfSCrte@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZyqnjF-rGIfSCrte@orbyte.nwl.cc>
X-Spam-Score: -1.9 (-)

On Wed, Nov 06, 2024 at 12:17:32AM +0100, Phil Sutter wrote:
> On Wed, Nov 06, 2024 at 12:10:02AM +0100, Pablo Neira Ayuso wrote:
> > On Tue, Nov 05, 2024 at 10:54:50PM +0100, Phil Sutter wrote:
> > > calloc() expects the number of elements in the first parameter, not the
> > > second. Swap them and while at it drop one pointless cast (the function
> > > returns a void pointer anyway).
> > 
> > BTW, will you add
> > 
> > -Wcalloc-transposed-args
> > 
> > to Makefile.am?
> 
> The gcc-14.2.1_p20240921 here seems to have this enabled by default. I
> did not pass any special configure or make options.

I was expecting something like this, thanks for confirming.
