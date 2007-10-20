From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] Add xt_tos
Date: Sat, 20 Oct 2007 18:01:37 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710201758460.1997@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710201344220.1997@fbirervta.pbzchgretzou.qr>
 <471A2338.6060501@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53496 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194AbXJTQBj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Oct 2007 12:01:39 -0400
In-Reply-To: <471A2338.6060501@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Oct 20 2007 17:48, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> --- /dev/null
>> +++ gitone/include/linux/netfilter/xt_tos.h
>> @@ -0,0 +1,13 @@
>> +#ifndef _XT_TOS_MATCH_H
>> +#define _XT_TOS_MATCH_H
>> +
>> +struct xt_tos_info {
>> +	u_int8_t tos;
>> +	u_int8_t invert;
>> +};
>>   
>
> I think this will break compatiblity on CRIS, which IIRC doesn't
> perform any alignment (XT_ALIGN becomes a NOP) and thus the
> structure size increases.

Hah, you screwed it up!
You quote xt_tos, but the patch is xt_TOS :)

> I've already queued up the patch with some changes (capital
> letters removed from function names, keep ipt_TOS.h, Kbuild),
> could you send me a fix on top of that? I guess the options
> are to remove inversion or to introduce a new revision (or
> to convice me that I'm wrong :))

I'll fix it up, somehow.
