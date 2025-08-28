Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38087261C
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Aug 2025 13:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756387929; cv=none; b=hYK2TFaGKQejeq0DYT8KTBXRrv4zgUxP+TSY9VoB229q9AsG0wF7m5Xiq5acUe+XV+gzIb2s/nYu9b+2wUaGwQoaScObY/w7dwulync0wswXD/Y0BJNWjsZL58fZ/9lvy2FyPGf1tynuUb1sy6Pcg/128R4eVYM2KbIrrGpUlnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756387929; c=relaxed/simple;
	bh=S4IjeNcKH22alH1G0vHbmPxtaMz66mZQI/CBrW8uK6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CVhYm+KQwJ8laJj32UN1aPEJzdggpDghaq496jIS3Ika9OUk2IfUYeQG44Fa4rNer9fKNeNPWkSkIOw/iS0rKgj4rMh78PVk3z9LkD+xO2xf6rR8pWobN5quxh7S7h+2btJfGd3SNwSVDDe6G5rFvn/JhxLSALy4w9amuo8aQB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XRg2EOFq; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NmCGqJ2D; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XRg2EOFq";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NmCGqJ2D"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 4410B606D3; Thu, 28 Aug 2025 15:32:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756387925;
	bh=By6XHHKvDM51aIkPtrHAduo0Vk8W2HIWUDWL2uqGHiI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XRg2EOFqQzOBAfxRNdghXgKZdKHWYHO3cyekyG73+ojimCksSssPZh1pK6VtjZORA
	 LBrKruG0msbFYV+nZKW3Zd4HoOfFPoEO/hIg/wQj51R0NuTdKcL+0RVWQRSZ7JgN8E
	 32vR9FAz8E3H8tCDafIUaVwolTdoM8I3D2mqY/Pxs0dwnKo44DBftcD1V6ysvPEgEA
	 YX1zzFBzDIuUuKBr/xe581wQMvLFzRQXUb3l/vSqKo8ndk6EXMMre6WoKlMvnAoDeT
	 tm77+lAyWGGHreCfNJY7bKdWVpG+21u/ShIOyuLXhyPoLT6bij2aQwtTQCfMOTYDBy
	 JxrtzEp6EmWZQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3E0BE606D3;
	Thu, 28 Aug 2025 15:32:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756387924;
	bh=By6XHHKvDM51aIkPtrHAduo0Vk8W2HIWUDWL2uqGHiI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NmCGqJ2D2GlKehu3DsYpGUCQUOGPjxb6vlNHHpnVeuX5qlk+2Yl77ETHL0cssrhDQ
	 N9Yx5fP6TEheB4Fh36dLRv+8dshwzywdGJORyVx2jaKcO7HZblPWBOY8kxWPBdfl6Q
	 dmHRWraCxRS9mcGd+ps5qYegnCb1uFMiOuEuk9tDpmKMdpEEfD7PXDwC5aLADvq10N
	 xHc+JfkkWRVwAHsFiAUWQzfaZde+d0Qci4eDcGmQzgtiiW3A7irR1426dEnaYtJ/tU
	 quKu5eyg0iuHDoO7XynnY1c+1K0SiaTqJOmwoZZX1RgRj91DMPKuCrQbIUHly3bfE2
	 D69Orr3nj44qg==
Date: Thu, 28 Aug 2025 15:32:00 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH nf-next] netfilter: nft_payload: extend offset to 65535
 bytes
Message-ID: <aLBaUP8ECOI9gczI@calendula>
References: <20250828124831.4093-1-fmancera@suse.de>
 <aLBSYUfiL_HR_BJK@calendula>
 <5c24f67e-744f-4114-8fcd-85b3e88809a4@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5c24f67e-744f-4114-8fcd-85b3e88809a4@suse.de>

On Thu, Aug 28, 2025 at 03:06:10PM +0200, Fernando Fernandez Mancera wrote:
> On 8/28/25 2:58 PM, Pablo Neira Ayuso wrote:
> > On Thu, Aug 28, 2025 at 02:48:31PM +0200, Fernando Fernandez Mancera wrote:
[...]
> > > diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
> > > index 7dfc5343dae4..728a4c78775c 100644
> > > --- a/net/netfilter/nft_payload.c
> > > +++ b/net/netfilter/nft_payload.c
> > > @@ -40,7 +40,7 @@ static bool nft_payload_rebuild_vlan_hdr(const struct sk_buff *skb, int mac_off,
> > >   /* add vlan header into the user buffer for if tag was removed by offloads */
> > >   static bool
> > > -nft_payload_copy_vlan(u32 *d, const struct sk_buff *skb, u8 offset, u8 len)
> > > +nft_payload_copy_vlan(u32 *d, const struct sk_buff *skb, u16 offset, u8 len)
> > >   {
> > >   	int mac_off = skb_mac_header(skb) - skb->data;
> > >   	u8 *vlanh, *dst_u8 = (u8 *) d;
> > > @@ -212,7 +212,7 @@ static const struct nla_policy nft_payload_policy[NFTA_PAYLOAD_MAX + 1] = {
> > >   	[NFTA_PAYLOAD_SREG]		= { .type = NLA_U32 },
> > >   	[NFTA_PAYLOAD_DREG]		= { .type = NLA_U32 },
> > >   	[NFTA_PAYLOAD_BASE]		= { .type = NLA_U32 },
> > > -	[NFTA_PAYLOAD_OFFSET]		= NLA_POLICY_MAX(NLA_BE32, 255),
> > > +	[NFTA_PAYLOAD_OFFSET]		= { .type = NLA_BE32 },
> > 
> > Should this be
> > 
> >                                          NLA_POLICY_MAX(NLA_BE32, 65535),
> > 
> > ?
> > 
> 
> Hi Pablo,
> 
> I don't think so. NLA_POLICY_MAX sets the nla_policy field "max" which is a
> 16 bit signed int (s16). Therefore, when doing NLA_POLICY_MAX(NLA_BE32,
> 65535) it triggers a warning as the max value set is actually "-1" in a s16.
> 
> This is why I decided to drop it. Let me know if I am missing something
> here..

Ah indeed, I forgot this NLA_POLICY_MAX limitation.

Thanks for explaining.
