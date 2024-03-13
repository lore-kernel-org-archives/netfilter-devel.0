Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF55647F46
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Mar 2024 15:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710343533; cv=none; b=hsFA4crjecNiXWkO+9w1ePXAWfh9a/Js8PIm8LigSBBukyA2NvY/6fOrjEtzIxVSMsAP3rgRe7pnKJn3GweESPG6Llcao3nvfJeFQXPqam9lwK12n9lOckT+iV0tNSW4nxXjvIZ38dI/psYkNp9DnAfpnEmMS4YfknijRW22xeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710343533; c=relaxed/simple;
	bh=v7mv5HZvL4lEIHdGcy0L6GcCCwEXLm9r4dwKeyfJkp8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fce7RhFEsV33H5/LwhZBZLH+oFhH3i0i050YDjHbNO0+lLemY49gEXeWyWkzEiOisFusP1SPirgaRBflS+8Kg0oo0ZxpjJeJlw7pjna5jik3OHMQl4hfVpgBoBghTdvmxkTABrYmeArCn8d1s4URNXJYTsBddgA0/WgBd6eU93o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rkQTw-0000Ec-FX; Wed, 13 Mar 2024 16:25:28 +0100
Date: Wed, 13 Mar 2024 16:25:28 +0100
From: Florian Westphal <fw@strlen.de>
To: Sven Auhagen <sven.auhagen@voleatech.de>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: Flowtable race condition error
Message-ID: <20240313152528.GF2899@breakpoint.cc>
References: <x6s4ukl7gfgkcap6b56o6wv6oqanyjx4u7fj5ldnjqna7yp6lu@2pxdntq2pe5f>
 <20240313145557.GD2899@breakpoint.cc>
 <20240313150203.GE2899@breakpoint.cc>
 <yyi2e7vs4kojiadm7arndmxj5pzyrqqmjlge6j657nfr4hkv4y@einahmfi76rr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yyi2e7vs4kojiadm7arndmxj5pzyrqqmjlge6j657nfr4hkv4y@einahmfi76rr>
User-Agent: Mutt/1.10.1 (2018-07-13)

Sven Auhagen <sven.auhagen@voleatech.de> wrote:
> On Wed, Mar 13, 2024 at 04:02:03PM +0100, Florian Westphal wrote:
> > Florian Westphal <fw@strlen.de> wrote:
> > > No idea, but it was intentional, see
> > > b6f27d322a0a ("netfilter: nf_flow_table: tear down TCP flows if RST or FIN was seen")
> > 
> > Maybe:
> > 
> > diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> > --- a/net/netfilter/nf_flow_table_ip.c
> > +++ b/net/netfilter/nf_flow_table_ip.c
> > @@ -28,10 +28,8 @@ static int nf_flow_state_check(struct flow_offload *flow, int proto,
> >  		return 0;
> >  
> >  	tcph = (void *)(skb_network_header(skb) + thoff);
> > -	if (unlikely(tcph->fin || tcph->rst)) {
> > -		flow_offload_teardown(flow);
> > +	if (unlikely(tcph->fin || tcph->rst))
> >  		return -1;
> > -	}
> >  
> >  	return 0;
> >  }
> > 
> > ?
> > 
> > This will let gc step clean the entry from the flowtable.
> Thanks for your answer.
> 
> I double checked and the problem is that the timeout in flow_offload_fixup_ct is set to a very small value
> and the state is deleted immediately afterwards.

but from where is the call to flow_offload_fixup_ct() made?

I don't think tearing down the flowtable entry on first fin or rst makes
any sense, its racy by design.
