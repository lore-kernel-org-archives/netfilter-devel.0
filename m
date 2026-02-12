Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9B23EBF3F
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Feb 2026 20:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770929365; cv=none; b=HG1FyjOJVk7ImSnyEhwd6FzJIvYEduTk635tTk2oWziW56vEDQiB3gWsHi+YZAQ5fsE5wyrCSfNaI+CUpjvWzcrD/ZGVpO6s6Bs0ZS02OVhBDnzL2Eef094BMnrP1qHpEGuc/dVKJWd6EMYdbdZa78tSHi9an0ArKgN7gntgTBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770929365; c=relaxed/simple;
	bh=V89Om4o3zfSXzJP8NSPkcH24VsY37fyRoRJp2odG2RU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KBiZ6H/t/zLnWu5d25p1R1ZiniJfDwkDhjtWUG0tDnCOWG9KGPOQzpQY4OO2j9XPJzkrYvEDkwoR1uiEnJBnZlZJf6X5SlLfF4lBab3EOz5lojpKe0lcHnX9Oy+XIFS8yu+1NWIQtJYNJbTsbLXgTwEAHjAM1lrM94kGafj7Cjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=JoQPTlkO; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="JoQPTlkO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bWs7mf5uOcefwncWEKCiAj6CDC6nJzhguXuURyaZ16c=; b=JoQPTlkOsX116BqgG3gOjXiEFI
	dB/BFsXuYKpMzphxc7531pQCl12vpStjjiJZb3/uA+VDcO5hXbNTfYE0zUyLiChgBwpEKZ4VSReUD
	fQDAeAWMrRkkZ/zBEpKaNdUVCnhULGomGYvoZUKtTrwWYeGUkumdn/mvHkTLz9IubkOxoZ8hKMbE0
	1gGJtIGZAWzpMyqYFYS4e+KvICHSA/dh8VEZX+Y3qpc4+V9cc4tntRHtEh6+DzeAZzSBPD6ddmJAB
	t42FZ7S3CWgAHJ6ZOhScEOaBTZtbSExM0Aq1BaAqikVnX3Tn4RFB2nfjgQWLTV8IQ+j/SxXgYYFm2
	0c4t8ZCA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vqdcg-000000005Ea-1bYq;
	Thu, 12 Feb 2026 21:49:14 +0100
Date: Thu, 12 Feb 2026 21:49:14 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v3] configure: Implement --enable-profiling option
Message-ID: <aY48ymBNNYGL46fR@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20260211201503.27186-1-phil@nwl.cc>
 <aY0Z63yPjQoXYp9b@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aY0Z63yPjQoXYp9b@strlen.de>

On Thu, Feb 12, 2026 at 01:08:17AM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > This will set compiler flag --coverage so code coverage may be inspected
> > using gcov.
> > 
> > In order to successfully profile processes which are killed or
> > interrupted as well, add a signal handler for those cases which calls
> > exit(). This is relevant for test cases invoking nft monitor.
> >
> > index 0000000000000..912ead9d7eb94
> > --- /dev/null
> > +++ b/src/profiling.c
> > @@ -0,0 +1,36 @@
> > +/*
> > + * Copyright (c) Red Hat GmbH.  Author: Phil Sutter <phil@nwl.cc>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 (or any
> > + * later) as published by the Free Software Foundation.
> > + */
> > +
> > +#include <nft.h>
> > +#include <profiling.h>
> > +
> > +#include <signal.h>
> > +#include <stdio.h>
> > +
> > +static void termhandler(int signo)
> > +{
> > +	switch (signo) {
> > +	case SIGTERM:
> > +		exit(143);
> > +	case SIGINT:
> > +		exit(130);
> 
> Unfortunately I can't find exit(3) in the list of async-signal safe
> functions, so I have to assume this isn't allowed.

You're right. At least since exit() runs atexit() callbacks, it is very
unlikely this is async-signal-safe.

> From a quick glance, I would suggest to either use self-pipe-trick, or,
> given nft is linux specific anyway, use signalfd(2) instead of a
> traditional handler; then, stuff the fd into mnl_nft_event_listener
> select().

I'll go with signalfd() as it's simpler than the self-pipe and hooking
into mnl_nft_event_listener is required in both cases.

> Sorry, I did not think of this earlier.  If I'm wrong and this is safe,

Thanks for the pointers! I'm not very familiar with writing signal
handlers.

Cheers, Phil
