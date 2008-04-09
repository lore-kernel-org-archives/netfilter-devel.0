From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 3/8] [NETFILTER]: rename NF_ARP to NFPROTO_ARP and assign
 a non-clashing value
Date: Wed, 9 Apr 2008 18:31:12 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804091819380.3866@fbirervta.pbzchgretzou.qr>
References: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de> <2a75525ff0d60f2e71df2c9c3d040d3a76451713.1207668694.git.jengelh@computergmbh.de> <47FCBC24.4020209@trash.net> <alpine.LNX.1.10.0804091508480.4411@fbirervta.pbzchgretzou.qr>
 <47FCC0D2.7060306@trash.net> <alpine.LNX.1.10.0804091514550.4411@fbirervta.pbzchgretzou.qr> <47FCC2F4.4030901@trash.net> <alpine.LNX.1.10.0804091533010.4411@fbirervta.pbzchgretzou.qr> <47FCC7B0.6080205@trash.net> <alpine.LNX.1.10.0804091545570.4411@fbirervta.pbzchgretzou.qr>
 <47FCC9CC.4070307@trash.net> <alpine.LNX.1.10.0804091552430.4411@fbirervta.pbzchgretzou.qr> <47FCD318.1030507@trash.net> <alpine.LNX.1.10.0804091638160.3866@fbirervta.pbzchgretzou.qr> <47FCD954.5000308@trash.net> <alpine.LNX.1.10.0804091710070.3866@fbirervta.pbzchgretzou.qr>
 <47FCDD9D.7050905@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35893 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbYDIQbO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 12:31:14 -0400
In-Reply-To: <47FCDD9D.7050905@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-04-09 17:15, Patrick McHardy wrote:
>>>
>>> #define AF_INET         2       /* Internet IP Protocol         */
>>> #define AF_ATMPVC       8       /* ATM PVCs                     */
>>> #define AF_INET6        10      /* IP version 6                 */
#define AF_BLUETOOTH	31
>> 
>>> after decoupling them we don't really care about clashes
>>> anymore, so we might still use zero for ARP and AF_INET6
>>> as highest value.
>> 
>> I have a bad feeling about it, though.. maybe someone wants
>> to add a PF_LOCAL filter one day, and if NFPROTO_ARP is
>> exported, that'd be really bad - more than currently even.
>
> PF_LOCAL? And why would it matter, if we decouple the
> values they simply have nothing in common anymore except
> the a few old values for compatibility (IP,IP6,BRIDGE).

Are you suggesting to split the AF and NFPROTO list?
(Took me quite some time..)

A few concerns.
If so, how would you deal with the addition of a new, real,
protocol? Suppose someone added support for the
semifictional IPv5, say  AF_INET5=42 or so. How would
this affect the NFPROTO list?
