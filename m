From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [resend net-next] socket: Added 'transparent' option
Date: Thu, 4 Jun 2009 18:03:55 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0906041759320.20094@fbirervta.pbzchgretzou.qr>
References: <1244122013-25970-1-git-send-email-panther@balabit.hu> <4A27CD5A.6040303@trash.net> <alpine.LSU.2.00.0906041653420.13894@fbirervta.pbzchgretzou.qr> <4A27E7F0.6010403@balabit.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Laszlo Attila Toth <panther@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52001 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbZFDQDx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jun 2009 12:03:53 -0400
In-Reply-To: <4A27E7F0.6010403@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-06-04 17:27, Laszlo Attila Toth wrote:
>
> I'm also working on a newer revision of the limit match, which is almost done.
> It can be inverted (! --limit ...).

Take a look at hashlimit, where for the userspace interaction, the
use of ambiguous negations is avoided: --hashlimit-above /
--hashlimit-below; only behind the curtain is it encoded into a
negation. I wish that this logic be kept for future developments.

>I think in this case a bitfield can be
> used, but it is probably not necessary, the following extra member is enogh:
>
> 	u_int32_t invert;

That is pretty large for a single inversion. Again, make it a "flags"
variable, maybe there will be more flags in future, who knows.

Also, if possible, try combining all the TBF implementations; limit
and hashlimit are so close to each other, the latter would only need
a "--hashlimit-mode notuple" (from a userspace pov) , and xt_limit
could be obsoleted.
Furthermore, we have xt_rateest now, so is the work on the TBF
limiters really justified?
