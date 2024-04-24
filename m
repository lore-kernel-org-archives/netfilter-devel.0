Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD9114A85
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Apr 2024 18:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713983719; cv=none; b=JkoBnR7WfPi3Z5IonVfrwFP42sw7kN8gaMvC1dCmwdY/m9GZbDsDp+/iI+dekMRUXMLtWMLpZwPetzl3HQW3CQ36VZnm3pL85ZdPpQWD9h7RIvIY9DFzRhrU8/xCgmypfPx1/sln7nW+91eGgm94pWkXxCHx8XeVSa6+4xtHqv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713983719; c=relaxed/simple;
	bh=PjfL/hZUjcjRqmhIXiq5r/+CNwXcNOPiUIBDl3QebSE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ASECYnGMcT621kZgTGugUc57O4+oq2q7UyAsZ/vPR0aWsnYMQAXHZLacPXLDwHcElirsonBmX9R/YssfIh/3FF4gZUa0zc6fymG1bH8WFinhOLUmSG2ns0HIvWx4eqG98oe0ntKB5Cnd7D9+/EUWj7L1jNg8Sh3G48xwPzxl58o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=EZNgO6r0; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="EZNgO6r0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ID+7SnXm50zDVA2zBIqZ2DOqLOGiE26GvJnBLz9yjdY=; b=EZNgO6r0orINbVri+BZPWiJgQQ
	0vQPLmw+OCF0pu8yfblC9GQ0U/DRHu2uum4phA+NCvpgFbiG9OyRFWb12Y/KIpS7kGCBQK5Cr20wu
	xOmzeGh5cPb0fIYkdVhOlbo2HDMnQr08pbd2GJ6XzAzk3NE4qIqxcMauqJUpfaihbi5pzB1J9rWwc
	31QvNaE1NEgMP00eoegzHtSKoXQCX2PlJqTBF/rNcDizqkzdZoIZ9i2K4mem/roXNZkKUIsLkQ4GC
	rPoGJgFDhUl3oGdExTuNBfHPwOtqruCTio0ir321YdsxLZCfm4ji/EHDEi1UPpjovT8NHFTOe1QIX
	0K73Ui9A==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rzhSa-000000001Wo-2ODL;
	Wed, 24 Apr 2024 20:35:12 +0200
Date: Wed, 24 Apr 2024 20:35:12 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Alexander Kanavin <alex@linutronix.de>, netfilter-devel@vger.kernel.org,
	Khem Raj <raj.khem@gmail.com>
Subject: Re: [iptables][PATCH] configure: Add option to enable/disable
 libnfnetlink
Message-ID: <ZilQ4G2LzdU4ksEq@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Alexander Kanavin <alex@linutronix.de>,
	netfilter-devel@vger.kernel.org, Khem Raj <raj.khem@gmail.com>
References: <20240424122804.980366-1-alex@linutronix.de>
 <ZikA0v0PrvZBsqq6@orbyte.nwl.cc>
 <53acd1f2-92ed-4ea5-b7be-05d3a0f5b276@linutronix.de>
 <ZikeIC9v7J0z8GXa@orbyte.nwl.cc>
 <ZikjLzdb97ZS1muM@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZikjLzdb97ZS1muM@calendula>

On Wed, Apr 24, 2024 at 05:20:15PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Apr 24, 2024 at 04:58:40PM +0200, Phil Sutter wrote:
> > On Wed, Apr 24, 2024 at 04:11:59PM +0200, Alexander Kanavin wrote:
> > > On 4/24/24 14:53, Phil Sutter wrote:
> > > > Hi,
> > > >
> > > > On Wed, Apr 24, 2024 at 02:28:04PM +0200, Alexander Kanavin wrote:
> > > >> From: "Maxin B. John" <maxin.john@intel.com>
> > > >>
> > > >> This changes the configure behaviour from autodetecting
> > > >> for libnfnetlink to having an option to disable it explicitly.
> > > >>
> > > >> Signed-off-by: Khem Raj <raj.khem@gmail.com>
> > > >> Signed-off-by: Maxin B. John <maxin.john@intel.com>
> > > >> Signed-off-by: Alexander Kanavin <alex@linutronix.de>
> > > > The patch looks fine as-is, I wonder though what's the goal: Does the
> > > > build system have an incompatible libnfnetlink which breaks the build?
> > > > It is used by nfnl_osf only, right? So maybe introduce
> > > > | AC_ARG_ENABLE([nfnl_osf], ...)
> > > > instead?
> > > 
> > > The patch is very old, and I didn't write it (I'm only cleaning up the 
> > > custom patches that yocto project is currently carrying). It was 
> > > introduced for the purposes of ensuring build determinism and 
> > > reproducibility: so that libnfnetlink support doesn't get quietly 
> > > enabled or disabled depending on what is available in the build system, 
> > > but can be reliably turned off or on.
> > 
> > Thanks for the explanation. I don't quite get how a build is
> > deterministic if libnfnetlink presence is not, but OK.
> 
> IIRC, there are also dependencies on utils with libnfnetlink that
> would need to be disabled too.

Within iptables, we only have nfnl_osf (in utils/) which depends on it,
but missing HAVE_LIBNFNETLINK effectively disables it from being built.
So unless you have something else in mind, that's fine with and without
this patch.

Cheers, Phil
