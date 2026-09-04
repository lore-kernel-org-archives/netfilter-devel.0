Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FCA51356A
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Sep 2026 17:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788543511; cv=none; b=glfCsj8PyOKNkYfoprSlEn3TMBfShZkwzpCWZSx6E0ZEgQZqkWP22ayhnjZ0K/5M45E7mDS8k39YzXHDJOB7M3RBXT6NsaHHo952hlD2ShPXWlWRuG8NKUAh387Amh4YGTbQQmqoeUpg42laAfoG1K2d8NEJhaRzhbs2IVGP4Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788543511; c=relaxed/simple;
	bh=IpWZ1D15SMQ1vIM2Wxdiyvz1D6uetO2JvxyBEOliDow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k9J8L0KZddtQTuih8X4iTKZAlOWABj9rO9Wt7e5CgolwJDvXs6Fob2ctiacfoPbZFoeqEWk88yJJiSQv/pLvASXU/NoSCXwxDK9DtHLpy60PmHNksnS4qzGADrsYUGJYRSkdNJM1i2YdAP+22lVgAwGEczNN7iL1krqodnlhiJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id ED7576032B; Fri, 04 Sep 2026 19:38:25 +0200 (CEST)
Date: Fri, 4 Sep 2026 19:38:24 +0200
From: Florian Westphal <fw@strlen.de>
To: Ren Wei <weir@nebusec.ai>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc,
	vega@nebusec.ai, rakukuip@gmail.com
Subject: Re: [PATCH nf 0/1] netfilter: ip6t_rt: fix zero-address non-strict
 match out-of-bounds read
Message-ID: <apsCEFQCajln3DBo@strlen.de>
References: <cover.1788337633.git.rakukuip@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1788337633.git.rakukuip@gmail.com>

Ren Wei <weir@nebusec.ai> wrote:
> In net/ipv6/netfilter/ip6t_rt.c, rt_mt6_check() permits rules to be configured with rtinfo->addrnr == 0.
> When evaluating IPv6 packets with IP6T_RT_FST_NSTRICT (non-strict routing match), rt_mt6() iterates over the packet's routing addresses and compares each candidate address with rtinfo->addrs[i] before checking whether i has reached addrnr:
> 
>     if (ipv6_addr_equal(ap, &rtinfo->addrs[i])) {
>         i++;
>     }
>     if (i == rtinfo->addrnr)
>         break;

Please send a v2 that also puts a stop to this backwards loop
termination.
