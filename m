Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF58331E823;
	Thu,  5 Mar 2026 09:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772703626; cv=none; b=BifAoIk5Rdm5PVjblfqObwgAdCot/nJxnuS29Cd5IsJW/sWwzfurGBz2rf5g2Hw2rLPWYB9O29hu/BjHPvSCScpfbtsplzozAr6Uceio8KRgRI2K8Eb4zCUlK75nhjQ0DgVFiCBJaItQlRYg/yC8/XxJMFP1WTdC+HwJSOGA23g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772703626; c=relaxed/simple;
	bh=p1mveXsa/Q4CbMNtiAOsXmS6tImykT4LjEd33iUB0k4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g2axuq5MovB38ijIjkuCdQWmCKf6DRp6hWFZpkPpZhmttDxAEBGlB8MfheJuEdSgwkc1d73tkvQhJs6ZpNbdK0yySVWvT5N2TCfvIJmkPKGFfvxkxnLLU+INorCD5co1+UvHyxSx6eETiL3vfjj0KGnDgBKyWcQnEXaW30j7VmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=f2ybZO9l; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="f2ybZO9l"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 23A12602CC;
	Thu,  5 Mar 2026 10:40:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1772703616;
	bh=9r4TFdWb4XBQbqmwMWxCH/5YNQ8V/9bxzevc4XttvHI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f2ybZO9lncpSgXDyVnKNym5XDCpdwuBhd8bU108ZUkWVqp0ezVXh4lO1dTpWcdrPO
	 pnxrq/SjCEVPGP2bLaK+bwbm+UIuWD/YAB0okfMaYOaJT/OTYK8mSHuwFqZSxfgYCn
	 gm5UOf5lgzWf8QbtUaANo7erRe87mQrJ45+FvTRoD2Ow/6ai0sl7seXn6RQEt8FFES
	 kxUO7FjmDv0NQKlPTHnKQy4YLVqX7kevw5Mhip3pKBmBMCtgowoz0f76L2lKEojLZZ
	 Qje6pytATM8rAP6/KubZ8URJ487rBBsAgHFOWIQvjnrOINfyXZbLKFeEyEB8SiqEaU
	 MJa1u+Be/0mbA==
Date: Thu, 5 Mar 2026 10:40:14 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net 0/4] netfilter: updates for net
Message-ID: <aalPfgw5Ypsik8NY@chamomile>
References: <20260304172940.24948-1-fw@strlen.de>
 <aaiqrFrus1syOmlT@chamomile>
 <aalHS6-11HUHy-Dd@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aalHS6-11HUHy-Dd@strlen.de>

On Thu, Mar 05, 2026 at 10:05:15AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Hi Florian,
> > 
> > On Wed, Mar 04, 2026 at 06:29:36PM +0100, Florian Westphal wrote:
> > > Hi,
> > > 
> > > The following patchset contains Netfilter fixes for *net*:
> > > 
> > > 1) Fix a bug with vlan headers in the flowtable infrastructure.
> > >    Existing code uses skb_vlan_push() helper, but that helper
> > >    requires skb->data to point to the MAC header, which isn't the
> > >    case for flowtables.  Switch to a new helper, modeled on the
> > >    existing PPPoE helper. From Eric Woudstra. This bug was added
> > >    in v6.19-rc1.
> > 
> > In patch 1/4, why is this new function so different wrt. skb_vlan_push?
> >  
> 
> I asked that to Eric when I reviewed this, and that was his reply:
> --------------------------------------------------------------------
> The code here for the inner header is an almost exact copy of
> nf_flow_pppoe_push(), which was also implemented at the same time.
> So handling pppoe and inner-vlan header is implemented in the same
> manner, which keeps it simple and uniform. If one functions
> (in)correctly, then so would the other.
> 
> I've been implementing handling the inner vlan header like this for a
> half year now. My version of nf_flow_encap_push() was a bit different,
> but after this patch it is quite similar.
> --------------------------------------------------------------------
> 
> >                 skb_postpush_rcsum(skb, skb->data + (2 * ETH_ALEN), VLAN_HLEN);
> >         }
> >         __vlan_hwaccel_put_tag(skb, vlan_proto, vlan_tci);
> >  
> >  
> > In case there are two VLANs, the existing in hwaccel gets pushed into
> > the VLAN header, and the outer VLAN becomes the one that is offloaded?
> >  
> > Is this reversed in this patch? The first VLAN tag is offloaded, then
> > the next one coming is pushed as a VLAN header?
> 
> Yes, it looks broken.  I wonder why we have no tests for this stuff.
> First a vlan push function that cannot have worked, ever, now this
> seemingly reversing-headers variant:

This used to work, I just accidentally broke it when using
skb_vlan_push() in net-next.

I will post fix.

> For PPPOE, its pushing the ppppe header to packet, so we get
> strict ordering, later header coming in the stack gets placed on
> top, before older one.
> 
> Here, first vlan push gets placed into hw tag in skb (which makes
> sense, let HW take care of it).
>
> But if 2nd comes along, then that gets placed in the packet
> and the hwaccel tag remains?
>
> What to do?  Should be nuke vlan offload support from flowtable?
> It appears to be an unused feature.
>
> I have low confidence in this code.

Could you elaborate more precisely?

Thanks.
