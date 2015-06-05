From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: bridge: restore vlan tag when refragmenting
Date: Fri, 5 Jun 2015 16:55:46 +0200
Message-ID: <20150605145546.GI11015@breakpoint.cc>
References: <1433503633-16312-1-git-send-email-fw@strlen.de>
 <1433515021.1895.57.camel@edumazet-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38590 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751444AbbFEOzs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2015 10:55:48 -0400
Content-Disposition: inline
In-Reply-To: <1433515021.1895.57.camel@edumazet-glaptop2.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
> > index 46660a2..0d9ad4a 100644
> > --- a/net/bridge/br_netfilter.c
> > +++ b/net/bridge/br_netfilter.c
> > @@ -115,6 +115,8 @@ struct brnf_frag_data {
> >  	char mac[NF_BRIDGE_MAX_MAC_HEADER_LENGTH];
> >  	u8 encap_size;
> >  	u8 size;
> > +	u16 vlan_tci;
> > +	__be16 vlan_proto;
> >  };
> >  
> >  static DEFINE_PER_CPU(struct brnf_frag_data, brnf_frag_data_storage);
> > @@ -837,6 +839,11 @@ static int br_nf_push_frag_xmit(struct sock *sk, struct sk_buff *skb)
> >  		return 0;
> >  	}
> >  
> > +	if (data->vlan_tci) {
> > +		skb->vlan_tci = data->vlan_tci;
> > +		skb->vlan_proto = data->vlan_proto;
> > +	}
> > +
> >  	skb_copy_to_linear_data_offset(skb, -data->size, data->mac, data->size);
> >  	__skb_push(skb, data->encap_size);
> >  
> > @@ -890,6 +897,9 @@ static int br_nf_dev_queue_xmit(struct sock *sk, struct sk_buff *skb)
> >  		nf_bridge_update_protocol(skb);
> >  
> >  		data = this_cpu_ptr(&brnf_frag_data_storage);
> > +
> > +		data->vlan_tci = skb->vlan_tci;
> > +		data->vlan_proto = skb->vlan_proto;
> >  		data->encap_size = nf_bridge_encap_header_len(skb);
> >  		data->size = ETH_HLEN + data->encap_size;
> >  
> 
> I am curious :
> 
> IP defrag unit does not care about vlan, so how do we ensure all frags
> have same vlan characteristics ?

We don't.  bridge-nf-filter-vlan-tagged=1 completely breaks isolation of VLANs.
(same goes for pppoe header stripping).

In retrospect it was a bad idea to add this feature.

I wouldn't be sad if we'd kill it instead of applying yet another crap
patch for this but I'm afraid that there are people out there that use it.

Perhaps adding TAINT_CRAP on vlan=1 change would be good idea :)
[ Its off by default at least, phew. ]
