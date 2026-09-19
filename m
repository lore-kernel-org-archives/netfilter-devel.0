Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED8729408;
	Sat, 19 Sep 2026 06:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789799098; cv=none; b=dlynZrRq6Ll88XYRz6W6TMuLHYUZR3DTm9Vr1UdDtECrNs+59l9x11mK6BDdOyDEk/NR+NpMYjZ7XcySumgMXuNhm+zvN39EFuOFEx7PvSV/sO8vnHNLRj7ehH3cxYUEiw8hscS6Ca0VqA4TvZIdGZE81EBcImfgPNLTa9BcR3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789799098; c=relaxed/simple;
	bh=5VtlwD/z8ot8gELp9Ngll8Qk6f9ykQ/UQLNcH8SYQBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BFeXhQeDvNpQFaP3GEJT6EDYZ6a5ml3AVZHV/X8ZARK8Q7q3H7NEvVF1bpm+7wfjT7z+H5NBklgfrrjP7wb/EMv3aBcg355TKHBflYhFzCp+7j8V6BsDpjaPJM80hGzJqeTCDyQoNpoldEwMoPMXenglUzV7Crkky5OrvHOTo5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C427C60456; Sat, 19 Sep 2026 08:24:52 +0200 (CEST)
Date: Sat, 19 Sep 2026 08:24:52 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: pablo@netfilter.org, netdev@vger.kernel.org, phil@nwl.cc,
	shuah@kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH nf-next] selftests: netfilter: nft_queue.sh: only queue
 icmp echo request/reply
Message-ID: <aq4qtFAKULch5dTl@strlen.de>
References: <20260918183109.3918131-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918183109.3918131-1-kuba@kernel.org>

Jakub Kicinski <kuba@kernel.org> wrote:
> The bridge test flakes on debug kernels:
> 
>   FAIL: Expected 10 packets total, but got 24 packets total
>   hook 3 packets 00000008
>   hook 4 packets 00000010
> 
> The surplus are icmp fragment reassembly timeouts.  The udp flood in the
> stress test leaves incomplete datagrams behind in ns2 and ns3, 30 seconds
> later their reassembly queues expire and both namespaces send icmp time
> exceeded to ns1's pre-bridge address.  ns3 is not reconfigured when the
> router is turned into a bridge, so its messages arrive via veth2 and are
> then forwarded out of br0. Such packets are locally originated from the
> bridge point of view and are queued from the bridge output and
> postrouting hooks, which is why only those two counters are off.
> 
> Restrict the ipv4 rule to echo request/reply, the icmpv6 rule already
> does this.
> 
> We used to see 1 flake a day in NIPA before locally queuing this change,
> zero flakes since (over 9 days)

Thanks for debugging and fixing this!

Reviewed-by: Florian Westphal <fw@strlen.de>

> The difference between v4 and v6 has been there from day one,
> which makes it seem intentional, but I don't understand nft
> well enough to come up with any theories why..

Without the restriction this would also queue IPv6 neighbour
discovery messages.

ARP is not seen by NFPROTO_IPV4 hooks, so the restriction
was not needed. I simply did not think of icmp reassembly
timeout errors getting sent after some time when I wrote
this.
