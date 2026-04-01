Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD99E344D9B
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Apr 2026 20:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775074715; cv=none; b=NgSc+xAkeU17WS5LokyvOR5qVcpjUeVAx0cw0r4fozjBL2GQXqpIBu2STkixLxS/3AIeVFWB35uH+UaY63eeb1YPJbmYHmBrtqoB6CJ7jMTDLCiOWrJ5DvLbiUr4JGZKT7kdd7YucAGe9wz7d3gScYBasxS018mbTgvjHp8NNok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775074715; c=relaxed/simple;
	bh=jk7VLw/KAhmXilMy8xeoUIaGbSjTt+PD7EY420EKhrA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vo8b8WP4UMUmxD8GdGNhef16yrJ+qurulK/cJ6GMH3Xh7qis2o6xH7ghN9GMU1a0h+R20IRPoQWC82240bJIB8UXOyfQOLl74usPJJI0ISZUxJVkdYrouVMEx78GP4w0qMlhzXMBy+Wc70FHRWC6rpBTlspDb4Yh5qCAMMIC3IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aRD3DlL8; arc=none smtp.client-ip=74.125.82.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aRD3DlL8"
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-2bdcf5970cdso86517eec.0
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Apr 2026 13:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775074713; x=1775679513; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FuVesV2fdyK2YGJPS8+r0s4v7hrpvYmFmPxjsR85jlU=;
        b=aRD3DlL8pydj4JtXLB2hGSrirmO3n3TbkeVLoNzZFV/Wnzyn1n1FKThsNm1hXz6vdr
         CBrQ95iUSu97E6QBl8aTbIemxOw+E8Ynh59GO+eNhIeSa7FKY6UaU+vJRiGqVvMxasd4
         o9xPSb0Yb/yKFcO3+ZjdwoeFxp8KFmwr1eClpRiCMhypMj5DPPVAGgsb4FLETZUec5aS
         UGlL2IPoccw7W87MQ1XUbWdo7IYcejk2JJfpkMVtuZOKrwvg9cwnYm19uI3c3x3+8e42
         vRugwd7j+YJq3yNhCU1V5PMG59jyt1gGONoO5z28l+KnhyN2YINTNElMj1o3krILvTxh
         n1RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775074713; x=1775679513;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FuVesV2fdyK2YGJPS8+r0s4v7hrpvYmFmPxjsR85jlU=;
        b=C/hYuKQ3vtZQF/XpAzIY2qD8p21kq1ojs+74euRgA9v4DOljGCNYSc6bF0cioblJg5
         FjZlJTKVEU1NXGJArhE5TPkC8IwOlCQrKNGgld6KU1H+2EDrSDQCXaQGq6Cra4fHe7e5
         EEPVXx9Eh9hEZcHMEvdYP+KyaeC0YtTXUOxGC93iW/Kq16BwkW0P3xrPj2nv0vRUgdfV
         SvuTdON/opi1GIvYfWNcxQuehUOpnc+OPU7QQzzF+6SKX+St+Z0I1bIoQz82fz2WEJDv
         ZrnP524Po2WzgvWeSvwfvrGdf5CEW1fEjRBJhos3H4q8oxj4RpRNoDdaI9xEfUHPBIdB
         1zTg==
X-Gm-Message-State: AOJu0YyTm6/JhQBBz39xy22tqRYVT+wh9BeTu9uCzcn4T2ByXNXC/IbD
	wXl/s996IuXwJfJMHuSyzo7c5+IZbGNRmlvO0KkU58wbrvReWrcSutyV
X-Gm-Gg: ATEYQzyVdMbE5bTgmms8zUwOI3/dhfFrmjWyyO9z9vZb5oE4hg+KRPsXptNKS7shWvF
	UEvo5d6+4QZhblnoRpO0LS3HjMSmSV185knWA1hkKX2N7F3FmntEod88tA+Xb2yc9P2ntYdZ1zn
	jezQNyCmxAm635PjN0r8pC4g3Y+UmulfCSUTMvdQI+rc1zQTNoJmGAUtvT5sWaqf/DDyb56drN+
	HwgnqvOaEKGWz6LbD7/zjSHq6MrujgMegLZM8AXz3dhHBLbhgKOfMpp5Cqa0irmvS8CBc0X3Wko
	BZuerNMSbaljG8afj4oY09pIqpVPTar+ptNHZHUpPOogYiOGP1hbcLUu9GNsF9fSZML5C0GirLL
	D+H+ppd9Bfaoe0puvUeP01VANASIDYD9bqBCoKGIL5lonPkB+2Wcuwwdp108tKbmvfszkId/UHP
	jBlsYrQXiERcPw1pln6hXLT4H/bnkl3lhZatxlck1+1jAMDttL53DxSUuAoaBztOyPL56MC79QB
	pZm/Flbt5y4AnpRRXi84bQDxQ==
X-Received: by 2002:a05:7301:1695:b0:2c6:67b6:3acc with SMTP id 5a478bee46e88-2c7bcf6d89emr4316599eec.15.1775074712813;
        Wed, 01 Apr 2026 13:18:32 -0700 (PDT)
Received: from ?IPV6:2607:fb90:8f29:281d:4cbe:a647:edd9:c78c? ([2607:fb90:8f29:281d:4cbe:a647:edd9:c78c])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ca793ea2f2sm617855eec.9.2026.04.01.13.18.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2026 13:18:32 -0700 (PDT)
Message-ID: <1495b6f5-3ac4-4073-bba9-f2dfca9d46a8@gmail.com>
Date: Wed, 1 Apr 2026 13:18:31 -0700
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] netfilter: ip6t_eui64: validate MAC header before
 using it
To: Florian Westphal <fw@strlen.de>, Ren Wei <n05ec@lzu.edu.cn>,
 zcliangcn@gmail.com
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc,
 yifanwucs@gmail.com, tomapufckgml@gmail.com, bird@lzu.edu.cn,
 enjou1224z@gmail.com
References: <cover.1774859629.git.zcliangcn@gmail.com>
 <5267bb5b37997fa793c28c4b928a828cfb3a3927.1774859629.git.zcliangcn@gmail.com>
 <acuTO7bnCukKSpme@strlen.de> <acus9gpd-oKl_6dg@strlen.de>
 <ac1uqcDxsmmQ-oxH@strlen.de>
Content-Language: en-US
From: Yuan Tan <yuantan098@gmail.com>
In-Reply-To: <ac1uqcDxsmmQ-oxH@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 4/1/26 12:14, Florian Westphal wrote:
> [ Trimming Cc list ]
>
> Florian Westphal <fw@strlen.de> wrote:
>> Florian Westphal <fw@strlen.de> wrote:
>>> Ren Wei <n05ec@lzu.edu.cn> wrote:
>>>> From: Zhengchuan Liang <zcliangcn@gmail.com>
>>>>
>>>> `eui64_mt6()` derives a modified EUI-64 from the Ethernet source
>>>> address and compares it with the low 64 bits of the IPv6 source
>>>> address.
>>>>
>>>> The match unconditionally reaches `skb_mac_header()` and `eth_hdr(skb)`
>>>> after a guard that only rejects an invalid MAC header when
>>>> `par->fragoff != 0`. As a result, non-fragment packets can still reach
>>>> `eth_hdr(skb)` even when the skb has no MAC header set, or when the MAC
>>>> header does not cover a full Ethernet header.
>>>>
>>>> Fix this by first checking that the MAC header is set and spans a full
>>>> Ethernet header before accessing it, then using that validated header
>>>> directly for the EUI-64 comparison. Preserve the existing hotdrop
>>>> behavior for non-first fragments with an invalid MAC header.
>>> I find this rather confusing.  E.g. why is net/netfilter/xt_mac.c safe?
>>> I get the feeling that this patch is not sufficient?
>>>
>>>> +	if (!skb_mac_header_was_set(skb)) {
>>> Makes sense to me.
>>>
>>>> +	mac = skb_mac_header(skb);
>>>> +	if (mac < skb->head || mac + ETH_HLEN > skb->data) {
>>>> +		if (par->fragoff != 0)
>>>> +			par->hotdrop = true;
>>>> +		return false;
>>> Why do we still need this stunt?  Why not:
>>>
>>> mac_len = skb_mac_header_len(skb);
>>> if (mac_len < ETH_HLEN) {
>>> 	par->hotdrop = true;
>>> 	return false;
>>> }
>>>
>>> ?
>>>
>>> I also feel there should be a check for ethernet, i.e.
>>>          if (skb->dev == NULL || skb->dev->type != ARPHRD_ETHER)
>>>
>>> ... like in xt_mac.c.
>> There are other suspicious spots, e.g. in nf_log_syslog.c and in ipset.
>>
>> Will you make a patch to cover all of these?
> Ping.  Will you followup or do you expect us to take over?
Sorry for our late reply. We will try to send version 2 in 2 days.
