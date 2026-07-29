Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46B4409114
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 07:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785310264; cv=none; b=WtiC9UWqC9+jKpZYFAyBGJonHm7FDWuP6Z26SZPu4VO9cyTt896DhUTu3nmoA3ORfTzH3x11lk7uLZdqq+x5epjFsML2ZekGzKtGRWjy74WDGOm4J6RSxlustIfLhgBn1T5IjWB+MJi/s3+qQY+EYGRghUnM/D37MomvF7Sjry8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785310264; c=relaxed/simple;
	bh=iBRLvk9GI19jvHkUZq1H1GbSHb6TiVLWhX93miGGQ6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J+rgkeTGZiCKmMPH6PAr5NZ8FGInDj4PxAYjZ9dEHoIwij2Qx3jJAqP991YTKdNKhJA+V8XPkmy9HtsLAVPe4A3O8eJGYj9gRdxItJSNjqoQTXcrqpc3DAmcuvYXw5UAoBX55abAIyNbou+KInfoucDsLn8+zUQz4EZlXlSG3Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0912D60301; Wed, 29 Jul 2026 09:30:40 +0200 (CEST)
Date: Wed, 29 Jul 2026 09:30:39 +0200
From: Florian Westphal <fw@strlen.de>
To: zhilin zou <zhilinz@nebusec.ai>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Ren Wei <enjou1224z@gmail.com>,
	netfilter-devel@vger.kernel.org, phil@nwl.cc, davem@davemloft.net,
	edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
	zhaojignmin@hotmail.com, kaber@trash.net, vega@nebusec.ai
Subject: Re: [PATCH nf 0/1] netfilter: h323: fix helper NAT mangling
Message-ID: <ammsH8vWEf8u2tuj@strlen.de>
References: <cover.1785133455.git.zhilinz@nebusec.ai>
 <amkFqw-2vdtxEogs@chamomile>
 <CANB6i5yBvEWuF36SQ0BH+1msCxhgsmT11zdd6Az7gt4oKQ6P-Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANB6i5yBvEWuF36SQ0BH+1msCxhgsmT11zdd6Az7gt4oKQ6P-Q@mail.gmail.com>

zhilin zou <zhilinz@nebusec.ai> wrote:
> > > packet's current IPv4 protocol byte. A namespace-local packet modifier
> > > can rewrite that byte after conntrack has accepted the original layout
> > > and before helper processing at the confirm hook.

But it can mangle packet in other ways, no?

AFAICS this fix papers over the problem and only "fixes" this particular reproducer.

> > commit 54f34607d184c1cc056c59a5b3d86d96dd6a515c
> > Author: Florian Westphal <fw@strlen.de>
> > Date:   Tue Jun 9 13:51:53 2026 +0200
> >
> >     netfilter: nfnetlink_queue: restrict writes to network header
> >
> > commit df07998dfd40796a05fff7ffea2661ad65ed42a7
> > Author: Florian Westphal <fw@strlen.de>
> > Date:   Tue Jun 9 13:51:54 2026 +0200
> >
> >     netfilter: nftables: restrict linklayer and network header writes
> >
> > are you running a kernel with this patches?

Neither fixes are sufficient, afaics, as no tcp revalidation is done.

Ideally we could just remove nfqueue write support, but we can't.

> The issue still reproduces. The crash is:
> 
> BUG: KASAN: out-of-bounds in mangle_contents+0x13a/0x680
> 
> and the trace goes through:
> 
> mangle_contents()
> __nf_nat_mangle_tcp_packet()
> set_addr()
> set_ras_addr()
> ras_help()
> nfqnl_recv_verdict()
> 
> So these commits do not seem to block this NFQUEUE/H.323 NAT mangling path.

Why do you think your patches block this path?

Can't you make a valid TCP packet, then mangle it so that tcp options
will get you into end-of-buffer territory?

AFAICS you will need to ask your AI to extend the two commits, for nfqueue,
add nfqnl_validate_l4(), called from the tail of ip option validation, for
ipv6, called from ipv6 exthdr validation, with the last "next" header as
argument.

- Validate minimal size of base header
- validate length in case of IPPROTO_TCP (data_len >= sizeof(struct tcphdr)
  and data_len >= __tcp_hdrlen())
- reject unknown headers
- reject if l4 proto is different from attached
  nf_conn l4proto (if any).

For nft_payload.c: add nft_th_write_ok(), which
rejects writes to TCP th->doff.

nft_nh_write() rejects writes to nexthdr value, so "nf_conn l4 proto
changes underneath" should not be possible via nft_payload.
