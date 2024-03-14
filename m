Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B6B1E4A6
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Mar 2024 11:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710415292; cv=none; b=sWubrSVGwYdX3Ax0Ll93R0EVQExHGdk96bJFLzIlrcAXWiZ2+cS9cRhC6GqV6SEuiE2FtG34pj1xAxhYNB23GRJ1mmXFchFSDfk0MZqevQTAmjpWH1w1/RRb0FMB7uf1upYjvYt/X9Xf8c4oeWDpXEVVSbw7nW3skygQO6tjAFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710415292; c=relaxed/simple;
	bh=C4rADEtaqf/QydS0fK8XuZoP0SZeeGU4zCjwyv6E84Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kwhP+RI+I3dm0qJB4R3uncKfdhjQO/azylweggBhQdyCJoLT6Jq8EM0eXZonO0aN5ACVDufqUm6HFzzCPTfCqc5vRTQbbELFUpHt2qppppZbzJAd1dMC98sBN1HK0vh9p05kmD6XupjCgz0pRR7YDt7o1HgeGYkyS0pS0OdK8Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rkj9K-0006lb-1Q; Thu, 14 Mar 2024 12:21:26 +0100
Date: Thu, 14 Mar 2024 12:21:26 +0100
From: Florian Westphal <fw@strlen.de>
To: Sven Auhagen <sven.auhagen@voleatech.de>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: Flowtable race condition error
Message-ID: <20240314112126.GC1038@breakpoint.cc>
References: <x6s4ukl7gfgkcap6b56o6wv6oqanyjx4u7fj5ldnjqna7yp6lu@2pxdntq2pe5f>
 <20240313145557.GD2899@breakpoint.cc>
 <20240313150203.GE2899@breakpoint.cc>
 <yyi2e7vs4kojiadm7arndmxj5pzyrqqmjlge6j657nfr4hkv4y@einahmfi76rr>
 <20240313152528.GF2899@breakpoint.cc>
 <2rzv5gwtw3mp4hzndzb4sjtnibefs7sjcsychvm7vpoy5wetv2@ssrxj7cmi42b>
 <20240314092541.GB1038@breakpoint.cc>
 <3ku3nssbmgc7jn7mlslvag5rdn2mbqcszkm4mccnzd72uhbb3o@uwkhkhxg3msw>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ku3nssbmgc7jn7mlslvag5rdn2mbqcszkm4mccnzd72uhbb3o@uwkhkhxg3msw>
User-Agent: Mutt/1.10.1 (2018-07-13)

Sven Auhagen <sven.auhagen@voleatech.de> wrote:
> I think you have a valid point with the not calling flow_offload_teardown but maybe
> we need to do something else instead like lower the flowtable entry timeout to trigger a
> faster gc for both udp and tcp.

conntrack core should receive the fin/rst packet, and should switch the
state entry accordingly, i.e. away from established.

I suspect that gc_worker() "repairs" the timeout to a hige value again
because the OFFLOAD flag is left in place.

However, this change:

> >         if (nf_flow_has_expired(flow) ||
> >             nf_ct_is_dying(flow->ct) ||
> > +           !nf_conntrack_tcp_established(ct) ||
> >             nf_flow_custom_gc(flow_table, flow))
> >                 flow_offload_teardown(flow);

(well, flow->ct, I did not test this at all).

should still make flowtable gc remove the entry.

I think if possible we should get rid of ct/flowtable
entanglements where possible rather than adding more.

F.e. early drop should probably not test or care about
offload flag anymore.
