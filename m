Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266482E22B5;
	Fri, 18 Sep 2026 08:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789720704; cv=none; b=LxxAVP3PFn7a4Pp9tjctAseh1CQe5KuoW91ShlS2JVKbESHJXnnpcOu68pQzshgZ6s7S/9YqCfaLSGLhwS7dUA7HBEQOSZFCHUPRI10h4us1gSzNpVGy4E2NuyrLFCWsAJAkqEhOWzBlvkNSRl95/9aFhOLrQTAtvx1pOR4RKVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789720704; c=relaxed/simple;
	bh=8ytEC02CBkAH1hD64m+2vvU6vsofHjKWGTI1Q8ujUXs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gtYzJ1NloxtYBxHa/liC3N4vYRTuXdImcrvFAbrplsrhnrcEVa7FuyJBXbNdY0gB0iGbvcPfRnjNP+qkfzY7aAXUO1LBvztXhW3aHJ/zHqmCy0AmueS4A0dnLJx5raFY8qdX/xKfuyv991mMQ7TMISNm4MIRrmQTyb0i/D+/06A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AajHUbKd; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AajHUbKd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789720692;
	bh=jVI9HVSyPXFgxlSH2ibKEir/RSIBCGwTHXBMxDn2af4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AajHUbKdTBZp5O7uXY0bgzNc+dzmhvAdT2g7fZrqcmmmxbKOWhawiTQPnp1VfCf+E
	 t3pK1XBp66F0j+lXeac/reAM2XgKQrduVN6iirEvFhFz6JKjA8Dm7xS2VITty4/vJ9
	 na7LIMCNrrG3LceELa9tYeSI4SV/TwIxcttr9uPAwW9u2x+1knS0PMdNYyiPDj12zM
	 cr36aDZmuJRW1fmqacSgklzhtC2RLl/xA3RzYHJLy2wWKI9l2NnUN7H0vWoUo9LNkv
	 WSCBBCwrOWhssmvEqPDyOtJYWrhsWnhZHZvjPkDsV141up0M/Z4HM9BlpwyuSMZwtM
	 eS2/LF0ywiJaQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 38E8A60052;
	Fri, 18 Sep 2026 10:38:12 +0200 (CEST)
Date: Fri, 18 Sep 2026 10:38:09 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 01/10] netfilter: flowtable: publish HW_DEAD after
 worker is done
Message-ID: <aqz4cRSbfcJI1Gvs@chamomile>
References: <20260916231652.127456-2-pablo@netfilter.org>
 <20260918020406.3513303-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260918020406.3513303-1-kuba@kernel.org>

On Thu, Sep 17, 2026 at 07:04:06PM -0700, Jakub Kicinski wrote:
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> ---
> netfilter: flowtable: publish HW_DEAD after worker is done
> 
> The patch moves the NF_FLOW_HW_DEAD publication out of
> flow_offload_work_del() into the common epilogue of
> flow_offload_work_handler(), so that it happens after
> clear_bit(NF_FLOW_HW_PENDING) rather than before it.  The stated goal is
> to make setting HW_DEAD the last flow access performed by destroy work,
> so garbage collection cannot free the flow while the worker is still
> touching it.
> 
> > diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> > index 801a3dd9ceea3..6757fd89c1f1a 100644
> > --- a/net/netfilter/nf_flow_table_offload.c
> > +++ b/net/netfilter/nf_flow_table_offload.c
> > @@ -995,7 +995,6 @@ static void flow_offload_work_del(struct flow_offload_work *offload)
> >  	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
> >  	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
> >  		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
> > -	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
> >  }
> >  
> >  static void flow_offload_tuple_stats(struct flow_offload_work *offload,
> > @@ -1059,6 +1058,12 @@ static void flow_offload_work_handler(struct work_struct *work)
> >  	}
> >  
> >  	clear_bit(NF_FLOW_HW_PENDING, &offload->flow->flags);
> > +	if (offload->cmd == FLOW_CLS_DESTROY) {
> > +		/* Publish after the worker's last flow access. */
> > +		smp_mb__before_atomic();
> > +		set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
> > +	}
> > +
> 
> [Severity: High]
> Does this reordering close the whole use-after-free, or only the
> FLOW_CLS_DESTROY part of it?

This describes a pre-existing issue. I posted patches for this I have
to pick up.
