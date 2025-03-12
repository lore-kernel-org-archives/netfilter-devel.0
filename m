Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8011DE882
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 21:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741815515; cv=none; b=uX8gdpu0BV77Slcwhbdo+4wDTzfYhkAVBjqAzr9Niz0aBOaUI1I+k/TTKju5JFqziVinB6LuBT4NYvMk9iDXyKEmHpOwWbp7NNm+hhQdVIZ8WHVq+fuA+AgsPuU/BaJIQW8d1j6u97HQE7h+bfOtN1swz5q1W0h9h4O9puAyV9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741815515; c=relaxed/simple;
	bh=yXDQ/C5mkZ8oZ+VlQs7lBfsEqOh54Z0GxIlnPmrxO44=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GrMGd2EFx9ZX27aIWUroi6KO7RwyMmel3mTsbFd/C7svnNUNU/QWiUmsEzkUEQ7qYr2UpqPJEbICNPUAPrnJV2sDQaFCp+wlBnPF9GR3bJ6Jn60ui/2DQtMkwNt+JsafD263o38Ss+A1odadrwKdrKFUY1M3/NZ4fJP5IbSbv5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tsTmZ-0002fo-3E; Wed, 12 Mar 2025 22:38:31 +0100
Date: Wed, 12 Mar 2025 22:38:31 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: fib: avoid lookup if socket is
 available
Message-ID: <20250312213831.GB4233@breakpoint.cc>
References: <20250220130703.2043-1-fw@strlen.de>
 <Z9HdO_7XgQBbxcg1@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9HdO_7XgQBbxcg1@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > +	switch (nft_hook(pkt)) {
> > +	case NF_INET_PRE_ROUTING:
> > +	case NF_INET_INGRESS:
> 
> Not an issue in your patch itself, it seems nft_fib_validate() was
> never updated to support NF_INET_INGRESS.

Yes, probably better to do that in a different patch.

> > +	if (nft_fib_can_skip(pkt)) {
> > +		nft_fib_store_result(dest, priv, nft_in(pkt));
> > +		return;
> > +	}
> 
> Silly question: Does this optimization work for all cases?
> NFTA_FIB_F_MARK and NFTA_FIB_F_DADDR.

Its the socket that the skb will be delivered to, so I don't see
an issue.  Theoretically you could set a different mark in input,
but what is it good for? Its too late to change routing result.

As this sits in input hook, route lookup done by stack (not by fib
expr) already picked nft_in as the 'right' interface for this daddr.
