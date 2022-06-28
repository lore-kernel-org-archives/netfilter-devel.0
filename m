Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B3F1C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jun 2022 13:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346195AbiF1NNT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Jun 2022 09:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346187AbiF1NNR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Jun 2022 09:13:17 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2076.outbound.protection.outlook.com [40.107.244.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 610885FA4
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jun 2022 06:13:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CvMp+L43UsG53rZ1Axt+lK1eeMwM0O3sHecAk/pUcmR7gYwgoXvvHMH3g3g+Ppq6EV18CKoiKefBM5PysAaaP/vc/rAID6NSiAfaCupmGml4O8TFW0JJrzaMu03uiwTajp3rnxE8S/bwZIxAaGwNvQ2iNPM8QCX6m91deuHabJhTeYeMaPfLX572SWKTxp7o1JvgLcbvqpLTvU9nkEeRKlzsL+u7fmS84jJz1cMTvclQdeHHxnqGjLyqnXl5B7fkoutKlE3etx8dI5POJH3xeGbTmWaDimvCXs4VZpw7pY0mNtxR9aGSgGcCcVgR/Is1QTrYPDao4JHbQWcctGFcRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JsD/rEUCE/48mTHz0xGsspPH0iYYU7BZRyLp+6Od2og=;
 b=UJu+AUsvSFWnHvGYX/FSWb6xdrdVBivpdmoVX3zrXr5J9QcpiLTxYb98eMQdV/+T29hX9Cr0V0bLvZuWqO5JJWbyEIw1WKrPSUj3AISgN+sSuXtX7b6xc2kj5PhLfGdV41zY+YAKElroQ3c7kRQNGDYdjGGdGQNmF+AW+arG75BRxgrk2SX7blbjHZykkQz4T8nXVSUBgZT5yxSW52fMRYm2Aiq2zOMhuXuA7jHEkatphm0RUt5Vb8Y44SD4tEJjqfMrQZ5vT6RMK1/oxhz1F+zHehhkkYQ7oQlj/b/atoBqwTfNV6+OHSZizDc8VabFBGeWFf/NSd5YsrbI0hM5kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JsD/rEUCE/48mTHz0xGsspPH0iYYU7BZRyLp+6Od2og=;
 b=B7LNHn/LHZ1KgaKlXZARx1EnIRH2+qntt7A9pj3B/rCfHWQ6N43Zf6E7I5p2WCplj/ROSN305Q/UjlshpX1kfrYlY74Wmod/mtjgbDF9A/6ylRJIeXalU90TfbViHHE977jsi7hoDGD16ozY7b55XYEQvUpPrpa2TUDXv8O0LKivUPm+MQMQ6yVOG5sgL4T0a+PeqGCF+H6W1PozF/m4tkvOByq6dHJjwJmAlqxCBmfj6dVt0cvjT9WvcAazImUfqaWCR/MPci78hrPyt6j4AvoYQprUBfuA3KXpIGwvhs9jV/5htgMuaJFwJF1D7zdKsoOXzt5GcozSo4UB43EOaA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 DM4PR12MB5938.namprd12.prod.outlook.com (2603:10b6:8:69::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.18; Tue, 28 Jun 2022 13:13:12 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::1075:9d96:7eaa:3f9f]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::1075:9d96:7eaa:3f9f%4]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 13:13:12 +0000
Message-ID: <d6b97751-019b-7b81-f4e9-076aaedbbc91@nvidia.com>
Date:   Tue, 28 Jun 2022 16:13:05 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH nf-next] flow_table: do not try to add already offloaded
 entries
Content-Language: en-US
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Paul Blakey <paulb@nvidia.com>
References: <95c2aa63adea29e6008ee45af17d199492f4d14b.1656340577.git.marcelo.leitner@gmail.com>
 <c5039f5a-5295-a457-65c5-d7016d6a5034@nvidia.com>
 <YrnjpSUKZdKT1NZO@t14s.localdomain>
From:   Oz Shlomo <ozsh@nvidia.com>
In-Reply-To: <YrnjpSUKZdKT1NZO@t14s.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0142.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::34) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9fc735d-b1ee-4c5a-0794-08da5907f423
X-MS-TrafficTypeDiagnostic: DM4PR12MB5938:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xc2iAhidYhLATagZAtMXrOztxpGZ3NBTjAT/xkgBqeRuayoadZgLa/aqA0bMNUgMW4x6QQq6FI/aoAXX75UGroYhzaEdgyctGJJwL5yESFdFl93jlPbZFIdl2tlBBlz8KO7eRkr5YchGsP7kvy7pCJNsvmgFNqLy6nKJTr7uyvyp4E8SH5J5WwNEaRMbmWb+nFUYKJ/G0Vg/KIVmp6/yTisSP8K+W+IzcRp9Zzza3DGyudJv1WybH8nE/SdUhHY6+mNbL5PdBVLven35OcRVUNQUYThwqbJonb7wTFYAJFIthuqRvUZQAydMI383S7e/XjqAZAbjF8fxPH21lqB4n5RI2eDveSg5XOfV5Is2MxdjOCtLv8SvE+yb8IquuBkcIaz4YnYU7BAsj8814YUOQl41Qf+nh7qxnT+uogyQVOiHBG4KFNyFqb6Cn9VbG/G8CgMxAp7axphH9OIoXrTBEC6ZmaRIQ9MBCyYYYfEEgjq+jIq4wAvXN+8o4lUbe5tcyNFp+nf/UGsZ9kFzRYQawylIqz/UeMyM/947BQZqyI8V/VXimbMUBXkCIUvuSSy8hkuh5LKqUMB5kF0q1r24QAp9g7U+s04CO/POKpABF2PzwOvYXLyuhvnNgCRFNUJWw6ENxbY3hKuKFBMYeLqi7Lmz6Wan08WYjKjVXWP2pZn2BCYqAKqikpMHFQFxmnPbXAVOgiIx0l3yAQcsf6GkWHG8MrPdf7vECoy+rjFwqzhtfxf9B4ArKj/ZpcqDp1EZxkIyxRkMhpjB0fuBdCGclvMGz6MqH6RLMbzmXX6RaIajo5c0SbPNB611eIvSRwOM0TmPnsGvxrIeKorjCZZqyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(376002)(366004)(39860400002)(83380400001)(38100700002)(66946007)(107886003)(186003)(2906002)(66556008)(316002)(54906003)(31696002)(6486002)(86362001)(6916009)(4326008)(36756003)(31686004)(66476007)(8676002)(26005)(5660300002)(478600001)(6512007)(53546011)(6506007)(8936002)(6666004)(2616005)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U21NQkxZRHVrZi83THlYaUYzY05ZWFgyNkIvWndESWZyRXBROHZxVDdpQ2F1?=
 =?utf-8?B?dUlsOG1UVFBXNEVCdTVZZnpucGN4THVoZGxVYnZ6TUhPU3VqKy9xWjY3WWVt?=
 =?utf-8?B?TFNzcUZ3Ti9UMkg3RjIzS1VSSzMxUnc2Y2krcGJLTUxQbFVENkp1VjZSZjJj?=
 =?utf-8?B?dEIyd1JuVEZuOG9DdWRqV1BvWlFFd0lhYjNDbzV4eTRTVTNjRy9YQi84ck1I?=
 =?utf-8?B?Yk1ETGZOOFpLeThteVp3N1NKL3U5NUtnYjMvVHFXeFh2LzhCcHJrS2ZmNzBq?=
 =?utf-8?B?eE0vWW9JMWlQK3dWVFNZR1F2bzJoa0UzVmpwSWY5VmtNQ21xYTlHQmpEaFpK?=
 =?utf-8?B?R21ZeWlMUkZrdTdVZkUzcTQveTl1Z0JycWlXc1dMck4zTEwzbEljTUJOVEtp?=
 =?utf-8?B?bHZIeHhaS0NiYWIyUVFzM2F1K1NwWHRCL2pMcGxXbGFvTDJZbkVIckJ1ekRN?=
 =?utf-8?B?VU1OMCt4aDFGUlNvdlRpWHp4Q1pINlNSSWJYRUpYaG9YZUZrSmNVWWNFQVJT?=
 =?utf-8?B?VmhZdS9wTG9JS2xYSDNScnBXN3EwMGt0QU8wSjJndTduYVdCOXlvb25RUzZ3?=
 =?utf-8?B?RnRhelVtem1YcnJ6Q2kxTEpxbkU4OW9OQlg3c2M4V1h5Q2tZNTFtRDk1S3k5?=
 =?utf-8?B?VTRzdStOeVA5dFIvSW5LNDNiR1I4V0hxNFBiOHJUeWo4c0hVcHNuVWNyTjFV?=
 =?utf-8?B?bExBQ3JXcWtScy8vc3U5bEtqUzFmYVRwN1ppWWRHWEh0MzNIVTd2MW96UGlO?=
 =?utf-8?B?aTE4RDRUYnRKb1pUZHh0UjVJR05KcFNrT3hqU0N0U0ZHbzVoRjZ0MWsyelAy?=
 =?utf-8?B?RWp0ZktPKzN3YTI4N05GK2w4RzkxYUsvY01sTW1GZStDeTNvKzZIdXJldi9W?=
 =?utf-8?B?ZFc4VzhPeUNtMWYvbkVhRzUxb0dSeEtvYngzMEdITmNWK2tmY095dkNCWTV3?=
 =?utf-8?B?aWR0TnhWSjBoZDl2YlhsYWRWWHZsakNESUtYTnVtQ1plamQwY1A2SzlvbGcv?=
 =?utf-8?B?bU4wcnVYY2JIMlZFWVQ0am9XdTNhUnZUeEdtSkpkWnA2VVhiR21qZG5nUkRX?=
 =?utf-8?B?c0MwOFlhMHE1b2hJYVptSSt1ZUpGMHVvakJLN08vRmZqT3hMZWhwTjkrb0E0?=
 =?utf-8?B?Um9DUFRwYmRqVXRVZzhYdXFXR0NaUUc4QWJtd1A4RmErY3ZwSVpSVHYxZVY3?=
 =?utf-8?B?SXU3Y2NpT1R6OUMwVEVuR3JETysya0h6VExaNTRJOTdZQ2ozUkVLU3gyTnZP?=
 =?utf-8?B?c1Exb01kOFBrWG5CbzNxTXNRS1ZBa1NJTEVvRWdJbWJXdHpzQmxCVW92ZHJ0?=
 =?utf-8?B?MGgxdmhUL1NkTWVGVjIwK29zc3dwMU41eUdvcVF3dG5KMGpTT2drRmx6SDJS?=
 =?utf-8?B?azJyVUtDUTBrU2twMGVtc0FKMzdBUm1Ba1RYWHJMQ0dreDVsa2RMTlZQRHdp?=
 =?utf-8?B?dGFZQml5Z3pqT1drbGw3Q2dVb0trRmhXWE1ETlN3Q2hVQ1dTSHhNWDFZK2Rw?=
 =?utf-8?B?VVJLeTBoU01HTXU2QTh0YjJyYW1lTFZZdjhHLzJZT3YxOEkzckFQemk1Y1E4?=
 =?utf-8?B?dVhJZVFxMGxFSnJlSlFoTmNNSDZ3cFBTcVZXUC9tY3JNbG8vNERUZDVNV2Fj?=
 =?utf-8?B?bXFpTWJFR2tpNnFPVzhnd1ZtczIwZzN0OFJ6WEFxbW80RFFmejJaQXJ3aWZz?=
 =?utf-8?B?TEI2VVhJMDV2T1VHM3U3ZzZRUjVLdzJXN0I4OGt2L3ZpSmg2ZnNuWXNUMUxh?=
 =?utf-8?B?RkJocC9YT0gybHFlVjVKU2hSajVhSmtzVFI1S2Y2c00xcUhKV09aNWJIZjdY?=
 =?utf-8?B?WHd5SEcrWmp3ZTY2QytrdnZOcHRPc09oeHpDNzEvRFgrVzVaS3JaTW85Qnpm?=
 =?utf-8?B?Vmo0QTVGdk9RaGF4SXVJeEs3ay82NWdFZURBQTRya3VIZmUxY0dQQUkwN1kv?=
 =?utf-8?B?UGltVERLT1RmRXJwV0wyZERkWFNuWjZYQkd2Tmd6YURaUHVjRm1RU3pUSDhk?=
 =?utf-8?B?czNyenNRcTQwMlB6Wm85SVlNYjV4elF6K0c5dG42ZlR3OXFkOWxsU05WSk54?=
 =?utf-8?B?RW9hTDlRNWlvMG94N0YxMWJ3M1pKNExNSWUyN3pwYm5iZk1WeFVVaEpYZ2dm?=
 =?utf-8?Q?/AxbcXHOmvjqK5QRs9Fb0+DM+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9fc735d-b1ee-4c5a-0794-08da5907f423
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 13:13:12.3175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BBbJUIVyuQ3tus4jVzjYuJK+rZ1VKQVhp544b6HteZl9BXFv+/7rgBNCEZUfcXvf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5938
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Marcelo,


On 6/27/2022 8:06 PM, Marcelo Ricardo Leitner wrote:
> Hi Oz,
> 
> On Mon, Jun 27, 2022 at 06:19:54PM +0300, Oz Shlomo wrote:
>> Hi Marcelo,
>>
>> On 6/27/2022 5:38 PM, Marcelo Ricardo Leitner wrote:
>>> Currently, whenever act_ct tries to match a packet against the flow
>>> table, it will also try to refresh the offload. That is, at the end
>>> of tcf_ct_flow_table_lookup() it will call flow_offload_refresh().
>>>
>>> The problem is that flow_offload_refresh() will try to offload entries
>>> that are actually already offloaded, leading to expensive and useless
>>> work. Before this patch, with a simple iperf3 test on OVS + TC
>>
>> Packets of offloaded connections are expected to process in hardware.
>> As such, it is not expected to receive packets in software from offloaded
>> connections.
>>
>> However, hardware offload may fail due to various reasons (e.g. size limits,
>> insertion rate throttling etc.).
>> The "refresh" mechanism is the enabler for offload retries.
> 
> Thanks for the quick review.
> 
> Right. I don't mean to break this mechanism. Act_ct can also be used
> in semi/pure sw datapath, and then the premise of packets being
> expected to be handled in hw is not valid anymore. I can provide a
> more detailed use case if you need.

It is clear that the refresh design introduces some overhead when act_ct 
is used in a pure sw datapath.

> 
>>
>>
>>> (hw_offload=true) + CT test entirely in sw, it looks like:
>>>
>>> - 39,81% tcf_classify
>>>      - fl_classify
>>>         - 37,09% tcf_action_exec
>>>            + 33,18% tcf_mirred_act
>>>            - 2,69% tcf_ct_act
>>>               - 2,39% tcf_ct_flow_table_lookup
>>>                  - 1,67% queue_work_on
>>>                     - 1,52% __queue_work
>>>                          1,20% try_to_wake_up
>>>            + 0,80% tcf_pedit_act
>>>         + 2,28% fl_mask_lookup
>>>
>>> The patch here aborts the add operation if the entry is already present
>>> in hw. With this patch, then:
>>>
>>> - 43,94% tcf_classify
>>>      - fl_classify
>>>         - 39,64% tcf_action_exec
>>>            + 38,00% tcf_mirred_act
>>>            - 1,04% tcf_ct_act
>>>                 0,63% tcf_ct_flow_table_lookup
>>>         + 3,19% fl_mask_lookup
>>>
>>> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
>>> ---
>>>    net/netfilter/nf_flow_table_offload.c | 3 +++
>>>    1 file changed, 3 insertions(+)
>>>
>>> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
>>> index 11b6e19420920bc8efda9877af0dab5311c8a096..9a8fc61581400b4e13aa356972d366892bb71b9b 100644
>>> --- a/net/netfilter/nf_flow_table_offload.c
>>> +++ b/net/netfilter/nf_flow_table_offload.c
>>> @@ -1026,6 +1026,9 @@ void nf_flow_offload_add(struct nf_flowtable *flowtable,
>>>    {
>>>    	struct flow_offload_work *offload;
>>> +	if (test_bit(NF_FLOW_HW, &flow->flags))
>>> +		return;
>>> +
>>
>> This change will make the refresh call obsolete as the NF_FLOW_HW bit is set
>> on the first flow offload attempt.
> 
> Oh oh.. I was quite sure it was getting cleared when the entry was
> removed from HW, but not.
> 
> So instead of the if() above, what about:
> +       if (test_and_set_bit(IPS_HW_OFFLOAD_BIT, &flow->ct->status))

I think this will set the IPS_HW_OFFLOAD_BIT prematurely.
Currently this bit is set only when the the flow has been successfully 
offloaded.

> 
> AFAICT it will keep trying while the entry is not present in the flow
> table, and stop while it is there. Once the entry is aged from HW, it
> is also removed from the flow table, so this part should be okay.
> But if the offload failed for some reason like you said above, and the
> entry is left on the flow table, it won't retry until it ages out from
> the flow table.

But then we will never have the chance to re-install it in hardware 
while the connection is still active.

> 
> If you expect that this situation can be easily triggered, we may need
> to add a rate limit instead then. Even for these connections that
> failed to offload, this "busy retrying" is expensive and may backfire
> in such situation.

Perhaps we can refresh only if the flow_block callbacks list is not empty.


> 
>>
>>>    	offload = nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_REPLACE);
>>>    	if (!offload)
>>>    		return;
