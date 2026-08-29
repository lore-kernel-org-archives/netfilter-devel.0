Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60695345EA2;
	Sat, 29 Aug 2026 09:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787995638; cv=none; b=kC4nTIgKYjGywSBeZADfDoKOJiLh5V6/I4tKwuoO6e9lfYy26gP2mi80jaICmXuXINA7rXdgMM3sdn9pza7zmowrgpY+eY0u2vldLrZH2WCoZyD83lZAGufVj70rDbXOYBzPiZjQnfjokaBE/FmzzqSgH/ufeLE5wbTWTD7PUN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787995638; c=relaxed/simple;
	bh=uJp1NnRh/Bf88nHyfhsdcROSGc3nvflbEuKnd0DbS9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o480824L2NC/ydo1njoCYSR3YIBEfbDE4rCErNUXZWkvkIq81O3sZDEJ38n1jroaF1J89U2njKJf2ZWziVtDNf+Til0P1j6yi4cwyKWG4BNWkNrOjGP5ScGh5axpqwTCP8DETMyn/y2Zut8MKQYo6l5u7Ig9hnTtPNbAf1vkxUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B2D1C6032B; Sat, 29 Aug 2026 11:27:07 +0200 (CEST)
Date: Sat, 29 Aug 2026 11:27:07 +0200
From: Florian Westphal <fw@strlen.de>
To: Zihan Xi <zihanx@nebusec.ai>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Phil Sutter <phil@nwl.cc>, Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, coreteam@netfilter.org,
	stable@vger.kernel.org, Vega <vega@nebusec.ai>
Subject: Re: [PATCH nf 1/1] netfilter: nf_dup: prevent asynchronous duplicate
 recursion
Message-ID: <apKl65BbdyWCtre7@strlen.de>
References: <cover.1787903722.git.zihanx@nebusec.ai>
 <8e45ea5d0cf764267a90d959fa40f0f831aabf08.1787903722.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e45ea5d0cf764267a90d959fa40f0f831aabf08.1787903722.git.zihanx@nebusec.ai>

Zihan Xi <zihanx@nebusec.ai> wrote:
> nf_dup_ipv4() and nf_dup_ipv6() use current->in_nf_duplicate to keep
> duplicated packets from being duplicated again while ip_local_out() or
> ip6_local_out() walks netfilter hooks. The task flag is cleared as soon
> as the output function returns.
> 
> NFQUEUE can retain a duplicate and return from the output hook. A later
> NF_ACCEPT verdict resumes the same skb at the following hook from the
> verdict task, after in_nf_duplicate has been cleared. A later TEE target
> or dup expression can then duplicate it again. With an earlier queue
> hook and a later duplication hook, one packet can sustain an unbounded
> packet generation loop.
> 
> Record the duplication state in the cloned skb as well as the task. The
> skb flag survives queuing, reinjection, and skb metadata copies, so an
> asynchronously resumed duplicate cannot enter either IPv4 or IPv6
> duplication helper again. Copy the flag through nf_copy() so fragments
> retain the same state. Keep the task flag for the nested xtables jumpstack.

Not sure about this one.  I think this is a case of "behaves as
intended", you get oops because you *ask* the kernel to oops.

I think there are a great many other ways to OOM the kernel,
outside of dup/TEE/nfqueue.

IFF we prented that this is a real problem, then I would
prefer to solve this in nf_dup, not involving sk_buff changes.

I cannot see a sensible use case for nf_dup outside of
physical hardware (sending packets to some external
packet logging machine for instance).

So. I think a better solution would be to either disable
dup in user namespaces entirely, or, restore the "old" behaviour
of passing the clone directly (no reentry) if we were configured
from user namespace.
