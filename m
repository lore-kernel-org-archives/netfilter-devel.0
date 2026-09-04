Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74FC8412294;
	Fri,  4 Sep 2026 05:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501432; cv=none; b=ZcJrhAmQ61MKISAk/ccEFacwJW7Ta8zau6GCDXofk5m8jp3JmDkZ1gBl1WHlgyHK5r907KyRq3d5BZgzFqLa01/CxNYsB9mW6S6pAnIHaYImceK57U+2P2lbqpbsCUSU6ofFWTIe5xKchsa1i+wP41AtevnwLmTLpemoUnSCLk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501432; c=relaxed/simple;
	bh=8s4DQ/ak2Il+rCZFVLgNqdu0xyhkLfkZ/xyTVNKJBdI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gkt1GZIY1pYc8tar97CS9UkLps0E945V48gIvk/UXqRfNEZGHdn6cki4pWCwX0rLrfwOX4UYbKHZRtq/05JJw+2sLriXMGPnXx6uyggfLqBDcDt2r/MSVAxvTX+pMTsqIRThp4RNOig9jvNC61t9AJDFznELjEEukymr9nIzEdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 414C56032B; Fri, 04 Sep 2026 07:57:08 +0200 (CEST)
Date: Fri, 4 Sep 2026 07:57:07 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	horms@kernel.org, ja@ssi.bg
Subject: Re: [PATCH net 00/12] Netfilter/IPVS fixes for net
Message-ID: <appds8dn7fuqOvHw@strlen.de>
References: <20260903004149.1037028-1-pablo@netfilter.org>
 <20260903190425.332cd930@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903190425.332cd930@kernel.org>

Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu,  3 Sep 2026 02:41:37 +0200 Pablo Neira Ayuso wrote:
> > netfilter pull request 26-09-03
> 
> I think the AI is now going too far claiming the patches don't fully
> close the issue and/or the commit message isn't 100% accurate.
> But we missed the net PR today, already, so why not confirm..

Pablo, I suggest you drop all my patches from this batch and resend.
