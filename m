From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH xt-addons] xt_geoip: fix possible out-of-bounds access
Date: Sun, 13 Jun 2010 10:40:54 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1006131040120.10970@obet.zrqbmnf.qr>
References: <1275382302-8857-1-git-send-email-fwestphal@astaro.com> <alpine.LSU.2.01.1006121037230.29158@obet.zrqbmnf.qr> <20100613083827.GA11457@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56716 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505Ab0FMIk4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Jun 2010 04:40:56 -0400
In-Reply-To: <20100613083827.GA11457@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2010-06-13 10:38, Florian Westphal wrote:
>> diff --git a/extensions/xt_geoip.c b/extensions/xt_geoip.c
>> index 4c6b29f..44e489d 100644
>> --- a/extensions/xt_geoip.c
>> +++ b/extensions/xt_geoip.c
>> @@ -126,13 +126,13 @@ static bool geoip_bsearch(const struct geoip_subnet *range,
>>  {
>>  	int mid;
>>  
>> -	if (hi < lo)
>> +	if (hi <= lo)
>>  		return false;
>>  	mid = (lo + hi) / 2;
>>  	if (range[mid].begin <= addr && addr <= range[mid].end)
>>  		return true;
>>  	if (range[mid].begin > addr)
>> -		return geoip_bsearch(range, addr, lo, mid - 1);
>> +		return geoip_bsearch(range, addr, lo, mid);
>>  	else if (range[mid].end < addr)
>>  		return geoip_bsearch(range, addr, mid + 1, hi);
>>  
>> Seems to work on paper.
>
>Yes, this works as well.
>
>I do not have a strong preference on how this is fixed; if you
>consider your patch to be the better choice then please, by all means,
>apply it :-)

The initial call is
	geoip_bsearch(x, ip, 0, count);
which already shows that the original intent was to make hi
the exclusive upper barrier.
