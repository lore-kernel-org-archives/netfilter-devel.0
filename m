Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E74C33A716
	for <netfilter-devel@vger.kernel.org>; Sun, 12 Jul 2026 07:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783842878; cv=none; b=dRjR1jeyR2wD3VBlqX5ahK0Asu4XtpdplBtAxaBJ862amHCTnUizIrAOKI+uwHk6/1ftXYdUxgjdqqg2Ub/XMixDqZ/fCJ+R3ECCAKxy6uOtFzbbe7VCMKBFtSgdTNymc2ZDQ0ypLrG3Tm6zzwUtkGBJ9cpwDaL3fVNz2nWL1NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783842878; c=relaxed/simple;
	bh=l6mZuQCYdM+r/1Z+5nNp5GeJfPrWrT/Psz2qd3ZX+i0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UgltJ0Yv1D3bvIoBQ8sPmc15TZtFDhNK03Q/10l5g7HMUzkcNDBtTdak07/978BEfLexMb2qDPskLRiH1ebRqxkIOwQo2ff4udUftRdCvNDSUkzABv8d7eDxSL5YLHsQLFUNIEbM8PUNHhGZhZAYyg14v8V8z2vIY6N33ouR/zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vDFK3Kg8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vDFK3Kg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11FE1F000E9;
	Sun, 12 Jul 2026 07:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783842875;
	bh=rtwRhKcWugeGWfVrEfzJe21k8ollWkghkI1bz4gJD3o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=vDFK3Kg8dycpSHPMHhVhuM5Gv0CsPwcMgTX70CCqeGFTzegMwouMDI1q55Y1jE/RB
	 WFkcJYVZC2R/1L3/ibTt41hErAluSDHo0MUFfzJ1FES9jAuPwuT/Fhhi8OiqDP6Dcj
	 37qII+aZrjF8ZdiRu7fQ2hfO585ASxpvFSdn7lmM=
Date: Sun, 12 Jul 2026 09:54:30 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Florian Westphal <fw@strlen.de>
Cc: Jaeyeong Lee <iostreampy@proton.me>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org, phil@nwl.cc
Subject: Re: [PATCH nf] netfilter: nf_nat: do not reuse an unexpected
 expectation on RTCP clash
Message-ID: <2026071249-contented-gallantly-2927@gregkh>
References: <aQrSf6maL27cH2V4V9ELFdSqdtCWQ-B5iZr8fjR2Wz7zAJ7L32oW50bdrePoTMnJ4CRjDrns-jNMNFHGWNUxYe3UcV91AK99Ilncjab2uDk=@proton.me>
 <2026071134-turkey-detonator-0d87@gregkh>
 <178377968720.33756.12204817361601593230@proton.me>
 <alJva5_-K55ouKGh@strlen.de>
 <2026071235-geometric-snowdrift-bb4c@gregkh>
 <alNE4AO9H0HGLc34@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alNE4AO9H0HGLc34@strlen.de>

On Sun, Jul 12, 2026 at 09:40:16AM +0200, Florian Westphal wrote:
> Greg KH <gregkh@linuxfoundation.org> wrote:
> > > I think this function should WARN_ON_ONCE when one tries to reinsert a
> > > dead expectation (and return -EINVAL or another appropriate error).
> > > 
> > > (This is indenpendent of the real fix).
> > 
> > If you do that, then the machine will reboot, loosing everything.
> > Are you sure you want that to happen?
> 
> Of course not, i never set panic_on_warn.

You don't, but a few billion Linux installs do :)

> > Why not just properly handle the
> > issue if it possibly could happen?
> 
> This is no different than the WARNs on list corruption or refcount
> under/overflows.

True, but adding new ones is not a good idea, and removing the existing
ones is a good idea.

> Would you propose to remove those?  I hope not, they help catch bugs.

Bugs that userspace can trigger?  If so, then properly catch them by
testing and handling the issue.  If userspace can never trigger it, then
it's not really needed as the code is never going to trigger.

thanks,

greg k-h
