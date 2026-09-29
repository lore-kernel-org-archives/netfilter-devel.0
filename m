Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462BF50C291;
	Tue, 29 Sep 2026 10:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790677642; cv=none; b=ZApUuBdW8dufB3SjZAuail2UhylagUpxB9OwFpLFYo7hTE+i3QovKVP25p+S/gpscRILiy7/FxEVZC4iLdk9HJaQjx+FvymMfbCJKxHFx1ECvSbBGbnZDxzOSotvdiiONrurdA9lJxQXMIT4x3GG4lauvhrq6TPi81rGJNdLFMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790677642; c=relaxed/simple;
	bh=yYsWTOgE2HuLS/Ptf5JGliz68o7bjAWc2Zg8+RSNoac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D1gPWHBVISvX25GOFJ5P3Y67GPrPdslrtYu0KxGv/mn6NnnvVRuDO106w8qHb18HDXj7XoWGgBELKdQskAA7flQ0ZqKe1E9/YvYwqImPIQssFNFArp2BjQ3YDKcHxUwb7m8bJPpNNt7z44h0Gg0LE91JBsPgzmp6JoWL+m5Q3wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qdNfpRN8; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qdNfpRN8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790677622;
	bh=37ud5Y+ktqC5GdoQ50TkRBZqS2diQRdsjUlxYSpnzoA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qdNfpRN8LcWLlvRvJKLEyOeGGdSpH38yNNps/q/mGXjY6h4h4KchMOVXgH3WeLTvi
	 nyD7a3fSZ0tIXjtYVqn7WT6CUgQhvY07ZlrLkGtWYT+1GQzhdd6Hi4dnYXBP84xjMj
	 kgjDo0wW9nyDV3xx/cjYwoqq46kgyiXpgbTfAoqHz7GhM+7r800uAMi0zKRyNgyLgf
	 VM2rZuUDDTkHwEPTU6KX+Pwdr78sxDFuDSqRFnW3Hq1P3KkeVvEBrtSD0IydAEhIes
	 7SL9gKy/u3+eF8zX+RgbENbkO+iQ0DOfRMmr8UCs3iH052ybxo8jfqVFczanQIFDIU
	 VteuN5frYn48g==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 6888D6020E;
	Tue, 29 Sep 2026 12:27:02 +0200 (CEST)
Date: Tue, 29 Sep 2026 12:27:00 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Julian Anastasov <ja@ssi.bg>, netdev-bot+sashiko@kernel.org,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
	horms@kernel.org, fw@strlen.de
Subject: Re: [PATCH net 02/11] ipvs: fix buffer overflow when sending sync
 messages
Message-ID: <aruSdAPXTRbH430w@chamomile>
References: <20260927220816.268206-3-pablo@netfilter.org>
 <179063970014.3145.11099245705422825051@kernel.org>
 <2aa8af69-3843-3ffd-cfa4-2daf3c949127@ssi.bg>
 <634b26a1-cf1f-46c0-8026-c9c08f398169@redhat.com>
 <aruIKBhVhp3KKvJp@chamomile>
 <f5766ebd-7436-4c82-a835-49d09b68ce0f@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f5766ebd-7436-4c82-a835-49d09b68ce0f@redhat.com>

On Tue, Sep 29, 2026 at 11:55:11AM +0200, Paolo Abeni wrote:
> On 9/29/26 11:43, Pablo Neira Ayuso wrote:
> > Hi Paolo,
> > 
> > On Tue, Sep 29, 2026 at 10:19:55AM +0200, Paolo Abeni wrote:
> > > On 9/29/26 06:06, Julian Anastasov wrote:
> > > > > > @@ -744,7 +749,7 @@ void ip_vs_sync_conn(struct netns_ipvs *ipvs, struct ip_vs_conn *cp, int pkts)
> > > > > >    		s->v4.vaddr = cp->vaddr.ip;
> > > > > >    		s->v4.daddr = cp->daddr.ip;
> > > > > >    	}
> > > > > > -	if (cp->flags & IP_VS_CONN_F_SEQ_MASK) {
> > > > > > +	if (seq_mask) {
> > > > > >    		*(p++) = IPVS_OPT_SEQ_DATA;
> > > > > >    		*(p++) = sizeof(struct ip_vs_sync_conn_options);
> > > > > >    		hton_seq(&cp->in_seq, (struct ip_vs_seq *)p);
> > > > > 
> > > > > [Severity: Medium]
> > > > > This is a pre-existing issue, not one introduced by this patch. The flags
> > > > > are now a consistent snapshot, but the sequence data is still read
> > > > > without cp->lock. Nothing orders that read against READ_ONCE(cp->flags).
> > > > > Can the master send stale or half-updated ip_vs_seq values here?
> > > > > 
> > > > > ip_vs_sync_conn() here only holds ipvs->sync_buff_lock. The same applies
> > > > > to the memcpy() of cp->sync_conn_opt in ip_vs_sync_conn_v0().
> > > > > 
> > > > > On the backup side, ip_vs_proc_conn() sets the SEQ bits in cp->flags under
> > > > > cp->lock and drops the lock. Only after that does it copy the sequence
> > > > > data, with no lock held:
> > > > > 
> > > > > net/netfilter/ipvs/ip_vs_sync.c:ip_vs_proc_conn() {
> > > > >       ...
> > > > > 		cp->flags = flags;
> > > > > 		spin_unlock_bh(&cp->lock);
> > > > >       ...
> > > > > 	if (opt) {
> > > > > 		cp->in_seq = opt->in_seq;
> > > > > 		cp->out_seq = opt->out_seq;
> > > > > 	}
> > > > >       ...
> > > > > }
> > > > > 
> > > > > On a node running both the master and backup daemons, ip_vs_sync_conn()
> > > > > could see seq_mask set and then send old or torn init_seq, delta and
> > > > > previous_delta values. A peer with an app bound to that connection would
> > > > > then apply the wrong TCP seq/ack adjustment after failover.
> > > > 
> > > > 	Agreed, this can be improved to take a snapshot of
> > > > flags and seqs together under lock. I'll request to drop
> > > > this version, it is not urgent to apply it.
> > > 
> > > It looks like a respin of the PR is needed, I'll drop the revision from PW.
> > 
> > Just wrote to Jakub with a summary on the LLM report.
> > 
> > I would take this PR as is if it is still possible.
> > 
> > If you feel strong about to need to respin this PR, that's also fine
> > with me, just let confirm where to go.
>
> Uhm... I must admit that given the pressure we received from Linus on
> shrinking/prevent from increasing the net PR size I think we are better
> off dropping patch 2/11 entirely.
> 
> I'm sorry for the extra work, but the messaging from Linus was pretty
> strong:
> 
> https://lore.kernel.org/netdev/CAHk-=wiSnTE9vBZ=5_v+3EEkdazCCbBM5YABRzRHUAeRdyd4Xw@mail.gmail.com/

Yes, I read that. I tried to move what is less relevant to nf-next (if
you look at my nf-next PR, it's contains not so relevant fixes too).

 include/linux/netdevice.h               |  3 ++
 include/net/netfilter/nf_flow_table.h   |  2 +-
 net/mac80211/iface.c                    |  7 +++++
 net/netfilter/ipset/ip_set_bitmap_gen.h |  2 +-
 net/netfilter/ipvs/ip_vs_conn.c         |  3 ++
 net/netfilter/ipvs/ip_vs_lblc.c         |  4 +++
 net/netfilter/ipvs/ip_vs_lblcr.c        |  3 ++
 net/netfilter/ipvs/ip_vs_sync.c         | 56 ++++++++++++++++++++++++++-------
 net/netfilter/nf_flow_table_core.c      |  7 ++++-
 net/netfilter/nf_flow_table_offload.c   | 14 +++------
 net/netfilter/nf_flow_table_path.c      |  3 ++
 net/netfilter/nf_nat_bpf.c              |  3 ++
 net/netfilter/nf_nat_core.c             |  5 +--
 net/netfilter/nft_flow_offload.c        |  7 ++++-
 net/netfilter/nft_set_rbtree.c          |  2 ++
 net/sched/act_ct.c                      |  2 +-
 16 files changed, 95 insertions(+), 28 deletions(-)

Yes, this patch is larger in the diffstat. I can just move it to
nf-next if you prefer.

I will respin and send v2 today without this.

Thanks.
