From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] netfilter: remove modulo operations
Date: Sun, 24 Oct 2010 21:11:51 +0200
Message-ID: <1287947511.2658.1678.camel@edumazet-laptop>
References: <1287891635-30207-1-git-send-email-xiaosuo@gmail.com>
	 <20101024182508.GM15247@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Changli Gao <xiaosuo@gmail.com>, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50228 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab0JXTMA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Oct 2010 15:12:00 -0400
Received: by wyf28 with SMTP id 28so2625937wyf.19
        for <netfilter-devel@vger.kernel.org>; Sun, 24 Oct 2010 12:11:59 -0700 (PDT)
In-Reply-To: <20101024182508.GM15247@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le dimanche 24 octobre 2010 =C3=A0 20:25 +0200, Florian Westphal a =C3=A9=
crit :

> I'd imagine that the result of ((hash * total) >> 32) is (almost)
> always zero, especially if total is small (which it is usually).
>=20

Absolutely not. total is a 32bit number, using full range.

> Did you test that this change does not affect distribution average?

That would be shocking actually, given we use jhash()

I did same tricks in various parts of network stack in the past, and it=
s
fine.



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
