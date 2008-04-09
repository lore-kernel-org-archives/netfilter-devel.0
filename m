From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/8] [NETFILTER]: rename NF_ARP to NFPROTO_ARP and assign
 a non-clashing value
Date: Wed, 09 Apr 2008 16:57:24 +0200
Message-ID: <47FCD954.5000308@trash.net>
References: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de> <2a75525ff0d60f2e71df2c9c3d040d3a76451713.1207668694.git.jengelh@computergmbh.de> <47FCBC24.4020209@trash.net> <alpine.LNX.1.10.0804091508480.4411@fbirervta.pbzchgretzou.qr> <47FCC0D2.7060306@trash.net> <alpine.LNX.1.10.0804091514550.4411@fbirervta.pbzchgretzou.qr> <47FCC2F4.4030901@trash.net> <alpine.LNX.1.10.0804091533010.4411@fbirervta.pbzchgretzou.qr> <47FCC7B0.6080205@trash.net> <alpine.LNX.1.10.0804091545570.4411@fbirervta.pbzchgretzou.qr> <47FCC9CC.4070307@trash.net> <alpine.LNX.1.10.0804091552430.4411@fbirervta.pbzchgretzou.qr> <47FCD318.1030507@trash.net> <alpine.LNX.1.10.0804091638160.3866@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49769 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbYDIO50 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 10:57:26 -0400
In-Reply-To: <alpine.LNX.1.10.0804091638160.3866@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2008-04-09 16:30, Patrick McHardy wrote:
>> Well, I'm sick of this discussion. MAX is the highest value,
>> NUM is the number of items. I'm aware that people seem to
>> have problems understanding this, but that is no reason
>> to further the confusion.
>>
>> BTW, these values *do* need to be exported to userspace
>> for nfnetlink.
> 
> So let's use NFPROTO_NUM, that's a name fine by me.

In this case its actually not the best choice since we have
four protocols supported by netfilter and the value will be
something like 35. Use it if you insist, I might change it
though :)

One more thing I was thinking about. The current AF values
we need to keep are

#define AF_INET         2       /* Internet IP Protocol         */
#define AF_ATMPVC       8       /* ATM PVCs                     */
#define AF_INET6        10      /* IP version 6                 */

after decoupling them we don't really care about clashes
anymore, so we might still use zero for ARP and AF_INET6
as highest value.

> (Who does the patch now?)

You I'd suggest.

