Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76A91F171;
	Tue, 30 Apr 2024 13:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714484712; cv=none; b=ADHRK4pbNvoLDMAYpYWJ+KINtJK0vob52NTpGF1q4EQlU0oJeT5qVTRIkeXc7fsjkV/1lK6w6Gm0fguBIA7xfFwh9/ztgXU6jfHeFiOB69nSVZBwatAhxKlw0Eqjxz104BXeo+HwfSCoLHXtLIXM7FB25GQYenQU5r+EjBZctzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714484712; c=relaxed/simple;
	bh=SPO1QFKjaCksCzjKxRKzhIi9yY3bSkyC8ud8dmN1prA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jfjPgmN9L/IEdq2p+aUyeX0FaguGeCU1IPzLwJWjzMwi2unrP3xdyEYTvjcmlDw2xyz2Va5PqBpr6N/hPZJuare8TO3D/fUs+zh20tLG1puwzA/VtpGm+27fV8wI6qyrM7lc4p0GciYx245X/BnKK25wCCyqZMn2KZj3l6D6lXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1s1nmu-0003vn-Vi; Tue, 30 Apr 2024 15:44:52 +0200
Date: Tue, 30 Apr 2024 15:44:52 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH net-next 0/7] selftest: netfilter: additional cleanups
Message-ID: <20240430134452.GA11813@breakpoint.cc>
References: <20240423130604.7013-1-fw@strlen.de>
 <20240423095043.2f8d46fc@kernel.org>
 <20240423194221.GA6732@breakpoint.cc>
 <20240423135218.7f4af1b7@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240423135218.7f4af1b7@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue, 23 Apr 2024 21:42:21 +0200 Florian Westphal wrote:
> > > The main thing that seems to be popping up in the netdev runner is:
> > > 
> > > # TEST: performance
> > > #   net,port                                                      [SKIP]
> > > #   perf not supported
> > > 
> > > What is "perf" in this case? Some NFT module? the perf tool is
> > > installed, AFAICT..  
> > 
> > Its looking for the pktgen wrapper script
> > (pktgen_bench_xmit_mode_netif_receive.sh).
> > 
> > I don't think it makes too much sense to have that run as part of the CI.
> > 
> > I can either remove this or move it under some special commandline
> > option, or I can look into this and see if I can get it to run.

It runs for ~25m, so I'd say lets NOT have it run by default.

> Hm, never used it myself but it makes me think of the extended ksft
> vars:
> 
>  | TEST_PROGS_EXTENDED, TEST_GEN_PROGS_EXTENDED mean it is the
>  | executable which is not tested by default.
> 
> https://docs.kernel.org/dev-tools/kselftest.html?highlight=test_progs_extended#contributing-new-tests-details

Thanks, I'll add a small wrapper via TEST_PROGS_EXTENDED so folks
can run the performance (pps match rate) manually.
