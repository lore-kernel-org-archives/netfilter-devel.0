Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2669331EBB
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2026 22:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787610188; cv=none; b=GL5UXXsJSr8b1WoKR+6c17jdKDglJ6MkSBtVCg3NVo3qMbRvGiRl+VH9NQ6kH6XXNCIfzwihf5ZjZOi0c2HqEyxOhPElpxMH8o9bQw1xppukrKp0NPBh1o+fUpotEIMLyY+kQENBilPm/Nm5utL2pc2jlGsV+7pBnTgEUb1h1cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787610188; c=relaxed/simple;
	bh=FY+esbbfI6Zihk1qykZkAI22KHpBUpkrb6KaHP7dJJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BclLFQdZ2dKqfXzlS3W/Ca2oHBTlA9zL/Mn9RUGjRrImM/nqYEw7rC7su6A17xBFlTGEoJUjWmEsb/yI81bghyFy4oAnlrMAMRiM2WANHzEy3lYk2tVymrM2aDvddDEwDgWT8fsvFisIpL1p1+HGMTwrDkdCSnKOpguU+5FZkpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=G6aFziEe; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="G6aFziEe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787610184;
	bh=x1ooKgD8bjSL4Mohn67kglBfc1gvarrYiPkKb5/CcQw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G6aFziEeCOQJblE3t/fVnAu3Vn4hLX8CVqJx11wBcZIHJWNRFynTGZH68mmJBPYUa
	 WWIikCYuuXRWI7PjD9z1WH9vCuptw6OP7vRTY4bptm9jSUyDvPl2r+Fh464a6uz2fg
	 XmjmIfeDveCAz61PF//j/TThHiCqcrwO438g62fIeM/XynTm2lJdDDFoCGLsNyobtv
	 ADg8d5NfTdsjSfmGQYHKcyhe1e3Ne+ENOix6xXEEoHFyDjCjARlN5ILyhOUbi0Gt03
	 B4yCviBBJs842YgabivCYO5xrOqcUmAwPXwyOnpVW6JG1hdkRYp2SzWGlWGMdgLWoZ
	 W4x+QNo9jkFaQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id A38B56005C;
	Tue, 25 Aug 2026 00:23:04 +0200 (CEST)
Date: Tue, 25 Aug 2026 00:23:01 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Zhiling Zou <zhilinz@nebusec.ai>
Subject: Re: [PATCH nf-next] netfilter: x_tables: reject missing '-p' flag
 and check for INV flag
Message-ID: <aozERf3kQQYrPjMk@chamomile>
References: <20260821134136.18191-1-fw@strlen.de>
 <aohabszy_Ac23p7x@chamomile>
 <aolaWzC1PI7zeYRN@strlen.de>
 <aoy8kFZkXMNOHUcR@chamomile>
 <aoy977yxzSEsViun@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aoy977yxzSEsViun@strlen.de>

On Mon, Aug 24, 2026 at 11:55:59PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > Sashiko also hinting to fix ip6_tables core check for this protocol
> > > > flag:
> > > > 
> > > > https://sashiko.dev/#/patchset/20260821134136.18191-1-fw%40strlen.de
> > > 
> > > Not so sure.  Maybe just do this?  I don't think proto > 0 and flag
> > > unset makes any sense.
> > > 
> > > diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
> > > --- a/net/ipv6/netfilter/ip6_tables.c
> > > +++ b/net/ipv6/netfilter/ip6_tables.c
> > > @@ -647,6 +647,13 @@ check_entry_size_and_hooks(struct ip6t_entry *e,
> > >  	/* Clear counters and comefrom */
> > >  	e->counters = ((struct xt_counters) { 0, 0 });
> > >  	e->comefrom = 0;
> > > +
> > > +	/* Make sure F_PROTO is set, else ip6_packet_match
> > > +	 * won't do the right thing.
> > > +	 */
> > > +	if (e->ipv6.proto)
> > > +		e->ipv6.flags |= IP6T_F_PROTO;
> > 
> > Userspace always provides a zeroed e->ipv6.proto when unused, correct?
> 
> Yes, ip6tables raises it when it parses '-p' option.
> 
> > If so, LGTM.
> 
> Alright, I will respin tomorrow, thanks.
> 
> Do you want me to include the TPROXY fix too?

I think that is nf-next material, for correctness. Not urgent.

Thanks!
