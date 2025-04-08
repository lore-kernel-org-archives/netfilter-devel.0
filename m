Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7887267392;
	Tue,  8 Apr 2025 09:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744106350; cv=none; b=Lf1BJpf/kZK4kU0a24BhifkRZwUStuouaDgVribKhfYAWHgZ0xrZZQTRfNvUx+NLaS/Um8mR6VGFN/eucIHvlErrII8bn74zbTktiAHe957JjuRomAaaycrRKZP+jG7jdBczN7YM1tnx0okmhMoO7jSCUUkrsGxPIbaDPwSbBXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744106350; c=relaxed/simple;
	bh=bfZZ8hhxwTjULubKWB6fvth7YGatOY7Rn3r9fTg/XNU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VYWAB40UFsqPVEJgNe+BKWAIZLesRMbCB30iyq9o8l8C050H6VzPfoWlpPGSIDMjWnVNoDnss749fTrrq6oTWoZipTNbvd1K8/nto5zNZC9SeeRe7vXCwSSbklerCmGZscYVXd0uxnT//Q5lHr0lnjzEh05zjDEdXBBVQuAdT3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u25jK-0000GP-U1; Tue, 08 Apr 2025 11:58:54 +0200
Date: Tue, 8 Apr 2025 11:58:54 +0200
From: Florian Westphal <fw@strlen.de>
To: lvxiafei <xiafei_xupt@163.com>
Cc: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
	horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org,
	linux-kernel@vger.kernel.org, lvxiafei@sensetime.com,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	pabeni@redhat.com, pablo@netfilter.org
Subject: Re: [PATCH V2] netfilter: netns nf_conntrack: per-netns
 net.netfilter.nf_conntrack_max sysctl
Message-ID: <20250408095854.GB536@breakpoint.cc>
References: <20250407095052.49526-1-xiafei_xupt@163.com>
 <20250408090332.65296-1-xiafei_xupt@163.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250408090332.65296-1-xiafei_xupt@163.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

lvxiafei <xiafei_xupt@163.com> wrote:
> From: lvxiafei <lvxiafei@sensetime.com>
> 
> Support nf_conntrack_max settings in different netns,
> nf_conntrack_max is used to more flexibly limit the
> ct_count in different netns, which may be greater than
> the value in the parent namespace. The default value
> belongs to the global (ancestral) limit and no implicit
> limit is inherited from the parent namespace.

That seems the wrong thing to do.
There must be some way to limit the netns conntrack usage.

Whats the actual intent here?

You could apply max = min(init_net->max, net->max)
Or, you could relax it as long as netns are owned
by initial user ns, I guess.

Or perhaps its possible to make a guesstimate of
the maximum memory needed by the new limit, then
account that to memcg (at sysctl change time), and
reject if memcg is exhausted.

No other ideas at the moment, but I do not like the
"no limits" approach.

