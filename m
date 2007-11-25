From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC NETFILTER 2/4]: Add xt_rateest match
Date: Sun, 25 Nov 2007 18:29:28 +0100
Message-ID: <4749B0F8.4050500@trash.net>
References: <4749ACD4.4010407@trash.net> <Pine.LNX.4.64.0711251824480.9477@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64622 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbXKYRaH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2007 12:30:07 -0500
In-Reply-To: <Pine.LNX.4.64.0711251824480.9477@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Nov 25 2007 18:11, Patrick McHardy wrote:
> 
>> Date: Sun, 25 Nov 2007 18:11:48 +0100
>> From: Patrick McHardy <kaber@trash.net>
>> To: Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>
>> Subject: [RFC NETFILTER 2/4]: Add xt_rateest match
>>
>>
>> index 0000000..e4e0653
>> --- /dev/null
>> +++ b/include/linux/netfilter/xt_rateest.h
>> @@ -0,0 +1,33 @@
>> +#ifndef _XT_RATEEST_MATCH_H
>> +#define _XT_RATEEST_MATCH_H
>> +
>> +enum xt_rateest_match_flags {
>> +	XT_RATEEST_MATCH_INVERT	= 0x01,
>> +	XT_RATEEST_MATCH_ABS	= 0x02,
>> +	XT_RATEEST_MATCH_REL	= 0x04,
>> +	XT_RATEEST_MATCH_DELTA	= 0x08,
>> +	XT_RATEEST_MATCH_BPS	= 0x10,
>> +	XT_RATEEST_MATCH_PPS	= 0x20,
>> +};
> 
> Perhaps 1<<0, 1<<1, 1<<2, ...?

I don't really care, so why not :)

>> +	spin_lock_bh(&info->est1->lock);
>> +	rstats	= &info->est1->rstats;
>> +	if (info->flags & XT_RATEEST_MATCH_DELTA) {
>> +		bps1	= info->bps1 >= rstats->bps ?
>> +					info->bps1 - rstats->bps : 0;
>> +		pps1	= info->pps1 >= rstats->pps ?
>> +					info->pps1 - rstats->pps : 0;
>> +	} else {
>> +		bps1	= rstats->bps;
>> +		pps1	= rstats->pps;
>> +	}
>> +	spin_unlock_bh(&info->est1->lock);
>> +
>> +	if (info->flags & XT_RATEEST_MATCH_ABS) {
>> +		bps2	= info->bps2;
>> +		pps2	= info->pps2;
> 
> I think you can cut down on the extra whitespace around = here,
> it already lines up nicely anyway.

True, that needs some reformatting anyway, especially the ? .. : ..
looks weird.
