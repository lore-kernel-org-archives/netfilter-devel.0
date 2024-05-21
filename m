Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124A2487BC
	for <netfilter-devel@vger.kernel.org>; Tue, 21 May 2024 12:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716295737; cv=none; b=p4JsvYN2KBExHPBhRip5lUsEZpCOoz1hwn7jq2X1TWDQfQl145Q2AHutpa8GuyvyBAA+DvYl02h22sNmsbKCGI3UNMOz1gyGS5PB8Nkhjg6Dbj2NBAaAQNhwuE00XTm8sW5cWFkaUVrPgMvblKQw6L3UNLUPiXeXmR2KqPPHP5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716295737; c=relaxed/simple;
	bh=wj2bKM6p8NJB7H6yY7AEJP6ZnUAOj4p+JUsEwzCbaJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZzuAOml/WUD4AOsVuPTKtRCOWkm2eCaprTl3pO4GEI08ALZgbQkrquwLsfvmVI5mbUev7jGiIU0FMvn9kh/rBsgHlxRK2fhWnsSvA9RALcEewlmdK5RC1dP0glxPqKur1rdc074+s5o+N+4bTjvaYbIh/O/dcdsc1PYvK5QoYPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1s9OvC-0000b6-RW; Tue, 21 May 2024 14:48:50 +0200
Date: Tue, 21 May 2024 14:48:50 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Antonio Ojea <aojea@google.com>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] netfilter: nfqueue: incorrect sctp checksum
Message-ID: <20240521124850.GC2980@breakpoint.cc>
References: <20240513220033.2874981-1-aojea@google.com>
 <Zkszmr7lNVte6iNu@calendula>
 <Zktv4TN-DPvCLCXZ@calendula>
 <ZkuXgB_Qo5336q4-@calendula>
 <ZkuasOTMseQKGUr_@calendula>
 <CAAdXToQRUiJBzMPGZ7AD_16A-JRZNUrr0aJ20mwaoF7gb92Rqg@mail.gmail.com>
 <Zkx8BCuu6dyTDjcX@calendula>
 <20240521105124.GA29082@breakpoint.cc>
 <ZkyOjy0YBg35tUrk@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZkyOjy0YBg35tUrk@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > userspace, my proposal:
> > > 
> > >               if (!skb_is_gso(skb) || ((queue->flags & NFQA_CFG_F_GSO) && !skb_is_gso_sctp(skb)))
> > >                         return __nfqnl_enqueue_packet(net, queue, entry);
> > 
> > This disables F_GSO with sctp packets, is sctp incompatible with nfqueue?
> 
> This will send a big SCTP payload to userspace (larger than mtu),
> then, userspace will send the such big SCTP payload to kernelspace via
> nf_reinject().

I'm not following.

  if (!skb_is_gso(skb) || ((queue->flags & NFQA_CFG_F_GSO) && !skb_is_gso_sctp(skb)))
     return __nfqnl_enqueue_packet(net, queue, entry);

Means:
1. skb isn't gso -> queue, OR
2. Userspace can cope with large packets AND packet is not sctp-gso
-> queue

-> sctp gso packets are fully software-segmented in kernel, and
we queue n packets instead of 1 superpacket.

Apparently GSO SCTP is incompatible resp. skb_zerocopy() lacks
GSO_BY_FRAGS support.

Too bad.

> Can kernel deal with SCTP packets larger than MTU?

As far as I can see the gso helpers used in fwd and output
path handle this transparently, i.e., yes.
