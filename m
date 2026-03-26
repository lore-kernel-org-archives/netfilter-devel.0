Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD153AC0F1;
	Thu, 26 Mar 2026 21:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774561165; cv=none; b=pJRJ+dksX1iUuQw5Ojl0ycyKYKmt/lDUaAGdgJ8XjV+5XeX3n+1tIQXqRNqpcVMtAWLuY1qftXwIONfFjrVLWbbkLfuD4YM+PWXDOOqruGCagzIMnOJMu7TbMn0a2sMgx9fZ3A8ZttXqYEO2HyxDAM2XMFFkRh6itDxcXmhaosk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774561165; c=relaxed/simple;
	bh=xM/QoPNN+JJYmK3EF6ngbmVlB6gNfW/DiAEW7rMwb/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h3BgGAnKZgPVoqsnjPXgR7cnr5vLhrp00lrT5ijgw6fvxhTwhK9+h5C8sut0wn+xuTr81ZGtSHbpzEfsdflZjT+wce7UyLOMlBgO6zQp8PVOTp4RFz4b4CFpe6g9jyQc3Vm6Izmy1oeOnMjLb4FDDQU7CbifGfPCL7z1toeSDQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tFQv/zX0; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tFQv/zX0"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id C04D96017A;
	Thu, 26 Mar 2026 22:39:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774561157;
	bh=ED1zl0+0t51o8oYMY8dYU5mCrKJu3S6Z6qvI6vdMHHQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tFQv/zX0P/5R1JfqoywfB9PSP6rY9dXBzsVOgd5i88WxoYmGgt7jJHqZbJhLpP5Jd
	 P0LAj08UKkMJD+tGrxXNOoUx+95al+EmKXkz5AEbNJSaPSte8KGLKchH/O0o9gBqpr
	 7XFEVoYqXMHfH48vuxDg6AalXWIrtLidUXd7yBbtMFIvhkmeyk9iq6gnuJfQJfd758
	 hAYehBVr17h2px9pVmKOdHRJEIoO/Usyb/nSviSGVlKGelw+d6f8kamTEyWsMsTHy6
	 BVe2nyrr3YHE1/w9GnlhNVaeU5JhgEeWy7+2k+aCZYU83V3b5sHRYLGj+lnDWK/Jcg
	 gl2Uw0wz4CLCQ==
Date: Thu, 26 Mar 2026 22:39:14 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Weiming Shi <bestswngs@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Phil Sutter <phil@nwl.cc>, Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH nf] netfilter: nf_conntrack_sip: fix use of uninitialized
 rtp_addr in process_sdp
Message-ID: <acWngrh34bQ--ZTn@chamomile>
References: <20260323080727.2932866-3-bestswngs@gmail.com>
 <acWVV__8xRMezYrU@chamomile>
 <acWaoSUm9SrD8_pS@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <acWaoSUm9SrD8_pS@strlen.de>

On Thu, Mar 26, 2026 at 09:44:17PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > @@ -1091,9 +1095,11 @@ static int process_sdp(struct sk_buff *skb, unsigned int protoff,
> > >  					  &matchoff, &matchlen, &maddr) > 0) {
> > >  			maddr_len = matchlen;
> > >  			memcpy(&rtp_addr, &maddr, sizeof(rtp_addr));
> > > -		} else if (caddr_len)
> > > +			have_rtp_addr = true;
> > > +		} else if (caddr_len) {
> > >  			memcpy(&rtp_addr, &caddr, sizeof(rtp_addr));
> > > -		else {
> > > +			have_rtp_addr = true;
> > 
> > After this update, this loop sets over rtp_addr, but this was already
> > set by ct_sip_parse_sdp_addr() a bit above.
> > 
> > This new chunk results in:
> > 
> >                 } else if (caddr_len) {
> >                        memcpy(&rtp_addr, &caddr, sizeof(rtp_addr));
> >                        have_rtp_addr = true;
> > 
> > which is not needed? Why does caddr need to be copied over and over
> > again to rtp_addr?
> 
> Code before update was:
>                 if (ct_sip_parse_sdp_addr(ct, *dptr, mediaoff, *datalen,
>                                           SDP_HDR_CONNECTION, SDP_HDR_MEDIA,
>                                           &matchoff, &matchlen, &maddr) > 0) {
>                         maddr_len = matchlen;
>                         memcpy(&rtp_addr, &maddr, sizeof(rtp_addr));
>                 } else if (caddr_len)
>                         memcpy(&rtp_addr, &caddr, sizeof(rtp_addr));
>                 else {
> 
> 
> so we re-set rtp_addr to the session description in case it was
> overwritten by earlier iteration of the loop.
> 
> 1. Extract session description (caddr_len set)
> 2. enter loop, parse media description (overwrite rtp_addr with media
>    address)
> 3. next loop fails ct_sip_parse_sdp_addr() call
>    Restore the original session address instead of using
>    the previous media description.
> 
> I think its correct this way.

Thanks for explaining, this is leaving things as they were before this
patch.
