Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FE1178381
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Sep 2024 09:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726653249; cv=none; b=SfAkwFqmYI+CbYMyA9TL26LWDylMYmh87fd8OyvHp8Bv/6Im4Gqe688gIRQoc26J4ID4khe9tjfHYR+2v2YmvD8Efi8WOF+UhGbCRYTjagpzgogJES+TTR19G/N067BboP6dV8BaS7LAQZrvV/IPXHR8hv3BOAaA58UFRiftgIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726653249; c=relaxed/simple;
	bh=kktjy5lMHPffALM9u/EgNWHsMssyxNbTxS5cHTA+DnU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mrk2s6OkohBcs2YX2mHQnUptSos1FjbnViqFuPi0OrbZwH+R4c8zFGxIIref5rG5hKKsmWa7lH9/yeo0KV9/3Hyk1WdUoZ3xGg+Hri99YLbD4uU6mIj5Gav47zNE0MohqDYj4mOrFIoRe7S6gJVYGZF6sOjp0jXVVtr6o0a0NOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sqrNs-000399-Q6; Wed, 18 Sep 2024 11:54:04 +0200
Date: Wed, 18 Sep 2024 11:54:04 +0200
From: Florian Westphal <fw@strlen.de>
To: Antonio Ojea <antonio.ojea.garcia@gmail.com>
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nfnetlink_queue: reroute reinjected
 packets from postrouting
Message-ID: <20240918095404.GA11988@breakpoint.cc>
References: <20240912185832.11962-1-pablo@netfilter.org>
 <CABhP=tY2ceRAiZd3UCN3LqU8ZSO1G1W236XW+2rC6QhpeA9dsw@mail.gmail.com>
 <CABhP=taUnE6nxQ1ZPradgk7iNt3M_LCcFoM251OhpEJsasCoSw@mail.gmail.com>
 <ZuqPnLVqbQK6T_th@calendula>
 <20240918084202.GA10401@breakpoint.cc>
 <CABhP=taCqWu5JSmZp+cF+p-=cDsbnQXpBU+ZR1v6238yC1pdmQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABhP=taCqWu5JSmZp+cF+p-=cDsbnQXpBU+ZR1v6238yC1pdmQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Antonio Ojea <antonio.ojea.garcia@gmail.com> wrote:
> > Antonio could also try this hack:
> >
> > diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> > --- a/net/netfilter/nfnetlink_queue.c
> > +++ b/net/netfilter/nfnetlink_queue.c
> > @@ -379,7 +379,7 @@ static void nfqnl_reinject(struct nf_queue_entry *entry, unsigned int verdict)
> >                 unsigned int ct_verdict = verdict;
> >
> >                 rcu_read_lock();
> > -               ct_hook = rcu_dereference(nf_ct_hook);
> > +               ct_hook = NULL;
> >                 if (ct_hook)
> >                         ct_verdict = ct_hook->update(entry->state.net, entry->skb);
> >                 rcu_read_unlock();
> >
> > which defers this to the clash resolution logic.
> > The ct_hook->update infra predates this, I'm not sure we need
> > it anymore.
> 
> Awesome, it works perfectly

Great, I'll send a formal patch.
