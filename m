From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC IPTABLES 3/4]: add xt_RATEEST target
Date: Sun, 25 Nov 2007 18:37:56 +0100
Message-ID: <4749B2F4.9070604@trash.net>
References: <4749ACDB.3020705@trash.net> <Pine.LNX.4.64.0711251831230.9477@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64872 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbXKYRif (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2007 12:38:35 -0500
In-Reply-To: <Pine.LNX.4.64.0711251831230.9477@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Nov 25 2007 18:11, Patrick McHardy wrote:
> 
>> +static void
>> +RATEEST_final_check(unsigned int flags)
>> +{
>> +	...
>> +	for (info->interval = 0; info->interval <= 5; info->interval++) {
>> +		if (interval <= (1 << info->interval) * (TIME_UNITS_PER_SEC / 4))
>> +			break;
>> +	}
> 
> -{}

For multiple statements they're fine.

>> +static void
>> +__RATEEST_print(const struct xt_entry_target *target, const char *prefix)
>> +{
>> +	struct xt_rateest_target_info *info = (void *)target->data;
>> +	unsigned int interval;
>> +	unsigned int ewma_log;
> 
> Ouchie - that throws a warning with -Wshadow (which is what I'm trying to slip
> in later).

Will rename.

>> +
>> +	interval = (TIME_UNITS_PER_SEC << (info->interval + 2)) / 4;
>> +	ewma_log = interval * (1 << (info->ewma_log));
> 
> ewma_log = interval << info->ewma_log;

OK.

> 
>> +	printf("%sname %s ", prefix, info->name);
>> +	printf("%sinterval ", prefix);
>> +	RATEEST_print_time(interval);
>> +	printf("%sewmalog ", prefix);
>> +	RATEEST_print_time(ewma_log);
>> +}
>> +
> 
> 
>> -LDLIBS       = -ldl
>> +LDLIBS       = -ldl -lm
> 
> I have not seen the function that requires -lm, which was it?

log():

+		if (interval / (-log(w)) > ewma_log)
