From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/8] [NETFILTER]: rename NF_ARP to NFPROTO_ARP and assign
 a non-clashing value
Date: Wed, 09 Apr 2008 19:05:14 +0200
Message-ID: <47FCF74A.1030100@trash.net>
References: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de> <alpine.LNX.1.10.0804091508480.4411@fbirervta.pbzchgretzou.qr> <47FCC0D2.7060306@trash.net> <alpine.LNX.1.10.0804091514550.4411@fbirervta.pbzchgretzou.qr> <47FCC2F4.4030901@trash.net> <alpine.LNX.1.10.0804091533010.4411@fbirervta.pbzchgretzou.qr> <47FCC7B0.6080205@trash.net> <alpine.LNX.1.10.0804091545570.4411@fbirervta.pbzchgretzou.qr> <47FCC9CC.4070307@trash.net> <alpine.LNX.1.10.0804091552430.4411@fbirervta.pbzchgretzou.qr> <47FCD318.1030507@trash.net> <alpine.LNX.1.10.0804091638160.3866@fbirervta.pbzchgretzou.qr> <47FCD954.5000308@trash.net> <alpine.LNX.1.10.0804091710070.3866@fbirervta.pbzchgretzou.qr> <47FCDD9D.7050905@trash.net> <alpine.LNX.1.10.0804091819380.3866@fbirervta.pbzchgretzou.qr>
  <47FCF047.3000202@trash.net> <alpine.LNX.1.10.0804091844220.3866@fbirervta.pbzchgretzou.qr> <47FCF3D6.30403@trash.net> <alpine.LNX.1.10.0804091858300.3866@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53467 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbYDIRFT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 13:05:19 -0400
In-Reply-To: <alpine.LNX.1.10.0804091858300.3866@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2008-04-09 18:50, Patrick McHardy wrote:
>> Right. There is currently to my knowledge only a single
>> place where this happens, which is net/xfrm/xfrm_output.c.
>> All others explicitly pass AF_INET etc, and then would
>> simply pass NFPROTO_INET.
>>
>> But you have a point, that doesn't sound ideal.
>>
>> Unfortunately, as I said, we need to export these values
>> to userspace, so we can't have them depend on AF_MAX.
>> Another constraint is that they must not exceed 255
>> or they won't fit in nfgenmsg->nfgen_family.
>>
>> Mhh tricky. I still would prefer to avoid AF_ARP ...
>>
> I would have been going for NFPROTO_ now, with a translation
> table for use for things like the xfrm code.

We need to keep the INET/INET6 values identical anyway,
so there no need for translation here.

> Should I change all AF_INET6 to NFPROTO_ in the same run
> (i.e. mostly xt_[A-Za-z]*.c), or leave it as is?

If we introduce those values, they should be used everywhere.

