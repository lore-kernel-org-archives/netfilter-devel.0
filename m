Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5461E2D46C9
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Sep 2025 16:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757607438; cv=none; b=gDQZLM1u5al/cLM2aemBcRgIwZFQ4/Xk7DP8JK1wKCiXFXNn0f2pTEg37ig9MQdAOYzezq1THlK9VDzPYyzFksK+y1YturgMONEoLxvulRj1tpTNsttPt78fIRfE1okh0k/e3Iz72tfn2tZDE7lJG3UdVp8Kbu0mmaJbXahFrXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757607438; c=relaxed/simple;
	bh=N7MizTajXW1aHII0E0bcrpAaUtQIIP6AzGlWk0+XUlg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FHDoGDkGm46/7j6Q2KkxQtW0jyYeOgtwYv0Yt57npXeSgaX2U5NUcnpxRAy1EDsh1NsngY4mHZxNdlbIDG6lzSaSVS7KTMAX+1cA/GRXh/qbo81R26b3pQvYKUmX5hw4pjHHy/YikKFaTHl+P60fJ1kLPWvewuHL+Mldxy6MsN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=kenHTosa; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="kenHTosa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mKdyEZmSqapFSP6dSo5k27A0Pya0qjnpt3Oykzd50lc=; b=kenHTosajsHRyfXuDIghoUDdha
	davn06KvA4WkT+CY5SVXA8mEAb8kh8JMRI6SIaW/uQbYGGNifzoBh/b3EqsJ55oveTzFaPDQgUccm
	aFBjsg2TzHSa9S2yZiv3PZQLDuHZaMhE2DkgdEl0o3oapGMq3+H+MoTf9G0m3f5fSUjcxgo28W0Cy
	5RkKFL36nWQO7k/Jy+2fL7HfgbD6EiWvjf0+LcT0t45Ja/KAE/megIIuvaqzRoS8UZhfupu5a3vSK
	tQEoem3SbdJvFaSkBHsp1BwduPkFT0kchLQQQycU/jTCLEDIBpD6hIXyuxojFicthozUX4196GMHO
	vlN3lyDA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uwjz0-000000000BZ-0aKk;
	Thu, 11 Sep 2025 18:17:14 +0200
Date: Thu, 11 Sep 2025 18:17:14 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Yi Chen <yiche@redhat.com>
Subject: Re: [nft PATCH] fib: Fix for existence check on Big Endian
Message-ID: <aML2CpkelDyPuNPp@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Yi Chen <yiche@redhat.com>
References: <20250909204948.17757-1-phil@nwl.cc>
 <aMLaw30XihPy0Moc@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMLaw30XihPy0Moc@calendula>

On Thu, Sep 11, 2025 at 04:20:51PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Sep 09, 2025 at 10:49:48PM +0200, Phil Sutter wrote:
> > Adjust the expression size to 1B so cmp expression value is correct.
> > Without this, the rule 'fib saddr . iif check exists' generates
> > following byte code on BE:
> > 
> > |  [ fib saddr . iif oif present => reg 1 ]
> > |  [ cmp eq reg 1 0x00000001 ]
> > 
> > Though with NFTA_FIB_F_PRESENT flag set, nft_fib.ko writes to the first
> > byte of reg 1 only (using nft_reg_store8()). With this patch in place,
> > byte code is correct:
> > 
> > |  [ fib saddr . iif oif present => reg 1 ]
> > |  [ cmp eq reg 1 0x01000000 ]
> > 
> > Fixes: f686a17eafa0b ("fib: Support existence check")
> > Cc: Yi Chen <yiche@redhat.com>
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Patch applied, thanks!
