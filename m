Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0218125742E;
	Wed, 23 Apr 2025 14:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745417221; cv=none; b=PdTk9IupFSbXUauO4tW3HLR+ov61MWXcUt4Y/XRBwKKHbzBFKAJ+3zaXnTg5eCbnmyKROVbdY6ep9LlYJKzbjYY41yeBHxABkXYl1XLXLsdzGOsZWJ6Tcadu6P7WipC3jLlvJRXdE6zHqQkDZ1Ka6Cu3i6J9H/jJKn4d1CaBk9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745417221; c=relaxed/simple;
	bh=/4IwMcmggweNzLOmEsT4avJ0Quz1czJWw65b6ndALbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p+K/bdhR/Rjp/KG11DrZxMIk969HJDp53BO//im1n77DEXz2M8BTYb1QKyldJz4RxEP9G5fkYAFOe+S96cOBuslgsuTJJNR7X9PnU+hcPrU3WdNCloi0n1gCFrhXaTS81mvMffLZL8nBV4KhC+bl3o9x7Jhp1op3sdwrvHIyR3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u7akY-000386-Tc; Wed, 23 Apr 2025 16:06:54 +0200
Date: Wed, 23 Apr 2025 16:06:54 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	fw@strlen.de, horms@kernel.org
Subject: Re: [PATCH net-next 4/7] netfilter: Exclude LEGACY TABLES on
 PREEMPT_RT.
Message-ID: <20250423140654.GD7371@breakpoint.cc>
References: <20250422202327.271536-1-pablo@netfilter.org>
 <20250422202327.271536-5-pablo@netfilter.org>
 <20250423070002.3dde704e@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423070002.3dde704e@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jakub Kicinski <kuba@kernel.org> wrote:
> I think you need to adjust a bunch of existing config files.
> Or make this somehow default to y when they are selected
> instead of having them depend on the LEGACY feature.
> 
> All these failures are because netdev CI builds based on relevant
> configs in tools/testing/selftests lost the netfilter modules:
> https://netdev.bots.linux.dev/contest.html?branch=net-next-2025-04-23--12-00&pw-n=0&pass=0

I can have a look, likely there needs to a a patch before this one
that adds a few explicit CONFIG_ entries rather than replying on
implicit =y|m.
