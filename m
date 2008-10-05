From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: RFC: net/netfilter reorganization
Date: Sun, 5 Oct 2008 19:16:55 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810051909430.3354@fbirervta.pbzchgretzou.qr>
References: <48E8E984.8090807@trash.net> <alpine.LNX.1.10.0810051221560.21891@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0810052101090.17356@blackhole.kfki.hu> <20081005.132850.34376215.davem@davemloft.net> <alpine.LNX.1.10.0810051632400.32566@fbirervta.pbzchgretzou.qr>
 <alpine.LNX.1.10.0810051641220.32566@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0810052258460.17462@blackhole.kfki.hu> <48E938F6.8080108@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	David Miller <davem@davemloft.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, sam@ravnborg.org,
	zippel@linux-m68k.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59163 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547AbYJEXQ6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 19:16:58 -0400
In-Reply-To: <48E938F6.8080108@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>> > Funny thing is, only when you try you see more problems a-coming.
>> > Like, Kconfig option names. Keep/Lose
>> > NETFILTER_XT_{MATCH,TARGET}_CONNMARK, and query users for a new one?
>>
>> Definitely yes. Kconfig is overloaded with netfilter
>> targets/matches and if matches/targets are collapsed into a single
>> file, then Kconfig options should be unified, as in your sample
>> patch.
>
> Agreed, but please keep the old options around (doing just a select
> on the new ones) for one or two releases.

Hm I just noticed a not-nice kconfig behavior.

If I have a .config with

	TARGET_CTMARK=m
	MATCH_CTMARK=m
	# BOTH_CTMARK not listed at all

and a Kconfig file with

	config TARGET_CTMARK
		tristate
		select BOTH_CTMARK
	config MATCH_CTMARK
		tristate
		select BOTH_CTMARK
	config BOTH_CTMARK
		tristate "shiny new module"

Then oldconfig will still ask me to choose [N/m] for BOTH_CTMARK. Only 
if I use

	config TARGET_CTMARK
		tristate "foo"
		select BOTH_CTMARK
	config MATCH_CTMARK
		tristate "bar"
		select BOTH_CTMARK
	config BOTH_CTMARK
		tristate "shiny new module"

i.e. add strings, it will proceed without asking me anything. Meh that's 
bad. I can think of odd workarounds like

	config TARGET_CTMARK
		tristate "shiny new module"
	config MATCH_CTMARK
		select BOTH_CTMARK
	config BOTH_CTMARK
		select TARGET_CTMARK

but that looks a bit odd. Requesting more comments.
