Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F001D278B
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Nov 2024 16:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730823836; cv=none; b=KSkRW9Mwcd+vDZCh2QNF5E/VEWZjSqSGbwGWMgGfWbEgWQeTIEQjNbR9dsSvk6avIX1/EOAIbMTOdBy5s34dYn78dSewTGKi+5JjDLatzszKaiT8+uxFSUWkUq1/kOrxE7Vm0RR7NAEdsZg58asgRi2kS910x0Db56+G81p4J/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730823836; c=relaxed/simple;
	bh=7xCGGwlD+cTFLAUY9pYRX/0e7FbNm9M9z/32yCr4hgg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oN3kwfqKKuDZHTpOShzKHy4nhPiq1ZhS8MaE1+0LKtELSbQ6BIB380/zvKowTD9NZFljdKMbhhQ6HZaZgh+yD6FOuSm1xmf1CuZVebFD/xhFp1wTfTDnnJZoXr9+zfP6N4Ji0AufnWGoDouM3QcBfwTku8uNcd0VprltOpSZsXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t8MLK-0002T9-Ad; Tue, 05 Nov 2024 17:23:46 +0100
Date: Tue, 5 Nov 2024 17:23:46 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Nadia Pinaeva <n.m.pinaeva@gmail.com>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	Antonio Ojea <antonio.ojea.garcia@gmail.com>
Subject: Re: [PATCH nf-next v2] netfilter: conntrack: collect start time as
 early as possible
Message-ID: <20241105162346.GA9442@breakpoint.cc>
References: <20241030131232.15524-1-fw@strlen.de>
 <CAOiXEcfv9Gi9Xehws0TOM_VrtH4yKQ4G1Xg9_Q+G8bT_pk-2_A@mail.gmail.com>
 <ZypDF4Suic4REwM8@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZypDF4Suic4REwM8@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sun, Nov 03, 2024 at 11:26:36AM +0100, Nadia Pinaeva wrote:
> > I would like to provide some more context from the user point of view.
> > I am working on a tool that allows collecting network performance
> > metrics by using conntrack events.
> > Start time of a conntrack entry is used to evaluate seen_reply
> > latency, therefore the sooner it is timestamped, the better the
> > precision is.
> > In particular, when using this tool to compare the performance of the
> > same feature implemented using iptables/nftables/OVS it is crucial
> > to have the entry timestamped earlier to see any difference.
> > 
> > I am not sure if current timestamping logic is used for anything, but
> > changing it would definitely help with my use case.
> > I am happy to provide more details, if you have any questions.
> 
> The start time will be accurate. However, stop time will not be very
> accurate: the netlink message containing the SEEN_REPLY status flag
> can sit in the socket queue for some quite time until the userspace
> software has a chance to receive and parse it.
> 
> @Florian: Would you explore instead to extend the nf_conntrack_ecache
> infrastructure to allow to provide timestamps for netlink events? This
> can be enabled via toggle. That would allow to have a more accurate
> delta between two events messages.

Simply using current time in ctnetlink won't help, the NEW event comes
after confirm.

It will help for SEEN_REPLY.  But I don't see how it will avoid this
patch.
