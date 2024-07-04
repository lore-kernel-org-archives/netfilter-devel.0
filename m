Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9261822E2;
	Thu,  4 Jul 2024 13:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720101111; cv=none; b=RTXH8pUGNi3L+Q+CGFe+7zHlm/KqhQTiS0VCNXaFa4b7vLJEEkQREBubKikXR6GUjK7GtDOob5Vv5cSEZBjXG2sNZJTVNM+LE5+UDcxDCPcugiB09JBbT14HJargmCfY8XQjF/UkksbQ+fO1HhVJyTPymyzIutr5hRC3ycu6C4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720101111; c=relaxed/simple;
	bh=j7y3SaNZOdZ/qlSujb8S0Jm/YN/yBFAlgHfB7bnQva4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iYJYXGfVF4yL4UAr+DWvkVDfvIh1Grr9LkYnWTHYx4vaHqP63ZmfywIsQdGomfGevvL2jgD0UTMlIFUCZ/v0T01X0GRngxxYnDUl5FenW5m3nixMfCIezTI5HbKOtoPGeqCL6Qsqq1fm2K9OJCdFZ8EGAf437Sv3a9UeOoEZ0l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=48078 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sPMWm-004unV-LC; Thu, 04 Jul 2024 15:29:39 +0200
Date: Thu, 4 Jul 2024 15:29:34 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
	fw@strlen.de
Subject: Re: [PATCH net 1/1] netfilter: nf_tables: unconditionally flush
 pending work before notifier
Message-ID: <ZoajvtlIVk3mNMk7@calendula>
References: <20240703223304.1455-1-pablo@netfilter.org>
 <20240703223304.1455-2-pablo@netfilter.org>
 <af0c0ca73af3d4442d2de49c54fa58d3d2b759af.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <af0c0ca73af3d4442d2de49c54fa58d3d2b759af.camel@redhat.com>
X-Spam-Score: -1.8 (-)

On Thu, Jul 04, 2024 at 03:24:17PM +0200, Paolo Abeni wrote:
> Hi,
> 
> On Thu, 2024-07-04 at 00:33 +0200, Pablo Neira Ayuso wrote:
> > From: Florian Westphal <fw@strlen.de>
> > 
> > syzbot reports:
> > 
> > KASAN: slab-uaf in nft_ctx_update include/net/netfilter/nf_tables.h:1831
> > KASAN: slab-uaf in nft_commit_release net/netfilter/nf_tables_api.c:9530
> > KASAN: slab-uaf int nf_tables_trans_destroy_work+0x152b/0x1750 net/netfilter/nf_tables_api.c:9597
> > Read of size 2 at addr ffff88802b0051c4 by task kworker/1:1/45
> > [..]
> > Workqueue: events nf_tables_trans_destroy_work
> > Call Trace:
> >  nft_ctx_update include/net/netfilter/nf_tables.h:1831 [inline]
> >  nft_commit_release net/netfilter/nf_tables_api.c:9530 [inline]
> >  nf_tables_trans_destroy_work+0x152b/0x1750 net/netfilter/nf_tables_api.c:9597
> > 
> > Problem is that the notifier does a conditional flush, but its possible
> > that the table-to-be-removed is still referenced by transactions being
> > processed by the worker, so we need to flush unconditionally.
> > 
> > We could make the flush_work depend on whether we found a table to delete
> > in nf-next to avoid the flush for most cases.
> > 
> > AFAICS this problem is only exposed in nf-next, with
> > commit e169285f8c56 ("netfilter: nf_tables: do not store nft_ctx in transaction objects"),
> > with this commit applied there is an unconditional fetch of
> > table->family which is whats triggering the above splat.
> > 
> > Fixes: 2c9f0293280e ("netfilter: nf_tables: flush pending destroy work before netlink notifier")
> > Reported-and-tested-by: syzbot+4fd66a69358fc15ae2ad@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=4fd66a69358fc15ae2ad
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  net/netfilter/nf_tables_api.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index e8dcf41d360d..081c08536d0f 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -11483,8 +11483,7 @@ static int nft_rcv_nl_event(struct notifier_block *this, unsigned long event,
> >  
> >  	gc_seq = nft_gc_seq_begin(nft_net);
> >  
> > -	if (!list_empty(&nf_tables_destroy_list))
> > -		nf_tables_trans_destroy_flush_work();
> > +	nf_tables_trans_destroy_flush_work();
> >  again:
> >  	list_for_each_entry(table, &nft_net->tables, list) {
> >  		if (nft_table_has_owner(table) &&
> 
> It look like there is still some discussion around this patch, but I
> guess we can still take it and in the worst case scenario a follow-up
> will surface, right?

Let's do that.

Thanks.
