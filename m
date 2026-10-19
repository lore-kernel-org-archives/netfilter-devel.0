Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF26496D40;
	Mon, 19 Oct 2026 09:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792401068; cv=none; b=e0HMf982ie0bAVHxu93KnIzorh4F7+xoWbugY9hk97umSasE/SrBnVwF3+6JjQWKx61S248U294w7YrhLIdicudPpCcTisz7DSFt/bkfW5IcB35G9siao1DXaY9IwperUET4/JHHF+gMmArIq9kEw6L1OnJnWp/Kue4BjR8x1wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792401068; c=relaxed/simple;
	bh=p+jY3tmxwUt019LxwgmVwWOXI6oEZqEVc9D9I+PEr1M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E3yH9fhoKbPSWejzGx3PK7UZYBBuk5N2aiWVvWUE2rcfDMR3h3+Pytvb99V8IIYvNi6o73bsdKXkHOttJ70mvUOL5uoLDiAXknfGHeLbfB84ENE0cpmOkgPIswJwtP1L6xQUo5KOGA250xIX5uq/1ftpYAbhy6G1Zvd2MlaSIhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OdkLtUQF; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OdkLtUQF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792401064;
	bh=cooeJdd3ZOoKuDT3EFTXdUcEgO8JUE4TEpeg7owRSCU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OdkLtUQFuykNOsUNna630292JZB/GlsKYOHeaRxonMelcM4avycN8CGhYuazZDZQE
	 68grN8FMDEQbZ865DblqvaiQjJ7oIUr6Bef5xLRidnP+AjNUtsZzvfzzq7tFrLStVp
	 0nLcjDxDmHSvQc3rsAtGHkVokJP5EGJ2OEdXs4Lz8IRXJI4X8qs4gb/xfVoI7DP90y
	 4ae5UOBmZpovfF3OH6XMuLnq1UFcmw2z+f7g7hfhumLvgJetfvy1HBFr+lmiqk1sg8
	 XSjPjTMWKvAB+bC5SGGy47pNcLx/+7xm/wqEPwEZxxpX1C1KwRXfoOtOhqSpwOYIe7
	 QZLIjsiTq1gvw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 322D060058;
	Mon, 19 Oct 2026 11:11:04 +0200 (CEST)
Date: Mon, 19 Oct 2026 11:11:01 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev-bot+sashiko@kernel.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net-next 09/15] netfilter: nft_exthdr: avoid 60 bytes
 stack buffer in TCP option mangling
Message-ID: <atXepTQ9VUufeOAu@chamomile>
References: <20261018005638.1776148-10-pablo@netfilter.org>
 <179237288600.3135.15119152740392179853@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <179237288600.3135.15119152740392179853@kernel.org>

On Mon, Oct 19, 2026 at 01:21:26AM +0000, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 1 · Low: 0
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] The commit message says "This patch also updates the logic to
>   drop malformed packets, before this patch NFT_BREAK was used as a…
> 
> --
> 
> netfilter: nft_exthdr: avoid 60 bytes stack buffer in TCP option mangling
> 
> This commit changes nft_exthdr_tcp_set_eval() and
> nft_exthdr_tcp_strip_eval() so they no longer call
> nft_tcp_header_pointer(). Each function now reads only the 20 byte fixed
> TCP header with skb_header_pointer(), validates doff, and leaves it to
> skb_ensure_writable() to pull the options. This removes a 60 byte stack
> buffer and a redundant second header copy from both functions.
> 
> > diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
> > index 3492426dccf7f..861bab93f4352 100644
> > --- a/net/netfilter/nft_exthdr.c
> > +++ b/net/netfilter/nft_exthdr.c
> > @@ -233,16 +233,23 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
> 
> [ ... ]
> 
> > -	tcph = nft_tcp_header_pointer(pkt, sizeof(buff), buff, &tcphdr_len);
> > +	if (pkt->tprot != IPPROTO_TCP || pkt->fragoff)
> > +		goto err;
> > +
> > +	tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt), sizeof(_tcph), &_tcph);
> >  	if (!tcph)
> >  		goto err;
> >  
> > +	tcphdr_len = __tcp_hdrlen(tcph);
> > +	if (tcphdr_len < sizeof(*tcph) ||
> > +	    tcphdr_len > sizeof(*tcph) + MAX_TCP_OPTION_SPACE)
> > +		goto err;
> > +
> >  	if (skb_ensure_writable(pkt->skb, nft_thoff(pkt) + tcphdr_len))
> >  		goto err;
> >  
> > @@ -313,16 +320,23 @@ static void nft_exthdr_tcp_strip_eval(const struct nft_expr *expr,
> 
> [ ... ]
> 
> > -	tcph = nft_tcp_header_pointer(pkt, sizeof(buff), buff, &tcphdr_len);
> > +	if (pkt->tprot != IPPROTO_TCP || pkt->fragoff)
> > +		goto err;
> > +
> > +	tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt), sizeof(_tcph), &_tcph);
> >  	if (!tcph)
> >  		goto err;
> >  
> > +	tcphdr_len = __tcp_hdrlen(tcph);
> > +	if (tcphdr_len < sizeof(*tcph) ||
> > +	    tcphdr_len > sizeof(*tcph) + MAX_TCP_OPTION_SPACE)
> > +		goto err;
> > +
> >  	if (skb_ensure_writable(pkt->skb, nft_thoff(pkt) + tcphdr_len))
> >  		goto drop;
> 
> [Severity: Medium]

Nothing wrong in this patch.

> The commit message says:
> 
>   This patch also updates the logic to drop malformed packets, before this
>   patch NFT_BREAK was used as a verdict instead.

I added this comment to make this AI robot and it keeps complaining...

> Does that match what the diff does? The diff does not touch any verdict
> code. The change in behaviour only comes from removing the second,
> full-length skb_header_pointer() call that nft_tcp_header_pointer() made:
> 
>   return skb_header_pointer(pkt->skb, nft_thoff(pkt), *tcphdr_len, buffer);
> 
> Before this patch, a truncated TCP packet (thoff + doff * 4 > skb->len)
> made that call return NULL. Both functions then took goto err and
> returned NFT_BREAK.

Yes, this is what the comment aims to say.
