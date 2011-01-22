From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] Incorrect xt_iprange boundary check for IPv6
Date: Sat, 22 Jan 2011 15:53:24 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1101221551470.31929@obet.zrqbmnf.qr>
References: <1295705432-2588-1-git-send-email-jacob@internet24.de> <1295705432-2588-2-git-send-email-jacob@internet24.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jacob <jacob@internet24.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40290 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331Ab1AVOxZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 22 Jan 2011 09:53:25 -0500
In-Reply-To: <1295705432-2588-2-git-send-email-jacob@internet24.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2011-01-22 15:10, Thomas Jacob wrote:

>iprange_ipv6_sub was substracting 2 unsigned ints and then casting
>the result to int to find out whether they are lt, eq or gt each
>other, this doesn't work if the full 32 bits of each part
>can be used in IPv6 addresses. Patch should remedy that without
>significant performance penalties.

Correctness before speed ;)

The algo change looks ok to me, thanks for spotting.

> static inline int
>-iprange_ipv6_sub(const struct in6_addr *a, const struct in6_addr *b)
>+iprange_ipv6_lt(const struct in6_addr *a, const struct in6_addr *b)
> {
> 	unsigned int i;
>-	int r;
> 
> 	for (i = 0; i < 4; ++i) {
>-		r = ntohl(a->s6_addr32[i]) - ntohl(b->s6_addr32[i]);
>-		if (r != 0)
>-			return r;
>+		if(ntohl(a->s6_addr32[i]) != ntohl(b->s6_addr32[i]))
>+			return ntohl(a->s6_addr32[i]) < ntohl(b->s6_addr32[i]);
> 	}
> 
> 	return 0;
