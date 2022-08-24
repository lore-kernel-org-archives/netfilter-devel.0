Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52196C3F6B0
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Aug 2022 09:35:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235131AbiHXJfj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Aug 2022 05:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236371AbiHXJff (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Aug 2022 05:35:35 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D301387
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2022 02:35:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pf2zfI2kzqWjG07WLLHyhxP3quEwYJ6XimVToh9qYLIRvZPNKx1sR+ZB/OxzMLBKJRmtqBfS2AoUbrtflFzeFQ/xnZnH1kh4YNmwjyN0tVhoNrw7TPbb5iDGqfSIFLi/n1ts8c31HGRWl/8koFN7h5vTLNLo47m4uLmHTl8d50m/6IiTXiPUmk+os4cXbtVQDqwoD9URHb3IG8kgP7JBvu1CSIBB9dLib50eWD5URq0uIV6RSYZ9LTouekK8SXY2VGdQVpWgYZrjTAy3C0yiyFfnHomg1I9G1yCkhEB0kUlCQhNV1SM15aUl9K+KTHcz6PVhwu8a6y66B/+oa0eFFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DiPFIklB5ibaYJZ7DIQIl/6Sdi7LqOwd3ym0JbT6ZWY=;
 b=hUTeUCWQJOOXPNmuYmBCknITC7jrSxeHxBR+cVbOBoDJGx1EPUNVHH+H8KPqkr75zQnlTbHBqxXJDtpIwumz2YUQgR23Oec3fp+vRdyKbnWm3es220gOHEwz2rzHAemKZ1tfV+SrQbplKSWI8+QWu4A9e6Jl6eVcdkWnnW5166brCB8xQ6+EClHhihXH9c2VykY5BxjlwcPXY3zNQtBL5jOAmlin4eG1wxzBq4BPVhOZNJbW9i1QJo/2Ll7ZOEmGZz3vN3bk2C6yvFNb+Mm/BdEYn0GKOD8Q0Hn/JRf1PxFL+loNQ/XGkXEF86/LYY1CqkT7EmiYNailuHaj3aBrXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DiPFIklB5ibaYJZ7DIQIl/6Sdi7LqOwd3ym0JbT6ZWY=;
 b=Z6Hx0VasmOn+D2ejk/UzzPlRtp9GQBB+l/70C8Q55jTzHXpZGqofQZiNKfvAWm92KO8KfO9hMO1oNHJaaGVWtzLF3HPKQEzFXmfhtw8C1McSbHAaU5h/yjXZBRK1yBeOQxn+r4KCDTBp2D6jtmzt/RyosuMenRJzw8zDdViTq2EVMYWHRJod1DsvLB7v70998B9fMpKHqtiDvYll4AK0bRTyhTBiNfkvP2EQ8aMvXmWKZd539xOIYZrC5vlTSAd2L11SADSNEXLNse/gnkywdqilB4ptaV46MeBS0y8R5I5AYHpb4U4/Us7lnVEIVIaj8WtaZZJ+l1HxKByWGhP/jg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB5629.namprd12.prod.outlook.com (2603:10b6:510:141::10)
 by CH2PR12MB3992.namprd12.prod.outlook.com (2603:10b6:610:29::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.19; Wed, 24 Aug
 2022 09:35:32 +0000
Received: from PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::61f4:2661:ffa2:e365]) by PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::61f4:2661:ffa2:e365%5]) with mapi id 15.20.5546.016; Wed, 24 Aug 2022
 09:35:32 +0000
Message-ID: <6c95c291-c428-bc1d-e55a-3ff59627db11@nvidia.com>
Date:   Wed, 24 Aug 2022 12:35:21 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH nf 2/2] netfilter: flowtable: fix stuck flows on cleanup
 due to pending work
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     roid@nvidia.com, ozsh@nvidia.com, saeedm@nvidia.com
References: <20220822212923.13677-1-pablo@netfilter.org>
 <20220822212923.13677-2-pablo@netfilter.org>
From:   Paul Blakey <paulb@nvidia.com>
In-Reply-To: <20220822212923.13677-2-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0318.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::17) To PH0PR12MB5629.namprd12.prod.outlook.com
 (2603:10b6:510:141::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58544338-9ee5-4f98-c2ac-08da85b3fd44
X-MS-TrafficTypeDiagnostic: CH2PR12MB3992:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s5YoRCRIFip60E3c7hehqQvtI6qyhj6QP4Up5frtI8Ry5U60XxoZP4SZR3AXohKogpQ2NYoE6k4u8/DEVerHprYjQYkgayhfuT/zM++2UvHGJOlO40fQXmMRvMbD0BWs+ZN76MCdwgp+SMOxW7zsV3IcGqFChAqv8j55jCTURd9nU6IsXQ7qs/V64l74fzFREzHUnMySDB5ChK0JaMnX0Pe/xvBct/pE+xs+S+QcblOXpmuHj1EKo36JQY4c8UqwVNLQrjABOsPUGfoHHvhHX47nQvWNF30aeya322GcPWzu3BLIGqBcmCfN4t1z7ITftHjYEXrgJivvIcN6OVkxF7SSaW+RYO1RzmKRNWZ5Qde6pG8Ywu/nyZZ1x54pU/WxQ6gAUlW6Qc/tnLnoKsFpYrkmsoEBr0h8lNeqO9TMfAZg3rNee7XIoTdKoqW4q3vdOHoQ16tNGnJ7V25wyJI45tJsjlkcAB22dA0zrI9ryV5oZJABkrCEpScPW8A+UmZuSZV1pLo8fgfJLzUmBBpSrlBkutqmMQS6fAEovsGVzB92QB7N3aVQK/eqxNuUowYp8nc3ES+S/CUz4WQ9EHR9E6R6j5KLgvTvOQygfZFwSDocs9qnsgds7oXLDFqqXwSnIQuzr7Ap8A5uBJB3iI9qPcOah9UzhLppzMC6+Vmro+3PY8XjYKs2Fm8uAb5mwFfE06QXIcz7+dFmW2OIXtjeg9xEIcpaVCW4oZqBu0D36C4Kt+MZ4GvCOylCwWkHCDpE/go8YrwWQNzgXJX8rh7AzAnyRHMvN2rAGn8KiCXKDbw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5629.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(346002)(366004)(396003)(39860400002)(2616005)(8936002)(41300700001)(5660300002)(36756003)(4326008)(6486002)(316002)(6666004)(8676002)(31686004)(66476007)(478600001)(66556008)(66946007)(107886003)(26005)(31696002)(86362001)(6506007)(2906002)(53546011)(83380400001)(6512007)(186003)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OFNlaDRiRFJzajVhcmRxa3p5WWIvcFZ2QmhKVGlnY1R3RkJBRHMvcXJrZkVT?=
 =?utf-8?B?ZGl6aEZUTkFqTWtONFR2Z2JlVU5RdVYrTlhFSVorZkZHWE9IMm5NeDBBOU9U?=
 =?utf-8?B?aTgvUUdXS2NlT3pSKzN1OEpiSXlYdTRLd1RybGowVlNqMWN4VHNMME1YSlk5?=
 =?utf-8?B?TGkrUGwrU3ZmMkxxSUU2aWtnTDNtVkIzMDZzYlVaSzNNY0MyTnMrVXR6SDNB?=
 =?utf-8?B?NWYydEQ0YUhqOXZSNEJFcVB6bFMrQmp6OHFZWVhxTFNKUmtCYjN2QTRoeTNP?=
 =?utf-8?B?RmV0MHlPV2RuMGkzVXZKMGNhV0Y5empuZENiRm40V3ArNnFCTWVUZVFkUDJL?=
 =?utf-8?B?NUY3WVozbkh0YzFZMXF5anZCdGVTZ3ZQSnNCU3ZYSE9XTHg4dG5VaXVxcElZ?=
 =?utf-8?B?L1NXejhPSGVPOSt2bnZsZFU1cXMwUDVmbytmV0Y3NEdxNFpzY2RkVWhaQVMx?=
 =?utf-8?B?ZTUzWWpPbHZKSVk0bkN5Ti9CbHp2S0d0QXFLWkFjQlpUdXNqNWNqUkNyai8w?=
 =?utf-8?B?ZENqTkx4NGJzZlVkQWhlTzlkbzNrT0w0Y0FQbWl5MVltb3Y2WkVjOVY0ZjRG?=
 =?utf-8?B?bTZQMnFLbnhJZ0ZRL1BuTXZ4KzlwZ25pUHJpdHFXaW5MTzdhL1BHQmFaR2lv?=
 =?utf-8?B?MXJTc0hBQjhISTZJVU5TSVBBd0JOUkI2VCtQbjcvUGQzbldPN21FbTM2ZFRk?=
 =?utf-8?B?cjlmK3llbnNKUmJyUCtRNnpncE5hSnVDbUxBWmo4OUtEV2ZiMm0yNU9BRWdD?=
 =?utf-8?B?dmJVR2RNL3RtdGhObEQwVm1leENRVWdnSzNKd1UyNkFnd3VJNENPMzhZUnAv?=
 =?utf-8?B?Q2x3R0doa29ieFRzeG9YSmk0Zit3aDZISVVSVmxuMnFVY1BKQ3ZtQWY1U1h2?=
 =?utf-8?B?cjh2SmUrcm9WVXlxU2F6bnRjYUhsUGlRVVpkQUpOYzA4SDZ2NUdHeWVsVE1v?=
 =?utf-8?B?VEV5eExQMXRNUGFyQXhKNjBjVGlQK2kwT2NSd001RGZuRUVIVWhFTGU1MVdz?=
 =?utf-8?B?TFBuZUlBZjB0M2xXTGwyUjh2a2hqSU9rbW9oSGg3UmJ2dGt3WnJyb244UWpY?=
 =?utf-8?B?RnFPbXZzbmpNeFIvcDlwMlNVL3puV0h4endscERHcmcxUFVtUzJHSmFRTEta?=
 =?utf-8?B?S1ZYWUNsZXd3Rm5iejVNREE5ZGU2T0ZtT3c3QThteUwwSXhjNUtuQmo3TWVn?=
 =?utf-8?B?M2Z0RGRrZGhScUhyK0c2VHZYNnJWQ0xGN2xDbERDSXZXbHhidEMxMHFoVVNX?=
 =?utf-8?B?NFV1Q2cwVDdObm1BZWhSK21lNFZaRXdJbVZtL2hYTm9pb1pVOFRnUkNndWhz?=
 =?utf-8?B?aTdXMlpYZ2NyaGRwUDlPMXNob2ZUYk11Q2d0UlVFcEVORDlQUlBGSC9TLzhx?=
 =?utf-8?B?ZjhCTjV5U2U3aTdPcFZHZG92ckY4ajhvSm9Kd3QrMTFuQnl2WmlkbWZsZnpy?=
 =?utf-8?B?blY2Rm1sQTF4bi9OWWxTMkVZZ2V0WnN2NTZzRGloTFhqS1VsUmVkN3FTWHpk?=
 =?utf-8?B?OXY2MVhsWUM2MVUxUDZCVDI2cUpxTFVwd0U2cWtTbWlhRG16Q2VaZnZ6Mjdw?=
 =?utf-8?B?Rmo2OHUrdHFjbTI1U0hFa3Fad2hzOTBNYWNXMHVBc1N4NE0vRDIwNllGMG5U?=
 =?utf-8?B?eHdrZXU0dmFVdUMzYVd1bU1KcG9OSTliRVZZZVE4bVh3VFdLaXlIRnA5aGNO?=
 =?utf-8?B?cEV5eTY4enV4WEdIL25hY3ZYV3hRdCs1V3E3NC85UXdWY00rN1hMUitSNEVz?=
 =?utf-8?B?QzMxRUtLQldWdWFXdkFnbzRWcyswdzRsQytRcEJrelZjM043NWo4KzRxa0Jn?=
 =?utf-8?B?K05GemJ0N0tCM3Z3WFdWclNTUUdHQ3NjUm0vSXFZaEtLVldRb2gyNEMyY2x3?=
 =?utf-8?B?TFdGWGtPS3lvWW54ZUg4czdSUG9wbCtDQXRpejEvWUJSM0d4SGZZMmo0b3BG?=
 =?utf-8?B?MHB0T05neXdyT0k4V0FFYXZCUzh1V3hMdkYvcHY1YTRuZmFZdllLYW4yTHVi?=
 =?utf-8?B?V29mRDFaNWRWeDcwbkx6VDE4U2NuS09NV1RhNGtZWFNWZXlXV1ZmZG9MSFE0?=
 =?utf-8?B?QlErbTl2STd5dDlnMkhVK0pkdFBSUTlvY0pwRUllOUdzcCtIeTNzSnJSeVpY?=
 =?utf-8?Q?XxPBbRqDh83HhFfgVXxkuausN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58544338-9ee5-4f98-c2ac-08da85b3fd44
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5629.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 09:35:32.4422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NseEF3K8sycarKjSEwZhest7USWH8ak90JjK2SIPKAokzvZKtmZP+5hS1ujII49d5yaEcC2ai9n02tGwWTEhvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3992
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 23/08/2022 00:29, Pablo Neira Ayuso wrote:
> To clear the flow table on flow table free, the following sequence
> normally happens in order:
> 
>    1) gc_step work is stopped to disable any further stats/del requests.
>    2) All flow table entries are set to teardown state.
>    3) Run gc_step which will queue HW del work for each flow table entry.
>    4) Waiting for the above del work to finish (flush).
>    5) Run gc_step again, deleting all entries from the flow table.
>    6) Flow table is freed.
> 
> But if a flow table entry already has pending HW stats or HW add work
> step 3 will not queue HW del work (it will be skipped), step 4 will wait
> for the pending add/stats to finish, and step 5 will queue HW del work
> which might execute after freeing of the flow table.
> 
> To fix the above, this patch flushes the pending work, then it sets the
> teardown flag to all flows in the flowtable and it forces a garbage
> collector run to queue work to remove the flows from hardware, then it
> flushes this new pending work and (finally) it forces another garbage
> collector run to remove the entry from the software flowtable.
> 
> Stack trace:
> [47773.882335] BUG: KASAN: use-after-free in down_read+0x99/0x460
> [47773.883634] Write of size 8 at addr ffff888103b45aa8 by task kworker/u20:6/543704
> [47773.885634] CPU: 3 PID: 543704 Comm: kworker/u20:6 Not tainted 5.12.0-rc7+ #2
> [47773.886745] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009)
> [47773.888438] Workqueue: nf_ft_offload_del flow_offload_work_handler [nf_flow_table]
> [47773.889727] Call Trace:
> [47773.890214]  dump_stack+0xbb/0x107
> [47773.890818]  print_address_description.constprop.0+0x18/0x140
> [47773.892990]  kasan_report.cold+0x7c/0xd8
> [47773.894459]  kasan_check_range+0x145/0x1a0
> [47773.895174]  down_read+0x99/0x460
> [47773.899706]  nf_flow_offload_tuple+0x24f/0x3c0 [nf_flow_table]
> [47773.907137]  flow_offload_work_handler+0x72d/0xbe0 [nf_flow_table]
> [47773.913372]  process_one_work+0x8ac/0x14e0
> [47773.921325]
> [47773.921325] Allocated by task 592159:
> [47773.922031]  kasan_save_stack+0x1b/0x40
> [47773.922730]  __kasan_kmalloc+0x7a/0x90
> [47773.923411]  tcf_ct_flow_table_get+0x3cb/0x1230 [act_ct]
> [47773.924363]  tcf_ct_init+0x71c/0x1156 [act_ct]
> [47773.925207]  tcf_action_init_1+0x45b/0x700
> [47773.925987]  tcf_action_init+0x453/0x6b0
> [47773.926692]  tcf_exts_validate+0x3d0/0x600
> [47773.927419]  fl_change+0x757/0x4a51 [cls_flower]
> [47773.928227]  tc_new_tfilter+0x89a/0x2070
> [47773.936652]
> [47773.936652] Freed by task 543704:
> [47773.937303]  kasan_save_stack+0x1b/0x40
> [47773.938039]  kasan_set_track+0x1c/0x30
> [47773.938731]  kasan_set_free_info+0x20/0x30
> [47773.939467]  __kasan_slab_free+0xe7/0x120
> [47773.940194]  slab_free_freelist_hook+0x86/0x190
> [47773.941038]  kfree+0xce/0x3a0
> [47773.941644]  tcf_ct_flow_table_cleanup_work
> 
> Original patch description and stack trace by Paul Blakey.
> 
> Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
> Reported-by: Paul Blakey <paulb@nvidia.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>   include/net/netfilter/nf_flow_table.h | 2 ++
>   net/netfilter/nf_flow_table_core.c    | 7 +++----
>   net/netfilter/nf_flow_table_offload.c | 8 ++++++++
>   3 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
> index 476cc4423a90..cd982f4a0f50 100644
> --- a/include/net/netfilter/nf_flow_table.h
> +++ b/include/net/netfilter/nf_flow_table.h
> @@ -307,6 +307,8 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
>   			   struct flow_offload *flow);
>   
>   void nf_flow_table_offload_flush(struct nf_flowtable *flowtable);
> +void nf_flow_table_offload_flush_cleanup(struct nf_flowtable *flowtable);
> +
>   int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
>   				struct net_device *dev,
>   				enum flow_block_command cmd);
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 60fc1e1b7182..81c26a96c30b 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -605,12 +605,11 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
>   	mutex_unlock(&flowtable_lock);
>   
>   	cancel_delayed_work_sync(&flow_table->gc_work);
> +	nf_flow_table_offload_flush(flow_table);
> +	/* ... no more pending work after this stage ... */
>   	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
>   	nf_flow_table_gc_run(flow_table);
> -	nf_flow_table_offload_flush(flow_table);
> -	if (nf_flowtable_hw_offload(flow_table))
> -		nf_flow_table_gc_run(flow_table);
> -
> +	nf_flow_table_offload_flush_cleanup(flow_table);
>   	rhashtable_destroy(&flow_table->rhashtable);
>   }
>   EXPORT_SYMBOL_GPL(nf_flow_table_free);
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 103b6cbf257f..b04645ced89b 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -1074,6 +1074,14 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
>   	flow_offload_queue_work(offload);
>   }
>   
> +void nf_flow_table_offload_flush_cleanup(struct nf_flowtable *flowtable)
> +{
> +	if (nf_flowtable_hw_offload(flowtable)) {
> +		flush_workqueue(nf_flow_offload_del_wq);
> +		nf_flow_table_gc_run(flowtable);
> +	}
> +}
> +
>   void nf_flow_table_offload_flush(struct nf_flowtable *flowtable)
>   {
>   	if (nf_flowtable_hw_offload(flowtable)) {


Tested-By: Paul Blakey <paulb@nvidia.com>

