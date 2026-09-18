Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CCB37E2FE
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Sep 2026 11:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789731192; cv=none; b=hO0f8gPZfi0hNmCQhfdcau8eFlFWdaUhmR7K9YDV0ZJRFYraXkZ6OQDZreTGIU1loT3/FkSZnf/kaDkK1Ih8B3sUWI+ZZzzGbg0hs/dGfSq9eXpk68nKG5E74hG6ADWjOL48jB/lU3Rz1Pesk4pSy76G57lO/0FqPN9SIfxOeVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789731192; c=relaxed/simple;
	bh=Qmpd3gKAgQmgHjqtFrOpVhXn1OPzS8qNHGiew6PYy+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IKYE8fd/8HvafwUwhCj6+J4nzzjHTOkAtfE0M5LxeDvbK2ZOOCnpblGRHBXcrwNiITVEwNpiRFuw+G5yuw9Td10fA7iYfacqsiOeSwAtFcRXBPDQ3pw91X4zed5I7XXEejErE+rcjTxdRTWHZMA7rGu+HPZyIm2jyazg95MMS54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ujzJL9lT; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ujzJL9lT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789731188;
	bh=q7x+BDyIegBYz4Zw9tW7sL/j0ikl0Y3lynUI8YTBDYs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ujzJL9lTUvLLsIbo9G0Hwto6fKsFjdLEPo7x+XN2Z2AYPvLW/grap1TVyW6L9EwEE
	 kKSCkuXKN3qqoWywRCU6LMuPQnm1nlooX6BjKvmS5F55ZRGivf1RxhPQOKOuZj4s7o
	 JoGoEs0MtLqYv09Eg5tKIw2uiUTpxccGjB1HrqdHiAKctUfW1HQWf0YjNbbGZI1lec
	 ShkgLGgiHRy0ISoHQFi3sPeLT8qSkBqHyuUWDvseRjCFsQ321H+dms8QVjS+33PX4c
	 vVlKA2pt23nYAznGEJqCOsqFV/P90/wnbOG8pDCJiG7tJuANq87ex2M/oQA0y1E42N
	 P2dR2dXMee2Lw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 8EA296007C;
	Fri, 18 Sep 2026 13:33:08 +0200 (CEST)
Date: Fri, 18 Sep 2026 13:33:06 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Ren Wei <weir@nebusec.ai>, netfilter-devel@vger.kernel.org, phil@nwl.cc,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org, kaber@trash.net,
	vega@nebusec.ai, petalzu987@gmail.com
Subject: Re: [PATCH nf 0/1] netfilter: nf_ip6_checksum: validate checksum
 offset
Message-ID: <aq0hcstVk4JsPjWM@chamomile>
References: <cover.1789660425.git.petalzu987@gmail.com>
 <aq0UpHHbvxjR2jLb@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aq0UpHHbvxjR2jLb@strlen.de>

On Fri, Sep 18, 2026 at 12:38:28PM +0200, Florian Westphal wrote:
> Ren Wei <weir@nebusec.ai> wrote:
> > From: Zixuan Chai <petalzu987@gmail.com>
> > 
> > Hi Linux kernel maintainers,
> > 
> > We found and validated an issue in net/netfilter/utils.c. The bug can be
> > reached by a non-root user when unprivileged user namespaces are enabled,
> > using user and network namespaces. We tested the fix in QEMU, and it does
> > not affect valid checksum handling or other tested functionality.
> > 
> > We will provide detailed information about the bug in this email,
> > along with a PoC to trigger it.
> 
> patch is fine, but could you make another patch that either fixes
> ipv6_find_hdr() or ip6_packet_match() / nft_set_pktinfo_ipv6() as well?
> 
> If I read this right then ipv6_find_hdr() returns nexthdr 'TCP',
> but its clear packet is malformed and that header isn't there.
> 
> Assuming nexthdr would not pass ipv6_ext_hdr() / nexthdr == NONE
> test. then this would hit:
> 
>  hp = skb_header_pointer(skb, start, sizeof(_hdr), &_hdr);
>  if (!hp)
>       return -EBADMSG;
> 
> (as start is past skb->len).
> 
> ... so I think ipv6_find_hdr() should also validate offset
> is not past skb->len before telling the caller that 'nexthdr'
> is at offset <bignum>.

+1 for fixing this from ipv6_find_hdr() if it is feasible.

> Or do you see a case where this would break anything?
> 
> Thanks!
