From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: RFC: net/netfilter reorganization
Date: Tue, 7 Oct 2008 13:44:51 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810071343290.23228@fbirervta.pbzchgretzou.qr>
References: <48E8E984.8090807@trash.net> <alpine.LNX.1.10.0810051221560.21891@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0810052101090.17356@blackhole.kfki.hu> <20081005.132850.34376215.davem@davemloft.net> <alpine.LNX.1.10.0810051632400.32566@fbirervta.pbzchgretzou.qr>
 <alpine.LNX.1.10.0810051641220.32566@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0810052258460.17462@blackhole.kfki.hu> <48E938F6.8080108@trash.net> <alpine.LNX.1.10.0810051909430.3354@fbirervta.pbzchgretzou.qr> <48E9E368.50901@trash.net>
 <alpine.LNX.1.10.0810062106260.438@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0810071331170.12399@localhost.localdomain> <alpine.LNX.1.10.0810071129180.23228@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0810071856010.12399@localhost.localdomain>
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
Received: from sovereign.computergmbh.de ([85.214.69.204]:56159 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbYJGRox (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Oct 2008 13:44:53 -0400
In-Reply-To: <Pine.LNX.4.64.0810071856010.12399@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-10-07 13:09, Roman Zippel wrote:

>>  config NETFILTER_XT_TARGET_CONNMARK
>> -       tristate  '"CONNMARK" target support'
>> +       tristate
>>         depends on NF_CONNTRACK
>>         depends on NETFILTER_ADVANCED
>>         select NF_CONNTRACK_MARK
>>=20
>> nukes TARGET_CONNMARK from .config - as in, there is not even a
>> "# TARGET_CONNMARK is unset" line.
>
>That's correct, as it doesn't get any value (either from a default or =
a=20
>select). If it has a value, it will be used to select other symbols.
>
>> As such I can understand why adding a "select ELSE" for TARGET_CONNM=
ARK
>> won't work.
>
>I don't quite understand what you're trying to do. :)

We are trying to combine TARGET_CONNMARK and MATCH_CONNMARK into a
new option, and doing so without showing {TARGET,MATCH}, yet
selecting BOTH_CONNMARK when either of {TARGET,MATCH} was previously
selected (e.g=C2=A0by feeding oldconfig something that has these option=
s
active).
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
