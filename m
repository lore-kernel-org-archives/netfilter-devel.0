Received: from mail-wm2-f11.google.com (mail-wm2-f11.google.com [74.125.225.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83762559C83
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 15:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790090973; cv=none; b=EVufxE7hWEYpq6VSoViII/QZ7XVHdqrmCLYohbcjcdYXQxvSQUi/Jn4NIrcgohwnAI/z4XJx0Ndiznqfijof/XzZ6NQW8w3E0HwgSnQyvNph4EM8IeU9kj1JYvu30n+gAin/wkTgZnl5kd7KkCaybVhsFwZ9AH5FlH7iJ635jec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790090973; c=relaxed/simple;
	bh=WGdxf4JWgsj7qXEES4uwLAJCsB8IbrSJIDy8qKtOpcM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rbGDw3PY2jagVhwvP0kHtjX5i/Yqky+tg6G/PezI9OVki6gvwHuNP9HSnSJ6M81FFXCQpQ89iuB0qCXH9A9BHVgHpoNVhCCPQ++pnsj/YIjZkA8pzTImfSCtmBYYRIAmfFsnvHMRu7uTNIIzmNqWCVX9p+bSyDg/Y1CRZtIt4m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.225.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm2-f11.google.com with SMTP id 5b1f17b1804b1-49814d35686so1783495e9.0
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 08:29:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790090970; x=1790695770;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QFN5eT2UnxXyQbw0Bbtp+XvC5zxP4g1xuK4mAIg36L4=;
        b=LZlcVOYBZJniMX0n9IFsYEjZNqXBF/f5S83jnA2nXnzvBQqmnAqgEt5uN9g/W2haaF
         R/suZgMK7lCkrdDtGPFWTklcaier37FTE8PlrIKfVVnFpYRpiz5EL5Ss3lRUYcxFBGg4
         tpOa+e1mMXjUU/mFfOk/+XFHThXrFddtWBLmEF1B5PUQEeA0H9/WVmrU4Bg6vjuuR/OC
         wx7e0VbOf+ikeTMHUsfilXShJ22XqXQBP7HQu4Ukp6k7mUopHBRGmZ1qJ8Ab/9nkIKur
         Y0CRF8V262RrF0lZ52ei2+6LfrpawyCay5QkWUWE+vcDY+H2cw53WN6witqDOBoYRXcs
         6yKQ==
X-Forwarded-Encrypted: i=1; AKwUvBxUpfL7IEBofbkpPaTHz3/5MdaRSwt2wfsOeagtFIPxI1KLpjz+ApOSHGxaB36vs5380oyeUzEJDzmDnh2qYSQ=@vger.kernel.org
X-Gm-Message-State: AFuF++nHFVEy5xhQB2vB0XZaln/qaw3IZSnjZQWyFBIO2BXT5LByTgC1
	njRiEnGKhiQWWeEhQhKdkvtF5MTiLee/GYIhKR8SS4clIvnAE6nooXy6
X-Gm-Gg: AYBFou24hkp3deoJxknhLEoOQgIDFhzVo489kjx/oFL4VGTRV0AhDJxi/yJ3oIAzamk
	ncyUcCBifRoXTG/9ELjtQ/Ryrmhg599dfPfeN561aMkrNh/pTg8Ar7lLQbp8I+h3ysdMV8+z5GD
	c+juVNWiEjJfte41S/B6aGv0y5qE6ocqeE4uzpkQF4wBUttPQ2670tM5nzFZXMryMq09NhU4fF9
	XicV1c7no3XbIGqRuWNWna0B/NvcEOqCcIE0ZuzoFvkkX5ZKyG3a2Tbnhk+MVyJzZdoXeT/dtmz
	f0psh80rh2OwGUG1n6FgIkrFxGq1LS4K9BpPWbyj+keqdWWsDO9CXb5WJGhu1BTRXTeCyvIdeIB
	WYvdA3p9uHdrvxLia6h5OClqP4Bi95l9/8xaGjGMWrhMXbtoNEJ3XT1R+ns18QVukccG9vSbLrl
	GYwxhAGrawTeyCaupbqwwlf9Q11Vhspm0b7ZDpVIgTYjfyiFU60xd4YFEFJf4IXycRBaoCS/PMA
	ycduRa0QeX4D0SphlOmLDdq5SX+kuup8UxxKJ03jyDgfMM=
X-Received: by 2002:a05:600c:8b10:b0:49d:2936:8ad1 with SMTP id 5b1f17b1804b1-49fd8853834mr49427975e9.1.1790090969679;
        Tue, 22 Sep 2026 08:29:29 -0700 (PDT)
Received: from [192.168.88.241] (78-80-107-225.customers.tmcz.cz. [78.80.107.225])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fda8f04f7sm96753605e9.0.2026.09.22.08.29.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2026 08:29:29 -0700 (PDT)
Message-ID: <e3e001ae-cf08-408a-9059-4255de915110@ovn.org>
Date: Tue, 22 Sep 2026 17:29:27 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 2/6] net: openvswitch: conntrack: remove 'add_helper'
 dead code
To: netdev-bot+sashiko@kernel.org, i.maximets@ovn.org
Cc: netdev@vger.kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, aconole@redhat.com,
 echaudro@redhat.com, jhs@mojatatu.com, jiri@resnulli.us,
 lucien.xin@gmail.com, marcelo.leitner@gmail.com,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, dev@openvswitch.org, stable@vger.kernel.org
References: <20260921145655.3167436-3-i.maximets@ovn.org>
 <179008911774.2160803.5007856848467620850@kernel.org>
Content-Language: en-US
From: Ilya Maximets <i.maximets@ovn.org>
Autocrypt: addr=i.maximets@ovn.org; keydata=
 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
In-Reply-To: <179008911774.2160803.5007856848467620850@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 9/22/26 4:58 PM, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found more severe
> issue(s) in other patches of this series. This mail is only an FYI, in case
> you want to address the nit picks below when you respin.
> 
> Low priority / nit picks for your consideration:
> 
> - [Low] Concern: after this patch the comment above the helper call reads
>   '- nf_conntrack_in() was executed above ("!cached"), or - When…
> 
> --
> 
> net: openvswitch: conntrack: remove 'add_helper' dead code
> 
> This drops the add_helper variable in __ovs_ct_lookup(), since it is only
> ever set for unconfirmed connections while it is only read on the
> confirmed branch of the helper-call condition.  The helper-call condition
> is simplified to nf_ct_is_confirmed(ct) ? !cached : info->commit.
> 
>> diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
>> index a733029c28dd0..c20f096eef40e 100644
>> --- a/net/openvswitch/conntrack.c
>> +++ b/net/openvswitch/conntrack.c
> 
> [ ... ]
> 
>> @@ -821,13 +818,10 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
>>  		}
>>  
>>  		/* Call the helper only if:
>> -		 * - nf_conntrack_in() was executed above ("!cached") or a
>> -		 *   helper was just attached ("add_helper") for a confirmed
>> -		 *   connection, or
>> +		 * - nf_conntrack_in() was executed above ("!cached"), or
>>  		 * - When committing an unconfirmed connection.
>>  		 */
>> -		if ((nf_ct_is_confirmed(ct) ? !cached || add_helper :
>> -					      info->commit)) {
>> +		if ((nf_ct_is_confirmed(ct) ? !cached : info->commit)) {
> 
> [Severity: Low]
> This isn't a bug, but does the reworded comment still match the condition?
> 
> The first bullet now reads as an unqualified statement:
> 
> 	/* Call the helper only if:
> 	 * - nf_conntrack_in() was executed above ("!cached"), or
> 	 * - When committing an unconfirmed connection.
> 	 */
> 
> while the code only honours "!cached" on the confirmed side of the
> ternary:
> 
> 	if ((nf_ct_is_confirmed(ct) ? !cached : info->commit)) {
> 
> For a non-committing ct() action on a new packet in __ovs_ct_lookup(),
> cached is false, the entry returned by nf_ct_get() is not yet confirmed
> and info->commit is 0, so nf_ct_helper() is not called even though the
> first bullet says it should be.
> 
> Worth noting that the following patch in the series, "net: openvswitch:
> conntrack: fix helper UAF due to extensions realloc", rewrites both the
> comment and the condition to:
> 
> 	/* Call the helper only if nf_conntrack_in() was executed
> 	 * above ("!cached").
> 	 *
> 	 * For unconfirmed connections it will be called later during
> 	 * commit as we need to have all the other extensions allocated
> 	 * before the call.
> 	 */
> 	if (nf_ct_is_confirmed(ct) && !cached) {
> 
> so the mismatch only exists in this intermediate commit.  Could the
> deferral note be pulled into this patch to keep each commit
> self-consistent, given this one is tagged for stable?
Comments do not need to spell out verbatim what the code is doing,
it is pointless for the most part.  The current comment, IMO, is
conveying the intention clear enough.  It is also re-written in the
very next patch.

Best regards, Ilya Maximets.
