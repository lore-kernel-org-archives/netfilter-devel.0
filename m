Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD0E26290
	for <netfilter-devel@vger.kernel.org>; Sat, 23 May 2026 06:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779517735; cv=none; b=kUJcQJI0/L6Yror3H2PSpd2vKrdazSJJMvrTun/Xb6MNgGPoaemuO7aaAMy8yOh5b6d7XqiFIihDMMjiZqJzn4azyoO6XbMwv0r36cZoP7Cpe8bycnLhyrsXAbwzCTle6QjVehnHBKGnMAM2t7yA+Xym9EtZmvHdduDoqBxwqos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779517735; c=relaxed/simple;
	bh=S4+yaK6Ie7IFvkHQMiv1yRrBuLAK6J7hlut4fZSFEX0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uEdPM3UJAb7dfFJLuXpQ7lVrzIK4HNLLznxrSXkhZcqjjCuR27l4zLQapiHWkDj/+ABs823vgLtb1s0n3RU569Yx84LQNA0t3KZxNAQUgNnAntPR4/KbeuvCC74VvheKMFf0luwGcBJVI2HYzY7kjLNiAjqM9Y0m6LgY5ReAT9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=uBuGY8HG; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="uBuGY8HG"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id CB37D6017F;
	Sat, 23 May 2026 08:28:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1779517723;
	bh=NMt/1bnFHbxSjkGyQO4rXFybarDFNjunmFiu20ICAv8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uBuGY8HG/4bOdGlJInHFFOWV5NkznQfec2QOKs+SivkZSF86p/B33nQDBjbEepTV6
	 oKN8T7o/pAAUyHZJ+JA/woInKwySIU04VqxPRun0rukFiKoa8fuM1uViXqgPTgUbEh
	 PO0uodioGKs0vw9w6ezxMcU2T2s6SGUjG99t+aTuVP+Prj3SsLpYHO9gV5ZEO/eBwj
	 ZRcMxd/bL/lfSlBdb+BzOM1Iz7IBGBpj0Pr/a3bb55I2U0yz0W8Rbz+s8Xsv58IHaa
	 QhBcAdCve36ESDwGOmTegBULL8mhTqp915S6FIcBA5HwabAp0Z1d7gaVlIK9BdbQLF
	 fF24Rvh5urWLA==
Date: Sat, 23 May 2026 08:28:41 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/5] netfilter: conntrack: remove some code
Message-ID: <ahFJGSir1oJ5i7Fb@chamomile>
References: <20260522050140.4838-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260522050140.4838-1-fw@strlen.de>

Hi Florian,

Thanks for your series.

I have been working this week on fixing the helper infrastructure as I
told you, my series is directly clashing with this.

It's is taking me a bit of time to make sure to validate this is
correct but I can hopefully post it asap.

If you can only on with this series, I'd appreciate.

Thanks

On Fri, May 22, 2026 at 07:01:29AM +0200, Florian Westphal wrote:
> 1) Remove the full tuple from the nf_conntrack_helper hash. Switch to hashing
>    based on the helper name and L4 protocol.
> 
> 2) Remove tuple from netfilter conntrack helper definitions. Eliminate
>    redundant IPv4 and IPv6 registration requests.
> 
> 3) Switch nf_conntrack to static registration. Remove helper autoassign
>    port module params.
> 
> 4) Remove the obsolete nf_ct_helper_init API from netfilter.
> 
> 5) Add deprecation warnings for IRC and PPTP conntrack trackers. Update IRC
>    helper help text to clarify its use for DCC extension.
> 
> Florian Westphal (5):
>   netfilter: nf_conntrack_helper: do not hash by tuple
>   netfilter: conntrack: get rid of tuple in helper definitions
>   netfilter: nf_conntrack: switch to static registration
>   netfilter: remove obsolete nf_ct_helper_init api
>   netfilter: conntrack: add deprecation warnings for irc and pptp trackers
> 
>  include/net/netfilter/nf_conntrack_helper.h | 20 ++---
>  net/ipv4/netfilter/nf_nat_snmp_basic_main.c |  5 +-
>  net/netfilter/Kconfig                       | 11 +--
>  net/netfilter/nf_conntrack_amanda.c         | 35 +++-----
>  net/netfilter/nf_conntrack_broadcast.c      |  2 -
>  net/netfilter/nf_conntrack_ftp.c            | 51 +++--------
>  net/netfilter/nf_conntrack_h323_main.c      | 85 ++++++------------
>  net/netfilter/nf_conntrack_helper.c         | 96 ++++++---------------
>  net/netfilter/nf_conntrack_irc.c            | 40 ++++-----
>  net/netfilter/nf_conntrack_netbios_ns.c     |  7 +-
>  net/netfilter/nf_conntrack_pptp.c           |  7 +-
>  net/netfilter/nf_conntrack_sane.c           | 50 +++--------
>  net/netfilter/nf_conntrack_sip.c            | 61 +++++--------
>  net/netfilter/nf_conntrack_snmp.c           |  7 +-
>  net/netfilter/nf_conntrack_tftp.c           | 47 +++-------
>  net/netfilter/nfnetlink_cthelper.c          | 20 ++---
>  16 files changed, 177 insertions(+), 367 deletions(-)
> 
> -- 
> 2.53.0
> 
