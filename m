Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7581DF247
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Mar 2025 12:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742474493; cv=none; b=lNXc/yBoayYihnfKyF+huQUU0XEdRUQnpTkKOjvAGhz0HQSWqb+5y+TCSwoHGDqCuL1pwHpXvnk01s0N1d7k8U9kj87wscYDhXBWU38cyU1UDNKwKOfp20cVUGK5yBtKXvWLSKYU/uj0JnnXX7H+09LWNE4Ul4sm1+x82rHNqkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742474493; c=relaxed/simple;
	bh=12v+fKvUQ7pC3UcBfyTsJFUUoIqCOrybuQs3QHTCDwg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=idr0HX/EL+IQutx51JjG+i2st1mY8RfI21PkJjWv+sq9TtGslxPR73U8xitPVC914HB6AWQxkFOG5Nne0Tt8O/ioKkEnyFi4p4tNKmHzk9mboDPnnf+0CVZSP859WCwq8aV7pJvU1Dp3A6CLgWxi1WLK4btoy1/v7LMjkiYW67U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=geS3nDlt; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MfsXJ6IP; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="geS3nDlt";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MfsXJ6IP"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id D7B34603B6; Thu, 20 Mar 2025 13:41:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742474489;
	bh=V5INuPrUu6uSFn4SzwqWB2vhngl64PkrrJbEbI88BB0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=geS3nDltWh7h1xaW8K+csOBbdR+uAH+K3icm/84jYAmS1ZoDEUr4CIkWKqZhSnB5k
	 6pZAK4P7WVQVBkWqL0k0/ck/8Y1dkNNyPYRg6/Xmc0JFVk+ayKyn4TgBJXOEg+dvai
	 qc3wG6HrD/+t5b8VbiksYSwKet90TsoPYi+f0xXeSQibrQ+nD5INJClpAXTgXmjIDj
	 KZOdPmrddCQr148i4xace4U+Tcmi/AG4Hp2sKyYFkn8P128ySanYYd2uaWHxM0jscz
	 ufVsoYxURLsT+qwWurI9KqkLCYC0rur1qCoX6eWkEFPpKAG+nyph84cLg1yCRYWlqn
	 P/jSLMhyhQ91Q==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 836FB603A3;
	Thu, 20 Mar 2025 13:41:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742474488;
	bh=V5INuPrUu6uSFn4SzwqWB2vhngl64PkrrJbEbI88BB0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MfsXJ6IPE7wdJG0mFW3KrDngrOYIVjb5ZmTy7vvfX5k3mRjRNJ+q0Kt+ALtA2i2q0
	 xmuacVOAOGdXcoZ/lKsgPUyvrdxJ3see+I8ltGssE7VAOR54kSbnDb8135oMxKDIMm
	 PApYKrNZuP48o6yuqoqNgBisJQtFzp71FvuH693Uny78dgoQmtbtcWIf2mFlM7r7zp
	 79xIkXafQbw6Hjor6m6rt20vZ6z+qHaLTQ8TFrTMw3iox5b8QAOQBkKjCqVzWg2NUe
	 zfug0RQSWXmGhPx1KDHYLlb8zR5lUpUhEtG6akSMtW6xYyZ0B0GZSsM7FWjX460eQx
	 cZw1QjqsR6DzA==
Date: Thu, 20 Mar 2025 13:41:26 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next v2 0/3] Replace xt_recseq with u64_stats.
Message-ID: <Z9wM9mqJIkHwyU1J@calendula>
References: <20250221133143.5058-1-bigeasy@linutronix.de>
 <Z9IVs3LD3A1HPSS0@calendula>
 <20250313083440.yn5kdvv5@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250313083440.yn5kdvv5@linutronix.de>

Hi Sebastian,

On Thu, Mar 13, 2025 at 09:34:40AM +0100, Sebastian Andrzej Siewior wrote:
> On 2025-03-13 00:16:03 [+0100], Pablo Neira Ayuso wrote:
> > Hi Sebastian,
> Hi Pablo,
> 
> > Kconfig !PREEMPT_RT for this is not an option, right?
> 
> That bad? I though it would make you happy ;)
> Making it !PREEMPT_RT would essentially disable the whole nf-legacy
> interface. Given that it is intended to get rid of it eventually it
> might be an option. I mean there is nothing you can do with
> iptables-legacy that you can't do with iptables-nft? 
> I mean if this is not going to happen because of $reasons then that
> would be the next best thing.

We could give a try to this series and see.

Thanks
