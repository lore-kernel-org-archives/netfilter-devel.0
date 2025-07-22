Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33F215530C
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Jul 2025 23:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753227118; cv=none; b=BCwEW1YF4jopVc0MYgdp8UlAxjlhuRrOR3lGpx9hzPFmABvLsWloRVyaJCeFKVRFN07UTxucz+VVjBBR1zq9cHA6nOnOOS5o4WDGhhISu2zTD1MEgSDEvQoeLGxHJu8H9Kp8wfYRGw77xgOfjGM4iJnXvsdDsr7RtPG6h/KxeUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753227118; c=relaxed/simple;
	bh=ioAfbUXnAVY7kzIhTZU5A1IMop8wKjnHS/yEGXA4Ef0=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fOE5fQdiKGCft+nTVwTdWRqfkdC6KVPoMU2u+L8XTJG7bj+MJraJGovOI5d8migl/IsSDQ3yE1VkeZaRnbHHZ4KK3swTcHCj6v31PN4drh9D6uLFXPw6Qi8usCLowBELfCuQRACAFbJpl7Xvgn7qqPfxGKk+Cik8vIgZpJjCamE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 781486048A; Wed, 23 Jul 2025 01:31:53 +0200 (CEST)
Date: Wed, 23 Jul 2025 01:31:53 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
	shankerwangmiao@gmail.com, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables v2] extensions: libebt_redirect: prevent
 translation
Message-ID: <aIAfaY4aZhAUhuXN@strlen.de>
References: <20250717-xlat-ebt-redir-v2-1-74fe39757369@gmail.com>
 <aHjmETYGg4UtDdSf@lemonverbena>
 <aHjrV-YUot_fKToY@orbyte.nwl.cc>
 <aHu4moCviA27DpXO@strlen.de>
 <aH9M6kWerwHmVvGP@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aH9M6kWerwHmVvGP@orbyte.nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> > > calling 'redirect' verdict will manipulate the IP header as well which
> > > we don't want
> > 
> > Can you point me to the code that alters the IP header?  I can't find
> > anything.
> 
> I guess this is a misunderstanding, but continuing along the lines:
> xt_REDIRECT.ko calls nf_nat_redirect() for incoming packets passing the
> incoming interface's IP address as 'newdst' parameter. I assume
> conntrack then executes, no?

Hmmm, I was referring to ebt_redirect, not xt/nft redirect.
Whats the concern here?

inet redirect should be fully functional, if thats wanted, for skbs
passed to bridge local in via ebt_redirect (or nft bridge family
with mac dest rewritten to a local address + altered packet type).

At least I don't see why it would not work.
