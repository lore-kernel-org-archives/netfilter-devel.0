From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: RFC: net/netfilter reorganization
Date: Mon, 6 Oct 2008 21:08:20 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810062106260.438@fbirervta.pbzchgretzou.qr>
References: <48E8E984.8090807@trash.net> <alpine.LNX.1.10.0810051221560.21891@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0810052101090.17356@blackhole.kfki.hu> <20081005.132850.34376215.davem@davemloft.net> <alpine.LNX.1.10.0810051632400.32566@fbirervta.pbzchgretzou.qr>
 <alpine.LNX.1.10.0810051641220.32566@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0810052258460.17462@blackhole.kfki.hu> <48E938F6.8080108@trash.net> <alpine.LNX.1.10.0810051909430.3354@fbirervta.pbzchgretzou.qr> <48E9E368.50901@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	David Miller <davem@davemloft.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, sam@ravnborg.org,
	zippel@linux-m68k.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50163 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757356AbYJGBIW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 21:08:22 -0400
In-Reply-To: <48E9E368.50901@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-10-06 06:07, Patrick McHardy wrote:
>>[troubles with Kconfig syntaxe about BOTH_CTMARK]
>
> That should be fine though since the old options already exist
> (in most cases)?
>
> BTW, does it make any difference if you add a dependency
> on TARGET_CTMARK || MATCH_CTMARK?

Unfortunately no.
If I use "BOTH_CTMARK depends on TARGET_CTMARK || MATCH_CTMARK", the 
option does not show itself. Somewhat understandable.
I also tried
"BOTH_CTMARK default m if TARGET_CTMARK=m || MATCH_CTMARK=m", also a 
no-go.

Seems like config options without a one-line text are considered 
nonexistent for kconfig to begin with, so that nothing can depend or 
default on these.
