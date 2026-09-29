Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D3A4E66A1;
	Tue, 29 Sep 2026 09:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790674991; cv=none; b=hrZcFimRq5z+Pd1gJeRKmaxaaAGmin4nDZdg46WKrQGE1/fgo2r+JGf700ZgsfYzzFCG1MjnFiHEgqJIyIG98fmn8xwMQp2W9jIPoty4/BEyZzzM9io8p4cEHYNlDnKcymiYdXsyeRJYyr2KIFnf0H7IIgBbCVKamnT5O0dE73g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790674991; c=relaxed/simple;
	bh=FR04vb8vZ7yGo/R+Em3H86yxefQ/vSFAuFGINOTQAs0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UyEMMKHGbODbxyHzPn7N7auzocNNX7olUBIq7W0tMAKNRSTHrV3SqYiGuxFdJHgAEmgn2+jEVY385fZSht0/4LHrMfcPP8UY6LTxCFfUd6i/kUL+VKb+NcpHkRru0xLfgOtMXR2hRcJtLPgoTWIcKYg0g5GFP8mXRHmi9Dj46o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Cwk6rIxc; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Cwk6rIxc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790674986;
	bh=VBDi87v2GLxvQQ4svDlq2UlpLIBJkHt/1VL8QOI3SNg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Cwk6rIxcaBZbOorXwU9hr9r/7XJEBGXZGxRltmNj2IJGkniEIr17arRzX58Tjt0Wi
	 XGpn8z3S0fnRE9PPGwBkDZiDxhIUypdfG7JGrH/vPL+nC4AexshjQepSqHifzPSXGU
	 gJyM72GaR59ncBzsMUf4dpofvwvvcjKyggeSEcg48yhxRLevnVL6BDChlZy0YeRJ7e
	 38w1e3WSRAmPRWNoM9VEgDMdm3I4fccctB4Nl9WOMsyRsv+d0kuuPKpd5L3cVmgJqN
	 d19Hjs1D8/6drAu0Ru39+hTzmRZ1PRA4hjPn0zX+F5h1OuIgrpe/N0tOC8b//TvgGd
	 Nm/r62VBji4rw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 9779760262;
	Tue, 29 Sep 2026 11:43:06 +0200 (CEST)
Date: Tue, 29 Sep 2026 11:43:04 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Julian Anastasov <ja@ssi.bg>, netdev-bot+sashiko@kernel.org,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
	horms@kernel.org, fw@strlen.de
Subject: Re: [PATCH net 02/11] ipvs: fix buffer overflow when sending sync
 messages
Message-ID: <aruIKBhVhp3KKvJp@chamomile>
References: <20260927220816.268206-3-pablo@netfilter.org>
 <179063970014.3145.11099245705422825051@kernel.org>
 <2aa8af69-3843-3ffd-cfa4-2daf3c949127@ssi.bg>
 <634b26a1-cf1f-46c0-8026-c9c08f398169@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <634b26a1-cf1f-46c0-8026-c9c08f398169@redhat.com>

Hi Paolo,

On Tue, Sep 29, 2026 at 10:19:55AM +0200, Paolo Abeni wrote:
> On 9/29/26 06:06, Julian Anastasov wrote:
> > > > @@ -744,7 +749,7 @@ void ip_vs_sync_conn(struct netns_ipvs *ipvs, struct ip_vs_conn *cp, int pkts)
> > > >   		s->v4.vaddr = cp->vaddr.ip;
> > > >   		s->v4.daddr = cp->daddr.ip;
> > > >   	}
> > > > -	if (cp->flags & IP_VS_CONN_F_SEQ_MASK) {
> > > > +	if (seq_mask) {
> > > >   		*(p++) = IPVS_OPT_SEQ_DATA;
> > > >   		*(p++) = sizeof(struct ip_vs_sync_conn_options);
> > > >   		hton_seq(&cp->in_seq, (struct ip_vs_seq *)p);
> > > 
> > > [Severity: Medium]
> > > This is a pre-existing issue, not one introduced by this patch. The flags
> > > are now a consistent snapshot, but the sequence data is still read
> > > without cp->lock. Nothing orders that read against READ_ONCE(cp->flags).
> > > Can the master send stale or half-updated ip_vs_seq values here?
> > > 
> > > ip_vs_sync_conn() here only holds ipvs->sync_buff_lock. The same applies
> > > to the memcpy() of cp->sync_conn_opt in ip_vs_sync_conn_v0().
> > > 
> > > On the backup side, ip_vs_proc_conn() sets the SEQ bits in cp->flags under
> > > cp->lock and drops the lock. Only after that does it copy the sequence
> > > data, with no lock held:
> > > 
> > > net/netfilter/ipvs/ip_vs_sync.c:ip_vs_proc_conn() {
> > >      ...
> > > 		cp->flags = flags;
> > > 		spin_unlock_bh(&cp->lock);
> > >      ...
> > > 	if (opt) {
> > > 		cp->in_seq = opt->in_seq;
> > > 		cp->out_seq = opt->out_seq;
> > > 	}
> > >      ...
> > > }
> > > 
> > > On a node running both the master and backup daemons, ip_vs_sync_conn()
> > > could see seq_mask set and then send old or torn init_seq, delta and
> > > previous_delta values. A peer with an app bound to that connection would
> > > then apply the wrong TCP seq/ack adjustment after failover.
> > 
> > 	Agreed, this can be improved to take a snapshot of
> > flags and seqs together under lock. I'll request to drop
> > this version, it is not urgent to apply it.
>
> It looks like a respin of the PR is needed, I'll drop the revision from PW.

Just wrote to Jakub with a summary on the LLM report.

I would take this PR as is if it is still possible.

If you feel strong about to need to respin this PR, that's also fine
with me, just let confirm where to go.

Thanks.
