Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0D54F68B4;
	Wed, 14 Oct 2026 11:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791977031; cv=none; b=gFZYNRuCPAYBCkWZvovsDUVkPDMlYi2MGeWPNl2o+N00F+mb8W5QkLg7oN36c1AeGLqcXR3OuDCUp5JopV6RbaKCU8yN8pU8k7mGRchj/pwGsn+p1dsFDOgD1dK3vVNO8RTbG3P2p/Oz3WZl59Jr5jCwwCPJ4cYwqwbn2CGs8fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791977031; c=relaxed/simple;
	bh=1gJYOvUdRjxpyBKufdxGY4p4MZRccLrsispRaZ8vt64=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iJVR0mrCiDcUcKzswE4OeEI1LDOuVDQXQ483fGfYs9veaaNH1mvmqszVXFqifjyUy9truvzQ8zcpr5ejGy0lHdHPFid3N/51LoNP2Jp7jn7xczidDJk5oUH6bDnQUXmnDvhj4uiceFU0U1tO5g5Sm0E73tI1nGDRutU3O1R9st8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7B30760486; Wed, 14 Oct 2026 13:23:47 +0200 (CEST)
Date: Wed, 14 Oct 2026 13:23:46 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, horms@kernel.org, ja@ssi.bg,
	lorenzo@kernel.org
Subject: Re: [PATCH net-next 00/15] Netfilter/IPVS updates for net-next
Message-ID: <as9mQmF9Owtv9r36@strlen.de>
References: <20261011215953.1334630-1-pablo@netfilter.org>
 <as66prsWCk1qlQpm@chamomile>
 <as9dKnQPk5xy92M8@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as9dKnQPk5xy92M8@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > sashiko reports:
> > 
> > "If an IPv4 packet from an AF_INET socket is encapsulated by an IPv6 tunnel,
> > the tunnel preserves the AF_INET socket in skb->sk while transmitting the
> > outer IPv6 packet on the LOCAL_OUT path."
> > 
> > This sounds like an unrelated issue, I don't know yet how that can
> > happen TBH.
> 
> I'm stupid and I don't understand why this would be a regression.
> 
> This change makes things stricter, so it doesn't enable anything that
> wasn't allowed before, how does this add a new crash regression? :-(

Please toss this patch. Lets ignore this problem.
