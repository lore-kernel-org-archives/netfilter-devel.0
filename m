Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221205013BC;
	Thu, 15 Oct 2026 10:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792060758; cv=none; b=L9d9pz/TlzRjLCWIrz56w5MywlTy/SGG1FzaE7FvWGl6dRJVQDGMTNTtshKLoBzXM5HD9xU47oNt4ZRfw1UCxrRI6eHuDztRAEjSkZmsX3a8vl9taaxiBVS9ogD54sDbRPP6oT1GPIZv1fTo6U7uSehY46h0lIFzlXyfAk6Esp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792060758; c=relaxed/simple;
	bh=uBijJrZM4mnefoRvItG7+mBcA6wx00llHnG2gvGYJU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t4NofZJRcx6wNvw3QN3NklDcmUwVS7Ox3lIg8hV3D7U9MjByJxeCuFLDT36Yp3Xbv2q02Bfp21wB7gIXWc/fsbh2H/YUYKLY3eL9YAj18fnj5UUCCJn/Ps5gclo89h/8NPt/KwSLeXnqwtZr+F3EpoCX/A05VEIJnyJB+n1Z/+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 13087606E2; Thu, 15 Oct 2026 12:39:13 +0200 (CEST)
Date: Thu, 15 Oct 2026 12:39:12 +0200
From: Florian Westphal <fw@strlen.de>
To: Zihan Xi <zihanx@nebusec.ai>
Cc: netfilter-devel@vger.kernel.org, virtualization@lists.linux.dev,
	intel-wired-lan@lists.osuosl.org, bpf@vger.kernel.org,
	pablo@netfilter.org, phil@nwl.cc, davem@davemloft.net,
	edumazet@kernel.org, pabeni@redhat.com, horms@kernel.org,
	kaber@trash.net, jengelh@medozas.de, andrew+netdev@lunn.ch,
	mst@redhat.com, jasowangio@gmail.com, eperezma@redhat.com,
	xuanzhuo@linux.alibaba.com, aleksander.lobakin@intel.com,
	ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
	john.fastabend@gmail.com, sdf@fomichev.me,
	magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
	willemb@google.com, alice.kernel@fastmail.im,
	eilaimemedsnaimel@gmail.com, imv4bel@gmail.com,
	shiming.cheng@mediatek.com, sd@queasysnail.net, vega@nebusec.ai,
	root@tr0jan.top
Subject: Re: [PATCH nf v8 0/3] netfilter: bound asynchronous packet
 duplication
Message-ID: <atCtUFcG9b4ykXY3@strlen.de>
References: <cover.1792048855.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1792048855.git.zihanx@nebusec.ai>

Zihan Xi <zihanx@nebusec.ai> wrote:
> Hi Linux kernel maintainers,
> 
> We found and validated an issue in netfilter packet duplication. The bug
> is reachable by an unprivileged user in user and network namespaces.
> Bounded tests exercised the fixes. Non-duplication packet semantics are
> intended to remain unchanged. MIRRED flow offload for affected netdev dup
> rules is rejected because it cannot enforce the duplication-depth limit.
> 
> We will provide detailed information about the bug
> in this email, along with a PoC to trigger it.

Series makes no sense to me, sorry.  I dislike the 2nd patch, I see no
reason why we need to make changes all over the place for this...?

Also, if we go with 2nd patch, why do we still need the first?

> The IPv4 and IPv6 duplication helpers use a task-local guard while a cloned
> packet traverses output hooks. If NFQUEUE suspends that traversal, the
> output call can return and clear the guard before a later verdict resumes
> the remaining hooks. The resumed packet can reach another duplication
> consumer without the original guard. This can cause repeated packet
> processing and consume CPU and network resources.

"Don't do that, then"?

I think the kernel should not crash when misused, but I don't think
kernel should have to do extreme stunts to detect such loops.

There are probably many other ways to make kernel allocate lots of
memory or waste cpu cycles.

E.g. via create use of veth and bridges, sched plug, teql, ...

> Patch 1 records the
> guard in the queue entry and restores it during reinjection. It keeps
> bottom halves disabled during the reinjection traversal, restoring the
> verdict task state before reenabling them.

Its small enough, so I have no objections to this patch.

> The netdev nft dup path has a separate synchronous transmit recursion
> counter. It does not accompany a duplicated skb through asynchronous
> software receive paths. Patch 2 carries a bounded duplication depth through
> skb and supported XDP conversions, resets it on reused buffers, and rejects
> MIRRED flow offload where the software depth cannot be enforced. This scope
> covers software skb/XDP continuity, not packet loops through physical
> hardware or userspace device round trips.

I think it would be better to first go to the drawing board and make ONE
facility that governs the recursion part.

From a quick glance, the difference is historical from time when
per-module pcpu counters were used, so nf_dup netdev could not see the state
of nft_dup toggle.  Now that its in task struct anyway, maybe its time to
just zap the egress recursion counter and first make a patch that
uses the bool toggle for both egress and normal dup?

I would like to remove code, not add more.

> At PRE_ROUTING and LOCAL_IN, the IPv4 and IPv6 helpers decrement TTL or
> hop limit on the copy. Patch 3 stops creating copies when the value is
> <= 1, so the decrement cannot reach zero or wrap a zero value to the
> maximum.

Thats unrelated problem.  There are other places that do TTL/HL
decrements.  I think it makes sense to clean this up in -next and
add common helpers and then use those.
