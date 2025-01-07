Received: from smtp-out.freemail.hu (fmfe13.freemail.hu [46.107.16.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648B832C8E;
	Tue,  7 Jan 2025 22:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736288205; cv=none; b=Wei+obKFQOQd5dwNTyxwGWMG1dmmySblvSlqCqwRr5ei6z67+LsY8nmRiTBDObaiQydm+aZNpcVit8IgPmi4c10XpeFXrIr8CIvlG8pZ5eR1mHzEQsVz2oFSvwFJfzgma1GmFXtOSidtIFPhoxpEK4aRDSOxQNEUEMm20uU0iJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736288205; c=relaxed/simple;
	bh=P286wzQsym/KR/rIxnDSJlA8oK0/nOTXz4vDbnAr+iQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TX//GNKnofbyMG9Ff3KirbzPWa0Kq/I24iqOH1gQ7WEcYQR2+YXz9ENuFxsSBDqGD9x3/GnOMuH6Rx+a93DPsrfzkpn9jaks8fyXlwDfryhk3a5D1vTPeHvarXFOUEoSvvh7uruMkI7UwCvQrTCpSoCaKyws/u40MTQmLRs41HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=vBjqyHow reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="vBjqyHow"
Received: from [192.168.0.16] (catv-178-48-208-49.catv.fixed.vodafone.hu [178.48.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YSQBg0NTXztPj;
	Tue, 07 Jan 2025 23:07:07 +0100 (CET)
Message-ID: <0e51464d-301d-4b48-ad38-ca04ff7d9151@freemail.hu>
Date: Tue, 7 Jan 2025 23:06:43 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/10] netfilter: Add message pragma for deprecated
 xt_*.h, ipt_*.h.
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: fw@strlen.de, pablo@netfilter.org, lorenzo@kernel.org,
 daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com,
 davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20250107024120.98288-1-egyszeregy@freemail.hu>
 <20250107024120.98288-10-egyszeregy@freemail.hu>
 <1cd443f7-df1e-20cf-cfe8-f38ac72491e4@netfilter.org>
Content-Language: hu
From: =?UTF-8?Q?Sz=C5=91ke_Benjamin?= <egyszeregy@freemail.hu>
In-Reply-To: <1cd443f7-df1e-20cf-cfe8-f38ac72491e4@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736287627;
	s=20181004; d=freemail.hu;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	l=4897; bh=lt51BCtqmSIYRL0a7phBUsHAMDpo2sbnDyuW/1z9sVk=;
	b=vBjqyHowI/y2Df+LrR2+CUa2cTd1gz2qJB+o/qpn71o5COCZyeju5zSXpuBfGDfd
	4ZpC41XDlKSrnD1AA+1lK9J7SOkFX86E8YDo2QT0csQSkwDg6RVD6MFp62bkdIg4BH3
	o8rD2m4wK272Y7h/hvahh26lumHTn3uz8bzVntWkBucCRaupMFzlLcyt4ga/jwmFZD7
	xO01LzXxzJc+OIH9jDyyp+Sa6Bx+EuQAO2qpmL8Xpf0eMElzZlH4yJ1imqUfddJEaj7
	cZBrLFAqf+Afb0yierQbvbRLjw69+kM4eK/N3HoSvW+buZl3ya8WZDdTmnvsKAk6oKB
	GMkeGpLKnQ==

2025. 01. 07. 20:39 keltezéssel, Jozsef Kadlecsik írta:
> On Tue, 7 Jan 2025, egyszeregy@freemail.hu wrote:
> 
>> From: Benjamin Szőke <egyszeregy@freemail.hu>
>>
>> Display information about deprecated xt_*.h, ipt_*.h files
>> at compile time. Recommended to use header files with
>> lowercase name format in the future.
> 
> I still don't know whether adding the pragmas to notify about header file
> deprecation is a good idea.
> 

Do you have any other ideas how can you display this information to the 
users/customers, that it is time to stop using the uppercase header files then 
they shall to use its merged lowercase named files instead in their userspace SW?

> On my part that's all. Thank you the work!
> 
> Best regards,
> Jozsef
>   
>> Signed-off-by: Benjamin Szőke <egyszeregy@freemail.hu>
>> ---
>>   include/uapi/linux/netfilter/xt_CONNMARK.h  | 2 ++
>>   include/uapi/linux/netfilter/xt_DSCP.h      | 2 ++
>>   include/uapi/linux/netfilter/xt_MARK.h      | 2 ++
>>   include/uapi/linux/netfilter/xt_RATEEST.h   | 2 ++
>>   include/uapi/linux/netfilter/xt_TCPMSS.h    | 2 ++
>>   include/uapi/linux/netfilter_ipv4/ipt_ECN.h | 2 ++
>>   include/uapi/linux/netfilter_ipv4/ipt_TTL.h | 2 ++
>>   include/uapi/linux/netfilter_ipv6/ip6t_HL.h | 2 ++
>>   8 files changed, 16 insertions(+)
>>
>> diff --git a/include/uapi/linux/netfilter/xt_CONNMARK.h b/include/uapi/linux/netfilter/xt_CONNMARK.h
>> index 171af24ef679..1bc991fd546a 100644
>> --- a/include/uapi/linux/netfilter/xt_CONNMARK.h
>> +++ b/include/uapi/linux/netfilter/xt_CONNMARK.h
>> @@ -4,4 +4,6 @@
>>   
>>   #include <linux/netfilter/xt_connmark.h>
>>   
>> +#pragma message("xt_CONNMARK.h header is deprecated. Use xt_connmark.h instead.")
>> +
>>   #endif /* _XT_CONNMARK_TARGET_H */
>> diff --git a/include/uapi/linux/netfilter/xt_DSCP.h b/include/uapi/linux/netfilter/xt_DSCP.h
>> index fcff72347256..bd550292803d 100644
>> --- a/include/uapi/linux/netfilter/xt_DSCP.h
>> +++ b/include/uapi/linux/netfilter/xt_DSCP.h
>> @@ -4,4 +4,6 @@
>>   
>>   #include <linux/netfilter/xt_dscp.h>
>>   
>> +#pragma message("xt_DSCP.h header is deprecated. Use xt_dscp.h instead.")
>> +
>>   #endif /* _XT_DSCP_TARGET_H */
>> diff --git a/include/uapi/linux/netfilter/xt_MARK.h b/include/uapi/linux/netfilter/xt_MARK.h
>> index cdc12c0954b3..9f6c03e26c96 100644
>> --- a/include/uapi/linux/netfilter/xt_MARK.h
>> +++ b/include/uapi/linux/netfilter/xt_MARK.h
>> @@ -4,4 +4,6 @@
>>   
>>   #include <linux/netfilter/xt_mark.h>
>>   
>> +#pragma message("xt_MARK.h header is deprecated. Use xt_mark.h instead.")
>> +
>>   #endif /* _XT_MARK_H_TARGET_H */
>> diff --git a/include/uapi/linux/netfilter/xt_RATEEST.h b/include/uapi/linux/netfilter/xt_RATEEST.h
>> index f817b5387164..ec3d68f67b2f 100644
>> --- a/include/uapi/linux/netfilter/xt_RATEEST.h
>> +++ b/include/uapi/linux/netfilter/xt_RATEEST.h
>> @@ -4,4 +4,6 @@
>>   
>>   #include <linux/netfilter/xt_rateest.h>
>>   
>> +#pragma message("xt_RATEEST.h header is deprecated. Use xt_rateest.h instead.")
>> +
>>   #endif /* _XT_RATEEST_TARGET_H */
>> diff --git a/include/uapi/linux/netfilter/xt_TCPMSS.h b/include/uapi/linux/netfilter/xt_TCPMSS.h
>> index 154e88c1de02..826060264766 100644
>> --- a/include/uapi/linux/netfilter/xt_TCPMSS.h
>> +++ b/include/uapi/linux/netfilter/xt_TCPMSS.h
>> @@ -4,4 +4,6 @@
>>   
>>   #include <linux/netfilter/xt_tcpmss.h>
>>   
>> +#pragma message("xt_TCPMSS.h header is deprecated. Use xt_tcpmss.h instead.")
>> +
>>   #endif /* _XT_TCPMSS_TARGET_H */
>> diff --git a/include/uapi/linux/netfilter_ipv4/ipt_ECN.h b/include/uapi/linux/netfilter_ipv4/ipt_ECN.h
>> index 6727f5a44512..42317fb3a4e9 100644
>> --- a/include/uapi/linux/netfilter_ipv4/ipt_ECN.h
>> +++ b/include/uapi/linux/netfilter_ipv4/ipt_ECN.h
>> @@ -4,4 +4,6 @@
>>   
>>   #include <linux/netfilter_ipv4/ipt_ecn.h>
>>   
>> +#pragma message("ipt_ECN.h header is deprecated. Use ipt_ecn.h instead.")
>> +
>>   #endif /* _IPT_ECN_TARGET_H */
>> diff --git a/include/uapi/linux/netfilter_ipv4/ipt_TTL.h b/include/uapi/linux/netfilter_ipv4/ipt_TTL.h
>> index 5d989199ed28..1663493e4951 100644
>> --- a/include/uapi/linux/netfilter_ipv4/ipt_TTL.h
>> +++ b/include/uapi/linux/netfilter_ipv4/ipt_TTL.h
>> @@ -4,4 +4,6 @@
>>   
>>   #include <linux/netfilter_ipv4/ipt_ttl.h>
>>   
>> +#pragma message("ipt_TTL.h header is deprecated. Use ipt_ttl.h instead.")
>> +
>>   #endif /* _IPT_TTL_TARGET_H */
>> diff --git a/include/uapi/linux/netfilter_ipv6/ip6t_HL.h b/include/uapi/linux/netfilter_ipv6/ip6t_HL.h
>> index bcf22824b393..55f08e20acd2 100644
>> --- a/include/uapi/linux/netfilter_ipv6/ip6t_HL.h
>> +++ b/include/uapi/linux/netfilter_ipv6/ip6t_HL.h
>> @@ -4,4 +4,6 @@
>>   
>>   #include <linux/netfilter_ipv6/ip6t_hl.h>
>>   
>> +#pragma message("ip6t_HL.h header is deprecated. Use ip6t_hl.h instead.")
>> +
>>   #endif /* _IP6T_HL_TARGET_H */
>> -- 
>> 2.43.5
>>
>>
> 

