Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01CE369992
	for <netfilter-devel@vger.kernel.org>; Sun, 12 Jul 2026 07:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783842022; cv=none; b=JnbJc0rgvtFbyfyirJkgzBkR88nJ4syNcXAmR+y70RHcwkco29Bb+M9xyG0xhuMsKjCNxUvb1ycx49BDtdIFTvOVBIPuTh1NKZmahVXj3+4fXLqDMJeYPaYPZcCzTZ1QSwB0DLpXgqqMhfhkzLlHIX2wpgWFNZLbf7U/i1Ira1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783842022; c=relaxed/simple;
	bh=awWh/MDk78Vq2Xe6+Yc3aHEyGDda4IN6GxJNlKAH8Qg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bNWkCTq/GYUnBfwuHBUZer8JgVtXCM+H7VU50A+iS/ZQZMTCmI42O5YFMdMK4+WVJq/1Dcgd2pyH9FPrRha27CPDyOxtAYbj9xuBVkTEo0BszFe8igPlOnYOxCC5N6I16+pcfuehH649AjP3gBor5GCu5yCcdugxjs7V4QMNbcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4F49D60388; Sun, 12 Jul 2026 09:40:17 +0200 (CEST)
Date: Sun, 12 Jul 2026 09:40:16 +0200
From: Florian Westphal <fw@strlen.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jaeyeong Lee <iostreampy@proton.me>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org, phil@nwl.cc
Subject: Re: [PATCH nf] netfilter: nf_nat: do not reuse an unexpected
 expectation on RTCP clash
Message-ID: <alNE4AO9H0HGLc34@strlen.de>
References: <aQrSf6maL27cH2V4V9ELFdSqdtCWQ-B5iZr8fjR2Wz7zAJ7L32oW50bdrePoTMnJ4CRjDrns-jNMNFHGWNUxYe3UcV91AK99Ilncjab2uDk=@proton.me>
 <2026071134-turkey-detonator-0d87@gregkh>
 <178377968720.33756.12204817361601593230@proton.me>
 <alJva5_-K55ouKGh@strlen.de>
 <2026071235-geometric-snowdrift-bb4c@gregkh>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026071235-geometric-snowdrift-bb4c@gregkh>

Greg KH <gregkh@linuxfoundation.org> wrote:
> > I think this function should WARN_ON_ONCE when one tries to reinsert a
> > dead expectation (and return -EINVAL or another appropriate error).
> > 
> > (This is indenpendent of the real fix).
> 
> If you do that, then the machine will reboot, loosing everything.
> Are you sure you want that to happen?

Of course not, i never set panic_on_warn.

> Why not just properly handle the
> issue if it possibly could happen?

This is no different than the WARNs on list corruption or refcount
under/overflows.

Would you propose to remove those?  I hope not, they help catch bugs.
