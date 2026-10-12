Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33874534A9
	for <netfilter-devel@vger.kernel.org>; Mon, 12 Oct 2026 12:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791808093; cv=none; b=im5Uqj/y2YfaeB1j9CLBX8uVeobKnaukMM84S5bjVh5DC03rIlKgvVDrQLlB94scJp8GSY5j0JouUOtI/HDDoy1rUiUHOlVDZ9IEZbxKvCPPpkrjPAJWh2jG0y0QnY/a0W0NIy6cjsqkTuB9osqQiqNaMiPrKmkw9kjXY4Vbi/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791808093; c=relaxed/simple;
	bh=j1NuzG7okDyCIBmbWk4T9+gTMmJEPwWecx4vfBAD8Yk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EuW5DWJiKDqPdX0THjMTT1ps2UHHovx04KDD8g6adGxM2VSMxddZl///XKx0I562iMOu3qiIVqR/7tXbqVohx1F7TCUc6ddW+07OjsWuhiZd8gDfww8MkGkCuE74JYDn1jbDpA75M9VZgxhZBzuvjzWngF/VciOrINsmfFtWIh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dQYwo5Mj; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BQJ2fPuZ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dQYwo5Mj";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BQJ2fPuZ"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69CC0BI82275902
	for <netfilter-devel@vger.kernel.org>; Mon, 12 Oct 2026 12:28:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	OyL0SJk1xJCKjUnKWxUveX80pGedAgDOn+gj9J70eB8=; b=dQYwo5MjcKGHPJIr
	MlhgOtNKWALkqQL3bheJYCFbF9GAeimCGrQrNt109P0QutklaLcToSAQQ/PmzQWy
	nIiqMTnUU7Rdq4DRo5mMs4TO3lTg4uqmCCJRaUqs+4xGvzyGNoXsMLCjFSL/3hTV
	G0qY48CvAEpKg12fnzhXqdW5ohPRLaaD+6IQtcdp0XFAKlSi1rqFqiQs3nqzQold
	0MWDkbRzPJd7aVnsHyNR20qSeeb11n2ZeAe+YV4CfwGA8Z57ZVy5iCKX8VLRxRFT
	7f7bcgPXIHhJSJLA8OD6ZERn5AbMtr8DL+5cgYfxcB3XWUxF4XdAw7QJU79TsNvt
	4/ZnFA==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h8udq19xj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Mon, 12 Oct 2026 12:28:09 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3abfcf726dcso956593a91.2
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Oct 2026 05:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791808088; x=1792412888; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OyL0SJk1xJCKjUnKWxUveX80pGedAgDOn+gj9J70eB8=;
        b=BQJ2fPuZHO96J2YPDSDPZGgbOi6S2qhsr3WHM1DjX8w5Afn8hnRiMYSuoQLzUZ8UJa
         2ZTQzP1JAxd+qhKsTd2KDyX2hBByXqcp+wJH/Iv9jdoMFhm/fRe6kFGlQEnQ+D8OPl4v
         S8do9Wp4ZARNKfF4jhLt4NOXJ8M+03NEwUId6hUqqN12c5VlXjPwZtqIRKdCmreBuYhz
         hevsUYBca/MESQrYIwb4Wglz9p/5mltUIx+wnvCfSd+lqMjjFTt1rlzSq2eeQAdjrJMl
         O2bmx7nOHFFKU4s4/s/+RVO11sr6i/9D/BJNdObDvVHnyLF3Xd+YwvC4rFgcZV1j321e
         QEAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791808088; x=1792412888;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OyL0SJk1xJCKjUnKWxUveX80pGedAgDOn+gj9J70eB8=;
        b=kph6LLHXPVSR4FWA9BDHBIFH8qvY17THI7LdYFEs+0UKqIsWWbvVZo1bbrz5MzSgNb
         u8Oe9hYLKOSxyb4DAbh/JBunsT7EZN4oYZa4Imapo8N37pvbZ+6gSmRlG58PPhOA9wZt
         UbEAwPOs1oQmOwN5YoeCEw6Xtz5KZoPumdIW8/QEVvN/VwCXat1BsxpT7Vq37RNoLamw
         a9mqde/TQYB0fHnJ2gX79z1a+6UrgFariU+KEDt0C6a+7l+QICfd//g1qIMSXRrMwVyD
         4Efhu2PDNgcTBsGkm0+DrUsmeqry2tpRowWkY7T0q4QEMZtBcksiI8LkRqFE81aAyPW0
         EgBQ==
X-Forwarded-Encrypted: i=1; AKwUvBxuKA7ZuhUl2iDYP3FdRFydX3OCZZHzkMplQeSd5k4DaQm8a7qW4Y15L5Wm+KbeK75CEzdLrOAhZZCA6Pj019g=@vger.kernel.org
X-Gm-Message-State: AFq9FYLZOcF35VcC0LWPffeNqwgn4y4ZSexABYiRgJCgirUlDqLAggJX
	t67kvnGxjP7usktpsP/yZvmyPOxZAZ9e4b4W+TFS6WGdNdnGwHFI/ch04pI4Uo5yePBHyrkLGQH
	cJn6JbkP0Q8Qv4ReU0fhHuVbNH5TmMv3y8LmapmY+yFP3JrvGipaeaCw8HBDRIVyEIHUPMU8=
X-Gm-Gg: AYBFou0lf/je+36LGh1gA3ZiVk12nWlezHdWY2KUtOReXrg79K0SKswnN2z9u9CH839
	19Ig+y3Rt9sHRIp8SWjCDW6liBAY456+q9eTwKTu0pkkgRgzI598CxWiPi50Fk12K3B955E0SNe
	wvHFDlPBoEtmgjTDuT2mBWZCggUvn+UmxtLrRnaXz4n2sOKw8hudoQX8viOUOr3niMqmoSRtviy
	HcNwAu0pJA+wsr0YZ/AHtQVNjdsVP6viR/kGDfXeduVqlDvj4NAyeS9e2CPyjrv4n65W3yEukv2
	bNRkNSyaVlrj4/X5F2GQoNKOOtOsr4iiCy2yoL7+hEkX+UTvy2xKxrJv55cd3AE7YY+ouKeycIu
	SJ2npUyWUqg09D8RFxbcJgZC03cJjLrfthdwLCKXxDzyYcg==
X-Received: by 2002:a17:90b:3c8c:b0:3aa:6b5d:a018 with SMTP id 98e67ed59e1d1-3ab3af94c34mr7276487a91.67.1791808088319;
        Mon, 12 Oct 2026 05:28:08 -0700 (PDT)
X-Received: by 2002:a17:90b:3c8c:b0:3aa:6b5d:a018 with SMTP id 98e67ed59e1d1-3ab3af94c34mr7276466a91.67.1791808087785;
        Mon, 12 Oct 2026 05:28:07 -0700 (PDT)
Received: from [10.239.221.166] ([152.57.95.120])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab36ed0332sm17600087a91.3.2026.10.12.05.28.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2026 05:28:07 -0700 (PDT)
Message-ID: <dcdd3921-69db-4781-814c-6a83a7d3bbd7@oss.qualcomm.com>
Date: Mon, 12 Oct 2026 17:58:02 +0530
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH net-next] netfilter: nf_conntrack: add ct expression
 support for netdev egress chains
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: fw@strlen.de, phil@nwl.cc, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20261006085844.2694120-1-hari.chandrakanthan@oss.qualcomm.com>
 <asT_37n_6viz9dJa@chamomile>
Content-Language: en-US
From: Hari Chandrakanthan <hari.chandrakanthan@oss.qualcomm.com>
In-Reply-To: <asT_37n_6viz9dJa@chamomile>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=evJKXYpX c=1 sm=1 tr=0 ts=6accd259 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=8t6FrhTGQU2+Ya5TYW0Vxg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=oc923GDM-3h-CEzwMGEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDA0OSBTYWx0ZWRfX4Do2N4Bp6QBT
 FdlcjHGFW8gO/vgM5TgIhLRwEnAnr6Lv0OKSeHVFpW9ntdWplNisZ2XNHh3kAMzK+M0d/EncipX
 1NutEo2nwXClRDpiyGlwLj6BgM6pDGI=
X-Proofpoint-GUID: 6hoElob0Z_G4mGf91e6mrINIONRStqGP
X-Proofpoint-ORIG-GUID: 6hoElob0Z_G4mGf91e6mrINIONRStqGP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDA0OSBTYWx0ZWRfX/BbOqCgwftfw
 SIzhjdu4wC5VOwvzTTntr4zq8DOvOpECWHo3hOatZDJh6GgP710MYleqejCRfUPm865nF+p/DKG
 izfWBiGM1hipV56VM1AdnYt25P9GCtxsMgIedRh0H5cRJ9u/7ymaHUKwF0csRyd7QpeCwnXprpw
 QDQ56t2Kf6prM4YvQxWrF36fTxEGWRcJEf604DY9VY9nMPsV4oQNvyMekg8tiDA63+Y6xJKIjuf
 va+5LH81v3qwpj0H1rH0tPu4u24m36tmjMv5Vbw9w6RGyuEi9dE9gE2O3abipW2YGfOqRtkNyFb
 zBnPA6DmvLH9awTty/3aHCWnA324tkehqDPLSIi0oIH8Q9/H0fMwW3fF3qoHckU40R9F/HFwgP2
 A5MP5IH6fzT6/LTjIK18RthPmWG8q1arA8j3VgJSmjXwPdl0p4d+ikFxsHnbQYRSt/e1mh+vPSa
 D3yszE+RnO7Frty5j0g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-12_04,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0 bulkscore=0
 phishscore=0 adultscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610120049


On 10/6/2026 7:34 PM, Pablo Neira Ayuso wrote:
> On Tue, Oct 06, 2026 at 02:28:44PM +0530, Hari Chandrakanthan wrote:
>> Add support for using the ct expression in nftables netdev egress chains.
>> This enables QoS policy enforcement at the netdev egress hook by
>> allowing ct operations such as copying connmark to packet mark.
>>
>> Add an explicit NFPROTO_NETDEV case in nf_ct_netns_get() and
>> nf_ct_netns_put() that enables conntrack for IPv4, IPv6 and bridge when a
>> ct expression is added to a netdev chain.
>>
>> Restrict ct expression use in the netdev family to egress hooks only, as
>> the connection entry is not yet available at ingress.
>>
>> Sharing this change as an RFC, to get feedback. The patch has been tested
>> by configuring nft rules at netdev egress hook to set ct mark and copy
>> ct mark into skb->mark. Also, the patch is validated at netdev ingress to
>> ensure the nft rule with ct mark set action is rejected.
>>
>> Signed-off-by: Hari Chandrakanthan <hari.chandrakanthan@oss.qualcomm.com>
>> ---
>>   net/netfilter/nf_conntrack_proto.c | 26 ++++++++++++++++++++++++++
>>   net/netfilter/nft_ct.c             | 22 ++++++++++++++++++++++
>>   2 files changed, 48 insertions(+)
>>
>> diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
>> index 7a40e4e0e33e..b8ee46262901 100644
>> --- a/net/netfilter/nf_conntrack_proto.c
>> +++ b/net/netfilter/nf_conntrack_proto.c
>> @@ -587,11 +587,36 @@ static int nf_ct_netns_inet_get(struct net *net)
>>   int nf_ct_netns_get(struct net *net, u8 nfproto)
>>   {
>>   	int err;
>> +	bool bridge_acquired = false;
>>   
>>   	switch (nfproto) {
>>   	case NFPROTO_INET:
>>   		err = nf_ct_netns_inet_get(net);
>>   		break;
>> +	case NFPROTO_NETDEV:
>> +		err = nf_ct_netns_do_get(net, NFPROTO_BRIDGE);
> Hm. This is pulling in the bridge conntrack hooks.
>
>> +		if (err < 0) {
>> +			mutex_lock(&nf_ct_proto_mutex);
>> +			if (nf_ct_bridge_info) {
>> +				/* Module present but hook registration failed.*/
>> +				mutex_unlock(&nf_ct_proto_mutex);
>> +				return err;
>> +			}
>> +			mutex_unlock(&nf_ct_proto_mutex);
>> +			/* Bridge module absent, netdev egress handles routed
>> +			 * traffic too, bridge conntrack is only needed for
>> +			 * bridged frames.
>> +			 */
>> +		} else {
>> +			bridge_acquired = true;
>> +		}
>> +		err = nf_ct_netns_inet_get(net);
> And inet too.
>
> I understand this is to deal with a situation where only ct rule is
> placed in netdev/egress.

Yes.

>
> Is it really worth? I would expect users already have rules refering
> to ct from either bridge and/or netdev would match here.
>
> It looks a bit like too much to enable them all for the "a ct rule in
> netdev/egress only".
>
> Probably better solution would be to enable nf_conntrack_in() from the
> netdev hook (just an earlier call), but this also needs to enable
> packet defrag from there. Then, enabling all inet and bridge is not
> required, because netdev/ingress would handle the creation/lookup of
> the conntrack.

Thanks for suggesting the alternate solution.
Yes, we can call nf_conntrack_in() at netdev/ingress and nf_confirm()
at netdev/egress, avoiding the need to enable the inet and bridge
hooks when ct expressions are used only with netdev hooks.
I’ll share tested patches to add this support, including the handling of
packet defrag.

>> +		if (err < 0) {
>> +			if (bridge_acquired)
>> +				nf_ct_netns_put(net, NFPROTO_BRIDGE);
>> +			return err;
>> +		}
>> +		break;
>>   	case NFPROTO_BRIDGE:
>>   		err = nf_ct_netns_do_get(net, NFPROTO_BRIDGE);
>>   		if (err < 0)
>> @@ -615,6 +640,7 @@ void nf_ct_netns_put(struct net *net, uint8_t nfproto)
>>   {
>>   	switch (nfproto) {
>>   	case NFPROTO_BRIDGE:
>> +	case NFPROTO_NETDEV:
>>   		nf_ct_netns_do_put(net, NFPROTO_BRIDGE);
>>   		fallthrough;
>>   	case NFPROTO_INET:
>> diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
>> index 3c4c2faa7398..e90e73475b0c 100644
>> --- a/net/netfilter/nft_ct.c
>> +++ b/net/netfilter/nft_ct.c
>> @@ -649,6 +649,15 @@ static void nft_ct_get_destroy(const struct nft_ctx *ctx,
>>   	nf_ct_netns_put(ctx->net, ctx->family);
>>   }
>>   
>> +static int nft_ct_validate(const struct nft_ctx *ctx,
>> +			   const struct nft_expr *expr)
>> +{
>> +	if (ctx->family != NFPROTO_NETDEV)
>> +		return 0;
>> +
>> +	return nft_chain_validate_hooks(ctx->chain, 1 << NF_NETDEV_EGRESS);
>> +}
>> +
>>   static void nft_ct_set_destroy(const struct nft_ctx *ctx,
>>   			       const struct nft_expr *expr)
>>   {
>> @@ -732,6 +741,7 @@ static const struct nft_expr_ops nft_ct_get_ops = {
>>   	.init		= nft_ct_get_init,
>>   	.destroy	= nft_ct_get_destroy,
>>   	.dump		= nft_ct_get_dump,
>> +	.validate	= nft_ct_validate,
>>   };
>>   
>>   #ifdef CONFIG_MITIGATION_RETPOLINE
>> @@ -742,6 +752,7 @@ static const struct nft_expr_ops nft_ct_get_fast_ops = {
>>   	.init		= nft_ct_get_init,
>>   	.destroy	= nft_ct_get_destroy,
>>   	.dump		= nft_ct_get_dump,
>> +	.validate	= nft_ct_validate,
>>   };
>>   #endif
>>   
>> @@ -752,9 +763,19 @@ static const struct nft_expr_ops nft_ct_set_ops = {
>>   	.init		= nft_ct_set_init,
>>   	.destroy	= nft_ct_set_destroy,
>>   	.dump		= nft_ct_set_dump,
>> +	.validate	= nft_ct_validate,
>>   };
>>   
>>   #ifdef CONFIG_NF_CONNTRACK_ZONES
>> +static int nft_ct_set_zone_validate(const struct nft_ctx *ctx,
>> +				    const struct nft_expr *expr)
>> +{
>> +	if (ctx->family == NFPROTO_NETDEV)
>> +		return -EOPNOTSUPP;
>> +
>> +	return 0;
>> +}
>> +
>>   static const struct nft_expr_ops nft_ct_set_zone_ops = {
>>   	.type		= &nft_ct_type,
>>   	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ct)),
>> @@ -762,6 +783,7 @@ static const struct nft_expr_ops nft_ct_set_zone_ops = {
>>   	.init		= nft_ct_set_init,
>>   	.destroy	= nft_ct_set_destroy,
>>   	.dump		= nft_ct_set_dump,
>> +	.validate	= nft_ct_set_zone_validate,
>>   };
>>   #endif
>>   
>> -- 
>> 2.34.1
>>
