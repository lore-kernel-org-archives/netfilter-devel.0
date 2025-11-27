Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBDC21770B;
	Thu, 27 Nov 2025 14:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764254886; cv=none; b=JU2Jy0RPf+WY+tkCr4Z915og4L62G+GGd2oohw2nBP8MENe9ZdpJMdPvBaYeeZs5bPaKvF4c/OJ4QZXpAC55UjJyVXzvGlaCVIUEb9ajY+S0JWnX2kIzGipGS43XDBO6oPicH1t6HChLNs20vwmvVmiZBYoHteBGZHYaxIYIsHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764254886; c=relaxed/simple;
	bh=EUMWaDISOZ4CjfRBtOiLmH8DsNlWAlIEETN9pBgNAcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a6gTvXdpDEf0KxeE8IoEJ5o+crcKvmm1mv1ZGWNfxqvm7ei6FwCAM07GCjy0P2k3UJoCYCbMVdrl9o9b6XfDDi1TOvr8TOfwzEFi+tjl6iYB6crNJuY4QMStS7MXy4wm2GeOwDjmR831vn0V13tR/9X0etT0HKhMGZhoXQ+7whY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 88BBB60466; Thu, 27 Nov 2025 15:48:02 +0100 (CET)
Date: Thu, 27 Nov 2025 15:48:02 +0100
From: Florian Westphal <fw@strlen.de>
To: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>, netdev@vger.kernel.org,
	phil@nwl.cc, Eric Dumazet <eric.dumazet@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	kernel-team@cloudflare.com, mfleming@cloudflare.com,
	matt@readmodwrite.com
Subject: Re: [PATCH nf-next RFC 2/3] xt_statistic: do nth-mode accounting per
 CPU
Message-ID: <aShkog5k8nsD5YsA@strlen.de>
References: <176424680115.194326.6611149743733067162.stgit@firesoul>
 <176424684236.194326.12739516403715190883.stgit@firesoul>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176424684236.194326.12739516403715190883.stgit@firesoul>

Jesper Dangaard Brouer <hawk@kernel.org> wrote:
> The atomic cmpxchg operations for the nth-mode matching is a scaling
> concern, on our production servers with 192 CPUs. The iptables rules that
> does sampling of every 10000 packets exists on INPUT and OUTPUT chains.
> Thus, these nth-counter rules are hit for every packets on the system with
> high concurrency.
 
> Our use-case is statistical sampling, where we don't need an accurate packet
> across all CPUs in the system. Thus, we implement per-CPU counters for the
> nth-mode match.
> 
> This replaces the XT_STATISTIC_MODE_NTH, to avoid having to change userspace
> tooling. We keep and move atomic variant under XT_STATISTIC_MODE_NTH_ATOMIC
> mode, which userspace can easily be extended to leverage if this is
> necessary.

This patch seems acceptable to me (aside from the deliberate userspace
breakage).

But I do wonder why you can't move to random sampling instead, it
doesn't suffer from this problem (i.e. -m statistic --mode random).

I think a non-rfc version would have to add a new mode, plus the
userspace change, and an explanation why -m random can't be used,
esp.  because the changelog above implies to me that -m random would work
for this :-)
