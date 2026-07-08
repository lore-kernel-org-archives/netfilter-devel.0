Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3267E4CA272
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2026 18:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783535776; cv=none; b=stTfAkOkgqsEJXrOK/aaA3riyk6TJim0TIzVMqFyALv5dVIKaUydnHHFgNu+oxSHrq/cCT9GjuCJ9sKX/cSdN2bb5LejSNf59FyyqBvmBwSq5jiuE/F0BpmQwNHq2jmc4d1JN+O0pnLSbXHLRcodCJrn0s1jIeHObGeTIAxYORA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783535776; c=relaxed/simple;
	bh=G2H2imZ4fo8dNzfLfERwGQavgPhokh01V8hq8+UsP8A=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=f4NGW0IaVp7Z3bsCswyc1jeLW9HRt8F+b7zzYk5xy82E3lV+JDqNMi77XCd0WIxT5n5N7xP/48zwvoSFc/QV1ZOCQBLeg8QbkmmiJ3hLPZAHci8hlcqloVTHzdbWgAWYYTslXmyfB+MOxDXbh4kXfMH5aCaLRGusQuWSTY/TgOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tFfZ5hZX; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tFfZ5hZX"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c1276f8414bso122756266b.0
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Jul 2026 11:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783535773; x=1784140573; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ynaYupb3vfef1dEfTEhXs8EICy43K01H4C9YfW8Cml0=;
        b=tFfZ5hZXXxjXj1+2wdRAyN2GVcbzCsw7+Gr2Wf6qpf5Zprc03EGfVy1BPA/0cV3iXd
         0iujq5DPIteY0fIevU1sk+HKCuI956fQ3KSx3TB0gmmQoc58L6csZXp09pGigoiCsYGl
         bd1mWNO67FdKPTyrkfq9F8G41ufwGi+BBF+aEOONepGCykwdEUV+AC3K0dg1O2PJagKZ
         358rAap0xLsamRi/Pi0KSY/yhdRcGoVVOjbA7keI52/ETmFituwZXWYxF1yguwgTHs8s
         W8Bq/nCgyglAdpCZT/OZ7LmoZobDAgULLy8cFhLzys0K0QkzeNYRnfbaQloe8WS+1Mf3
         vY6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783535773; x=1784140573;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ynaYupb3vfef1dEfTEhXs8EICy43K01H4C9YfW8Cml0=;
        b=calB+JMW/GB+Dpkx84oEYpMxgyITvKCqHaZ1lDWdVMR6G8Lh73wjjxtKwxxNbHSeZC
         ltOcuoQaYSXXWkiCczWlPFuRxGOnjSFgQdvlZno52Q2/kouKu1Dovk5m0tKd26nY/rMI
         HxopZDnMdzenvMq5ar1dk+IAoUH4gepOSiOhtKBC7u3r71m0h0Ew2wHMDAGQCUi9wW7v
         TkS0IkykEY60Ercbv9ycU1DIbEOStB/Ycr9hvcJZ1dzn1SzCw/8DS6HBaVfT3hMKbjkU
         KrCpfUTIAs7DBt67pQci+hs1m0gACS6/+eIAS5wH+wD0A8IJl/4ktUBS62rjDmZBEjnF
         s4oA==
X-Forwarded-Encrypted: i=1; AHgh+Rp9MTvmdITywI5KNgiUpN3m6MAcJ8MSjpPrarE/qcfMVVqYmzxCB+sCx7LivrBcjUIDSw/dVGP120uVFryPO0g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5DDzIC4uAVseKPWDEybLbAhLtcivSwvVHyvsPL6vdPrRh9iNo
	CECExUXDzE9eJzICf+oDL4FRvhRGg+oH4PADVTBRzHhEMYgpJr3p+h4z
X-Gm-Gg: AfdE7cmF2QeyG9x5rcPgKH0dU3lTefRwNt5uR/XBi0kmNvMc9Qy9Ab6+CkG8M2/PsoV
	VcWZnwlSmVFveNqzaTuade9HvSdvFAUKwjINNji3SfAVoqJ6HFtaDuLwqBlgdzPbSiF3jXnmBcR
	J+05mBAfXvPmxi4oafz5Ei7NBavpkqgF6hZfdxD+nXxvbGZ/iA/P4TLG4txKJIBcSFlPmPpb9rm
	hz+sS30z8zRuZ6sIq4jtr4CpDpm688i0kLY0J6l9E0r/N8PNuSM9WbcjlTjdz/SgYksVkyyA8uY
	ELhM2cW+uLAtvHpBbLRWrEppIZvm5sNZBtgv1DtZK6Ae64YTC6fD8Nh+Urj5BAZwlqaKLo/3TGw
	YhFMAkdV7Wx1SFwxMnFcipyoP0li+UO1ts1+s6xe8B4GNSLbc+0jO1dJbXKpmoPK/4ZFgbaetDl
	2QcQHKSXEFUKwOAyCr2XyBrKmYjhRbLUZwxpX+NpAc4w9/CIq6yVcBeGDeXJZJEPMollohOpr1r
	r0NUvkZX4P5DJ0VmZqfnm0hM9ENu3rdEjtz1uJ8qrdyjOGxGNgq/eUY1bKWHoj0VXFUIrinOJzS
	McuSR7kJc00eS2LZYfJ0232OfxpigLszhQ==
X-Received: by 2002:a17:906:2e9a:b0:c15:c3bb:c90a with SMTP id a640c23a62f3a-c15ce18c8b7mr128361266b.35.1783535773134;
        Wed, 08 Jul 2026 11:36:13 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15d5de95e6sm115505766b.39.2026.07.08.11.36.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2026 11:36:12 -0700 (PDT)
Message-ID: <81c3bf65-b19b-4f80-aa8e-c0c4b3f5d6a7@gmail.com>
Date: Wed, 8 Jul 2026 20:36:11 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Eric Woudstra <ericwouds@gmail.com>
Subject: Re: [PATCH v12 nf-next 3/7] netfilter: nf_flow_table_offload: Add
 nf_flow_rule_bridge()
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, Nikolay Aleksandrov <razor@blackwall.org>,
 Ido Schimmel <idosch@nvidia.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 Stanislav Fomichev <sdf.kernel@gmail.com>,
 Samiullah Khawaja <skhawaja@google.com>, Hangbin Liu <liuhangbin@gmail.com>,
 Krishna Kumar <krikku@gmail.com>, Martin Karsten <mkarsten@uwaterloo.ca>,
 netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
 bridge@lists.linux.dev
References: <20260707091045.967678-1-ericwouds@gmail.com>
 <20260707091045.967678-4-ericwouds@gmail.com> <ak4dAXHDmTDRr7-b@chamomile>
Content-Language: en-US
In-Reply-To: <ak4dAXHDmTDRr7-b@chamomile>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/8/26 11:48 AM, Pablo Neira Ayuso wrote:
> Hi,
> 
> On Tue, Jul 07, 2026 at 11:10:41AM +0200, Eric Woudstra wrote:
>> Add nf_flow_rule_bridge().
>>
>> It only calls the common rule and adds the redirect.
> 
> I decided to use the new _unsupp() function, so we don't pretend
> bridge hw offload is already supported. We will need a driver before
> we can add this, this stub does not provide much. I guess your goal
> was just to avoid a crash here.
> 

No, I am already using hw_offload between bridged interfaces
on the mt7986 succesfully for almost 2 years.
It works dsa-port to direct interface (lan1 to eth1 on Bananapi R3) and
between direct interfaces (eth0 to eth1 on Bananapi-R3-mini)

It can also be tested with my bridge_fastpath.sh selftest script.
This script uses veth-device pairs to test the software fastpath.
It can also use 2 real interfaces interconnected in a loop of copper,
when chosen with commandline arguments. Then it tests software- and
hardware-fastpath. It also tests many different scenarios.

So this is why I've added it, as it is already functional. If a software
fastpath is setup correctly, the hardware fastpath is also functional.

>> Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
>> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
>> ---
>>  include/net/netfilter/nf_flow_table.h |  3 +++
>>  net/netfilter/nf_flow_table_offload.c | 13 +++++++++++++
>>  2 files changed, 16 insertions(+)
>>
>> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
>> index 7b23b245a5a86..5c6e3b65ae85b 100644
>> --- a/include/net/netfilter/nf_flow_table.h
>> +++ b/include/net/netfilter/nf_flow_table.h
>> @@ -368,6 +368,9 @@ void nf_flow_table_offload_flush_cleanup(struct nf_flowtable *flowtable);
>>  int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
>>  				struct net_device *dev,
>>  				enum flow_block_command cmd);
>> +int nf_flow_rule_bridge(struct net *net, struct flow_offload *flow,
>> +			enum flow_offload_tuple_dir dir,
>> +			struct nf_flow_rule *flow_rule);
>>  int nf_flow_rule_route_ipv4(struct net *net, struct flow_offload *flow,
>>  			    enum flow_offload_tuple_dir dir,
>>  			    struct nf_flow_rule *flow_rule);
>> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
>> index 002ec15d988bd..5566ebda7b7d3 100644
>> --- a/net/netfilter/nf_flow_table_offload.c
>> +++ b/net/netfilter/nf_flow_table_offload.c
>> @@ -740,6 +740,19 @@ nf_flow_rule_route_common(struct net *net, const struct flow_offload *flow,
>>  	return 0;
>>  }
>>  
>> +int nf_flow_rule_bridge(struct net *net, struct flow_offload *flow,
>> +			enum flow_offload_tuple_dir dir,
>> +			struct nf_flow_rule *flow_rule)
>> +{
>> +	if (nf_flow_rule_route_common(net, flow, dir, flow_rule) < 0)
>> +		return -1;
>> +
>> +	flow_offload_redirect(net, flow, dir, flow_rule);
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(nf_flow_rule_bridge);
>> +
>>  int nf_flow_rule_route_ipv4(struct net *net, struct flow_offload *flow,
>>  			    enum flow_offload_tuple_dir dir,
>>  			    struct nf_flow_rule *flow_rule)
>> -- 
>> 2.53.0
>>

