Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580E83FE3F
	for <netfilter-devel@vger.kernel.org>; Wed,  8 May 2024 12:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715172809; cv=none; b=FLjrNcLUCw2B0vz8r54ye9uSX1RyorSydU/b+loTbbA/GCYd6RdRyxLr+o+YBWTwW5WmXrDcttIes01hMzJYXnjc6ucQxX2U+H0lKE4kTDQI/aObhlfjL2EhPgUjR8DzLfGWu0zKe/njFKZfI3XDHhTT6Mnd7nQAX8HgQbWMbts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715172809; c=relaxed/simple;
	bh=RzeBBbXZVxVO+N9WJFONre/1okruZQhE7tDzS/jGyx0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UwG92M1HIhyX1FmltcHOnZVYU2A1m2Xm5hmUcI8FVXzhGqql/n9yaf4EqLG1IsdA/RaJ7P1E7jWS7s6ICvb/ijBjRrrRmxnWMpm5KwXD9MYvu2QvAp8V1FZbvbUlR0pFjOMfKkdqUVuUva6p5vOaEOIlQ7JTPBe4HD5aMQ4gdbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1s4gCk-0004ML-B8; Wed, 08 May 2024 14:15:26 +0200
Date: Wed, 8 May 2024 14:15:26 +0200
From: Florian Westphal <fw@strlen.de>
To: Sven Auhagen <sven.auhagen@voleatech.de>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, pablo@netfilter.org
Subject: Re: Could not process rule: Cannot allocate memory
Message-ID: <20240508121526.GA28190@breakpoint.cc>
References: <qfqcb3jgkeovcelauadxyxyg65ps32nndcdutwcjg55wpzywkr@vzgi3sh2izrw>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <qfqcb3jgkeovcelauadxyxyg65ps32nndcdutwcjg55wpzywkr@vzgi3sh2izrw>
User-Agent: Mutt/1.10.1 (2018-07-13)

Sven Auhagen <sven.auhagen@voleatech.de> wrote:
> I am using nftables with geoip sets.
> When I have larger sets in my ruleset and I want to atomically update the entire ruleset, I start with
> destroy table inet filter and then continue with my new ruleset.
> 
> When the sets are larger I now always get an error:
> ./main.nft:13:1-26: Error: Could not process rule: Cannot allocate memory
> destroy table inet filter
> ^^^^^^^^^^^^^^^^^^^^^^^^^^

> along with the kernel message
> percpu: allocation failed, size=16 align=8 atomic=1, atomic alloc failed, no space left

Are you using 'counter' extension on the set definition?

Could yo usahre a minimal reproducer? You can omit the actual
elements, its easy to autogen that.

