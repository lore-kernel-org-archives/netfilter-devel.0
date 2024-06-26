Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14AAD79CE;
	Wed, 26 Jun 2024 11:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719402090; cv=none; b=jbXnwtvhbSMV16+Joe0RdY7oWnBgckVkHbiQyY5L4f5tqcDAFQ6aSrZvMFFM8x6cl6jQ9B35lAak0MtadzeqnbK3gMOyXyNReZ+YiLhwkML/PrlZ9MI7W6paTEqGtyYVXwdIEOqpqqla2Bmw6Hd3dEHzicXWCmdQGbDdcXS6DVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719402090; c=relaxed/simple;
	bh=0KlVBMdfshBi0ZXObaucGAnJ917Dsu1uCjDMmmjZmHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FjUh/YcdIhFq1labJYiG3FuN9WDMZqjbosVl3smdRQJS/Pdr3fbAb+kxy7R1d1vRGQzjUeH71VJF+dus8VMF++kqt/mu4WJs+HJPup6CjF3XLwwnjwFwdQkbz/I/OxaJRRVJVWRHHhh7uH67F/3NJ7CLaVQpHDtCGIbaVoPvZkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=48270 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sMR1f-007swq-BN; Wed, 26 Jun 2024 13:41:25 +0200
Date: Wed, 26 Jun 2024 13:41:22 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: restore default behavior for
 nf_conntrack_events
Message-ID: <Znv-YuDbgwk_1gOX@calendula>
References: <20240604135438.2613064-1-nicolas.dichtel@6wind.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240604135438.2613064-1-nicolas.dichtel@6wind.com>
X-Spam-Score: -1.9 (-)

Hi Nicolas,

On Tue, Jun 04, 2024 at 03:54:38PM +0200, Nicolas Dichtel wrote:
> Since the below commit, there are regressions for legacy setups:
> 1/ conntracks are created while there are no listener
> 2/ a listener starts and dumps all conntracks to get the current state
> 3/ conntracks deleted before the listener has started are not advertised
> 
> This is problematic in containers, where conntracks could be created early.
> This sysctl is part of unsafe sysctl and could not be changed easily in
> some environments.
> 
> Let's switch back to the legacy behavior.

Maybe it is possible to annotate destroy events in a percpu area if
the conntrack extension is not available. This code used to follow
such approach time ago.
