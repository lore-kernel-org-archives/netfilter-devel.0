Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706D6331A6D
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Apr 2026 10:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775729520; cv=none; b=k090T3njN3okAz1QzqCmIcGcRkgpnWA/Y8tnAw1BwNYEe32lLKSFoeIYzP1l4+dWueo3ZFvROqdF3EWxa4LXpYRHFpDlOy1fbN3HGfwOVNDWLsb5Xm7277FkkFEg4m05tgHGjkgx/2xtLGpfon/G+jvnT/LmSR6FN3PLBNTgsSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775729520; c=relaxed/simple;
	bh=QUDkch0toSoATG6Ag9O36eqszo1W1Tm2RxQ3+yJOkIc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UaGoF+FJ86eM4bb+6izsmTHUCNlhG6xMCspDB+2/xb+2tlPSk8LjSd1QuoIE6HmcBq57ALoLx7cmbDPPRy/cXDPWTqpCdN/gV+KLw/SmM4MkWrWd3KlGDof9BLOEunmAWJOPKtFBeNDw2zYXWceuHHu2qJB2P1GUVYEEUe3m66E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MoglJCqG; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MoglJCqG"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-82cd6614a90so369575b3a.3
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Apr 2026 03:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775729519; x=1776334319; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ze6uJ71rMugLTsbbiL/lEDVgsRa2xx9AjXO0GTiYltw=;
        b=MoglJCqGZ2EEJ85xYbhYfBMjOiipOxGavOiTOeWfL2dlW6DfqCkpOetUj974FWtKSe
         zV9uRI9BMyFRouUF3GjK/QI0EdW1bkmWlxnl6MaWWoAQb9jk507u+FsJzW0mvGnZE9Lr
         SupeILf10oYn43SKEQ/NFbuyDqcHSIUAIX1z//wSBW0eTmOxrzeH9Id/obMcZClfTCHg
         qihyTHXrFqf6a6Jc9jl9MDyKAiVjoa5ovkYKpfnZBR2ns9jHrcGFVC242luYz22ZtIZM
         mUEj5k5KJ6kdoTKYnq7xtbX70GWeLMU3bWyW/kf0PT470u735hJJpZX6nlSR61HaejQ1
         Y7GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775729519; x=1776334319;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ze6uJ71rMugLTsbbiL/lEDVgsRa2xx9AjXO0GTiYltw=;
        b=UtLP71ZjtOHErKujfeGZ+MTHaBuE1BQruo0FhxvyhAIn+QPe/AqKd8Dg9wZy/Joc7c
         2MOWEy+Y6NvsEXAxMCzG0Ydc/vUPEkd8mfRp22FrI0CqHL9ruVRnc6hZjph3vD1jI2WU
         mydT/qd5kD2e7CXNI+MBxYQgn6Z73Os8OKqC53gjzhkHX63hXabnJnGsrnsjProDzsN8
         zG+vJ+bF/+GAe3samalj8fmj2vmMY/Twn79sRf/vwmPgvUPSyTSe1XKtRcMxKJ9TKah+
         2BxSN22q+z8D+dFARILMiTCQsA6KeB0XERtc81X0bFz4Ou3Q8NiKRywtxEVXgP0tQJND
         aHqQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQ5pnv973Xn2j97VsDYmeg6dS/QUjGn1CCC/QX2xTIeCbCJ0MB7cpPxa/buwgeiLVl4pz0dKFVevxl+S4H54M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxk+DJRr1dOTZqGTqqYQfAp7tuWwe9nMD5kRjmp9FGi8kBmlXk4
	Ze1lXSUPqwBPpXAncwA0lccMYNaKXfo9rbWjfZmjMn9SuJrpmlYrs4U4
X-Gm-Gg: AeBDiet72qj8aC++SAX+frlkFbF23WrpmIaeiCLQZA6TuJbMIWd4aqAkZGbmhWfMIoF
	istvg0XKEfHTdsedPIRdvdImxTqHEIzmytWDI3IsBZA9x0t+0ACP7fwzfZCMj2SPN2MRcCkTgN3
	SpaIJ2JY7wMWdoHvK/2YGVYKbfmy82zO3s75goRyF6Z+LD+44x7bQfhGQLOaet9r8uQPazbDYl6
	Yv5FPBlp9dnf/wUsV8NXH8zRK2p2dymXsVN/h4hDOqZYK2knv9PJP7uXF+XNLc2dk8ceWxPJmGN
	aVHVdchl/S0helimbdPnThsCeqTgnxpLHDlDu4wiFA8iO8yRoMFDKU0Svz+RedAVlpv2fQsjHK3
	zkebXR/KKcRCPvKW1h89AJJ0YG1dejgbTrmk3nUQLYQi0bOkSKj1J/+Aa6LNOd9bYUNuSuHeb59
	r6G/MPIAhSUMjZZyz7sRiKuRbyYTMxle4SsIhcnhjJYCxV3YdCLHbStX7C01BT
X-Received: by 2002:a05:6a00:2e85:b0:81c:446d:6bd0 with SMTP id d2e1a72fcca58-82d0da9f9c9mr23580213b3a.23.1775729518705;
        Thu, 09 Apr 2026 03:11:58 -0700 (PDT)
Received: from SLSGDTSWING002 ([129.126.109.177])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9c4126bsm23194864b3a.36.2026.04.09.03.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 03:11:58 -0700 (PDT)
Date: Thu, 9 Apr 2026 18:11:53 +0800
From: Weiming Shi <bestswngs@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Phil Sutter <phil@nwl.cc>, Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH nf] netfilter: nft_fwd_netdev: use recursion counter in
 neigh egress path
Message-ID: <add7abl1x_NJkcC-@SLSGDTSWING002>
References: <20260409053629.698822-2-bestswngs@gmail.com>
 <add2ajF5YGqd4MxZ@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <add2ajF5YGqd4MxZ@strlen.de>

On 26-04-09 11:50, Florian Westphal wrote:
> Weiming Shi <bestswngs@gmail.com> wrote:
> > Fixes: f87b9464d152 ("netfilter: nft_fwd_netdev: Support egress hook")
> > Reported-by: Xiang Mei <xmei5@asu.edu>
> > Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> > ---
> >  include/net/netfilter/nf_dup_netdev.h |  4 ++++
> >  net/netfilter/nf_dup_netdev.c         | 18 ++++++++++++++++++
> >  net/netfilter/nft_fwd_netdev.c        |  7 +++++++
> >  3 files changed, 29 insertions(+)
> > 
> > diff --git a/include/net/netfilter/nf_dup_netdev.h b/include/net/netfilter/nf_dup_netdev.h
> > index b175d271aec9..17362f76d1d1 100644
> > --- a/include/net/netfilter/nf_dup_netdev.h
> > +++ b/include/net/netfilter/nf_dup_netdev.h
> > @@ -7,6 +7,10 @@
> >  void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif);
> >  void nf_fwd_netdev_egress(const struct nft_pktinfo *pkt, int oif);
> >  
> > +bool nf_dup_netdev_has_recursed(void);
> > +void nf_dup_netdev_recursion_inc(void);
> > +void nf_dup_netdev_recursion_dec(void);
> > +
> >  struct nft_offload_ctx;
> >  struct nft_flow_rule;
> >  
> > diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
> > index fab8b9011098..e2fe8bb6fe0d 100644
> > --- a/net/netfilter/nf_dup_netdev.c
> > +++ b/net/netfilter/nf_dup_netdev.c
> > @@ -29,6 +29,24 @@ static u8 *nf_get_nf_dup_skb_recursion(void)
> >  
> >  #endif
> >  
> > +bool nf_dup_netdev_has_recursed(void)
> > +{
> > +	return *nf_get_nf_dup_skb_recursion() > NF_RECURSION_LIMIT;
> > +}
> > +EXPORT_SYMBOL_GPL(nf_dup_netdev_has_recursed);
> 
> I think thats a bit too heavy-handed.
> nf_get_nf_dup_skb_recursion() fetches from pcpu counter or current->.
> 
> Can you move nf_get_nf_dup_skb_recursion to a shared header file
> and make it inline instead of having a function call?
> 

Thanks for the review. I will send the patch for version v2 as you suggested.

Weiming Shi
