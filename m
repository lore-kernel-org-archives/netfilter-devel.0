Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C55285058
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 16:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761668806; cv=none; b=kpwPQvtfbG1o+xaYHHTSwZNfeVErdlY4lbzs4L8BsGcvtddaQy4HyWTUt7B5mdwCEtDCOdUbojfHGLnZF9JbbmcjOD+Qn3UFpVU0BLAvLRe1ZTGLziYdXKatBIbwVFOrjjN3SkIQ/D9QFokikucMgduhCnfZ37gx2R3s/7pjaSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761668806; c=relaxed/simple;
	bh=NBcOSaBykf2Y7JpidrcTq9ZKXM1eeD204FvxYzQa3ag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V/sD24iQwVNUf46x1aS9wjFnMohJf29HGRK7mdldsRet9s72ej4LJLZNaW3EXYjVmNARa5iqr5aQMvOfSnR+zp/8TjP37AQG+KeI3v83lMx0eZk1sdAvaYi0vhu1eVY3HmgDW0lVk8paA3G9N7b/3p8a7NQSnhq23QzT2VNbL2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 367F361A31; Tue, 28 Oct 2025 17:26:41 +0100 (CET)
Date: Tue, 28 Oct 2025 17:26:36 +0100
From: Florian Westphal <fw@strlen.de>
To: Christoph Anton Mitterer <calestyo@scientia.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: nftables.service hardening ideas
Message-ID: <aQDuvGsDwlaiK94D@strlen.de>
References: <71e8f96ac2cd1ee0ab8676facb04b40870a095a1.camel@scientia.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71e8f96ac2cd1ee0ab8676facb04b40870a095a1.camel@scientia.org>

Christoph Anton Mitterer <calestyo@scientia.org> wrote:
> This would be ideas about further hardening nftables.service, primarily
> using the options from systemd.exec(5).

Whats the point?  nft will exit anyway.

> which not only mounts some but the entire fs hierarchy read-only for
> the service's commands.
> I guess nft -f should never write anywhere, or does it? At least it
> seems to work.

nft -f should not write anything.

> 4. I guess nft needs no capabilities/privileges other than
> CAP_NET_ADMIN:
> > CapabilityBoundingSet=CAP_NET_ADMIN
> > AmbientCapabilities=""
> > NoNewPrivileges=yes
> 
> CapabilityBoundingSet=CAP_NET_ADMIN would supersede the =~CAP_SYS_ADMIN
> from (2) above.

CAP_NET_ADMIN is mandatory and should work as only capability.

> AmbientCapabilities="" disables all ambient capabilities, I'd blindly
> guess that nftables doesn't execve(),... but it shouldn't harm either.

It doesn't execve.

> 5. There should be no reason why nft -f needs to access stuff in /tmp
> or /var/tmp of anything else, so:
> > PrivateTmp=yes

Makes no sense to me.  nft -f won't write anything.

> 7. AFAICS, nft -f may cause modules to be loaded, but that's done
> indirectly (i.e. I guess by the kernel itself?)

nft relies on kernel module autoloading.

> So leats get a bit more exotic ;-)

Exotic? More like estoteric, this is bad.  Service file should be small and not rely
on obscure and maybe not well-tested systemd code paths.
