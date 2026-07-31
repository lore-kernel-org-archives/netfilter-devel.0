Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958B441684B
	for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2026 10:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785493110; cv=none; b=HMkDDPmb6NdDSo8T2rJroXesCcoRHwS/nKWYlSuqJjZ4Dh5DLma+BxiYc8L4ojTDx3QTDbxxUnQ7f44hfRzc/MCy7BesDstZJQJOZ3II5TFtDSosc9u80/3yFiGCbBKCI4NocdATyPoZYaSXM/nlspXX1I/lvVQW50B03hkTINI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785493110; c=relaxed/simple;
	bh=hUBeNOv12FPk9ka05gjuQ4KkbWPIso8TFhtKwxbgEbE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d1V+FspTgiyH3e3ktaC5NHgk775opaAY/hUKrzaYbc/JOzrjRVkGnXbXZlWNGC0Id0RC28jxSr2AIdx9yV2KFtBkais8j8js/oMqBNwIsIrsLi6TpcWmy/eM2W4I6IEhiJe9W3rvPDI0ZF+ZenaqnOY1OSp3Gt+4XBlI2NV5cJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=JiF8b6pI; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="JiF8b6pI"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 74D9D601BC;
	Fri, 31 Jul 2026 12:18:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785493094;
	bh=2z7v0hEExWxIO2Y55UcXJmHqBgHu8d4K+J2y0HxcOR0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JiF8b6pIxq/lJY9fIR2siWWi9o5HZ0Hjdij0OJjQyb07H+ZacL0MgxKoXIb65ZTxM
	 rMFTcrewPpJClsxp3nX51mjdk1jIYRaFEv0flWvWOj7ham3EFFJbKnq710h9XDtdpq
	 TeHqcU0ix2pD1XPHCISEdaHABCbOXTEzN6BQNVxzI4jAbOaM7eImeL+A/SUUUEL37F
	 cxWabNMZqVUuYNo2B3odasmrqP9X9hg3yg6+nnxYzUTY767/0qamEKbm7qL1mgRuSz
	 oCfsvtLrv/B18LdMv+UKWqTJTCH0Yvg1dWzZvct+8NdbXA5+LUGrsAhhNn4aoQVFnm
	 ROglxy/kf6UTA==
Date: Fri, 31 Jul 2026 12:18:12 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Zihan Xi <zihanx@nebusec.ai>, netfilter-devel@vger.kernel.org,
	phil@nwl.cc, davem@davemloft.net, edumazet@google.com,
	pabeni@redhat.com, horms@kernel.org, avagin@gmail.com,
	vega@nebusec.ai
Subject: Re: [PATCH nf v2 2/2] netfilter: nf_conntrack_tcp: defer
 tcp_in_window invalid logging until after unlock
Message-ID: <amx2ZGHC7vIUaK48@chamomile>
References: <cover.1785348197.git.zihanx@nebusec.ai>
 <27612fbff3730c5d63a0e3fb0f51aeeed77ed5d7.1785348197.git.zihanx@nebusec.ai>
 <amuz5x-ib-Cuatcn@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <amuz5x-ib-Cuatcn@strlen.de>

On Thu, Jul 30, 2026 at 10:28:23PM +0200, Florian Westphal wrote:
> Zihan Xi <zihanx@nebusec.ai> wrote:
> > tcp_in_window() can emit several invalid-packet logs while ct->lock is
> > still held.  If invalid logging is routed to nfnetlink_log with
> > conntrack export enabled, this can re-enter conntrack netlink glue and
> > recurse into tcp_to_nlattr() on the same conntrack.
> > 
> > Fix this by storing only the minimal invalid-log context for the
> > remaining tcp_in_window() cases and emitting the actual log after
> > releasing ct->lock.  Rename the helper to reflect that it now records
> > context instead of logging immediately, and add an explicit lockdep
> > assertion plus comment to document that invalid TCP logs must not be
> > emitted while ct->lock is held.
> > 
> > Fixes: d48668052b26 ("netfilter: fix nf_l4proto_log_invalid to log invalid packets")
> > Cc: stable@vger.kernel.org
> > Reported-by: Vega <vega@nebusec.ai>
> > Assisted-by: Codex:gpt-5.4
> > Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
> > ---
> > changes in v2:
> >   - Keep only the tcp_in_window() invalid logging cases in this patch.
> >   - Rename the helper to reflect that it stores invalid-log context.
> >   - Add a lockdep assertion and comment documenting that invalid logs must not be emitted under ct->lock.
> >   - v1 Link: https://lore.kernel.org/all/cover.1785307980.git.zihanx@nebusec.ai/
> > ---
> >  net/netfilter/nf_conntrack_proto_tcp.c | 113 ++++++++++++++++++-------
> >  1 file changed, 82 insertions(+), 31 deletions(-)
> > 
> > diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> > index ef31dcaffd19..e5875b7528fe 100644
> > --- a/net/netfilter/nf_conntrack_proto_tcp.c
> > +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> > @@ -480,37 +480,87 @@ static void tcp_init_sender(struct ip_ct_tcp_state *sender,
> >  	}
> >  }
> >  
> > -__printf(6, 7)
> > -static enum nf_ct_tcp_action nf_tcp_log_invalid(const struct sk_buff *skb,
> > -						const struct nf_conn *ct,
> > -						const struct nf_hook_state *state,
> > -						const struct ip_ct_tcp_state *sender,
> > -						enum nf_ct_tcp_action ret,
> > -						const char *fmt, ...)
> > +enum nf_tcp_invalid_log_type {
> > +	NF_TCP_LOG_NONE,
> > +	NF_TCP_LOG_OVERSHOT,
> > +	NF_TCP_LOG_SEQ_OVER,
> > +	NF_TCP_LOG_ACK_OVER,
> > +	NF_TCP_LOG_SEQ_UNDER,
> > +	NF_TCP_LOG_ACK_UNDER,
> > +};
> > +
> > +struct nf_tcp_invalid_log {
> > +	enum nf_tcp_invalid_log_type type;
> > +	u32 value;
> > +};
> > +
> > +static enum nf_ct_tcp_action
> > +nf_tcp_store_invalid(const struct nf_conn *ct,
> > +		     const struct ip_ct_tcp_state *sender,
> > +		     struct nf_tcp_invalid_log *log,
> > +		     enum nf_ct_tcp_action ret,
> > +		     enum nf_tcp_invalid_log_type type,
> > +		     u32 value)
> >  {
> >  	const struct nf_tcp_net *tn = nf_tcp_pernet(nf_ct_net(ct));
> > -	struct va_format vaf;
> > -	va_list args;
> >  	bool be_liberal;
> >  
> >  	be_liberal = sender->flags & IP_CT_TCP_FLAG_BE_LIBERAL || tn->tcp_be_liberal;
> >  	if (be_liberal)
> >  		return NFCT_TCP_ACCEPT;
> >  
> > -	va_start(args, fmt);
> > -	vaf.fmt = fmt;
> > -	vaf.va = &args;
> > -	nf_ct_l4proto_log_invalid(skb, ct, state, "%pV", &vaf);
> > -	va_end(args);
> > -
> > +	log->type = type;
> > +	log->value = value;
> >  	return ret;
> >  }
> >  
> > +static void nf_tcp_log_invalid(const struct sk_buff *skb,
> > +			       const struct nf_conn *ct,
> > +			       const struct nf_hook_state *state,
> > +			       const struct nf_tcp_invalid_log *log)
> > +{
> > +	/* nfnetlink_log may re-enter conntrack attribute dumping and try to
> > +	 * take ct->lock again via tcp_to_nlattr(), so invalid TCP logs must
> > +	 * only be emitted after dropping ct->lock.
> > +	 */
> > +	lockdep_assert_not_held(&ct->lock);
> > +
> > +	switch (log->type) {
> > +	case NF_TCP_LOG_OVERSHOT:
> > +		nf_ct_l4proto_log_invalid(skb, ct, state,
> > +					  "%u bytes more than expected",
> > +					  log->value);
> 
> Can you move the comment and the lockdep assert into
> nf_ct_l4proto_log_invalid() so we can catch offenders outside
> tcp as well?
> 
> SCTP seems to be buggy as well.
> 
> Other than that:
> 
> Reviewed-by: Florian Westphal <fw@strlen.de>
> 
> You can keep this tag in next iteration.

Please, also squash these two patches in one, they are basically the
same logical fix plus include the SCTP fix.

I would suggest you call this patch:

  netfilter: nf_conntrack: defer invalid log until after unlock 

Thanks.
