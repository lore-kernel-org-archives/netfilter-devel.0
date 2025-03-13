Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A501EFF98
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Mar 2025 08:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741854885; cv=none; b=aeSNCS8U/Zcgx6WmBn5k5WIhehv19oglxjTyohfeB8+TU0QU2+2yXUACXROJsm5jA+hXz/KaSXSRieQx9QPTUXIOmASBbYhe18wYOWIbtgw7DN8qd+Ty8/UX9htkjBJ3y6U+3pdcsSjTxwbzHQDMGEuPovflk14Xd/n38WD0C/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741854885; c=relaxed/simple;
	bh=TVVON/ZwVj7ZxzuYRKb4qG8+UevQti9o35vGkEl2+B0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tA11d6I/bYpB/N7/cCs4CTXd3ki4ywDvUKUcrAJuPrEnYoFinUTagt2O/BovWKm5FXvvat6ARHbB+xjpEv8KB1wgiY7mOX9gWhtFvjTOxVV1Ygp0dNZXF0BIRsstxyh6Kio5wGCenRFZf4X+UDrbd05kWtPp7kWxqU38eYcvFFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=jFg9OE8t; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=btk5igP/; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="jFg9OE8t";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="btk5igP/"
Date: Thu, 13 Mar 2025 09:34:40 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1741854882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z1QdGmjXo7ZgbLC9nyneqKti66pQjDgye7JPZean61A=;
	b=jFg9OE8tGNHT2pUpaeyShzniPgsjBLfYsB3dreCT6GiMvNkixeBGRwlnT1h2sgn38uV8Uz
	qSEK26AsCFnNVzX9+CoPPpKxHIOcGvzsWSC8E/Q98TaO1Qx3jZHbsfNBsZkcT2AK+HrY0q
	WYkIYwG9ECCSeXywGzq+60PEOtxOQoEsMf2KNV+j33dlTLhq7oARYjcajUoFpnfp97YDwq
	f9O+z3KpU4PCiDOpceS+5g8Hwvin3ectozi7lTUHqtRbTNoMKD0gIEDxEXMuPPFbmIe37I
	RhAQ2HfvnbRUuy9mzBx/ZePvuaJfzpOykSrDt9/Y0ti3bIuKyOmj6Py3LnmbdA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1741854882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z1QdGmjXo7ZgbLC9nyneqKti66pQjDgye7JPZean61A=;
	b=btk5igP/rXnbWUHOsBYUYS+vn5PttuzcrEurkYcI9P5fB3PV8+llbUwkwAmgJ80ev3SnNz
	hbDZt/WcvW4zk2DA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next v2 0/3] Replace xt_recseq with u64_stats.
Message-ID: <20250313083440.yn5kdvv5@linutronix.de>
References: <20250221133143.5058-1-bigeasy@linutronix.de>
 <Z9IVs3LD3A1HPSS0@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z9IVs3LD3A1HPSS0@calendula>

On 2025-03-13 00:16:03 [+0100], Pablo Neira Ayuso wrote:
> Hi Sebastian,
Hi Pablo,

> Kconfig !PREEMPT_RT for this is not an option, right?

That bad? I though it would make you happy ;)
Making it !PREEMPT_RT would essentially disable the whole nf-legacy
interface. Given that it is intended to get rid of it eventually it
might be an option. I mean there is nothing you can do with
iptables-legacy that you can't do with iptables-nft? 
I mean if this is not going to happen because of $reasons then that
would be the next best thing.

> Thanks.

Sebastian
