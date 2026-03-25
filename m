Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635632874FA;
	Wed, 25 Mar 2026 15:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774451934; cv=none; b=fpwS46+u3bgfmSq+0bMBzwpO3oD9NdSJmy9Mia/fByhgsz5Wr4DIp74dmNl90MpJsYJ554XsxbXFga/LK5+aneaqde4NdkZvJ+ZSWlaQhUloyREcDPPwHRCu4XMCcAjzvSyNSMpYYVGf2o1XSnhZtD2MZLVSHJ1QrVcgTo0Hd38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774451934; c=relaxed/simple;
	bh=6m/MmvYSE/2Ygtum1ZsGcZJVuBOOGdOrW5mny9KmDFk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VlH7sqBhtwUGOwaCPUqO173ccAY7XB3asPb2tTNlFnpmOxbt17fRRW4bhXU0sXctnekBNwdlkSTE1lA+Wl4edd50FX6OBqXMzTWWOeadQh0kNoyVe8++hwRD//ipP9UrIGROisYR7a//QqGr5TVlaAandtGt8T+DqdAVEfg21jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=e3hHqZCY; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="e3hHqZCY"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 58F7460178;
	Wed, 25 Mar 2026 16:18:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774451929;
	bh=x7JNqP/5ocp87OzSoqZMy229QOtYkmJPDg2MSYVgTZc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e3hHqZCYGoseBnrzwF5sFL6/D3LhGOfLTyGapPTZlQ49V+OpE3JwCRPxAEl6PIBmX
	 GmJhfxG/iLAx2eVWicZoyeD1uWWLBDPCk/MxOyIW7TlncqU2jFXpH1i8orwiDixGao
	 LX2Aj+pJNmUavvCKJW+zlrN2bqeySwk4TAuEf64Mb3m84nl8YsICoRQjVOxghpcZrt
	 EpNKki+io2lNl81N8tUHxuQHO3/SFPvUpp2qjlguvOPoH5FSaDQjE0MmyzRBR2xIF1
	 uPBV73UESrRQNLINCHS+ZV/NfEZiwV8ymGB6ZswUPBEXVyiAtWx4rcPEFKuQYA5EVm
	 m4f5LwV7punOQ==
Date: Wed, 25 Mar 2026 16:18:47 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Hyunwoo Kim <imv4bel@gmail.com>, phil@nwl.cc, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nf_flow_table_offload: fix heap overflow
 in flow_action_entry_next()
Message-ID: <acP810hDQY7O99-f@chamomile>
References: <aaxe-uH2Qr6qM4E9@v4bel>
 <aax2yZtJce0d19gd@strlen.de>
 <abfhRFfZ1LOgWEsf@strlen.de>
 <abfoTBGLhav-iPQb@v4bel>
 <abfuEe_PpDCyA64B@strlen.de>
 <abgQ7GSjz2v2_QnX@v4bel>
 <abgajW6KJM5KD3bN@strlen.de>
 <acPw54RoNOSgsfdE@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <acPw54RoNOSgsfdE@strlen.de>

On Wed, Mar 25, 2026 at 03:27:51PM +0100, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > Hyunwoo Kim <imv4bel@gmail.com> wrote:
> > > hmm. So, based on what you said, I assume the run-time check would look 
> > > something like this?
> > > 
> > > diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> > > index 9b677e116487..69ffefbdd5e8 100644
> > > --- a/net/netfilter/nf_flow_table_offload.c
> > > +++ b/net/netfilter/nf_flow_table_offload.c
> > > @@ -218,6 +218,9 @@ flow_action_entry_next(struct nf_flow_rule *flow_rule)
> > >  {
> > >         int i = flow_rule->rule->action.num_entries++;
> > > 
> > > +       if (WARN_ON_ONCE(i >= NF_FLOW_RULE_ACTION_MAX))
> > > +               return NULL;
> > > +
> > >         return &flow_rule->rule->action.entries[i];
> > >  }
> > > 
> > > However, if we add a runtime check in this way, all callers of 
> > > flow_action_entry_next() would also need to handle a NULL return value, 
> > > since none of them currently perform a null check.
> > > 
> > > Because of the potential risk, this would require modifying quite a number 
> > > of call sites carefully. What do you think about this approach?
> > 
> > Can't we reject this at configuration time?
> > 
> > I mean, userspace has to ask for this action sequence, no?
> 
> Guess:
> 
> diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
> --- a/net/netfilter/nf_tables_offload.c
> +++ b/net/netfilter/nf_tables_offload.c
> @@ -105,6 +105,9 @@ struct nft_flow_rule *nft_flow_rule_create(struct net *net,
>         if (num_actions == 0)
>                 return ERR_PTR(-EOPNOTSUPP);
> 
> +       if (num_actions > NF_FLOW_RULE_ACTION_MAX)
> +               return ERR_PTR(-EOPNOTSUPP);
> +
>         flow = nft_flow_rule_alloc(num_actions);
>         if (!flow)
>                 return ERR_PTR(-ENOMEM);
> 

That is good enough, thanks.

Would you submit this?

This is nf-next material, it is not possible to reach such number of
actions (16) in the flowtable.
