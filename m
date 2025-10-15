Received: from baidu.com (mx21.baidu.com [220.181.3.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD381F4191;
	Wed, 15 Oct 2025 01:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.3.85
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760493443; cv=none; b=J6t3MZ6/AXcqWVGX6mZk8Ln0PhgHLwIfJecov/jUPPpudvnlQ4O/R3sUkHcc7rjD9tX3Ra2LMwo5TRb7gDEB1cTRKHzKRy7SIFupaNoZkIdm1XWnr3NTk68gPEk0lYlYU5AkrCKmRhUF34ty8MQNJw1/dKHrM2OGuZAULi9kK4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760493443; c=relaxed/simple;
	bh=/zC2WZ0f+zEXcM6rYZXPDJMMSq/9n/5kb+d0paxVClg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AMBUiA+xv4BBLm9mpnQ2IeJhqD9sWRTaZE+hXqd5U8D9XKLkpnvRcIn3K8sQ8O6j/e9r6cIlOKMN0P/JPISdIKxPwOW+jzJgZV9DftQSMuEnYR4sSRtSQLF9yHPKXdVljQ5HD3MGYFvq+0CKIJAZTWrGVKCR5wP+RqvdT1JBFVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=220.181.3.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: "Li,Rongqing" <lirongqing@baidu.com>
To: Florian Westphal <fw@strlen.de>
CC: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik
	<kadlec@netfilter.org>, Phil Sutter <phil@nwl.cc>, "David S . Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
	<horms@kernel.org>, "netfilter-devel@vger.kernel.org"
	<netfilter-devel@vger.kernel.org>, "coreteam@netfilter.org"
	<coreteam@netfilter.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [????] Re: [PATCH net-next] netfilter: conntrack: Reduce
 cond_resched frequency in gc_worker
Thread-Topic: [????] Re: [PATCH net-next] netfilter: conntrack: Reduce
 cond_resched frequency in gc_worker
Thread-Index: AQHcPQDVgdtchoaPFky/o8HNXziejLTBFqYAgAFcacA=
Date: Wed, 15 Oct 2025 01:56:35 +0000
Message-ID: <13de94827815469193e10d6fb0c0d45b@baidu.com>
References: <20251014115103.2678-1-lirongqing@baidu.com>
 <aO5K4mICGHVNlkHJ@strlen.de>
In-Reply-To: <aO5K4mICGHVNlkHJ@strlen.de>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-FEAS-Client-IP: 172.31.50.46
X-FE-Policy-ID: 52:10:53:SYSTEM

> > The current implementation calls cond_resched() in every iteration of
> > the garbage collection loop. This creates some overhead when
> > processing large conntrack tables with billions of entries, as each
> > cond_resched() invocation involves scheduler operations.
> >
> > To reduce this overhead, implement a time-based throttling mechanism
> > that calls cond_resched() at most once per millisecond. This maintains
> > system responsiveness while minimizing scheduler contention.
> >
> > gc_worker() with hashsize=3D10000 shows measurable improvement:
> >
> > Before: 7114.274us
> > After:  5993.518us (15.8% reduction)
>=20
> I dislike this, I have never seen this pattern.
>=20

This patch is similar as=20

commit 271557de7cbfdecb08e89ae1ca74647ceb57224f
    xfs: reduce the rate of cond_resched calls inside scrub

> Whole point of cond_resched() is to let scheduler decide.
>=20
> Maybe it would be better to move gc_worker off to its own work queue
> (create_workqueue()) instead of reusing system wq so one can tune the
> priority instead?

I am fine to move gc_worker to its own work queue

Thanks

-Li
