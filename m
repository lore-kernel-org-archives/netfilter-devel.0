Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1A1306B1A
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 23:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761865858; cv=none; b=l3kxdKxgIUSpKTmGluLpzYvgW7eKp/g60FQk4pNAWYOP42LzGiJ+ROtbhd2QikgA5M2XAXuRc96d9PW963bzCY/vHZkoHdP/16eo169+6OD4IIK+VcvPxtG7HD2/X/ajPIgMeL5fHStsVffWlFXrS/+D3a3GN05RhqbU7NOJilk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761865858; c=relaxed/simple;
	bh=wCqgTROzH7yDsvg4b2gkRW3Grr6bAKPpGi7mD47SDFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kiOxCKshLat/JM4UIifVrVmJnxqw4TeTM23hrTL3aH8UBxFqnnQiAmtQBi4ZXClwiB4IYEtX2DVJayi8EsmWxtnKOK6Hr/E7ILygtMGNPOY09Fn/5yJ9PwtXIApNqf0/k82hSU6iSpOpo59t32gtvxzABB0zqK3c+ZrWg64m4CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BBB256017F; Fri, 31 Oct 2025 00:10:52 +0100 (CET)
Date: Fri, 31 Oct 2025 00:10:52 +0100
From: Florian Westphal <fw@strlen.de>
To: Christoph Anton Mitterer <calestyo@scientia.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: nftables.service hardening ideas
Message-ID: <aQPwcOW3X-4OGuiq@strlen.de>
References: <71e8f96ac2cd1ee0ab8676facb04b40870a095a1.camel@scientia.org>
 <aQDuvGsDwlaiK94D@strlen.de>
 <7c3760d6afad70f7579311022748363f7d5f5c77.camel@scientia.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7c3760d6afad70f7579311022748363f7d5f5c77.camel@scientia.org>

Christoph Anton Mitterer <calestyo@scientia.org> wrote:
> Hey.
> 
> On Tue, 2025-10-28 at 17:26 +0100, Florian Westphal wrote:
> > Christoph Anton Mitterer <calestyo@scientia.org> wrote:
> > > This would be ideas about further hardening nftables.service,
> > > primarily
> > > using the options from systemd.exec(5).
> > 
> > Whats the point?  nft will exit anyway.
> 
> Uhm... well the point of any sandboxing is always (at least trying to)
> prevent any attacks.

Sure, but then we're talking about e.g. bug in dns resolver/parser
or something like that.

In general I don't believe Linux is capable of isolating against
abusing userspace, unfortunately.  Especially with CAP_NET_ADMIN
(which is very broad and provides access to many facilities in
 the kernel) or with unprivilged user namespaces enabled (the default,
sigh).

> Sure, nftables is probably not the most likely program to be abused (in
> particular as it usually won't process untrusted input), but still even
> nftables can't be 100% sure to never be abused in something like
> secretly included malware or so.

In that case I think all bets are of.

> As with the first patchset my idea was simply that *if* a .service file
> is shared it could as well be proper and use as many sandboxing options
> from systemd as possible, serving as and example for e.g. downstream
> versions of such .service.

Ok, if you want then feel free to start to send patches.
(and CC Jan).

I think that enabling CAP_NET_ADMIN restriction is fine,
otoh if you think that this should be done then I believe
its better to patch nft and not rely on systemd for this.
