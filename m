Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DF518CC03
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Jul 2024 23:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722382462; cv=none; b=XLzells8PYAlCKd/eKgxpbqwQmixQIJb32RkJ8+RIxPJrY5W9IvjOCsKqm7En5JFWx3P+hp9mha105KmByhqkdC4IRlUkWBtn4k7zeBc5AGrmmKdL0l4YV0rhus7XKmd5N/6Un4bZ7Tu8HDYolEqVvFnjSMPetgmhMcWxXaRjmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722382462; c=relaxed/simple;
	bh=KS9bgyxhhop15W3zhUNH6kJIWvR2G0fuqYL5Sa6c0HM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qSLXDpm5lOkTzM4rRSv+f3THoVAr5AhNBJunbDOB27Ye6m5fXTE8kglVIMaKmvm6EiaiWJwfEPpp6s18z+mQT4nGPydIIR3Fue+UGYkSymaneCxPGLvR4uuK4yiT8SNmC0ZES+1e6Zr1OBMRPsBkKxAISO2CN+tXQhrT6bA/Kcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [2001:8a0:74d4:2501:a64e:31ff:febd:17a4] (port=46012 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sYwM1-00BWwi-0z; Wed, 31 Jul 2024 01:34:07 +0200
Date: Wed, 31 Jul 2024 01:34:04 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nft 1/4] doc: add documentation about list hooks feature
Message-ID: <Zql4bCx4Gc6SGzUU@calendula>
References: <20240726015837.14572-1-fw@strlen.de>
 <20240726015837.14572-2-fw@strlen.de>
 <ZqNlvkJ2YSc-KIKb@calendula>
 <20240726123152.GA3778@breakpoint.cc>
 <ZqbR0yOY87wI0VoS@calendula>
 <20240728233736.GA31560@breakpoint.cc>
 <ZqbgmMzuOQShJWXK@calendula>
 <20240729153211.GA26048@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240729153211.GA26048@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Mon, Jul 29, 2024 at 05:32:11PM +0200, Florian Westphal wrote:
[...]
> TL;DR: I think we should revert to strict behaviour, i.e.
> nft list hooks foo

Agreed.

> queries hooks registered as NFPROTO_FOO.
> 
> NFPROTO_INET expands to shorthand for 'list hooks ip and ip6'.
> 
> AFAICS the problem is that ip, ip6 and arp are both NFPROTO_ values
> (protocol families), but also l3 protocols, whereas netdev and bridge
> are only families.
> 
> Hence, what to do on bridge becomes murky, there is just a large number
> of possible l3 protocols that can pass through these hooks.
> 
> Netdev is simple because its scoped only to one single interface.
> 
> Sorry for the wall of text below, but maybe it helps to understand
> why i think the above (no-guesses, treat strictly as nfproto) makes sense.

Makes sense, thanks for explaining.

[...]
> > If you don't like this behaviour and prefer a strict view per hook
> > family it should be possible to revisit. User will have to get all the
> > pieces together to understand what the hook pipeline is instead. This
> > command has not been documented so far.
> 
> Yes.  In theory it should be possible to do this, so to go with arp example:
> 
>   nft list hooks arp device foo
> 
> would list:
> 
> 1. netdev ingress and egress hook for the queried device
> 2. arp in and output hooks (there is no forward for arp)
> 3. bridge pre,in,forward,output and postrouting
> 
> but does that make sense?  I don't think so, because it gets more
> complicated for bridge query:
> 
> nft list hooks bridge
> 
> 1. can't show netdev, we lack device to query -> query all interfaces?
>    But why would one clutter output with netdev in/egress when bridge
>    was asked for?
> 2. show pre/in/fwd/out/postrouting NFPROTO_BRIDGE hooks
> 3. should it show ip/ip6 hooks? They could be relevant in case
>    of broute expression in nftables.
>    ip/ip6 Output+postrouting are travesed in case of local packets.
> 
> and it would have to show arp hooks, no?  for arp packet, we might pass
> them up to local stack.  Local arp query pass through arp:output.
> 
> So I'm just worried that this gets complicated/murky as to what is shown
> (and what is omitted).  For bridge, we would have to end up dumping
> everything and treat it like 'list hooks'....
> 
> I do admit that it would be nice to have something like:
> 
> nft list pipeline meta input eth0 ip saddr 1.2.3.4 ip daddr 5.6.7.8
> 
> and then have nft:
> 1. list NFPROTO_NETDEV for eth0 ingress only (no egress)
> 2. list NFPROTO_INET hooks for ingress eth0
> 3. list NFPROTO_IPV4 hooks for prerouting
> 4. query FIB to get output device for 1.2.3.4->5.6.7.8
> 5. list NFPROTO_IPV4 for EITHER input or forward+postrouting
> 6. for forward case, list NFPROTO_NETDEV egress hooks for the
> fib-derviced output device
> 
> But thats hard, because there might be rules in place that
> alter ip daddr or ip saddr, or packet mark etc etc so the
> pipeline shown can be a wrong.

Yes, providing a pipeline description is a much wider task than just
listing hooks. Please, move on with restoring list hooks.

Thanks Florian.
