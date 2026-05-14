Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA7D3E0739;
	Thu, 14 May 2026 13:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778766130; cv=none; b=VL6M4+N9dhZSDPLL5hopqukgdxvebTReoFhfmyGTQ72dVDw8M9sJw2jbm5+itLogyqMmysfgB1kOMUQW9awun+raF9iIm7smv5UhhMUEquX9xpxgjWAOpegVaQGwb5WBWwHhtw5a3TcW++SPzNp6AHKZII2ZAVeaBxiNV0ey3/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778766130; c=relaxed/simple;
	bh=8qOkthjctEjSF1Pf2LzH+O4vQuS3zhaX/ADeJ3YmaS8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mb0CCaylUOWJZA9B2XFoCAYmv+hTnkCvdGCMWoxUN4I9UhDRq4OP+mrEEz3u2pQGtxJ8VxU+T3rTeJgoxDazHiJnimhoP4Fv60UGGGKzDyKrsrbMpGfR/EN2Fp8UOfv8u+cY+y+lfK6fi6fDr419/tqv2GXBgiY7QNE13otYaJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C65776099C; Thu, 14 May 2026 15:42:04 +0200 (CEST)
Date: Thu, 14 May 2026 15:42:04 +0200
From: Florian Westphal <fw@strlen.de>
To: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Bart De Schuymer <bdschuym@pandora.be>,
	Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	bridge@lists.linux.dev
Subject: Re: [PATCH net v3] net: neigh: Reallocate headroom if necessary in
 neigh_hh_bridge()
Message-ID: <agXRLM6esULBG4al@strlen.de>
References: <20260513-nf-neigh_hh_bridge-fix-v3-1-8ec9353c0909@kernel.org>
 <20260514081403.GA482081@shredder>
 <agW6zjwDHB3dTiZC@lore-desk>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agW6zjwDHB3dTiZC@lore-desk>

Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > Personally I would use 'goto free_skb' after releasing the neighbour, to
> > be consistent with the other paths that free the packet.
> 
> ack, I do not have a strong opinion about it, but in this case we would need to
> even move "ret" since the current codebase always returns 0. What do you prefer?

I think It can return 0 unconditionally, there are no code paths in
that function where skb doesn't disappear (ownership change or freed),
and its prerouting so there is no use for an error code either.
