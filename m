Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A46E2D5C8E;
	Fri, 16 Oct 2026 12:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792152115; cv=none; b=cMK66bv4oiGsWYNJoUPM6jHVqP//TNt9JhyFUz0sq8SUWVAM70K1/axP+AVHI/tk+gvfkfLyeBWdddgPhkBpPvPr8kJ6N8MEssE1vG4aTU2pnb6bKJ/zUnTIEuRWAhzOrjFjjtiL8g2GPemu+w8L26ZMojcjROFyea9VIbfVGug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792152115; c=relaxed/simple;
	bh=n5rNZMc8Wy7QvuvnhsJhaLhXdG2NpQ6B8WZe42FDEng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uWH34GZZ3xaQ+/0go8QbG6onLbqTf75xfYOfGKOCxJQ/1ZcRSArX9mMSGSWJzPkHJHhSdYMMf5HntnKsvAi7rleniPoJL293PPlhXAW8YBBKshdq4/RtndDVA1/La2XVX5rpuiLo2CHlaowWsh7hh8lPdeVHYSViNTuavhvhqU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0E6DB60291; Fri, 16 Oct 2026 14:01:47 +0200 (CEST)
Date: Fri, 16 Oct 2026 14:01:46 +0200
From: Florian Westphal <fw@strlen.de>
To: Hari Chandrakanthan <hari.chandrakanthan@oss.qualcomm.com>
Cc: pablo@netfilter.org, phil@nwl.cc, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next] netfilter: nf_conntrack: add ct expression
 support for netdev egress chains
Message-ID: <atISKsTHeHwAXfZf@strlen.de>
References: <20261006085844.2694120-1-hari.chandrakanthan@oss.qualcomm.com>
 <asTd69Buuk6PisMl@strlen.de>
 <fe6fe48c-df09-41be-acff-bbae33454bd9@oss.qualcomm.com>
 <as0HMjsgUvKd7dAo@strlen.de>
 <67d8e88a-eff0-4c8d-a030-b29b5d86f450@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <67d8e88a-eff0-4c8d-a030-b29b5d86f450@oss.qualcomm.com>

Hari Chandrakanthan <hari.chandrakanthan@oss.qualcomm.com> wrote:
> By netdev/egress only, I mean that the nft rule with a ct expression
> (e.g., ct mark set) is present only in the egress chain for a netdev,
> with no other nft conntrack rules in inet or bridge chains.
>
> For example, it may be possible that only rules similar to the below
> nft rules are added at the netdev egress chain, with no other ct rule
> in inet or bridge hooks.
> 
> nft add table netdev qos_table
> 
> nft add chain netdev qos_table wlan0_qos \
>      { type filter hook egress device "wlan0" priority 0\; }
> 
> nft add rule netdev qos_table wlan0_qos \
>      ether daddr 00:03:7f:01:50:65 \
>      ip saddr 192.168.1.10 \
>      ip daddr 192.168.1.20 \
>      ip protocol tcp \
>      tcp sport 12345 \
>      tcp dport 443 \
>      ct mark set 0x10
> 
> > Where are the skbs coming from, i.e. though what pipeline?
> >
> > Bridge?
> > Routing?
> 
> In the use case that we are trying to address, the device is a Wi-Fi 
> access point router. It receives the classification rules from a Wi-Fi 
> client device for QoS prioritization of down-link traffic to the client 
> (n-tuple to Wi-Fi TID mappings) via SCS. We would like to apply these 
> classification rules on the access point router using nft rules
> (ct/skb mark set rules) at the WLAN netdev's egress chain.

I still see no reason to ever conntrack.  Is this for 'sticky'
skb->mark ?

I think conntrack for that is waaay too much overhead and would
use a nft map for this.

> >> To address this, as suggested by Pablo, we are considering enabling
> >> conntrack lookup/creation at
> >> netdev/ingress. This would allow netdev chains to access conntrack state
> >> without requiring conntrack
> >> to be enabled for the inet or bridge families, avoiding unnecessary
> >> overhead for netdev-only use cases.
> > FWIW bridge conntrack is already problematic (see recent RFC patch
> > to refag in INPUT, conntrack is pretty much routing-only.
> >
> >> Kindly share your thoughts on this approach.
> > I think you'd have to explain your use case.
> >
> > I thought you only want
> >
> > skb-> mark = ct->mark
> >
> > from egress. That would imply something else already enabled conntrack
> > anyway, else you'd have no conntrack marks set that you could read.
> 
> As mentioned in the previous comment, in the use case that we are
> trying to address, the device is a Wi-Fi access point router. It 
> receives classification rules from a Wi-Fi client device for
> prioritizing downlink traffic to the client (n-tuple to Wi-Fi TID
> mappings) via SCS. We would like to apply these rules on the access
> point router using nft rules (ct/skb mark set rules) at the WLAN
> netdev egress chain.
> The nft rules at netdev egress chain achieve the below functionality:
> 1. If connmark is not set on the first skb seen by the rule,
>     perform flow classification (based on dmac addr and n-tuple) and 
> store the result in the ct's mark via ct mark set. Typically, this rule 
> will be skipped when the connmark is already set for the flow.
> 2. If connmark is already set (for subsequent packets), copy it to
>     skb->mark. Ideally, only this rule should be processed by the vast
>     majority of packets for the flow.
> There are three advantages we see in this solution for this use case:
> 1. We wanted to avoid incurring the cost of n-tuple match for every
>     single packet at the netdev egress hook, by applying the
>     classification rule (tuple match and connmark set) only for the 
> first packets until connmark is set.

Hmmm.  Conntrack has overhead.  Did you check that bringing
in conntrack into the picture really saves cycles?

If you assume conntrack is already active anyway to provide NAT, etc,
then my point is moot.  But in that case all that is needed is to
permit retrieving ct->mark in netdev egress chains, which is much
simpler and doesn't require conntrack enablement.

> 2. Adding the rules at the egress hook of the netdev restricts the
>     scope of these rules only to packets egressing the netdev of
>     interest, without incurring the cost of processing these rules for
>     traffic egressing on other netdevs in the system or other hooks.

I think that IFF you really need to bring in full-blown conntrack, then
Pablos proposal makes sense.

However, I think that we really have to make many more changes to
make this work, even to existing bridge conntrack support.

As-is, bridge conntrack is no 'works out of the box' solution, it
requires extra setup (conntrack zones) to separate VLANs or you risk
unwanted cross-vlan-traffic.

I think we'd have to bring at least the vlan id into the nf_conn
entry and auto-separate such entries if request is coming from
bridge resp. netdev hook.
