Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1812303C88
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Aug 2025 12:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756384051; cv=none; b=pGDelpFUGF1aNvOdGkL3oOIHnFsyYcMZWEQWCXPA2kL3kxqhKycuS0RosmYGqRxcfCtYGFlF74L3H0x8HFF3w7pjn1XoDxUaDmsY1syxz3pjmJUaKOuLK0a9qeyVCOTPlRh8SwP16ksSgbyz+vRj6NL5PMTQRs7gqdasWzs4Idk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756384051; c=relaxed/simple;
	bh=4V7AIDYQTb6v/9kwau9V5s4nGN4Wv5WjI3+gEE995yo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WOIw/+5XJbRSy+ktr0d050Rf3qkn9Iy99rXhgZLO03esem6mM6GwerYrhzJnAlxS/x7Mz6UJTtPrkB3SC/+Of7GnMYD2x/KycxFnSg2PPIjjTM+bAvcgOkX1Ro83zQJAf0NyL/+LcEbHMFT9D+CkR0PxP4EnwyXmRY2eIrokVHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=c5pUg9OF; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QnSC6s9o; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="c5pUg9OF";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QnSC6s9o"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 51BED60701; Thu, 28 Aug 2025 14:27:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756384041;
	bh=7+iRtM0/quz5Bs6AqaYL6E0KKgfkg5Mw41rNwfpun9k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c5pUg9OFhJnRzJbR8FXcPDxxw3hKp1/mpdxYBfAjQBIYtLxIk2VSNQv0vih7ur8Ef
	 7aLIAyvEdhXW5BnX7GZMQlKSiRdXIiJtjnvFtB6ZorzdgZnOfqcOcpTAL5X5NcXvus
	 1ibMBMmH7GmfsK7Dw/21xJt1GSA9Lx5z2lqu6pTZH7UnOKWgSiJFi+uiTe28xGOwLf
	 Hg2UuCX3mseVCoZo0cH5vDa+DQ/FMaqTkynQcTDswZjR0/HIUQhqyfaNqBVT1iP7vb
	 3YtlVOIP0mEplpwficDtvAjN1Mrn41riT5xBTMnT0+wG5N5GKIUe7LH4RsBr+YLiBU
	 wPWbLgTrbjOKQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A7A25606FE;
	Thu, 28 Aug 2025 14:27:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756384040;
	bh=7+iRtM0/quz5Bs6AqaYL6E0KKgfkg5Mw41rNwfpun9k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QnSC6s9oUGqLHT9+sxEu3j/w0ummX1tZucJgd2kWxZrwwswVb3qP1knOp0TC1F3Fd
	 AB3dMb2zkiS78mNwHyp71l4sXYkbrAObWsgwIIjorfmy4WaeVo7HOyL7cJlpdfnUQH
	 cPolCGb9iaF5VSSDVkB918SSZIys4F+WxrZqVAa5I1pJ4/5Zv+OQgh4rNOBjmBc0y2
	 7zcHW1lTdGcJJH9sdSRrwoO/vJb9HGLrtuNWK28qs/K6lzjgvbGqF3jokjlClDc4ps
	 imy4zYjfjsoKq/pUC+AmouZeStvAegp97WkAotyY9KXU2Psd/H6cyZpxJQVrGHasGA
	 Y3wtiunkgxBOg==
Date: Thu, 28 Aug 2025 14:27:17 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: nftables monitor json mode is broken
Message-ID: <aLBLJW9qwTSjlLZW@calendula>
References: <aK88hFryFONk4a6P@strlen.de>
 <aK9MRw-hiudD_tEK@calendula>
 <aK9QXz16DjYjEWkH@calendula>
 <aLAhaqBWKt5wyWZ6@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aLAhaqBWKt5wyWZ6@strlen.de>

On Thu, Aug 28, 2025 at 11:29:14AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Why? Is unfixable to consider this?
> 
> I'm not sure.
> 
> It depends on several factors:
> 1. Do we have users of the json monitor mode?
> 2. Can they cope with *partial* info?
>    For non-json, the user will be a human and they
>    can the delete messages will have enough info to
>    correlate it with the corresponding add messages.
>    But for automated robots consuming json? Dunno.
> 3. Is the burden of correlating the delete info
>    with the full information about the deleted object
>    on the nft monitor -j side or the consumer of the
>    (Then incomplete) json info?

I don't think json output should diverge from the native monitor mode,
which only displays the partial information.

Then, for stateful objects such as counters, maybe there is a usecase
to display this in the delete object events, but then native nftables
monitor should display the same behaviour.

> > this is a relatively large rework, I started some code but is
> > incomplete, including rule caching to deal with runtime incremental
> > updates.
> 
> Thanks Pablo.
> 
> > I think it should be better to fix what we have then look pick back on
> > the rework at some point.
> 
> I also prefer repair to "nuke it".
> But I dislike the idea of spending time on something that is not
> used in practice.

I don't find a good reason to cripple json to make it less capable
than the native representation.
