Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B95145B28
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Apr 2024 10:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830616; cv=none; b=R2kL6tAD4xrc2IQWg+Z6fWfg+jdDvjeEFKiwRXOupKGFJPrWMA2+4OrEowQa7nRXqTFpEfgdUbLijpOZuxJb6JEDDesQ74hPkmlUUQGVdosZleuZucxcmdx/mIzuojPddCfcCka1uH1kk3sqbcmeNh+BEjJa7fNEdg5NMdr3LIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830616; c=relaxed/simple;
	bh=rhDJ2elEjepYtZL0CJA6pkFSt+WojYYQOOPGFyS73X0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ovuuNw3LlFcrMTE6oP5RoSnkIl/Eev727a8Gp045zV5RTtIlYQW5ch3OWzy+NqBSvftPg1TUXBmWE/fwSdlFDfWjFHjx0iSegZSF5LhcfV7ZNvJo/+IBD0IZ//O0hpgJW4kwG6+1/5a2ReX7bCxO6RpucOjbK0kGx+MpM/f9Tu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=RS+ae/2Y; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="RS+ae/2Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=woBldjNzYTeSWaAEVrGIoovGlHKrv7r9hFbOhcEW3U0=; b=RS+ae/2Ypn83nFWLkFqlhjovdO
	CZokv9Z6PCpDDH2ljV6vSdWdTrsQ9NxejmYAEJkYVwavJXm8snsQmhJyyeg1kQmFOYFM5Tnbc+tqP
	Zt5qhMLy/WN3BrhHox9yew298iv5vDCq3TlvxjC9ZaLY8cCTwDxC4wQAtp4ekf8tZCPKShPai8RUQ
	BiiPXrBTYCW6NNmhFFTn1z7n7lSexqlTud7RsZ2XlJs4CQvqTlRn6lI9Rc4koNouOiShM+Ab7Fllw
	LbsEd3HRcqu+nOBwhsHBJ9SfzQGtyEjU7SElyqHu8/72i5oemLm/PCJix7w6RpDFqRaXo1X/nHf2T
	XD8akYHw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rurUD-000000001J0-0fhJ;
	Thu, 11 Apr 2024 12:16:53 +0200
Date: Thu, 11 Apr 2024 12:16:53 +0200
From: Phil Sutter <phil@nwl.cc>
To: Vitaly Chikunov <vt@altlinux.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] libxtables: Attenuate effects of functions'
 internal static buffers
Message-ID: <Zhe4le2MCzFVF-Og@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Vitaly Chikunov <vt@altlinux.org>, netfilter-devel@vger.kernel.org
References: <20240409151404.30835-1-phil@nwl.cc>
 <20240409164910.5x6l35anvc36juca@altlinux.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240409164910.5x6l35anvc36juca@altlinux.org>

On Tue, Apr 09, 2024 at 07:49:10PM +0300, Vitaly Chikunov wrote:
> Phil,
> 
> On Tue, Apr 09, 2024 at 05:14:04PM +0200, Phil Sutter wrote:
> > While functions returning pointers to internal static buffers have
> > obvious limitations, users are likely unaware how they call each other
> > internally and thus won't notice unsafe use. One such case is calling
> > both xtables_ipaddr_to_numeric() and xtables_ipmask_to_numeric() as
> > parameters for a single printf() call.
> > 
> > Defuse this trap by avoiding the internal calls to
> > xtables_ip{,6}addr_to_numeric() which is easily doable since callers
> > keep their own static buffers already.
> > 
> > While being at it, make use of inet_ntop() everywhere and also use
> > INET_ADDRSTRLEN/INET6_ADDRSTRLEN defines for correct (and annotated)
> > static buffer sizes.
> > 
> > Reported-by: Vitaly Chikunov <vt@altlinux.org>
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> Reviewed-by: Vitaly Chikunov <vt@altlinux.org>
> 
> Also, I tested in our build env and it's worked good.

Thanks for the review and testing, patch applied.
