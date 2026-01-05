Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8E617736;
	Mon,  5 Jan 2026 14:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767624525; cv=none; b=lYllaFDSs7Qv1FNemLgLhiC0MqMY2mUsjcuLSoLxYW/jZLufOGCgY9uOOh8YzME9cZQ4XILUrpidE0mDgJ6P47+D5mY0edz3AHMI+H2eJ+Vo8yF9bEJZkQFFv/+FNKHCVUAvB0z+n0vnpggUpx3gzGICFJtccMlsok28EraRr/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767624525; c=relaxed/simple;
	bh=D8ZDylyNaO7a1YULuB3qtg+Imwuj9iNUix8M4auAjSI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Maui3gcgyCYAf5IwmRzN6waDtsOQGKa2CMLI1oO1Hv4POZiKb5zjSWJI/5v4W0nPxEVwj6aNVpTcZgBsAW8lUAJN5sGfD3/btilboUITRxJY/oyDQQxQEiv5WSeDW/R1wXiNPXxs0OltAQJNSC3HApMgy1uMWyHZic4Yw2Q3Tu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=ue5F62vf; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=+yPU6Mvk; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="ue5F62vf";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="+yPU6Mvk"
Date: Mon, 5 Jan 2026 15:48:38 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1767624521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RK1ege7lL4G3FEhJT1V+htfNNauc/205k+U2T2Cmj9o=;
	b=ue5F62vfvt6ZfGnmKmiEWSUkM+X5yhpLERp++1iIms0aLYWdto/WPwaYW52lpK4DRnnzlA
	cJIG9/CtescuCTLW3LEVMeUORVCla0We10fEN29cuMEJZ/j7N6jE0MYZxS7wMooouVggJ7
	PtNYUIAlv6lB5/1M5UrbK13hU/7UKNOtQQoS8Kc6Tkq+yBcJh+YMMkie9ItbHKGYNNpY7U
	yZZ1yAiqHSh11PD4oVgdtZtlA+K5uypZgdozwrs6He3doCYoaxKZI/g449u9PM10PxwH3l
	c8Y2Qh1Vx0a54sjVPtM82RGAb2CoXzXeKLsSKsjk3xSSOwV732lqDfZem77MIA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1767624521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RK1ege7lL4G3FEhJT1V+htfNNauc/205k+U2T2Cmj9o=;
	b=+yPU6MvkityWZ4a4DJYeJbcwJo5jznELU4QSjMKh4VhISWNykdlebWlhQ359YMiWc90yeB
	15YzfxtW5qS41RAA==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Andrew Lunn <andrew@lunn.ch>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, Arnd Bergmann <arnd@arndb.de>, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org
Subject: Re: [PATCH RFC net-next 1/3] uapi: add INT_MAX and INT_MIN constants
Message-ID: <20260105154705-2301e4f2-948f-422d-bfed-81725ac82bc8@linutronix.de>
References: <20260105-uapi-limits-v1-0-023bc7a13037@linutronix.de>
 <20260105-uapi-limits-v1-1-023bc7a13037@linutronix.de>
 <ae78ddb2-7b5f-4d3b-adef-97b0ab363a30@lunn.ch>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ae78ddb2-7b5f-4d3b-adef-97b0ab363a30@lunn.ch>

On Mon, Jan 05, 2026 at 03:37:14PM +0100, Andrew Lunn wrote:
> On Mon, Jan 05, 2026 at 09:26:47AM +0100, Thomas Weißschuh wrote:
> > Some UAPI headers use INT_MAX and INT_MIN. Currently they include
> > <limits.h> for their definitions, which introduces a problematic
> > dependency on libc.
> > 
> > Add custom, namespaced definitions of INT_MAX and INT_MIN using the
> > same values as the regular kernel code.
> 
> Maybe a dumb question.
> 
> > +#define __KERNEL_INT_MAX ((int)(~0U >> 1))
> > +#define __KERNEL_INT_MIN (-__KERNEL_INT_MAX - 1)
> 
> How does this work for a 32 bit userspace on top of a 64 bit kernel?
>
> And do we need to be careful with KERNEL in the name, in that for a 32
> bit userspace, this is going to be 32bit max int, when in fact the
> kernel is using 64 bit max int?

'int' is always 32 bit on Linux.


Thomas
