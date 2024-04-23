Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F063EA76;
	Tue, 23 Apr 2024 19:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713901355; cv=none; b=kBIyGMGcL3mOfn+tJOf2hDzPVV64k30cKSrz2hS5/BuCJDVLl+eaLMAIleAZ+dIHad8HG6J8kjmkKygHPY7HBWCf8oCuofoXLLzbsQkq08hTIrA0fcslkZraGshHh3q+S46jL5O4cHWLtN8+AWH0f8S5NA2ZdhDForjosvBonm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713901355; c=relaxed/simple;
	bh=cry/RH2rKuH1HbgXRSzotD72z8BzbveBjDuTfED9nTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gSlS4V9Qs/gFRKNIpK6Fvla6lQH3BCzY6W5cY42Czv2qMTUt37MK59yX0lX5KQYZ/tJH0PM58c3Q65d8CExanpRIdn0mqIfmZDd3R+FPAj7+dL81h/DMvluCgMiZYmDc0X+Tg0Fp6+3NcwFEkH6MNiKHanonk7HTZBmqROcwdao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rzM21-00024O-1A; Tue, 23 Apr 2024 21:42:21 +0200
Date: Tue, 23 Apr 2024 21:42:21 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH net-next 0/7] selftest: netfilter: additional cleanups
Message-ID: <20240423194221.GA6732@breakpoint.cc>
References: <20240423130604.7013-1-fw@strlen.de>
 <20240423095043.2f8d46fc@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240423095043.2f8d46fc@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue, 23 Apr 2024 15:05:43 +0200 Florian Westphal wrote:
> > This is the last planned series of the netfilter-selftest-move.
> > It contains cleanups (and speedups) and a few small updates to
> > scripts to improve error/skip reporting.
> > 
> > I intend to route future changes, if any, via nf(-next) trees
> > now that the 'massive code churn' phase is over.
> 
> Got it.
> 
> The main thing that seems to be popping up in the netdev runner is:
> 
> # TEST: performance
> #   net,port                                                      [SKIP]
> #   perf not supported
> 
> What is "perf" in this case? Some NFT module? the perf tool is
> installed, AFAICT..

Its looking for the pktgen wrapper script
(pktgen_bench_xmit_mode_netif_receive.sh).

I don't think it makes too much sense to have that run as part of the CI.

I can either remove this or move it under some special commandline
option, or I can look into this and see if I can get it to run.

Let me know, thanks.
