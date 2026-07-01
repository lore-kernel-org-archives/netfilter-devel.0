Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9225F4949F6;
	Wed,  1 Jul 2026 12:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782908625; cv=none; b=I+14zVdUmHfBWtECCSwrExl1zZb4n0GKiF28sD397qQ9/tEwPlVXItSd1NuggRE879dGaet4nvo2lBi0WYRV6Ij5goKT7f5+Ntorta97JTz00rxJ69G51NgKtFq4jlVpX05v8zUiv8RGz/jzBws987aKnDdNOR2oY2r1LtKfSPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782908625; c=relaxed/simple;
	bh=k+TtxdtUUMAMOmrO0Jqc9RQB983Yil6KUMLWD0iKzLg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cap3uVbXjhXOFGYUalDN0If2hUXgYxIKl8DoBAgMjkPugfsltkt6Md9LJaeCH0ZAEfgrdxVW/EKfeOB4SZ1zzXDa8jy75gBndtzW9igz+Ed21CGjZbkgNhNruc73ZW5ZboNA8WyqOZRaz/rOtNK9OVQgNKiZYdV1u35nynXTPAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=JlS/zuC6; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="JlS/zuC6"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 6203E60195;
	Wed,  1 Jul 2026 14:23:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782908621;
	bh=sCh18bJ0wsKk0ClQVCz3RmLPmzhnTlCWwrzk5awYpIA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JlS/zuC6eaRW07/3ttn8IKtHI5B6NLUh594swdJuIqwGV3gRrfhZYd8kMrLYk6Pz4
	 RgsbmIOgBnwNyTBU/+xrdKLUd9mY7nUKJRzeVcqWCC+Bb8kCayw3E5HmrVVcaolUpR
	 r/F6woxJkuPPIgVT6rOVwh5this4WcknsV/VX4yI9B4+5GcS4LqIkINhqYedlLg+82
	 YnZTaE1vZGtM8M6KX6Igq9eKlGkTbPT2+2T139GAUG4l5F0G3sFctG4z0IUmBdqmAM
	 9Iehqf5uG6u2U6dBCULw7bbhJJuZ6Q05FIcbRr35yicn+0LPOTNilslF2AC4V9znr4
	 l6gO8PEDcp3Dw==
Date: Wed, 1 Jul 2026 14:23:38 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net 4/9] netfilter: nf_conntrack_sip: validate skb_dst()
 before accessing it
Message-ID: <akUGynHszNDwFjJ6@chamomile>
References: <20260630045243.2657-1-fw@strlen.de>
 <20260630045243.2657-5-fw@strlen.de>
 <akS1W7XGQ3LiP0LC@strlen.de>
 <akTzomC4Qz8u8teJ@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <akTzomC4Qz8u8teJ@chamomile>

On Wed, Jul 01, 2026 at 01:01:58PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Jul 01, 2026 at 08:36:11AM +0200, Florian Westphal wrote:
> > Florian Westphal <fw@strlen.de> wrote:
> > > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > > 
> > > tc ingress and openvswitch do not guarantee routing information to be
> > > available. These subsystems use the conntrack helper infrastructure, and
> > > the SIP helper relies on the skb_dst() to be present if
> > > sip_external_media is set to 1 (which is disabled by default as a module
> > > parameter).
> > 
> > The sashiko drive-by appears real, I submitted a patch for it.
> > Its not a regression added by this patch but a unrelated issue.
> > 
> > https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260701062922.9660-1-fw@strlen.de/
> 
> Is skb_ensure_writable() bogus here?
> 
> As you said, skb is already linearized. As for clones, they should
> only happen in br_netfilter? In such case, it should be br_netfilter
> that should be audited not to pass cloned skbuffs before calling the
> inet hooks.

Forget this, this skb_ensure_writable() is really needed here.
