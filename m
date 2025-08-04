Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA195248F78
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Aug 2025 10:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754303100; cv=none; b=ImNYnGmyRar75n0wrb900ueipqHyrCNBlY0ZW2I5HXKNSk7AUwbApkbCqIxoLmDUq2M9WCIfxuPeEKyt+dMqakih8XeaW1xxNTbbqn65y0O+7O/YZntrsSNMX8TyCDWvPqRQZkpwYkBS5Hqh3lhvyywao1HpZ7hCkWr4kXes8oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754303100; c=relaxed/simple;
	bh=+9v/3GuzahlpcNNBCwypSr8VTupqwXzMfqbFPRHjdBg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qP0zGw4oAeBHQGA3C9BiwgVF9lb9JTPt2HZXnMI8I7z+VRNfT8/dN7cHNaDcUhr947z1JwIWpuU8rYr13P+Q6Vb5pCTiEASu3kbbT9S/g4wvtNcyDhSUCOF0jr34ili8PBOxau1tfl7GgMRYnzQ10v4NA1et7OkxF0uI7czoOgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QEvVYyip; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QEvVYyip"
Message-ID: <b863df76-402b-41b6-9517-980fbf1d8e22@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754303094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nAE0TWXDN40fWqcD8iRw4W74F/DdbrnuRTmA8Gxv/e0=;
	b=QEvVYyipX3Lu9rBQswa5l9v1Rhkr+PQH3t12RkU94cd26aBJ/dlP9zIA6NLR5vzSxXdd4P
	aqP4LN0zQgWQVTIhaKOQ2t9vMHBLNWIIm7phwZpf5wFHxVVrnpiLdu72fSk3rip2xwh2W+
	plDzoM2CbHUeAB/mZnXY6Wb4BVVLl00=
Date: Mon, 4 Aug 2025 18:24:49 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [bug report] netfilter: load nf_log_syslog on enabling
 nf_conntrack_log_invalid
Content-Language: en-US
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: netfilter-devel@vger.kernel.org
References: <aJBtpniVz8dIRDYf@stanley.mountain>
 <0e275ffe-e475-40eb-ac19-d0122ba847ae@linux.dev>
 <cd3b87dd-9f6f-48f0-b2f2-586d60d9a365@suswa.mountain>
 <c401288b-e2de-42a7-8e04-abd08daa112a@linux.dev>
 <4bf4576a-e790-470a-a86f-329472ace9f6@suswa.mountain>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <4bf4576a-e790-470a-a86f-329472ace9f6@suswa.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 2025/8/4 18:10, Dan Carpenter wrote:
> On Mon, Aug 04, 2025 at 05:57:09PM +0800, Lance Yang wrote:
>>
>>
>> On 2025/8/4 17:24, Dan Carpenter wrote:
>>> On Mon, Aug 04, 2025 at 05:05:32PM +0800, Lance Yang wrote:
>>>>
>>>>
>>>> On 2025/8/4 16:21, Dan Carpenter wrote:
>>>>> Hello Lance Yang,
>>>>>
>>>>> Commit e89a68046687 ("netfilter: load nf_log_syslog on enabling
>>>>> nf_conntrack_log_invalid") from May 26, 2025 (linux-next), leads to
>>>>> the following Smatch static checker warning:
>>>>>
>>>>> 	net/netfilter/nf_conntrack_standalone.c:575 nf_conntrack_log_invalid_sysctl()
>>>>> 	warn: missing error code? 'ret'
>>>>
>>>> Thanks for pointing this out!
>>>>
>>>>>
>>>>> net/netfilter/nf_conntrack_standalone.c
>>>>>        559 static int
>>>>>        560 nf_conntrack_log_invalid_sysctl(const struct ctl_table *table, int write,
>>>>>        561                                 void *buffer, size_t *lenp, loff_t *ppos)
>>>>>        562 {
>>>>>        563         int ret, i;
>>>>>        564
>>>>>        565         ret = proc_dou8vec_minmax(table, write, buffer, lenp, ppos);
>>>>>        566         if (ret < 0 || !write)
>>>>>        567                 return ret;
>>>>>        568
>>>>>        569         if (*(u8 *)table->data == 0)
>>>>>        570                 return ret;
>>>>>
>>>>> return 0?
>>>>
>>>> That's a good question. proc_dou8vec_minmax() returns 0 on a successful
>>>> write. So when a user writes '0' to disable the feature, ret is already 0.
>>>> Returning it is the correct behavior to signal success.
>>>>
>>>>>
>>>>>        571
>>>>>        572         /* Load nf_log_syslog only if no logger is currently registered */
>>>>>        573         for (i = 0; i < NFPROTO_NUMPROTO; i++) {
>>>>>        574                 if (nf_log_is_registered(i))
>>>>> --> 575                         return ret;
>>>>>
>>>>> This feels like it should be return -EBUSY?  Or potentially return 0.
>>>>
>>>> We simply return ret (which is 0) to signal success, as no further action
>>>> (like loading the nf_log_syslog module) is needed.
>>>>
>>>>>
>>>>>        576         }
>>>>>        577         request_module("%s", "nf_log_syslog");
>>>>>        578
>>>>>        579         return ret;
>>>>>
>>>>> return 0.
>>>>
>>>> It's 0 as well.
>>>>
>>>> Emm... do you know a way to make the Smatch static checker happy?
>>>>
>>>
>>> Returning 0 would make the code so much more clear.  Readers probably
>>
>> Yep, I see your point ;)
>>
>>> assume that proc_dou8vec_minmax() returns positive values on success
>>
>> IIUC, proc_dou8vec_minmax only returns 0 for success or a negative
>> error code, so there's no positive value case here ...
>>
>>> and that's why we are returning ret.  I know that I had to check.
>>>
>>
>> It should make the code clearer and also make the Smatch checker happy:
>>
>> 	ret = proc_dou8vec_minmax(table, write, buffer, lenp, ppos);
>> 	- if (ret < 0 || !write)
>> 	+ if (ret != 0 || !write)
>> 		return ret;
>>
>> By checking for "ret != 0", it becomes explicit that ret can only be
>> zero after that. wdyt?
> 
> The ret check there should either be the way you wrote it or:
> 
> 	if (ret || !write)
> 
> either one is fine.  Adding a "!= 0" is not really idiomatic because
> ret is not a number, it's an error code.

Yes. "if (ret || !write)" is much more idiomatic ;)

> If you have the cross function database, then Smatch knows that ret
> can't be positive...  I build with the DB on my desktop but the cross
> function DB doesn't scale well enough to be usable by the zero-day bot
> so I see this warning on my desktop but the zero-day bot will not
> print a warning.

Ah, got it. Would you be interested in sending a patch for it?

Thanks,
Lance

