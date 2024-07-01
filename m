Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1370917BBB
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Jul 2024 22:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719872213; cv=none; b=MOoJ75AgwlBDrifR8OAemvmwlyZzz7s61Rs55r99IbEhuhcJawK3ovSrDn3OcYzMLhRv1/X64YfPJu4MWSfxMDZQ2TYBqo4zbZdwM0O4AjA2OAoPx74LV0P47hDvLlBgKKDxyFZzIH/U31CshQrCWOSfWhU0llbS9aYpDFjpVfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719872213; c=relaxed/simple;
	bh=mCuebfb38eUzDwiUjQauqQ/gwpIEpx3kn4T6EHKpH5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I32BNih9U8eN4UNaV7bn8oeum5T9AZkMvGqBbWEQhMaGxQTYIgI5FUU2YUSIlYFDoEtx6StAOWJDyh+spBJfN+hfQCXIhlUXDONu0/D7egsLGTyUR7yTZcu4tJy19nMvD3/sFKoi4ts+gZkkdRMgF7Fq/Ker3FBEGdUFL+FRvrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sOPKE-0002ux-NO; Tue, 02 Jul 2024 00:16:42 +0200
Date: Tue, 2 Jul 2024 00:16:42 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [RFC nf-next 2/4] netfilter: nf_tables: allow loads only when
 register is initialized
Message-ID: <20240701221642.GA11142@breakpoint.cc>
References: <20240627135330.17039-1-fw@strlen.de>
 <20240627135330.17039-3-fw@strlen.de>
 <ZoMSIF0jVEe1ro5T@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZoMSIF0jVEe1ro5T@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > +	next_register = DIV_ROUND_UP(len, NFT_REG32_SIZE) + reg;
> > +
> > +	/* Can't happen: nft_validate_register_load() should have failed */
> > +	if (WARN_ON_ONCE(next_register > NFT_REG32_NUM))
> > +		return -EINVAL;
> > +
> > +	/* find first register that did not see an earlier store. */
> > +	invalid_reg = find_next_zero_bit(ctx->reg_inited, NFT_REG32_NUM, reg);
> 
> Is this assuming that register allocation from userspace is done secuencially?

No, that would be a bug.

Each set bit represents a register, if the bit is 1, the register
saw a store.

The above is the load check: load is from register "reg", and we
check the first reg that did not see a store (is 0), starting from
reg.  The result (register with undefined content) needs to be larger
than next_register, which is the register coming after the current
access (can be NFT_REG32_NUM, in that case no furhter registers exist
and access is ok).

> > +	/* invalid register within the range that we're loading from? */
> > +	if (invalid_reg < next_register)
> > +		return -ENODATA;
> > +

This means that in range the relevant access range
[reg,next_reg) the is at least on register that did not see a store.

