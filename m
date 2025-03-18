Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5800C20C479
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Mar 2025 13:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742304242; cv=none; b=IA7sIOEfZ+ra0cUSRzyBAtPgAUK7Y3Qrtbmx/L19IAIAjSbeolI0uA8l2TPTqhjrQs8P89hVYPdA/6bvqC6auA4pE+Okm6G+kesEfoFH6/LWDanblLcFH/48p6tgXDA8YltzAE5qagCE23P33yDpG8+L1enziC9yUcniMVIg2RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742304242; c=relaxed/simple;
	bh=e7Kt9HjLqoQeoGiwgaXK9DpQOy9EU1n/7DpvPuhqte0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pecdGSnc5h4+NvnWNVYop48SLVPH6xxqArRIa+WTKSvEroq31wN18rVTN+krqODPpaItE7kqyTN+qI4xGGsZ0AX2ohdLWCsWexRaZKUznznd0DnNb3FLE4pWLcsCK8ueS8F9tS/WvCVWYlK5NkrB1Lqh1R81cQwFWQpvYXZOnps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tuWv5-0005Sn-4Q; Tue, 18 Mar 2025 14:23:47 +0100
Date: Tue, 18 Mar 2025 14:23:47 +0100
From: Florian Westphal <fw@strlen.de>
To: Antonio Ojea <aojea@google.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Eric Dumazet <edumazet@google.com>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v3] selftests: netfilter: conntrack respect reject rules
Message-ID: <20250318132347.GA20865@breakpoint.cc>
References: <20250313231341.3040002-1-aojea@google.com>
 <20250318094138.3328627-1-aojea@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250318094138.3328627-1-aojea@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Antonio Ojea <aojea@google.com> wrote:
> This test ensures that conntrack correctly applies reject rules to
> established connections after DNAT, even when those connections are
> persistent.
> 
> The test sets up three network namespaces: ns1, ns2, and nsrouter.
> nsrouter acts as a router with DNAT, exposing a service running in ns2
> via a virtual IP.
> 
> The test validates that is possible to filter and reject new and
> established connections to the DNATed IP in the prerouting and forward
> filters.
> 
> Signed-off-by: Antonio Ojea <aojea@google.com>
> ---
> V1 -> V2:
> * Modified the test function to accept a third argument which contains
>   the nftables rules to be applied.
> * Add a new test case to filter and reject in the prerouting hook.
> V2 -> V3:
> * Add helper functions to remove code duplication
> * Use busywait instead of hardcoded sleeps

You will need to apply the busywait logic to the 'kill -0' too:

# PASS: frontend filter-ip6: fail to connect over the established connection to [dead:4::a]:8080
# [<0>] do_select+0x68e/0x950
# [<0>] core_sys_select+0x1ef/0x4b0
# [<0>] do_pselect.constprop.0+0xe7/0x180
# [<0>] __x64_sys_pselect6+0x58/0x70
# [<0>] do_syscall_64+0x9e/0x1a0
# [<0>] entry_SYSCALL_64_after_hwframe+0x77/0x7f
# ERROR: frontend filter-ip6: persistent connection is not closed as intended
# cat: /proc/756/stack: No such file or directory


The <0> Lines come from cat: /proc/$pid/stack which I added here
locally, i.e. the kill -0 works, enters failure, but a retry after
sleep 2 and the process is gone.

So, I think you need to give the process a bit more time to wake up,
process the rst/eof and exit.

I think you can simply use the busywait helper for this too, pick a short
timeout such as 3000ms as upperlimit, that should do the trick and still
allow to detect a hanging process.
