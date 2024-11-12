Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD462178FC
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Nov 2024 18:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731435958; cv=none; b=P0uWDYm0tLGwuvhaS2PXKeX9R+xOmJn2NqI6oa9mUJd3huuYFv8ktSlAD0OBD+ZDhvZGazU2TgWQ5ySK8/QrjPODaB7YR/BQL78uDQVxhR0shqT2dCtX+YDE7OlHISJwSLiBNWXwasQ3+ZWQwXgTLerl94LaYNLP3QJUtgIUfPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731435958; c=relaxed/simple;
	bh=9g45UXidN5osGZ1et9t+OfaOQ4lIp41oelxYyZyQvPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d6Of59R3JrqkD+YtrAp4SLAPhc9zjx8rJ0YeggFNw6DaWlyimysJOl6/qhAW/pTrCXVuThJkMgexEc7LsdTfQwE4q0+TjYKqcY7r4AGEVWpW1HQQTj2kuDWCymBh6HKqRvInKAcaWYgEfA670U+PifkIiXGMxdfiPrm+ATJ9qZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tAvaL-0007aH-8u; Tue, 12 Nov 2024 19:25:53 +0100
Date: Tue, 12 Nov 2024 19:25:53 +0100
From: Florian Westphal <fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Nadia Pinaeva <n.m.pinaeva@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: conntrack: add conntrack event
 timestamp
Message-ID: <20241112182553.GC28817@breakpoint.cc>
References: <20241107194117.32116-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241107194117.32116-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

Florian Westphal <fw@strlen.de> wrote:
> Nadia Pinaeva writes:
>   I am working on a tool that allows collecting network performance
>   metrics by using conntrack events.
>   Start time of a conntrack entry is used to evaluate seen_reply
>   latency, therefore the sooner it is timestamped, the better the
>   precision is.
>   In particular, when using this tool to compare the performance of the
>   same feature implemented using iptables/nftables/OVS it is crucial
>   to have the entry timestamped earlier to see any difference.
> 
> At this time, conntrack events can only get timestamped at recv time in
> userspace, so there can be some delay between the event being generated
> and the userspace process consuming the message.
> 
> There is sys/net/netfilter/nf_conntrack_timestamp, which adds a
> 64bit timestamp (ns resolution) that records start and stop times,
> but its not suited for this either, start time is the 'hashtable insertion
> time', not 'conntrack allocation time'.
> 
> There is concern that moving the start-time moment to conntrack
> allocation will add overhead in case of flooding, where conntrack
> entries are allocated and released right away without getting inserted
> into the hashtable.
> 
> Also, even if this was changed it would not with events other than
> new (start time) and destroy (stop time).
> 
> Pablo suggested to add new CTA_TIMESTAMP_EVENT, this adds this feature.
> The timestamp is recorded in case both events are requested and the
> sys/net/netfilter/nf_conntrack_timestamp toggle is enabled.

I was about to send v2 of this patch, but I found following comment in
ulogd source code (input/flow/ulogd_inpflow_NFCT.c):

 *      - add nanosecond-accurate packet receive timestamp of event-changing
 *        packets to {ip,nf}_conntrack_netlink, so we can have accurate IPFIX
 *        flowStart / flowEnd NanoSeconds.


I'm leaning towards reworking this patch to replace ktime_get_real_ns()
by

ktime_to_ns(skb_tstamp_cond(skb, 1)))

so that the event carries the packet receive timestamp if that was
available or the current clock time as fallback.

Thoughts?  Otherwise I can ignore above comment and keep
ktime_get_real_ns() usage.
