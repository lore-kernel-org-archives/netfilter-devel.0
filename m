Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F691917C2;
	Thu, 22 May 2025 19:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747942572; cv=none; b=r/PA5z9WF0M/Kp0yzgO6QA9yf2IdyC+tl/tfb83PBQiDoT4BiUycTH3VEMo1fE5OBQhmYHqB0HcZSZk6a9gmHfLusgj0iU5d8jXJ57UJu/RnP3xjQFZzx/XRBDVgqvXY/9xfbVbq5yQoV8AslQGEE4tASs9j+oG3oYQU/YiyOOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747942572; c=relaxed/simple;
	bh=z1nOD9vMDLur3enpYZSVa3zHV+WwYQAJsNhj4rsHVB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AG7dWtrhtWKlxxn/3Q0d3iCjGg3XnZXJu3o22wQEFf9znJ4zHoulgFgL+1JvmFEopJT8NmWIdAED+SBWsez4MCyDA2yW/cVmxBteesuW5HHt5TnFZL6tYJgg8/7Jmv2RDqOLf9xPTVBRwjxFgPVGAWpWbCSlUnlyQPdYGma2uhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id F283F602E7; Thu, 22 May 2025 21:36:06 +0200 (CEST)
Date: Thu, 22 May 2025 21:32:23 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: lvxiafei <xiafei_xupt@163.com>, coreteam@netfilter.org,
	davem@davemloft.net, edumazet@google.com, horms@kernel.org,
	kadlec@netfilter.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
	lvxiafei@sensetime.com, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH V6] netfilter: netns nf_conntrack: per-netns
 net.netfilter.nf_conntrack_max sysctl
Message-ID: <aC97x6CHFleb54i0@strlen.de>
References: <20250407095052.49526-1-xiafei_xupt@163.com>
 <20250415090834.24882-1-xiafei_xupt@163.com>
 <aC96AHaQX9WVtln5@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aC96AHaQX9WVtln5@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > -        to nf_conntrack_buckets by default.
> > -        Note that connection tracking entries are added to the table twice -- once
> > -        for the original direction and once for the reply direction (i.e., with
> > -        the reversed address). This means that with default settings a maxed-out
> > -        table will have a average hash chain length of 2, not 1.
> > +    - 0 - disabled (unlimited)
> 
> unlimited is too much, and the number of buckets is also global, how
> does this work?

Its an historic wart going back to ip_conntrack - it was never the
default but you could disable any and all limits even in the original
version.

Wether its time to disallow 0 is a different topic and not related to this patch.

I would argue: "yes", disallow 0 -- users can still set INT_MAX if they
 want and that should provide enough rope to strangle yourself.

> > +    The limit of other netns cannot be greater than init_net netns.
> > +    +----------------+-------------+----------------+
> > +    | init_net netns | other netns | limit behavior |
> > +    +----------------+-------------+----------------+
> > +    | 0              | 0           | unlimited      |
> > +    +----------------+-------------+----------------+
> > +    | 0              | not 0       | other          |
> > +    +----------------+-------------+----------------+
> > +    | not 0          | 0           | init_net       |
> > +    +----------------+-------------+----------------+
> > +    | not 0          | not 0       | min            |
> > +    +----------------+-------------+----------------+

I think this is fine, it doesn't really change things from init_net
point of view.
