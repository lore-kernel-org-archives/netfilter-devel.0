Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC10B19D092;
	Mon,  8 Dec 2025 14:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765205183; cv=none; b=ABjFErjm7wknswOACeT0143sOxrzdn9N6FLgGBQrpDxVl+tjsYx8iwImRhASIiBy2MsRbvYyI+izZtxjnI8TYDOvVbumyqwWdca2IPkG9Iet4g1nsEXeZlnu35F7SRmn9PHabaY4rH+KJLt8OY1JDLbwNomrqqPRmF745xBCeo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765205183; c=relaxed/simple;
	bh=KejMhTn1AaeL3RzdmUwKZ3OaDXqSGv5CVFbFMAsC+4I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ioIcy7JfFvaPoHyi/d6MwcQ9M1rUhgCo8GylraJQP5F4vZO7zQ/GRNosKRAQ3PnVZjNX5adGPwofEOuDz6WxtnwBtpBCasydRK3Q1ZLwR4r9WOxFdSKTkaj8wTyWh/aaXHeEgRo+LfU0wz4i8V8GG6pkWAfw01ZK4PGqKxlDk+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E85A860336; Mon, 08 Dec 2025 15:46:18 +0100 (CET)
Date: Mon, 8 Dec 2025 15:46:13 +0100
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
Message-ID: <aTbktQxxH5gUJrB6@strlen.de>
References: <176424680115.194326.6611149743733067162.stgit@firesoul>
 <176424684236.194326.12739516403715190883.stgit@firesoul>
 <aShkog5k8nsD5YsA@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aShkog5k8nsD5YsA@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> Jesper Dangaard Brouer <hawk@kernel.org> wrote:
> > The atomic cmpxchg operations for the nth-mode matching is a scaling
> > concern, on our production servers with 192 CPUs. The iptables rules that
> > does sampling of every 10000 packets exists on INPUT and OUTPUT chains.
> > Thus, these nth-counter rules are hit for every packets on the system with
> > high concurrency.
>  
> > Our use-case is statistical sampling, where we don't need an accurate packet
> > across all CPUs in the system. Thus, we implement per-CPU counters for the
> > nth-mode match.
> > 
> > This replaces the XT_STATISTIC_MODE_NTH, to avoid having to change userspace
> > tooling. We keep and move atomic variant under XT_STATISTIC_MODE_NTH_ATOMIC
> > mode, which userspace can easily be extended to leverage if this is
> > necessary.
> 
> This patch seems acceptable to me (aside from the deliberate userspace
> breakage).
> 
> But I do wonder why you can't move to random sampling instead, it
> doesn't suffer from this problem (i.e. -m statistic --mode random).

Addendum, did not think of this before.  Another alternative is to
prefix '-m statistic' with '-m cpu' so only one core will do the
sampling.  If this should be done on all cpus then xtables
framework would require n rules for n cpus which scales poorly.

In nftables one could use verdict map with 'meta cpu' as a hash key,
then one would be able to fanout based on processing cpu.
