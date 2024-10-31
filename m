Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BB319D08A
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2024 15:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730387791; cv=none; b=TdvILaJK2AKA5UGGCbzt5ZZIz8ZCTWc/7BjQ1yp85ukAFvdobzg1hE4GjosfQGczQNaVN96Y2uouA01bTm6sz/5j3eBGrSonVlXXkuMdsyAxW119C76E7eyTjuuDhU2rZBctXRJrW6jpovPfWRH+02t63aQh3UZc3M4uGFLOCFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730387791; c=relaxed/simple;
	bh=l+a1oukgh8QfxDDGf/Yr9GsLeg/mm3MXalzA/PWeMgI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dnIL36x1FJu1Va2FuQbycSfiQ7C08NR3PKMvE4lOjCyoH6/TPG/T9d3ul+atfKFPpger2Av5QDXqdjQ6fsSM1k6+yhgdNRcvYxBKRCrhOvnXlrHtRwmnTObsW9DgjmMbgd95Nrup6CaNb9Ncx+QO2amCyHmNsZs5j6/wTUtHWn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=JzCLXtBw; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="JzCLXtBw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=odZMHfzqjIIklZQzSYRvdp7hbMDuZK5ji+XIjIQK15g=; b=JzCLXtBw/TWzU9PPLFQzmjUHxG
	W1LNZdzqrGkngQDB9RB0F6+ZGZZCb+TQ9jXzaPlpu1w07hy9uMEMXAfUtIm8sSrq2Dv07tPzfOHz5
	122yQGTnBHb8JcoKJBVwW1+llH0pGAZeeVnziB06Q8CImpWIvQTxbii5tIu5DGOmkeZP4zphC1Wdd
	gyN1jiR8U+1LOzDKdFovkLZFp5ejZAHVreKFdsQ3bBtNrNypkmsF29t6sZSL/RlDW6ZIeo7F858yK
	jmEmef6zLO45Hm6VDzCpcMCKospZ7hzwclCZ22OFw4VIy8yqX5jtZXl/jsu9/UZW0OFvSpZZDWgD/
	JkarwHqg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t6WuR-000000002Bp-06Di;
	Thu, 31 Oct 2024 16:16:27 +0100
Date: Thu, 31 Oct 2024 16:16:26 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v3 06/16] netfilter: nf_tables: Tolerate chains
 with no remaining hooks
Message-ID: <ZyOfSncM-phz6SFm@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
References: <20240912122148.12159-1-phil@nwl.cc>
 <20240912122148.12159-7-phil@nwl.cc>
 <20241031140104.GA21912@breakpoint.cc>
 <ZyOR-X0c6ToIR90y@orbyte.nwl.cc>
 <20241031143736.GA25657@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241031143736.GA25657@breakpoint.cc>

On Thu, Oct 31, 2024 at 03:37:36PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > AFAIR, we did just that in the past with such cases. I agree, it pretty
> > much breaks any efforts at making the testsuite usable with stable
> > kernels.
> > 
> > > Should the dump files be removed?
> > 
> > Maybe "feature flag" it and introduce a mechanism for test cases to
> > revert to a different dump file?
> 
> What could be good enough:
> 1. fix dump files
> 2. add feature flag, if feature not present -> exit 77/skip to elide
> dump compare.

Reasonably simple to provide backwards compat (and still keeping the
actual test active)!

> Would you explore this?

Will do!

Thanks, Phil
