Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C90331ED0;
	Thu,  3 Sep 2026 06:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788418699; cv=none; b=I1AuX+TTPkwS7Cb5RoQ2p2WAwIOFWrmY//O5PcOf0f7tEU8VfiOb+Igp2sWIFj0etR2RbIO3vH33mxlwCt572AiqZCH0jkJEAgMRlQIKY7cpVKLfdASu76r+tE1UCcMN0Rha3m4XZAguUItjQfqWXvR59DKnvRY4bex9hOxueRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788418699; c=relaxed/simple;
	bh=jd4g6n0K3Z9u5xj+BbuCKna0mV3cLVe7KwV+/JhTnWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vGYpd4ppKC0Sv03liNh6zK0CK30YuWrphazs8/pzC5EKnuPMJCZvcQJvHMqimc2D2vukisCrSG72mDAUD9/GO7HjaEV8EQWsx/xyt/eMMd8ERyrwgVnjlnQF4GAzcDryqQc79yn8lcQxKXqDT1Y8Ukj1bJvCEWlrdDHLAOcYl80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 76E5C6032B; Thu, 03 Sep 2026 08:58:15 +0200 (CEST)
Date: Thu, 3 Sep 2026 08:58:15 +0200
From: Florian Westphal <fw@strlen.de>
To: zihan xi <zihanx@nebusec.ai>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Phil Sutter <phil@nwl.cc>, Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, coreteam@netfilter.org,
	stable@vger.kernel.org, Vega <vega@nebusec.ai>
Subject: Re: [PATCH nf 1/1] netfilter: nf_dup: prevent asynchronous duplicate
 recursion
Message-ID: <apkahwSdQhuE6gRV@strlen.de>
References: <cover.1787903722.git.zihanx@nebusec.ai>
 <8e45ea5d0cf764267a90d959fa40f0f831aabf08.1787903722.git.zihanx@nebusec.ai>
 <apKl65BbdyWCtre7@strlen.de>
 <CAANe3eT8ycDkomgpzZmni7hMrUX1fr2dE4QvQOcKCPEcw=J=2A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAANe3eT8ycDkomgpzZmni7hMrUX1fr2dE4QvQOcKCPEcw=J=2A@mail.gmail.com>

zihan xi <zihanx@nebusec.ai> wrote:
> If you do prefer to keep a small nf_dup-only change, I can prepare either:
> 
> 1. disable IPv4/IPv6 dup in network namespaces owned by a non-initial user
>    namespace; or

I think this is the better option, someone would have to explain
the use-case for DUP in a user netns.
