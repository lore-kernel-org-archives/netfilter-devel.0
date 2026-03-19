Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B02D37F018
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Mar 2026 09:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773911897; cv=none; b=FojH4tM2xSJ/5SLYQmVzFV6VfzRW+lLeHSzug9G0fAuN9EPAiLS6fO3uqmYhzWDIVS0KaeHglPFBn/ap5qb8R/90Xu+RwTPyRb9otE2128hFdlIpfeyYlPiANl9BU8OlNWax/cJgCemtT8ZJBcE6aono0g5JfKVzeji3lxUX0EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773911897; c=relaxed/simple;
	bh=Fg01wNRidLBXFO5MHQpk/6hleWtvyVLx0LRbg6syNcw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=edz7UFK/GPO5mk8RUXcvc3T1tjDtp5xXV8wzS1dC9UzqaPCYzV96WigMvoYb3qi6HiHtL5cr04r8TAVPh6CW3rJDuSZtGkCorC/tQ8750tU3okvTbPE2lnw27sNL+igmbxGPPpKljaTlElZl0nB+Mu60lX4tqq9HOyHO0La7KRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 32ABD606E1; Thu, 19 Mar 2026 10:18:11 +0100 (CET)
Date: Thu, 19 Mar 2026 10:18:11 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Chloro Dose <chlorodose@gmail.com>
Subject: Re: [libnftnl PATCH] set{,_elem}: Drop nftnl_set{,_elem}_clone()
Message-ID: <abu_U5twbHFFv-FT@strlen.de>
References: <20260319090613.13874-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319090613.13874-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> These functions were never exported and are not used internally anymore.
> Maybe due to that, they became incorrect (e.g., they ignore expr_list)
> so drop them altogether.

Acked-by: Florian Westphal <fw@strlen.de>
