Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C617030DEA6;
	Mon, 16 Mar 2026 14:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773673128; cv=none; b=KC0Ny0s4z7hqZR5JzUK2vY9nmT3r4zTPfzN+KhZ9aB4sau/3LeBpn6r3ZX8cwhv/pSe2NA1dVMXbExJwLUGOj4NYUVUG6Sd65/x5PPOGfZamBc4bOnmAj1gdNLKKMJME8IGNWTvnLakl+o19HysJhvvfvb8TW4L5jMzoJo1oa0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773673128; c=relaxed/simple;
	bh=WQ7+yzEPlsNgj0Vd3agRBCbV3mUnKYAhERmPGtYemAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BlAy2XqFpYJDiojTiUqaiwEhcajufDEMyQbwEACIVza+4qLHiN5Yl/O/J35totQD5n+GvWgvgA/6um0Ya/cB7jpXvHuYGA5Z8je1lRLVxaB6r5KvVYCktWwaZIG7bzee0wdRB9GDGPtcreD7ZhEmyei7fy3AZKPTPFUx93WjjYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7A121605C3; Mon, 16 Mar 2026 15:58:44 +0100 (CET)
Date: Mon, 16 Mar 2026 15:58:48 +0100
From: Florian Westphal <fw@strlen.de>
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: pablo@netfilter.org, phil@nwl.cc, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nf_flow_table_offload: fix heap overflow
 in flow_action_entry_next()
Message-ID: <abgajW6KJM5KD3bN@strlen.de>
References: <aaxe-uH2Qr6qM4E9@v4bel>
 <aax2yZtJce0d19gd@strlen.de>
 <abfhRFfZ1LOgWEsf@strlen.de>
 <abfoTBGLhav-iPQb@v4bel>
 <abfuEe_PpDCyA64B@strlen.de>
 <abgQ7GSjz2v2_QnX@v4bel>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abgQ7GSjz2v2_QnX@v4bel>

Hyunwoo Kim <imv4bel@gmail.com> wrote:
> hmm. So, based on what you said, I assume the run-time check would look 
> something like this?
> 
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 9b677e116487..69ffefbdd5e8 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -218,6 +218,9 @@ flow_action_entry_next(struct nf_flow_rule *flow_rule)
>  {
>         int i = flow_rule->rule->action.num_entries++;
> 
> +       if (WARN_ON_ONCE(i >= NF_FLOW_RULE_ACTION_MAX))
> +               return NULL;
> +
>         return &flow_rule->rule->action.entries[i];
>  }
> 
> However, if we add a runtime check in this way, all callers of 
> flow_action_entry_next() would also need to handle a NULL return value, 
> since none of them currently perform a null check.
> 
> Because of the potential risk, this would require modifying quite a number 
> of call sites carefully. What do you think about this approach?

Can't we reject this at configuration time?

I mean, userspace has to ask for this action sequence, no?
