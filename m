Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03DF367B86;
	Wed, 14 Oct 2026 10:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791975021; cv=none; b=tNTLBsLlSzSgYZvqHz3cmEVoX5oeDL9CIpKI7zJJfjwCmq4Eslpoco7p4KvOzGNqZ6dBetMrRgfZi6LEojFaZy/ysPhph3RtFE8GpfKYsoB/LkeRmMjtEc1dp1yJtFIZP+Aj8C+ZWk8lb1hzg9zq3U5E5DMgCbVeGr6qaZNB/mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791975021; c=relaxed/simple;
	bh=oBnL9h29x6KzZ69HBxe0qXU6NDqSpgQLyBM28ynAeGU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LtdG2Sq0edBNIy9JFhVS7w3Y6/m9ycAegU0No5hZ7A17A3fACkVMXZ/RUFXvcYln/QVBZclItkJLlp8EfZpa3VyhizrTdNngjIbWiVi3f+Hw59elNUjOOj6AeDRGa+r2JwOhsjCciPPJTLzXkfNWNz59j7l7wU7Naye5dov2EU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4441E60486; Wed, 14 Oct 2026 12:40:43 +0200 (CEST)
Date: Wed, 14 Oct 2026 12:40:42 +0200
From: Florian Westphal <fw@strlen.de>
To: zihan xi <zihanx@nebusec.ai>
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, kprateek.nayak@amd.com, pablo@netfilter.org,
	phil@nwl.cc, davem@davemloft.net, edumazet@kernel.org,
	pabeni@redhat.com, horms@kernel.org, kaber@trash.net,
	jengelh@medozas.de, lukas@wunner.de, vega@nebusec.ai,
	root@tr0jan.top
Subject: Re: [PATCH nf v7 1/1] netfilter: nf_dup: preserve duplication guard
 across NFQUEUE
Message-ID: <as9cKonuO_37jfA5@strlen.de>
References: <cover.1791688819.git.zihanx@nebusec.ai>
 <9c51ddfce3069d585b6c9b87e7e1bf3a3b0a2761.1791688819.git.zihanx@nebusec.ai>
 <asukIMajFpbzx3PH@strlen.de>
 <CAANe3eQSU06GJAaaj8Fd=S+THSJn0Eu+1Bt_E=VNZ0=rAQXnBQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAANe3eQSU06GJAaaj8Fd=S+THSJn0Eu+1Bt_E=VNZ0=rAQXnBQ@mail.gmail.com>

zihan xi <zihanx@nebusec.ai> wrote:
> Hi Florian,
> 
> Thanks again for the review. I tested the simpler approach you suggested:
> extending the local_bh_disable() / local_bh_enable() scope in
> nf_reinject() to cover hook lookup, hook traversal, and okfn execution.
> The experiment changed only nfnetlink_queue.c and built successfully
> against nf.git main at ab699d296e06.
> 
> I ran the IPv6 TEE/NFQUEUE reproducer in a 2-vCPU, 2-GiB QEMU guest
> in a network namespace owned by a non-initial user namespace, with:
> 
> QUEUE_COUNT=1
> PAYLOAD=1
> TEE_CLONES=1
> panic_on_oom=0
> 
> The bounded run reached 68,881 callback iterations in 6.700 seconds and
> exited normally. No OOM, panic, Oops, BUG, or soft lockup was observed.
> This was a bounded resource-consumption run, not an OOM or crash test.
> 
> The reproducer continued executing the callback loop throughout the
> bounded run, so extending the BH-disabled region alone does not address
> this case. It protects against BH interference during nf_reinject(), but
> it does not preserve current->in_nf_duplicate across the asynchronous
> NFQUEUE verdict path: the original ip_local_out() or ip6_local_out()
> call has already returned and cleared the task-local guard before
> reinjection starts.

Why? You'd store the current->in_nf_duplicate struct nf_queue_entry
at queue time ("this skb is due to recursion via nf dup").

Then, on reinject, you'd set current->in_nf_duplicate to the
value stashed in struct nf_queue_entry so that if we were queued earlier
from the recursion a potential further 'dup' would see current->in_nf_duplicate
as true and skip next duplication round.

I think one could add a 'DEBUG_NET_WARN_ONCE(current->in_nf_duplicate)'
in nf_reinject, I don't see how it could be set on function entry.

What did I miss?
