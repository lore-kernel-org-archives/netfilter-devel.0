Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DFA018732F
	for <netfilter-devel@vger.kernel.org>; Tue,  7 May 2024 22:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715121171; cv=none; b=IrpRuocI8+LHpqJ1/PBlf5HmP62LPQQgV3jbQMn7kug9zH77wKehJfNpj4nmNw22vksBDbskxtY/xb89R6yBn1qMXQ0ir7vxGaVmGBdbsjxUV7NtlBHU+LsQP+UKPyMSHOp2APCUCR2WR9r3HHxOBK3q+kqMkQ7muhu1gR+qsuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715121171; c=relaxed/simple;
	bh=SG4STb9XekOfTSCSHlHl+ivn4c+gJOUhKaNvEw9T+50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hxs6Ie7ANz0nV8AILA1w3L0mAOXq8LI1juKQzjqnRB8koFHE8+wkZDPZzobGXJrSa4LR1E9ryfZVgQjdzKBVFAt2mfQ+uJ5zo9xJrrx72VchD54L0m3euBRMlI0ckkm/8B0iVMx0gn43ku/Era6lO+OCg0/7KLTo11q9ipHXYLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Wed, 8 May 2024 00:32:38 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Neels Hofmeyr <nhofmeyr@sysmocom.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: nftables with thousands of chains is unreasonably slow
Message-ID: <ZjqsBomPs2qWEi_5@calendula>
References: <ZjjGOyXkmeudzzc5@my.box>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZjjGOyXkmeudzzc5@my.box>

Hi Neels,

On Mon, May 06, 2024 at 01:59:55PM +0200, Neels Hofmeyr wrote:
> Hi!
> 
> I am trying to figure out why adding/deleting chains and retrieving counters
> via nftables takes long for high nr of entries. I'd like to share some
> findings, to ask whether this is known, whether a solution exists, etc...
> 
> I'm writing two programs that interact with nftables via
> nft_run_cmd_from_buffer(). (osmo-upf and osmo-hnbgw)
> 
> One use case is setting up / tearing down thousands of GTP tunnels via nftables
> rule sets one by one, for reference:
> https://gitea.osmocom.org/cellular-infrastructure/osmo-upf/src/commit/a21bcec358a5147deb15d156700279f52386a7d7/tests/nft-rule.vty

You are focusing on the "set up / tear down thousands of GTP tunnels"
problems in this email, correct?

> The other use case is retrieving all counters that are currently present in the
> inet table that my client program owns.
> 
> Adding the first few hundred chains / reading a few hundred counters finishes
> in an ok amount of time. But the more chains are already submitted in the
> table, the longer it takes to add another one, etc.
> 
> By the time that there are ~4000 chains, adding another chain becomes
> prohibitively slow. Some numbers: in total, when setting up 1000 GTP tunnels in
> osmo-upf, which means adding 4000 chains into a table owned by the program
> (osmo-upf), in total takes 49 seconds. This includes the overhead for talking
> PFCP and logging, etc., but by far the most time is taken waiting for
> nft_run_cmd_from_buffer().

In you scenario: Is there a nft_run_cmd_from_buffer() call for each
new chain?

> We'd like to scale up to like 100 times the above -- completely beyond all
> reason currently, since the wait time seems to increase exponentially.
> 
> I have two angles:
> 
> 1) workaround: structure the chains and rules differently?
> 2) analysis: bpftracing tells me that most time is spent in chain_free().
> 
> (1) Currently I have one flat table with all the chains in that "top level".
> Would it make sense to try breaking that long list up into smaller groups,
> maybe batches of 100? As in, pseudocode:
> 
>   table osmo-upf {
>       group-0 {
>          chain-0 {}
> 	 chain-1 {}
> 	 ...
>       }
>       group-1 {
>          chain-100 {}
>          chain-101 {}
> 	 ...
>       }
>       ...
>       group-1000 {
>          chain-100000 {}
>          chain-100001 {}
> 	 ...
>       }
>   }
> 
> Then I can also retrieve the counters in batches of 100, which might be more
> efficient and better to coordinate with concurrent tasks.

This means, your existing approach is not batching updates?

> (2) Using bpftrace, I drilled a bit into where the time is spent. Two
> interesting findings for me so far:
> 
> It seems most time is spent in
> 
>   nft_run_cmd_from_buffer
>     nft_evaluate
>       nft_cache_update
>         nft_cache_release
>           nft_cache_flush
>             table_free
>               chain_free
> 
> The bpftrace shows:
> 
> nft_cache_update() was called 6000 times.
> (I have 1000 GTP tunnels and expect four chains per GTP tunnel, which would be
> 4000, not sure why I see 6k, but that's not really that significant.)
> 
> chain_free() was called more than 5 million times, that's 1000 times as often
> as I would naively expect to see.
> 
> Most calls are fast (<16us), but there are some break-outs of up to 8ms, and in
> total the 5 million calls amount to 80 seconds. (One bpftrace dump below, FYI)
> 
> I'm continuing to think:
> 
> - Is this stuff known already, or does it make sense to continue on this path,
>   share a reproduction recipe here, and so on?

Yes, a simple reproducer would be good to have. Users from time to
time post reproducer on bugzilla to trigger issue, sometimes those
reproducers provide the time it takes, so it should be possible to get
numbers before and after patches.

> - can we fix that? Is there some memory leak / unnecessary blow up happening
>   that causes this apparent factor 1000 in effort?

tests regularly run valgrind and ASAN to ensure no memleaks.

> - can we defer the free, so my client program gets the nftables results without
>   having to wait for the freeing? Can the client program decide when to do the
>   nftables freeing, i.e. not within nft_run_cmd_from_buffer()?

I am not sure yet I understand the pattern you follow to trigger the
issue.

Thanks for reporting.
