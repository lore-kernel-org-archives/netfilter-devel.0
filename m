Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BEC37EFE7
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Apr 2026 12:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776947899; cv=none; b=UqGJi5MIvZ33Ig8KXTTwc9idYhmSLKwbb/NRF7eDn0CqOSlDvERZsJgRX/ydyhQnTJWDwxmepYKaG8T5RgwYS8P+A++pC2n41IU8jPaLqht6H1Bse+4dWFrf6NKxz5r0lX6z5pg89hXzyP/FFzYbTcSXIT5UXqBPxKJV9bouTbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776947899; c=relaxed/simple;
	bh=mF4lkmOmmugesXiliq/m9lC18kd+T+1JM1cH2Qf9sYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dblNh/+9XFj0qKbLA0e1E5+RQR+PrVlCi3IBnpLOLRik7DlmxI5KKLxCBlzbz7dfXNynrA27K1W2YXzctPoUFzRX3enuTWbNuKkNTDAja2eJZlH1vyt5JS+u9VzzlRrEAtz8ha2RKVX3Y+PT3As7W/OUeTJ4846hTaRD6oCiiLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5D87960425; Thu, 23 Apr 2026 14:38:15 +0200 (CEST)
Date: Thu, 23 Apr 2026 14:38:14 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	jeremy@azazel.net, phil@nwl.cc, pablo@netfilter.org
Subject: Re: [PATCH nf v2] netfilter: nft_bitwise: fix dst corruption in same
 register shifts
Message-ID: <aeoStjrp12qNUeDL@strlen.de>
References: <20260423120538.3704-1-fmancera@suse.de>
 <aeoQMCJ7x0tGoUFC@strlen.de>
 <684ec011-3785-4df4-a9ee-457025dcd447@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <684ec011-3785-4df4-a9ee-457025dcd447@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> On 4/23/26 2:27 PM, Florian Westphal wrote:
> > We should support overlaps (src == dst).  But partial overlaps?
> > Does nft generate such byte code?
> > 
> 
> No, not at all.

Phew. :-)

> Fine for me. I could not find any situation where this could be useful 
> but I was afraid of breaking some weird setups. If we have agreement 
> that this isn't useful I am fine rejecting it from control plane with 
> something like (not tested):

Lets wait for Pablos take on this, but I would prefer reject from
control plane.
