Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE7138F226
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Aug 2026 16:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035133; cv=none; b=cvdf64ZSK7RuYhLT28tc8A747ImILXgj0/tqkdreO3bq8VNq8wLyfkn9QIbaUPcM+1mkROjJDCEQCXKPDgC5nUpHPNr1WTIL9TX5ovoF7pph/AT38kvsbfccWTQpJOpFTMSgaOWWUtdq27bi3UNIA+0v6SUylldQGshzdf6qSuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035133; c=relaxed/simple;
	bh=7A6y2fqFu0ra2jfky8aBMhlbeHVEDALneuEdlxuMou4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EEsw3frHYhnDz5Pt3rB3o9Rt+IkGTRZFhh9oYWHgmhtvVc/aHDyVBf4IbL3qflHe23R/JbXlaSvnBn5Nci9An2vHbdFibGgDbd7Rl8WuzKUJq4f8p3zT29oENiqGVxHHPdbyiBUK7jcDSPvxUM0wI7xt0rGUlUWSspuXLWArnoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B00AA602AB; Thu, 06 Aug 2026 18:52:06 +0200 (CEST)
Date: Thu, 6 Aug 2026 18:52:05 +0200
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: [PATCH nf] netfilter: ipset: let destroy callbacks adjust ext
 mem size
Message-ID: <anS7tUXBHWztzD9m@strlen.de>
References: <20260806141750.10441-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806141750.10441-1-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> For bitmap this change makes no difference, because destructors are
> called synchronously.
> List type however calls them via call_rcu() so accounting decrement can
> happen after list_set_flush() set ext_size to 0.
> 
> 'set->elements = 0' can be removed for the same reason in the list type
> case, it calls 'set->elements--' for each element.
> 
> Fixes: 9e41f26a505c ("netfilter: ipset: Count non-static extension memory for userspace")
> Suggested-by: Jozsef Kadlecsik <kadlec@netfilter.org>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  sashiko: list_set_uadd() may call list_set_replace() and
>  then erronously increments set->elements, causing a counter
>  drift. This bug will be resolved in a different patch.

Seems sashiko ignored this and reported this bug again.
The report can thus be discarded.
