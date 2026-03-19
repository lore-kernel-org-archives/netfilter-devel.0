Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566923ACA65
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Mar 2026 21:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773954515; cv=none; b=QTufFxSJ34y+uxiYOCkwUMsPPHScZoXW1hlo7GzYc/PjwLfKGXWzxGlRzfQBUnfO4J5p02q5b1DYZK5yLPmQzNzkHrhCWI/XJb8cKRydyuqPtVYNk97804dY2E9aWG7RLXTs8Gjl0ZN0rLxnb9EXt2dnD8qBEQyYfNx+w2kIDTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773954515; c=relaxed/simple;
	bh=/WCTp6Fgbmo4e2gffdfxxqH8Y7xIiQ2NBgCyikKw8t4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K6DMe4eBC0Ers3DyVg1USuTsZ2jVvvmZgenj2ezU3MhyhphYs7hWjKVziRd4ZlISHfYOBaDHcqFA6OBnfSEiBhfk37e1xl8VnMVBaCpNA2mX386kCkrzuz828U0NZHOmXLVMs7gNkcJW/7S2UPkZdB3vsA5x5b3CHe0QyIVOf6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Q/+aAjDF; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Q/+aAjDF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9PqFux5G6jNgr7vVHbX/ovQ8JkxOEVzELUkqs/aktBs=; b=Q/+aAjDFEcrlCc/pYiDm031en+
	HF9b8vGNifjfrCqMpa+GjhKFZVi7YMmjp21ZUH/seiNBgAzvKbyhIYlnuVaH2KGzqy4TKne/UAkHz
	aMW2M7kcLFiAJZ7p03OQQiuOadbxXsJK57NEKSjrUw8hP5/YtoS4IGmidHpPk28RMxsNAUoSerBfs
	nL8C2PPz9ANSHJztwXWnH40LS7xR+dCa2bsqUXQZpo4c5v39WcsaIjA8HHCy3vAsXdbY+mZhd66RK
	5RVuriyEm8dAzv0E+8aMhtvWN+5dyf2Jsd8DY3HoRWkh0gPboCeUaZdkDhUan3eAQRUEIKAtn9w9T
	k8KLbwSA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w3KbW-000000003Df-2cDO;
	Thu, 19 Mar 2026 22:08:30 +0100
Date: Thu, 19 Mar 2026 22:08:30 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH] netfilter: nfnetlink_hook: Dump nat type chains
Message-ID: <abxlzn7lymOxWUFa@orbyte.nwl.cc>
References: <20260313153220.19662-1-phil@nwl.cc>
 <abwegj2TijkaQVLz@strlen.de>
 <abwraHUuxizN4krg@orbyte.nwl.cc>
 <abwtAkSF8-SmH684@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abwtAkSF8-SmH684@strlen.de>

On Thu, Mar 19, 2026 at 06:06:10PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Ah, so the nat-type chain's priority value orders it inside the
> > dispatcher's list.
> 
> Yes.
> 
> > Maybe I should print them below the dispatcher hook with extra
> > indentation? Maybe extra braces could further clarify, e.g.:
> > 
> > | hook postrouting {
> > |         +0000000100 nf_nat_ipv6_out [nf_nat] {
> > |                 +0000200000 chain inet nat postrouting [nft_chain_nat]
> > |         }
> > |         +2147483647 nf_confirm [nf_conntrack]
> > | }
> 
> Actually  one could override the hook value with the one of the
> nat base hook.  The ordering inside the dispatcher is whats important,
> the exact numerical value isn't important.

Hmm. I like how one can use 'list hooks' output to find a good spot for
a new base chain. The real nat chain priority value is needed for that,
but no point in considering made up use-cases. Seeing the chains
attached to a given nat dispatcher is already a step forward, and having
their ordering is probably well enough.

> > > If we really want the ability to list the nat hooks, I think this
> > > needs a new command to dump them.
> > 
> > We may change 'nft list hooks' output arbitrarily, right? Or should we
> > fear braking some third-party parsers when doing too fancy stuff?
> 
> Ugh. No mercy for screenscrapers.  But maybe my suggestion above is
> enough.

ACK, I'll prepare a v2.

Thanks, Phil
