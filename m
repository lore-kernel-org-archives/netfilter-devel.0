Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B451318DF6E
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Oct 2024 09:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729848242; cv=none; b=i5Q2d44njuZ2WGuU/n9tiznE/Q9vUdauQ1PX9Jt+qXbptFGot6vC3Z98w4IaV3XRGmjp0rKPYCCfgdQS9Ih7h3jWJ4X055duKtOTa2eOiEkvr1iCt3JYis6whYhCs1hYbUA2zpTXJ/L4WL1Q8rn2MZHL/EdExF1NLMoUH5zwL6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729848242; c=relaxed/simple;
	bh=dQCgZP77tdqylw1R4+0QqCqwqzbvG4l5TJkudqdsKBM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BeZRg+bVbdKyyX4xLoS4KFaXUzDnBeBOV6y4cqUwLkol6kOk/4n+mcDtrsbhYekCcpPY/EQbt8n3UVTEKl77tcGI3WJnTmPulEzuXnj6gcZ8tvrOglvJ8DzktXREvwPE4QCKVOTR4ZbfvvdGSorUBNjLtAJy8FtnF/bdEV56o1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t4GY0-0003G3-EN; Fri, 25 Oct 2024 11:23:56 +0200
Date: Fri, 25 Oct 2024 11:23:56 +0200
From: Florian Westphal <fw@strlen.de>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	coreteam@netfilter.org
Subject: Re: Netfilter: suspicious RCU usage in __nft_rule_lookup
Message-ID: <20241025092356.GA11843@breakpoint.cc>
References: <da27f17f-3145-47af-ad0f-7fd2a823623e@kernel.org>
 <ZxqKkVCnyOqHjFq-@calendula>
 <ZxqQAIlQx8C1E6FK@calendula>
 <20241024232230.GA23717@breakpoint.cc>
 <40d071e1-4c13-49c9-8cac-14c1377eaf86@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <40d071e1-4c13-49c9-8cac-14c1377eaf86@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Matthieu Baerts <matttbe@kernel.org> wrote:
> While at it, I had a question related to the rules' list: in
> __nft_release_basechain() from the same nf_tables_api.c file, list's
> entries are not removed with the _rcu variant → is it OK to do that
> because this function is only called last at the cleanup time, when no
> other readers can iterate over the list? So similar to what is done in
> __nft_release_table()?

Looks like __nft_release_basechain() is broken from start, I don't see
how it can work, it doesn't call synchronize_rcu or anything like that
afaics.

No idea what to do here.
