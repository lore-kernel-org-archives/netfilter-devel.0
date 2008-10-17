From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: RFC: net/netfilter reorganization
Date: Fri, 17 Oct 2008 10:53:31 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810171051160.30268@fbirervta.pbzchgretzou.qr>
References: <48E8E984.8090807@trash.net> <alpine.LNX.1.10.0810051221560.21891@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0810052101090.17356@blackhole.kfki.hu> <20081005.132850.34376215.davem@davemloft.net> <alpine.LNX.1.10.0810051632400.32566@fbirervta.pbzchgretzou.qr>
 <alpine.LNX.1.10.0810051641220.32566@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0810052258460.17462@blackhole.kfki.hu> <48E938F6.8080108@trash.net> <alpine.LNX.1.10.0810051909430.3354@fbirervta.pbzchgretzou.qr> <48E9E368.50901@trash.net>
 <alpine.LNX.1.10.0810062106260.438@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0810071331170.12399@localhost.localdomain> <alpine.LNX.1.10.0810071129180.23228@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0810071856010.12399@localhost.localdomain>
 <alpine.LNX.1.10.0810071343290.23228@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0810132042170.12399@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	David Miller <davem@davemloft.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, sam@ravnborg.org
To: Roman Zippel <zippel@linux-m68k.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43482 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668AbYJQOxd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Oct 2008 10:53:33 -0400
In-Reply-To: <Pine.LNX.4.64.0810132042170.12399@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-10-13 14:52, Roman Zippel wrote:
>On Tue, 7 Oct 2008, Jan Engelhardt wrote:
>
>> We are trying to combine TARGET_CONNMARK and MATCH_CONNMARK into a
>> new option, and doing so without showing {TARGET,MATCH}, yet
>> selecting BOTH_CONNMARK when either of {TARGET,MATCH} was previously
>> selected (e.g=C2=A0by feeding oldconfig something that has these opt=
ions
>> active).
>
>Try the patch below, you can define an alias (e.g. add "option=20
>alias=3DTARGET_CONNMARK" to BOTH_CONNMARK) and kconfig will use the al=
ias=20
>while reading the .config file (unless there is already a value for it=
).
>Previously .config data was only used as a preset for user prompts, fo=
r=20
>any other derived symbol it's ignored.
>If it does what you need, I can get it merged as quickly as possible=20
>after adding a bit of documentation. I maybe also give it another name=
, as=20
>"alias" is a little general and it's not a generally usable alias.

Nope, does not quite do.. it seems it cannot use more than one:

config BOTH
	option alias=3DTARGET
	option alias=3DMATCH

Given a .config with TARGET=3Dn, MATCH=3Dm, I will get BOTH=3Dn when
running oldconfig.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
