From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/8] [NETFILTER]: rename NF_ARP to NFPROTO_ARP and assign
 a non-clashing value
Date: Wed, 09 Apr 2008 18:35:19 +0200
Message-ID: <47FCF047.3000202@trash.net>
References: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de> <2a75525ff0d60f2e71df2c9c3d040d3a76451713.1207668694.git.jengelh@computergmbh.de> <47FCBC24.4020209@trash.net> <alpine.LNX.1.10.0804091508480.4411@fbirervta.pbzchgretzou.qr> <47FCC0D2.7060306@trash.net> <alpine.LNX.1.10.0804091514550.4411@fbirervta.pbzchgretzou.qr> <47FCC2F4.4030901@trash.net> <alpine.LNX.1.10.0804091533010.4411@fbirervta.pbzchgretzou.qr> <47FCC7B0.6080205@trash.net> <alpine.LNX.1.10.0804091545570.4411@fbirervta.pbzchgretzou.qr> <47FCC9CC.4070307@trash.net> <alpine.LNX.1.10.0804091552430.4411@fbirervta.pbzchgretzou.qr> <47FCD318.1030507@trash.net> <alpine.LNX.1.10.0804091638160.3866@fbirervta.pbzchgretzou.qr> <47FCD954.5000308@trash.net> <alpine.LNX.1.10.0804091710070.3866@fbirerv
 ta.pbzchgretzou.qr> <47FCDD9D.7050905@trash.net> <alpine.LNX.1.10.0804091819380.3866@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52659 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbYDIQfW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 12:35:22 -0400
In-Reply-To: <alpine.LNX.1.10.0804091819380.3866@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2008-04-09 17:15, Patrick McHardy wrote:
>>>> #define AF_INET         2       /* Internet IP Protocol         */
>>>> #define AF_ATMPVC       8       /* ATM PVCs                     */
>>>> #define AF_INET6        10      /* IP version 6                 */
> #define AF_BLUETOOTH	31
>>>> after decoupling them we don't really care about clashes
>>>> anymore, so we might still use zero for ARP and AF_INET6
>>>> as highest value.
>>> I have a bad feeling about it, though.. maybe someone wants
>>> to add a PF_LOCAL filter one day, and if NFPROTO_ARP is
>>> exported, that'd be really bad - more than currently even.
>> PF_LOCAL? And why would it matter, if we decouple the
>> values they simply have nothing in common anymore except
>> the a few old values for compatibility (IP,IP6,BRIDGE).
> 
> Are you suggesting to split the AF and NFPROTO list?
> (Took me quite some time..)

Yes.

> A few concerns.
> If so, how would you deal with the addition of a new, real,
> protocol? Suppose someone added support for the
> semifictional IPv5, say  AF_INET5=42 or so. How would
> this affect the NFPROTO list?

It wouldn't since those values simply have seperate
meanings. AF_INET5 might be 42, NFPROTO_INET5 could
be .. lets say 5.



