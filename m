Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B843D7D67;
	Wed,  5 Aug 2026 19:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785957479; cv=none; b=sRmHSBF+Ue9IXS7sOTQoFsE8njKjFQoR2EbsmVFBeyWvn2kAPdduPpqBW6Wy0NCv8Kp0WTXNk899dpju7Z79itk5EyWMMTwoDdviwtCZnWLz/2g4VEVj1dSWPRMWn9hAF940hOx4jncp1bz5dTAEYdT069oZF/BtQUy16nZEnFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785957479; c=relaxed/simple;
	bh=N3LfiXUtgKYWagMvr3ExeRVkwop8Rz4/Vns0n+q7Lw4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n+7dYpQUPfXx4DSlaA1vjglDeZ3bmYKeWJXxBl8T9//rZ28JwcdOrSvc5lHn+t2oMOTOzmS6X6gE8/nnF76pnMubU+LkzHhmBU7VROUHo28MYd98Sk8Wmc3Lpe4VQajjyjOxc+dKTHI/V+MFeFv/pFNlnNWt2ooV1XG28HhpiVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E68E8602AB; Wed, 05 Aug 2026 21:17:52 +0200 (CEST)
Date: Wed, 5 Aug 2026 21:17:51 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
	edumazet@google.com, horms@kernel.org
Subject: Re: [PATCH net 03/10] netfilter: ipset: rework cidr bookkeeping
Message-ID: <anOMX-mBjTcG23WX@strlen.de>
References: <20260731151806.849724-4-pablo@netfilter.org>
 <20260805001531.3978750-1-kuba@kernel.org>
 <anNwo7eKRm5HqOOD@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anNwo7eKRm5HqOOD@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Florian needs these starter ipset patches to follow with more fixes to
> move ipset hash to use rhashtable.
>
> For his workflow, he considers it better to do this incrementally.

Some things I can squash and resend, but in other cases it would indeed
be better to keep it extra to avoid too large commits and better
document which patch is fixing what issue.

Many of these (new) LLM findings have root causes in older, different
problems.

> While this is not perfect, we prefer this path to address the existing
> issues that LLMs have reported in ipset.

Yes, we continue to get bug reports in code that is on the chopping
block, so the more I changes I have to squash and then send new version
the longer it will take to get the real conversion patches in.

Around half of the LLM issues I already knew and deliberately did not
fix in this first series to keep diff size smaller.

Paolo linked to an unrelated patch having a 'sashiko: ' comment
in the diffstat section to suppress known benign reports, I will
try to remember and make use of this for future submissions that
have known warts.
