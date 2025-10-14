Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D357B1E260C;
	Tue, 14 Oct 2025 13:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760447206; cv=none; b=Irkfqpced6Z97HjQx8I8/JaNcWm7kTCl641JSuLP10SLHb1UBJa9E9dATDZZFJIhBM5UNplehv23yAenpnBS3mF5dQ9q3ULwnOJ3Y6E9v5bFGQf67A5PJJ5HyGvHVp3/2vwRkyTh6d+EcYJkZGVFQNpSlYTej4Pr6/zylJItPvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760447206; c=relaxed/simple;
	bh=X50IHm3w0OfrTfTJJv+bSTRaCm8D1QRDrJaGPn4z+uQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LRUA9anOymQ7e0Fajjv2QYO/1Ix1YWLLlj1fiPRAMSAGF7+5PrFEaUuFfUY8sknyRn5W2GyErr8ldUEHtnR2MWB3cw2QWrlA+7ERVy00ION8nPM/UZ89xrBzp8pqn/Y4Yr/VtBcxuuHTHpLtGGQtRHYEllwAho0XJkpr+QCE6+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id DD2E960321; Tue, 14 Oct 2025 15:06:42 +0200 (CEST)
Date: Tue, 14 Oct 2025 15:06:42 +0200
From: Florian Westphal <fw@strlen.de>
To: lirongqing <lirongqing@baidu.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: conntrack: Reduce cond_resched
 frequency in gc_worker
Message-ID: <aO5K4mICGHVNlkHJ@strlen.de>
References: <20251014115103.2678-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014115103.2678-1-lirongqing@baidu.com>

lirongqing <lirongqing@baidu.com> wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> The current implementation calls cond_resched() in every iteration
> of the garbage collection loop. This creates some overhead when
> processing large conntrack tables with billions of entries,
> as each cond_resched() invocation involves scheduler operations.
> 
> To reduce this overhead, implement a time-based throttling mechanism
> that calls cond_resched() at most once per millisecond. This maintains
> system responsiveness while minimizing scheduler contention.
> 
> gc_worker() with hashsize=10000 shows measurable improvement:
> 
> Before: 7114.274us
> After:  5993.518us (15.8% reduction)

I dislike this, I have never seen this pattern.

Whole point of cond_resched() is to let scheduler decide.

Maybe it would be better to move gc_worker off to its own
work queue (create_workqueue()) instead of reusing system wq
so one can tune the priority instead?
