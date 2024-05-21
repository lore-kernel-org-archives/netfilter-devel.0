Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54DD51E48B
	for <netfilter-devel@vger.kernel.org>; Tue, 21 May 2024 12:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716296338; cv=none; b=qsN8f5NEFHeoxcjCbOzJ9wNek1VCs6fkkLuX77+6yRviee1fT4HLw/ZrNqMduDiC6RmGHx5vmek2qJPnmGZiXNpk/ltjb2hiri9NmzlQKIJ7tlX5mF/MlfNeLi9v+Xa4ukl1rKJcA7C4gc8gR+9ZW0PkT8omOsUhPw4ygbXkirg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716296338; c=relaxed/simple;
	bh=FG/Gi01dTZv15t2HWEky9nFCTfoarLCx58S0lqBipXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qvYs1tihWurxM8xly6uruRRq0TUcWd1M80uVs0VPUk+qDL+aH8E3AoTcK4Ni0VKZksjd50ib0v97ylGG9N2/SUncXqrGv7HfF4lACPhsuqzpFlDsC+4UP6n0QJIsnmsdslJevRv10RdY7/oXN8zAry/mtNg4GJV5H49dniWtTUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Tue, 21 May 2024 14:58:52 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Antonio Ojea <aojea@google.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] netfilter: nfqueue: incorrect sctp checksum
Message-ID: <ZkyajEEYa0SV8zq-@calendula>
References: <20240513220033.2874981-1-aojea@google.com>
 <Zkszmr7lNVte6iNu@calendula>
 <Zktv4TN-DPvCLCXZ@calendula>
 <ZkuXgB_Qo5336q4-@calendula>
 <ZkuasOTMseQKGUr_@calendula>
 <CAAdXToQRUiJBzMPGZ7AD_16A-JRZNUrr0aJ20mwaoF7gb92Rqg@mail.gmail.com>
 <Zkx8BCuu6dyTDjcX@calendula>
 <20240521105124.GA29082@breakpoint.cc>
 <ZkyOjy0YBg35tUrk@calendula>
 <20240521124850.GC2980@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240521124850.GC2980@breakpoint.cc>

On Tue, May 21, 2024 at 02:48:50PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > userspace, my proposal:
> > > > 
> > > >               if (!skb_is_gso(skb) || ((queue->flags & NFQA_CFG_F_GSO) && !skb_is_gso_sctp(skb)))
> > > >                         return __nfqnl_enqueue_packet(net, queue, entry);
> > > 
> > > This disables F_GSO with sctp packets, is sctp incompatible with nfqueue?
> > 
> > This will send a big SCTP payload to userspace (larger than mtu),
> > then, userspace will send the such big SCTP payload to kernelspace via
> > nf_reinject().
> 
> I'm not following.
> 
>   if (!skb_is_gso(skb) || ((queue->flags & NFQA_CFG_F_GSO) && !skb_is_gso_sctp(skb)))
>      return __nfqnl_enqueue_packet(net, queue, entry);
> 
> Means:
> 1. skb isn't gso -> queue, OR
> 2. Userspace can cope with large packets AND packet is not sctp-gso

Yes, this is implicit case: skb is gso. This is adding an exception
for sctp-gso.

> -> queue
> 
> -> sctp gso packets are fully software-segmented in kernel, and
> we queue n packets instead of 1 superpacket.
> 
> Apparently GSO SCTP is incompatible resp. skb_zerocopy() lacks
> GSO_BY_FRAGS support.
> 
> Too bad.

Then, either extend skb_zerocopy() to deal with GSO_BY_FRAGS or poor
man approach as above: enqueue n packets until that is supported.

By reading this, my understanding is that you prefer to extend
skb_zerocopy(), I pick up from Antonio's work and send a patch.

> > Can kernel deal with SCTP packets larger than MTU?
> 
> As far as I can see the gso helpers used in fwd and output
> path handle this transparently, i.e., yes.
