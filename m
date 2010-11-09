From: Frederic Leroy <fredo@starox.org>
Subject: Re: [arptables] rfc: add classify target
Date: Tue, 9 Nov 2010 17:10:47 +0100
Message-ID: <20101109161047.GB25549@sd-11162.dedibox.fr>
References: <20101107152636.56f62235@caresse>
 <alpine.LNX.2.01.1011071616150.21289@obet.zrqbmnf.qr>
 <4CD959D6.1090705@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sd-11162.dedibox.fr ([88.191.70.230]:60953 "EHLO
	sd-11162.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0KIQT4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:19:56 -0500
Content-Disposition: inline
In-Reply-To: <4CD959D6.1090705@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 09, 2010 at 03:25:26PM +0100, Patrick McHardy wrote:
> Am 07.11.2010 16:18, schrieb Jan Engelhardt:
> > On Sunday 2010-11-07 15:26, Frederic Leroy wrote:
> Actually we already register for NFPROTO_UNSPEC, so simply
> adding a userspace extension should do the job.

Not really, the mangle table for arp seems to be inexistnet.
And hacking and using the filter table  I got arptables complaining abo=
ut
chain INPUT missing although the command line with -A OUTPUT.

It seems there need a big work on arptables userspace side.

--=20
=46r=E9d=E9ric Leroy
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
