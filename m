Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA492BE64E
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Jul 2025 22:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752617367; cv=none; b=Cjp3B03Bo/DS45W4O1HKW8mrl829hxR600CRR+chwSYZCpZKfotSSQE/RdfFtZK18b1NxcZXbTgQdHAme8BuvrXhy5xh+jDZJGfmUEHEyMX216KXBo/u94uF7h4+a1RvICzYY4uFFfljMD3U4KxvuS+LWTXEfmDloPQZuiFL1Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752617367; c=relaxed/simple;
	bh=pWueEUjr4p/JEzXsOvt+NGEmQWMny5LRASOWEbdRuXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Anz4QOlYFZEujZgQoIO0k/n9b0XMnYuugHiOHJEKA1IajTWhYqQxCxnqEkd5mK3qUmxYmi1Dvlg8eanh92R9L+PF8yuOI5OGYWmEjLmscTDfOREpyTmtJKsPraLVqt85XOTCP8q8A2BWWi3HBv3QnU7F5aojoK/0RR8BC3qs25E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=JzPS4PeJ; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ltc7y/ho; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="JzPS4PeJ";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ltc7y/ho"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 80A75602AB; Wed, 16 Jul 2025 00:09:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752617355;
	bh=6oEtjOvp1dLKCnfNXAv3t7jKL9Vu2TQAxiSKQYBsM4s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JzPS4PeJaWXwk9FuRj4KraX7EaGjWXhRp0g8DDrwaqFQjADHa3/RIRVspjVCA+82/
	 XwDice9r7VKQz/FGDg8/fpb5ROe31jE9bgqZEuokoclevdohqU5JGEbX+C74I4U5nt
	 lXf/i481Kt4qQ1vohNFch7P7P97AhuWDx8IW1zy2O2KhMJ7nKJnbA8sHi5zCAGzT5b
	 87sC/obqK6C8LG0vTt+zsIlBMNLyGd/t9Cy2dVTkK8ZWT0esk/qwDFS8WdJgAcef21
	 YEQo3gMDWDaAlIcWuXfw+uitGX/R9LNbHBeWdnvbZnf9BDUL6hQJyfMvOduMjSzsDm
	 9OL9MlKq4kf4A==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CE9F7602AB;
	Wed, 16 Jul 2025 00:09:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752617354;
	bh=6oEtjOvp1dLKCnfNXAv3t7jKL9Vu2TQAxiSKQYBsM4s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ltc7y/hoz6dBEThf7YkvL/eGs6AtjuCiSjaeWa3akiSSJoUP8BuS7I6Ze2CkMF+cj
	 EvzEdBUAh1YegpHy/raa9TT69n32kS05qXlvMU7YMyu0paatw8sj2k+HDrz9u0oaCV
	 qnrzOqAfLs0VI0bO5TJLe5bk22YKhQ/cpVGskj/Ts+s2l+jsV6Z60EzGZf1pJroRdJ
	 z927OXjniB5fhIieWvQ3B/XWV8csvhm0n9xxeJkTgnHFrM0tqvkkYt3EouBlGXn+yg
	 x1fP+SaiEohDIbpzVcwMHc4qLVBJ/n6Td91E5lJct+vB/Yru/24jk7efp4/Oy6wZm7
	 bAu03N3DlrVYw==
Date: Wed, 16 Jul 2025 00:09:10 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 4/4] netfilter: nf_conntrack: fix crash due to removal
 of uninitialised entry
Message-ID: <aHbRhj-NW3frJt0v@calendula>
References: <20250627142758.25664-1-fw@strlen.de>
 <20250627142758.25664-5-fw@strlen.de>
 <aGaLwPfOwyEFmh7w@calendula>
 <aGaR_xFIrY6pwY2b@strlen.de>
 <aHULbUHBCM4bUw8e@calendula>
 <aHUV8-hd1RbiupaC@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aHUV8-hd1RbiupaC@strlen.de>

On Mon, Jul 14, 2025 at 04:36:35PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, Jul 03, 2025 at 04:21:51PM +0200, Florian Westphal wrote:
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > Thanks for the description, this scenario is esoteric.
> > > > 
> > > > Is this bug fully reproducible?
> > > 
> > > No.  Unicorn.  Only happened once.
> > > Everything is based off reading the backtrace and vmcore.
> > 
> > I guess this needs a chaos money to trigger this bug. Else, can we try to catch this unicorn again?
> 
> I would not hold my breath.  But I don't see anything that prevents the
> race described in 4/4, and all the things match in the vmcore, including
> increment of clash resolution counter.  If you think its too perfect
> then ok, we can keep 4/4 back until someone else reports this problem
> again.

Hm, I think your sequence is possible, it is the SLAB_TYPESAFE_BY_RCU rule
that allows for this to occur.

Could this rare sequence still happen?

cpu x                   cpu y                   cpu z
 found entry E          found entry E
 E is expired           <preemption>
 nf_ct_delete()
 return E to rcu slab
                                        init_conntrack
                                        <preemption>     NOTE: ct->status not yet set to zero

cpu y resumes, it observes E as expired but CONFIRMED:
                        <resumes>
                        nf_ct_expired()
                         -> yes (ct->timeout is 30s)
                        confirmed bit set.

> > I would push 1/4 and 3/4 to nf.git to start with. Unless you are 100% sure this fix is needed.
> 
> 3/4 needs 2/4 present as well.  I can then resend 4/4 then with the

Right, I accidentally skipped that test, it should be also included.

> > > - ct->status |= IPS_CONFIRMED;
> > > + smp_mb__before_atomic();
> > > + set_bit(IPS_CONFIRMED_BIT, &ct->status) ?
> 
> change.

If the status bit is used to synchronize the different threads,
I agree this needs to be set_bit(). But I am not sure yet this is
sufficient yet.

Thanks.
