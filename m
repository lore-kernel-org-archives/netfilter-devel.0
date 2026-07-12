Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B44B3B27E2
	for <netfilter-devel@vger.kernel.org>; Sun, 12 Jul 2026 19:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783884476; cv=none; b=PkwNM4W8iZ+coEXWz2WCjkCTMf6leUANA6soCUxJ/yDpyJ63vS3xGtu7Lk2Euf/wZuKqhJAiue1p2dgb9nlqS+UL4aIOK4D1W5EloaZ/xZbDNBM6O0/gzVaAdLSW/lRwbajbM4rSzJ4hl4/q0C+B5sGcjElQL9SCX19lt1hKfSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783884476; c=relaxed/simple;
	bh=NZDiZDzprTUAm5N5hU2Uw4GcTm0QNpGv9eWrOlZUr8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YCB6I+Ed++liRuGUamTV6e0c2ohjMT2hN3jAInr2+yyEltcWR95YbakxLRpQIBfmEQIGRdBW+xBGLI2JzAjHu3ehoDzLEDcQ07lrMYEtIUcoI9BwxKK46Ewzyd3E7BUT+MLuIyg84GCYH04ffrPXH8Kn/LLLK18Qi5pK+s10YKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BD2mRoSh; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BD2mRoSh"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 090FF6057C;
	Sun, 12 Jul 2026 21:27:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783884470;
	bh=jiF2LNaK7ksU3E+/YRQAOXBB93UGFbXUGMsiAbcqiVM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BD2mRoShGQxuN0NeqEBOa/UvAQInwifqX44Nnuclbnfta3ymdrzHiwM3zcR2PimAN
	 vOOSUwUAaMFS/a68Bd+1fgGyHzadsj9ytdXbgVUEjO6cRr5+datDdfZdfQKBDy/Ylw
	 MGaxkis6hR1CnPxUDfEPQMI9sTgXn++Vcmbpqd05DxjLQlY7BTV+g8G/vJ5pcqnPfM
	 mvKC5F7viXQZaerEe5qujGqF4yDK8z+m4gUTHsBhDGkWJf7SKgaOHNcGVso7WQ/3SU
	 rm45R0rdZZtFzJGCsp3QSnURvIzVQXyhP+AabC3FHX7OHRFQ8/9oMa1LUtAtAG2nKu
	 aumSMZoZsfeTg==
Date: Sun, 12 Jul 2026 21:27:47 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ahmed Zaki <anzaki@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v2] netfilter: flowtable: tear down flow entries with
 stale dst from GC
Message-ID: <alPqs8gMuF1uJuTw@chamomile>
References: <20260710075409.1360085-1-pablo@netfilter.org>
 <CANczwAEqpv+zALby0crkzO5tX63efo-0JrVHVJUWbNgtxsKqSA@mail.gmail.com>
 <alKvX-Q_v6ez4fV3@chamomile>
 <CANczwAFH_GFK+uTTcpOoogQ8LuY6MRRwe0Q76=rP=F-9bY953g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANczwAFH_GFK+uTTcpOoogQ8LuY6MRRwe0Q76=rP=F-9bY953g@mail.gmail.com>

On Sun, Jul 12, 2026 at 07:39:25AM -0600, Ahmed Zaki wrote:
> On Sat, Jul 11, 2026 at 3:02 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> .
> 
> > > I am testing this patch and keep getting some splats. I am testing
> > > with a MTK7621 hw which
> > > to my understanding, marks the tuple's xmit_type DIRECT (not neigh or XFRM).
> > >
> > > In nft_dev_forward_path(), out.h_source is set and this overrides the
> > > dst_cache (same union)
> > > this seems to be causing the splat when the dst_cache is dereferenced.
> > > (btw, not like his patch,
> > > in the latest HEAD, nf_flow_dst_check() guards tuple->dst_****  by
> > > checks on xmit_type)
> >
> > We have move dst_cache out of the union quite recently so... (see below)
> >
> > > So, to support DIRECT types, we can:
> > > 1 - go back to my v1 patch (no dependency on dst_cache)
> > > 2 - same patch but use dst_check() only for NEIGH/XFRM
> > > 3 - or maybe we can have the dst_cache out of the union and available
> > > for all xmit_types.
> > >
> > > I have some time to work on this, let me know if I can help.
> >
> > ... probably you are missing this series? They got merged quite
> > recently, I am not sure what tree you are using as reference:
> 
> yeah, I was looking at nf-next. These seem to be in nf only as of now.

OK.

> > fa7395c02d95 netfilter: flowtable: support IPIP tunnel with direct xmit
> > 6c5dcab95f4c netfilter: flowtable: IPIP tunnel hardware offload is not yet support
> > c328b90c17fc netfilter: flowtable: use dst in this direction when pushing IPIP header
> >
> > There is also this patch which is needed:
> >
> > https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260709114025.1294044-1-pablo@netfilter.org/
> >
> > which has been included in the last PR this Friday.
> 
> I have some limitations so I can only test with 6.6 or 6.12. I will
> try to trim down these patches to
> "move dst_cache out of union and use the gc to check all entries" and
> will let you know if I see
> any more problems.

You will have to backport the move of dst_cache out of the union.

> The one thing I believe is still missing is to remove the if condition
> in flow_offload_fill_route()
> when setting  "flow_tuple->dst_cache/dst_cookie":
> 
> - if (route->tuple[!dir].in.num_tuns) {
> 
> We now need "flow_tuple->dst_cache/dst_cookie" for all DIRECT xmit
> even with no tunnels

How so? ->dst_cache is not available when sending packets to a port
behind a master bridge device.
