From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: net/netfilter reorganization
Date: Mon, 06 Oct 2008 12:07:36 +0200
Message-ID: <48E9E368.50901@trash.net>
References: <48E8E984.8090807@trash.net> <alpine.LNX.1.10.0810051221560.21891@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0810052101090.17356@blackhole.kfki.hu> <20081005.132850.34376215.davem@davemloft.net> <alpine.LNX.1.10.0810051632400.32566@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0810051641220.32566@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0810052258460.17462@blackhole.kfki.hu> <48E938F6.8080108@trash.net> <alpine.LNX.1.10.0810051909430.3354@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	David Miller <davem@davemloft.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, sam@ravnborg.org,
	zippel@linux-m68k.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36173 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbYJFKHo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 06:07:44 -0400
In-Reply-To: <alpine.LNX.1.10.0810051909430.3354@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Hm I just noticed a not-nice kconfig behavior.
> 
> If I have a .config with
> 
> 	TARGET_CTMARK=m
> 	MATCH_CTMARK=m
> 	# BOTH_CTMARK not listed at all
> 
> and a Kconfig file with
> 
> 	config TARGET_CTMARK
> 		tristate
> 		select BOTH_CTMARK
> 	config MATCH_CTMARK
> 		tristate
> 		select BOTH_CTMARK
> 	config BOTH_CTMARK
> 		tristate "shiny new module"
> 
> Then oldconfig will still ask me to choose [N/m] for BOTH_CTMARK. Only 
> if I use
> 
> 	config TARGET_CTMARK
> 		tristate "foo"
> 		select BOTH_CTMARK
> 	config MATCH_CTMARK
> 		tristate "bar"
> 		select BOTH_CTMARK
> 	config BOTH_CTMARK
> 		tristate "shiny new module"
> 
> i.e. add strings, it will proceed without asking me anything. Meh that's 
> bad. I can think of odd workarounds like
> 
> 	config TARGET_CTMARK
> 		tristate "shiny new module"
> 	config MATCH_CTMARK
> 		select BOTH_CTMARK
> 	config BOTH_CTMARK
> 		select TARGET_CTMARK
> 
> but that looks a bit odd. Requesting more comments.

That should be fine though since the old options already exist
(in most cases)?

BTW, does it make any difference if you add a dependency
on TARGET_CTMARK || MATCH_CTMARK?

