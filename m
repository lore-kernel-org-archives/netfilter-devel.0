Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142833B27F4
	for <netfilter-devel@vger.kernel.org>; Sun, 16 Aug 2026 14:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786890326; cv=none; b=ArdD4DRVutI/cOFsjBVO07AO1ZzQNxBTSj2zcbMRud/7XY4vfPMX8W9kXRgioGn9J3C9x3J+d8GUiorOIStiAhixpBDzoeoT8KBJtF+qYfy2JQkw+bHqU8gaxOWWPh4Cpm7aSZQvJ0DV9fyC29m/9msdfwqfxWb/0kxDWCbJyyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786890326; c=relaxed/simple;
	bh=xF2iBSKGmcPdYKQZwEOXStGCa20ILMUoy1eD7D/FcyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cjtgCj+BmjYW26Hw1O0HiXAvrKJZfPQ2TM4u5IGEvxsIWX1kSQnB8a2ATpWEjjqQ07309zfMxnLyREXBHRe6ZTxizb9LVS8vxAzWf247t7FYj3/Bp/JXNO5j+uBkwRfYFstBPLXSKo2ZHAojU1SR4eEUlspjGqUp4zK+GdBJY9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 892EE6051B; Sun, 16 Aug 2026 16:25:14 +0200 (CEST)
Date: Sun, 16 Aug 2026 16:25:14 +0200
From: Florian Westphal <fw@strlen.de>
To: Vimal Agrawal <avimalin@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>, coreteam@netfilter.org,
	Vimal Agrawal <vimal.agrawal@sophos.com>
Subject: Re: netfilter: nf_nat: race in nf_nat_setup_info() corrupts
 nat_bysource list (GPF / soft lockup)
Message-ID: <aoHISuGf2vzWk2s0@strlen.de>
References: <CALkUMdRXAB1nGsBhg77zg2VGZyh-D+rL8kxqDDiEs6qmcXev=g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALkUMdRXAB1nGsBhg77zg2VGZyh-D+rL8kxqDDiEs6qmcXev=g@mail.gmail.com>

Vimal Agrawal <avimalin@gmail.com> wrote:
> Our custom module can decide to send the first packet of a conntrack
> to userspace via NFQUEUE while the rest of the packets for that
> conntrack follow the standard kernel forward path.
> In the case of a bridge, br_flood() clones skbs, and those clones
> share one unconfirmed conntrack for the initial packet(s) (via
> skb_clone()'s __nf_copy(), which just bumps the refcount and copies
> the same ct pointer).
> 
> br_flood() clones the skb; Skb1 and Skb2 share one unconfirmed ct:
>   Skb1 (cpu1): -> nfqueue -> [userspace verdict] -> reinject -> SNAT
> -> confirm (cpu2)
>   Skb2 (cpu1): -> SNAT -> confirm (cpu1)
> Skb1's reinject-triggered SNAT (cpu2) races Skb2's synchronous SNAT
> (cpu1) on the same, still-unconfirmed ct.
> 
> Because of this, SNAT for the two skbs sharing the unconfirmed
> conntrack races across two different CPUs. nf_nat_setup_info() sees on
> both CPUs that the conntrack isn't yet SNAT-initialized, and both try
> to initialize it — pushing the same conntrack node onto the
> nat_bysource hash chain twice, corrupting the list.

Yes, conntrack assumes exclusive access, this is why nfqueue has all
these hacks to drop cloned skbs where we don't own the unconfirmed skb,
e.g. in nfqnl_enqueue_packet().

We could add more hacks but "fixing" nf_nat_setup_info() doesn't really
help, its only one of many possible races.

If you want to add more hacks, you could move:

        /* It's done. */
        if (maniptype == NF_NAT_MANIP_DST)
                ct->status |= IPS_DST_NAT_DONE;
        else
                ct->status |= IPS_SRC_NAT_DONE;

in nf_nat_setup_info to test_and_Set_bit() done while holding the
lock to add to unconfirmed list, failure causes drop.
But it won't solve the underlying design defects.
