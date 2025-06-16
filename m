Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6B71E231E
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Jun 2025 09:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750065389; cv=none; b=FSoSE++g9TZeHNFkFP8JbUDFMXsOLykCz9XSJwp7cwyAnF+UR/em2TuCOK4YgkKpzPZwPc9Gt7boGzg6P6l5Nt0atNnMxyr5kXclivNrJMJKTb+9FiskUt1+zpLoA3zsMf2YJqwSzUkmsddE7iVsNzdJJvwYutXhuwAHUwiPcRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750065389; c=relaxed/simple;
	bh=EEK+hViHwKDOfxf++A1T8Q4mcNVtZbUeZvczFn5EdXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cSFYvRnLlpLJsGLo9l2w2JJi1l5CfFiK3kNDaM657mPwrqC79cSD4gaHCl4Rl9P8eppdhuMaHL3xgOHu4+Wrbf6JgE5PgrwG8wgGIQeqjFjY+fTKMjDTjDLn1dr2fLqNK3gx29K0ZwKyBboceI5wg3fisA9jYqqRwj8oQT4OaLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5602D60EC2; Mon, 16 Jun 2025 11:16:19 +0200 (CEST)
Date: Mon, 16 Jun 2025 11:16:18 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Phil Sutter <phil@nwl.cc>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] evalute: don't BUG on unexpected base datatype
Message-ID: <aE_gwzl1Fagv0jcz@strlen.de>
References: <20250613144612.67704-1-fw@strlen.de>
 <aExGZDqWdNgG0_BD@orbyte.nwl.cc>
 <aE3vUEmr6Ua291dK@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aE3vUEmr6Ua291dK@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >  I wonder if we should just replace all BUGs in evaluate.c
> > >  with expr_error() calls, it avoids constant whack-a-mole.
> 
> I think that can help uncover bugs, or are those json induced bugs?

This one is bison, see included bogon input.
I meant in general.

How do these BUGs help at all?
