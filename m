Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4917A165FAF
	for <netfilter-devel@vger.kernel.org>; Fri, 10 May 2024 08:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715329779; cv=none; b=KMxNBc/jEXxuImyIlJ3ii2pwCStMt0Br2jExYXZf+XbpOh+Fdwsmdq6q7FXCaaulPL5B3F9qARHIbki6PC2HWIxILtouXNoWBeJG04P8KoxvSMHX3ZEXa25ZZQCfOGTri6tTA5aRWIkj0tVWuFWBOzlqMucP+R/5GskmQUr+cME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715329779; c=relaxed/simple;
	bh=wIUjL7m9bMJkgLNAvzQ4N+bii8Is/EHCqpaKuyi2sBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pM0X68CgYYc4/B5WbcoUHKiIZnsJEhGHu9AOI6pt7s3qRt6gz2KOGHNnHvjOE4xEWmRluYE847uekmw2LFopGsOjjadA3V2M3wPT/3KbMETTTBzgHBcgq6FfJbfbzHdy04DzYFAN0Wkt5AT5eD3LpokpkOAKy5H67JatzQMv2mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1s5Ld1-0005NX-PI; Fri, 10 May 2024 10:29:19 +0200
Date: Fri, 10 May 2024 10:29:19 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	sbrivio@redhat.com
Subject: Re: [PATCH nf-next v2 7/8] netfilter: nft_set_pipapo: move cloning
 of match info to insert/removal path
Message-ID: <20240510082919.GA16079@breakpoint.cc>
References: <20240425120651.16326-1-fw@strlen.de>
 <20240425120651.16326-8-fw@strlen.de>
 <Zj1s6HcwpUsHKkrK@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zj1s6HcwpUsHKkrK@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> nft_pipapo_get() is called from rcu path via _GET netlink command.
> Is it safe to walk over priv->clone? Userspace could be updating
> (with mutex held) while a request to get an element can be done.
> 
> That makes me think nft_pipapo_get() should always use priv->match?

Right, that could work too.
