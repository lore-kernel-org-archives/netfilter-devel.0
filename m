Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DF7380FDD
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2026 13:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782738594; cv=none; b=U2lT+Y+/Kk1zz2SQdWQB20m5psBEIzfSnJNNKQT0QmhkLxI7bZhmWuPRiiPsGz6s2CUnZSnwIE2kykah23WCYqUmV156EZYGnVyfNuUicSz9E30t68vmboRl+iiJt1NV4teU/lGEM5bM41gE1y7T/DZx3p+I+G1FNzuYY2r7Oqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782738594; c=relaxed/simple;
	bh=MRnm09PMVz3zZlTQCCbSkxqgokpKHu3OelLb7bM8jtQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q9DQ9ovKRm1ZeupwUVTRP01duA+gJ+Gm/mq9WORpXjX7kYCZSu5MGGQonWit0LBTHOPYt43o9ReG3RdkXhfisbJxfSYyOYBzyMUg7DAEgI5OmOZ/+29H0aiqEpe6nGwGvhO0QVOSHCX2Js5kqG2LSaBFi+EE91HHvk13SaVUVE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.b=gMJDg1NA; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.b="gMJDg1NA"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7e6b5737bb2so3779567a34.1
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2026 06:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu.com; s=google; t=1782738592; x=1783343392; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C857Q2VDyItus3syZ+DUaEL05/aUtCKQC2sIRlYJkic=;
        b=gMJDg1NAajeSLhbu0RTZcMA51c0+/uo33amb51UJLNd1o2YVOaFkRWKjg/iPIKLDSw
         46XUc8VZocCD5dV08LbuyFxuwpGOeMsJSbSNr+1ITT4Dw+HINjDwWkW8wPm6BZSuY7IM
         CSQqPeDgY0QntvYjabDVFqnOPb21tnh3onwIo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782738592; x=1783343392;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C857Q2VDyItus3syZ+DUaEL05/aUtCKQC2sIRlYJkic=;
        b=RYGxvvZlTtC0et/3PrtOIbipX9Q0oSHbduGNXjew3h1OrGbBJvb2JNQ1lLR/wpd+nE
         2bZlsia9ktJE3cRFUskHZqN4xe2Vt+0D3SPhikq6cucCulfHmDLg4x4rGJRQTU9TwWqo
         rL5MNho8KrSvOiSOFKDWWTHiQ/s+0wv8zhq0ndhL6SbH1hQsYYUmd364SgtTh77BGtu4
         9hcZpRzTdGClIoFUyvUFJ85bwl1g5Kup1DZgAzwcjnOH/PA7pRCuPtvCMcFkREB5YNxG
         ESjqiUYLTA7vqdIr5yNNCbMNBbeQAQeG9Hwvcuhss51TdCOL+wnCWB2iYt2xcn5H41Mq
         wiWg==
X-Forwarded-Encrypted: i=1; AFNElJ+y7JgDAl77BEbCdmJLwNC5SdoDuNoh+I1oJhiEFVYTTkzR3xp0Ez2DXShsFF1DLt2TAgOjLN/ltJmm3oBRChk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSxfbYNcctwGOV3cjRA4wWMqSqRVItdkTq4VA1xCL5Y0J5qSW6
	bk+wXzZ6jijaQ1/SMGgOWI0XoctP8pvWle7A7PCTy1ghAPWm1Kdx1giCzn6zUsQcZw==
X-Gm-Gg: AfdE7cktMk/OdpPkkuJMR2CrhPKMTqzDeXIDPLN1+7e65bOXcTLKouZE1pKIJyu4XAj
	tZCl9v6amBF0EGJkM7xv4hYwluwkYEKSLDbEiDorwT+l7hmtqaP0hWTefW1tHUtGk2xtgHSIIMR
	om+ChmYRtJzH4jPTDmLtwfa1rw15GDWDkBEDi1gWC9SUyONo7g2CjKH5GdVI42Prn2lusEFJcGk
	X5ChpiXtIqAF9zmNNeNmhDfe5xqm7ZR55zLR0sbqB43AXPH+Ds66jCBbAbpyYxokhcBVfuu6Ac7
	y/rPDCIltMQ9oT9L9YsdCyaYyNDvsnfIrzoXP2yR+hAwWQ02c7G0Viz62e0i0cO02qoDFyE/YXs
	icP4B2qwtLUDYdPaePlh1jTaMv7X6hItUUvJUTsSg5TKnZssPjo1z7l4R/OCzy6kMKlqD9hopWK
	LrwFoEx1jPvkFd895myNa65/cuzDtlz1BcRw==
X-Received: by 2002:a05:6830:314c:b0:7e9:d3aa:e391 with SMTP id 46e09a7af769-7e9e91a5b19mr361337a34.6.1782738592071;
        Mon, 29 Jun 2026 06:09:52 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c54:4d67::1c9d? ([2804:14d:5c54:4d67::1c9d])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e9aa800350sm8796677a34.25.2026.06.29.06.09.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2026 06:09:51 -0700 (PDT)
Message-ID: <f315dd0d-211e-4d85-a06e-da422f015f1e@mojatatu.com>
Date: Mon, 29 Jun 2026 10:09:45 -0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] netfilter: nf_nat_masquerade: recalculate TCP TS
 offset when port is randomized
To: xietangxin <xietangxin@h-partners.com>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
Cc: gaoxingwang <gaoxingwang1@huawei.com>, huyizhen <huyizhen2@huawei.com>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260629093408.3927103-1-xietangxin@h-partners.com>
Content-Language: en-US
From: Victor Nogueira <victor@mojatatu.com>
In-Reply-To: <20260629093408.3927103-1-xietangxin@h-partners.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi!

On 29/06/2026 06:34, xietangxin wrote:
> Problem observed in Kubernetes environments where MASQUERADE target with
> --random-fully is configured by default. after commit
> 165573e41f2f ("tcp: secure_seq: add back ports to TS offset") TCP short
> connection QPS dropped from ~20000 to ~10000. This added source and
> destination ports into TS offset calculation.
> 
> However, with MASQUERADE --random-fully, when multiple internal connections
> (e.g sport 10000,20000) are mapped to the same external port (e.g 30000),
> their TS offsets are calculated as ts_offset(10000) and ts_offset(20000).
> If the server reuses the TIME_WAIT slot from the first connection, there is
> a chance that ts_offset(20000) < ts_offset(10000), breaking TSval
> monotonicity for the same 4-tuple and causing RST packets:
>    Client -> Server 24870 -> 80 [SYN] TSval=2294041168
>    Server -> Client 80 -> 24870 [ACK] TSecr=2846236456
>    Client -> Server 24870 -> 80 [RST] Seq=855605690
> 
> After nf_nat_setup_info() successfully assigns a new randomized
> source port, recalculate the TS offset using the new port and
> update the SYN packet's TSval accordingly.
> 
> Test results on 4U4G VM with
> `./wrk -t8 -c200 -H "Connection: close" -d10s --latency http://5.5.5.5:80`
> Before:
>    random:10712 req/s, random-fully:10986 req/s
> After:
>    random:21463 req/s, random-fully:19181 req/s
> 
> Fixes: 165573e41f2f ("tcp: secure_seq: add back ports to TS offset")
> Cc: stable@vger.kernel.org
> Closes:https://lore.kernel.org/all/92935c00-e0be-4591-ac44-5978c7804d57@yeah.net/
> Signed-off-by: xietangxin <xietangxin@h-partners.com>
> [...]
> +
> +static void masquerade_update_tcp_ts_offset(struct nf_conn *ct, struct sk_buff *skb)
> +{
> [...]
> +
> +		if (nf_ct_l3num(ct) == NFPROTO_IPV4)
> +			st = secure_tcp_seq_and_ts_off(net, tuple->src.u3.ip, tuple->dst.u3.ip,
> +				tuple->src.u.tcp.port, tuple->dst.u.tcp.port);
> +		else
> +			st = secure_tcpv6_seq_and_ts_off(net, tuple->src.u3.ip6,
> +				tuple->dst.u3.ip6, tuple->src.u.tcp.port, tuple->dst.u.tcp.port);

This breaks the build when CONFIG_IPV6 is not set.

.config:4948:warning: override: reassigning to symbol NET
.config:4949:warning: override: reassigning to symbol NET_CORE
.config:4950:warning: override: reassigning to symbol NETDEVICES
.config:4951:warning: override: reassigning to symbol NETWORK_FILESYSTEMS
ERROR: modpost: "secure_tcpv6_seq_and_ts_off" [net/netfilter/nf_nat.ko] 
undefined!

cheers,
Victor
