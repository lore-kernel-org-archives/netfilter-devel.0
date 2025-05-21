Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BF676034
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 13:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747835553; cv=none; b=fRO3ohE45Iw9/BH2mu9nZ1CeQ7kQZ/DCXPXlP7ct+VzpQ2IdjXkNQoqYyWnOWkqSFk8N4zgK/te5B3fLAvaMgOvmpb49+/ObfzJN0N3Tn7sj+/bWwDeRT6LTOWjEjhBMNJW1PNI3kFP2/qVPKqFH7/G4Rg1ijKQs7Jkm8KruXPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747835553; c=relaxed/simple;
	bh=kl9FV5+7AI78x2Jj50N4Hh9PIXCofE7JCKqHt4kgOPk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rAkrxBCBbhA0WJupva7giA8q6cNdx1DAEEuKtA1CyRiu3Ut362Gvkay1djhFSLPVhIaUq67LPcHn55evAIg/FQoYdV3osWNdCxSmti5e4TlER9vcVxf1sG4bgm2p/QsEqpz28o+DiLBZ9m4zkSHSIRDZsZSU9hIyGl6JAxQP7C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=I4dDxhca; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FLPuYPFB; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="I4dDxhca";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FLPuYPFB"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id F3D23602E3; Wed, 21 May 2025 15:52:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747835548;
	bh=Kc4eZJF2FFrvDDBbqeIgaQ0DZIeJMiTQ2W+6JBrGask=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I4dDxhcaGvz+FRPGi0DOtqCJl+CKapBF7g0Rr2mQuZfWmkME45bpNyKmMzzT9Q6Wp
	 Tweh2Zu4lqM1cRirINlFagJpDAXZO3cq8D9tq8IkXuhgV9FO8y3yFSv4LOLvNkQFVg
	 xJyW74j+NxTd6V8saeS0fQPUUsDDEjQd7mErry5N8RIHXLUEhfgLT+N6BaOGHxO8/z
	 jqZJsOtOY0p3lipHvhfXfa10FdX3Pi/tHGtQz+4b7TSP63Gq9z3Ue2Hs+To9pj7ksJ
	 Dm1PC1BNxU9/Hq3rIeLxkueWQczV+iHJllvcCJJ7+H57/QirhMJ1AhCDQcbvO1wXbS
	 igqdDrSgHdfhw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3F10B602E3;
	Wed, 21 May 2025 15:52:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747835547;
	bh=Kc4eZJF2FFrvDDBbqeIgaQ0DZIeJMiTQ2W+6JBrGask=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FLPuYPFBcF/CWyb95HBLcclREhVGUWV1nNpLclkpoLYph/yW+o4pKZl7I/X+cWzAd
	 6k0pKDVD7sexJR9D89DIXTGOeMh+t50Oz21AnKInJeJ8MoiPjEIE9odXTKyLQ+udGm
	 1ccieRAepoDYxzOwkXPDG8h5ovnSl212DofjTxzJ+uUMWQo7pSA4w4YK3JpEyFZdcv
	 OrQPqHz6hdzkPpOxO7mjCC+5D3sRiYie/S4tUeCcD5TYIurtS0PSS9NwMDA8KgD2HP
	 c4gM8h3RJkmeGmlPBXbS4ueEZRhOh0KNJPSu/xQTAwL+mZq1hki6QPW0hogTfNi6RH
	 udH/4y/ZYhNgA==
Date: Wed, 21 May 2025 15:52:24 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 2/2] netfilter: nf_tables: add packets conntrack
 state to debug trace info
Message-ID: <aC3XAyaYio7T--ik@calendula>
References: <20250508150855.6902-1-fw@strlen.de>
 <20250508150855.6902-3-fw@strlen.de>
 <aC2eUd6OOxn9ramP@calendula>
 <aC24SHR6Jl0uMhVl@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aC24SHR6Jl0uMhVl@strlen.de>

On Wed, May 21, 2025 at 01:26:00PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > +		if (nla_put_be32(nlskb, NFT_CT_ID, (__force __be32)id))
> > > +			goto nla_put_failure;
> > > +
> > > +		if (status && nla_put_be32(nlskb, NFT_CT_STATUS, htonl(status)))
> > > +			goto nla_put_failure;
> > 
> > NFT_CT_* is enum nft_ct_keys which is not intended to be used as
> > netlink attribute.
> > 
> > NFT_CT_STATE is 0 which is usually reserved for _UNSPEC in netlink
> > attribute definitions.
> > 
> > My suggestion is that you define new attributes for this, it is
> > boilerplate code to be added to uapi.
> 
> In that case I would prefer not to use NESTED attribute for this, i.e.:
> 
>  * @NFTA_TRACE_CT_ID: connection tracking information (NLA_U32)
>  * @NFTA_TRACE_CT_STATUS: connection tracking information (NLA_U32)
>  * @NFTA_TRACE_CT_STATE: connection tracking information (NLA_U32)
> 
> ... and so on.  I see no potential for attribute re-use.
> 
> The only argument for NESTED is that userspace can check for presence
> of NFTA_TRACE_CT/NESTED instead of checking each ct trace attr in
> sequence.
> 
> Whats you preference?

Flat representation (no nesting) is fine with me in this case.

Thanks.
