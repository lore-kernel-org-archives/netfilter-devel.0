Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D453CA491
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2026 08:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773131151; cv=none; b=BHYedvi1JMF3E2kNNeCBqXHDKzxer1+DKJsX5kzp+/zEcIIeO/6P1xoAIgkjGUeTDev9Ct2w2DixE05BpvbNwubBO+dlabkD4HlX4FJSwB9VYcj5mXhMDZYpN7HACDwhPRtW/fPcgS+DAMcJMn1P4OHSCR5I1cczAMogAvcxPtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773131151; c=relaxed/simple;
	bh=2QCzLp0F2pYx6+dlRlsKBe0b3nFaOmqYmIDT/PUKLd0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DA1ZCXLWj1qsPR9hFYqhUhXYH6fLbU8rTXAWoyUZvN4M36ejl5pSroxWZ7YqFSeFbYevVGQ4Cr8ntXWSMJIg6oYekscpH60WbFO4hjffq3BftOtMIFBwz4Qn4HMoLE/23o8vRYne545H//4bombAOjV2Vm5uKxz2ZhZjqFm/Yyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZvLRhApr; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZvLRhApr"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-66281b1018bso2988021a12.2
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2026 01:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773131147; x=1773735947; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Oly3B87PA63gHRv66eFhTHd4PtYqp9cSgK81C/xTgFU=;
        b=ZvLRhAprredcnxq0ktx/IeNW4ILpm1nZeQiYEnsgEWvkHz3IMvWdVTbJJt97d9nBTm
         98LoiMW+VXShfrcxWRGvGcZZGzE0iBrDQascT32v6DTZYuGgn+3Fg3l1TZRrpwl7D4TJ
         xaasv0PN4RqciBhPbyw7rIi9nBbBS0bs3QSN7MrtA46BcoKRcz+7qUsrzyHQCWjkDpYe
         YZ+GF4rvYl2BsfYWvAvpDu0LG45rl3U60FAHRJQqN23SXRmttlABWmNCB+5NNsvq1iUW
         8cmr+Uk5SwIHu6hv4w5nmtoNxWWi0BeigDZF+3zvQgtRODWb++rAfvxEMbKEkiLZFYDz
         2l2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773131147; x=1773735947;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Oly3B87PA63gHRv66eFhTHd4PtYqp9cSgK81C/xTgFU=;
        b=XgAcF5PuJRBV7s5rJi5/MnWP8/hmswyUvWmP96hWZUYEi78gLRDGV+qJCbsTwZ9NdS
         R+/sqZ8m4ydv7lMQnUX78qFfdPlhrTHZ22aIGW+vIEktPMdO2M5CdvhgXpy9enKnQuJ5
         B7+tjgCKcW/PWKUYgIin4juvEcjw4IKc38XtQM/FP75z0p97xnvQIH8UPNLkhwvJdz4Y
         PK51V5NG7LhSRB64X0ZddsitpyCg0FTEz4iDzl63JiDSOp3wCD2ff5U6jnTinLsF86ea
         +uW3hkhgV402Yzjh9XoYKD3DmhF9GR3ryS2o92ETwNO7iQ6OxrL4hujajahYO1MLdXDt
         Lbmw==
X-Forwarded-Encrypted: i=1; AJvYcCUfuMVhzWZDuoxzhElgWtK6zAcf8SuIsCVrvsuX7o55zs1tvDcU4mdF5sxtwb9XkfDDsxZywMrMkJE3yLAOC6k=@vger.kernel.org
X-Gm-Message-State: AOJu0YyT3/qKcLeDHYm1X4z4ghDgJIQBwo+BBw1PbkhUcpQ/b24LZKSO
	gQBZgoKcw2oQQ2z1lLR57WEVi7wX6RbbEeDGQmTO7QJ2nqKRSLVMLohppU5PzQ==
X-Gm-Gg: ATEYQzzCBDUblEsL4BwIsxNmkKYEKvOt6zcGc9fs5A4Uu5YgRcJX7Z5QtiUKpflrTi4
	cRZEbK7VK16kgyAmU838Uz1yeiAN1z9E22QVgUGIobIPvfdPmJdmd5BHGTwHd2Ye94GEFx+WHqQ
	XyU25KrXto8fEr4vDM+0rX2vQ3WEXPVEWlFqzHiGBe5srWp5fV1O3toD0p7XMhdzJj6XM4NTtZl
	0jBKMhFt64ynx03OiNeOMac5BsAFezKrlga9BZzbBnbPclgknY37dzipsevcXCVMjIOgCwSfE2p
	8GFkAdMtKKP/+QQOeyUIRWsr2qIk3eDRiYdQqnGBe5H9Tvwm4TqfUICoCHH5AS70d8tIhCHf/wN
	/y2eJnoCM2xgQ8Lt2HOYm+Bzdm1jcHO545lmldyXZR58lSiM7Su4hy8X1AHfJUHSxnaSrncaRlR
	l9lviisq5d7TrLOKpFlHVqa302Y4ZR/fGRwzvdxZVOB3L9MvqQU0s5iHWG/8RaFUj7eO9qcUvrs
	HXhXoisiVGtRxU8P/QhNRVL6oVPrJrplbm83+N6KqdSmkw0qVjfp91cQhRJtwKRMmSh4NxdNygh
	6vP1kZLflh/InfBosUVqVWQW8lC2yMWskw==
X-Received: by 2002:a17:907:97d5:b0:b86:e938:1b3a with SMTP id a640c23a62f3a-b942dced156mr805331566b.17.1773131147211;
        Tue, 10 Mar 2026 01:25:47 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b942f139e24sm460611466b.38.2026.03.10.01.25.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 01:25:46 -0700 (PDT)
Message-ID: <5f8c4194-5066-4a55-898f-257bfdce4a6c@gmail.com>
Date: Tue, 10 Mar 2026 09:25:46 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 nf] netfilter: nf_flow_table_ip: Introduce
 nf_flow_vlan_push()
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
 netdev@vger.kernel.org
References: <20260227162955.122471-1-ericwouds@gmail.com>
 <aa86Ai1FRuJzthEF@strlen.de>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <aa86Ai1FRuJzthEF@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/9/26 10:22 PM, Florian Westphal wrote:
> Eric Woudstra <ericwouds@gmail.com> wrote:
> 
> Hi Eric
> 
>> With double vlan tagged packets in the fastpath, getting the error:
>>
>> skb_vlan_push got skb with skb->data not at mac header (offset 18)
>>
>> Introduce nf_flow_vlan_push(), that can correctly push the inner vlan
>> in the fastpath. It is closedly modelled on existing nf_flow_pppoe_push()
>>
>> Fixes: c653d5a78f34 ("netfilter: flowtable: inline vlan encapsulation in xmit path")
>> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
>   
>> +static int nf_flow_vlan_push(struct sk_buff *skb, __be16 proto, u16 id)
>> +{
>> +	if (skb_vlan_tag_present(skb)) {
>> +		struct vlan_hdr *vhdr;
>> +
>> +		if (skb_cow_head(skb, VLAN_HLEN))
>> +			return -1;
>> +
>> +		__skb_push(skb, VLAN_HLEN);
>> +		skb_reset_network_header(skb);
>> +
>> +		vhdr = (struct vlan_hdr *)(skb->data);
>> +		vhdr->h_vlan_TCI = htons(id);
>> +		vhdr->h_vlan_encapsulated_proto = skb->protocol;
>> +		skb->protocol = proto;
>> +	} else {
>> +		__vlan_hwaccel_put_tag(skb, proto, id);
>> +	}
> 
> I did not apply this because I'm not sure if this preserves correct tag
> order.  Can you clarify?
> 
> Lets consider vlan-offload-doesn't-exist case.
> 
> First loop pushes vlan tag 1, we get:
> 
>   [vlan1][inet]

Always !skb_vlan_tag_present (all vlan tags are pulled before the push
in the fastpath), so vlan1 is always stored in skb->vlan_all.

> 
> 2nd items pushes vlan tag 2, we get:
>   [vlan2][vlan1][inet]
> 

The second is pushed directly [vlan2][inet]. At a later moment the
contents of skb->vlan_all is pushed by SW. Ending up with
[vlan1][vlan2][inet].

> Now lets consider with-offload.  We have one tag only, so we get 1 skb with hwaccel
> tag in the sk_buff.  This is fine, HW will insert it for us.
> 
> But now lets consider two tags:
> 
> First loop pushes vlan1, we get the vlan1 tag in sk_buff vlan info.
> Packet is: [inet].

Correct, so same as SW, vlan1 in skb->vlan_all.

> 
> 2nd loop pushes vlan2, we get:
> 	[vlan2][inet].
> 

Correct, [vlan2][inet].

> Now, when packet is transmitted, where will the HW insert the tag?
> 
> [vlan1][vlan2][inet]?
> Or will this be [vlan2][vlan1][inet]?

The contents of skb->vlan_all is pushed by HW. Ending up with
[vlan1][vlan2][inet], same as SW.

Hope this is enough to clarify, but you can double-check it looking at
nf_flow_tuple_encap(). With 2 vlan tags, the contents of skb->vlan_all,
is always vlan1, the first in the encap array, which is the outer tag.

> reading though the SW-side (no hw support), it seems it will do the right
> thing (i.e.. the hw tag gets added as the inner tag, right before inet
> and not added as outermost tag.
> 
> Can you confirm thats the case?
> 
> Sorry for not responding sooner, there are lots of patches atm and
> I forgot about this one when I yanked it off the previous pull request
> at the last second.


