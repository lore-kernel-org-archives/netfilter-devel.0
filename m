Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77602C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 May 2022 13:13:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbiEINRY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 May 2022 09:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235402AbiEINRW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 May 2022 09:17:22 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93E71B1F5E
        for <netfilter-devel@vger.kernel.org>; Mon,  9 May 2022 06:13:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kbum7jbgTwRIcn2rwDq/TyrsE+BACFh2aCTVZet4qKnLSdmVlrm2kmzvKDywPRXMEJ2NzIa3T1TxN2B8EPG8yCG3gISHETftnt0Wy3Sf/1I6VmmNzVOmVPJlD7h9YFtbe/7HyVy3tcRQhNFWscHcc1b+ILoO+yZkCAVDVQcXLBQMc6qXTvw3ogyMx+jBvyoXWdOc8puF1amFsW06GFlXYurmGq2GMAuKbGN5KqDPXLYvIqRypIKRh6EDnLV340pAiqon5D4Xp8RMfQ+nlmkM3pTIjietyA36QqZbDERYfwCjlzoKfbLtNrR/Re60MIeK8KcL1nKbbLYZljLJBm8ehg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qaxm9CKwsqSiQPH5cy4JG6W8Gn9AWjZofPHOdgVT0Ko=;
 b=ezobtzelLs2mFddcgw4Qlra4VH3az8LCOdKMCZTZj6gOQd+IyRi49jCXlmjcyy/Sna0x9O7yKxFI2pKKrRieYwMfLSZb9EK9nAz3CpSDdW4YfrAJLRHhjYj9xAD1H7/l3ZdfG7BlyxQNV5BIIhqJU4I//HdYkr6LrvAQRZ+oh08DyTnY35zf0Srzo8lZHt2Ab0Jz0klC2aVMEV14hGpfnAyCna1r/fUPR9mYEYNdC4v8xBrICF6EOeNK92mVJKo/OwVKpBv4tb1HqwbaOIxN1RjLqXoZhC9ikxKjvtvdbnZ0K+U+cn9UjxqExvFjwYwLe6b2JVeJr3M7kHS8x40lFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qaxm9CKwsqSiQPH5cy4JG6W8Gn9AWjZofPHOdgVT0Ko=;
 b=IsxQWebK5UwhnKmZT4w5jKpZsxLPfEpHXElT8cyvYTy3nMdlHgU/IiTG+DJwfLIqj35gcaE/1wT8A0oIr4wFWaYj9vnRFoBsbwczAt4pOrK9GIpCZyvYKSaGiiKddeBy1eaNRYf4L+ut6r34W6YzPmy9rUcCjt22WttTMR9mdCrlpzBv2Iozbag+EKa+CPG1bTGCeS+f9y6RBhjQIBmbFBWsLC7wS3C5JAft2iSX2uCYChy60573nD9KhApnSYF1snfGLZiwNZPylfS49d6ExZ45X3kxAWnqWBePURv8byQ6avGfbv4D7bNbGAvM8haaY1zTJ8h+elKmGqJDV7QZOw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 DM4PR12MB5341.namprd12.prod.outlook.com (2603:10b6:5:39e::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.21; Mon, 9 May 2022 13:13:26 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::fc67:fe4e:c11a:38ba]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::fc67:fe4e:c11a:38ba%7]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 13:13:26 +0000
Message-ID: <c4622e4f-d22d-b716-6909-400eae9b3abf@nvidia.com>
Date:   Mon, 9 May 2022 16:13:19 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] nf_flowtable: teardown fix race condition
Content-Language: en-US
To:     Sven Auhagen <Sven.Auhagen@voleatech.de>,
        netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, nbd@nbd.name, fw@strlen.de, paulb@nvidia.com
References: <20220509093132.fmxxhhogq7jhhpks@SvensMacbookPro.hq.voleatech.com>
From:   Oz Shlomo <ozsh@nvidia.com>
In-Reply-To: <20220509093132.fmxxhhogq7jhhpks@SvensMacbookPro.hq.voleatech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0156.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c7::18) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9ca892d-38d5-4462-8875-08da31bdb3d6
X-MS-TrafficTypeDiagnostic: DM4PR12MB5341:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB534189D60CD6CAAA07B4353DA6C69@DM4PR12MB5341.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TJ2TTCeUb3LrSV8VQ/XK5g5qeSZSt1UbZlZCHjf0y4QBgo+QPpBOX2xqe2emouEq8qQSK/SajtPNVlhKQpdmOQmxAeD7pJ4rIF/06K/87tNlk/usXwwBgCgkrQacNBqvS+MsnLDzWMl4E1Lliby5MfAfrb7DQSMLvoBYHns0/k7DFnzMSOWmxi5H6yEGybrFVP501Z1/rQa6ZpMcMtt2lG9i/QhL+E1IEUrMHJi4UP8T4cR+mwKThK5HzU5CEV2FDcugAf5OVHpm9iuAYBYvNJ/w6iQy6/NDnOhpqZPH/+wP0Ol6S/k1bLiNAqWKtFF1QTO8TN3Ipr6gr8qWR3Y0AJZoh4yoOZfmfEPMPRuDoNwkq1F8Ndla8qdWdMeutFCZsPBlJ0m5ChjzKp3Brp042mUnagPR00Xx0cCYAhwTjTilwrQSYmN/Zn8sEJ7iScMlZ0uQcv4Vz/cX5ZvVTNUev4inB+gdM2o6egifHcJdWHy5h2fiHqpQF6ZYwqS+o4JXy3tc7jkACg5R7zzAZZTewbjIXFJRxJG4Qtzyd1KdkftkGRyV0SKigokDPiMUnUebsE/258YSvVoe0s9MzMPRKx5rchnbRvPL+nys1j5mCYOQ9VM58zH5erZrd4/M2W/jh+TeGcY4Bv023LiIPHO3WsZFMnt6lG3nplcUX5nqO2wM4ekd4xnvqxudTlyilYkJtHNZ8eywVsNJZUdNbhBJ/mjPIDTnBp8lHPa+gRgxuoAKNEz0ZaOBrEAKwUMV160L
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(36756003)(31686004)(8936002)(5660300002)(8676002)(66476007)(66946007)(66556008)(4326008)(107886003)(86362001)(83380400001)(31696002)(38100700002)(6486002)(186003)(2616005)(53546011)(6506007)(26005)(316002)(6666004)(6512007)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WEJ4aWM1bWwyUFhPS0tlaEcxT2VYY0RjcXJ6ZEtFSXZpWithakkxbE5uOENt?=
 =?utf-8?B?SDV1ZzBtVUJEVVpRQTV4OEtTV2RUdG40bm12WG1GYk8zWTRRcDJqc21QeVgr?=
 =?utf-8?B?V1N4bW5KR2dSaEhTUGxISVBKTExqaGV5WE9RYXVsNWc1WjdCZXY3VUpuL1VN?=
 =?utf-8?B?VXZuMHRuTjF2cmV2ZDBXQWNlUncraVlwTUJlVTZ2M0M2bmEvVnVzL004c2da?=
 =?utf-8?B?VG1XNThuY1kvZmhmY1I3MnN0VjhQZ2ZOa0labVNqSmVKKzNmSWY4WE80TmFn?=
 =?utf-8?B?bWlOV2tiOW50dFZXVTh1cndYWDNHUVZPbGdoK21lRXNTV1ZaTG15WGVyaEU2?=
 =?utf-8?B?Qi9sSkxuTjB2dkhjZmxlVC84K09mVGE1K09PbHpwOXhteDdKMndKM3lMZnFN?=
 =?utf-8?B?NDVidnl1ZjJFN1FTYzcyQnNiNjN2ajYwTEp1VmxHV2NHQ3VIRWdrdWlCSTFV?=
 =?utf-8?B?TUl2YUcyWFllMlI3d3MvTnRONHhpbkxVYlNnVkprbFdlTWp4M05qSGZ0bUMz?=
 =?utf-8?B?bEFIVkdjdFpOL29FRDdHek4xUm0xWG9hV3E2WEZadkdoaE1iRDBZSThBekhx?=
 =?utf-8?B?ZkZaUFFqZVJmM0ZoUzRRNjRlN3BhU1RQWTNsd2FzYXE4SkNGblZmd0g3d2cw?=
 =?utf-8?B?VktQT3JrOWZVZkhwUkh5em8vU1lEUnB6QVZnL3NYTllGR3YwbWJ3aVkyUlc3?=
 =?utf-8?B?TzlRSjErZXpaY0RRTVpaOEFhVUY0MHJmZTVsSjdKbFI0NndSVEpMc0ZsVloz?=
 =?utf-8?B?QnlvTVptYk1ZZER1Y0EreVhLZ3l6amVwNk9jWFZ6WUZ3NTdaTVlqM293UUNn?=
 =?utf-8?B?RmFVcFkxL0FHVGp1djhUcHYvbEFrS3d0cWwzdGY0eXFZQkFRaS9Qd1RNZnRB?=
 =?utf-8?B?clJlNFZQWnRwRk90Z2ZwdytlOFNZMDJEYjBBckoyM2phNkJmZjJONDQ3aE80?=
 =?utf-8?B?b0FxL2toeEQwMVMzYnNKNFVuU01pV204WXhZL1hIMXgycFpESkU1ZEF4blkw?=
 =?utf-8?B?TzRaSURoLzVqaVdBdkNWaVdnTnR3TFdEL05vdFI4TDN6V0V0bDMzNkFYRTlP?=
 =?utf-8?B?NFIzY1JvWFZZdHNCblA1Mll5Tk5KZTV5VmxBNEg0UUxPOFFxN254azQydmhN?=
 =?utf-8?B?RkVMWWY2ZnVmMWxiYzh0eFU4ZnFySjVQUU1lSGVQWERuSmM4SzFGWFpIeWFP?=
 =?utf-8?B?S0wyOGFiZ2piODFiRXRZQTBPcjhOZmk1UzdqVnRlcmRPdkNTTHREMHJRRlBQ?=
 =?utf-8?B?RnVDM2U5Qmx1cXk3UHRscml0dVMrUTlUc3JVZUJabzFqa1F4U21tV2t5TEdH?=
 =?utf-8?B?Ynp5dzVvU002V1hXc25VUWdVVDEvZ3lFRTBtejJVbHg4eEhYTk12QU1WRVBu?=
 =?utf-8?B?c2pFVXl6cmZiU05YN3F6KzY2SmNMK0MrUHVPeU5WVUVVTUdZQksyRjFBVUJV?=
 =?utf-8?B?bktyeG5KVUtsS3VUdEhCbXZJUnR3NWVQdXkzcjFrMmsyZTNsbjdqMkhreVRF?=
 =?utf-8?B?MnZYcDVsL3RPS29MdFVvTXYvOGs4dlcvYkJEQXpMamlKOFZCRlErdkZCRXN1?=
 =?utf-8?B?RzRBQi9TOHQwaWxpSG9mS3YrUCtLa043ZERvOEx4SWhOeE05enJFSDVRaUZI?=
 =?utf-8?B?QjhSQmFSNzBnVkFiYmRRdkovaVNtN25pRGNML1RIMWdLUGlyMG5UYWlvS29a?=
 =?utf-8?B?RDVFRFNGZTU3SG9TRitwL3laQ3ZzTHcrcllaVFV2a01McFVEYTNFTlByVXhp?=
 =?utf-8?B?T09OWEhZTjZ0cjdjYkg4ckFXMUUxSWdwMVFqdmRYbDNDMlI3ZzROeUdVTkpJ?=
 =?utf-8?B?WTlEK2VBS0NyMGV2dStpMFJWdU5jMnlnaWphT204RGtrMldTeW16UHk2YWEy?=
 =?utf-8?B?a2FJeVJmNGxUYVo5RkswbzVmYSt0ckRFTXRMK05uSGI2WlY4N3E5L1JtR2xy?=
 =?utf-8?B?RlUrUGQ3K0ZGeHJpbjIzT0Fscmwra2ZTWEwreUM5bnM1aUxFQVBLc2RDWk5I?=
 =?utf-8?B?UGs2THh3V0NMMHdSNjNBTzRUck9iK2tCWG5pNm5iaVU5QmhpZkhYOHliMHor?=
 =?utf-8?B?YXJNQUFWdHBPU3I4N0xDalJwTXNySWRNNHBaVk5lckNjNG44MjhDQmRiakdm?=
 =?utf-8?B?Wi85ZTNxelQ3MG5LaWYwQS8xQ1NsNURiTjZZeWh0b0x3RmpLamNkV0pybVIy?=
 =?utf-8?B?MmJ2YTYwVDZIRFMxQnpLeDFJUjFTaXpWZmMxeWZhOTRIQk9UZnhsMFJQSEw3?=
 =?utf-8?B?OW1GY3h6VEJOY0dETllLWUJ5WmNRWHUyU0t3blNNZlhhQjUrNUdPdnhLWWUx?=
 =?utf-8?B?MXlOVklJNjRmNWVpZWFlVXFVbGV4bnc2RXJGRVZHTnNONjFFZnkydz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9ca892d-38d5-4462-8875-08da31bdb3d6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 13:13:26.4138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pVN9Ls+W8anKzVruw8M6twtMnCrE8XWUHbOj0rueDc7scTXGLU8AZSVLoNzO2+A2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5341
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Sven,

It seems to me like the issue should be resolved from nft side rather 
than the flowtable side.

On 5/9/2022 12:31 PM, Sven Auhagen wrote:
> The nf flowtable teardown forces a tcp state into established state
> with the corresponding timeout and is in a race condition with
> the conntrack code.
> This might happen even though the state is already in a CLOSE or
> FIN WAIT state and about to be closed.
> In order to process the correct state, a TCP connection needs to be
> set to established in the flowtable software and hardware case.
> Also this is a bit optimistic as we actually do not check for the
> 3 way handshake ACK at this point, we do not really have a choice.
> 
> This is also fixing a race condition between the ct gc code
> and the flowtable teardown where the ct might already be removed
> when the flowtable teardown code runs >
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> 
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 87a7388b6c89..898ea2fc833e 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -5,6 +5,7 @@
>   #include <linux/netfilter.h>
>   #include <linux/rhashtable.h>
>   #include <linux/netdevice.h>
> +#include <linux/spinlock.h>
>   #include <net/ip.h>
>   #include <net/ip6_route.h>
>   #include <net/netfilter/nf_tables.h>
> @@ -171,30 +172,32 @@ int flow_offload_route_init(struct flow_offload *flow,
>   }
>   EXPORT_SYMBOL_GPL(flow_offload_route_init);
>   
> -static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
> -{
> -	tcp->state = TCP_CONNTRACK_ESTABLISHED;
> -	tcp->seen[0].td_maxwin = 0;
> -	tcp->seen[1].td_maxwin = 0;
> -}
>   
> -static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
> +static void flow_offload_fixup_ct(struct nf_conn *ct)
>   {
>   	struct net *net = nf_ct_net(ct);
>   	int l4num = nf_ct_protonum(ct);
>   	s32 timeout;
>   
> +	spin_lock_bh(&ct->lock);
> +
>   	if (l4num == IPPROTO_TCP) {
> -		struct nf_tcp_net *tn = nf_tcp_pernet(net);
> +		ct->proto.tcp.seen[0].td_maxwin = 0;
> +		ct->proto.tcp.seen[1].td_maxwin = 0;
>   
> -		timeout = tn->timeouts[TCP_CONNTRACK_ESTABLISHED];
> -		timeout -= tn->offload_timeout;
> +		if (nf_conntrack_tcp_established(ct)) {
> +			struct nf_tcp_net *tn = nf_tcp_pernet(net);
> +
> +			timeout = tn->timeouts[TCP_CONNTRACK_ESTABLISHED];
> +			timeout -= tn->offload_timeout;
> +		}
>   	} else if (l4num == IPPROTO_UDP) {
>   		struct nf_udp_net *tn = nf_udp_pernet(net);
>   
>   		timeout = tn->timeouts[UDP_CT_REPLIED];
>   		timeout -= tn->offload_timeout;
>   	} else {
> +		spin_unlock_bh(&ct->lock);
>   		return;
>   	}
>   
> @@ -203,18 +206,8 @@ static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
>   
>   	if (nf_flow_timeout_delta(ct->timeout) > (__s32)timeout)
>   		ct->timeout = nfct_time_stamp + timeout;
> -}
>   
> -static void flow_offload_fixup_ct_state(struct nf_conn *ct)
> -{
> -	if (nf_ct_protonum(ct) == IPPROTO_TCP)
> -		flow_offload_fixup_tcp(&ct->proto.tcp);
> -}
> -
> -static void flow_offload_fixup_ct(struct nf_conn *ct)
> -{
> -	flow_offload_fixup_ct_state(ct);
> -	flow_offload_fixup_ct_timeout(ct);
> +	spin_unlock_bh(&ct->lock);
>   }
>   
>   static void flow_offload_route_release(struct flow_offload *flow)
> @@ -354,12 +347,9 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
>   			       &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
>   			       nf_flow_offload_rhash_params);
>   
> -	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
> +	flow_offload_fixup_ct(flow->ct);
>   
> -	if (nf_flow_has_expired(flow))
> -		flow_offload_fixup_ct(flow->ct);
> -	else
> -		flow_offload_fixup_ct_timeout(flow->ct);
> +	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
>   
>   	flow_offload_free(flow);
>   }
> @@ -367,8 +357,6 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
>   void flow_offload_teardown(struct flow_offload *flow)
>   {
>   	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
> -
> -	flow_offload_fixup_ct_state(flow->ct);
>   }
>   EXPORT_SYMBOL_GPL(flow_offload_teardown);
>   
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> index 889cf88d3dba..990128cb7a61 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -10,6 +10,7 @@
>   #include <linux/if_ether.h>
>   #include <linux/if_pppox.h>
>   #include <linux/ppp_defs.h>
> +#include <linux/spinlock.h>
>   #include <net/ip.h>
>   #include <net/ipv6.h>
>   #include <net/ip6_route.h>
> @@ -34,6 +35,13 @@ static int nf_flow_state_check(struct flow_offload *flow, int proto,
>   		return -1;
>   	}
>   
> +	if (unlikely(!test_bit(IPS_ASSURED_BIT, &flow->ct->status))) {
> +		spin_lock_bh(&flow->ct->lock);
> +		flow->ct->proto.tcp.state = TCP_CONNTRACK_ESTABLISHED;
> +		spin_unlock_bh(&flow->ct->lock);
> +		set_bit(IPS_ASSURED_BIT, &flow->ct->status);
> +	}
> +
>   	return 0;
>   }
>   
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index b561e0a44a45..63bf1579e75f 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -5,6 +5,7 @@
>   #include <linux/rhashtable.h>
>   #include <linux/netdevice.h>
>   #include <linux/tc_act/tc_csum.h>
> +#include <linux/spinlock.h>
>   #include <net/flow_offload.h>
>   #include <net/netfilter/nf_flow_table.h>
>   #include <net/netfilter/nf_tables.h>
> @@ -953,11 +954,22 @@ static void flow_offload_work_stats(struct flow_offload_work *offload)
>   static void flow_offload_work_handler(struct work_struct *work)
>   {
>   	struct flow_offload_work *offload;
> +	struct flow_offload_tuple *tuple;
> +	struct flow_offload *flow;
>   
>   	offload = container_of(work, struct flow_offload_work, work);
>   	switch (offload->cmd) {
>   		case FLOW_CLS_REPLACE:
>   			flow_offload_work_add(offload);
> +			/* Set the TCP connection to established or teardown does not work */
> +			flow = offload->flow;
> +			tuple = &flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple;
> +			if (tuple->l4proto == IPPROTO_TCP && !test_bit(IPS_ASSURED_BIT, &flow->ct->status)) {
> +				spin_lock_bh(&flow->ct->lock);
> +				flow->ct->proto.tcp.state = TCP_CONNTRACK_ESTABLISHED;
> +				spin_unlock_bh(&flow->ct->lock);
> +				set_bit(IPS_ASSURED_BIT, &flow->ct->status);
> +			}

Hmm, this looks like a workaround.
Also note that this code is called only when the flowtable 
NF_FLOWTABLE_HW_OFFLOAD bit is set.

>   			break;
>   		case FLOW_CLS_DESTROY:
>   			flow_offload_work_del(offload);
