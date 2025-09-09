Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F87285CBB;
	Tue,  9 Sep 2025 09:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757409459; cv=none; b=Gt00/PD6oPVwch6O6RK12gc9PZVu83m3HP7MBXMjhJghivNA+LyKKVoRaIdbSNvrCTeSNvHTuxvPg5v8PxSX20hunQoiWurq5eBQVQQXvLG/Qh4C65YZBG6FTNHEItgYeSt89t9+VdcEEQZ0ytF0IS91yYxzWymoE3MOj67pLxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757409459; c=relaxed/simple;
	bh=IslIkKU+Rjs6YxP9rj6x3SrZ3vjFO+B3Wb8sbTWyDBM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KmEezjMGvoy+iqzIfa+XJ8swmF6N4Ij39crZZM0DhpvyZjxIkM0iY3nzAKjhb3NGfYyB2GXg8/DOCLzVxjRLuMMkDkY9NnUPw82zkYn+z1CeFNwbSxZehWK7mnMpWNSXc/W4ODoH+H+4quXVmf0hMfutNuxF/vZhrN649vflD0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VX2UcdQ5; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VX2UcdQ5"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b0411b83aafso881550166b.1;
        Tue, 09 Sep 2025 02:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757409456; x=1758014256; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RfbsNx4Ej0BLDskNnIJhjW/8RtalgNanAogt81Ea4Yg=;
        b=VX2UcdQ53kibktuwGcXsz4TG5Zw7Utu0wHBj7sK0ZrGPUdAmtqnO82tEoJZHgu+ro/
         GhSYkcbyDejv1SDBAEj4uhmFsYcbzQPtJR5BqnsDoOhrY6rETzxqz+CQ7Fl0mz8NVB5F
         uA+EuQDnMreAU5zge0qSjgCY/ZXTZhPflf36iw+BxHJgCqUmEp5kU/ZZo1D2FHWIeAvQ
         20V0aT7YWHwUVEh1ThobNJmbCvSA68AXemYTZyrxITw23cIkLBMrBcX9mvcwjZWLNIQT
         bz4DNpqHtJKgCY87zzTJieSSzLK8hLuGZCCSypVQBzD0cUCLdVLh3IDKWEBGx9ixwAC7
         RBjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757409456; x=1758014256;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RfbsNx4Ej0BLDskNnIJhjW/8RtalgNanAogt81Ea4Yg=;
        b=cTic7VcjADs32GpUWpLm4Q/Sg+OKT/ixHXKwsp/NLGxH0q5CCNktgbj4unj/+QX1n4
         d3b/K+JlZ4jjt28yC2YfiJlSsGl6irS9cNusrhf3wdV5folzYysxlvi4mW8Crj1KS+jG
         B5+nitglkAQ8Sa0QDjEjyJUe1mT2ocLJtSmFXPyRl0U3a/2ji+5UUTqylOJB/1dK0elF
         59ZbpPTFBCwyQtVKHG6gvmRlLh1ZNtsEEDupLw8x6u9N1s8DLWMp0xahKrqMyxnSIGVl
         EeOLkrySM6S2fzemrwZomLeuoRc3JARieWKdK6aZitLB2xeAhkH+dmHTdtJiI94DNYd+
         L7hA==
X-Forwarded-Encrypted: i=1; AJvYcCUl6rSCQnE5y8DrB5oWfhgJV8v9X2BLW3yEnYZHnIAZRzPLxHmd6mVLMAKYLKVmkYxtdHLI8GVRQ1E0jGpEHRVH@vger.kernel.org, AJvYcCXOkThB4pCzpEDdFCLPB5RZPQBUODAL+zYl+AQ8fIhR8QFJ5yr8Gkh5nWgATtQTD+jAMjM/uYk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHUCzjktt/6UU5UbWUG+wd3+rDW56/vnqYk3IoXrUXtceUyUNG
	Jpx9E7d40EkcK30XPx6wfKpXwB39dlHLaV7Gu/Gqw+CCeISKmxNz0D6B
X-Gm-Gg: ASbGncvOmRWnjrLVWYYVCIbCdKHn8CKaZs+NRSWHWj7ge9C+AXR6Hje04CyclMNAHyY
	B51azbbgx0t5Z9en801RznraCXKRbWJgCxQWjbTGhDvXsUhTjx1pj0g7aOEz58F0rzLVZrXv3Tr
	RONAxrslJy99kvn3TYtH28OhVsIkNrUpXuY8oEske3KCIV8mh194F57YW+ljkB8lkwcw1keexs5
	DqjJMsnpJR/yFzQpEhwfjbK6I2LKF0B5zo/AXDQSphgqm8es/3UNnltJ4fjR42PDwqawUenz/C7
	IK904gNyWLSDT81hVKsV2r6Mv4q/ozIjKqYXxkpZ3a+R8QDP1GyG+W6qpJ0bzw8Wo5H08t/mH4R
	hYkqGvUFS2G7El8kqdVSTrblI2XF9QZDcDO/uDzSuL9mybJVFNg58c1LAJzjapRVrcp3gUWTL3z
	AtPozEVCvuK7Te06SeeUjHesjWB4086CBtPZ9Gt9bHWsZCr8GQJ0tRa7cYyvjIvyd7MQpfZzWhc
	+rfsaMcyEu1j3r+TueUPwpJ8FffbvOUwmDI4/jdDICKnhZyPf278g==
X-Google-Smtp-Source: AGHT+IE/jQZDFMcQ7ZjTIQ0R6zDdXt1M25FWMQrxtYZGtY8aZZ0XMyUZqgcncvmNU5vjzg8lOByEVA==
X-Received: by 2002:a17:907:98d:b0:af9:8438:de48 with SMTP id a640c23a62f3a-b04b1737677mr1226832366b.48.1757409455477;
        Tue, 09 Sep 2025 02:17:35 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aff0d9b1b53sm2546820066b.96.2025.09.09.02.17.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 02:17:34 -0700 (PDT)
Message-ID: <49a5ae30-2fc7-4695-829f-1eb5b041aeaa@gmail.com>
Date: Tue, 9 Sep 2025 11:17:33 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 nf-next 2/3] netfilter: bridge: Add conntrack double
 vlan and pppoe
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>,
 Nikolay Aleksandrov <razor@blackwall.org>, Ido Schimmel <idosch@nvidia.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
 bridge@lists.linux.dev, netdev@vger.kernel.org
References: <20250708151209.2006140-1-ericwouds@gmail.com>
 <20250708151209.2006140-3-ericwouds@gmail.com> <aLyjgj5CP5KIvUdl@strlen.de>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <aLyjgj5CP5KIvUdl@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/6/25 11:11 PM, Florian Westphal wrote:
> Eric Woudstra <ericwouds@gmail.com> wrote:
>>  	enum ip_conntrack_info ctinfo;
>> +	u32 len, data_len = U32_MAX;
>> +	int ret, offset = 0;
>>  	struct nf_conn *ct;
>> -	u32 len;
>> -	int ret;
>> +	__be16 outer_proto;
>>  
>>  	ct = nf_ct_get(skb, &ctinfo);
>>  	if ((ct && !nf_ct_is_template(ct)) ||
>>  	    ctinfo == IP_CT_UNTRACKED)
>>  		return NF_ACCEPT;
>>  
>> +	if (ct && nf_ct_zone_id(nf_ct_zone(ct), CTINFO2DIR(ctinfo)) !=
>> +			NF_CT_DEFAULT_ZONE_ID) {
>> +		switch (skb->protocol) {
>> +		case htons(ETH_P_PPP_SES): {
>> +			struct ppp_hdr {
>> +				struct pppoe_hdr hdr;
>> +				__be16 proto;
>> +			} *ph;
>> +
> 
> This function is getting too long, please move this to a helper
> function.

Ok. At the end of nf_ct_bridge_pre() I've added:

>> +	if (offset && ret == NF_ACCEPT)
>> +		skb_reset_network_header(skb);

to reset the network header, only when it had been changed.

Do you want this helper to return the offset, so it can be used here?
Or do you think it is more clean to always reset the network header like so:

	if (ret == NF_ACCEPT)
		skb_reset_network_header(skb);

(Same question for nft_do_chain_bridge())

