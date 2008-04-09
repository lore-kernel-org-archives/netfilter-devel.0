From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 3/8] [NETFILTER]: rename NF_ARP to NFPROTO_ARP and assign
 a non-clashing value
Date: Wed, 9 Apr 2008 19:38:16 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804091930191.3866@fbirervta.pbzchgretzou.qr>
References: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de> <47FCC0D2.7060306@trash.net> <alpine.LNX.1.10.0804091514550.4411@fbirervta.pbzchgretzou.qr> <47FCC2F4.4030901@trash.net> <alpine.LNX.1.10.0804091533010.4411@fbirervta.pbzchgretzou.qr>
 <47FCC7B0.6080205@trash.net> <alpine.LNX.1.10.0804091545570.4411@fbirervta.pbzchgretzou.qr> <47FCC9CC.4070307@trash.net> <alpine.LNX.1.10.0804091552430.4411@fbirervta.pbzchgretzou.qr> <47FCD318.1030507@trash.net> <alpine.LNX.1.10.0804091638160.3866@fbirervta.pbzchgretzou.qr>
 <47FCD954.5000308@trash.net> <alpine.LNX.1.10.0804091710070.3866@fbirervta.pbzchgretzou.qr> <47FCDD9D.7050905@trash.net> <alpine.LNX.1.10.0804091819380.3866@fbirervta.pbzchgretzou.qr> <47FCF047.3000202@trash.net> <alpine.LNX.1.10.0804091844220.3866@fbirervta.pbzchgretzou.qr>
 <47FCF3D6.30403@trash.net> <alpine.LNX.1.10.0804091858300.3866@fbirervta.pbzchgretzou.qr> <47FCF74A.1030100@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:45728 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbYDIRiR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 13:38:17 -0400
In-Reply-To: <47FCF74A.1030100@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-04-09 19:05, Patrick McHardy wrote:
>> I would have been going for NFPROTO_ now, with a translation
>> table for use for things like the xfrm code.
>
> We need to keep the INET/INET6 values identical anyway,
> so there no need for translation here.

The problem is with non-IP,non-IPv6 that passes through xfrm.
That is, if IPX can get xfrmd at all, probably does.

>> Should I change all AF_INET6 to NFPROTO_ in the same run
>> (i.e. mostly xt_[A-Za-z]*.c), or leave it as is?
>
> If we introduce those values, they should be used everywhere.
>
That would amount to a huge patch (perhaps I split to make it feasible).
