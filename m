Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D104D32779B;
	Mon,  8 Dec 2025 14:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765203517; cv=none; b=bmXHK9LntenSc/tbv5QF7Lup/D48l8ul9Od0LoUNfr+1omfFbTFPRaFQ/6MiStGbW/diBm75FaGYsQGwge8BcCXH2xlmo3zQQNGO/BklTaczHID6JgWH5PlJyF7p4ONrkLOXKa8ir2skFvjHcS5GcUNb07qZknNuSUgIpdwptxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765203517; c=relaxed/simple;
	bh=Tpuwk1EFfBITZ6qj3PNAEkRsP9TW2v7YW7jUqA6Sonk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YSdF1S1mDsJIRxHYQExtMdnzWMpWTg109TWglO/TYkc3SCzAZhMRJzL2sROBuZ1oI0d/2vrU2PYnS7k6bdUpUUD6SoQwFsqsz1PQGC+deAEiNM2Adamuw5x1Vb7Ej/h1/I2XBT+JN+2DGtFMr4SZizzdXokd3u69d+Q9ZTXYzfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 18B5260336; Mon, 08 Dec 2025 15:18:26 +0100 (CET)
Date: Mon, 8 Dec 2025 15:18:25 +0100
From: Florian Westphal <fw@strlen.de>
To: Nick Wood <nwood@cloudflare.com>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>,
	netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>, netdev@vger.kernel.org,
	phil@nwl.cc, Eric Dumazet <eric.dumazet@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	kernel-team@cloudflare.com, mfleming@cloudflare.com,
	matt@readmodwrite.com, aforster@cloudflare.com
Subject: Re: [PATCH nf-next RFC 1/3] xt_statistic: taking GRO/GSO into
 account for nth-match
Message-ID: <aTbeKpBL0qVtjyY-@strlen.de>
References: <176424680115.194326.6611149743733067162.stgit@firesoul>
 <176424683595.194326.16910514346485415528.stgit@firesoul>
 <aShi608hEPxDLvsr@strlen.de>
 <c38966ab-4a3c-4a72-a3c1-5c0301408609@kernel.org>
 <CACrpuLQGj70xCi8wDH4HeKzkA=d-9+eOYkkQ47M2Tw8MA65kzQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACrpuLQGj70xCi8wDH4HeKzkA=d-9+eOYkkQ47M2Tw8MA65kzQ@mail.gmail.com>

Nick Wood <nwood@cloudflare.com> wrote:
> > It was easier to change the nth code (and easier for me to reason about)
> > than dealing with converting the the formula to use an integer
> > approximation (given we don't have floating point calc in kernel).
> 
> with s = integer sample rate (i.e s=100 if we're sampling 1/100)
> and n = nr_packets:
> 
> sample_threshold = [ 2**32 //s //s ] * [n*(s - (n-1))] ;
> 
> if get_random_u32 < sample_threshold {
>     sample_single_subpacket
> }*

Thanks for clarifying.  But we can't do that within the limitations
imposed by the netfilter framework.

We can only flag the entire skb/aggregate as either matching or not
matching.  We can't signal a 'match this subpacket'.

While we could split the aggregate within the conditional, we can't
(re)inject splitted packets back into the processing pipeline.

If there is a way, I can't think of anything.  At least not without
major rework of the entire netfilter stack :-|
