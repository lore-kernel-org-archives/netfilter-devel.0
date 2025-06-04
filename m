Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2AC6F073
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Jun 2025 17:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749059859; cv=none; b=DzwTy3Ie54gb1FhxfhKLR+Et2ifGX1IEFYw1AHh+WZMaUcYvDjzb7s4i/6xLfJQw4A03tRQ38ReWTfMtCekJSXDdhSo+HmRHhYa5+3NgfZDjpftJizcQoD5y4PZJRIZ2U7+nmSoFNgzi5TA0z+75igolfb0fZj00Ce+OZEGgyFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749059859; c=relaxed/simple;
	bh=Gw6njD/ZW66uDE7doFUXEAofT2gzIHi83sr6NoTYnJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RWcWW6TGpbMLHnGSxOYuEa02cqK1EiTGd/GFgAsTIZIRcYxScvPiDT7nuNiwePNXkjr0pAowpAcjnpksFTnUl6+AcNBcB2RUFt0Su3RGLGmXuPEB+BK0Wcy5BkdYfXVbekJkBmL7RdJ+YmTjHE2Lk3ZvtaB9xeRDr+GU6u7nAMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=dxuEo/vs; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="dxuEo/vs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Gw6njD/ZW66uDE7doFUXEAofT2gzIHi83sr6NoTYnJ4=; b=dxuEo/vs741ratFoxXSZE3ZSkj
	+FU+G682R/7lpeVGkCgYg1P9COX3+28YEW5Z5u91U9H6XuKgciCGDEEunlWLYnxyz5A2Y2dLrSxsW
	ujOZzRh2sK2EA/hJD8mdJLHq+6mh6LPceY4bGt2+NI0MTOwdON8u65CPUfRhl0Rje9G3LWWXQ4crm
	yYrUzugSkuRMmT8cbXLIws+gwsnA228+5p4+lthiR4CM2dhH15E62LjmV4KBq9szCigzo49xbA66h
	9G858D7aaWfc2PFHGTcIMvvnyt9fAHRx9d/ErJ6jmpkATMKR1zDbRXDZtxwMFAxHvaL/CtRFC26qp
	ZN4Ne4Cw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uMsMp-000000006qA-1eII;
	Wed, 04 Jun 2025 19:57:35 +0200
Date: Wed, 4 Jun 2025 19:57:35 +0200
From: Phil Sutter <phil@nwl.cc>
To: Folsk Pratima <folsk0pratima@cock.li>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Document anonymous chain creation
Message-ID: <aECJD4M1VpgGMthC@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Folsk Pratima <folsk0pratima@cock.li>,
	netfilter-devel@vger.kernel.org
References: <20250604102915.4691ca8e@folsk0pratima.cock.li>
 <aEBPo-EAZA0_OSD7@orbyte.nwl.cc>
 <20250604154604.0af22103@folsk0pratima.cock.li>
 <aEB5i1l8C8-TK3vJ@orbyte.nwl.cc>
 <20250604173206.75523a86@folsk0pratima.cock.li>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250604173206.75523a86@folsk0pratima.cock.li>

On Wed, Jun 04, 2025 at 05:32:06PM -0000, Folsk Pratima wrote:
> On Wed, 4 Jun 2025 18:51:23 +0200
> Phil Sutter <phil@nwl.cc> wrote:
> > Thanks! I think we need to update the synopsis as well. What do you
> > think of my extra (attached) to yours?
> Good. See the attachment for a bit of style improvement. Removed
> the quotes I put around eth0 to look uniform with the previous
> examples. Also did not like how 'Note that' sounds, as if anonymous
> chains are something unimportant or accidental.

ACK! Formally submitted now, will push it out in the next few days
unless someone complains. Thanks for your input!

Cheers, Phil
