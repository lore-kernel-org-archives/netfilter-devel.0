From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 3/8] [NETFILTER]: rename NF_ARP to NFPROTO_ARP and assign
 a non-clashing value
Date: Wed, 9 Apr 2008 17:12:09 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804091710070.3866@fbirervta.pbzchgretzou.qr>
References: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de> <2a75525ff0d60f2e71df2c9c3d040d3a76451713.1207668694.git.jengelh@computergmbh.de> <47FCBC24.4020209@trash.net> <alpine.LNX.1.10.0804091508480.4411@fbirervta.pbzchgretzou.qr>
 <47FCC0D2.7060306@trash.net> <alpine.LNX.1.10.0804091514550.4411@fbirervta.pbzchgretzou.qr> <47FCC2F4.4030901@trash.net> <alpine.LNX.1.10.0804091533010.4411@fbirervta.pbzchgretzou.qr> <47FCC7B0.6080205@trash.net> <alpine.LNX.1.10.0804091545570.4411@fbirervta.pbzchgretzou.qr>
 <47FCC9CC.4070307@trash.net> <alpine.LNX.1.10.0804091552430.4411@fbirervta.pbzchgretzou.qr> <47FCD318.1030507@trash.net> <alpine.LNX.1.10.0804091638160.3866@fbirervta.pbzchgretzou.qr> <47FCD954.5000308@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52346 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628AbYDIPMK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 11:12:10 -0400
In-Reply-To: <47FCD954.5000308@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-04-09 16:57, Patrick McHardy wrote:
>> 
>> So let's use NFPROTO_NUM, that's a name fine by me.
>
> In this case its actually not the best choice since we have
> four protocols supported by netfilter and the value will be
> something like 35. Use it if you insist, I might change it
> though :)
>
> One more thing I was thinking about. The current AF values
> we need to keep are
>
> #define AF_INET         2       /* Internet IP Protocol         */
> #define AF_ATMPVC       8       /* ATM PVCs                     */
> #define AF_INET6        10      /* IP version 6                 */

And PF_UNSPEC. And PF_BRIDGE. This is becoming fun...

Where is ATMPVC used?

> after decoupling them we don't really care about clashes
> anymore, so we might still use zero for ARP and AF_INET6
> as highest value.

I have a bad feeling about it, though.. maybe someone wants
to add a PF_LOCAL filter one day, and if NFPROTO_ARP is
exported, that'd be really bad - more than currently even.
