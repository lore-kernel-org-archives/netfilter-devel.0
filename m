Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EE7333452;
	Thu, 27 Nov 2025 14:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764254459; cv=none; b=JjRgFw+ikrUie9KqjMTioJ7dyX6mm3275/dyby1pveJlSPk4adTHqbNSXONyhb4l4Roo6HlhCvMKq+/LYd1XPCIRQ4IDPlrQAyof5+Y4LrLWeW7vRukTxGHAN+1kYKGiIJOFfK5Ikk8+MlQ5u/WUhgjP7fFQKiNyWbqcS4tl1cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764254459; c=relaxed/simple;
	bh=qZzsDmEgedYYyU8FMvZoUFy/0KNHgI1WTAosRLlSxKY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j3032F2UiqEYr0OIlV+35bxsWS+h1ZTw8kWswUITjHmpsTTiqMvDT3bfkMnrBwViIqjWsvfH1YfMPVwztd9NByNFQcY91jMZa+3BUhAjmHisXZGTIRk3eC21aDrdP6v4oclbv99+g5LaMV85/VF9gDYsrGnJl/cxTIbGGMaovnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2246760429; Thu, 27 Nov 2025 15:40:48 +0100 (CET)
Date: Thu, 27 Nov 2025 15:40:43 +0100
From: Florian Westphal <fw@strlen.de>
To: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>, netdev@vger.kernel.org,
	phil@nwl.cc, Eric Dumazet <eric.dumazet@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	kernel-team@cloudflare.com, mfleming@cloudflare.com,
	matt@readmodwrite.com
Subject: Re: [PATCH nf-next RFC 1/3] xt_statistic: taking GRO/GSO into
 account for nth-match
Message-ID: <aShi608hEPxDLvsr@strlen.de>
References: <176424680115.194326.6611149743733067162.stgit@firesoul>
 <176424683595.194326.16910514346485415528.stgit@firesoul>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176424683595.194326.16910514346485415528.stgit@firesoul>

Jesper Dangaard Brouer <hawk@kernel.org> wrote:
> The iptables statistic nth mode is documented to match one packet every nth
> packets. When packets gets GRO/GSO aggregated before traversing the statistic
> nth match, then they get accounted as a single packet.
> 
> This patch takes into account the number of packet frags a GRO/GSO packet
> contains for the xt_statistic match.

I doubt we can do this upstream.  Two reasons that come to mind, in no
particular order:

1. It introduces asymmetry.  All matches use "skb == packet" design.
   Examples that come to mind: xt_limit, xt_length.
2. This adds a compat issue with nftables:
    iptables-translate -A INPUT -m statistic --mode nth --packet 0  --every 10
    nft 'add rule ip filter INPUT numgen inc mod 10 0 counter'

'numgen' increments a counter for every skb, i.e. reg := i++;.
But, after this patch -m statistics doesn't work this way anymore
and the two rules no longer do the same thing.

But even if we'd ignore this or add a flag to control behavior, I don't
see how this could be implemented in nft.

And last but not least, I'm not sure the premise is correct.
Yes, when you think of 'packet sampling', then we don't 'match'
often enough for gro/gso case.

However, when doing '-m statistic ... -j LOG' (or whatever), then the
entire GSO superpacket is logged, i.e. several 'packets' got matched
at once.

So the existing algorithm works correctly even when considering
aggregation because on average the correct amount of segments gets
matched (logged).

With this proposed new algo, we can now match 100% of skbs / aggregated
segments, even for something like '--every 10'.  And that seems fishy to
me.

As far as I understood its only 'more correct' in your case because the
logging backend picks one individual segment out from the NFLOG'd
superpacket.

But if it would NOT do that, then you now sample (almost) all segments
seen on wire.  Did I misunderstand something here?
