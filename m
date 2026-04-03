Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197B033E34B
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Apr 2026 19:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775243648; cv=none; b=YqJUG91pj2mhjhR1Cww3KKJI4XnUcsU1hARE2LpXQ8tmH+iLGQBxm1R2Qiy+SusfeqLvd5T+b9kx77KgUHALEaV+5e70naKP8bS9ayZ7t8Jfj+2jO1D3kPEQ2ImgPRC3VlAQUem627po/1w/r2EPqBZsCEoQhAIIxx27d8vUh4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775243648; c=relaxed/simple;
	bh=IXasO1xs/DT2h4F3bBVfO3tOxnJDfDW4U1odhqahIWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TpCkdV9o35rBJisSo6ZziavsAhefNxKA0v3vmi0ed7zoLXJdJvRFoC95w8w3QQhm9uPAzeDKt0yifZY3ZLRSRNS8b8g1ntbk7DPsXOXhaxlHFimg5jLNrUacRqTvbGlQSQO+Rb0IEyzSlmu/aTL1vdNWCX+bzIsXO1ZataFwcis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 84E5F60913; Fri, 03 Apr 2026 21:14:03 +0200 (CEST)
Date: Fri, 3 Apr 2026 21:14:03 +0200
From: Florian Westphal <fw@strlen.de>
To: Scott Mitchell <scott.k.mitch1@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: nfnetlink_queue crashes kernel
Message-ID: <adARe9HW3emmdj6q@strlen.de>
References: <ac-w6e33txkgTRJj@strlen.de>
 <ac_EY9ciqt5yQ6wr@strlen.de>
 <CAFn2buDAPLPjS5fXejDiuY5pV1rduMes2Ho=sSYmFVMVmh5xAw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFn2buDAPLPjS5fXejDiuY5pV1rduMes2Ho=sSYmFVMVmh5xAw@mail.gmail.com>

Scott Mitchell <scott.k.mitch1@gmail.com> wrote:
> > diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> > index 47f7f62906e2..15c6276f6592 100644
> > --- a/net/netfilter/nfnetlink_queue.c
> > +++ b/net/netfilter/nfnetlink_queue.c
> > @@ -60,29 +60,10 @@
> >   */
> >  #define NFQNL_MAX_COPY_RANGE (0xffff - NLA_HDRLEN)
> 
> NFQNL_HASH_MIN (1024) and NFQNL_HASH_MAX(1048576) were set when the
> table was global, but if table is moved to per queue it can likely be
> reduced. Suggested values:
> 
> #define NFQNL_HASH_MIN 8
> #define NFQNL_HASH_MAX 32768

Changed, thanks.

> Should `netlink_unregister_notifier(&nfqnl_dev_notifier);` be
> 'unregister_netdevice_notifier(&nfqnl_dev_notifier);' ?

Yes, thanks.
