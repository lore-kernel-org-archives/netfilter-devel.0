From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 22/27] Rename ipt_iprange to xt_iprange
Date: Thu, 10 Jan 2008 16:52:59 +0100
Message-ID: <47863F5B.9020705@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022131230.14900@fbirervta.pbzchgretzou.qr> <47839CFA.9090005@trash.net> <Pine.LNX.4.64.0801081714430.3032@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801091453210.29244@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57798 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143AbYAJP5Y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2008 10:57:24 -0500
In-Reply-To: <Pine.LNX.4.64.0801091453210.29244@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Jan 8 2008 17:16, Jan Engelhardt wrote:
>> --- /dev/null
>> +++ b/include/linux/netfilter/xt_iprange.h
>> @@ -0,0 +1,17 @@
>> +#ifndef _LINUX_NETFILTER_XT_IPRANGE_H
>> +#define _LINUX_NETFILTER_XT_IPRANGE_H 1
>> +
>> +enum {
>> +	IPRANGE_SRC     = 1 << 0,	/* match source IP address */
>> +	IPRANGE_DST     = 1 << 1,	/* match destination IP address */
>> +	IPRANGE_SRC_INV = 1 << 2,	/* negate the condition */
>> +	IPRANGE_DST_INV = 1 << 3,	/* -"- */
>> +};
> 
> Flag holes can be evil :-/
> Please apply, thanks.
> 
>     [NETFILTER]: xt_iprange: Need to keep old constats from ipt_iprange

Folded into the original patch, thanks.
