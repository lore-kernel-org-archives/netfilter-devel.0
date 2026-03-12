Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7481DEFE8;
	Thu, 12 Mar 2026 12:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773319007; cv=none; b=LGSJn8rEeWaOYWm9fvgQxwDZUcCFZMbM3J7GxrvGOvSCZ59wLWWbwWxRfUvAjvhzc/KGjXa13lXNw3JPkeJA5aZQEUAOe6ktzLwM6SgK7y99J+sWGNtZu0cg5/JH3iYCsNA9gCuGLAO5O9X1xaAaM8qj+0Ux1aWSCWZMNAZlIcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773319007; c=relaxed/simple;
	bh=aLrncpKox8OUUgw9Pi1Wd+JmkU+sBo7DO9cXcHpsdMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gai2mL+B05oz2SUqjddiAlsfb9lnEA/Y+gHepRAq/40XonmQXRIHLcTsNbesa8YqruUON8gLNPUZhfV1Xj1YrnPP+jBcBuKu+vVqFRfXEM6zOfEokNBZjQQGGLXWiX2/3Op2DXxsxp/feGxn8+KYLhoKWO3gmUxS/DC2+aLxZS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D14026047A; Thu, 12 Mar 2026 13:36:38 +0100 (CET)
Date: Thu, 12 Mar 2026 13:36:40 +0100
From: Florian Westphal <fw@strlen.de>
To: Prasanna S Panchamukhi <panchamukhi@arista.com>
Cc: netfilter-devel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	netdev@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH net-next] netfilter: conntrack: expose
 gc_scan_interval_max via sysctl
Message-ID: <abKzWIhVz_SeiSOa@strlen.de>
References: <20260311194058.13860-1-panchamukhi@arista.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311194058.13860-1-panchamukhi@arista.com>

Prasanna S Panchamukhi <panchamukhi@arista.com> wrote:
> The conntrack garbage collection worker uses an adaptive algorithm that
> adjusts the scan interval based on the average timeout of tracked
> entries.  The upper bound of this interval is hardcoded as
> GC_SCAN_INTERVAL_MAX (60 seconds).
> 
> Expose the upper bound as a new sysctl,
> net.netfilter.nf_conntrack_gc_scan_interval_max, so it can be tuned at
> runtime without rebuilding the kernel.  The default remains 60 seconds
> to preserve existing behavior.  The sysctl is global and read-only in
> non-init network namespaces, consistent with nf_conntrack_max and
> nf_conntrack_buckets.

This was proposed before, see:

https://lore.kernel.org/netfilter-devel/aO-id5W6Tr7frdHN@strlen.de/
https://lore.kernel.org/netfilter-devel/aRsuU57juCvsMBKE@strlen.de/

I did not hear back wrt. the horizon cache.

I'm not 100% opposed to this, but I do wonder if we really can't do
better than the current avg strategy.
