Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4187E792
	for <netfilter-devel@vger.kernel.org>; Sun,  9 Aug 2026 14:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786284996; cv=none; b=S5kCx6ooU/pQsPinT4k7Bszp5Dykzl+1z7GoQmy/4ywUocPiqxFwfmXNjNa/5nr7wwDeFAxi98a0XvoWh9qcNlV+a/mBjYe86JAE9ZAXNX30MNdsvuX4N46ne+XLeFtkzr0vM3C/VS1g3aNCe6xh7RHHUEcp/3GmhU7sKeAe5q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786284996; c=relaxed/simple;
	bh=fzJQhvsfzK/VX7j5+ex7b6saww5IL8uqAa2Us2BvfGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oqLDQfXC8pLCJgbamUUnwx4kByUifyHJRDSL5e4c8nuh9xuqmVLCgjj3Bdsasst7aMkuxdYe972qVggwIgiT1nIrBRhrkSyjBxqubcimhxEUY9aB/jAf1UwukQI9JKhR0s80sL3mgfUJsdgUWXvXEt5wjmG7Ql9i6K4E6eiqCUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 91E496051B; Sun, 09 Aug 2026 16:16:32 +0200 (CEST)
Date: Sun, 9 Aug 2026 16:16:32 +0200
From: Florian Westphal <fw@strlen.de>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: ipset: fix list type element drift bug
Message-ID: <aniLwNENxpoK-qK2@strlen.de>
References: <20260806135341.8896-1-fw@strlen.de>
 <6082ea3a-15d3-650a-98a0-403b1bab7b5d@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6082ea3a-15d3-650a-98a0-403b1bab7b5d@netfilter.org>

Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>

Thanks for reviewing!

> > +	if (n) {
> >  		list_set_replace(set, e, n);
> > +		return 0;
> > +	}
> > +
> >  	else if (next)
> >  		list_add_tail_rcu(&e->list, &next->list);

While it makes no difference from correctness, the
above looks very weird, so I propose to turn the else if into plain if (next).

(Did not spot it before sending...).
