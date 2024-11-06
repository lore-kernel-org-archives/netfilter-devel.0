Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B521DB365
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2024 09:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730884211; cv=none; b=Q7+LbwUslNIsx73RXllBK0R5WZP2fJgyBhQtOfnVcVycBJYf6zJnByAO5Q1ekfeqUPyeZfzrBHTE8kYMPxvp2SXODyYl4r072pHX1jHIarQP9ybZkaaem1dktSGmMkgmuwKtu0xTj+lHqNSc9swUK5AHDKo5kxOJWBfZ7LDLMuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730884211; c=relaxed/simple;
	bh=JyDkxsuOrwhDxVe0iYDEeuCfK0BjHU/cMlS5JgHNmB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rIQ5n0lH6Qg1XbdC+puNForNsHhKB+EkIZucPIRnaDN4j8gSo6XdgHSw2k6FSHLTEas431zf/5l71CAuPy432M9UPhjpvXUfqlAdLP37UZDllZmlG5D79MQt02uFzC63BTHVHFdeNddpHzWQutuKwgpYTtaPwrdDIpJZfpA/y0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=56472 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t8c39-008pXv-LQ; Wed, 06 Nov 2024 10:10:05 +0100
Date: Wed, 6 Nov 2024 10:10:02 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Nadia Pinaeva <n.m.pinaeva@gmail.com>, netfilter-devel@vger.kernel.org,
	Antonio Ojea <antonio.ojea.garcia@gmail.com>
Subject: Re: [PATCH nf-next v2] netfilter: conntrack: collect start time as
 early as possible
Message-ID: <ZysyaqYhMEOzdWFm@calendula>
References: <ZypDF4Suic4REwM8@calendula>
 <20241105162346.GA9442@breakpoint.cc>
 <ZypHs3XO4J2QKGJ-@calendula>
 <20241105163308.GA9779@breakpoint.cc>
 <ZypLmxmAb_Hp2HBS@calendula>
 <20241105173247.GA10152@breakpoint.cc>
 <ZyqoReoNkhz_fo3p@calendula>
 <20241106082644.GA474@breakpoint.cc>
 <Zyspid81oTuwYtcQ@calendula>
 <20241106083438.GA1738@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241106083438.GA1738@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Wed, Nov 06, 2024 at 09:34:38AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Can you clarify?  Do you mean skb_tstamp() vs ktime_get_real_ns()
> > > or tstamp sampling in general?
> > 
> > I am referring to ktime_get_real_ns(), I remember to have measured
> > 25%-30% performance drop when this is used, but I have not refreshed
> > those numbers for long time.
> >
> > As for skb_tstamp(), I have to dig in the cost of it.
> 
> Its not about the cost, its about the sampling method.
> If skb has the rx timestamp, then the event will reflect the skb
> creation/rx time, not the "event time".  Did that make sense?

I think ktime_get_real_ns() needs to be used to get the "event time",
I am afraid skb_tstamp() is not useful.
