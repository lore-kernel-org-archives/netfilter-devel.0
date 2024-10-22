Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3E21A00D6
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Oct 2024 14:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729608939; cv=none; b=k8xkGb5heYni+ZXblkuVdSXr2g67ZjU49+k7dby3AL6Y0LPSHewq7G+Jp6yGTpaF+vEyrEi+ggQi2QT71FH4Q+v7iwWMl7izj2yjxTHqMsCIuhf59FZwtzJbCi6sk+E6eTwl8a44jMdxLrhLbhun+w7vIxvV2CvdjIyvMfjQ3vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729608939; c=relaxed/simple;
	bh=fZ10OF+uZvoBFfMfecd0oZnHvgBJ5o46gIvnEOnRHX4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M3Swee2FHZBq1TFCV6gA9ZHS8bTd7PTB7/Yooe7k1t38JlN0MMn3J5k1gynm9EHKkMBHmZPeAcjFFJ2MVlAFWw3qWkAzziXdw4JdkcmweNhEt0IwEjAW4cLPO1MvfZzaWxC7w01dWacTubP7PKQZEriZGJcd0uAgmNS1j5IxC7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ejOBMPMw; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ejOBMPMw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=YYdsK2Gmuw37hZGYEOk8kDaDtRBI0M7w5+ykEQab0Ns=; b=ejOBMPMwXA5ZWLDTuZKvBpCkIg
	PC3RBvkOpJRp8+MW7qJLL5M3X1Cjolua00u8wOpdCw8Hst9FOUfevkDYi1SNw9bmQF0JzYtnQHsU/
	4sEg7lav/uKcTyULO25t70JcoVNZ50/hOkpQEbrL46a9pW0ohlTDj5iGMlNj1Ny4cMv/o+cz+RfgP
	PJAw+t6EsaQcLOnlGijsrQK+nLhHOmibc8azGw06aBx/2EOC+rdxEVj4cI3VDLLFL568LL/1G4sub
	lclzZAbnTxs2ziWQcFP/FUcDKQkhqnOAY8qM3cfS0uTz/xV2L6mgqs9XCWZQ1bisffLpoHeQIYgp3
	wxDWT3YA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t3GIH-000000000Yp-26OI;
	Tue, 22 Oct 2024 16:55:33 +0200
Date: Tue, 22 Oct 2024 16:55:33 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH iptables] tests: iptables-test: extend coverage for
 ip6tables
Message-ID: <Zxe85R9YnoOL-pzg@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20241020224707.69249-1-pablo@netfilter.org>
 <ZxebAVfZ_aDSNeb4@orbyte.nwl.cc>
 <ZxejsR2ph2CSnYjD@orbyte.nwl.cc>
 <ZxetHFXRj08Jipu0@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxetHFXRj08Jipu0@calendula>

On Tue, Oct 22, 2024 at 03:48:12PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Oct 22, 2024 at 03:08:01PM +0200, Phil Sutter wrote:
> > On Tue, Oct 22, 2024 at 02:30:58PM +0200, Phil Sutter wrote:
> > [...]
> > > - With your patch applied, 20 rules fail (in both variants). Is this
> > >   expected or a bug on my side?
> > 
> > OK, so most failures are caused by my test kernel not having
> > CONFIG_IP_VS_IPV6 enabled.
> > 
> > Apart from that, there is a minor bug in introduced libip6t_recent.t in
> > that it undoes commit d859b91e6f3ed ("extensions: recent: New kernels
> > support 999 hits") by accident. More interesting though, it's reported
> > twice, once for fast mode and once for normal mode. I'll see how I can
> > turn off error reporting in fast mode, failing tests are repeated
> > anyway.
> 
> Would you point me to the relevant line in the libip6t_recent.t?

It is in line 7, I had changed the supposed-to-fail --hitcount value of
999 to 65536.

Cheers, Phil
