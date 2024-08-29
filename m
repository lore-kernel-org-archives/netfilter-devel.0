Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134C916D300
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Aug 2024 12:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724933330; cv=none; b=jeWJRFODmL9hrIWrPXOwsF5uss88Uf26A4NgOFcJ8aOHTtRSKfU8ArKi3NeoEmAFS8exgbvBBoE4KC0wytlWoo+mZZJ0sN7Izu4+r5IMLhDu87uZ8BdYqlz1s1TXOztJSd0D/22AfF2ExTp4nSMjfO7tYGK0AKWGy6x0eXcseOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724933330; c=relaxed/simple;
	bh=sA5clQDgQnkK26Z5VRjr1PmHW1UIlx4qKa5itIf6p1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U8+obnC9KA4IZmhP1thfFz7ben9MPfqnlC9S4KmyzfyVkND7nYX/h9Qm0pOADOYLAHyql5kgYg9NFHtwzLsRZbbT6WX1XxDjbegRQzXXS8onPQlsFZ8mLY49QHVtuSODhvBK/A1EvLMvVQzMjpT65bDSBhdSbN7acMNlmvUxX10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=qJZMT1E5; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="qJZMT1E5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sCizjrnwZbPeFzdffyOQ5OPbKR62Z+SsYqX1k+/IXPg=; b=qJZMT1E5K4mfZD6IQz0syQighu
	f9KqwVcxhqr424ILEcSF8d0So/LaDX0PnmE4gnbBTxCRh3nNXhDudrsjVZ6gIL+rcYb/SbS74o/UZ
	lN8Nzoi6r3otiGi7FHJBLaI6WqQC4nqTdxhCVCr54pwCRQRbbC0kmEFZKwqzrM3YBvyO+m2vbeh9X
	iHAYcUbNGp3Cx67L2/NL3trti7vsGxYV0F1BlLFrueV7P1Qtm47K+iyq0j19+z9G0tG+aWja6pb2s
	p2dU9fz304PU7eQ69Aghzdh5S34iPbp4UBVBe90ti+xSJ6KezBr2MZ6KhfcDHL9y1biQ1uDUsqvQG
	7fjjwZCA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sjdxF-000000000H4-41mT;
	Thu, 29 Aug 2024 14:08:46 +0200
Date: Thu, 29 Aug 2024 14:08:45 +0200
From: Phil Sutter <phil@nwl.cc>
To: Joshua Lant <joshualant@googlemail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables 1/1] configure: Determine if musl is used for
 build
Message-ID: <ZtBkzUiFIvmtyaWp@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Joshua Lant <joshualant@googlemail.com>,
	netfilter-devel@vger.kernel.org
References: <20240828124731.553911-1-joshualant@gmail.com>
 <20240828124731.553911-2-joshualant@gmail.com>
 <ZtBWoImxzGRBFLs2@orbyte.nwl.cc>
 <ZtBj3hmWMn5lapzA@thinkpc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZtBj3hmWMn5lapzA@thinkpc>

On Thu, Aug 29, 2024 at 01:04:46PM +0100, Joshua Lant wrote:
> > Thanks for the patch! I tested and it may be simplified a bit:
> > 
> > [...]
> > > +	#if defined(__UAPI_DEF_ETHHDR) && __UAPI_DEF_ETHHDR == 0
> > > +		return 0;
> > > +	#else
> > > +		#error error trying musl...
> > > +	#endif
> > [...]
> > 
> > Since the non-failure case is the default, this is sufficient:
> > 
> > |       #if ! defined(__UAPI_DEF_ETHHDR) || __UAPI_DEF_ETHHDR != 0
> > |               #error error trying musl...
> > |       #endif
> > 
> > Fine with you? If so, I'll push the modified patch out.
> > 
> > Thanks, Phil
> 
> Looks good to me :)

Thanks for your review, modified patch applied.

Thanks, Phil
