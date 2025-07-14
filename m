Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C324E246BB6
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Jul 2025 14:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752503800; cv=none; b=PZMBdpkaa5yOEbCYtv8LwI9lReUU4vyKU5FAnC02hlyeXxPvqMd7x/VDX4Y/caRB7ni6O2ZZiK1IggPOJGZoFI9HPGdHIM8M867h3oFmqFc8JquZztc4Mo45+kYlEuRe/zUc4i0XPkjUpecbtlV9Xkv4NvlXV3xP2dg13xl1Zzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752503800; c=relaxed/simple;
	bh=Ie/kvWWoTyDhx1F73bK0SCW0UHm4R5zbHFO6nU5M9Xg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nTbEv2i1qNUYVVw0DTfZYEfXaWLz9jt8lO5f3gFyNoMm7qOqFy38WTyPVDz+5d391kzmzwlKzTToIg4GihBidCC7BYB4bo1rRhPjs27iBfqvX/lsc7wVbE7x1uG1fcKkrLoPCc3EvUOjXjWALxzwiO4KvdHrGasu7LIPu8fs+Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 493FB609BD; Mon, 14 Jul 2025 16:36:35 +0200 (CEST)
Date: Mon, 14 Jul 2025 16:36:35 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 4/4] netfilter: nf_conntrack: fix crash due to removal
 of uninitialised entry
Message-ID: <aHUV8-hd1RbiupaC@strlen.de>
References: <20250627142758.25664-1-fw@strlen.de>
 <20250627142758.25664-5-fw@strlen.de>
 <aGaLwPfOwyEFmh7w@calendula>
 <aGaR_xFIrY6pwY2b@strlen.de>
 <aHULbUHBCM4bUw8e@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHULbUHBCM4bUw8e@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Jul 03, 2025 at 04:21:51PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Thanks for the description, this scenario is esoteric.
> > > 
> > > Is this bug fully reproducible?
> > 
> > No.  Unicorn.  Only happened once.
> > Everything is based off reading the backtrace and vmcore.
> 
> I guess this needs a chaos money to trigger this bug. Else, can we try to catch this unicorn again?

I would not hold my breath.  But I don't see anything that prevents the
race described in 4/4, and all the things match in the vmcore, including
increment of clash resolution counter.  If you think its too perfect
then ok, we can keep 4/4 back until someone else reports this problem
again.

> I would push 1/4 and 3/4 to nf.git to start with. Unless you are 100% sure this fix is needed.

3/4 needs 2/4 present as well.  I can then resend 4/4 then with the

> > - ct->status |= IPS_CONFIRMED;
> > + smp_mb__before_atomic();
> > + set_bit(IPS_CONFIRMED_BIT, &ct->status) ?

change.
