Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F0919D881
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Oct 2024 13:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729602364; cv=none; b=DCaJqO0cMMCzzsz10BQUx12gkrvHZjaW3vLZgg47EgfbOIYCJMqv4HZWESEeqoDaSZPDtG886PYne/+h1fsPyzkQWSCl9/Qs9ncT+FMcIHEzNhAC95/w/GHcs2Kfm71GelI1Y8rLxTtgCtkJzpdMiFaa068BPVnxXg/5gFnk6Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729602364; c=relaxed/simple;
	bh=p3PdcNJvzccJvIGPkbhHqVNBSa2yyT2HQySGHC0uqzY=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JAHAICiKx8MuLN1u4TOSnjzVykHNofBaf1HJde0KUjTjtkRcpAqx/FwIZAiq29EBOxEjX8tz+mryUozW2vTa6Q4JJUmk2yoNADAFOct1pDn4dpvYIROvg1CJaZ5rv3Bo0s5JCedi+FtNg75PhsjxExO2QqbMhUCu6d/VGlaDfxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=37784 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t3EaD-00DlFl-TV; Tue, 22 Oct 2024 15:05:59 +0200
Date: Tue, 22 Oct 2024 15:05:57 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	fw@strlen.de
Subject: Re: [PATCH iptables] tests: iptables-test: extend coverage for
 ip6tables
Message-ID: <ZxejNVQd_5Iak34X@calendula>
References: <20241020224707.69249-1-pablo@netfilter.org>
 <ZxebAVfZ_aDSNeb4@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZxebAVfZ_aDSNeb4@orbyte.nwl.cc>
X-Spam-Score: -1.7 (-)

On Tue, Oct 22, 2024 at 02:30:57PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Mon, Oct 21, 2024 at 12:47:07AM +0200, Pablo Neira Ayuso wrote:
> > Update iptables-test.py to run libxt_*.t both for iptables and
> > ip6tables. This update requires changes in the existing tests.
> 
> Thanks for working on this! I see a few things we could still improve:
> 
> - Output prints libxt tests twice. Maybe append the command name?

OK, I can just make it print it once.

> - The copying of libxt into libipt and libip6t creates some redundancy
>   depending on test content. Maybe keep the non-specific ones in a libxt
>   test file?

I can take a look at what is common and keep it in libxt_ , I quickly
splitted and convert.

> - I noticed there are some remains of supporting '-4' and '-6' flags in
>   iptables-test.py but it is unused and seems broken. One could revive
>   it to keep everything in libxt files, prefixing the specific tests
>   accordingly. I'll give this a try to see how much work it is to
>   implement support for.

Not sure it is worth, but your call.

> - With your patch applied, 20 rules fail (in both variants). Is this
>   expected or a bug on my side?

Maybe you don't have the NFLOG, mark and TRACE fix that is missing?

I don't see this in v2 of this patch + kernel fix.
