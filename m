Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFD7346E5E;
	Sun, 23 Aug 2026 15:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787500295; cv=none; b=GlsT1v9422s6M8/4aIh6X23EzTLKBaDHLUMUIr2Mhmn0dsc6KjzViPZZrTuNAHLuXbgw6B7mLAVc1aoWm50UxLnItw+lkMo3WvJz0hCifiGM/bZNs0CTzRhQ6IRD+vS0e/WacJq4Qkf6zA3DHdNWc/M7gJz99lRrJzBD+3exVP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787500295; c=relaxed/simple;
	bh=NnSPabE68DW8kII7zX24VGL1Pz0S6QlimhUfHQYdJeU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pu/2bXnGpvdH8sMi+KZmsf4x/Q0DXyF6HN5Cp97PL7Sm59rxuQZ9ESijOOyFra8uwzG1hGqeJubwKEDbrF+T/23z9tLyB2aaeqm2rbI9OCwgtw4kL4vcqqxqathYZOtT8IOvcR5uHdd9nHOXEgnHm6p6fIsYPLUJXuLGmZLI0Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 46E2A602AA; Sun, 23 Aug 2026 17:51:23 +0200 (CEST)
Date: Sun, 23 Aug 2026 17:51:22 +0200
From: Florian Westphal <fw@strlen.de>
To: Chengfeng Ye <nicoyip.dev@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Gao feng <gaofeng@cn.fujitsu.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_log: clear per-net loggers on unregister
Message-ID: <aosW-q9G-rQlIXwu@strlen.de>
References: <20260822184658.3787672-1-nicoyip.dev@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260822184658.3787672-1-nicoyip.dev@gmail.com>

Chengfeng Ye <nicoyip.dev@gmail.com> wrote:
> Logger backends unregister their per-network namespace operations before
> unregistering their global logger. This leaves a window where a sysctl or
> netlink writer can rebind a per-net logger after the old per-net
> selection was cleared, but before the global logger registration is
> removed.
> 
> The race looks like this:
> 
>   CPU 0                                 CPU 1
>   ----                                  ----
>   unregister_pernet_subsys()
>     nf_log_unset(net, logger)
>       net->nf.nf_loggers[pf] = NULL
> 
>                                         lock nf_log_mutex
>                                         find logger in loggers[][]
>                                         net->nf.nf_loggers[pf] = logger
>                                         unlock nf_log_mutex
> Later, a sysctl read or nf_log_packet() reads net->nf.nf_loggers[pf]
> and dereferences the stale logger.
> 
> nf_log_unregister() only removes the backend from the global logger
> table. It does not clear matching net->nf.nf_loggers[] entries that were
> rebound by CPU 1 after per-net teardown. Once module unload completes,
> those per-net pointers can still reference static data from the unloaded
> logger backend, and later readers can dereference freed module memory.

Why can't this be fixed by unregistering in reverse order?
