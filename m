From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 11/11] netfilter: xtables: convert basic nfproto match
 functions into xt matches
Date: Tue, 11 May 2010 14:59:02 +0200
Message-ID: <4BE95496.1000709@trash.net>
References: <1272880297-11198-1-git-send-email-jengelh@medozas.de> <1272880297-11198-12-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39025 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665Ab0EKM7F (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 May 2010 08:59:05 -0400
In-Reply-To: <1272880297-11198-12-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Each table implementation has a private built-in hardwired match
> function for its corresponding nfproto data (e.g. ip_tables: struct
> ipt6_ip6 processed by ip6_packet_match to match against the IPv6
> header, etc.)
> 
> Rewrite the functions so that they are independent xt_matches and can
> be used from an nfproto-independent table.

No major objections, but I'd like to know where this is going
and when, so far this doesn't provide any benefit.

And as always, please format things like

> +	ret = ifname_compare_aligned((par->in == NULL) ? nulldevname :
> +	      par->in->name, ipinfo->iniface, ipinfo->iniface_mask);

so the arguments are neatly aligned. F.i.

	ret = ifname_compare_aligned(!par->in ? nulldevname : par->in->name,
				     ipinfo->iniface, ipinfo->iniface_mask);

would work nicely.
