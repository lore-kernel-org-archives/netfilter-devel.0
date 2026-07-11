Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DEF31715A
	for <netfilter-devel@vger.kernel.org>; Sat, 11 Jul 2026 21:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783803758; cv=none; b=hiviVPwKdgxIoy5tp/me7jb3qoQEbXkqdCou23xcCnn4Q4YzbyLlG5YV5gTMG5EIJrtqG9GYlb8vfIEUtwv9x0JXopr7UGfeZQCEcGGdPqnuITRxlYtypnq8hMGbbFMmZFcc4pWOlYLmODDGwHHqcavIjqOFKd73hheEEPVafOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783803758; c=relaxed/simple;
	bh=KajbV2P2FCGBAXdCV/JZAvxoq4w2A5Ov46kVSYvR7OI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=COqDJpwtSjr7sUNJX2+TJRB8keETOgaFxbAo9dNaj1SWDNz5RXZCVpFha/qzrIF2YjaSQpQdrnEzIYNEHGwPpfUi5okrBz+8rW8PMzwqoOOGt5ZOtVEeq9hS9a0gI9JgjnWa5xf6NjZEijx6JchZdOUKlmgx7QGctgRUYv2LGFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=wLszoXjl; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="wLszoXjl"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 6EDB660195;
	Sat, 11 Jul 2026 23:02:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783803746;
	bh=lSDhBwwOcIm3XDE78fgq3pizrRwwndx5okHFV06rqD8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wLszoXjly3IHyY01iNucRRGP4KMfuo6hTbz9NNr5xmy4VRvroSpNCCMqf6sJKArO6
	 R6xJ7ye9RTdFcM26lT/xFjV4GRJdK2grZ2rQogl9fehHdYJfes1zhkQvsgDkxgdkRu
	 TAhlD0Qs2miuk5gVem7FDdvdO9YUA1ku42t7Bg1r8UKVuGp7sY349tCrimkTdv9xlc
	 FUQwL5is+3IzXmHdVY9nXKHlOjnd/+G3kpld+XvmWPvqml4TSsjKMqm1Pfl3Hzfcex
	 LLyoNfqnwdG/oTnt3Qe/ra1JN9bECBmTDlJgmr16RJOmGhe0xisUCRD/AU3+Txxwx0
	 GToGeRnoe3xyQ==
Date: Sat, 11 Jul 2026 23:02:23 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ahmed Zaki <anzaki@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v2] netfilter: flowtable: tear down flow entries with
 stale dst from GC
Message-ID: <alKvX-Q_v6ez4fV3@chamomile>
References: <20260710075409.1360085-1-pablo@netfilter.org>
 <CANczwAEqpv+zALby0crkzO5tX63efo-0JrVHVJUWbNgtxsKqSA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANczwAEqpv+zALby0crkzO5tX63efo-0JrVHVJUWbNgtxsKqSA@mail.gmail.com>

Hi,

On Fri, Jul 10, 2026 at 01:55:59PM -0600, Ahmed Zaki wrote:
> On Fri, Jul 10, 2026 at 1:54 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > In case of route updates, tear down flow entries with stale dst to give
> > them a chance to obtain a fresh route.
> >
> > This is specifically useful for hardware offloaded entries, where the
> > flowtable software dataplane sees no packet, where the existing check
> > for stale dst entries does not help.
> >
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > v2: - reuse nf_flow_dst_check(), move it to .h file
> >     - use correct logic in nf_flow_dst_check() from GC step
> >
> > This patch has been repurposed to the nf.git tree, because net-next.git is
> > still missing a recent fix and I would like sashiko kicks it for review.
> > So I am still leaning towards including this in nf-next.
> >
> >  include/net/netfilter/nf_flow_table.h | 8 ++++++++
> >  net/netfilter/nf_flow_table_core.c    | 2 ++
> >  net/netfilter/nf_flow_table_ip.c      | 8 --------
> >  3 files changed, 10 insertions(+), 8 deletions(-)
> >
> > diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
> > index ce414118962f..a090ec3ffef2 100644
> > --- a/include/net/netfilter/nf_flow_table.h
> > +++ b/include/net/netfilter/nf_flow_table.h
> > @@ -310,6 +310,14 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
> >  void flow_offload_refresh(struct nf_flowtable *flow_table,
> >                           struct flow_offload *flow, bool force);
> >
> > +static inline bool nf_flow_dst_check(struct flow_offload_tuple *tuple)
> > +{
> > +       if (!tuple->dst_cache)
> > +               return true;
> > +
> > +       return dst_check(tuple->dst_cache, tuple->dst_cookie);
> > +}
> 
> I am testing this patch and keep getting some splats. I am testing
> with a MTK7621 hw which
> to my understanding, marks the tuple's xmit_type DIRECT (not neigh or XFRM).
> 
> In nft_dev_forward_path(), out.h_source is set and this overrides the
> dst_cache (same union)
> this seems to be causing the splat when the dst_cache is dereferenced.
> (btw, not like his patch,
> in the latest HEAD, nf_flow_dst_check() guards tuple->dst_****  by
> checks on xmit_type)

We have move dst_cache out of the union quite recently so... (see below)

> So, to support DIRECT types, we can:
> 1 - go back to my v1 patch (no dependency on dst_cache)
> 2 - same patch but use dst_check() only for NEIGH/XFRM
> 3 - or maybe we can have the dst_cache out of the union and available
> for all xmit_types.
> 
> I have some time to work on this, let me know if I can help.

... probably you are missing this series? They got merged quite
recently, I am not sure what tree you are using as reference:

fa7395c02d95 netfilter: flowtable: support IPIP tunnel with direct xmit
6c5dcab95f4c netfilter: flowtable: IPIP tunnel hardware offload is not yet support
c328b90c17fc netfilter: flowtable: use dst in this direction when pushing IPIP header

There is also this patch which is needed:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260709114025.1294044-1-pablo@netfilter.org/

which has been included in the last PR this Friday.
