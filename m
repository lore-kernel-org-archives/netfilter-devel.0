Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF6B224F0
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Oct 2024 16:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728403895; cv=none; b=GBjxnS7UUawMVFcy8ycWT2jgg5XDkpDBHVlKZk+H+jIjbYLtjcUGZ0OvFu3yydI1MXmmIpZPPf/0R9HXxOX08Af9yUivN5CJpaO582msy8j7DAgWUsl4H0C1jQfEwrKHWAg4McHrV7BwkbSzd2kJn0/b5RwYPN0bD/3yodLibqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728403895; c=relaxed/simple;
	bh=BN7EAEw1Sz598RRo+J1zTCT4cqJh8mLYSSfAksnsbj4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=celoRCIonWAyQ06BeWPC8OiaodDgffYJqcxn6Khh98t/tpmvM0eNhsA5wOgNs7XSwYtjlfaRGVOXtK3XQoWZXunbNT1FLyDMHN1yWxB8sn6n3ITKdpNnCW6wOUow0w9bVSre5TChxN6dh1WL5SKq3V3bLYAglW4yVcwOW4AI6Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1syCo5-0003uq-L2; Tue, 08 Oct 2024 18:11:29 +0200
Date: Tue, 8 Oct 2024 18:11:29 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnftnl 1/5] expr: add and use incomplete tag
Message-ID: <20241008161129.GA14954@breakpoint.cc>
References: <20241007094943.7544-1-fw@strlen.de>
 <20241007094943.7544-2-fw@strlen.de>
 <ZwUT3LGOMW_PPXFr@calendula>
 <20241008121702.GA3610@breakpoint.cc>
 <ZwVFA_0gJCwvaT0i@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwVFA_0gJCwvaT0i@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > That would work too. I don't really get mnl_attr_type_valid().
> 
> mnl_attr_type_valid() can go away if all switch() are audited, yes, it
> is just defensive.

> > All of the callbacks have a switch statement, so anything not handled
> > is 'unknown'.
> > But if you prefer the mnl_attr_type_valid() use then I can rewrite it.
> 
> There is also _PAD attributes that maybe trigger default case.

Right, I'll probably change it to only care about 'mnl_attr_type_valid
returns false'.
