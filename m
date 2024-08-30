Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59307DA94;
	Fri, 30 Aug 2024 14:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725026965; cv=none; b=dy6zBI3GqDNfIiMv2bNSpYv3fVC5GRiPtDGtXHVDYdLjkevKGbirFG/B8GHaws2cxzisy3FpLNE60QSx+LVZsIO+tyVLzGXg6sRp/wyvcv3OokfVYhB/W2LTht4bGKSeKSdLmTie4LVGWc4awzI1oeBXHFCRPOmZraAx+B88ZQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725026965; c=relaxed/simple;
	bh=XLrJlY3FxfBezztJFFJFbdObLSlHH3/bC2LipoSvUXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kagX4Pgdh/RRsMkmOodCai4mnmvyOp8QnnoBU9T7u9g/qFHHNvKKjC1CnHV7H0a0iIvPzu7uuNDmApXpiwjWuo9JfSEjGdVeAu61TjxbC266Q2UGzXlsmo25tcs77s0stI7mgsuFLJzcNrvzR9uz0TNgDbL7pHEIiBawiH1fTDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sk2JK-00080z-Q5; Fri, 30 Aug 2024 16:09:10 +0200
Date: Fri, 30 Aug 2024 16:09:10 +0200
From: Florian Westphal <fw@strlen.de>
To: Breno Leitao <leitao@debian.org>
Cc: Florian Westphal <fw@strlen.de>, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	David Ahern <dsahern@kernel.org>, rbc@meta.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	"open list:NETFILTER" <coreteam@netfilter.org>
Subject: Re: [PATCH nf-next v4 1/2] netfilter: Make IP6_NF_IPTABLES_LEGACY
 selectable
Message-ID: <20240830140910.GA30623@breakpoint.cc>
References: <20240829161656.832208-1-leitao@debian.org>
 <20240829161656.832208-2-leitao@debian.org>
 <20240829162512.GA14214@breakpoint.cc>
 <ZtG/Ai88bIRFZZ6Y@gmail.com>
 <20240830131301.GA28856@breakpoint.cc>
 <ZtHRZwYGQDVueUlY@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZtHRZwYGQDVueUlY@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Breno Leitao <leitao@debian.org> wrote:
> > I thunk patch is fine, I will try to add the relevant
> > depends-on change some time in the near future.
> 
> I am more than happy to do it, if you wish. I just want to decouple both
> changes from each other.

Ah, that makes sense to me.

The "depends" change would be good to have, see
https://lore.kernel.org/netfilter-devel/20240813183202.GA13864@breakpoint.cc/

(TL;DR: PREEMPT_RT requirements would need more surgery in old
 x_tables infra)
