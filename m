Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF8D3DD537;
	Wed, 25 Mar 2026 14:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774448897; cv=none; b=H6tTXoykLAszI+BWOc+K6i3dZToi7tpgDGd5yg+jQLpTg/Vrte2oi0bDuZNxKwpsEZcsJ2jJK1GYEwfabIQElda5YiRYrscA+4qWa47dmBYVlVv8XfjtpVZXnoE1Oyp0qb8fBrNC3mpwgHOrkMlTYVhUAEzqpSNDV+AZL5c9OOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774448897; c=relaxed/simple;
	bh=O2Gf8X5RLnOS8yFEf/UX3fzOa0YqnwPiqSnZP2zBuhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dkxgmbxPHLa6CX/O+/YNCSqrP9aa8+qj6ir2zh3RgRodFes7zviQyjaFTE2Of83lKP1nEjCn6Y5eu5qCcdCuk+yt/KAGy10UEgGa9pV5zGSR2XY+s44X+15yixUYIw6dnbkY+ROX9lLMxsoDNurr7WrCHxQ4BfP7SplUj928+xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5CE2A60CBB; Wed, 25 Mar 2026 15:28:12 +0100 (CET)
Date: Wed, 25 Mar 2026 15:27:51 +0100
From: Florian Westphal <fw@strlen.de>
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: pablo@netfilter.org, phil@nwl.cc, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nf_flow_table_offload: fix heap overflow
 in flow_action_entry_next()
Message-ID: <acPw54RoNOSgsfdE@strlen.de>
References: <aaxe-uH2Qr6qM4E9@v4bel>
 <aax2yZtJce0d19gd@strlen.de>
 <abfhRFfZ1LOgWEsf@strlen.de>
 <abfoTBGLhav-iPQb@v4bel>
 <abfuEe_PpDCyA64B@strlen.de>
 <abgQ7GSjz2v2_QnX@v4bel>
 <abgajW6KJM5KD3bN@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abgajW6KJM5KD3bN@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> Hyunwoo Kim <imv4bel@gmail.com> wrote:
> > hmm. So, based on what you said, I assume the run-time check would look 
> > something like this?
> > 
> > diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> > index 9b677e116487..69ffefbdd5e8 100644
> > --- a/net/netfilter/nf_flow_table_offload.c
> > +++ b/net/netfilter/nf_flow_table_offload.c
> > @@ -218,6 +218,9 @@ flow_action_entry_next(struct nf_flow_rule *flow_rule)
> >  {
> >         int i = flow_rule->rule->action.num_entries++;
> > 
> > +       if (WARN_ON_ONCE(i >= NF_FLOW_RULE_ACTION_MAX))
> > +               return NULL;
> > +
> >         return &flow_rule->rule->action.entries[i];
> >  }
> > 
> > However, if we add a runtime check in this way, all callers of 
> > flow_action_entry_next() would also need to handle a NULL return value, 
> > since none of them currently perform a null check.
> > 
> > Because of the potential risk, this would require modifying quite a number 
> > of call sites carefully. What do you think about this approach?
> 
> Can't we reject this at configuration time?
> 
> I mean, userspace has to ask for this action sequence, no?

Guess:

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -105,6 +105,9 @@ struct nft_flow_rule *nft_flow_rule_create(struct net *net,
        if (num_actions == 0)
                return ERR_PTR(-EOPNOTSUPP);

+       if (num_actions > NF_FLOW_RULE_ACTION_MAX)
+               return ERR_PTR(-EOPNOTSUPP);
+
        flow = nft_flow_rule_alloc(num_actions);
        if (!flow)
                return ERR_PTR(-ENOMEM);

