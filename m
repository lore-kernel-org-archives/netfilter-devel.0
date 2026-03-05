Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF40378D64;
	Thu,  5 Mar 2026 09:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772701532; cv=none; b=U7354QQWlCZrr8text2C2guYKki6zz3+ppNCvDCrzlWBRBbuJUcGp6bi5DdRwfUrmmSDJzeTUcofz6feQrTMNSRSsVsr9Mc89MNiDYV1stwboAZsaItq4TPphznycSADKzJu7M8oBI51Z8PK55yyvAiR3UveyMKgkx3ZDPSFj/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772701532; c=relaxed/simple;
	bh=Fk4WW2rYqr2Ghem8k8qRq2E8LoJ8EUxNKFJ+tuT4ek4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KELcXW7gw+tJb/jxPxnmPQGfPxtunVEP/TmCjkuHK2LZZyGkzY3TVNnoyCccgDJ6+E/dcv56ha9iAwW/GuczU0EUT/DZ0PUdoB/OmtqbGtN0uD2wDv6wLRXDjTi9x67JGttb5OWWoNG9y4l24ouQEasg6iKJ0IH1EpUy4nqc0Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 916846047A; Thu, 05 Mar 2026 10:05:22 +0100 (CET)
Date: Thu, 5 Mar 2026 10:05:15 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net 0/4] netfilter: updates for net
Message-ID: <aalHS6-11HUHy-Dd@strlen.de>
References: <20260304172940.24948-1-fw@strlen.de>
 <aaiqrFrus1syOmlT@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaiqrFrus1syOmlT@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Florian,
> 
> On Wed, Mar 04, 2026 at 06:29:36PM +0100, Florian Westphal wrote:
> > Hi,
> > 
> > The following patchset contains Netfilter fixes for *net*:
> > 
> > 1) Fix a bug with vlan headers in the flowtable infrastructure.
> >    Existing code uses skb_vlan_push() helper, but that helper
> >    requires skb->data to point to the MAC header, which isn't the
> >    case for flowtables.  Switch to a new helper, modeled on the
> >    existing PPPoE helper. From Eric Woudstra. This bug was added
> >    in v6.19-rc1.
> 
> In patch 1/4, why is this new function so different wrt. skb_vlan_push?
>  

I asked that to Eric when I reviewed this, and that was his reply:
--------------------------------------------------------------------
The code here for the inner header is an almost exact copy of
nf_flow_pppoe_push(), which was also implemented at the same time.
So handling pppoe and inner-vlan header is implemented in the same
manner, which keeps it simple and uniform. If one functions
(in)correctly, then so would the other.

I've been implementing handling the inner vlan header like this for a
half year now. My version of nf_flow_encap_push() was a bit different,
but after this patch it is quite similar.
--------------------------------------------------------------------

>                 skb_postpush_rcsum(skb, skb->data + (2 * ETH_ALEN), VLAN_HLEN);
>         }
>         __vlan_hwaccel_put_tag(skb, vlan_proto, vlan_tci);
>  
>  
> In case there are two VLANs, the existing in hwaccel gets pushed into
> the VLAN header, and the outer VLAN becomes the one that is offloaded?
>  
> Is this reversed in this patch? The first VLAN tag is offloaded, then
> the next one coming is pushed as a VLAN header?

Yes, it looks broken.  I wonder why we have no tests for this stuff.
First a vlan push function that cannot have worked, ever, now this
seemingly reversing-headers variant:

For PPPOE, its pushing the ppppe header to packet, so we get
strict ordering, later header coming in the stack gets placed on
top, before older one.

Here, first vlan push gets placed into hw tag in skb (which makes
sense, let HW take care of it).

But if 2nd comes along, then that gets placed in the packet
and the hwaccel tag remains?

What to do?  Should be nuke vlan offload support from flowtable?
It appears to be an unused feature.

I have low confidence in this code.
