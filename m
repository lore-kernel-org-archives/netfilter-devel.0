Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A501D61B7
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2026 00:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773966295; cv=none; b=mjlMpxj2V+px+6GYLVJmucBEi7MpFM42xkjHZx0/qsVNT7m8KjXILHiJdZYbMnuFFpM6X3+WcXkMSD9HHnBgS/QoqpDnGbQksQYKuRhOLuduTujJICfS5LsfthMialbADK4m+X5gInBbQoGLShBReKmI8cS7vN+gS+kOvJgQ+fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773966295; c=relaxed/simple;
	bh=YBTNXCWE82fh2pIILXnj6SWDDBegP7WB4SVPe3FGEIU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tWoe0IVZs551zHlJ7f0CSXoabZi3hyHCU6RWIbtfbsZSJLVd7D0VF6rxiTwpWhFGO4L6l1g1by1Tzs0byylsI/9D4bdF/+DnEYXZbLdweoJOhHdS5LMse3uwK6qsaIPOlwrxutpfsDFd7bstK+x8e8vE2GD3v13PxeCYVrnUDbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=p9webqaA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="p9webqaA"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 7FD1F600B5;
	Fri, 20 Mar 2026 01:24:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773966283;
	bh=CVLnqBE3sQRpp04+pzP0AQwqWUXv0YxSYk0D0BcQYxE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p9webqaAEXOEs6zmTK0jO39e0TI4Yy1CZCKVI52wSRnKDJ+zuojH6qZoR4UZdH7c7
	 dTDWifnBsmccJWkUgizdeDiEnbWIKNwZcf8cvRY2KP8uv0cnEp0q3Hyh9uYSfLC5oP
	 uduM4XmJhml6BXYdbxYLyfGjhFzp3+oW4vDkwrVU9kHJU2HocvCm5UBnbAm/oeeA7m
	 ahibJADVmQ6YzKQZ6/co/MhjNqSFEivrtJm+Iamdv3ZAS47r2hkvLJULlRYFa89Ytm
	 7g9+Y+DUmyozHjpmLqVRsh85KH4xoxGzXJELbr/z0qlw9cawlFpcp0N5fW2HgnvTwE
	 imFNi7j9vs0Rg==
Date: Fri, 20 Mar 2026 01:24:40 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH] netfilter: nfnetlink_hook: Dump nat type chains
Message-ID: <abyTyJBv47f3v9gd@chamomile>
References: <20260313153220.19662-1-phil@nwl.cc>
 <abwegj2TijkaQVLz@strlen.de>
 <abwraHUuxizN4krg@orbyte.nwl.cc>
 <abwtAkSF8-SmH684@strlen.de>
 <abxlzn7lymOxWUFa@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <abxlzn7lymOxWUFa@orbyte.nwl.cc>

On Thu, Mar 19, 2026 at 10:08:30PM +0100, Phil Sutter wrote:
> On Thu, Mar 19, 2026 at 06:06:10PM +0100, Florian Westphal wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > > Ah, so the nat-type chain's priority value orders it inside the
> > > dispatcher's list.
> > 
> > Yes.
> > 
> > > Maybe I should print them below the dispatcher hook with extra
> > > indentation? Maybe extra braces could further clarify, e.g.:
> > > 
> > > | hook postrouting {
> > > |         +0000000100 nf_nat_ipv6_out [nf_nat] {
> > > |                 +0000200000 chain inet nat postrouting [nft_chain_nat]
> > > |         }
> > > |         +2147483647 nf_confirm [nf_conntrack]
> > > | }
> > 
> > Actually  one could override the hook value with the one of the
> > nat base hook.  The ordering inside the dispatcher is whats important,
> > the exact numerical value isn't important.
> 
> Hmm. I like how one can use 'list hooks' output to find a good spot for
> a new base chain. The real nat chain priority value is needed for that,
> but no point in considering made up use-cases. Seeing the chains
> attached to a given nat dispatcher is already a step forward, and having
> their ordering is probably well enough.

I guess the goal is to expose iptables and nftables in place?

Is it really needed to expose this internal +0000200000?

Maybe simply report instead?

         +0000000100 nf_nat_ipv6_out [nf_nat]: chain ip nat POSTROUTING [iptable_nat]
         +0000000100 nf_nat_ipv6_out [nf_nat]: chain inet nat postrouting [nft_chain_nat]

Yes, it looks like a duplicate, but it is sort of how it works now, no
need to expose dispatcher details.
