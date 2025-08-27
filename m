Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E6D2E266A
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Aug 2025 18:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756318801; cv=none; b=EP50K6hqO7ofhhKg/R/5fvppBQgyGY0IJQOk7wZFbKl6t0PHYA0bdV1jTLbPvQ247BdMb5I1sPB9aP/rmeK+HQlbRAIZDctcqEP6c61W+xTEPb8hAsDH9d6yVYACCsObJzXns27FZWCjKLC+306nW9yefo91ROyg8vTNV5kl8x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756318801; c=relaxed/simple;
	bh=xPAUWvQ9HwGzjV0vfk44BhqVTmOonfefuTTFKyrdXMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kyac017NJi+xnb4tIcT6c/tx4GkyuiqWXQ6H2onPOKD28PUHeONvtZ3Pav5ij+GiVpRB6uJl9qUYim0ANSQeJJSI9ED8WoUrRS/xvEWWxEOiKZSczNX7h1w9zNCSJsGH35ag0sJHpEo43tbkB8zwXiK70pUGoGCXud/Eb1cskJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=eHukfvb3; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=N8mzwz5M; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="eHukfvb3";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="N8mzwz5M"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 002F660265; Wed, 27 Aug 2025 20:19:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756318796;
	bh=U5UF2AfcHhd9YHYXbyIlxeITNHNDuLw3ziGn9PNLLNs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eHukfvb32RYR+cPXPAipA62Jy4omsZTCCtLPLnLnW5gioRbZKPwcYGn+o8QhhhZK1
	 iJyJYYEggaEcbgfkhS5+SWEQQa4UQL8tKaDbcRAdc70SZbQFTsHGmU5ne5HC8dkFII
	 V1DRgulLMhRJSv6XW1mUsex+9nzrp7gMstSc50lm6X38M2QZTjoeQ/NUQ7/JOwMYXW
	 jc4knlbrrxiV0AHcDXWZbTgIdlxyZFCoG9LO5Vg2140H4/UM96xGfz6BFnaKDv5IQ+
	 S5jr7hKwWbPRHM7lhJvTAbTGy7fDVVto3PtJPhjsMKErX6pbqVRIagpKn15c6g1/AC
	 f748XRLfLPB5g==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 21AEA60265;
	Wed, 27 Aug 2025 20:19:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756318795;
	bh=U5UF2AfcHhd9YHYXbyIlxeITNHNDuLw3ziGn9PNLLNs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N8mzwz5MnyDzP+kqvmInx9xKhFkcVDJNENEq2IoxyqUUU7n7nBHsSXMLKHPcrml01
	 dGAQzAdbFyug8Aq3RBtFyEx8jfENTRq0A2VJ7HVAuxBH8ZnySHV+HaZiXSaD9Xn1uf
	 3jj8N1BiQvXh8CYhn23b4Ykpqmg0DVNtYe7HpWtDqszo6jYpumWA/VVjDCKBy7EQgi
	 ZqWpW/WphA1sbMp/pivgJuZwBHhBgRoGxpFGAhva053aMfv0pGqxtuFUYJ3OHlMWgA
	 Ieb5TqPXnUNfoEA2Z9eZAYF+2jbFOyyopzeDH6cA6tMOItT4TDbvxnGfOFszCWHVJ2
	 gt58I8yN356NQ==
Date: Wed, 27 Aug 2025 20:19:51 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: nftables monitor json mode is broken
Message-ID: <aK9MRw-hiudD_tEK@calendula>
References: <aK88hFryFONk4a6P@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aK88hFryFONk4a6P@strlen.de>

On Wed, Aug 27, 2025 at 07:12:36PM +0200, Florian Westphal wrote:
> Hi,
> 
> as subject says, 'nft monitor -j' is broken.
> Example:
> 
> ./run-tests.sh -j testcases/object.t
> monitor: running tests from file object.t
> monitor output differs!
> --- /tmp/tmp.emU4zIN8UT/tmp.C4TeyO6xYk  2025-08-27 19:05:08.039619097 +0200
> +++ /tmp/tmp.emU4zIN8UT/tmp.jBOL3aIrp5  2025-08-27 19:05:09.062551248 +0200
> @@ -1 +1 @@
> -{"delete": {"quota": {"family": "ip", "name": "q", "table": "t", "handle": 0, "bytes": 26214400, "used": 0, "inv": false}}}
> +{"delete": {"quota": {"family": "ip", "name": "q", "table": "t", "handle": 0, "bytes": 0, "used": 0, "inv": false}}}
> monitor output differs!
> --- /tmp/tmp.emU4zIN8UT/tmp.C4TeyO6xYk  2025-08-27 19:05:10.095619097 +0200
> +++ /tmp/tmp.emU4zIN8UT/tmp.Guz55knY19  2025-08-27 19:05:11.117393075 +0200
> @@ -1 +1 @@
> -{"delete": {"limit": {"family": "ip", "name": "l", "table": "t", "handle": 0, "rate": 1, "per": "second", "burst": 5}}}
> +{"delete": {"limit": {"family": "ip", "name": "l", "table": "t", "handle": 0, "rate": 0, "per": "error"}}}
> 
> I did notice this weeks ago but thought it was a problem on my end
> and then didn't have time to investigate closer.
> 
> But its in fact broken on kernel side, since
> 
> netfilter: nf_tables: Reintroduce shortened deletion notifications
> 
> In short, unlike the normal output, json output wants to dump
> everything, but the notifications no longer include the extra data, just
> the bare minimum to identify the object being deleted.
> 
> As noone has complained so far I am inclinded to delete the
> tests and rip out json support from monitor mode, it seems noone
> uses it or even runs the tests for it.

Why? Is unfixable to consider this?

> Alternatives i see are:
> 1. implement a cache and query it

There is a cache infrastructure, monitor only need to use it.

> 2. rework the json mode to be forgiving as to what is set
>    and what isn't in the object.
>
> Object here also means any object reported in any delete kind,
> not just NFT_MSG_DELOBJ.  This applies to set elements etc. too,
> json expects the full info, but the kernel notifications no longer
> provide this.

But it does not make sense to provide the full information, delete
object should just provide the handle to identify, to remain in parity
with the native syntax.

> Alternative options?
