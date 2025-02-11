Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1F4254B05
	for <netfilter-devel@vger.kernel.org>; Tue, 11 Feb 2025 17:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739293373; cv=none; b=orBxC9h2YcS7hN2N+NLFJmGA+gRx8nEuCFdcz6XtSttAf6DuhU8b1Wh7yqyMemBf/htBOtcmfnb5pULnffEIbyQ4uwbNnL6oTIZqDIUCPEFavgp1mg5OqzaUFYBguChLpNluWy5PutA3NV1Ryxs2QTnLygJ+nV9/HDcgMwWWeeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739293373; c=relaxed/simple;
	bh=cl5VRTIaQVhnhX7Mp5CHjRfQCdJZoCwXZgpTFNL919I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R8BnHYF5/c1JnrA30Pv5pqRKlHw0xnVyjL1fppfhXloffcw9+eIXHyKxDAkq9yCZyJfaaTpz7WJWXTSeCaSYeURz3emID6ceWDl0jqYG3R+5Lkc25oSj9Gb4zGBG4XlTLGn9g5uehBoalJXJAlJgY7l4SlMMCdbOzE5f2tYjiXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org; spf=none smtp.mailfrom=blackwall.org; dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b=OjLotQ+E; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=blackwall.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b="OjLotQ+E"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ab744d5e567so1127974666b.1
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Feb 2025 09:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20230601.gappssmtp.com; s=20230601; t=1739293369; x=1739898169; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b/56BFQCA/x0+5Zxz4AvQg+9pW1+xObkEyrqUGNwQiI=;
        b=OjLotQ+EkgIV5vISUancQJtc0eeKOZMXVXSwgZe1m02PQqh3xxy0+mjYejvNijgYIV
         HXVtilq0D0SNYs8MA+VdjeVP1kmJ7sbs2MMPHKGHTwvrLKPnQXdAujeq1TBvdzIMzXLT
         W39uk+w4ZO8v5FCohIufqK28hcPTo3akvGGxH4c+39LgmS6HAMvJ5Rve8ep9cmIdjfVJ
         Zui4M562F11y15q9kICaksgfb6p+Br1A1Ue0kyW37GS8ZTkTdeTHmQjGs/mKTM8reVUY
         GWFxw+Jvw4ae1cS8RUVunFgMHKQvuBZv8n8AMfMMBY3MR8YR1nGIBRWbB+NYognomjUa
         JYyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739293369; x=1739898169;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b/56BFQCA/x0+5Zxz4AvQg+9pW1+xObkEyrqUGNwQiI=;
        b=Ia4MHRthw76V4PKdZEik2ILo+y4RLPVlLjKoyStbL8xUijHmoNU+8j6wW3yIt9k7Wx
         n2f125kCHwY8qpsd88rIdFhruxpsGm7DytcVLcwuJ+PPpQUolAkYjy0DE/mGE9/VI5Lh
         Ez8ifF7hi20GHk0x5LEx8nsj2zpylKj9MEamHh64y2jhYx3t4cV2poQcqMHlepQARt9i
         eE2U3rZHvUsqCZud17cmM7oisy5ZCK7M5dry+987agFZXy1zYCtQztGhhmUvio56btoD
         FumK6M383nqL212dU6W+HyRPARZvw26DDHveTsWnp/sdxrKjQtvbnNemAYUDBy94HBxl
         i4mQ==
X-Forwarded-Encrypted: i=1; AJvYcCUftKFYfIX7rdqB+A9eutoQDCufq/cDQM/8K/xttM2O3rn7MjffXsHXDvuNxEwr3KWZyoVS7vHGe9IBvZmemUM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKqt1Gvaqcz4QWAm1rTtu1vfRPmxUFYnH6oQTpkxyVwQDpmXsz
	aS1fD/rVcmboU6l/+Kj5TZbRFot68oBwlsnTplQDY3nOt9KhFKXgh4MIL7sR3Us=
X-Gm-Gg: ASbGncv94fnjchSZFwNgMpcubVe6ANnWxCDdleLWyQj1iittfcMvtWHfsawcMfEri8Z
	2MU+PDmN+IGisfSY7LBUCOMPq+ckWg7O2j0QhT9aRoEQyIMi7OnrCrerxRJhVFgtCGUQVj+Hi34
	jEScYQX06+FWvF27XWztYlDBznztJdG0zNkNVYU2csidMaxBrGBnaI8CRwcRO+XHmMX2tOQlkOl
	koh6gJuUz3Ie1xe2N5+WkF75gSOnAo+HvMX010XclpMBUY6ZAFfBuRAhYfD7CjRG3hs2Ae9gvI+
	MHL2I/gM9iqn6IGQS7C1KWD+xoCEo1C0e0pJGLyHYhBulx4=
X-Google-Smtp-Source: AGHT+IGAPbzjetBMyKn9xpkEx6mNiLaz6Iu+7FJStrC2CQYkHtGpuLCTUuKU+eMJA/ubyZG+xRvimw==
X-Received: by 2002:a17:907:7fac:b0:ab7:cd14:2472 with SMTP id a640c23a62f3a-ab7dafca27emr340636066b.23.1739293367291;
        Tue, 11 Feb 2025 09:02:47 -0800 (PST)
Received: from [192.168.0.205] (78-154-15-142.ip.btc-net.bg. [78.154.15.142])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab7b4e96185sm543848166b.86.2025.02.11.09.02.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2025 09:02:46 -0800 (PST)
Message-ID: <2609939e-fce9-42ff-93ee-890598437f25@blackwall.org>
Date: Tue, 11 Feb 2025 19:02:45 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 net-next 05/14] bridge: Add filling forward path from
 port to port
To: Eric Woudstra <ericwouds@gmail.com>, Vladimir Oltean <olteanv@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Andrew Lunn <andrew+netdev@lunn.ch>, Pablo Neira Ayuso
 <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>,
 Jiri Pirko <jiri@resnulli.us>, Ivan Vecera <ivecera@redhat.com>,
 Roopa Prabhu <roopa@nvidia.com>, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Lorenzo Bianconi <lorenzo@kernel.org>, Joe Damato <jdamato@fastly.com>,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Frank Wunderlich <frank-w@public-files.de>,
 Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, bridge@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org
References: <20250209111034.241571-1-ericwouds@gmail.com>
 <20250209111034.241571-6-ericwouds@gmail.com>
 <20250211132832.aiy6ocvqppoqkd65@skbuf>
 <91d709aa-2414-4fb4-b3e1-94e0e330d33c@blackwall.org>
 <1aa60578-ba4c-458b-b020-cff59b119bdc@gmail.com>
Content-Language: en-US
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <1aa60578-ba4c-458b-b020-cff59b119bdc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/11/25 18:35, Eric Woudstra wrote:
> 
> 
> On 2/11/25 5:00 PM, Nikolay Aleksandrov wrote:
>> On 2/11/25 15:28, Vladimir Oltean wrote:
>>> On Sun, Feb 09, 2025 at 12:10:25PM +0100, Eric Woudstra wrote:
>>>> @@ -1453,7 +1454,10 @@ void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
>>>>  	if (!br_opt_get(br, BROPT_VLAN_ENABLED))
>>>>  		return;
>>>>  
>>>> -	vg = br_vlan_group(br);
>>>> +	if (p)
>>>> +		vg = nbp_vlan_group(p);
>>>> +	else
>>>> +		vg = br_vlan_group(br);
>>>>  
>>>>  	if (idx >= 0 &&
>>>>  	    ctx->vlan[idx].proto == br->vlan_proto) {
>>>
>>> I think the original usage of br_vlan_group() here was incorrect, and so
>>> is the new usage of nbp_vlan_group(). They should be br_vlan_group_rcu()
>>> and nbp_vlan_group_rcu().
>>>
>>
>> Oops, right. Nice catch!
>>
> 
> Hi Nikolay,
> 
> I gather that I can include your Acked-by also in the corrected patch.
> 

Yes, thanks.

