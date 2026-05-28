Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7F6305678
	for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 10:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779963859; cv=none; b=umApHmjHGQlxuFM33q3LHAfLlYrWypngo+M0WSqVW2V4+jPLwuN/+2aJA2vClrdLt/OgYm4SHWIrrjjpMFwjO11uN3iT98JQTmwwz3MyRjNpBjeUl7IkBQMVYEX30DQKZl+Cril20sM/ZpWzuzmkdrvDClLao7GWrEr2gB/uuB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779963859; c=relaxed/simple;
	bh=JUUXOKEnluzNPdrNs3GfHsu4VoW1A7teToJukAHh1P4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MxtFPxVN1b451NhSg+HfuSeVbvDcwY1hqEVVPKjTe3hoxTvcdim9jyorDFj+iODwPWutzgZ2JKHcd97Mz1LGhxargxnR4gmfR3JMpiIDttI3w9MiKO0WgXlb6/KdtU1iGvuzPuSHLOe7QxtsupyPF/ViGJjHSft0RlWCOx/RhX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CB4B760551; Thu, 28 May 2026 12:24:14 +0200 (CEST)
Date: Thu, 28 May 2026 12:24:14 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_ct: fix OOB in NFT_CT_SRC/DST eval
Message-ID: <ahgXzrLZx8J5NbVx@strlen.de>
References: <20260528042620.263828-1-jiayuan.chen@linux.dev>
 <ahfQGCNs8hl6FlHL@strlen.de>
 <ahfV6K6KrG0akLUZ@strlen.de>
 <88abc4d7-8316-4c9e-aca0-351fe0ecb2b0@linux.dev>
 <ahfqfM6xQKZr_xbA@strlen.de>
 <58fc5150-76e7-46e5-a72f-41133c408109@linux.dev>
 <ahf2XAmRnsjK0krp@strlen.de>
 <c1383a3a-6c76-411a-8ae3-1dfe90052fb7@linux.dev>
 <ahgLdDKloq01r7lK@strlen.de>
 <ahgS9K_8Q9AHhQ0K@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahgS9K_8Q9AHhQ0K@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, May 28, 2026 at 11:31:32AM +0200, Florian Westphal wrote:
> > Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
> >  type filter hook output priority -300; policy accept;
> >  ct zone set 1
> >  ct original saddr 0.0.0.0 counter accept
> > }
> > 
> > Then: ping -c 1 127.0.0.1
> > 
> > should the rule match the template or not?
> 
> I don't think so, no matching on the template conntrack.

Great, I will make a test case for nftables.
Jiayuan, would you send a v2  that fixes the OOB+register leak
and restricts template matching?

Thanks!
