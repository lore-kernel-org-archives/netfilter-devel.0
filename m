Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F33DB54913
	for <netfilter-devel@vger.kernel.org>; Tue, 21 May 2024 12:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716293272; cv=none; b=r0gxwO/LvmVzWglcN4EpU9XJvUKj7zN0Wp7twHw1z6k8XWSsPA+KD2sNzmaXvWoSlvqn5ZjhNIFtbRgJLOQLQDHSnT+bhfU3ZCGUbcyY6Z7HVHPl1mumhAG+lvLfwFrlrzNyDDkhU7790BHVbg8/77+Dm6EE1JVEYzOVex4Bap8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716293272; c=relaxed/simple;
	bh=wzsVfK1sr7zYSJM7We2U9aqn5K7rD0LwjJr/O9mEm1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JIBoooS/pBRwRFYnujk64RJs9z+zc6r3zc73bCTzVWkLF96tVD3P2LLCxB0IVjux2KcNSJFFa8qYy0gu3OrZ8HWtEqgHGIe72lDC+cWDSjur2HnOSfd42SMqpeHlPNN68/42RjGwuBz+OrwO0Ngvd8PCnNBGojHyY46+6i8xU6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Tue, 21 May 2024 14:07:43 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Antonio Ojea <aojea@google.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] netfilter: nfqueue: incorrect sctp checksum
Message-ID: <ZkyOjy0YBg35tUrk@calendula>
References: <20240513220033.2874981-1-aojea@google.com>
 <Zkszmr7lNVte6iNu@calendula>
 <Zktv4TN-DPvCLCXZ@calendula>
 <ZkuXgB_Qo5336q4-@calendula>
 <ZkuasOTMseQKGUr_@calendula>
 <CAAdXToQRUiJBzMPGZ7AD_16A-JRZNUrr0aJ20mwaoF7gb92Rqg@mail.gmail.com>
 <Zkx8BCuu6dyTDjcX@calendula>
 <20240521105124.GA29082@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240521105124.GA29082@breakpoint.cc>

On Tue, May 21, 2024 at 12:51:24PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > I see, so I fixed the bug in one direction and regressed in the other
> > > one, let me retest both things locallly
> > 
> > The check to force GSO SCTP to be segmented before being sent to
> > userspace, my proposal:
> > 
> >               if (!skb_is_gso(skb) || ((queue->flags & NFQA_CFG_F_GSO) && !skb_is_gso_sctp(skb)))
> >                         return __nfqnl_enqueue_packet(net, queue, entry);
> 
> This disables F_GSO with sctp packets, is sctp incompatible with nfqueue?

This will send a big SCTP payload to userspace (larger than mtu),
then, userspace will send the such big SCTP payload to kernelspace via
nf_reinject().

Can kernel deal with SCTP packets larger than MTU?
