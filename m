Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8772EBBA8
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Oct 2025 14:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759935025; cv=none; b=PsrzZzpn9mX8K1pWhmMlMsv/9FYiVAk19JMNncDNFlc5M1XcUALDdM++Uwj9Ji+BUlOASGtImcUonLY4uSB1TRAlE2i0ihW/IKEwnf4qOY/v1SVU/iZIdWiWfXnhIg9Mi+U9nGX49tBhbSn8/dFKESWehRPnUsiEN8w+guw+1Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759935025; c=relaxed/simple;
	bh=NIq/k5hsylzFfPvcj2+nEA7vSEGdTYbiK6usToOiSks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hn88nzH1zoOd+rpHQFaV35kq6gqP9/1kQts0cgXQshSJindEyw+vH9qJ+zWE7NS4E++G5S6M28JHFgxVfM5acSplmwSBHDT6mSjfqg02ZoehdL4bgP4MD+MjeCGhpKS/W9Gi3heV9uIWgM/WHcEbMUhqOLoxuj74uQim9w0e518=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 735C860164; Wed,  8 Oct 2025 16:50:20 +0200 (CEST)
Date: Wed, 8 Oct 2025 16:50:20 +0200
From: Florian Westphal <fw@strlen.de>
To: Donald Hunter <donald.hunter@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Nikolaos Gkarlis <nickgarlis@gmail.com>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nfnetlink: always ACK batch end if requested
Message-ID: <aOZ6LEfjQrh_NLz5@strlen.de>
References: <20251001211503.2120993-1-nickgarlis@gmail.com>
 <aOV47lZj6Quc3P0o@calendula>
 <aOYSmp_RQcnfXGDw@strlen.de>
 <aOZMEsspSF3HBBpx@calendula>
 <CAD4GDZxhOZOp1uJ=V-oEnjfU2B7B4NaTSYJBj7mr=ogfPb68Jg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD4GDZxhOZOp1uJ=V-oEnjfU2B7B4NaTSYJBj7mr=ogfPb68Jg@mail.gmail.com>

Donald Hunter <donald.hunter@gmail.com> wrote:
> Thanks for the cc. I'm having difficulty catching up with the thread
> of conversation, so forgive me if I miss something.
> 
> > Yes, I am inclined not to add more features to bf2ac490d28c (and
> > follow up fixes patches that came with it).
> 
> Is there a problem with bf2ac490d28c or just with things that have
> come after it?

it broke golang library for nftables:
https://github.com/google/nftables/issues/329

Fix is:
https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git/commit/?id=09efbac953f6f076a07735f9ba885148d4796235

Current discussion centers more on what bf2ac490d28c wants,
what it does, what netlink can provide in practice and what
userspace would expect/need.

> > > > I suspect the author of bf2ac490d28c is making wrong assumptions on
> > > > the number of acknowledgements that are going to be received by
> > > > userspace.
> 
> Hopefully not. In the success case, ask for an ack, get an ack.
> Without that guarantee to userspace, we'd need to extend the YNL spec
> to say which messages don't honour acks.

Its not about the types, its more about available buffer space for acks.

> > > > #2 If you set NLM_F_ACK in your netlink messages in the batch:
> > > >    You get one acknowledgement for each message in the batch, with a
> > > >    sufficiently large batch, this may overrun the userspace socket
> > > >    buffer (ENOBUFS), then maybe the kernel was successful to fully
> > > >    process the transaction but some of those acks get lost.
> 
> Are people reporting ENOBUFS because of ACKs in practice or is this theoretical?

It happens in practice, e.g.:
https://lore.kernel.org/netfilter/aKrK6h2zYdqj2unR@lilyboudoir.localdomain/

(every set element triggers another error message).
Note, this is without NLM_F_ACK, just due to error messages
triggered during batch processing.

> I think we should try to specify the behaviour and see if it makes
> sense before layering more functionality onto what is there.

I think we can all agree on that :-)

> I can describe how the YNL python code sees the world, when it asks for ACKs:
> 
> 1. An ack for BEGIN, cmd, cmd, ... , END in the success scenario.
> 2. An ack for BEGIN, cmd, cmd, ... up to the first ERROR in a failure scenario.

Thanks for clarifying.

This should work, IFF the batch is small enough so receive buffer can
hold all acks.

nftables doesn't bail out on first error (transaction will fail and
no permanent changes are made, but it will move to next contained
message.
