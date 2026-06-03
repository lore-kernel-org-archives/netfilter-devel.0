Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2AE64048A7;
	Wed,  3 Jun 2026 08:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780474215; cv=none; b=QorpqxUpCgC3GrwCm/GDkXgR6oz9yD92OM3ca8D+4xlSk0Nt3043Cs54HFaWSTh973vY1s8gnCOPcre3mrafMoI6B6VPwkh+BrMX89p/7cf/zu/jFE1fEaTELPWXKXF1xCQ6jE1a/Wv9c5MMt3ucnz/fEX4zQne1tQx3ypEFsgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780474215; c=relaxed/simple;
	bh=n2GvGrihVJDXKwQa7E10PZJnJ+nmRSYVVlvdD3MkgWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YnLTCE4Dx1cEBbojS+T+cyxvd7OBkKvOzokkPb9GrWxiq0bPE2MrDuyEDQQY5famfXbKpAaCmEaHNgj74co6YkG9xJpX+aGm3YTulLebr6AyqMlZ0DeSxka96QaKYoDt0ZBIWEoBQuhvZV5UiG6z0OdJnb0+1nA4uw/lyQG+mrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MMgmxYu3; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MMgmxYu3"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 555816017E;
	Wed,  3 Jun 2026 10:10:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780474211;
	bh=YVuJE2K58TEND6rSTbgtm/yJKORKupBTx+vs8X2Jt0Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MMgmxYu3WjxGgsHKRbLJg2HshWh3OZHtuzUiKbJLbnpJxjsnBeSbwuM9JiXWr2XaF
	 VJUtxY/FPVtKkSfNGDtKzW5DiswJjd6LOng8xF2MSpvyJzdk2y1yFbZOiWfOKBVuIy
	 o2AmN5DthaLJzXAfy4Dx+TN+4EcDE/KdwreeVkJxy40njKun8kwSuk9KgKWTGXSygo
	 W/P0O5X8yJ+ics98HWaeYcaGqIf2MwCo/Dk7R2ce2YjQPz2bljQiVQOM3h/lAMkd2e
	 AbcLM3KMI57Wg2eAm3p2UVXoJZu50Y3El5unYe016/5LJjNfrdoZR9yscVroMZauz3
	 q1djAMT3+d+QA==
Date: Wed, 3 Jun 2026 10:10:08 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Sayooj K Karun <sayooj@aerlync.com>
Cc: aleksander.lobakin@intel.com, davem@davemloft.net, dsahern@kernel.org,
	edumazet@google.com, fw@strlen.de, horms@kernel.org,
	idosch@nvidia.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, pabeni@redhat.com,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] net/ipv6: icmp: fix is_ineligible() to block errors for
 Redirect packets
Message-ID: <ah_hYJa3byoUyose@chamomile>
References: <ah1VoxXLbRAZIEC3@chamomile>
 <20260603060112.10524-1-sayooj@aerlync.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260603060112.10524-1-sayooj@aerlync.com>

On Wed, Jun 03, 2026 at 11:31:12AM +0530, Sayooj K Karun wrote:
> You are right that netfilter can be configured to make devices behave in
> non-RFC-compliant ways, so I will drop the "netfilter policy must obey
> the RFC" framing from my earlier reply.
> 
> The point I should have made is that is_ineligible() is not a netfilter
> function. It is the generic gate that icmpv6_send() uses to decide
> whether the kernel, as an ICMPv6 originator, may emit an error for a
> given trigger packet, and it is shared by all icmpv6_send() callers. It
> already enforces RFC 4443 section 2.4(e.1) at exactly this spot, via
> !(*tp & ICMPV6_INFOMSG_MASK), that is "do not originate an error in
> response to an ICMPv6 error". My patch adds (e.2) (Redirect) right next
> to it, the second rule from the same MUST NOT list. So this is not
> about overriding netfilter policy; it is completing the e.1/e.2 pair at
> the single point where the kernel decides ICMPv6 error eligibility.
> 
> On how it fixes the REJECT case: the two IPv6 reject paths differ in who
> actually frames the ICMPv6 error. The bridge/netdev path,
> nf_reject_skb_v6_unreach(), builds the packet by hand: it allocates the
> skb, writes the IPv6 and ICMPv6 headers, copies in the original packet
> and computes the checksum. Because it does all that itself, it has to
> carry its own guard, nf_skb_is_icmp6_unreach(), the IPv6 analogue of the
> nf_skb_is_icmp_unreach() you mention.

Yes, because bridge/netdev path cannot assume the IP stack comes into
play, so it needs a custom function to build the packet to reject the
traffic.

> The L3 path, ip6t_REJECT / nft_reject -> nf_send_unreach6(), never frames
> a packet of its own. It just calls icmpv6_send() and lets the core
> ICMPv6 stack build and send the error. is_ineligible() is the gate that
> core builder consults first, before it allocates or assembles anything,
> so that is exactly where the e.1 suppression already lives for this path.
> There is no netfilter-local guard here, and there does not need to be.
> 
> So the scenario in my commit message is the L3 path:
> 
> 	ip6t_REJECT / nft_reject
> 	  > nf_send_unreach6()
> 	    > icmpv6_send() / icmp6_send()
> 	      > is_ineligible()  // now returns true for NDISC_REDIRECT
> 	        > goto out, no packet is ever built or transmitted
> 
> The patch fixes the REJECT case because the L3 reject hands packet
> construction to icmp6_send(), and is_ineligible() runs at the top of
> that builder, before any error skb exists. It is the same spot that
> already drops e.1 today, so adding e.2 there completes the pair rather
> than introducing a new override.
> 
> I also agree there is a gap to close on the netfilter side. The
> bridge/netdev path never reaches is_ineligible(), and its
> nf_skb_is_icmp6_unreach() guard currently checks only
> ICMPV6_DEST_UNREACH, not Redirect, so it is not covered by this patch. I
> will send a follow-up to netfilter-devel for nf-next extending that
> guard to also skip Redirect, so both paths behave consistently.

Yes, nf-next is the target for this for review.

> Does that split sound right? this fix to is_ineligible() for the L3
> path, plus a separate nf-next patch for the bridge/netdev reject guard?

Maybe, I did not look in depth with details, but posting a patch
upfront to see how things look like make it easier for us, even if
more changes are later requested on it.

Thanks.
