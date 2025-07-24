Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174012D12F7
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Jul 2025 12:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753361352; cv=none; b=IMBRTqs3cbRvuJJbDCUHZnrpW7Pd7ihTamK4BqH6jkBbmNIbBAa+DvJzf04xkYyHuvT19aCYRSVsrtEQW7EsZDQIP9/ascKH97aHQDy9VFVJjr3NxG0AdzK8X/Y95wY2vxv6x/ZW5RYlamgeLbz6/+sGXS707wvsb0VN3RBWWzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753361352; c=relaxed/simple;
	bh=xqXmrWxuJdb1D3OvBiTINZzzM4LYKaxmKPJIjhUeUSw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eyTI2YC8RLWgu937Gc52BlzjSueXNdTNIZ/8z6Z/3GDtekniwkljCQZ7Guq8tAvyV9A/4SwvTmxY+/4bWW5gd2H0NxfS6paKyNwqdVR2ffkkpsihhULkh/gtR1ZJo4AfrEbdqT3z1zoXhSCwsqajV+wz9jAcconz4/bA4xEfafo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CrmnmbdB; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CrmnmbdB"
Message-ID: <ba6d5737-863b-4cf1-8b26-f74e494e9b19@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753361338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ETtec1nSuP+hVZkxKzZmMe2vA06bPL9ep3oiEZZE7HA=;
	b=CrmnmbdBVMXMSlrCft2rcgVZyyCdeTDB7/DcJSUxacfRYisfPmex3H7KIOwZSrodoRkoR3
	3GoJreDfBMh7qvquzIkZwuceFg8UD2D7539w9vdDwYiwmrF4NVhQ9PK+rjhIQQHWXu7QtL
	j7L8RqOl+uPqiTgGFnmlwoEx2EALDHw=
Date: Thu, 24 Jul 2025 20:48:45 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/1] netfilter: load nf_log_syslog on enabling
 nf_conntrack_log_invalid
Content-Language: en-US
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: fw@strlen.de, coreteam@netfilter.org, davem@davemloft.net,
 edumazet@google.com, horms@kernel.org, kadlec@netfilter.org,
 kuba@kernel.org, linux-kernel@vger.kernel.org,
 netfilter-devel@vger.kernel.org, pabeni@redhat.com, zi.li@linux.dev,
 Lance Yang <ioworker0@gmail.com>
References: <20250526085902.36467-1-lance.yang@linux.dev>
 <aIIl9u1TY84Q9mnD@calendula>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <aIIl9u1TY84Q9mnD@calendula>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 2025/7/24 20:24, Pablo Neira Ayuso wrote:
> Hi,
> 
> On Mon, May 26, 2025 at 04:59:02PM +0800, Lance Yang wrote:
>> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
>> index 2f666751c7e7..cdc27424f84a 100644
>> --- a/net/netfilter/nf_conntrack_standalone.c
>> +++ b/net/netfilter/nf_conntrack_standalone.c
>> @@ -14,6 +14,7 @@
>>   #include <linux/sysctl.h>
>>   #endif
>>   
>> +#include <net/netfilter/nf_log.h>
>>   #include <net/netfilter/nf_conntrack.h>
>>   #include <net/netfilter/nf_conntrack_core.h>
>>   #include <net/netfilter/nf_conntrack_l4proto.h>
>> @@ -543,6 +544,29 @@ nf_conntrack_hash_sysctl(const struct ctl_table *table, int write,
>>   	return ret;
>>   }
>>   
>> +static int
>> +nf_conntrack_log_invalid_sysctl(const struct ctl_table *table, int write,
>> +				void *buffer, size_t *lenp, loff_t *ppos)
>> +{
>> +	int ret, i;
>> +
>> +	ret = proc_dou8vec_minmax(table, write, buffer, lenp, ppos);
>> +	if (ret < 0 || !write)
>> +		return ret;
>> +
>> +	if (*(u8 *)table->data == 0)
>> +		return ret;
> 
> What is this table->data check for? I don't find any similar idiom
> like this in the existing proc_dou8vec_minmax() callers.

My intention was to avoid the unnecessary nf_log_is_registered()
calls when a user disables the feature by writing '0' to the sysctl.

But it's not a big deal. I will remove this check in v3 ;)

>> +
>> +	/* Load nf_log_syslog only if no logger is currently registered */
>> +	for (i = 0; i < NFPROTO_NUMPROTO; i++) {
>> +		if (nf_log_is_registered(i))
>> +			return ret;
>> +	}
>> +	request_module("%s", "nf_log_syslog");
>> +
>> +	return ret;
>> +}
>> +
>>   static struct ctl_table_header *nf_ct_netfilter_header;
>>   
>>   enum nf_ct_sysctl_index {
>> @@ -649,7 +673,7 @@ static struct ctl_table nf_ct_sysctl_table[] = {
>>   		.data		= &init_net.ct.sysctl_log_invalid,
>>   		.maxlen		= sizeof(u8),
>>   		.mode		= 0644,
>> -		.proc_handler	= proc_dou8vec_minmax,
>> +		.proc_handler	= nf_conntrack_log_invalid_sysctl,
>>   	},
>>   	[NF_SYSCTL_CT_EXPECT_MAX] = {
>>   		.procname	= "nf_conntrack_expect_max",
>> diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
>> index 6dd0de33eebd..c7dd5019a89d 100644
>> --- a/net/netfilter/nf_log.c
>> +++ b/net/netfilter/nf_log.c
>> @@ -125,6 +125,33 @@ void nf_log_unregister(struct nf_logger *logger)
>>   }
>>   EXPORT_SYMBOL(nf_log_unregister);
>>   
>> +/**
>> + * nf_log_is_registered - Check if any logger is registered for a given
>> + * protocol family.
>> + *
>> + * @pf: Protocol family
>> + *
>> + * Returns: true if at least one logger is active for @pf, false otherwise.
>> + */
>> +bool nf_log_is_registered(u_int8_t pf)
>> +{
>> +	int i;
>> +
>> +	/* Out of bounds. */
> 
> No need for this comment, please remove it.

OK, will remove it.

Thanks,
Lance

> 
>> +	if (pf >= NFPROTO_NUMPROTO) {
>> +		WARN_ON_ONCE(1);
>> +		return false;
>> +	}

