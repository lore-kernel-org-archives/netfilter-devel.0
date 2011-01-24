From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] Incorrect xt_iprange boundary check for IPv6
Date: Mon, 24 Jan 2011 13:38:27 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1101241329330.24098@obet.zrqbmnf.qr>
References: <1295705432-2588-1-git-send-email-jacob@internet24.de>  <1295705432-2588-2-git-send-email-jacob@internet24.de>  <alpine.DEB.2.00.1101231446550.13261@blackhole.kfki.hu> <1295868671.15034.15.camel@enterprise.ims-firmen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org
To: Thomas Jacob <jacob@internet24.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47174 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861Ab1AXMi2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Jan 2011 07:38:28 -0500
In-Reply-To: <1295868671.15034.15.camel@enterprise.ims-firmen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2011-01-24 12:31, Thomas Jacob wrote:
>
>if (info->flags & IPRANGE_SRC) {
>  m  = iprange_ipv6_lt(&iph->saddr, &info->src_min.in6);
>  m |= iprange_ipv6_lt(&info->src_max.in6, &iph->saddr);
>  m ^= !!(info->flags & IPRANGE_SRC_INV);
>  if (m)
>    return false;
>}
>
>Shouldn't this be  m ||= ..

C does not have a ||= operator. This is not Perl.
Which is why either you make sure iprange_ipv6_lt returns a bool,
or force one by means of !!.

>to allow for some short circuit optimizations?

Since there is no ||=, it would be

m = iprange_ipv6_lt(&iph->saddr, &info->src_min.in6);
if (!m)
	m = iprange_ipv6_lt(&info->src_max.in6, &iph->saddr);
