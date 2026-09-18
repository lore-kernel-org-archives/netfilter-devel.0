Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECAC398902
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Sep 2026 10:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789727918; cv=none; b=YRLFj1p28KI2WLf7MAysmDuUCwmODwcHwInemulcIz4C8hw04NnY90rMc4gs0Wr3Jwz9JZ6NeDrwuNwU4OUUX1xdkX5TcFgO+FWAT021/qt/UYuNLkz+JKerfik/e2GGE1M6RqRIRhWsdVYnyf1afGiXNiFBfTj74xvAd9fs5+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789727918; c=relaxed/simple;
	bh=PzMkQBBQgw5cqDTs2yPOXEROcj4/7K8T/dYOE2YeleQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CYg1bygZnETCFD/1nJ5fN55oPYDy1eRbWWyZz3d+nyggou4KmDBWX8bjksUR9GeK4OGCMnOCyno7hzjM8a6u8OE1QfC4tCIYFIgtszXeEX/e1JPJH/hhF0JBkU2hk1JKmpHJgq3FeSORtiAISu46VT5NST2tisp8cRv3aoeeYnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A43BB60456; Fri, 18 Sep 2026 12:38:33 +0200 (CEST)
Date: Fri, 18 Sep 2026 12:38:28 +0200
From: Florian Westphal <fw@strlen.de>
To: Ren Wei <weir@nebusec.ai>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org, kaber@trash.net,
	vega@nebusec.ai, petalzu987@gmail.com
Subject: Re: [PATCH nf 0/1] netfilter: nf_ip6_checksum: validate checksum
 offset
Message-ID: <aq0UpHHbvxjR2jLb@strlen.de>
References: <cover.1789660425.git.petalzu987@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1789660425.git.petalzu987@gmail.com>

Ren Wei <weir@nebusec.ai> wrote:
> From: Zixuan Chai <petalzu987@gmail.com>
> 
> Hi Linux kernel maintainers,
> 
> We found and validated an issue in net/netfilter/utils.c. The bug can be
> reached by a non-root user when unprivileged user namespaces are enabled,
> using user and network namespaces. We tested the fix in QEMU, and it does
> not affect valid checksum handling or other tested functionality.
> 
> We will provide detailed information about the bug in this email,
> along with a PoC to trigger it.

patch is fine, but could you make another patch that either fixes
ipv6_find_hdr() or ip6_packet_match() / nft_set_pktinfo_ipv6() as well?

If I read this right then ipv6_find_hdr() returns nexthdr 'TCP',
but its clear packet is malformed and that header isn't there.

Assuming nexthdr would not pass ipv6_ext_hdr() / nexthdr == NONE
test. then this would hit:

 hp = skb_header_pointer(skb, start, sizeof(_hdr), &_hdr);
 if (!hp)
      return -EBADMSG;

(as start is past skb->len).

... so I think ipv6_find_hdr() should also validate offset
is not past skb->len before telling the caller that 'nexthdr'
is at offset <bignum>.

Or do you see a case where this would break anything?

Thanks!
