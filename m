Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A1B2E03EA
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 10:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770287842; cv=none; b=PNRqovMfIQ04TRP/mDXMbsanB/6VJzP9U6UrA9AH5KnKC4xJpyQp47SGv7SW+Lrie1I4utGwY/Ksl+jteqPri59Z3aEEUhlyLb7b3pMgtAV/grrViiAHXTDg7EpR0le1lt+TohtTY2L9FMXzknDROBSTt8ztkCtajGagLQMiV9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770287842; c=relaxed/simple;
	bh=g/H9e+MWNXCMMFLUwkMgHJ1O4UnXFXt15XsCUyKyi8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qajyxvXbOT5qMh/WCmLnNU9N6xrdL03BTh2UwD9ONgwwsvp187eB7fePJ+ma4awQWt5ZX96ukqkRIeSYn+sJ/VPd2GwYBI61cBX9lPRCxOCnEImERpjSwYpNHc1zR4yusvCbEgRhZ/ACaRXbvYsX/Ypm6AuyZrVwAjYPUshKcsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 735C160610; Thu, 05 Feb 2026 11:37:19 +0100 (CET)
Date: Thu, 5 Feb 2026 11:37:19 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v2 00/20] prepare for EXPR_SET_ELEM removal
Message-ID: <aYRy36z5j9qAFAQa@strlen.de>
References: <20260205024130.1470284-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205024130.1470284-1-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> This is v2 of the update to prepare for the removal of EXPR_SET_ELEM.
> This series is slightly larger than v1, including more preparation work.
> No functional changes are intended. No memory footprint reduction at
> this stage. This slightly increases LoC because of the patches that add
> assertions on EXPR_SET_ELEM.
> 
> This is passing tests/shell.
> 
> Apologies for this large series...

Thanks for the quick resend.  I have no comments, if you are happy with
it feel free to push this out.

I also checked this with both nf and nf-next and did not see any errors
running shell tests.
