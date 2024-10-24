Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5B81B392C
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Oct 2024 23:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729812162; cv=none; b=in+sVrwX8PYndncN2VP59RKVL4to7dT7xCu0oqOWlIAioBTeIwoH+MVf9TDtqjWRHi1+U1ew72W6glVPkaNlfflYnSLdqLMb6uLgNBept407Zrdi2xcKDaVdC00Eh58a/JNwg8ujZwD52dhpwDffgg6SqtsFnnofN9/MyhOXj8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729812162; c=relaxed/simple;
	bh=2p/112EE+U7PY80TwESyaD069SCvirWc1mLBsTz3QrQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nQdOk1l/RUv1jQ4vFXM6P/oHw/4OcxllxFoqhFmCVqGCw5MM41hxxjGTGCD4c5WC9la5raHgZpvSpqlhCuiTWWGuchvhrl7qvTfODqQaS1YVIvf9pihVcP5rUY7jQvQ4s+3qqvnQ7BOXpiw6AInXE9EXT24m09OJncn479tN8lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t479y-0006BT-M3; Fri, 25 Oct 2024 01:22:30 +0200
Date: Fri, 25 Oct 2024 01:22:30 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Matthieu Baerts <matttbe@kernel.org>, netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	coreteam@netfilter.org
Subject: Re: Netfilter: suspicious RCU usage in __nft_rule_lookup
Message-ID: <20241024232230.GA23717@breakpoint.cc>
References: <da27f17f-3145-47af-ad0f-7fd2a823623e@kernel.org>
 <ZxqKkVCnyOqHjFq-@calendula>
 <ZxqQAIlQx8C1E6FK@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxqQAIlQx8C1E6FK@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> this comment below is also not valid anymore:
> 
> /* called with rcu_read_lock held */
> static struct sk_buff *
> nf_tables_getrule_single(u32 portid, const struct nfnl_info *info,
>                          const struct nlattr * const nla[], bool reset)

Yes, either called with rcu read lock or commit mutex held.

> This is not the only spot that can trigger rcu splats.

Agree.  Will you make a patch or should I take a look?
I'm leaning towards a common helper that can pass the
right lockdep annotation, i.e. pass nft_net as arg to
document when RCU or transaction semantics apply.
