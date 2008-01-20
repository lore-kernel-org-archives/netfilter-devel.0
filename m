From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 1/4] [NETFILTER]: ebtables: expand/remove unneeded macros
Date: Sun, 20 Jan 2008 18:34:40 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801201815160.14598@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801172110060.18447@fbirervta.pbzchgretzou.qr>
 <47934659.50303@trash.net>  <Pine.LNX.4.64.0801201407280.14598@fbirervta.pbzchgretzou.qr>
  <479349D3.6050103@trash.net> <1200839199.2868.25.camel@localhost.localdomain>
 <47935E7A.1000908@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Bart De Schuymer <bdschuym@pandora.be>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56962 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbYATRel (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 12:34:41 -0500
In-Reply-To: <47935E7A.1000908@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 20 2008 15:45, Patrick McHardy wrote:
> Bart De Schuymer wrote:
>> Op zo, 20-01-2008 te 14:17 +0100, schreef Patrick McHardy:
>>
>> > Thanks. Bart, please let me know if you have any objections or
>> > want to add a Signed-off-by: line.
>> 
>> Hi, thanks for putting me in CC. If you remove the EBT_*_ macros from
>> ebtables.h this will break the ebtables userspace compilation.

"Ugh." I do not think ebtables(8) should depend on such macros.
iptables(8) does not do that either.
What good would those macros be for? It is not like the module names
would be changing anyway (one purpose of macros - to reduce the number
of places where you have to change things iff things change).

>> For the
>> other patches I have no objection except that the MODULE_DESCRIPTION
>> isn't consistent with using upper case after 'Ebtables: ', but I guess
>> that's nitpicking :) Anyway, thanks Jan.

It is consistent...

18:17 ichi:~/Coding/linux_nosov > git log -p
4ad299b1644579e5c9aae025bf81f6aff1cbdc77^..4ad299b1644579e5c9aae025bf81f6aff1cbdc77
| grep MODULE_DESC | grep ^+

+MODULE_DESCRIPTION("Ebtables: DSAP/SSAP field and SNAP type matching");
+MODULE_DESCRIPTION("Ebtables: Combined MAC/IP address list matching");
+MODULE_DESCRIPTION("Ebtables: ARP protocol packet match");
+MODULE_DESCRIPTION("Ebtables: ARP reply target");
+MODULE_DESCRIPTION("Ebtables: Destination MAC address translation");
+MODULE_DESCRIPTION("Ebtables: IPv4 protocol packet match");
+MODULE_DESCRIPTION("Ebtables: rate-limit match");
+MODULE_DESCRIPTION("Ebtables: Packet logging to syslog");
+MODULE_DESCRIPTION("Ebtables: packet mark modification");
+MODULE_DESCRIPTION("Ebtables: packet mark match");
+MODULE_DESCRIPTION("Ebtables: link layer packet type match");
+MODULE_DESCRIPTION("Ebtables: Packet redirection to localhost");
+MODULE_DESCRIPTION("Ebtables: Source MAC address translation");
+MODULE_DESCRIPTION("Ebtables: Spanning Tree Protocol packet match");
+MODULE_DESCRIPTION("Ebtables: packet logging to netlink using ULOG");
+MODULE_DESCRIPTION("Ebtables: 802.1Q VLAN tag match");

Did I miss something?


> Yes, for br_netfilter.c this makes sense I guess. For ebtables I'm
> not sure - I have no problem reviewing and applying kernel patches,
> but I'm lacking the time for taking care of userspace as well, at
> least for doing it alone.

/noticing that I do most userspace stuff ATM ;-D

> But since ebtables, arptables and iptables
> are pretty similar, perhaps it would be possible to merge ebtables
> and arptables support with iptables.

Before you attempt that, try merging ip- with ip6tables first.

> It would certainly make sense,
> but I expect it to be quite a lot of work. Well, anyways, for now
> I guess we'll just have to continue as usual :)
>
Continue as usual. Statistically, developers show up every now and
then and over time, enough 'small' patches will have accumulated so
that the merger is just one more 'small' operation away.
