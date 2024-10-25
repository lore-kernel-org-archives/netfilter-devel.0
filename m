Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDF71D54C7
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Oct 2024 10:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729852515; cv=none; b=eibXi3Dci8qIYK2OH28yQ5wFEgzDL+SoZ/Vw95nedV2oaCHJq53qf7WDW1n3r4VGHfF0k8mY5i17FIRb89eqX1pUtf6Rh6JF2Mc33BrixhYZ2DCIBLBrAc6wSyVXafu8PXlvEaANZ+X1tBPEfSLIZA81Fr8UxxI6kxx4hf8OVjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729852515; c=relaxed/simple;
	bh=sM6di1QgZacA3fpY2alHR7XjELVcUMJ8QwTYk6wuvPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j/W2BzJzgPIMH9ffJvxhIjwEWLjC7CqiE+3GpdSb26tNy1CFENN03sYwZYi1sOsGs8F0ImIAB6STLQJfPUgjiGm5GKhSH8uQUpLSIGq73Stf4lxFdidOo72oxbwOkLj+GtAWQrkQeVvkhKk3FGojmOXHUX0U79vcRHdO9JCjGtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=32798 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t4Hev-007N5q-CH; Fri, 25 Oct 2024 12:35:11 +0200
Date: Fri, 25 Oct 2024 12:35:08 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Matthieu Baerts <matttbe@kernel.org>, netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	coreteam@netfilter.org
Subject: Re: Netfilter: suspicious RCU usage in __nft_rule_lookup
Message-ID: <Zxt0XLj4OZPE-fx4@calendula>
References: <da27f17f-3145-47af-ad0f-7fd2a823623e@kernel.org>
 <ZxqKkVCnyOqHjFq-@calendula>
 <ZxqQAIlQx8C1E6FK@calendula>
 <20241024232230.GA23717@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241024232230.GA23717@breakpoint.cc>
X-Spam-Score: -1.8 (-)

On Fri, Oct 25, 2024 at 01:22:30AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > 
> > this comment below is also not valid anymore:
> > 
> > /* called with rcu_read_lock held */
> > static struct sk_buff *
> > nf_tables_getrule_single(u32 portid, const struct nfnl_info *info,
> >                          const struct nlattr * const nla[], bool reset)
> 
> Yes, either called with rcu read lock or commit mutex held.
> 
> > This is not the only spot that can trigger rcu splats.
> 
> Agree.  Will you make a patch or should I take a look?
> I'm leaning towards a common helper that can pass the
> right lockdep annotation, i.e. pass nft_net as arg to
> document when RCU or transaction semantics apply.

Please, go ahead if you have the time. Thanks.
