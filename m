Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D114AEF4
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 16:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726157210; cv=none; b=QXHAcsErDhqoZfs0ga9FpRTs/1tq/i1Xy6gcNE/yNn+zRnT5Of1qlsojJTQifStKtTwLVZQxPttq4xjA6EQVp9rOQ/YQp1R0nTm8YpeMGnd/1bZ7PwmrejJMFz1WN40iQvirRBcJ0KVpKvnpfUrCKqIsI2bbA2Vu54l1J8DMWDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726157210; c=relaxed/simple;
	bh=CQ2chGX2nPzYPaTgzQFY/rVGG+NuLI+4pdIXJzSI/OQ=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jAvsDTntvex3R93RwkfyLtOX3vbWsgTL/xMuDCF1EIudo2rtBtDfzQa9pH0IWNgz4CQNg4CUVNrZ3j0VsnFBpvm2MxEFcMjdAYdG+xA591LpHrS0ErDrS/WFbxEY2CWKv5IzSfmqImtWz5c9Pce90wYgVofgEfkNbjyDCsYCVL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1somL9-0003SN-FN; Thu, 12 Sep 2024 18:06:39 +0200
Date: Thu, 12 Sep 2024 18:06:39 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v3 11/16] netfilter: nf_tables: chain: Respect
 NETDEV_REGISTER events
Message-ID: <20240912160639.GA9554@breakpoint.cc>
References: <20240912122148.12159-1-phil@nwl.cc>
 <20240912122148.12159-12-phil@nwl.cc>
 <20240912144041.GE2892@breakpoint.cc>
 <ZuMDTL1P-NZ_Ezyk@orbyte.nwl.cc>
 <20240912151203.GA32404@breakpoint.cc>
 <ZuMLnfwhTdyqp90C@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZuMLnfwhTdyqp90C@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> So it is possible that ops are still used somewhere after
> nf_unregister_net_hook() returns? I don't quite get that code, with all
> the RCU-bells and ONCE-whistles.

Not ops, but other core could still run the hookfn that
is being unregistered, i.e.:

cpu 0
 unreg hookfn                      nf_hook_slow
                                      runs hookfn
if nf_hook() fetched the hook blob (struct nf_hook_entries *)
before unreg path called its rcu_assign_pointer with the updated
incarnation.

That said, this might be a special case as entire nf_hook_entries blob
is tied to device that is going down, so packet flow might have stopped
already.

From a brief glance the device is already disabled at NETDEV_UNREGISTER
time, no packets are flowing anymore.

> > Device is the same, so maybe its enough to update the name
> > in nft_hooks structure?
> 
> You're putting the cart before the horse here: The user sets
> hook->ifname and we bind to whatever device matches that.
> 
> Now with a device being renamed, there are two options:
> 
> A) Unbind if the name doesn't match hook->ifname anymore and search for
>    another, matching hook. This is what I had (tried to) implement.
> 
> B) Just leave the interface in place as long as it exists. This is how
>    the old code behaves.
> 
> For users, I find (A) more intuitive.

Yes, that makes sense to me.  But can't you defer the unbind until after
you've figured out if there is a matching hook or not?

I.e., if no matching new hook, just unreg, else register new/unregister
old.

Otherwise, we might unreg, then fail to re-register?
