Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B132853F7
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2025 22:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760998943; cv=none; b=c7kHXZM3KcuJ4cKB+ssjz4imC2xcUq2/3mkJSiAJnGT86/1L99RvFAzrlDKV4IdrWvXLFjj5geGhzEPZXuV6hdFUGWa+92Rl8O3quUy4d4B8AMoDwTaY/kEvsSFcb5MwtT8UNRqn7FiQY5dkBNqLoFVW3THu2kDiyUnctE2OKzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760998943; c=relaxed/simple;
	bh=v1K+ViIWZGb1CdVQH9JLvZUQXcyHqCIs/OkTVgafkNs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dH021SN8YOxikPI23riNLbTiHmEL4PI6fkjAtLyu56HI+XMObtE923qaAXLwrqlw5rVjybU1OYaOxL93hiC610BeoipoXleqQHpajqML3vjdt2jF3jwgGVsCxO7iyFNAxFW0Ry7jBCVJvDBS1snoyvj3gP+NhgdgEobU3LBSmUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4FCBA6031F; Tue, 21 Oct 2025 00:22:19 +0200 (CEST)
Date: Tue, 21 Oct 2025 00:22:19 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 nft] src: add and use refcount assert helper
Message-ID: <aPa2G3AIYYR63RfQ@strlen.de>
References: <20251020072937.1938-1-fw@strlen.de>
 <aPaywVyKhzUuj8Mn@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPaywVyKhzUuj8Mn@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > +static inline void assert_refcount_safe(unsigned int ref)
> > +{
> > +	assert(ref > 0);
> > +	assert(ref < INT_MAX);
> 
> Will this point to the right file and line when the assertion is hit?

No, I meant for this to be used with gdb+coredump.

> IIRC we have to use a macro here?

If you think that is preferrable then I can do that, in that case
it would propably also make sense to use BUG() macro instead
of plain assert?
