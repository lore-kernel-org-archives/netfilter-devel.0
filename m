Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596053C4553;
	Fri, 29 May 2026 09:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780047669; cv=none; b=X/gQAylihvZyRWUfdnVWgzjIpAcwyCdNCajqIaBjWr1QTGf0FrR5Cdwf6ju2KEuqsmp3PGzWrukwGSH++WMRhxmN5MEwtTxaEddLRKt4OKCn7kY/Q7Fl9tinw4bpLxUCPOXOkHCYBKvNjaEgcSBJMqHYzK055tONMDd4E0wwEOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780047669; c=relaxed/simple;
	bh=ZE7mQZ+/lYPcr1yJKb4X+ZzCntOd453QoqYdTPWVtG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PzIXcUVOhnasBNfQoCkm59YtMPcYhKH+S0mcRDq0D1IgROsMT6eP/jx2ek6f5trfnIXLRvUgAReh8NHenR75koSvlNFPFzKauC+KXBfWJT3z8DrlraQpPDpLyesm5fXgMYPfUvI9FSDJg0aC8hfp8B2VKXy9dDFKF6b7Q3U9yho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0E2FE60595; Fri, 29 May 2026 11:40:58 +0200 (CEST)
Date: Fri, 29 May 2026 11:40:57 +0200
From: Florian Westphal <fw@strlen.de>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Qi Tang <tpluszz77@gmail.com>, netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>, davem@davemloft.net,
	kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
	netdev@vger.kernel.org, dsahern@kernel.org, idosch@nvidia.com,
	horms@kernel.org, lyutoon@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH net] ipv4: validate ip_forward_options() option fields
 against skb tail
Message-ID: <ahlfI38aDciPfG2S@strlen.de>
References: <b1447f76-0ca4-49b1-a1ba-2670dbbe5eea@linux.dev>
 <20260528163226.573363-1-tpluszz77@gmail.com>
 <83d1be8a-34fd-4ebe-860f-5e026b554c74@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83d1be8a-34fd-4ebe-860f-5e026b554c74@linux.dev>

Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
> > VXLAN was just convenient. Other paths likely work too: any encap that pushes
> > the options deeper, or a smaller head like you suggested. Pre-6.3 without
> > skb_small_head_cache a plain forwarded packet already has end=192. I can send
> > the PoC off-list if you want to repro.
> >
> > Thanks,
> > Qi
> 
> 
> An alternative would be to re-validate the options by calling 
> __ip_options_compile()
> for writes targeting NFT_PAYLOAD_NETWORK_HEADER. Let's wait for the 
> netfilter maintainers' opinion.

I'm not sure netfilter is the only facility that can munge data this
way nowadays.  The plan is to disable arbitrary network header rewrites:

https://lore.kernel.org/netfilter-devel/20260527121147.22076-1-fw@strlen.de/
