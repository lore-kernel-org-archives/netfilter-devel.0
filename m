Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4497464
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Oct 2024 09:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730195612; cv=none; b=nvE0485pwsEbLS1bvo7Pn49Je3MfvhzfQ6sgBaI+J4UobJlzNwP7WttqWB2Xekeou2jUWoKR98mkLC3aGUkJoWQNLzt9Z33H0dE1eROr6lQwu/RQ/cMau8WBDFraKrStMIn4LIcO5p4hcpeCewKFyiCb6fEkY8JZmb7rbmJLVFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730195612; c=relaxed/simple;
	bh=T6WFMTQRNmuJpcFIcSV6iVf7Of5BXbL7QaqWLO8a7+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZEt4BDDCKZdqZORDB5A47dzEMuLXSnSnYE4ZfvGmsX0htR4HHoKJk9b8lyP+VebRigfEnd4xiVEyKtOYfvxnSjWMA0vvdEU++8vcWxwsOxm1cpo7UdYkmUDLSBd/N/L6aoI2qC9rZUsZB+TppxoRdiXdPMus2jW4PXXjrd6SwqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=33156 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t5iuj-006gKx-1s; Tue, 29 Oct 2024 10:53:27 +0100
Date: Tue, 29 Oct 2024 10:53:24 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	Nadia Pinaeva <n.m.pinaeva@gmail.com>
Subject: Re: [PATCH nf-next] netfilter: conntrack: collect start time as
 early as possible
Message-ID: <ZyCwlAhyQMLh_q-M@calendula>
References: <20241026105030.75254-1-fw@strlen.de>
 <ZyAZogr_F4GlCpPo@calendula>
 <20241029071624.GA16983@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241029071624.GA16983@breakpoint.cc>
X-Spam-Score: -1.8 (-)

On Tue, Oct 29, 2024 at 08:16:24AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Sat, Oct 26, 2024 at 12:50:13PM +0200, Florian Westphal wrote:
> > > Sample start time at allocation time, not when the conntrack entry
> > > is inserted into the hashtable.
> > 
> > Back at the time, long time ago, I remember to have measured a
> > performance impact on this.
> 
> You mean when enabling timestamp + conntracks get dropped before
> confirm, correct?

Yes.

> > > In most cases this makes very little difference, but there are
> > > cases where there is significant delay beteen allocation and
> > > confirmation, e.g. when packets get queued to userspace.
> > 
> > I delayed this to insertion time because packet could dropped before,
> > rendering this conntrack timestamp useless? There is no event
> > reporting for conntrack that never get confirmed.
> 
> Sure, but the "issue" is that the reported start time doesn't account
> for a possible delay.  I did not measure huge delta before/after this
> patch but if you have e.g. nfqueue in between alloc+confirm then the
> start timestamp will account for that delay after this patch.

I see. I think the question is what this start timestamp is. For me,
it is the start time since the conntrack is _confirmed_ which is what
we expose to userspace via ctnetlink and /proc interface.

Is this user trying to trying to profile nfqueue? Why does this user
assume conntrack allocation time is the right spot to push the
timestamp on the ct?

On top of this, at that time I made this, I measured ~20-25%
performance drop to get this accurate timestamp, probably this is
cheaper now in modern equipment?
