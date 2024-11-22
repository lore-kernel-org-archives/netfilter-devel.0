Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AEF12E7F;
	Fri, 22 Nov 2024 13:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732283503; cv=none; b=QQPcidlWcGxRZKhu+O3bQy3GPhOvGan9Qah27OyVhJe/QxUSYH5UbYMzpuCRmJYynVC4XO37KL+NxHv23tt5As0TZmNowmp1w/YovGCc57ZLfC2Ug3c7d6jrgnnaksjXVhZDFcvlIIeN/mO+08vCgd3JLXXXwvGosapjklORw0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732283503; c=relaxed/simple;
	bh=4qVeJak5xPiALIaYDPf7rB81y+1EOLDU6utWS0UkEno=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VUuScUwDLHy1vF67x0rCva5gn/fXfB8/IJY8pLc9rEYla7wC98ESn+IfG4kQqvv4SxnfA/cnI1Ipmj3usYyz5xCtQuflLbP1qIGHC3y2oWGnhF8Lw6YYuDoYkhl2wGTiivAwKrHd8ZjTNK8WKpCpzE0UMZTwPP6ZLNDu1iJjuco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.39.247] (port=47062 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tEU4M-000qBh-6R; Fri, 22 Nov 2024 14:51:36 +0100
Date: Fri, 22 Nov 2024 14:51:33 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Pei Xiao <xiaopei01@kylinos.cn>, kadlec@netfilter.org,
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot+84d0441b9860f0d63285@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] netfilter: nf_tables: Use get_cpu_ptr in nft_inner_eval
Message-ID: <Z0CMZcpRfYFuXojU@calendula>
References: <673fca0e.050a0220.363a1b.012a.GAE@google.com>
 <804e05fe4615cfd51f0cc72307f578ea34a701b4.1732281838.git.xiaopei01@kylinos.cn>
 <20241122134529.GB17061@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241122134529.GB17061@breakpoint.cc>
X-Spam-Score: -1.8 (-)

On Fri, Nov 22, 2024 at 02:45:29PM +0100, Florian Westphal wrote:
> Pei Xiao <xiaopei01@kylinos.cn> wrote:
> > syzbot complain about using smp_processor_id in preemptible.
> > use get_cpu_ptr to preempt_disable.
> 
> > Reported-by: syzbot+84d0441b9860f0d63285@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=84d0441b9860f0d63285
> > Fixes: 0e795b37ba04 ("netfilter: nft_inner: add percpu inner context")
> > Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
> > ---
> >  net/netfilter/nft_inner.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/netfilter/nft_inner.c b/net/netfilter/nft_inner.c
> > index 928312d01eb1..ae85851bab77 100644
> > --- a/net/netfilter/nft_inner.c
> > +++ b/net/netfilter/nft_inner.c
> > @@ -248,7 +248,7 @@ static bool nft_inner_parse_needed(const struct nft_inner *priv,
> >  static void nft_inner_eval(const struct nft_expr *expr, struct nft_regs *regs,
> >  			   const struct nft_pktinfo *pkt)
> >  {
> > -	struct nft_inner_tun_ctx *tun_ctx = this_cpu_ptr(&nft_pcpu_tun_ctx);
> > +	struct nft_inner_tun_ctx *tun_ctx = get_cpu_ptr(&nft_pcpu_tun_ctx);
> >  	const struct nft_inner *priv = nft_expr_priv(expr);
> 
> This can't be right, where is it re-enabled?
> 
> Not related to your patch:
> Why is this percpu?  How is this softirq safe?

I can add an owner skbuff to nft_inner_tun_ctx area, so this
information can be canceled in case of softirq interference, then
trigger a reparsing of the header.
