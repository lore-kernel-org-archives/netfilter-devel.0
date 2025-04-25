Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB66E1DB127
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Apr 2025 09:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745571715; cv=none; b=WJAdJqDn2byPAkDCxXMwnMpyXLgD56LsVcGWfQe6YTDHgpn6XofqB5VxfXe0SZDvjG+5oT/DzaCMXJeL0KUe7HbAKF5b5YPifr6Ob4n89V7gfHh1lqNmB1FntSmbEMmgZN0Ok0V4URvbuNHjb1nHq/eFZAyaltnlIusDLZRk3HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745571715; c=relaxed/simple;
	bh=veKiDl+AwIy545lnlPcUbY+e5JuIiZv+fdwkENzbQpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MUvOmmdnzoADrMScjnhhWpB+VEfhjqouwHpCFNokpGyuzss/MVq6EpSJag3eefkrUoBsLAsA/i9eW3fvOm31WMUUL8UmfA0WHatp7iexy72G5xRbvCnz+I5vANx1UnNPSFGnPrnK+HqZrgjr5qztAndULqnne0WhyQHzLjJpyt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=O5c1DiJ4; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IzarHWjd; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="O5c1DiJ4";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IzarHWjd"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 943D860728; Fri, 25 Apr 2025 11:01:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745571707;
	bh=85A7cepw8FA1KhW1+speDOe9ALrCa7Gr9fMm25+vGF8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O5c1DiJ4/SeKQ5V2unL4HXK2JKw6Ac17NL0lC/fRXh7QoMNJT5uPaeR2FFwIHfbZb
	 Zv14/HEcnWcKfg0Rd/izNmQTL/Fcd2cqbVp58R7EtlNalsh6mHRElr7GFr+OXgJRpg
	 jhLvulwpKk+3SEOXBSXjhDFDwHu00RZBuTe3vvaGhvtpAosXoHF6wsPP95eAW2QqAU
	 rDFlpZyRl+MBR6Q/GBB4n6YRv7+J8XTYk20QvADY8C5pQ9kDfr/tiPvzwlRy6TuxGR
	 O6pO2gOEvCw8hHLwwCamRbEisX03lS8JqKl34yNXEjVrqz8OokVw95747Hfnr/Tb68
	 pDFXYe7r6LtNQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 88FD660710;
	Fri, 25 Apr 2025 11:01:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745571706;
	bh=85A7cepw8FA1KhW1+speDOe9ALrCa7Gr9fMm25+vGF8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IzarHWjd7WtBs6yPdjIMFOlbQaiharOei0RoA7FPtz39vgYBguOw/SEWFWe1pPqQ0
	 Tq60xBQFB1ZzQHTpwd18C2viwOK28k0qmMehsSyUuNgp1ae+WqqtXIFQWwLQwmawcx
	 TarCmzk3mu0TJQH1fYapsT/YqdLzJOmE8aDomzXvZ3TnrNtE6M4dY7oNwn9noU/qZb
	 gAWS0wRmjoW6DBGgW1QQToEgiD09HT/WiCh+ojBCq3FhYiOKzQLRy5nTW1z5cU8jOC
	 Y4Utoslfd1pgFBf4LNQOHOhf+6rHloo4b7poZ0y03aqk5yIBu/y2yuGjxtxcSdH0aM
	 7b9laKOqQRgHw==
Date: Fri, 25 Apr 2025 11:01:43 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: shankerwangmiao@gmail.com
Cc: netfilter-devel@vger.kernel.org, phil@nwl.cc
Subject: Re: [PATCH iptables] extensions: libebt_redirect: prevent translation
Message-ID: <aAtPd3QF-2v8TNCe@calendula>
References: <20250425-xlat-ebt-redir-v1-1-3e11a5925569@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250425-xlat-ebt-redir-v1-1-3e11a5925569@gmail.com>

On Fri, Apr 25, 2025 at 04:44:24PM +0800, Miao Wang via B4 Relay wrote:
> From: Miao Wang <shankerwangmiao@gmail.com>
> 
> The redirect target in ebtables do two things: 1. set skb->pkt_type to
> PACKET_HOST, and 2. set the destination mac address to the address of
> the receiving bridge device (when not used in BROUTING chain), or the
> receiving physical device (otherwise). However, the later cannot be
> implemented in nftables not given the translated mac address. So it is
> not appropriate to give a specious translation.
> 
> This patch adds xt target redirect to the translated nft rule, to ensure
> it cannot be later loaded by nft, to prevent possible misunderstanding.
> 
> Fixes: 24ce7465056ae ("ebtables-compat: add redirect match extension")
> Signed-off-by: Miao Wang <shankerwangmiao@gmail.com>
> ---
>  extensions/libebt_redirect.c      | 2 +-
>  extensions/libebt_redirect.txlate | 6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/extensions/libebt_redirect.c b/extensions/libebt_redirect.c
> index a44dbaec6cc8b12f20acd31dcb1360ac7245e349..83d2b576cea5ae625f3bdf667ad56fc57c1665d9 100644
> --- a/extensions/libebt_redirect.c
> +++ b/extensions/libebt_redirect.c
> @@ -77,7 +77,7 @@ static int brredir_xlate(struct xt_xlate *xl,
>  {
>  	const struct ebt_redirect_info *red = (const void*)params->target->data;
>  
> -	xt_xlate_add(xl, "meta pkttype set host");
> +	xt_xlate_add(xl, "meta pkttype set host xt target redirect");
>  	if (red->target != EBT_CONTINUE)
>  		xt_xlate_add(xl, " %s ", brredir_verdict(red->target));
>  	return 1;
> diff --git a/extensions/libebt_redirect.txlate b/extensions/libebt_redirect.txlate
> index d073ec774c4fa817e48422fb99aaf095dd9eab65..abafd8d15aef8349d29ad812a03f0ebeeaea118c 100644
> --- a/extensions/libebt_redirect.txlate
> +++ b/extensions/libebt_redirect.txlate
> @@ -1,8 +1,8 @@
>  ebtables-translate -t nat -A PREROUTING -d de:ad:00:00:be:ef -j redirect
> -nft 'add rule bridge nat PREROUTING ether daddr de:ad:00:00:be:ef counter meta pkttype set host accept'
> +nft 'add rule bridge nat PREROUTING ether daddr de:ad:00:00:be:ef counter meta pkttype set host xt target redirect accept'

this is not a working translation, I don't think this is leaving this
in a better situation than before.

>  ebtables-translate -t nat -A PREROUTING -d de:ad:00:00:be:ef -j redirect --redirect-target RETURN
> -nft 'add rule bridge nat PREROUTING ether daddr de:ad:00:00:be:ef counter meta pkttype set host return'
> +nft 'add rule bridge nat PREROUTING ether daddr de:ad:00:00:be:ef counter meta pkttype set host xt target redirect return'
>  
>  ebtables-translate -t nat -A PREROUTING -d de:ad:00:00:be:ef -j redirect --redirect-target CONTINUE
> -nft 'add rule bridge nat PREROUTING ether daddr de:ad:00:00:be:ef counter meta pkttype set host'
> +nft 'add rule bridge nat PREROUTING ether daddr de:ad:00:00:be:ef counter meta pkttype set host xt target redirect'
> 
> ---
> base-commit: 192c3a6bc18f206895ec5e38812d648ccfe7e281
> change-id: 20250425-xlat-ebt-redir-aa40928f6fae
> 
> Best regards,
> -- 
> Miao Wang <shankerwangmiao@gmail.com>
> 
> 
> 
