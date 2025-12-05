Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746002253AB;
	Fri,  5 Dec 2025 16:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764951833; cv=none; b=OwDnpVw2QrTlQ12RIVMRIhx+9iP3qrtjlbm74Fj+evJJSqXEyVPoRuGo+CRuaJDf6bDJ8SpayXb7umJk9gRQ61P5myn5gY1yXR2QYlqS7cbMXIccojo4MV7vzES10wCU6wRRFjOaNP5uSRQunPZN8FQn3HIwQoN88eSaCAbwR7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764951833; c=relaxed/simple;
	bh=IGeh/QjE02HaR6TT8oVnPhDryAYch2kRD9pZXoFncaE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KcHsOWEbvCDyqQmofo8oXypyLl+srJOqzA79qYPa7xhJeQH/wro8KXmtiBT2XKxi0sbCt2JLjEsqe0xaiOH5vTn3I9tYWpQ4R2QVuUzPokDmaQscOsyVbCGA+ZpucfsrB7tahRDHJA2FQI3W6KEL1uz7m5Le74YvPfMU3QqejNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fYnxVp+2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fYnxVp+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A73C4CEF1;
	Fri,  5 Dec 2025 16:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764951831;
	bh=IGeh/QjE02HaR6TT8oVnPhDryAYch2kRD9pZXoFncaE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fYnxVp+2VoNGlZfw9oo1vfGro5sRrpgCX+fEJlhGOVOgLzCwG1i83SzY5FPOK/0E+
	 qXHXThQegIarn1GF27zz1qE1kCEFx1o1Qyiwp/Frvg7sRUskwp8oQMNKcWcHJiyCeK
	 +l8WvxvHlz5Y0k7OU0c1EnCmLdawjQLqNqE26kQ9E3gh9FQyLLoIsPR6nIOSeL3y3L
	 yppCDG26Qv6bbrWU52+NgRu6BwsDGFRaNV9MD4hZNIfH0RnLSVDNJ3Ggmvy4HEntHt
	 8CqvCc1HlYQOXN0t/AQ9TybQTwtyWOOUxeM4rVIA7nnGnDxdnLIdbD+ajPHsgPSvOz
	 ccBc5asyVMDCw==
Message-ID: <c38966ab-4a3c-4a72-a3c1-5c0301408609@kernel.org>
Date: Fri, 5 Dec 2025 17:23:46 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next RFC 1/3] xt_statistic: taking GRO/GSO into account
 for nth-match
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
 netdev@vger.kernel.org, phil@nwl.cc, Eric Dumazet <eric.dumazet@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, kernel-team@cloudflare.com,
 mfleming@cloudflare.com, matt@readmodwrite.com, nwood@cloudflare.com,
 aforster@cloudflare.com
References: <176424680115.194326.6611149743733067162.stgit@firesoul>
 <176424683595.194326.16910514346485415528.stgit@firesoul>
 <aShi608hEPxDLvsr@strlen.de>
Content-Language: en-US
From: Jesper Dangaard Brouer <hawk@kernel.org>
In-Reply-To: <aShi608hEPxDLvsr@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 27/11/2025 15.40, Florian Westphal wrote:
> Jesper Dangaard Brouer <hawk@kernel.org> wrote:
>> The iptables statistic nth mode is documented to match one packet every nth
>> packets. When packets gets GRO/GSO aggregated before traversing the statistic
>> nth match, then they get accounted as a single packet.
>>
>> This patch takes into account the number of packet frags a GRO/GSO packet
>> contains for the xt_statistic match.
> 
> I doubt we can do this upstream.  Two reasons that come to mind, in no
> particular order:
> 
> 1. It introduces asymmetry.  All matches use "skb == packet" design.
>     Examples that come to mind: xt_limit, xt_length.
> 2. This adds a compat issue with nftables:
>      iptables-translate -A INPUT -m statistic --mode nth --packet 0  --every 10
>      nft 'add rule ip filter INPUT numgen inc mod 10 0 counter'
> 
> 'numgen' increments a counter for every skb, i.e. reg := i++;.
> But, after this patch -m statistics doesn't work this way anymore
> and the two rules no longer do the same thing.

At some point we do want to move from iptables to nftables, so we do
need to come up with a solution for nft.

I wonder what nft building block we need if we want something like this,
e.g. based on the number of GRO/GSO segments.  We could have an inc_segs
and a greater-than-and-reset (gt_limit / gt_mod) with a counter limit
modifier that wraps increments. Like the C code does, it matches when we
overrun 'nth.every' and resets it back.  For existing iptables code this
is reset to zero, and new code take into account how much we overshot.


> But even if we'd ignore this or add a flag to control behavior, I don't
> see how this could be implemented in nft.
> 
> And last but not least, I'm not sure the premise is correct.
> Yes, when you think of 'packet sampling', then we don't 'match'
> often enough for gro/gso case.
> 
> However, when doing '-m statistic ... -j LOG' (or whatever), then the
> entire GSO superpacket is logged, i.e. several 'packets' got matched
> at once.
> 
> So the existing algorithm works correctly even when considering
> aggregation because on average the correct amount of segments gets
> matched (logged).
> 

No, this is where the "on average" assumption fails.  Packets with many
segments gets statistically under-represented. As far as I'm told people
noticed that the bandwidth estimate based on sampled packets were too
far off (from other correlating stats like interface stats).

I'm told (Cc Nick Wood) the statistically correct way with --probability
setting would be doing a Bernoulli trial[1] or a "binomial experiment".
  This is how our userspace code (that gets all GRO/GSO packets) does
statistical sampling based on the number of segments (to get the correct
statistical probability):

The Rust code does this:
  let probability = 1.0 / sample_interval as f64;
  let adjusted_probability = nr_packets * probability * (1.0 - 
probability).powf(nr_packets - 1.0);

  [1] https://en.wikipedia.org/wiki/Bernoulli_trial

We could (also) update the kernel code for --probability to do this, but
as you can see the Rust code uses floating point calculations.

It was easier to change the nth code (and easier for me to reason about)
than dealing with converting the the formula to use an integer
approximation (given we don't have floating point calc in kernel).


> With this proposed new algo, we can now match 100% of skbs / aggregated
> segments, even for something like '--every 10'.  And that seems fishy to
> me.
> 
> As far as I understood its only 'more correct' in your case because the
> logging backend picks one individual segment out from the NFLOG'd
> superpacket.
> 
> But if it would NOT do that, then you now sample (almost) all segments
> seen on wire.  Did I misunderstand something here?

See above explanation about Bernoulli trial[1].

--Jesper

