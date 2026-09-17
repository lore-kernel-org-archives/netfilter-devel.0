Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE0844331B
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 08:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789635278; cv=none; b=Mmt2VmeQdSM+jR24WFavMUgldpf1u3gZyBHh2lzf3SgIEjQXblSaR9Phs9i62yiZfD/ckQqU2MB5Xqn1AZZXl/dEIZi9WGyf8h5esb1NY7HP9Cqe1yDlyL5EPqVP/YznD93Q3yYYxfoI/iuwYgX0tQHzz0gYjRSyvH1f3TzYzKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789635278; c=relaxed/simple;
	bh=HIH/vNqZt/TIkOEP5Ol4ov/ey2SKslgTWTIZMSS+2w4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MaU7Q+ZWkGAvQ2AxyZuR9b/ZJh4pV2oLg6d/JacJdswT819uk0+lUpRUlgCSiVE6NRl60SM//kSSMYHxfcoqCxwJu6DANZMy1ziWYreNjz9E1GDKmQf7pY/ptw4L6GZKJdw0QGUGdLVjWsJOhiI+wMN7P3fGvADxhq+lr9BawOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dxYs6be+; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dxYs6be+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789635265;
	bh=tU2P6sqQRMpj4jvZi4y/BAe9zxw+wRFFWXji415yRHk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dxYs6be+9P1LUSe2YwQ+ALj/yIYLgluIF0IH4xROJn3pmG4kRhwu3QPwd2x6hB+rK
	 8NmheKUmgluLr30GsyBFItG4XMv6QUSpqdAMHr/tGxdxKIuOz8cw7QNzQRxpXv6Lv7
	 p+bCrrLavqeln5VoxP1+MXhqNKn2GKg8NMUH510wZfIS9AyEIRZaOexxCz0hW77RNP
	 KM7vzpNHizMel7f+uab1j+MG3qM9dkQGQ4CFRSIUbzQArDKQwccOA8Rull/5Cv9vtK
	 Qg3ikqAjV335n8yan8+iL/enDF94Xhb9sKkH+AeJSKledNfe6Th1lGdHyMyzSTrl3e
	 G4v++/HJJ9yQA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id DDE536005F;
	Thu, 17 Sep 2026 10:54:24 +0200 (CEST)
Date: Thu, 17 Sep 2026 10:54:22 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nfnetlink_queue: hash queue instance
 by portid too
Message-ID: <aquqvnzVYmnEISp5@chamomile>
References: <20260916220047.95751-1-pablo@netfilter.org>
 <aqtuUg-rFmUZYoD0@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aqtuUg-rFmUZYoD0@strlen.de>

On Thu, Sep 17, 2026 at 06:36:34AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > netlink_release() calls netlink_remove() before delivering the
> > NETLINK_URELEASE event. And a new queue instance can be created before
> > delivering such NETLINK_URELEASE event. This allows for two different
> > queue instances with the same portid to co-exist for a little while.
> > Since the instance that is going away is destroyed by portid via netlink
> > notifier, both the newly created instance and the one that is going away
> > with the same portid are destroyed.
> > 
> > Fixes: 7af4cc3fa158 ("[NETFILTER]: Add "nfnetlink_queue" netfilter queue handler over nfnetlink")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > @Florian: this is the rare race that Clashiko uncover with your fix.
> >           This is a pre-existing issue. I have to check if nfnetlink_log
> > 	  is also affected.
> 
> AFAICS its complete bullshit report.

It's theoretical, yes.

> Needs threads that race to kill and resurrect the same queue all over
> again, constantly.

I think this can happen with different queue number and same netlink
portid.

> Don't do that, then?!
> What kind of userspace does this?!  I mean, what's the point?

The goal of my patch reject duplicates netlink portid.

> We could make nfqueue refcounted, like _log, but I see no reason
> whatsover.

I don't see how refcounting will fix this race.

The problem is that the netlink notifier path encounters two different
queue instances with the same portid, and it destroys both of them,
the new and the stale one.
