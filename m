From: Patrick McHardy <kaber@trash.net>
Subject: Re: [oops] in text matching
Date: Tue, 13 Nov 2007 07:56:58 +0100
Message-ID: <47394ABA.3070109@trash.net>
References: <1194525620.6845.5.camel@ierdnac>  <47330FE1.9020008@trash.net>	 <1194547827.3298.5.camel@ierdnac>  <4735AAC6.7040605@trash.net> <1194936719.10588.0.camel@ierdnac>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: andrei.popa@i-neo.ro
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36307 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbXKMG5k (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Nov 2007 01:57:40 -0500
In-Reply-To: <1194936719.10588.0.camel@ierdnac>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Andrei Popa wrote:
> On Sat, 2007-11-10 at 13:57 +0100, Patrick McHardy wrote:
>> Andrei Popa wrote:
>>> The oops is reproducible by this script (yyy are some IP addresses):
>>>
>>> ...
>>> #$IPT -I INPUT -p tcp --dport 80 -m string --algo bm --string "$MyNick"
>>> -j DROP
>>
>> I could reproduce it with an empty string - is $MyNick defined?
> 
> it's not defined.
> 
>> Please try this patch.
> 
> it's ok now:
> 
> test ~ # iptables -I INPUT -p tcp --dport 80 -m string --algo bm
> --string "$MyNick" -j DROP
> iptables: Invalid argument


Thanks, thats whats expected. The patch is suboptimal though
since it should really allow patterns of length zero. Pablo,
the naive approach would be to ignore patlen == 0 in the
initialization path and return the current position in bm_find().
But I'm guessing there's a better way to handle this case,
could you look into this please? Thanks.

> 
>> plain text document attachment (x)
>> diff --git a/lib/ts_bm.c b/lib/ts_bm.c
>> index d90822c..5adb3ff 100644
>> --- a/lib/ts_bm.c
>> +++ b/lib/ts_bm.c
>> @@ -142,6 +142,9 @@ static struct ts_config *bm_init(const void *pattern, unsigned int len,
>>  	unsigned int prefix_tbl_len = len * sizeof(unsigned int);
>>  	size_t priv_size = sizeof(*bm) + len + prefix_tbl_len;
>>  
>> +	if (len == 0)
>> +		return ERR_PTR(-EINVAL);
>> +
>>  	conf = alloc_ts_config(priv_size, gfp_mask);
>>  	if (IS_ERR(conf))
>>  		return conf;
> 

