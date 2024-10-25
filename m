Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CB41D359A
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Oct 2024 09:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729849372; cv=none; b=XmtjwFm6t7f6lX765jjNsoJfLYTDLJIMVHHuBXbNnsKOoLphVNTMdk5SfGxC/S4E6Y9p9hd/eWBlJDxQf9VOilRVPF3754Kz8QuANVZ764ii0cYnSDms87Pt4X/Vn9wlw05Uho2X6uNx4ftEq6WHpbKSOcg7dS1AX6MvPtzuV0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729849372; c=relaxed/simple;
	bh=CbWoeWlXIgSGBAibf3EzY0ths1cIiLnXMRflye1XGXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=farZGwFlFBYRVI+GbFB2RI0tVEpFSX8DMRrHNED3aOwyriZpUTlqbCkxWbMsy3zTwLI20DBxQ6VZcnSic6nO2h13ZzEBH4Q/HmIhIDoZhChp7/kyHh0ljOuUuCGCKx9rT4DD2hiYnuVJyBsHiyp9y8C+bUbuPSnsUDSRpIP2L9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=56248 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t4GqB-007E18-3t; Fri, 25 Oct 2024 11:42:45 +0200
Date: Fri, 25 Oct 2024 11:42:42 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Matthieu Baerts <matttbe@kernel.org>, netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	coreteam@netfilter.org
Subject: Re: Netfilter: suspicious RCU usage in __nft_rule_lookup
Message-ID: <ZxtoEmxECw4r2O0m@calendula>
References: <da27f17f-3145-47af-ad0f-7fd2a823623e@kernel.org>
 <ZxqKkVCnyOqHjFq-@calendula>
 <ZxqQAIlQx8C1E6FK@calendula>
 <20241024232230.GA23717@breakpoint.cc>
 <40d071e1-4c13-49c9-8cac-14c1377eaf86@kernel.org>
 <20241025092356.GA11843@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241025092356.GA11843@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Fri, Oct 25, 2024 at 11:23:56AM +0200, Florian Westphal wrote:
> Matthieu Baerts <matttbe@kernel.org> wrote:
> > While at it, I had a question related to the rules' list: in
> > __nft_release_basechain() from the same nf_tables_api.c file, list's
> > entries are not removed with the _rcu variant → is it OK to do that
> > because this function is only called last at the cleanup time, when no
> > other readers can iterate over the list? So similar to what is done in
> > __nft_release_table()?
> 
> Looks like __nft_release_basechain() is broken from start, I don't see
> how it can work, it doesn't call synchronize_rcu or anything like that
> afaics.

Right, it should unregister hooks, then wait for rcu grace period, and
finally release objects.

> No idea what to do here.

I'm looking into this.
