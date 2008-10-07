From: Roman Zippel <zippel@linux-m68k.org>
Subject: Re: RFC: net/netfilter reorganization
Date: Tue, 7 Oct 2008 13:34:41 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0810071331170.12399@localhost.localdomain>
References: <48E8E984.8090807@trash.net> <alpine.LNX.1.10.0810051221560.21891@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0810052101090.17356@blackhole.kfki.hu>
 <20081005.132850.34376215.davem@davemloft.net>
 <alpine.LNX.1.10.0810051632400.32566@fbirervta.pbzchgretzou.qr>
 <alpine.LNX.1.10.0810051641220.32566@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0810052258460.17462@blackhole.kfki.hu> <48E938F6.8080108@trash.net>
 <alpine.LNX.1.10.0810051909430.3354@fbirervta.pbzchgretzou.qr>
 <48E9E368.50901@trash.net> <alpine.LNX.1.10.0810062106260.438@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	David Miller <davem@davemloft.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, sam@ravnborg.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:1517 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbYJGLqc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Oct 2008 07:46:32 -0400
In-Reply-To: <alpine.LNX.1.10.0810062106260.438@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Mon, 6 Oct 2008, Jan Engelhardt wrote:

> Unfortunately no.
> If I use "BOTH_CTMARK depends on TARGET_CTMARK || MATCH_CTMARK", the 
> option does not show itself. Somewhat understandable.
> I also tried
> "BOTH_CTMARK default m if TARGET_CTMARK=m || MATCH_CTMARK=m", also a 
> no-go.
> 
> Seems like config options without a one-line text are considered 
> nonexistent for kconfig to begin with, so that nothing can depend or 
> default on these.

Not really. If one of these two symbols has a value different than 'n', it 
should should also select BOTH_CTMARK. I did a quick test and I still get 
the expected behaviour, so there is something else...

bye, Roman
