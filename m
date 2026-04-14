Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91BC38D005
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2026 12:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776168065; cv=none; b=dGAM0g0914zW0fQkzKCaqxIna9DpuY3bVP3tJWK8DwcDV47DZBn7DQisoO9hCQ7ebo+DLV2HZxm9FKpmIipiIqnnDCLZIEHEIvqZYE9oBapUQYpsIETOeKuuhHbWjEHpib9pmybzG+E0Hb3ZFyNjyreHkE30Q6ynUXsxya4pg9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776168065; c=relaxed/simple;
	bh=HXU24dwSM6A1AxV04g/pB5XxRZxXiy1LoONcd+loM3Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bH5TIeL7RmQ/AW8UGf9LO/A6vtwKEEOL3T0BhtTSBecZdm20nKxe14lESCv08SJUoJXn344xr+iMVUrt32FTb3Wa7FD+ujXjPOXFDyMY/SlD8ARGUZ+7zkPDQhkwSxfIhrZxRTlSAj7R7MYSySwFnImCv+afCITPVsXZ9RUcAUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iHnPXdgh; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iHnPXdgh"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b9c603ec2dfso736788766b.1
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2026 05:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776168060; x=1776772860; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2d7SDP4tYVNHF5RjK6Z4XWLo0StG4PwjgZJsw7TAjok=;
        b=iHnPXdghhNhZxQbXGPpMQAy/WghyKP2lAqDKIiIHKVP2ztJFDYMq53D48MDqEdRDO7
         6ViTDklUvBoUzzELRjXzMFeGMW8aH2tAUofR8+0D2flzvi0k0sDcF21Jla/JfFWLMGtC
         N19iii2ppBH+JXZsnOC1V/mfn/ZV0kgJPE0lBmm9z1tbJDqzqZ8DCML/yT1YGNrfYDpj
         cXQbZx8uP+MydG2v+QhdZ0+p3ACbAJcEwok93FL5OHndXiDkxBE9dzLDMbjzE46wgv2J
         anz+RbGttUpBQ21ZTv3zNiRyhk5CMV1NfSOpV8Hka03hd+MF61Kg1gT5bqQItvRRFtRv
         2MIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776168060; x=1776772860;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2d7SDP4tYVNHF5RjK6Z4XWLo0StG4PwjgZJsw7TAjok=;
        b=n7XAaKdSE+THJyLG2o2Gepj5MwtN33X6QWU7SS8X7UKwUZlIa3ElIkBx3x69oH7Pn9
         fVaOROCkLXE6DoKEV1hUxpFLIqZXC36pC7OBHg7if99fEy7qEl4fnF2/6F6nVLKBiR0w
         bbK/oYv5gcvSaOkDvwbsADzab6DFjB3lSDSNqyl+ohf4sBu5HcSnQ3LfxoqaHMy1dkt6
         XLcuY67WBLyh9eCuMHAlCKhi/36bF7ZBgdjM3LidUZpP6G9l/M3KhdMqyYClWyU9Pewz
         lqpOoUze+OVChxOtMbUeMZMrvzxpDGv/JkQT/7VgbzXY7yxk1nL5vgs1ggfsPzW9o7mu
         8QnA==
X-Forwarded-Encrypted: i=1; AFNElJ8NqDjqdCNkmt4+6Q+GVOC2eecU6xQphRrZ8F6ESejLZIQkgNwcS08hfso978aRmgQDPQz3b0S/3f8gYEnYYqA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyefFvDA9oDmYtSlXZrvxzrnN97OyKiV8pp0kHmg5Vri8Si7f6X
	AyT5CAkvPnapR6eb8IbXXu4GtFncqalHYf9qEdfEAuybgjMuLDLPiWkX
X-Gm-Gg: AeBDiesTQ0mO6QCj7dlbQZ2vsiGMDBUurqEsGTv0LJhSG/6m9FxQ1RpSAeyrMF0Ll/x
	E/vePh3oEQ/he8ykGe0XcJ5MLTGZuBXt+vc55IOKaK0bn7NtHoThIlPWbQe3NEBwvzZyGJa1vNh
	PC7uXVXOWs6TwUcFcQbzFSgKyPBtqGYWUQQ6vclAeJAlYA7TtEHeiPQjBHc611wc9wsdkO41Eqx
	2lTLJmq/IDv6fZ16XtUZgsvv2CLWwD76ej3AgVEPGKy3pLDiQDs0oxFivJqm/Be5zOUo+YBNffF
	W8t4zNiucS8q6pmG+l86HWw9XUXykDtK96P/N1TnUf0xxasA4Rx4Vlbl/JnNd2O+ugGc4yrOcRu
	hyCMZHjO+mIz527dFgp5jqlHI9cWia0+j7wXzireUiI9GaENCN8IFjCXYeIbmpJ7eCMM7/NXwdj
	yfUNTZekKHZ+F2WEWgVJQxH0tE1zaNN+BEhy9utoRCVwPKKG5G2d8enFkUbxBpZMpN7lqAf295N
	ACSL65jFq6GsN9mJGdNyC3oYBfNbbw3rEk6TRy1iUjGUH3Xbl9Ulql6/5BLk7x+rF1Wv0R5SODc
	rlTw8LGqaLdjjPjGTdg4ZBULZ+jdQHds3TL7uZWOaLOr
X-Received: by 2002:a17:907:a2c5:b0:b97:1009:7536 with SMTP id a640c23a62f3a-b9d72792d3amr965295766b.15.1776168059396;
        Tue, 14 Apr 2026 05:00:59 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6717ae8cb15sm1358146a12.19.2026.04.14.05.00.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 05:00:58 -0700 (PDT)
Message-ID: <0f0f217e-a32b-4c9a-ab65-1cac5c86c76f@gmail.com>
Date: Tue, 14 Apr 2026 14:00:57 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 nf] netfilter: nf_flow_table_ip: Introduce
 nf_flow_vlan_push()
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
 netdev@vger.kernel.org
References: <20260414112120.248744-1-ericwouds@gmail.com>
 <ad4nQzsbeF1S53zt@chamomile>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <ad4nQzsbeF1S53zt@chamomile>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/14/26 1:38 PM, Pablo Neira Ayuso wrote:
> On Tue, Apr 14, 2026 at 01:21:20PM +0200, Eric Woudstra wrote:
>> Calling skb_reset_mac_header() before calling skb_vlan_push() does
>> remove the error:
>>
>> "skb_vlan_push got skb with skb->data not at mac header (offset 18)"
>>
>> But the inner vlan tag is still not inserted correctly.
>>
>> skb_vlan_push() uses __vlan_insert_inner_tag() to insert the tag
>> at offset ETH_HLEN. But the inner tag should only be pushed, without
>> offset, similar to nf_flow_pppoe_push().
> 
> It is doubled-tagged-vlan that is broken, right? I observed this once
> but I have been burdened into a few things.

That is correct, both q-in-q and q-in-ad (that may not be the correct
terms, but I think it is clear).

>> Fixes: c653d5a78f34 ("netfilter: flowtable: inline vlan encapsulation in xmit path")
>> Fixes: a3aca98aec9a ("netfilter: nf_flow_table_ip: reset mac header before vlan push")
>> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
>>
>> ---
>>
>>  net/netfilter/nf_flow_table_ip.c | 25 ++++++++++++++++++++++---
>>  1 file changed, 22 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
>> index fd56d663cb5b..0086f8a1a0d6 100644
>> --- a/net/netfilter/nf_flow_table_ip.c
>> +++ b/net/netfilter/nf_flow_table_ip.c
>> @@ -544,6 +544,26 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
>>  	return 1;
>>  }
>>  
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
>> +		vhdr = (struct vlan_hdr *)(skb->data);
>> +		vhdr->h_vlan_TCI = htons(id);
>> +		vhdr->h_vlan_encapsulated_proto = skb->protocol;
>> +		skb->protocol = proto;
>> +	} else {
>> +		__vlan_hwaccel_put_tag(skb, proto, id);
>> +	}
>> +	return 0;
>> +}
>> +
>>  static int nf_flow_pppoe_push(struct sk_buff *skb, u16 id)
>>  {
>>  	int data_len = skb->len + sizeof(__be16);
>> @@ -738,9 +758,8 @@ static int nf_flow_encap_push(struct sk_buff *skb,
>>  		switch (tuple->encap[i].proto) {
>>  		case htons(ETH_P_8021Q):
>>  		case htons(ETH_P_8021AD):
>> -			skb_reset_mac_header(skb);
>> -			if (skb_vlan_push(skb, tuple->encap[i].proto,
>> -					  tuple->encap[i].id) < 0)
>> +			if (nf_flow_vlan_push(skb, tuple->encap[i].proto,
>> +					      tuple->encap[i].id) < 0)
>>  				return -1;
>>  			break;
>>  		case htons(ETH_P_PPP_SES):
>> -- 
>> 2.53.0
>>

