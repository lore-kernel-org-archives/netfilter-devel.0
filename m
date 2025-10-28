Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA716343D91
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 17:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761671212; cv=none; b=btGZRu97TvUL66GRkc9Itko03lWgcMGT0UfKpsGTSv2a+z95LlHPmLtb7DjNljV8e3NddzD7np3p8Id6gLpkwO5HiV/0SrMNGsiB8tjeeMlSfvh7lsfP0jUgn4adwHEpi6LLsjOKiK6XoLMpashlkaIeojIhmFO+F0jzNXzvJE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761671212; c=relaxed/simple;
	bh=Z1MKnKyfFfAgUu1GhLTBmo4ZKzXU5dsRBT5dY/2JPPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pSjACAgYDcxWedMfyVmuR+slkmoQNPCqhZjs5W33G/FUvmJcC5l4firFSJk13wGe5+hsQ/PcS8Y/Hswmtbfy/+DZjchN6WNI7HL9UEYhradAneTTftUzRTznbd0T2peSvexyK7na7vh457foaSieSqmsX7MCwwX0HYZHf1V+g0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E9C1661A31; Tue, 28 Oct 2025 18:06:47 +0100 (CET)
Date: Tue, 28 Oct 2025 18:06:47 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	louis.t42@caramail.com
Subject: Re: [PATCH nf] netfilter: nft_connlimit: fix duplicated tracking of
 a connection
Message-ID: <aQD4J7pI-Fz1V3eC@strlen.de>
References: <20251027125730.3864-1-fmancera@suse.de>
 <aQD2R1fQSJtMmTJc@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQD2R1fQSJtMmTJc@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > -	if (nf_conncount_add(nft_net(pkt), priv->list, tuple_ptr, zone)) {
> > -		regs->verdict.code = NF_DROP;
> > -		return;
> > +	if (ctinfo == IP_CT_NEW) {
> 
> Quick question: Is this good enough to deal with retransmitted packets
> while in NEW state?

Good point, I did not consider retransmit case.
What about if (!nf_ct_is_confirmed(ct)) { ..?

Would need a small comment that this is there instead of NEW
check due to rexmit.

> > +		if (nf_conncount_add(nft_net(pkt), priv->list, tuple_ptr, zone)) {
> > +			regs->verdict.code = NF_DROP;
> > +			return;
> > +		}
> > +	} else {
> > +		local_bh_disable();
> > +		nf_conncount_gc_list(nft_net(pkt), priv->list);
> > +		local_bh_enable();
> >  	}

As this needs a respin anyway, what about removing the else
clause altogether?  Resp. what was the rationale for doing a gc call
here?

And, do we want same check in xt_connlimit?
