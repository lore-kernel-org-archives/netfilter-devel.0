Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7DE28370
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 15:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728747772; cv=none; b=nxL5t/hlcEsjLffwN+lt7jA4ZikKAM17qrVZhnXpqU+eHWHDsdrj5/kBwhBGmX8wV/So7IaFuHbSOXZD+mKzhWX59BADUbLkpxQkUpGqiypO8phymmGQx2mbR7uCm7acBoTb7npN9eK5jztKWsfrc1hHs+nd+p1c7vLfdfM13I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728747772; c=relaxed/simple;
	bh=2ct4y/1gwlOlJx6nOUKP7qbg7uN50GZNAF2syVGoAwM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q42f5eXlPKUgFkyl/bzqn29VjX+x498hiInyNHq9UFmgsBx6FhL7+0XZ7D8JdR5nGIG8ulxPYfwd5Ok50QMM7WuR/exvhfD0NIcDibKvsClFbDIzqV72Sed4beiyYFN/4mkJAQhU/HCDPn+/Eyaf199kk5jnmhGW1Qrd2twggzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=40572 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1szeGQ-001Tk7-MT; Sat, 12 Oct 2024 17:42:44 +0200
Date: Sat, 12 Oct 2024 17:42:41 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/4] netfilter: use skb_drop_reason in more places
Message-ID: <ZwqY8Rm74MO_UMM8@calendula>
References: <20241002155550.15016-1-fw@strlen.de>
 <ZwqDI5JcQi5fMa46@calendula>
 <20241012144216.GA21920@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241012144216.GA21920@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Sat, Oct 12, 2024 at 04:42:16PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > One question regarding this series.
> > 
> > Most spots still rely on EPERM which is the default reason for
> > NF_DROP.
> 
> core converts NF_DROP to EPERM if no errno value is set, correct.
> 
> > I wonder if it is worth updating all these spots to use NF_DROP_REASON
> > with EPERM. I think patchset becomes smaller if it is only used to
> > provide a better reason than EPERM.
> 
> I'm not following, sorry.  What do you mean?
> 
> This is not about errno.  NF_DROP_REASON() calls kfree_skb, so tooling
> can show location other than nf_hook_slow().

Right.

> Or do you mean using a different macro that always sets EPERM?

Maybe remove SKB_DROP_REASON_NETFILTER_DROP from macro, so line is
shorter?

        NF_DROP_REASON(pkt->skb, -EPERM)

And add a new macro for br_netfilter NF_BR_DROP_REASON which does not
always sets SKB_DROP_REASON_NETFILTER_DROP? (Pick a better name for
this new macro if you like).

Or you think the existing generic long version of NF_DROP_REASON is
convenient to have?

Thanks
