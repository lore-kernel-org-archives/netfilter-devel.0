From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] netfilter: add per-namespace logging to nfnetlink_log.c
Date: Mon, 18 Jul 2011 22:27:27 +0200
Message-ID: <1311020847.16961.8.camel@edumazet-laptop>
References: <8739i3fp6s.fsf@sapphire.mobileactivedefense.com>
	 <20110718191956.GA2489@p183.telecom.by>
	 <87hb6je5nh.fsf@sapphire.mobileactivedefense.com>
	 <20110718.124638.30010338187296272.davem@davemloft.net>
	 <87d3h7e43n.fsf@sapphire.mobileactivedefense.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: David Miller <davem@davemloft.net>, adobriyan@gmail.com,
	kaber@trash.net, netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Rainer Weikusat <rweikusat@mobileactivedefense.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51195 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab1GRU1c (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jul 2011 16:27:32 -0400
In-Reply-To: <87d3h7e43n.fsf@sapphire.mobileactivedefense.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le lundi 18 juillet 2011 =C3=A0 21:17 +0100, Rainer Weikusat a =C3=A9cr=
it :

> Adding new files filled with ifdefs in order to avoid ifdefs in old
> files in favor of lines-looking-like-code-which-arent seems
> debatable to me. The same goes for adding unused structure members,
> uneeded function calls, indirections through fifteen different other
> files that turn out to do nothing etc. I spend much more time trying
> to read Linux code than to write Linux code and while I decidedly kno=
w
> worse things, Linux isn't exactly a prime example of easily accessibl=
e
> code precisely because so much of it is something completely differen=
t
> than what it appears to be.

Its true of any large piece of software. A new comer have to read
thousand of lines before even adding a single line.

Note that namespace code was added recently and we tried to use ifdefs
only in include files. You can find only few exceptions to this rule.



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
