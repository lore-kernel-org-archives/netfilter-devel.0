Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DCA22B586
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Aug 2025 09:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756373491; cv=none; b=E7pHV5n3hW2734cJFG+ykmpTjV4Xm78WKTuDyD4wVB+UrX9drwcsUqj+PFJMtWJq+sy0jVHUevRC4wh12Upuxgo16F0gBNJ9TJSR7LW7lBbyk8cg6cSZ5D8WnPWKGyRuac42AT3nfb3o0nm2WO8QnpOcZcgtwjE4COJdgt0v+pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756373491; c=relaxed/simple;
	bh=jQcy5gSvmWlm1Xra1nxudxRsTUChZvFE1y1jHdHj+JA=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EfeqMll36/vGqkxt8Zsnw6CamzFLXuxOHImUCBT228KZUTh8IrrToo43mKll60KC3urXmlAzY8qOSx35QWfq3nwg9KqztHbcXN+ps+aVfIxmB8zdoehTBdCw9vj+2jVfsijRoCSewPTjB7/Rp3ouvqhnt0jOwlBt/3tRpQEZQbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1D5C160298; Thu, 28 Aug 2025 11:31:27 +0200 (CEST)
Date: Thu, 28 Aug 2025 11:31:26 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables monitor json mode is broken
Message-ID: <aLAh7h1tAQjiR4G5@strlen.de>
References: <aK88hFryFONk4a6P@strlen.de>
 <aK9w1Zqmxa9evI4C@orbyte.nwl.cc>
 <aK90KI8s-tyLGiVn@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aK90KI8s-tyLGiVn@orbyte.nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Oh, and there is also the same issue regarding flowtable hook deletion
> vs. flowtable deletion as fixed by commit 18ddac660dfa1 ("monitor:
> Correctly print flowtable updates"). :(

Yes, the json print functions can't handle the partial object states.
I also saw at least one segfault but did not investigate if it was
related to this issue or not.

Thanks for looking at this.
