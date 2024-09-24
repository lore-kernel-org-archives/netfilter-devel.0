Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EB88C1A
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Sep 2024 19:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727205099; cv=none; b=lUU2YFJH2ffIOI+1N9kzyPuJhFolFaBsWHcPMOH4aC2G/rN5Ls08VCJrYe/Qw7dB8dHbvGRa0+xusZl7nPDzFoS0c2xTSbeq1+4nLZHEpVvEKtzT5KnUyWMtomGqpIW3Y3vRsLe1Z29nTmrbZmllSw7c2YgQI2ZXQw+eioFFOqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727205099; c=relaxed/simple;
	bh=Q454jC6+2X3nV1z1KQ5LRsNC6aWXSvg8M3pc1tw4Wb0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IhJ5IctWEiISjzL73Iw44inNQaERadOVyTXipJma5/GN7HhseJT1Vy/z7CsYBBixNvk/Ek+LBetXg6arHZsMm77egHzctEr+L6G2nSj2+Mx0gWFyYITzuGLBI0LW/cxM8giBUX0UVMuKeKRNKf7c65os7qGRBpKpnSSebs03Rdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1stAwY-0004bh-T4; Tue, 24 Sep 2024 21:11:26 +0200
Date: Tue, 24 Sep 2024 21:11:26 +0200
From: Florian Westphal <fw@strlen.de>
To: Chris Mi <cmi@nvidia.com>
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Ali Abdallah <aabdallah@suse.de>, netfilter-devel@vger.kernel.org
Subject: Re: ct hardware offload ignores RST packet
Message-ID: <20240924191126.GA17409@breakpoint.cc>
References: <704c2c3e-6760-4231-8ac8-ad7da41946d9@nvidia.com>
 <20240923100346.GA27491@breakpoint.cc>
 <5edeab2c-2d36-4cef-b005-bf98a496db2c@nvidia.com>
 <20240923165115.GA9034@breakpoint.cc>
 <e12cd5f8-574c-4405-9e92-c1fac54053c6@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e12cd5f8-574c-4405-9e92-c1fac54053c6@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Chris Mi <cmi@nvidia.com> wrote:
> > If so, what is the exact expectation?
> > 
> > Could you propose a patch? As I said, I dislike tying this to sysctls.
> 
> Sure. I will add more debug log to understand the function
> nf_tcp_handle_invalid() and propose a patch.

Thanks!  Earlier this year I had a look at conntrack <-> flowtable
plumbing and found multiple issues.  Not sure they are related, I am
recovering the patches that I made back then and will post them asap
after they cleared basic testing.

I'll place you on CC.
