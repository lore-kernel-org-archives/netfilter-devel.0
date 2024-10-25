Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B399A18C93E
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Oct 2024 09:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729849604; cv=none; b=ILQ5c4Tp7QljuWBFWGAoT590zYpeuQg7Luv7sGbszVWgmKKLnpIm1UoPBycFPTjWHz7Ybz48QEgBGH33Kqmg7WdtKmsUVJM7eQxI3CGKNPOvcLp11nUHXq5JcJehSkkesYLa1IyeZW8Q7j2AZN/e0PfKFOO2j3HASZkhJ87MGWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729849604; c=relaxed/simple;
	bh=zz1x+FQ1dHlVSbVQDHJpcKHMJ4aWZ7euxPbuVYtzD/4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uTFw6RlWKsqugLjFKZi55fF37ndiAqLOaEdsfh83DRvs2llrVW3eQ6gJNOBfGQhTc7Jk2ejUYEGDIp8WmTZe6Ku4sZokuCLnrV4q1SClvrTjzsbE9L+ow5VzIGInHuVJN5A2vLeuUzUk5dcaNRES8G2qvMYJcv5ybrvxesUMk2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=DgpzlGp3; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="DgpzlGp3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TD0zqUSgL324TBeMIHvkqAMYNyKNLwAeB7LEb5o0zYU=; b=DgpzlGp3FV+O4XcEH4JzqB6nZ8
	sZXzthi1nUvJFX/QV9TEBvYcCoajrNv7txq0D9MpjhqkpgF2zyenwpgLFc9BuEZiG1jL4bHxRSIua
	K7wtNNiXghAGRwVo/Ee0KG7YDd+srTFizc89WlE8oyEBFmD5SAOShMMEA3vaE/cnyQXQcrcERQJMT
	WDV2arUs7CmpccOw4ihfa7GAjQcy1fnklp3DxtJCRr1FD1gjn5/cs++gHeAs3vNOJj/OeDluL7MFz
	aDOc5ZWs7teOy0SOo0TMinxfW+YwSF/iN6tDZsfWpKJwtkaM7vQyB5rg6tZS3Ou7z6xoFCoPOpEh7
	/dqTX4aA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t4Gtt-000000007pM-3dEs;
	Fri, 25 Oct 2024 11:46:33 +0200
Date: Fri, 25 Oct 2024 11:46:33 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Matthieu Baerts <matttbe@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>, coreteam@netfilter.org
Subject: Re: Netfilter: suspicious RCU usage in __nft_rule_lookup
Message-ID: <Zxto-TvgUAa1p9N9@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Matthieu Baerts <matttbe@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>, coreteam@netfilter.org
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
> 
> No idea what to do here.

It will vanish with my name-based netdev hooks series (the second part).
I could prepare a patch for nf/stable which merely kills that function -
dropping netdev-family chains upon removal of last interface is
inconsistent wrt. flowtables which remain in place.

Another alternative might be to call synchronize_rcu() in there, but it
slows down interface teardown AIUI.

Cheers, Phil
