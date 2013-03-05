From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH] nfacct: correct regressions in v1.0.1
Date: Tue, 05 Mar 2013 18:40:28 +0000
Message-ID: <51363C1C.6010503@googlemail.com>
References: <5135E977.1000905@googlemail.com> <20130305135943.GA4369@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:59000 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758306Ab3CESkj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Mar 2013 13:40:39 -0500
Received: by mail-wg0-f53.google.com with SMTP id fn15so6088107wgb.8
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Mar 2013 10:40:37 -0800 (PST)
In-Reply-To: <20130305135943.GA4369@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>> -static int _nfacct_cmd_add(char *name, int pkts, int bytes)
>> +static int _nfacct_cmd_add(char *name,
>> +			   long long unsigned pkts, long long unsigned bytes)
>>     
>
> those are still signed, should be unsigned.
>   
Noted.

>> -		ret = sscanf(buffer, "{ pkts = %lu, bytes = %lu } = %s",
>> +		ret = sscanf(buffer, "{ pkts = %llu, bytes = %llu } = %s",
>>     
>
> Better use %"PRIu64" given that we're using uint64_t.
>   
You learn something new every day. If this is indeed the case, then 
another patch coming up in a minute.

> I have applied a patch based on yours.
>   
Thanks.

