Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399DB406267
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 14:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779807580; cv=none; b=VTvZziSAe2hpjMbuANr53G9Bnk0cdwkGAhsRIUVYcVbxNP5vUzax9YsqV2zTpKJtRHQdxup54Wt7DwqXXh50vzkb9fZbi9vJvM5ILDbjUB1TWmIjUDp4v0DHZMHgdOs2ZJBqnSxo8MBy6ZDj9qVdrtPYStPitWV4egeNSm2D9II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779807580; c=relaxed/simple;
	bh=I7C3lp05io5pycwhL8Zp/PXI0hfM6PP1JAa+4ekR14o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K5HFmN5hwT/+hGQ4k25g303fBRXnWhEsejWJ9guhrWmVaEz6stBHJ1f5n5UfUXjgpprkSa5czxfjWTHdeVQ8oRaTNjdpL/K60uowD26GTB4nAynvKZA7XPp2ZgSBDCigrFM6HfBifxpJOnlIIeFBiEckhd5xICtyZBFgGNZxFJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gU4s8MBA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gU4s8MBA"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 66BD26017E;
	Tue, 26 May 2026 16:59:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1779807574;
	bh=K/MrEbeFujl10iXMmzaxkOXtDMI74itlFgnnuu0gFc0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gU4s8MBARpha70nHWtlL8JRWLY8hGY3OMo6Eji9Va9/8nf0wcDUcW3eoVt/EbNiRR
	 RXa5KQlEvhlbL8l5jWnKLXv/vobzHCnV4UXKfNIW/LPAetpPQrf/UHnmorzq5E3yI+
	 081djKTIwdgGcUZMHoCb6PmXmBidf3SzfT3jIGnmNYtOGF9JmmiIvIHgZgEs6DMTYB
	 +G2uM8izZoxZc3C9DUuQMZ/AHos4fmhu8UsfIFrZOq3gHsIrWYszz5KgPiCyXsKcV8
	 OsPw4iR9sOtKrViYizhxhWl/gg9Eq1Sr2ySUE/XIGAl+Y+kCoWFkIvT6dSzb2bFi2G
	 q7tCFrSgbHUtg==
Date: Tue, 26 May 2026 16:59:31 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, fw@strlen.de,
	phil@nwl.cc
Subject: Re: [PATCH 4/5 nf-next v3] netfilter: synproxy: protect
 nf_ct_seqadj_init() with conntrack lock
Message-ID: <ahW1U9_ESybsuAlv@chamomile>
References: <20260526141838.4191-1-fmancera@suse.de>
 <20260526141838.4191-5-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260526141838.4191-5-fmancera@suse.de>

Hi Fernando,

linux$ git grep nf_ct_seqadj_init
net/netfilter/nf_conntrack_seqadj.c:int nf_ct_seqadj_init(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
net/netfilter/nf_conntrack_seqadj.c:EXPORT_SYMBOL_GPL(nf_ct_seqadj_init);
net/netfilter/nf_synproxy_core.c:                       nf_ct_seqadj_init(ct, ctinfo, synproxy->isn -
net/netfilter/nf_synproxy_core.c:               nf_ct_seqadj_init(ct, ctinfo, 0);
net/netfilter/nf_synproxy_core.c:               nf_ct_seqadj_init(ct, ctinfo, synproxy->isn - ntohl(th->seq));
net/netfilter/nf_synproxy_core.c:                       nf_ct_seqadj_init(ct, ctinfo, synproxy->isn -
net/netfilter/nf_synproxy_core.c:               nf_ct_seqadj_init(ct, ctinfo, 0);
net/netfilter/nf_synproxy_core.c:               nf_ct_seqadj_init(ct, ctinfo, synproxy->isn - ntohl(th->seq));

On Tue, May 26, 2026 at 04:18:37PM +0200, Fernando Fernandez Mancera wrote:
> diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
> index 5413133a42fa..3e02e252eecc 100644
> --- a/net/netfilter/nf_synproxy_core.c
> +++ b/net/netfilter/nf_synproxy_core.c
> @@ -669,8 +669,10 @@ ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
>  	switch (state->state) {
>  	case TCP_CONNTRACK_CLOSE:
>  		if (th->rst && CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL) {
> +			spin_lock_bh(&ct->lock);
>  			nf_ct_seqadj_init(ct, ctinfo, synproxy->isn -
>  						      ntohl(th->seq) + 1);
> +			spin_unlock_bh(&ct->lock);
>  			break;

Maybe add the spin_lock to nf_ct_seqadj_init() given synproxy is the
only user of this function?

>  		}
>  
