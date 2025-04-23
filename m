Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0324280A20;
	Wed, 23 Apr 2025 14:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419762; cv=none; b=rXJmPesVBtEOzfTEJInI7fNnCoMaVDBBel6iP9fMNYw1AQmNkjWC8ZzNb8TuQKGRf6dKF0a0SUIsLXYP1QLTzA6CxCQktJ8YCrafVEQ1cs2nPgiO4AuX0TYlzjwn92oIICsg6x84GGtO6015U7+9qz9S1NneYNDUUFicASpxfnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419762; c=relaxed/simple;
	bh=8h9Pj6FUCm22sHBnB//KVvxcGmneZCHyGzEMLBFkEv4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EOzzHAf6fz9qEisBe7YcoXoKp9Y9lPj3JZM5gCd41IZGV93RcsnsMh562AurB6umsDwTEFQSU9XUGOTlpQbrrjGz6x5IeWPpI5Q55L8xoBUMXxFuAOv4adh+Jq7akgLT2Kjc/DJMr7dnrMT4KHEqSftTdykSIwHUaYQv5QIdkW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u7bPW-0003Qt-KZ; Wed, 23 Apr 2025 16:49:14 +0200
Date: Wed, 23 Apr 2025 16:49:14 +0200
From: Florian Westphal <fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: Jakub Kicinski <kuba@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	horms@kernel.org
Subject: Re: [PATCH net-next 4/7] netfilter: Exclude LEGACY TABLES on
 PREEMPT_RT.
Message-ID: <20250423144914.GA7214@breakpoint.cc>
References: <20250422202327.271536-1-pablo@netfilter.org>
 <20250422202327.271536-5-pablo@netfilter.org>
 <20250423070002.3dde704e@kernel.org>
 <20250423140654.GD7371@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423140654.GD7371@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Florian Westphal <fw@strlen.de> wrote:
> I can have a look, likely there needs to a a patch before this one
> that adds a few explicit CONFIG_ entries rather than replying on
> implicit =y|m.

Pablo, whats the test suite expectation?

The netfilter tests pass when iptables is iptables-nft, but not
when iptables is iptables-legacy.

I can either patch them and replace iptables with iptables-nft
everywhere or I an update config so that iptables-legacy works too.

Unless you feel different, I will go with b) and add the needed
legacy config options.

net tests are a different issue, they fail regardless of iptables-nft or
legacy, looking at that now.
