Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7AD1AB6E9
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 14:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726151244; cv=none; b=T1MUwNLpU2+m4fzqJpokhH6VL+E0ltFaE3FJkzl300jSqipPMVqUc4jKyvIuWHADOtU794/OFP88naiBrAfhHDtbHcG0F81TeGFE2hANiJHHu3/sFVDC9mdpjz+fQQ7zPIB79bIOW+SxSTXplsa2tdUfvmebf6BOrrf813+zYkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726151244; c=relaxed/simple;
	bh=sw6ju6hwPhos52xHgbRy2SKanMmBrNVl4ObSVQ6WrKw=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KN5l8RJ/6o9PIo+19o06X8dXqUOI041Nyyo0SHx2ZfzwcmOYeXTGX/N1k0vIvSUfk234B7bk3HVpzENjIHpq804B3nDTa69KhIIu8YbnWK+PzgfJFgW1x+pCm57cHB6hvZFO/fS/35Pe5Baq1JBOIvDUpgbZmqWQGNh3fqGeBF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sokn0-0002BS-P8; Thu, 12 Sep 2024 16:27:18 +0200
Date: Thu, 12 Sep 2024 16:27:18 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v3 01/16] netfilter: nf_tables: Keep deleted
 flowtable hooks until after RCU
Message-ID: <20240912142718.GD2892@breakpoint.cc>
References: <20240912122148.12159-1-phil@nwl.cc>
 <20240912122148.12159-2-phil@nwl.cc>
 <20240912133255.GB2892@breakpoint.cc>
 <ZuLxRi8asgeW1oLB@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZuLxRi8asgeW1oLB@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> > nf_tables_flowtable_destroy() is called after the hook has been
> > unregisted (detached from nf_hook list) and rcu grace period elapsed.
> 
> Yes, I didn't find a caller which didn't synchronize_rcu() before
> calling it. Same applies to chain hooks, right?

Sigh, there is nft_flowtable_find_dev() which iterates the nft_hook
list from packet path.

So the syncrhonize_rcu is irrelevant as long as the entry
is linked up and this patch is correct as-is.

 list_del_rcu(&hook->list);
 kfree(hook);

is illegal, and I think this should add a helper that unlinks
and then frees the entry via kfree_rcu and converts all instances
of this pattern.
