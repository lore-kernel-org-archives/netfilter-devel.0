Received: from smtp-out.freemail.hu (fmfe15.freemail.hu [46.107.16.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F059D56446;
	Tue,  7 Jan 2025 21:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736287197; cv=none; b=ArbRGYdMZZmDPLSRI805ZRR6qw50ZODY9QmKe6IXHo/W6wp5XsltYfuGA4B6TbOrDV/3yodIstjDKb0KAfLsds1ckQ5+A8CZCH858rqRxTUztBiG/7WHZAuCt1Os8oC1VIkdyi8+wU9rQ4NfVMFEgJ8ZBHb5svLJMcCPyL/mZQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736287197; c=relaxed/simple;
	bh=dc40KGz2+BKXHaPIXS+D4NSqJ/SIbOZaJoFnr08iHFc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AS/wQvE92kMbWh9HI4QQ/3NyEdkN+UI1isQRrZot2+XhELsjgUHEuSjn/qFezQtZu0FkPqrSbj3URcqTJh5wiPinTj8m7WfDTVeU95/v5/MSzGS6YnUNK/V1bq6a4D6UfhLZDYRmIKfO8EaAILSyiMD4wXwyLScgpznScr3c0Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=dgzt+tIn reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="dgzt+tIn"
Received: from [192.168.0.16] (catv-178-48-208-49.catv.fixed.vodafone.hu [178.48.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YSQ2B0c22ztyZ;
	Tue, 07 Jan 2025 22:59:46 +0100 (CET)
Message-ID: <4cf2e26b-2727-4b50-9ada-56a6be814dca@freemail.hu>
Date: Tue, 7 Jan 2025 22:59:21 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/10] netfilter: Adjust code style of xt_*.h, ipt_*.h
 files.
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: fw@strlen.de, pablo@netfilter.org, lorenzo@kernel.org,
 daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com,
 davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20250107024120.98288-1-egyszeregy@freemail.hu>
 <20250107024120.98288-9-egyszeregy@freemail.hu>
 <2962ec51-4d32-76d9-4229-99001a437963@netfilter.org>
Content-Language: hu
From: =?UTF-8?Q?Sz=C5=91ke_Benjamin?= <egyszeregy@freemail.hu>
In-Reply-To: <2962ec51-4d32-76d9-4229-99001a437963@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736287187;
	s=20181004; d=freemail.hu;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	l=4921; bh=qnv/wkuXnqbCCoZz65HUSrHvJsowhLcrOJUzEb67MSg=;
	b=dgzt+tInkTT0uzLT58xd+Uif/7nXiOtKuAP7OUkT26wLglhm26ze4DbGI2L9wXK2
	kd3/iLxJYpatH3Zf89LFGLVZzGCJct5jy85QOzin5WeWgMiwfUvhM6PuAs6C7ULO/6b
	z8NNyt1WkvJzlD9jlMfclLAgOIs3D/0dVTG9o5HzsQzF5zGv5ogZ7FiUaXVmtYRvXq5
	T5j/RBpz9o5U9/GTHaRExcAEje+8ZhIC/g3dnPI/JdtJv51dK7sBFyqCemOKDoHcdsp
	MAtO7K4716LCYT1gKHct0BQpumFvrpO+uEhDM4RgFECoSmDG0HHcXNUsasZzfh+XTj3
	GIZcZ8ec1A==

2025. 01. 07. 20:39 keltezéssel, Jozsef Kadlecsik írta:
> On Tue, 7 Jan 2025, egyszeregy@freemail.hu wrote:
> 
>> From: Benjamin Szőke <egyszeregy@freemail.hu>
>>
>> - Adjust tab indents
>> - Fix format of #define macros
> 
> I don't really understand why it'd be important to use parentheses around
> plain constant values in macros. The kernel coding style does not list it
> as a requirement, see 12) 4. in Documentation/process/coding-style.rst.
> 

If it would be more than just a const value, parentheses is a must have thing 
for it (now for it, it is not critical to have it but better to get used to 
this). This is how my hand automatically do it, to avoid the syntax problem in 
this coding.

> Best regards,
> Jozsef
>   
>> Signed-off-by: Benjamin Szőke <egyszeregy@freemail.hu>
>> ---
>>   include/uapi/linux/netfilter/xt_dscp.h      | 6 +++---
>>   include/uapi/linux/netfilter/xt_rateest.h   | 4 ++--
>>   include/uapi/linux/netfilter/xt_tcpmss.h    | 6 +++---
>>   include/uapi/linux/netfilter_ipv4/ipt_ecn.h | 8 ++++----
>>   include/uapi/linux/netfilter_ipv4/ipt_ttl.h | 3 +--
>>   include/uapi/linux/netfilter_ipv6/ip6t_hl.h | 3 +--
>>   6 files changed, 14 insertions(+), 16 deletions(-)
>>
>> diff --git a/include/uapi/linux/netfilter/xt_dscp.h b/include/uapi/linux/netfilter/xt_dscp.h
>> index bcfe4afa6351..22b6488ef2e7 100644
>> --- a/include/uapi/linux/netfilter/xt_dscp.h
>> +++ b/include/uapi/linux/netfilter/xt_dscp.h
>> @@ -15,9 +15,9 @@
>>   
>>   #include <linux/types.h>
>>   
>> -#define XT_DSCP_MASK	0xfc	/* 11111100 */
>> -#define XT_DSCP_SHIFT	2
>> -#define XT_DSCP_MAX	0x3f	/* 00111111 */
>> +#define XT_DSCP_MASK	(0xfc)	/* 11111100 */
>> +#define XT_DSCP_SHIFT	(2)
>> +#define XT_DSCP_MAX		(0x3f)	/* 00111111 */
>>   
>>   /* match info */
>>   struct xt_dscp_info {
>> diff --git a/include/uapi/linux/netfilter/xt_rateest.h b/include/uapi/linux/netfilter/xt_rateest.h
>> index da9727fa527b..f719bd501d1a 100644
>> --- a/include/uapi/linux/netfilter/xt_rateest.h
>> +++ b/include/uapi/linux/netfilter/xt_rateest.h
>> @@ -22,8 +22,8 @@ enum xt_rateest_match_mode {
>>   };
>>   
>>   struct xt_rateest_match_info {
>> -	char			name1[IFNAMSIZ];
>> -	char			name2[IFNAMSIZ];
>> +	char		name1[IFNAMSIZ];
>> +	char		name2[IFNAMSIZ];
>>   	__u16		flags;
>>   	__u16		mode;
>>   	__u32		bps1;
>> diff --git a/include/uapi/linux/netfilter/xt_tcpmss.h b/include/uapi/linux/netfilter/xt_tcpmss.h
>> index 3ee4acaa6e03..ad858ae93e6a 100644
>> --- a/include/uapi/linux/netfilter/xt_tcpmss.h
>> +++ b/include/uapi/linux/netfilter/xt_tcpmss.h
>> @@ -4,11 +4,11 @@
>>   
>>   #include <linux/types.h>
>>   
>> -#define XT_TCPMSS_CLAMP_PMTU	0xffff
>> +#define XT_TCPMSS_CLAMP_PMTU	(0xffff)
>>   
>>   struct xt_tcpmss_match_info {
>> -    __u16 mss_min, mss_max;
>> -    __u8 invert;
>> +	__u16 mss_min, mss_max;
>> +	__u8 invert;
>>   };
>>   
>>   struct xt_tcpmss_info {
>> diff --git a/include/uapi/linux/netfilter_ipv4/ipt_ecn.h b/include/uapi/linux/netfilter_ipv4/ipt_ecn.h
>> index a6d479aece21..0594dd49d13f 100644
>> --- a/include/uapi/linux/netfilter_ipv4/ipt_ecn.h
>> +++ b/include/uapi/linux/netfilter_ipv4/ipt_ecn.h
>> @@ -16,10 +16,10 @@
>>   
>>   #define ipt_ecn_info xt_ecn_info
>>   
>> -#define IPT_ECN_OP_SET_IP	0x01	/* set ECN bits of IPv4 header */
>> -#define IPT_ECN_OP_SET_ECE	0x10	/* set ECE bit of TCP header */
>> -#define IPT_ECN_OP_SET_CWR	0x20	/* set CWR bit of TCP header */
>> -#define IPT_ECN_OP_MASK		0xce
>> +#define IPT_ECN_OP_SET_IP	(0x01)	/* set ECN bits of IPv4 header */
>> +#define IPT_ECN_OP_SET_ECE	(0x10)	/* set ECE bit of TCP header */
>> +#define IPT_ECN_OP_SET_CWR	(0x20)	/* set CWR bit of TCP header */
>> +#define IPT_ECN_OP_MASK		(0xce)
>>   
>>   enum {
>>   	IPT_ECN_IP_MASK       = XT_ECN_IP_MASK,
>> diff --git a/include/uapi/linux/netfilter_ipv4/ipt_ttl.h b/include/uapi/linux/netfilter_ipv4/ipt_ttl.h
>> index c21eb6651353..15c75a4ba355 100644
>> --- a/include/uapi/linux/netfilter_ipv4/ipt_ttl.h
>> +++ b/include/uapi/linux/netfilter_ipv4/ipt_ttl.h
>> @@ -9,13 +9,12 @@
>>   #include <linux/types.h>
>>   
>>   enum {
>> -	IPT_TTL_EQ = 0,		/* equals */
>> +	IPT_TTL_EQ = 0,	/* equals */
>>   	IPT_TTL_NE,		/* not equals */
>>   	IPT_TTL_LT,		/* less than */
>>   	IPT_TTL_GT,		/* greater than */
>>   };
>>   
>> -
>>   struct ipt_ttl_info {
>>   	__u8	mode;
>>   	__u8	ttl;
>> diff --git a/include/uapi/linux/netfilter_ipv6/ip6t_hl.h b/include/uapi/linux/netfilter_ipv6/ip6t_hl.h
>> index caef38a63b8f..4af05c86dcd5 100644
>> --- a/include/uapi/linux/netfilter_ipv6/ip6t_hl.h
>> +++ b/include/uapi/linux/netfilter_ipv6/ip6t_hl.h
>> @@ -9,13 +9,12 @@
>>   #include <linux/types.h>
>>   
>>   enum {
>> -	IP6T_HL_EQ = 0,		/* equals */
>> +	IP6T_HL_EQ = 0,	/* equals */
>>   	IP6T_HL_NE,		/* not equals */
>>   	IP6T_HL_LT,		/* less than */
>>   	IP6T_HL_GT,		/* greater than */
>>   };
>>   
>> -
>>   struct ip6t_hl_info {
>>   	__u8	mode;
>>   	__u8	hop_limit;
>> -- 
>> 2.43.5
>>
>>
> 

