From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: don't track ICMPv6 negotiation message.
Date: Tue, 27 Jan 2009 15:57:08 +0100
Message-ID: <497F20C4.3090606@trash.net>
References: <200901271007.n0RA78k6023294@toshiba.co.jp> <1233053715-30398-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: yasuyuki.kozakai@toshiba.co.jp, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39704 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbZA0O5N (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Jan 2009 09:57:13 -0500
In-Reply-To: <1233053715-30398-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch removes connection tracking handling for ICMPv6 messages
> related to Stateless Address Autoconfiguration, MLD, and MLDv2. They
> can not be tracked because they are massively using multicast (on
> pre-defined address). But they are not invalid and should not be
> detected as such.

Applied, thanks Eric.

> +	type = icmp6h->icmp6_type - 130;
> +	if (type >= 0 && type < sizeof(noct_valid_new)
> +	    && noct_valid_new[type]) {

I've made a small cosmetic change here and moved the && to the
first line. I'm slowly trying to get rid of the inconsistent
operator placement whenever we touch some code.

