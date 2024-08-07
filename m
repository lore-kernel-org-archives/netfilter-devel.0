Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D59513F42D
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Aug 2024 19:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723060299; cv=none; b=txCrmIF8qq97dDvJA5UgnzILDO58zS+EdzoEW7o7WrVckyF2hfvF2Raot6yNrXvkbIiuhDvp9OflpNFnykZ999k6qmWL4yqMb6LrRFvLaarEy47IlJf0ZcIWE+gd9taC7KbKzXxJcqZqtnwGC1lAcGasefAVZO9oVFGye/kYi8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723060299; c=relaxed/simple;
	bh=zNVIst9i1RGti9E5GVFEzjjJM5IdGSC4XcJVaL+Dx7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j9JhlcP9uiyF1shMaELYo4uumZ9ATpZ75gBI9OfiSKMkssFcnMsWS43sKkhwPQ6Kn4QRyof8+8UlWMyIkyzZTNXEXQLlw4lXO6fLf2TFNfunV9oHW4il6HTNJalbHrRzTPrJ2bzo3+ogyf2DUHwXdn5e8GNUmo+r/4mkOeF+nFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sbmh4-0007k4-Gj; Wed, 07 Aug 2024 21:51:34 +0200
Date: Wed, 7 Aug 2024 21:51:34 +0200
From: Florian Westphal <fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 2/2] selftests: netfilter: add test for
 br_netfilter+conntrack+queue combination
Message-ID: <20240807195134.GA29241@breakpoint.cc>
References: <20240807192848.28007-1-fw@strlen.de>
 <20240807192848.28007-3-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240807192848.28007-3-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

Florian Westphal <fw@strlen.de> wrote:
> Trigger cloned skbs leaving softirq protection.
> This triggers splat without the preceeding change
> ("netfilter: nf_queue: drop packets with cloned unconfirmed
>  conntracks"):
> 
> WARNING: at net/netfilter/nf_conntrack_core.c:1198 __nf_conntrack_confirm..
> 
> because local delivery and forwarding will race for confirmation.
> 
> Based on a reproducer script from Yi Chen.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  tools/testing/selftests/net/netfilter/lib.sh  | 16 +++++
>  .../selftests/net/netfilter/nft_queue.sh      | 16 -----

Those two files should be unchanged. I'll send a v2 of the
selftest script tomorrow.
