From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [NETFILTER]: Move extensions' arguments into compound structure
 (1/2)
Date: Sun, 5 Oct 2008 12:19:05 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810051216090.21891@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0810031851430.13861@fbirervta.pbzchgretzou.qr> <48E8CF70.9090309@trash.net> <alpine.LNX.1.10.0810051036170.21891@fbirervta.pbzchgretzou.qr> <48E8D493.5@trash.net> <alpine.LNX.1.10.0810051054460.21891@fbirervta.pbzchgretzou.qr>
 <48E8D957.3000803@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46953 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757405AbYJEQTG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:19:06 -0400
In-Reply-To: <48E8D957.3000803@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2008-10-05 11:12, Patrick McHardy wrote:
>
> Thanks. As an added explanation - the benchmarking I did for nftables
> indicated that we're somewhere between 50 and 110 cycles for a "usual"
> rule on my x2. So its really easy to degrade performance significantly
> by just requiring a few more cycles. The upside is that it works in both
> directions :)

Hm there is actually a reason I did it this way.

I did not want to make the struct xt_match_param constant that
extensions receive, so they can tamper with the arguments just like
they were able to before. (Actually, just a single outoftree
extension does this right now.)

Constructing the xt_match_param for example in ipt_do_table() instead
of do_match() would mean that iff some extension trashed, say,
par->in, then all future extensions would get that new value, which
is of course not what we wanted.

Requesting verdict from you. :)
Make it const so that extensions don't tamper with it?
