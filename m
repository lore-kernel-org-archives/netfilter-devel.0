Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD28630AD09
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Oct 2025 20:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760387971; cv=none; b=hGzhQgZEA+thuF4lGRfwLFvrL9Nt3+7r57+kaOsm384mj/P0S/MGgggb9rlsdRzQKO7ayYvWk61sPogRpy1JDvI+ucjUoC4BoSWwA4zGjSjaQXbaJbW6y5kTJlwwh6Dx9Q2KhFjqMuIufJEWUHnhIiLPGYbr+uAub75PbLBaJ/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760387971; c=relaxed/simple;
	bh=I6j2L5FwyggMI5z8JNpQ0H86wvYB/DHzni+hA4x1Fdo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JuwG6sMxKk6aOVNijAGzEBiiAnthk8NuePGfUteEjy714ewY6hiFkb07zo7FwRAlW2M+jdrXl4bco/9ZpnO95ZSVW6DTSciVK4ONMfZtKnbYNECXDSZXzMnCXyq9UGtKILOerrlxSPG3G+bFDzkXW9mhBaSyTb2F7QZvrTn6LOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=idJGaYWz; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Ee87M8nl; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="idJGaYWz";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Ee87M8nl"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id CAAB86029F; Mon, 13 Oct 2025 22:39:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1760387958;
	bh=nHVJwmPL/CLXIHtg1L3iiu/LlxpU6oYV1JdzcAHLVwI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=idJGaYWzQC6IpBEWqeXXKwriM1tjFzADYioub9qOGHDGFuZF0cnFyeC97hPxQMd8y
	 WIaS7I7XcGBUDsDoiKr0mt/waQdOUDXLw0jvBQ2fpxAK7Li8ufwT/1uLju3fnA+jjQ
	 tOxSEnXP21o31aBvShqCtk83sX7zusi1SskxDELPDj8AOpmrYLbu3LifJ6sbzArxjL
	 35ab1Cz5nOPdvD4zY9Oxoo2YKNEE6tjgmjes2pNjlb0Gd4c7QUw5wFDcxi6ibryrSF
	 JxcUZNniTkCHcPC7OwnA61kS4Dgf5sg5vkLqxA2oXTqvLsMfZvaH4GH+RqSm2H/Jwl
	 fy9rBt5vwTwUg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 95C176029F;
	Mon, 13 Oct 2025 22:39:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1760387957;
	bh=nHVJwmPL/CLXIHtg1L3iiu/LlxpU6oYV1JdzcAHLVwI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ee87M8nljjB/bf9QvQbqImCwm9Sr6A+66LuQZOIHBkfhTS3qNrPvyXsYnpUSr1lqJ
	 T/baM184VzqKHK077i4JyRl/y1tCCvv+3DS0AMH+QrHNb3uZp6i0jRpzVFklYX5hLc
	 HJDl14EMtDLZW7J3pVcAIoVS33tYTgSE3WYSpdyVKmwEfSGshVYyNx6914jlWsNUux
	 kvRUXfFaj6ETLKhW5m1yVYlnMMyivayXeEtoKMJDLNpIMHDwMa3dXY6u/kkI3gQsBd
	 bdCO6ec0RlO87tetMgBUPk614CP3X+oXxboFmVl9caN3WbaK96+UFFtdMxwLt7+IQY
	 3AtVW4CgvBWOg==
Date: Mon, 13 Oct 2025 22:39:14 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH nft] meta: introduce meta ibrhwdr support
Message-ID: <aO1jchhd9t07Igq3@calendula>
References: <20250902113529.5456-1-fmancera@suse.de>
 <aO1XOREzSUUgROcy@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aO1XOREzSUUgROcy@strlen.de>

Hi Florian,

On Mon, Oct 13, 2025 at 09:47:05PM +0200, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> > Can be used in bridge prerouting hook to redirect the packet to the
> > receiving physical device for processing.
> > 
> > table bridge nat {
> >         chain PREROUTING {
> >                 type filter hook prerouting priority 0; policy accept;
> >                 ether daddr de:ad:00:00:be:ef meta pkttype set host ether daddr set meta ibrhwdr accept
> >         }
> > }
> 
> Pablo, does the above ok to you?
> I am not sure about 'ibrhwdr'.

I'd suggest: ibrhwaddr, for consistency with other existing ibr
selectors and anything that relates to address uses the suffix 'addr'.

> Will there be an 'obrhwdr'?

No usecase for this so far.

> Or is it for consistency because its envisioned to be used in
> incoming direction?

Using the input device where this frame came from, which is a bridge
port, fetch the address of the upper bridge device on top of it.

It is a bit unix-like looking acronym, arguably not so intuitive, but
I don't have a better idea.

> Patch LGTM, I would apply this and the libnftnl dependency.
