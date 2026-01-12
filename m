Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFF1182D2;
	Mon, 12 Jan 2026 08:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768205196; cv=none; b=ACzZHED8WHLBHOoqKKBmnntOXF3d8P5VgWgFxvxRvx8jyTyNA/PrkAyMWo3b2m+vkMS8gcyC4pW4m9aVbhrg0/ADkfnj9qHBYFzDF0iJGGsRvHF3uDntgI2CNHJaYx7brsl2nNmpzlkOyb+n9sbgDr3MQKwr4VwfcMyGi8sPTvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768205196; c=relaxed/simple;
	bh=lftOdkzRph5k7Ol1PQs0TjdDx8SQzf81PUzHXAE075o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VsAjbZxFKtvrSN2ChSRDHEv1wpSKhaqiWre8MjqNa61j4+gMMD63uXhXenAOfJc7p9KzfpjbNx3HOuIe6JacD5YiuknabYJCDAzQuMQNGZGPJFwXdsFVbJCgsaHyscZfW3fS2ARcskeSKN09D5tJPNQrai+iMlzQyo2lWfN45g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=TyBXxtCj; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=3WmnIxcP; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="TyBXxtCj";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="3WmnIxcP"
Date: Mon, 12 Jan 2026 09:06:27 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1768205187;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QkZxzMsXxU6PaVksDBvkJ+P+Zon4J13wicN6z2Btc+k=;
	b=TyBXxtCjICANv+nY+wGc2v24H38UOLTeWBCFqfReB0IXNTCozUK1mh1ZLEKHoydBBaUydU
	CLYulkag3DlaCue/xCYZ8VAfF+N7Hq1n2Ta/4x+rKhFV1M3aL60rFcw9D2gx24R4QJlqYK
	4oayDsucDUVV6O0i1VwTsa03/TjnZ+7mJkRvoL7po6ja085TU8qkw6v/4X78crUo0YnnO4
	KuU5LAfxTA+NR22jK0YKXvKEBoCt7OERvUSFYZUc7fg9dvOUnirkz/Fcl6I8lhYV+fbdh/
	rIxnIQHq4FLnAcy/iWl3g5MBPa1rqgurT3FFCIsnAU8n7dcDKYmCYe38DDwv6w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1768205187;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QkZxzMsXxU6PaVksDBvkJ+P+Zon4J13wicN6z2Btc+k=;
	b=3WmnIxcPUvPox3gU1g5mVY+FhcFk4oc/QG7rNEVibyDkM3pOe5dcbqef2SHDhZfHZC0QDn
	vakzvraALmq1mFBQ==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Andrew Lunn <andrew@lunn.ch>, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, linux-kernel@vger.kernel.org, 
	Netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH RFC net-next 3/3] netfilter: uapi: Use UAPI definition of
 INT_MAX and INT_MIN
Message-ID: <20260112090140-8b5fb693-989f-4af6-b65c-9c24a12d8779@linutronix.de>
References: <20260105-uapi-limits-v1-0-023bc7a13037@linutronix.de>
 <20260105-uapi-limits-v1-3-023bc7a13037@linutronix.de>
 <d3554d2d-1344-45f3-a976-188d45415419@app.fastmail.com>
 <20260109111310-4b387d2e-1459-4701-9e58-dc02ad74c499@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260109111310-4b387d2e-1459-4701-9e58-dc02ad74c499@linutronix.de>

On Fri, Jan 09, 2026 at 11:20:22AM +0100, Thomas Weiﬂschuh wrote:
> On Mon, Jan 05, 2026 at 02:02:17PM +0100, Arnd Bergmann wrote:
> > On Mon, Jan 5, 2026, at 09:26, Thomas Weiﬂschuh wrote:
> > > Using <limits.h> to gain access to INT_MAX and INT_MIN introduces a
> > > dependency on a libc, which UAPI headers should not do.
> > >
> > > Use the equivalent UAPI constants.
> > >
> > > Signed-off-by: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>
> > 
> > I agree with the idea of the patch series, but I think this
> > introduces a different problem:
> > 
> > >  #include <linux/in.h>
> > > +#include <linux/limits.h>
> > 
> > linux/limits.h is not always clean against limits.h. In glibc,
> > you can include both in any order, but in musl, you cannot:

(...)

> > I can think of two alternative approaches here:
> > 
> > - put the __KERNEL_INT_MIN into a different header -- either a new one
> >   or maybe uapi/linux/types.h
> 
> > - use the compiler's built-in __INT_MIN__ instead of INT_MIN in
> >   UAPI headers.
> 
> If we can rely on compiler built-ins I would prefer this option.

It turns out that the compiler only provides __INT_MAX__, not __INT_MIN__.
We can derive INT_MIN from INT_MAX as done in the original commit, but
open-coding it is ugly as heck. So we are back to a definition in a header
file again.

What about putting them in uapi/linux/types.h or adding a new
uapi/linux/typelimits.h?


Thomas
