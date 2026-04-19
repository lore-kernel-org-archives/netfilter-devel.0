Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647941A3154
	for <netfilter-devel@vger.kernel.org>; Sun, 19 Apr 2026 11:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776596769; cv=none; b=A5gpPwsEjBoppAMH6biENwzhO+uBiiHYvZLu8W4VNmXnvVzwNBVEYwgOGFqCL2s3ZVgcNL3yxmPS+s5wxn9uFrg6nED9Ie71fJmGobUXlZqCHU13hOqTYrb6kqnpVXoyMFDHKC2R7fIIA2im4tF0BYOHTpDugIAu7Je80S+5vEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776596769; c=relaxed/simple;
	bh=80rfKGtOJDFIbys/dFkMMcgakGJPe5Co2BtSi6pZnlk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i+cm0jsdBqeHUSslyhpPRnCatzgEWYgFTNMgKx00HHyEHGD//WPHE40PMFJ3IKgChWWNmBOmstJb8hLiMPFEn1TV4ErQ2lv4p5PAfYazEuA1qgR+sEO47l6EQ4geJAeQiJNzLCxiKUzhbB5gvfEUbmvt4t0RDznA1S4I5vpRY/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Mo3O/vfD; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Mo3O/vfD"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 78E1C60179;
	Sun, 19 Apr 2026 13:06:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776596766;
	bh=Zie5+FLRwM+EhUgz7gHF7zF7ZMKEbQwG65mFp6eOOTs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Mo3O/vfDbZwm/iJUiXGeChrThis9kKrq1AHDDDIS2Kib5o09ktXJ7j+xvBtrhCGus
	 beHT9zA+s6umcAXLJxEC/rt9LicZ2fB3tFsHMdlHmexWeroqxpCye4db2ObYzEw0rA
	 iUxtPNjhAXwjysW7p3nUyjYhsTwhXEU6BSR86lwplgMJhodsyU3eQv9SGvpUMy2dpa
	 FJCztN7Epo8tLs8AXehBjsO8XtQiM2KUwFC5bE6SdGO6VJPntD5UiJadyZgBD+C8qg
	 hX5sqYB93pWbdPqVIPtnT2BKiMns9IxTvzntxfp2Wo5XadvjeDyLAYf3TxVcQVJ1Ki
	 JKe7pDqNXSeVg==
Date: Sun, 19 Apr 2026 13:06:03 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>
Subject: Re: [PATCH nf] netfilter: x_tables: add late validate callback for
 nft_compat sake
Message-ID: <aeS3G7h1fX8uot3B@chamomile>
References: <20260419104509.42196-1-fw@strlen.de>
 <aeSzcx9YmM3usuez@chamomile>
 <aeS1iwP8ra-yU_Qu@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aeS1iwP8ra-yU_Qu@strlen.de>

On Sun, Apr 19, 2026 at 12:59:23PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Sun, Apr 19, 2026 at 12:45:05PM +0200, Florian Westphal wrote:
> > > x_tables and nftables are fundamentally different.
> > > In x_tables, one gets the full ruleset graph via setsockopt().
> > > ->checkentry() gets called at ruleset validation time.
> > > 
> > > In nf_tables, you get a transactional request (rule add in this case)
> > > in netlink format.  At this time, it is not yet knowm from which
> > > basechain(s) the new expression is reachable.
> > >
> > > In nf_tables, there is one final hook validation pass right before the
> > > point-of-no-return when the new state is fully known.
> > >
> > > However, nft_compat calls the x_tables checkentry functions way too
> > > early, at expression instantiation time, when we have the netlink
> > > info available but not the base chain info (not yet known).
> > 
> > There used to be full validation of the table in each transaction in
> > nf_tables.
> > 
> > What happened?
> 
> As far as I can see this never worked correctly.
> 
> A few matches/targets perform hook_mask checks in ->checkentry(), but
> nft_compat calls ->checkentry() at expression init stage, which is too
> early and only catches problems if the target/match is called from
> basechain.

There is nft_{match,target}_validate() which check against
{match,target}->hooks and select_ops sets ops->validate accordingly.

Maybe this broke with your updates to speed up chain graph validation?

> iptables-nft -t raw -A PREROUTING -p tcp -j TCPMSS --clamp-mss-to-pmtu
> -> rejected at expression init time from ->checkentry()
> 
> iptables-nft -t raw -N FOO
> iptables-nft -t raw -A FOO -p tcp -j TCPMSS --clamp-mss-to-pmtu
> -> works, non-basechain
> iptables-nft -t raw -A PREROUTING -j FOO
> -> works before this patch: ->checkentry not called again
> (and we can't call it twice either as these functions are allowed
>  to have side effects such as proc file creation, kmalloc etc).
> 
> I don't see another practicable solution for this problem except
> this hack.
