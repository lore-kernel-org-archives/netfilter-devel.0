Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5901A2C29
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Oct 2024 15:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729609653; cv=none; b=n4JgvercMk2/kTVNVTAZ+iBaSfdZhQUWg05z9l4KBKur/VEHfMCu6TGTlKasmKf6ub+cgrOyWBNKQ/V+Tl8zdOCkyuPwufdxD823cAcqsg/timLVGngeV+O6njQ631Aj+XHwVIk6VpSp4JSkpBVTKB2w/N+3+Vtr6MPA4WcfQUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729609653; c=relaxed/simple;
	bh=tL3Wv8Bj8jD+oMr123Recem5CwyP633UB+UDsZKW+xU=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ooyv2yrWD8oh8T4dORiyPiV3HqNb7W2a6tcqXp6IYCl8n9JEgwbp+Ml2NDTCU7YMiyVqhWV2aruR5aOLsbQYwE9fwA28xgRnGON/kvJPEv/DXbumaXckewewW9kgHqd6koHWeiZVw4sxRvUoX5E8Fru4kCILg/7n0POozTHkeOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=37968 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t3GTm-00E4Rh-KP; Tue, 22 Oct 2024 17:07:28 +0200
Date: Tue, 22 Oct 2024 17:07:25 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	fw@strlen.de
Subject: Re: [PATCH iptables] tests: iptables-test: extend coverage for
 ip6tables
Message-ID: <Zxe_rez8MZN-ieN8@calendula>
References: <20241020224707.69249-1-pablo@netfilter.org>
 <ZxebAVfZ_aDSNeb4@orbyte.nwl.cc>
 <ZxejsR2ph2CSnYjD@orbyte.nwl.cc>
 <ZxetHFXRj08Jipu0@calendula>
 <Zxe85R9YnoOL-pzg@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zxe85R9YnoOL-pzg@orbyte.nwl.cc>
X-Spam-Score: -1.9 (-)

On Tue, Oct 22, 2024 at 04:55:33PM +0200, Phil Sutter wrote:
> On Tue, Oct 22, 2024 at 03:48:12PM +0200, Pablo Neira Ayuso wrote:
> > On Tue, Oct 22, 2024 at 03:08:01PM +0200, Phil Sutter wrote:
> > > On Tue, Oct 22, 2024 at 02:30:58PM +0200, Phil Sutter wrote:
> > > [...]
> > > > - With your patch applied, 20 rules fail (in both variants). Is this
> > > >   expected or a bug on my side?
> > > 
> > > OK, so most failures are caused by my test kernel not having
> > > CONFIG_IP_VS_IPV6 enabled.
> > > 
> > > Apart from that, there is a minor bug in introduced libip6t_recent.t in
> > > that it undoes commit d859b91e6f3ed ("extensions: recent: New kernels
> > > support 999 hits") by accident. More interesting though, it's reported
> > > twice, once for fast mode and once for normal mode. I'll see how I can
> > > turn off error reporting in fast mode, failing tests are repeated
> > > anyway.
> > 
> > Would you point me to the relevant line in the libip6t_recent.t?
> 
> It is in line 7, I had changed the supposed-to-fail --hitcount value of
> 999 to 65536.

This was already fixed in v2, correct?

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20241021101442.182533-1-pablo@netfilter.org/

I am using 65536 there.

Thanks.
