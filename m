Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEBC376E5;
	Wed,  5 Jun 2024 18:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717612704; cv=none; b=Ur9Z6N9b6zthio7xaBlqMHWaJ9unsireydCzT/G5T0HZ/WDIRvrNAwS7fHcJpRjyGb1f3Wb5O/c/IGDS7eIcMP6WJv61e/5dwuQGyY+hoU0ENo2U59DVCgq8LEyGzkiCyWaeEBWGP+dbJrgE2inRLXVW/VROp5Maj/L+b6wGKFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717612704; c=relaxed/simple;
	bh=RjxGt6g9w1f0jv2X41M0MAEFwL2pBnoNdOjvbuoy4Co=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RNsM7fETZaW0X+i1+fsEVIC92b00SlqlhxQ9MTKIHUb3zJLjbbHx2iRXziXN/uaTBattBecqXlAtfJ3kz8b/DRTNKlvUBCX/LUTZRTA3FtS9dYy4Zaj+ElPF5F8EpBwTIQGbGxu5FlsSx05bKdLUboACzU8/8sNSooco/Whv6g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [46.222.228.168] (port=1618 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sEvWZ-00AuEP-1N; Wed, 05 Jun 2024 20:38:17 +0200
Date: Wed, 5 Jun 2024 20:38:13 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Christoph Paasch <cpaasch@apple.com>
Cc: Florian Westphal <fw@strlen.de>,
	Netfilter <netfilter-devel@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
	daniel@iogearbox.net
Subject: Re: [PATCH nf] netfilter: nf_reject: init skb->dev for reset packet
Message-ID: <ZmCwlbF8BvLGNgRM@calendula>
References: <20240604120311.27300-1-fw@strlen.de>
 <FF8A506F-6F0F-440E-9F52-B27D05731B77@apple.com>
 <20240605181450.GA7176@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240605181450.GA7176@breakpoint.cc>
X-Spam-Score: -1.8 (-)

On Wed, Jun 05, 2024 at 08:14:50PM +0200, Florian Westphal wrote:
> Christoph Paasch <cpaasch@apple.com> wrote:
> > > Reported-by: Christoph Paasch <cpaasch@apple.com>
> > > Suggested-by: Paolo Abeni <pabeni@redhat.com>
> > > Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/494
> > > Signed-off-by: Florian Westphal <fw@strlen.de>
> >
> > I just gave this one a shot in my syzkaller instances and am still hitting the issue.
>
> No, different bug, this patch is correct.
>
> I refuse to touch the flow dissector.

I see callers of ip_local_out() in the tree which do not set skb->dev.

I don't understand this:

bool __skb_flow_dissect(const struct net *net,
                        const struct sk_buff *skb,
                        struct flow_dissector *flow_dissector,
                        void *target_container, const void *data,
                        __be16 proto, int nhoff, int hlen, unsigned int flags)
{
[...]
        WARN_ON_ONCE(!net);
        if (net) {

it was added by 9b52e3f267a6 ("flow_dissector: handle no-skb use case")

Is this WARN_ON_ONCE() bogus?
