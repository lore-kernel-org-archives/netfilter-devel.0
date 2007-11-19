From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 2/3] xt_TOS target
Date: Mon, 19 Nov 2007 12:46:20 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711191239490.3501@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711161357050.3340@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0711161400170.3340@fbirervta.pbzchgretzou.qr> <47416809.60900@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60444 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbXKSLqV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Nov 2007 06:46:21 -0500
In-Reply-To: <47416809.60900@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 19 2007 11:40, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> Posted for review and checkup.
>> 
>> +++ net-2.6.25/include/linux/netfilter/xt_TOS.h
>> @@ -0,0 +1,13 @@
>> +#ifndef _XT_TOS_TARGET_H
>> +#define _XT_TOS_TARGET_H
>> +
>> +#ifndef IPTOS_NORMALSVC
>> +#	define IPTOS_NORMALSVC 0
>> +#endif
>> +
>> +struct xt_tos_target_info {
>> +	u_int8_t tos_value;
>> +	u_int8_t tos_mask;
>
> Is the mask thing really useful?

Yes, in case you want to modify an existing TOS value, e.g.

	-j TOS --tos 0x08/0x08

Sets Maximize-Throughput (plus whatever other TOS flags are already there).

	-j TOS --tos 0x08/0x18

Sets Maximize-Throughput and clears Minimize-Delay, and keeps other
flags (such as Maximize-Reliability).

Or, should the user desire, change all Min-Delay flows into Max-Thru
and vice-versa:

	-j TOS --tos 0x18/0x00

The mask becomes especially useful since with xt_tos/xt_TOS, you can
also match/set the Precedence (the upper 4 bits of the 8-bit TOS field),
and for that, you need a mask unless you want to touch the lower 4 bits too.

>> --- net-2.6.25.orig/include/linux/netfilter_ipv4/Kbuild
>> +++ net-2.6.25/include/linux/netfilter_ipv4/Kbuild
>> @@ -9,7 +9,6 @@ header-y += ipt_NFQUEUE.h
>>  header-y += ipt_REJECT.h
>>  header-y += ipt_SAME.h
>>  header-y += ipt_TCPMSS.h
>> -header-y += ipt_TOS.h
>
>
> We also need to keep this one I think.
>

Suppose so.


Thanks,
Jan
