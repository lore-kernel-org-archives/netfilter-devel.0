Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1E238DC7F;
	Wed, 29 Jul 2026 14:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785337145; cv=none; b=neEDZnH090k1+BUXm+Neg5OpMUDmM2bGCR1nKO4JHL8kIGbIfUhDqHtFacyemVFWriQcWetyR5LANL+8BHG+wxMNBPx/OsvlcDAgGWscNcc/Z6gpwahmOXnWRmN8hnmhFhCpEB8rjh12Ay87WjsBXPT/or2ysXQxk72jAZ94sBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785337145; c=relaxed/simple;
	bh=fXDmjsfDQjtaFOQvDtpp6nZgppQISEpbEuWemy5jrjE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uXZSdDd1LJBEfKV0JJQOlzD/ZaEQJSZsLNamX3N2MMTsD8PF92HuLeYtYnR+0LQlESZQBIv2bAh4NvGSHTDkF2Lc8skYuOUOH7vMePdXhQgwetddBSBFmklXqM7Awf8mnnKqJ2LYslX2FMx2CI5abj5t3izT+w8h3kCMzkB6+SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9A39460293; Wed, 29 Jul 2026 16:59:00 +0200 (CEST)
Date: Wed, 29 Jul 2026 16:59:00 +0200
From: Florian Westphal <fw@strlen.de>
To: Zihan Xi <zihanx@nebusec.ai>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc,
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	horms@kernel.org, chamaken@gmail.com, vega@nebusec.ai,
	stable@vger.kernel.org
Subject: Re: [PATCH nf 1/1] netfilter: nf_conntrack_tcp: defer invalid
 logging until after unlock
Message-ID: <amoVNFtNX5mpbum_@strlen.de>
References: <cover.1785307980.git.zihanx@nebusec.ai>
 <b9b0022c68b6d0ac1a729f768466e3400a825a87.1785307981.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9b0022c68b6d0ac1a729f768466e3400a825a87.1785307981.git.zihanx@nebusec.ai>

Zihan Xi <zihanx@nebusec.ai> wrote:
> nf_conntrack_tcp_packet() can log invalid packets while ct->lock is still
> held. This happens both through tcp_in_window() -> nf_tcp_log_invalid()
> and through the NFCT_TCP_INVALID path -> nf_tcp_handle_invalid().

Correct, this is a bug. While I like the general direction, I find this
patch too large and too complicated.

Please consider making at least two patches to fix this.

- One patch to make nf_tcp_handle_invalid() return bool, then log
outside of spinlock().  The timeout doesn't even have to be included,
	you can change the message to omit it (e.g. lowered timeout to
			UNACK or whatever).

This will help with review and it will simplify this patch too.

> +enum nf_tcp_invalid_log_type {
> +	NF_TCP_LOG_NONE,
> +	NF_TCP_LOG_OVERSHOT,
> +	NF_TCP_LOG_SEQ_OVER,
> +	NF_TCP_LOG_ACK_OVER,
> +	NF_TCP_LOG_SEQ_UNDER,
> +	NF_TCP_LOG_ACK_UNDER,

This is fine.

> +struct nf_tcp_invalid_log {
> +	enum nf_tcp_invalid_log_type type;
> +	u32 value;
> +	u8 index;
> +	u8 dir;
> +	u8 last_index;

index, dir, last_index no longer need this stashing once lowered-timeout
is solved as outlined above.

> +struct nf_tcp_invalid_logs {
> +	/* At most one tcp_in_window() log plus one lower-timeout log. */
> +	struct nf_tcp_invalid_log entries[2];

Same, once the lower-timeout is handled differently this is not needed.

> +static enum nf_ct_tcp_action
> +nf_tcp_log_invalid(const struct nf_conn *ct,
> +		   const struct ip_ct_tcp_state *sender,
> +		   struct nf_tcp_invalid_logs *logs,
> +		   enum nf_ct_tcp_action ret,
> +		   enum nf_tcp_invalid_log_type type,
> +		   u32 value)
>  {

This function doesn't log anymore.

>  static enum nf_ct_tcp_action
>  tcp_in_window(struct nf_conn *ct, enum ip_conntrack_dir dir,
>  	      unsigned int index, const struct sk_buff *skb,
>  	      unsigned int dataoff, const struct tcphdr *tcph,
> -	      const struct nf_hook_state *hook_state)
> +	      struct nf_tcp_invalid_logs *logs)
>  {
>  	struct ip_ct_tcp *state = &ct->proto.tcp;
>  	struct ip_ct_tcp_state *sender = &state->seen[dir];
> @@ -640,31 +728,29 @@ tcp_in_window(struct nf_conn *ct, enum ip_conntrack_dir dir,
>  			sender->td_end = end;
>  			sender->flags |= IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED;
>  
> -			return nf_tcp_log_invalid(skb, ct, hook_state, sender, NFCT_TCP_IGNORE,
> -						  "%u bytes more than expected", overshot);
> +			return nf_tcp_log_invalid(ct, sender, logs, NFCT_TCP_IGNORE,
> +					  NF_TCP_LOG_OVERSHOT, overshot);

Maybe rename to nf_tcp_store_invalid() or similar.  It only has to stash
the value (overshoot in this case) and NF_TCP_LOG_OVERSHOT.

Could you also add a lockdep_assert_not_held(ct->Lock) to the old
nf_ct_log_invalid() plus a comment explaining that we must not call into
nfnetlink_log with that lock held?

Thanks!
