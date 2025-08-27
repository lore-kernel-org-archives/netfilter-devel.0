Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADFE2D0C8E
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Aug 2025 18:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756319848; cv=none; b=RYwbsJklFdD4apQ5UmsraTD+ebdcI2e9bc9uMZZtNYAhSqm3Yb+aQcWFEwF5M5und5sAPM0w6bN/C23Wp07ci/l6rWpg/+C0y1m43QA3qWwCMs1mXK1weN6T3T3gUMj6FOQ64GvYlq8FZhJbVBl5Y6VztVq0ciYYl4ogAqthtZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756319848; c=relaxed/simple;
	bh=57XzfRb9uCWl8f9TBHhMPzeyHhnJ/6ef+TR3WHnYw18=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lnLADkrm3OwgNkYdwviNPIq+qzsra3fWRXDrqxgeTqqYxsFg4DuQnYQFdmnbmWk+keGoiWHionK6HgnVFpwk1lK58QjdrM5C0zIgG9QJG8VHNOQYJCfYRwUojJEOxz9+y4GGAdyKs4nzpy6CfSfcgw1yqAk+fSkCLHY/anvdGFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=grO/m9wR; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=grO/m9wR; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="grO/m9wR";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="grO/m9wR"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 896276026B; Wed, 27 Aug 2025 20:37:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756319843;
	bh=033A/KE9X794gEKYbKM0GC3DIoH8/1Gj0SP8hVZ/w5w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=grO/m9wRDp/FHyr2eU4GOxgoHxumIQncofMkY1buCRqeDajOAytrtbkhslU+2UDH7
	 X09D/ckNge4QWu9D3UzDeZZEOoJNdXEnI95oTofwhor5/jRJi6xz//3WcXBQYol18a
	 qS7GTV4oa0AYzC9Mo3XSEp7ALHV9wKTzs6yPLA5At+z9O4sDpN8x7dOZNMedLblorP
	 HGPyr7f2HCJakVBox69myx5du/h4QdMqVyBEGtABj/O9Pwu0JLEl9Dx0A8bx9DIgy8
	 rCOjUCHdyP6SiDLHrmYhFXrCR0nYYmDkmYBlk6eWfocUrRJQssDn+7w+9XTGRJ3Uua
	 u0H/w42rMWkWA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DAE5060263;
	Wed, 27 Aug 2025 20:37:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756319843;
	bh=033A/KE9X794gEKYbKM0GC3DIoH8/1Gj0SP8hVZ/w5w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=grO/m9wRDp/FHyr2eU4GOxgoHxumIQncofMkY1buCRqeDajOAytrtbkhslU+2UDH7
	 X09D/ckNge4QWu9D3UzDeZZEOoJNdXEnI95oTofwhor5/jRJi6xz//3WcXBQYol18a
	 qS7GTV4oa0AYzC9Mo3XSEp7ALHV9wKTzs6yPLA5At+z9O4sDpN8x7dOZNMedLblorP
	 HGPyr7f2HCJakVBox69myx5du/h4QdMqVyBEGtABj/O9Pwu0JLEl9Dx0A8bx9DIgy8
	 rCOjUCHdyP6SiDLHrmYhFXrCR0nYYmDkmYBlk6eWfocUrRJQssDn+7w+9XTGRJ3Uua
	 u0H/w42rMWkWA==
Date: Wed, 27 Aug 2025 20:37:19 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: nftables monitor json mode is broken
Message-ID: <aK9QXz16DjYjEWkH@calendula>
References: <aK88hFryFONk4a6P@strlen.de>
 <aK9MRw-hiudD_tEK@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aK9MRw-hiudD_tEK@calendula>

On Wed, Aug 27, 2025 at 08:19:51PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Aug 27, 2025 at 07:12:36PM +0200, Florian Westphal wrote:
> > Hi,
> > 
> > as subject says, 'nft monitor -j' is broken.
> > Example:
> > 
> > ./run-tests.sh -j testcases/object.t
> > monitor: running tests from file object.t
> > monitor output differs!
> > --- /tmp/tmp.emU4zIN8UT/tmp.C4TeyO6xYk  2025-08-27 19:05:08.039619097 +0200
> > +++ /tmp/tmp.emU4zIN8UT/tmp.jBOL3aIrp5  2025-08-27 19:05:09.062551248 +0200
> > @@ -1 +1 @@
> > -{"delete": {"quota": {"family": "ip", "name": "q", "table": "t", "handle": 0, "bytes": 26214400, "used": 0, "inv": false}}}
> > +{"delete": {"quota": {"family": "ip", "name": "q", "table": "t", "handle": 0, "bytes": 0, "used": 0, "inv": false}}}
> > monitor output differs!
> > --- /tmp/tmp.emU4zIN8UT/tmp.C4TeyO6xYk  2025-08-27 19:05:10.095619097 +0200
> > +++ /tmp/tmp.emU4zIN8UT/tmp.Guz55knY19  2025-08-27 19:05:11.117393075 +0200
> > @@ -1 +1 @@
> > -{"delete": {"limit": {"family": "ip", "name": "l", "table": "t", "handle": 0, "rate": 1, "per": "second", "burst": 5}}}
> > +{"delete": {"limit": {"family": "ip", "name": "l", "table": "t", "handle": 0, "rate": 0, "per": "error"}}}
> > 
> > I did notice this weeks ago but thought it was a problem on my end
> > and then didn't have time to investigate closer.
> > 
> > But its in fact broken on kernel side, since
> > 
> > netfilter: nf_tables: Reintroduce shortened deletion notifications
> > 
> > In short, unlike the normal output, json output wants to dump
> > everything, but the notifications no longer include the extra data, just
> > the bare minimum to identify the object being deleted.
> > 
> > As noone has complained so far I am inclinded to delete the
> > tests and rip out json support from monitor mode, it seems noone
> > uses it or even runs the tests for it.
> 
> Why? Is unfixable to consider this?
> 
> > Alternatives i see are:
> > 1. implement a cache and query it
> 
> There is a cache infrastructure, monitor only need to use it.

"monitor only use it"

Addendum:

this is a relatively large rework, I started some code but is
incomplete, including rule caching to deal with runtime incremental
updates.

I think it should be better to fix what we have then look pick back on
the rework at some point.

> > 2. rework the json mode to be forgiving as to what is set
> >    and what isn't in the object.
> >
> > Object here also means any object reported in any delete kind,
> > not just NFT_MSG_DELOBJ.  This applies to set elements etc. too,
> > json expects the full info, but the kernel notifications no longer
> > provide this.
> 
> But it does not make sense to provide the full information, delete
> object should just provide the handle to identify, to remain in parity
> with the native syntax.
> 
> > Alternative options?
> 
