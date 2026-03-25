Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2414E405AB0;
	Wed, 25 Mar 2026 17:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774459739; cv=none; b=i+RXxKCqu7NqhgU4aRX2ydbDXouzluVJUCVikRvg9HUBenNu3p5pEOcCWX/sT/tVKS20Jfh9o/jjJuU6k8I0tcybb3YuVc/GzQdS4wgJ0FTsogfWM4+3yBLe0LT5tK0CiDSNR0bfQG+uCa/UhxIc75+swPug17vK/UrF/kY1LKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774459739; c=relaxed/simple;
	bh=mZ5FCmbmEUI5S9A3jMuoQakyvUbkEdqp4jWuG5946Mc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZHCcEqFaQQah0yV2fG5pQOk8gDxXh8o+uc9XAd2UYnMAQWNYgbftU8vnfjqtjHSCWDym85kRB1YtsGnGYBMsbZ6TgowrpkN4FcO0H2TpSVnsvbAe5FRTwYF6P0HLhfsMj02rvcE0HCEcSSXkce/ki6ceWzUBk2IYTDyCGWx6NqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=j9Wga8q5; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="j9Wga8q5"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id CE23C600B5;
	Wed, 25 Mar 2026 18:28:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774459733;
	bh=fr7RHDf4eIASZHHxRVVoIlUiKoSTbIXLlIA9z4ENRyw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j9Wga8q50dMVs7JlhYI4TNBAXU2Y+i8YqJNTTWB4du53tuf9eaGfvnPGTpXdeMYfW
	 DuGAnOCxTSVh6MUhO2JbbOpfDrYdrEPEICg+pm791NXtw4OWBNUqXGNbEBVQxk0rhi
	 DFSWwglKO3MRiZYCgD6j2h41GZlMYQ6WJXwWybd/IxxmTR4uPpwsHrTGeDbagXtHZa
	 YRZzTCBifWYqvcgJ1CXC0ADAGYgK2b26nGvgn2hD2HHb5nqJNqsJoFkRWCfVGf2A2M
	 ZEZgmnbGw3TSnpfrJSiIiw4NUpmhd/7xUPI/YzLgctDLwghIYhXZOOqMXnnsXfiM2H
	 TwpSSOCVD7Fow==
Date: Wed, 25 Mar 2026 18:28:51 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net 10/14] netfilter: ctnetlink: ensure safe access to
 master conntrack
Message-ID: <acQbU0MndzrPpQ2A@chamomile>
References: <20260325131108.23045-1-fw@strlen.de>
 <20260325131108.23045-11-fw@strlen.de>
 <acQa30IdYh3PeLAh@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <acQa30IdYh3PeLAh@chamomile>

On Wed, Mar 25, 2026 at 06:26:58PM +0100, Pablo Neira Ayuso wrote:
> Hi Florian,
> 
> Sorry for this late followup incremental fix.
> 
> On Wed, Mar 25, 2026 at 02:11:04PM +0100, Florian Westphal wrote:
> > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > Holding reference on the expectation is not sufficient, the master
> > conntrack object can just go away, making exp->master invalid.
> 
> This patch needs this update for expectations which do not have
> nfct_help(ct), two cases:
> 
> - nft_ct creates
> - ip_vs_ftp
> 
> See attached incremental patch.

Sorry. Actually, This incremental fix is for:

  [PATCH net 08/14] netfilter: nf_conntrack_expect: honor expectation helper field

for the two cases I mentioned above.

> diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
> index 509d3eb6f56a..cf39662c4b97 100644
> --- a/net/netfilter/nf_conntrack_expect.c
> +++ b/net/netfilter/nf_conntrack_expect.c
> @@ -325,7 +325,9 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
>  		       u_int8_t proto, const __be16 *src, const __be16 *dst)
>  {
>  	struct net *net = read_pnet(&exp->master->ct_net);
> -
> +	struct nf_conntrack_helper *helper;
> +	struct nf_conn *ct = exp->master;
> +	struct nf_conn_help *help;
>  	int len;
>  
>  	if (family == AF_INET)
> @@ -336,7 +338,14 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
>  	exp->flags = 0;
>  	exp->class = class;
>  	exp->expectfn = NULL;
> -	rcu_assign_pointer(exp->helper, nfct_help(exp->master)->helper);
> +	help = nfct_help(ct);
> +	if (help) {
> +		helper = rcu_dereference(help->helper);
> +		if (helper)
> +			rcu_assign_pointer(exp->helper, help->helper);
> +	} else {
> +		exp->helper = NULL;
> +	}
>  	write_pnet(&exp->net, net);
>  	exp->zone = exp->master->zone;
>  	exp->tuple.src.l3num = family;

