Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681ED3AE1A2
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 14:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075023; cv=none; b=El9ojCoNnU32d3uFNbIsDVU8VSPxPCzsco8l8dAJbnh+BtbwDjKXZyvw7X06lHumlBY8UwZ2mBGqzfuHtvEeYot+ohvH6ryNqO5cryO8p0e+TKL8skI53fNQHKpmy69dgIdv00wF4Ssx3gCAcFIZNf0z2gi/RP56noxeHcdet9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075023; c=relaxed/simple;
	bh=T6MDdKbko84Uwd9MzLgywE7OFmPahDIumYMkMRmd5nA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PXEWBGUhdFjBnnpHO6lvQ47cvlHv5jTngMtUrqyqybzWB0Dt/ZH47dbyTd4u4sBy+uU8YBRZKzSBQKcwZHqOD2jKmpYnuqU81Q6od7PKuzUvxZ1UJiQYG76fw1Sk9BGlzo6qryLKJm0iLxILTlS7kRUHOk6hImopIdypzcSb3PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JEzJ2GXx; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KRptOCDc; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JEzJ2GXx";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KRptOCDc"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69F9jTCk2809293
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 14:37:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	F5JVHKyejEtUCLdAn6R1F3s7ZWDsoImMLIjCIUZY0aQ=; b=JEzJ2GXxaDIbnVOH
	D5BOy58/27ugfft59gQE0PEBW8p1AFDkphK4E7mjLPruMtvw46T+ite2x1XJYUx0
	rPp6+xFsEY5TflSms1pZMhC4l5umMJDIjNOYoRBgThmvfQHx475zDeS9oHb1sS6F
	vpvch4HwqJfCfGHapXneYsLZyyglqimX5a3I8CNNvh7/+74AjCsDyLOAMsIj9SCY
	QxI2pCKGra9bSunaj64LHxt/9ITXhAfxrg6ho86/WwYmi3q3h80vsSwDhGyB/orF
	MOxzZvxZWXPyELto2qcKyPcob/Jjnk9LHBaMs9WioJOyfsupmQoqFbVDfb0Jm3Kx
	ewd1Sw==
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4han54u2yw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 14:37:00 +0000 (GMT)
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-139b62317d0so19946898c88.0
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 07:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792075020; x=1792679820; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F5JVHKyejEtUCLdAn6R1F3s7ZWDsoImMLIjCIUZY0aQ=;
        b=KRptOCDc8qnfJqBrQcR1BkwZtj4G+slxQNtvwsMYN7ipQ9xSj3WcOZbgwxJTrXBWFD
         ZMJqHTQQRuecenrOxAWUL96ZsrlFczBoZkGjoSmzhBUgEuNOk9ui/1QIH7ybgGWobjIu
         3lC3PslXLYxF580TgUzIimFAlAnjnASuwoMohHw7MBVeznFaIfsUmUVY7Ppb7HoubxLZ
         UPCbh4fY1z0liGIQZehJ3Kef+E+TsQZDQoz5Dkh/ULsypK8Aiv9bXWiDWwfRqmyPoq7K
         gWRR0wnCXQJROq7Z8iDPoztIf1DS2Y14OvqM8l2mzFdhUFHTbPBegHmxbsYHKX89pP98
         WIfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792075020; x=1792679820;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F5JVHKyejEtUCLdAn6R1F3s7ZWDsoImMLIjCIUZY0aQ=;
        b=RNfJ5NJhw6S/hwqK/S0BJY96x1YQYGnCfr3r1WAHH9Eh0z6ErJIjpiF/90Wr8au3gl
         4zBbbPxw1vAZiJaA/Aqe6FW3jwkoGoh9oMh6VijZXKhQWhVxay76AgT7akLBFBmzo2Ex
         e92YeijPolA5EkByCo/eKyc2ZKzL1i/7UlyqePNfJyuyZxcGYxvF65bb1E0TxaaQJjPo
         qmrK1t1Q01dYiAzjDdn8uyY5Z8ZdLXDzt5HUyS2xaLRIFrk4QyZQxNi088nZvXjtelha
         NVIEVXWGtm6WnBHg55+lC/eZtQwfEUu/dyqjnOkuN/dpDt2yaYAy1SAnEw6dCu3qj9jH
         YprQ==
X-Forwarded-Encrypted: i=1; AKwUvBx1HJ7omwJ3DlAw4/vlQKJt17EtFX3CpeOG3qfv/neHn0zDPI4nchKHMW1i2ssOAjq8Q9xs9uWEo/oW3z9Wu8s=@vger.kernel.org
X-Gm-Message-State: AFq9FYLdgzuMtxmxwWXuRt8ksb4zoCxg8NntY8riGY1v0jo8M/RcDPuJ
	tnShVFLV0eBUIBL0u5uMVX6T8rtV1ae6jgxxxySR/JwObKwDVGZbBExEESGyO7FeHkOHWxTIXGw
	PI0SQFhQW8Anh/zvMliRuUA+/yKb5c27u41axqp2NPrucD2+7fvWdbBKLSpugn1ZjFANfJ1k=
X-Gm-Gg: AYBFou0ZD/gaOj8qf6o/uagNLJzNTx3n38S+v+3ZaHha7SpWbuJwBXsHYwCJxKxyJSw
	qO27vDXg1zQtge5oIBovlMVshTy1799KjQe9h48di0n4z4W27kAawCs1lBlDShyuKi2pgNg39lC
	d1DMwQ8k776PvUmRPs9+gOs9EZsraa3deGdDn7Kh3M8+3R23Pb5YSKMs4zaFBEJr5Ifp4MSTpki
	5MMwkvrPmBDLxd2pZmPfhXndgWqHw7jBT8cv3PMH08+O1UroGUIEpc9py94gNvOKe77c5SbetJq
	4YP/kYis1asS+dS5aZB+cDnhKC1PxbiF50agi19wgK+l0bzj0dbrtsT2wq4+kPOTfNfpNRMlxwf
	VhEtfq4yfnbU8eUP/Bvgjsm1RYq7sX1PksT0CxvaxZRRfYo4cLD5Xrizs3thhO8haAP5N8P2yWt
	TaK1t9TueRmew0mxWiGOdohsruqxo=
X-Received: by 2002:a05:701b:240a:b0:160:8d8e:7e3b with SMTP id a92af1059eb24-16a6169584amr30994591c88.10.1792075019749;
        Thu, 15 Oct 2026 07:36:59 -0700 (PDT)
X-Received: by 2002:a05:701b:240a:b0:160:8d8e:7e3b with SMTP id a92af1059eb24-16a6169584amr30994552c88.10.1792075018910;
        Thu, 15 Oct 2026 07:36:58 -0700 (PDT)
Received: from [10.149.127.220] (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-358ee8a3387sm54782930eec.15.2026.10.15.07.36.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2026 07:36:58 -0700 (PDT)
Message-ID: <67d8e88a-eff0-4c8d-a030-b29b5d86f450@oss.qualcomm.com>
Date: Thu, 15 Oct 2026 20:06:53 +0530
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH net-next] netfilter: nf_conntrack: add ct expression
 support for netdev egress chains
To: Florian Westphal <fw@strlen.de>
Cc: pablo@netfilter.org, phil@nwl.cc, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20261006085844.2694120-1-hari.chandrakanthan@oss.qualcomm.com>
 <asTd69Buuk6PisMl@strlen.de>
 <fe6fe48c-df09-41be-acff-bbae33454bd9@oss.qualcomm.com>
 <as0HMjsgUvKd7dAo@strlen.de>
Content-Language: en-US
From: Hari Chandrakanthan <hari.chandrakanthan@oss.qualcomm.com>
In-Reply-To: <as0HMjsgUvKd7dAo@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=RYQFmFtv c=1 sm=1 tr=0 ts=6ad0e50c cx=c_pps
 a=JYo30EpNSr/tUYqK9jHPoA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=bFJ6oBsKsIU-QafAo2gA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=Fk4IpSoW4aLDllm1B1p-:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA1OCBTYWx0ZWRfX90PN+6w3zyR6
 CIYBsFRyR2bYI/Lpxxlh0SYuI9XqeeEHVSoTHHhdvDTYVDKr/cAK2r4Np3hEuV+WahAlK4ZIirY
 Z0aYYPZer7V/d2QJWcHiMum2EfH51DekJupN69y0mhIm/ckxEeJGbK0MyxrZZGGZIeT37zGEiK7
 TtzmMQme9gkqMY+wsGmdUjHsqrEkm2WfVgycPAUSuwG+tQWUbjg317nDiHUhEz+DHtdTm4TsJDx
 YCLzGpgCaKoL4V/EaGX3j4mEl1sDuLhT3rEW9VuKQTXzWsPQ6XynctY1/oJ2g7q7IE9KtCsKF8V
 qYpZOQMP3O+/93paWs/5iJIST8yiSaqxg4ApRxiH5afiqKacqB4zhES+LoZf7tzeO5eazdcvVTX
 aI1vIM/GcwIteoDZ6NazpkC5hpjhkARzn3fxPS5cn1W7iaDOTltOLq4wghZatOE/idS+OSFdIWE
 GkS9RrnKUnPziYV1X+g==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA1OCBTYWx0ZWRfXzw+wjTk0tJ3A
 n2HpwLOkKtRxp6TtPGVQGMq6osMTvmEacXOB0r3E0f6IpgNVgEDmOZX3c4BBEKoXM3bTvVdp30p
 Iy7/f/s3QBWiTa7G1SRQC5+OOLtwU8Y=
X-Proofpoint-GUID: cQf3SFjsfY8QovuLhw6kwGnEI4IvjgVB
X-Proofpoint-ORIG-GUID: cQf3SFjsfY8QovuLhw6kwGnEI4IvjgVB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 bulkscore=0 suspectscore=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610150058


On 10/12/2026 9:43 PM, Florian Westphal wrote:
> Hari Chandrakanthan <hari.chandrakanthan@oss.qualcomm.com> wrote:
>> I agree that enabling inet/bridge conntrack solely for netdev/egress
>> would be unnecessary overhead.
> Not following.  What is 'netdev egress only'?


By netdev/egress only, I mean that the nft rule with a ct expression
(e.g., ct mark set) is present only in the egress chain for a netdev,
with no other nft conntrack rules in inet or bridge chains.

For example, it may be possible that only rules similar to the below
nft rules are added at the netdev egress chain, with no other ct rule
in inet or bridge hooks.

nft add table netdev qos_table

nft add chain netdev qos_table wlan0_qos \
     { type filter hook egress device "wlan0" priority 0\; }

nft add rule netdev qos_table wlan0_qos \
     ether daddr 00:03:7f:01:50:65 \
     ip saddr 192.168.1.10 \
     ip daddr 192.168.1.20 \
     ip protocol tcp \
     tcp sport 12345 \
     tcp dport 443 \
     ct mark set 0x10

> Where are the skbs coming from, i.e. though what pipeline?
>
> Bridge?
> Routing?

In the use case that we are trying to address, the device is a Wi-Fi 
access point router. It receives the classification rules from a Wi-Fi 
client device for QoS prioritization of down-link traffic to the client 
(n-tuple to Wi-Fi TID mappings) via SCS. We would like to apply these 
classification rules on the access point router using nft rules
(ct/skb mark set rules) at the WLAN netdev's egress chain.
The skbs of interest that are processed by these rules at the netdev
egress hook are primarily expected to be forwarded traffic (bridged or
routed), before they reach the netdev egress hook. However, it is
possible that the traffic can also be originated from the device.

>> To address this, as suggested by Pablo, we are considering enabling
>> conntrack lookup/creation at
>> netdev/ingress. This would allow netdev chains to access conntrack state
>> without requiring conntrack
>> to be enabled for the inet or bridge families, avoiding unnecessary
>> overhead for netdev-only use cases.
> FWIW bridge conntrack is already problematic (see recent RFC patch
> to refag in INPUT, conntrack is pretty much routing-only.
>
>> Kindly share your thoughts on this approach.
> I think you'd have to explain your use case.
>
> I thought you only want
>
> skb-> mark = ct->mark
>
> from egress. That would imply something else already enabled conntrack
> anyway, else you'd have no conntrack marks set that you could read.

As mentioned in the previous comment, in the use case that we are
trying to address, the device is a Wi-Fi access point router. It 
receives classification rules from a Wi-Fi client device for
prioritizing downlink traffic to the client (n-tuple to Wi-Fi TID
mappings) via SCS. We would like to apply these rules on the access
point router using nft rules (ct/skb mark set rules) at the WLAN
netdev egress chain.
The nft rules at netdev egress chain achieve the below functionality:
1. If connmark is not set on the first skb seen by the rule,
    perform flow classification (based on dmac addr and n-tuple) and 
store the result in the ct's mark via ct mark set. Typically, this rule 
will be skipped when the connmark is already set for the flow.
2. If connmark is already set (for subsequent packets), copy it to
    skb->mark. Ideally, only this rule should be processed by the vast
    majority of packets for the flow.
There are three advantages we see in this solution for this use case:
1. We wanted to avoid incurring the cost of n-tuple match for every
    single packet at the netdev egress hook, by applying the
    classification rule (tuple match and connmark set) only for the 
first packets until connmark is set.
2. Adding the rules at the egress hook of the netdev restricts the
    scope of these rules only to packets egressing the netdev of
    interest, without incurring the cost of processing these rules for
    traffic egressing on other netdevs in the system or other hooks.
Hence, we preferred adding the connmark set rule in the netdev egress
chain itself, instead of the other hooks (such as
forward/post-routing).
3. The destination MAC address (Wi-Fi client) should also be available 
in the skb for rule matching, which is available at the netdev egress hook.

