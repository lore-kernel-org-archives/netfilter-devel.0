Received: from mail-pj1-f67.google.com (mail-pj1-f67.google.com [209.85.216.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE6D10F0
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Jun 2026 01:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780882245; cv=none; b=rVhzoNL6fWDohzx6lue8tsxpiOBGADLjwBoKLKQbsQ7VRGcxv/20cXPtE8rJaLeP0ONKA7i6SZINOqLciJ9jRXjo0PwT9fYp1r9+nzUbDDJ4PQbJnY7p2UqUukrS3v3b+anEyMX6r2/lBu74Mf9Jp/+EMC5RCrOzG4dHBDgw2XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780882245; c=relaxed/simple;
	bh=zJiXo3RRFqOnhsScGItKBnGmdDnFK0/+vfz9iVVG4FU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n8IXXfPTsvMkLF9WrnHcuPwKUImQJSGfM1IyDQPQuPkMo0f/h7q4WdZXvHRYtlY9tAkDXUnJ5rEORTlhKPV/NG0I1n80vAJHKqkv9hzdqurfN26GBnxt/KGXhh0bkQQc8j6y/vvfPCCjQmz4aNbCNFFdrPnskLO56LuO+3pS6Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hCy1Vngl; arc=none smtp.client-ip=209.85.216.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hCy1Vngl"
Received: by mail-pj1-f67.google.com with SMTP id 98e67ed59e1d1-36ba706ab46so2467417a91.1
        for <netfilter-devel@vger.kernel.org>; Sun, 07 Jun 2026 18:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780882243; x=1781487043; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fwQbvMrmVvMXjhF3Jf8Hd1ArmS+2NmFXbE1fy1Pruu0=;
        b=hCy1Vnglz2nhHHg+Jv38NyXdIcQIfD8wfwHVlemQ2gIGWkw+vlvumS6oh70hVjfLV+
         zARXMPT5jwI/unewph0jRNO4x7re9ZvmuO9qKp22eJKHxH6O0uY5NCCGlSNjbltyqJ7Q
         Oaudcb0QWORlihjT6+8Ucfub6Z8VJVMxgGnIABNEm/f4bZDXKhpwwBmx5vdzXpBg4pkQ
         RoIhuf2ENb2Th7LphqTUorg1tElO/kvm7MpxU4QxrPdfVm/0dvlPINsVV5+nPfjxM1wG
         HKUNDA+wBzgoBxYP2Zur8Whbqd1hte9vNZm9KFC6G6XL9z2D6egjnTozn8FZRL7smeKK
         Jo9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780882243; x=1781487043;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fwQbvMrmVvMXjhF3Jf8Hd1ArmS+2NmFXbE1fy1Pruu0=;
        b=pixF3aTUSBPbpfdpwFhlg267VKa+F3X9ezE824wSi+wTTJ4gJSI+DKEF2xe/YD1G87
         Tw+keEnKhJznWrEcIaJAqnLn6fx1eh7NJWATHblrvOIgLkjHusYDunZ6sGXolYCeONZy
         N96e2mOgrTIod0wxqxqzIh199IW6jBdUu/Gj7WRiqfbW49GQ30xZ++nIwbLhrS7h9Tfv
         fANXn+sQCLft6TkRSafHM65cIVNbenA9IgJlp7yVLivhsldjTm1CH7oIKt/1/D3bY9So
         vP/7vUViswJMN0PUfrNQtXkA69aRa6JIe1Kkyk6uIr2PzuoC7HzGXcW0yCqCikKqvBVC
         Ecyg==
X-Gm-Message-State: AOJu0YxMrGfJNTe4yGn17mvgCcpRoy883gbciS09BYmdm1bwxrusRd9o
	K1zTxS5X8ia8hwDS9CDqbblwaTj7sjZziiMEHUkn+VHGzqnq400Vu2XL+su70ONnt/yh5Q==
X-Gm-Gg: Acq92OGT3Qpj4zdnSRY8OGX8eLGrF30EgwNxO5SjCWuZaOsJkB2qcJLawYB4E91rF4R
	JV6/b8EdqtweqcZwFf1DZOeKYfq0YRrqLwzb3X4/BhmXrNYrIFxk9YS/g1X4hWoeIBVLH0dlRSP
	PppHus/PdROgtB8i8Wg26bSLoc4h1dywVyw1IZ4xwhkaM6eZdgfEYVb+G1aZyp3szp9yx15ClYP
	m+n6k3YTs56cxGJ0Ytic2oLVzvciGY+cdjwxkv04I0Wk4n0N92sJDik6/z0pfr3fp9yfyeaYnEA
	qo4bD9guSTtnGHpj6EcSp+oTDobcWR+uqOH0ekP1q62CirwJKmyus2l0OWI5tD+pL7CgXmNljxu
	yOGwCXPZjKxmrxcG+HjajPwduuHlFEDq/YQjxnvgzE4FdQ0jeU8JVxMqAZzyptxskx+e+0gymaH
	am6t5RV+csRd8VHhJHkmBmnnVTn4tFsWifbbw58yca14o=
X-Received: by 2002:a17:90b:3503:b0:368:ed92:6f6 with SMTP id 98e67ed59e1d1-370ee830360mr13209405a91.1.1780882243325;
        Sun, 07 Jun 2026 18:30:43 -0700 (PDT)
Received: from [0.0.0.0] ([2a12:bec0:16e:590:1aa:f10:c238:546f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f70a285a1sm13888185a91.9.2026.06.07.18.30.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2026 18:30:42 -0700 (PDT)
Message-ID: <9fab271e-7a85-4925-b6b5-779e4ce11e7f@gmail.com>
Date: Mon, 8 Jun 2026 09:30:29 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf v4 1/1] bridge: br_netfilter: pin bridge device while
 NFQUEUE holds fake dst
To: Florian Westphal <fw@strlen.de>, Ren Wei <n05ec@lzu.edu.cn>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc,
 yuantan098@gmail.com, yifanwucs@gmail.com, tomapufckgml@gmail.com,
 bird@lzu.edu.cn
References: <cbc3a29c0654e8fcee30cb021d57883fed77fafc.1780630094.git.royenheart@gmail.com>
 <aiPYhDrNiGuyRtGo@strlen.de>
From: Haoze Xie <royenheart@gmail.com>
In-Reply-To: <aiPYhDrNiGuyRtGo@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/6/2026 4:21 PM, Florian Westphal wrote:
> Ren Wei <n05ec@lzu.edu.cn> wrote:
>>  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
>>  	const struct sk_buff *skb = entry->skb;
>> +	struct dst_entry *dst = skb_dst(skb);
>> +	struct net_device *dev = NULL;
>>  
>>  	if (nf_bridge_info_exists(skb)) {
>>  		entry->physin = nf_bridge_get_physindev(skb, entry->state.net);
>> @@ -92,6 +95,17 @@ static void __nf_queue_entry_init_physdevs(struct nf_queue_entry *entry)
>>  		entry->physin = NULL;
>>  		entry->physout = NULL;
>>  	}
>> +
>> +	if (entry->state.pf == NFPROTO_BRIDGE &&
>> +	    nf_bridge_info_exists(skb) &&
> 
> Is this check redundant?

Yes, that extra nf_bridge_info_exists() check was redundant there.

> 
>> +	    dst && (dst->flags & DST_FAKE_RTABLE))
> 
> ... this should be enough.  In which cases can we have
> FAKE_RTABLE and !nf_bridge_info_exists() ?
> 

In v4 I kept that extra check conservatively, to keep the bridge-device
pinning scoped to skbs with explicit bridge netfilter context while I was
still narrowing the condition.

After checking the actual bridge fake-dst path more closely, I couldn't
find a valid NFPROTO_BRIDGE case where a skb carries DST_FAKE_RTABLE
without nf_bridge_info, so v5 drops that redundant check.

>>  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
>> +	dev_hold(entry->bridge_dev);
> 
> LGTM, however, in last iteration sashiko complained that dev_cmp() in
> nfnetlink_queue.c should gain a bridge_dev->ifindev check so that entries
> are reaped in case bridge goes down.
> 
> Could you send a v5 that adds this test? Everything else here LGTM.

I also updated dev_cmp() so queued entries that hold entry->bridge_dev
get reaped when that bridge device goes down.

I'll send v5 later.

