From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/8] [NETFILTER]: rename NF_ARP to NFPROTO_ARP and assign
 a non-clashing value
Date: Wed, 09 Apr 2008 16:30:48 +0200
Message-ID: <47FCD318.1030507@trash.net>
References: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de> <2a75525ff0d60f2e71df2c9c3d040d3a76451713.1207668694.git.jengelh@computergmbh.de> <47FCBC24.4020209@trash.net> <alpine.LNX.1.10.0804091508480.4411@fbirervta.pbzchgretzou.qr> <47FCC0D2.7060306@trash.net> <alpine.LNX.1.10.0804091514550.4411@fbirervta.pbzchgretzou.qr> <47FCC2F4.4030901@trash.net> <alpine.LNX.1.10.0804091533010.4411@fbirervta.pbzchgretzou.qr> <47FCC7B0.6080205@trash.net> <alpine.LNX.1.10.0804091545570.4411@fbirervta.pbzchgretzou.qr> <47FCC9CC.4070307@trash.net> <alpine.LNX.1.10.0804091552430.4411@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48762 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbYDIOav (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 10:30:51 -0400
In-Reply-To: <alpine.LNX.1.10.0804091552430.4411@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2008-04-09 15:51, Patrick McHardy wrote:
>>> So since that just came to my mind, how about using the
>>> somewhat odd one NFPROTO_TOTAL?
>> How about just using MAX the way a maximum is defined?
>>
> 
> MAX is just ambiguous.
> 
>  - the maximum /number/ [i.e. counting things] of something or
>  - the maximum [array index] /value/
> 
> and apparently noone encoded the intent of MAX into their
> constant's name when writing it.

Well, I'm sick of this discussion. MAX is the highest value,
NUM is the number of items. I'm aware that people seem to
have problems understanding this, but that is no reason
to further the confusion.

BTW, these values *do* need to be exported to userspace
for nfnetlink.

> Make a public vote on lkml if you dare, or I will >>:-]

Don't CC me or I might get into an unpleasant mood.
