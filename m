Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AF431B12B;
	Wed, 15 Oct 2025 11:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760526372; cv=none; b=l5KE8qbAv1gGKoYm0rivOnApdxI27IIzHdIKEPOgVtWg3a9Q0G/q2Eimp+3tRcveFDbpf9nwU3Yr/BEURQupzG7sOJbzD+Sie09xqxxEApnMrcqKkbWdcQpZ2EBJnfYUSQFO2wyLeYQnIfxjcaMYgOINMVgB37sL8KoyCDD1dzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760526372; c=relaxed/simple;
	bh=awaQU58vXl4YAKLmdMe+GNPZ/adtnwxXxxI5nntmTTU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D6h+/j/qlQMJT5/kIycJDWw1QXqBALrf73wb8dKmANzdwJd6LzVGQBpQXqeesvJ+2HY/XCvPpJ32bYj/AlIv+hUbalbTZ3tA1cuc04f+5xgPGMQ0RMgJUSscmhzy4zdZzqfxN00c9QjkuwaNDD2kZX7l5lRHERs1lt0+zJpafy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 84ACD60186; Wed, 15 Oct 2025 13:06:01 +0200 (CEST)
Date: Wed, 15 Oct 2025 13:06:01 +0200
From: Florian Westphal <fw@strlen.de>
To: "Li,Rongqing" <lirongqing@baidu.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"coreteam@netfilter.org" <coreteam@netfilter.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
	vincent.guittot@linaro.org
Subject: Re: [PATCH net-next] netfilter: conntrack: Reduce cond_resched
 frequency in gc_worker
Message-ID: <aO-ADi4UJhOFz4zr@strlen.de>
References: <20251014115103.2678-1-lirongqing@baidu.com>
 <aO5K4mICGHVNlkHJ@strlen.de>
 <13de94827815469193e10d6fb0c0d45b@baidu.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13de94827815469193e10d6fb0c0d45b@baidu.com>

Li,Rongqing <lirongqing@baidu.com> wrote:

[ CC scheduler experts & drop netfilter maintainers ]

Context: proposed patch
(https://patchwork.ozlabs.org/project/netfilter-devel/patch/20251014115103.2678-1-lirongqing@baidu.com/)
does:

-		cond_resched();
+		if (jiffies - resched_time > msecs_to_jiffies(1)) {
+			cond_resched();
+			resched_time = jiffies;
+		}

... and my knee-jerk reaction was "reject".

But author pointed me at:
commit 271557de7cbfdecb08e89ae1ca74647ceb57224f
xfs: reduce the rate of cond_resched calls inside scrub

So:

Is calling cond_resched() unconditionally while walking hashtable/tree etc.
really discouraged?  I see a truckload of cond_resched() calls in similar
walkers all over networking. I find it hard to believe that conntrack is
somehow special and should call it only once per ms.

If cond_resched() is really so expensive even just for *checking*
(retval 0), then maybe we should only call it for every n-th hash slot?
(every L1_CACHE_BYTES?).

But even in that case it would be good to have a comment or documentation
entry about recommended usage, or better yet, make a variant of
xchk_maybe_relax() available via sched.h...
