From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC NETFILTER 1/4]: add xt_RATEEST target
Date: Sun, 25 Nov 2007 18:27:58 +0100
Message-ID: <4749B09E.5010300@trash.net>
References: <4749ACCF.3020806@trash.net> <Pine.LNX.4.64.0711251815430.9477@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64594 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbXKYR2h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2007 12:28:37 -0500
In-Reply-To: <Pine.LNX.4.64.0711251815430.9477@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Nov 25 2007 18:11, Patrick McHardy wrote:
> 
>> Date: Sun, 25 Nov 2007 18:11:43 +0100
>> From: Patrick McHardy <kaber@trash.net>
>> To: Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>
>> Subject: [RFC NETFILTER 1/4]: add xt_RATEEST target
>>
>>
>>
> 
> ^^^ That's all pine gives on reply. :)

Yeah, I know, icedove really sucks in this regard, it not only somehow
manages to break Content-Disposition: inline attachments, but also
doesn't quote them itself. thunderbird did both correctly.

>> @@ -0,0 +1,11 @@
>> +#ifndef _XT_RATEEST_TARGET_H
>> +#define _XT_RATEEST_TARGET_H
>> +
>> +struct xt_rateest_target_info {
>> +	char			name[IFNAMSIZ];
>> +	signed char		interval;
>> +	unsigned char		ewma_log;
> 
> int8_t, uint8_t.

It matches the types from the tc headers, but sure, I'll change it.

