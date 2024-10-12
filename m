Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5E51953A9
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 14:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728744150; cv=none; b=Y3fFMk4Hw5g3VEJx92qIdTUiHQyU8hVEcAxolYIk6Wm3RyPF+9mGcRNM4K1LtWD90Hw+P+AGAIufuEjBS5498RaKb2ypJDmtAfMUgdtBhBQhpka/yKcbVTD/p4LgSS4sErNa75OUzZu8t4Ck+/1iawizRBLl6r2OIenifAtSec0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728744150; c=relaxed/simple;
	bh=wc3X1rtr8ZQM7k2RQHa3gaF2SgYnRsTCpHVydNsrycs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mui4iNboOdG7L4lEI1NIREuHo+vmhzGa7pE4/x9zSoqyapZ6p7/iL+cafVebEC7NaHIaepS/gdNLKSDs14EpmpQicy9bJETA6Ne5dO/b5NL7eGn19ClF9TIbxjexTwII64swyazz2HN3Vn3uiZlVHn+3pa4od2MtKrTBy1T3T3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1szdJx-0006Qd-06; Sat, 12 Oct 2024 16:42:17 +0200
Date: Sat, 12 Oct 2024 16:42:16 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/4] netfilter: use skb_drop_reason in more places
Message-ID: <20241012144216.GA21920@breakpoint.cc>
References: <20241002155550.15016-1-fw@strlen.de>
 <ZwqDI5JcQi5fMa46@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwqDI5JcQi5fMa46@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> One question regarding this series.
> 
> Most spots still rely on EPERM which is the default reason for
> NF_DROP.

core converts NF_DROP to EPERM if no errno value is set, correct.

> I wonder if it is worth updating all these spots to use NF_DROP_REASON
> with EPERM. I think patchset becomes smaller if it is only used to
> provide a better reason than EPERM.

I'm not following, sorry.  What do you mean?

This is not about errno.  NF_DROP_REASON() calls kfree_skb, so tooling
can show location other than nf_hook_slow().

Or do you mean using a different macro that always sets EPERM?
