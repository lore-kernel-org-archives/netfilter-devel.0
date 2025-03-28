Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2AB1D63F9
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Mar 2025 15:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743176847; cv=none; b=K4qZpLICUXEL+nMPB5uzx35YeYJKfAX212BCjV5igq0H0mK8YuW7IBXKJ42YJm3H3OhMEr3whhSCnNXoAOqhgQFQwi3TrEXo/GnhpUV4hw3xkcATOmB4gVJDPNCMmZ0C4pIuFCzIfDCV+u01oL0Wgj3ahtF6lHB0sQ4N51DzkFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743176847; c=relaxed/simple;
	bh=qNVu5GMIF6uVa/8OEX8dWD9wnGTzB32W4ahwxdf0yjY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KaiQh8WmJ8HWnQuG8Pq1quWaOqqOlEodW2jWo6KFpslItT9ivgvECsLiTAClLTsoixKtSSawGb90OvBJBVuppxvz3WJfosuS6vA7GrJIGzzb3NTLa4h+89R+ffnnSwdG3yHXz7r/Nq0y3Vnxzg7Kt06KN9r4WNygSnf71s0YbG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=p58IcHIx; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="p58IcHIx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vcCeoV8l5YS681mmhb3+XQ25jJxDC2HxT6Zf+qZPA+w=; b=p58IcHIxT5A7SpvQ03xpcwODAM
	RVcSZxET6Bv4Q/eWIXkdXoDFSFgGLarQXn7ROM9aUO4n7RVHTTi56S7lcmT42GjKm31hGItSvjVPj
	KdcQ90yIXRs7hBjTQFhFKf37k9gAOeJ1Duh+UfL4th0OxFdEt+tcSLh+iPQKKavMJdpTz/StbGerM
	OeVsnMuOKmwHEpcDedJNSBpD/5NzAjcduouSN4paX3Idi2eaargXBVdz4flRwk9BtBoMKMh+vsoIt
	oQqMbL+sq0MYBwTC4PCW9Vzr+Fz7cS/Wk2T+xKwR2TEpysORQyi/nXqhfI1cloZotTLueUEd1Mvcl
	BsZuOmFQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tyBvW-000000000qb-0cMA;
	Fri, 28 Mar 2025 16:47:22 +0100
Date: Fri, 28 Mar 2025 16:47:22 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests: shell: Fix owner/0002-persist on aarch64
Message-ID: <Z-bEiib-Sn84y29V@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250328140921.15462-1-phil@nwl.cc>
 <20250328143345.GA27940@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250328143345.GA27940@breakpoint.cc>

On Fri, Mar 28, 2025 at 03:33:45PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Not sure if arch-specific, but for some reason src/nft wrapper script
> > would call src/.libs/lt-nft and thus the owner appeared as 'lt-nft'
> > instead of the expected 'nft'. Cover for that by extracting the expected
> > program name from /proc.
> 
> I've seen this as well before, thanks for investigating and fixing it.
> 
> Acked-by: Florian Westphal <fw@strlen.de>

Patch applied!
