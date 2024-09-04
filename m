Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C7C1D935D;
	Wed,  4 Sep 2024 12:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725454141; cv=none; b=pZmjdKhvkyZI5G58NtsZ1Ih2GZYGtnESnkMIFfEHC6I13ub9vDCEi34CZA34OCh21Vt5kzyJJuUSLTrbz5bQja3FGMOp7khlYmpbRLYoEit0pv0CWMaNKQNJ9a9bD//jc0y1auN9SZtmgHgamOG2iS/cT0S05s4r7QaRt9a+ixQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725454141; c=relaxed/simple;
	bh=7nHkGu1WQn0BZSIK8Hrq3P0BLmtsI/SvosBrgbZMvoI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YYzSQYu28o71o5aunWjSkzy3ChkAuB2EoS0WK6qQqbJ9ZcwTtok0ihCdUy4UFEtJK0+JDEZFBaWUNBSAfXDclCmZFEHBfuQNODMxWUwRR21GkMvWHYW+LMjPdzo6OTwW1jWAaKFrqagH+AuTaKsfa8ApVyMRS8kyTBJCV4hUU4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1slpRA-0003vu-KF; Wed, 04 Sep 2024 14:48:40 +0200
Date: Wed, 4 Sep 2024 14:48:40 +0200
From: Florian Westphal <fw@strlen.de>
To: Eric Dumazet <edumazet@google.com>
Cc: Jiawei Ye <jiawei.ye@foxmail.com>, pablo@netfilter.org,
	kadlec@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
	kuba@kernel.org, pabeni@redhat.com, fw@strlen.de,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: tproxy: Add RCU protection in nf_tproxy_laddr4
Message-ID: <20240904124840.GA15053@breakpoint.cc>
References: <tencent_DE4D2D0FE82F3CA9294AEEB3A949A44F6008@qq.com>
 <CANn89iLQuBYht_jMx7WwtbDP-PTnhBvNu2FWW1uGnKkcqnvT+w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89iLQuBYht_jMx7WwtbDP-PTnhBvNu2FWW1uGnKkcqnvT+w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Eric Dumazet <edumazet@google.com> wrote:
> On Wed, Sep 4, 2024 at 2:25 PM Jiawei Ye <jiawei.ye@foxmail.com> wrote:
> >
> > In the `nf_tproxy_laddr4` function, both the `__in_dev_get_rcu()` call
> > and the `in_dev_for_each_ifa_rcu()` macro are used to access
> > RCU-protected data structures. Previously, these accesses were not
> > enclosed within an RCU read-side critical section, which violates RCU
> > usage rules and can lead to race conditions, data inconsistencies, and
> > memory corruption issues.
> >
> > This possible bug was identified using a static analysis tool developed
> > by myself, specifically designed to detect RCU-related issues.
> >
> > To address this, `rcu_read_lock()` and `rcu_read_unlock()` are added
> > around the RCU-protected operations in the `nf_tproxy_laddr4` function by
> > acquiring the RCU read lock before calling `__in_dev_get_rcu()` and
> > iterating with `in_dev_for_each_ifa_rcu()`. This change prevents
> > potential RCU issues and adheres to proper RCU usage patterns.
> 
> Please share with us the complete  stack trace where you think rcu is not held,
> because your static tool is unknown to us.
> 
> nf_tproxy_get_sock_v4() would have a similar issue.

Right, all netfilter hooks assume rcu read lock is held.

See nf_hook()/nf_hook_slow().
