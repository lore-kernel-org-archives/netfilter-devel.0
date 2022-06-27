Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 287A2C43334
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jun 2022 15:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238079AbiF0PV3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Jun 2022 11:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238037AbiF0PVH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Jun 2022 11:21:07 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2073.outbound.protection.outlook.com [40.107.100.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82C118B30
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jun 2022 08:20:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h1bb524O/ZCBPsJUO5A9WlmGmb6Y2hm5qXMRazuYt72OYSt5NEte/y1qk1raRDlFDseHFueS5St22M0Od/3LHkTTHttJXlEmSais9JxO3p+4eMTDMMAIvD3TcPVvWMET+YKkex2OECNWlFf0YZC5DmJlhyxeXmp73nct4T5Ms5dsQ076AaTpv0TVXYyFPp6ucctdLc4d37J0FFxgWsT4Wtih14WWCDdYyaOwg4taIc63bJfhv0sQDqeUhMgk1lZzAs/ZivujMpx9CynHG6vrOBOb1k2JcAv9kGRhCcbupcs5B23vXDiIIpsWtncCXoPXXUtrwUiKsY7hCt1tk1lmhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hYIobtpsIE+2CAd0qKVZCbUTwsGFX8dVbrOf0dENcvE=;
 b=jCvXk/VOVUFBqjNS/UQ9TaFZ0W1QNlRBysXqhR7xngtI3rBhdPrl3od0SUINsy2BezJAyH/07Jwrz7sRfJHA60MF+fC6QjqQ6e100Hjw1hamHIBI+WtLPKqHbXUWXXPtGjriGqyEEEZ6mXG+o/q8c/MkANrrxwBMbnlLDnq+P8xnO+oxxnSfaF9MHsESCSf7F+psX/xb0NxeGDpnljNHaCJaIfpf39zJ4i83FuoYm+B8kctPlbp1OocbXgqxe95I5D3Ak2PXzfbq9yqXXwDHAH5wqreVBfLWhV27EwBxVu7F8z9XOb/9DkUbGHe06cNkDep1HNHkIkFpOkAB+j24Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hYIobtpsIE+2CAd0qKVZCbUTwsGFX8dVbrOf0dENcvE=;
 b=WmAv6RF38w1YLf/HGyMQQwGlq0UW9+ZLIp5oiS5lwjGnDb0tdAcz0305elWpjDRSME5TmgOtDIWRq4mqEyTpIY5UO9tk0+at2/30DKaurOKXHSDifn31pkuGaq806xxWJs+RHFhE0+VvWIfPxRpT8KT4Yp0RPbuqd7rgex5/7vbJI+9j3UiPYRn4diOTd7mKVhfaCp3uaO2U2XG/N9u9IExvgvA4EouuoO6hlRPtlCs0pEnkmU3YJN6FsBf8cExqKLXCM6qTANxVKLNvvwpMwJkUzD2DN5r5UamNwrpZLtCIqmps/zg/49ujfDpsweG+9iXqo4boHRH1jry6FHGjOw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 CY4PR12MB1414.namprd12.prod.outlook.com (2603:10b6:903:3a::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.18; Mon, 27 Jun 2022 15:20:02 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::1075:9d96:7eaa:3f9f]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::1075:9d96:7eaa:3f9f%4]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 15:20:01 +0000
Message-ID: <c5039f5a-5295-a457-65c5-d7016d6a5034@nvidia.com>
Date:   Mon, 27 Jun 2022 18:19:54 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH nf-next] flow_table: do not try to add already offloaded
 entries
Content-Language: en-US
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Paul Blakey <paulb@nvidia.com>
References: <95c2aa63adea29e6008ee45af17d199492f4d14b.1656340577.git.marcelo.leitner@gmail.com>
From:   Oz Shlomo <ozsh@nvidia.com>
In-Reply-To: <95c2aa63adea29e6008ee45af17d199492f4d14b.1656340577.git.marcelo.leitner@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0148.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:188::9) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: faba2350-3277-42bd-81d8-08da58508144
X-MS-TrafficTypeDiagnostic: CY4PR12MB1414:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NHrXbpq0bnvMe/vdJK93G5tuzMD+OeBXwIMOZMJwmBSX169Lm3wZwIEL0rzgL0lomYkN8jSbohR3vppLYQrvkjQQVEBb+6zQADFexknQWai7tPQwsgezhGt6RvkVonpJChnq80/wEY8pJeNzN/6OnWhngTJSxIKCbcm2IUTP5rQ6G0LJ7dhHUUKK6ZmgGMvufpBnQ7CaKKHlnW1EUw+q2mox5aiDI3C5P1ZCLPadJ+8IjboRsYSbkvJ5c82AvkZ2j34Y0/gTzvQ9AgCpIRaDDj4k3RKEGf1sOjoZbwgEuV2497q6znIxZesqc6Cw7egtSc+/ybPIbA3rCNAS+DMbNGFjT4RMU3/UPFu1w5pjcXi38m6E61O3IGrUkCurZgshqcIVU+hcN/d6sU+BefUSV94Z4FxFPuYqVNp7+w8y4nADYrQA3X3oVFEMHuho5b7tFeAzKy5eXHRy1lx9kng7KDG/v1EF6GpwQ1hshOl84VdsoeI8XnfXeD4CMwHEpoLfb8NwBOyKn9OMDveR7K18HrpvMuE1S8ImFtWBFfxUSYFfPgvZQl3aWQoc2LTuOkYyR5o50BDx2EYTjbgITMDPxYN8sMs+ywwsyN+BYVMSWMqxLbabKc31t0e22lJQwL2s9pjJabsu398k/tmqcKSwvPiSsoqzZr+/miWHNAm22lYfU7a8MHX/kCJt0nsrQonmbuo2TWHtNg4+zwx00Kebwf++9Fenonxv1cJnkPvFHshPKzqNOaKSLCSEIWlJYqe46R2BLaxo1Akjpfx5hBnoFGVa3+nOb/yh+NDneRncKX4U1By8g6sZgwurYYiJrBdzjFi7VJSEs6z1w2gxAjx5sw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(376002)(39860400002)(396003)(136003)(6506007)(478600001)(5660300002)(31686004)(2616005)(107886003)(6666004)(36756003)(8936002)(6486002)(38100700002)(26005)(53546011)(6512007)(86362001)(31696002)(186003)(2906002)(83380400001)(66556008)(66476007)(41300700001)(316002)(66946007)(8676002)(4326008)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TnVWd01uL0pyc3Fack5zWUlqNTFjOXdJcUZIZS9WWG92YS8vVWE3anJic2lQ?=
 =?utf-8?B?dVEwT2k3RDZvVWRDdDI4aFJFTStaQWdqUmt2alNLYlIrNWpwczBNd1RCbmgw?=
 =?utf-8?B?SHBRQk9yLzU5ZTcwTkpIam92UDRaT2x3MHZQd0VoaGdWYWQ4bnVLNC9SdndK?=
 =?utf-8?B?U1lRVnU3Rzk3OSs2YStmeGo2NDV5cWkrTmxzWXJvekZuUXZEN25zUVdhYXp3?=
 =?utf-8?B?Nll4OVJMMXpwUXYvOTBMbm5qbG4xdTkyeDZNKzB2bm9PYXNqUGk5b2tLL3BT?=
 =?utf-8?B?aGo0MGJQMW1GSy81SVlJVDR3UDlLV2xhMXhFeDU2ZVNvZ0FZSmRHSFBGMHY0?=
 =?utf-8?B?NTQ0Y3I2K0R6M3VJYzBpRFVsWWxxajVHbmhtNFhXTEdYa1pGYlQ2SDdFdHpv?=
 =?utf-8?B?aHRwRytNUkttd21GcE8xUTZ3QXVlWVZ0dnE2TWNOVXBaNUZOcVhZK2diR0tq?=
 =?utf-8?B?MitTUFJ3VVgxR0kwTk40eVhRSFBpeHoxM0hkK0hYcU8wNmQvOGJLRk1iNmdu?=
 =?utf-8?B?OTF1UTNpalEvcUUwLzBBaWZxUWpVc25PNFRGb0k4MHl2ZWlUOG9xaitkVmxY?=
 =?utf-8?B?ZFRwZm00T09ISEp6MWZoY1N1N1JhV3ZuWU1MYlNkeSsreEpVbHBUeCswMXN3?=
 =?utf-8?B?MXZYSVdvZ2VERk5xeVp5SHpNRVk1dmowM0JxWmFwUkN0VTZGa3J3dmE3TzlV?=
 =?utf-8?B?L1RXODU1aWcrV0NhbzM5YTJPaEcveFpoaG9vbVZBbGtxSWxGUjR1bExNejZv?=
 =?utf-8?B?UUpHL1FDenhuNGVEZmdCZE1zeDFqMXRUdWVRcWJDSUt2SVZxd093NnNnRWov?=
 =?utf-8?B?UjA2V3BjSlZTNDI3VlZUQ3ZiaEpFcWJ2cHA5ajlORWc3RnhRbHU0My9wSG8z?=
 =?utf-8?B?TWNlUEgwUU4zR3hkYnRobCtnYnV6MnRDZGg1SmMySVlpZXdVYWtITUNyZVVE?=
 =?utf-8?B?TDJmZW9JOVhSMFdMdm1GcmhUcG91L1lBYThFRk1TUzVqcWVHYVpLV2ZHdnRY?=
 =?utf-8?B?aEhvQ0dURjI0MVZCZWxKUjdGdUpza3loVXVOR1VIZU8vNWpSM0QzODBISnk4?=
 =?utf-8?B?djVxbmlETmlCZHRPbWRnODE0cUhCSVpEMVpBeWZKSit0Ky9wRXE4d0dINHBK?=
 =?utf-8?B?SUIvL2NMU3dFWGZCWmY0dFU0V09Wa1o5RWptYXhWS3g4K1pINjhkQkZoRnBp?=
 =?utf-8?B?OFl3NWhLQ0JvNjkxSlFhRE5STGw5eHJ5cWhXZ0p1ak5TOHMyVEh1Y2lZeUVz?=
 =?utf-8?B?bkJTM2Q5U25ScXlhMHJyOVB5cG9hZVNqWWVYWmIwaGx1YUdKREptcnRXL3ph?=
 =?utf-8?B?NVRzcXZOcEI0THlOOWk1YVl4Vzg4S3JiVXBRWURMSjU2SmMyR28vcExvcGFn?=
 =?utf-8?B?MFlubExmck13MCswSUFsSUFmRlRycmJVZFlDcFVldzBHbmxKRjZGaDlnam9n?=
 =?utf-8?B?U1FCcTI1WTNPS1gyK21CLy9xbWJqUS9XWndJdnJLSk9wOUllKzNNeEk1SjQ4?=
 =?utf-8?B?TzJvRktUTVlwcGt5dEtpQUVLcmxPQnpySVd2ejZDb1EycXQvcWdwK3FsaURi?=
 =?utf-8?B?bllldG1QenlyK0w0ZHdKOFNPR3JsL0JWU3p4L3RUYkFVZnozNC9XcklUbTFR?=
 =?utf-8?B?S00vU05ueDY4N1lVWFJUN1FVNVdZekxXVVZLaUFGSXlOVzBRNnRpYXYzUmda?=
 =?utf-8?B?OTVmenZVL2UrZjVzQlljbXpxeWo4TUl5elNuUDhiWDZBbFdhY1c3RDEwMHN5?=
 =?utf-8?B?MHl1MzM2ZmZXZG8xMVlxVXlUQ0UreTJsN0pzNWpPb00xU1dEYVowb3dUNHh3?=
 =?utf-8?B?QTFmUzlzdnZWZzZja1VNQ3AySHFDeHZyWTExaStjS3huREQxS01pSDV4ZVJC?=
 =?utf-8?B?K1RTWWNEQk5WYjU4aVV5bVVveU1OUXd2Y2p2NzBpbDJSdEhGMmloTUpYSm5P?=
 =?utf-8?B?Qm1WdEJ1ZWxFTi9vWDlMZ3BHUThaVW5iVnYwc21jbktqcklhRS9XL2xCMUts?=
 =?utf-8?B?QnBFNmZkZzlyM1lZcG1MTGZyVC94Q25oOXRkV3g4VXp1TitteDBDQ0RwSUNS?=
 =?utf-8?B?dmFXbndoSm1GREN6Sm5JMUlIeEk0S0thaHRQTUFVcVc4K3pTRnFKbzJjSU9y?=
 =?utf-8?Q?aeg/wjJHKNcflo+5GwUMyM9/8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faba2350-3277-42bd-81d8-08da58508144
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2022 15:20:01.8537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P7tKXiRHdFw0ny38/gRiPvhPb23dbL6/Jcmlh49+Q37pMmaeez2datbJ6iYgGQ1u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1414
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Marcelo,

On 6/27/2022 5:38 PM, Marcelo Ricardo Leitner wrote:
> Currently, whenever act_ct tries to match a packet against the flow
> table, it will also try to refresh the offload. That is, at the end
> of tcf_ct_flow_table_lookup() it will call flow_offload_refresh().
> 
> The problem is that flow_offload_refresh() will try to offload entries
> that are actually already offloaded, leading to expensive and useless
> work. Before this patch, with a simple iperf3 test on OVS + TC

Packets of offloaded connections are expected to process in hardware.
As such, it is not expected to receive packets in software from 
offloaded connections.

However, hardware offload may fail due to various reasons (e.g. size 
limits, insertion rate throttling etc.).
The "refresh" mechanism is the enabler for offload retries.


> (hw_offload=true) + CT test entirely in sw, it looks like:
> 
> - 39,81% tcf_classify
>     - fl_classify
>        - 37,09% tcf_action_exec
>           + 33,18% tcf_mirred_act
>           - 2,69% tcf_ct_act
>              - 2,39% tcf_ct_flow_table_lookup
>                 - 1,67% queue_work_on
>                    - 1,52% __queue_work
>                         1,20% try_to_wake_up
>           + 0,80% tcf_pedit_act
>        + 2,28% fl_mask_lookup
> 
> The patch here aborts the add operation if the entry is already present
> in hw. With this patch, then:
> 
> - 43,94% tcf_classify
>     - fl_classify
>        - 39,64% tcf_action_exec
>           + 38,00% tcf_mirred_act
>           - 1,04% tcf_ct_act
>                0,63% tcf_ct_flow_table_lookup
>        + 3,19% fl_mask_lookup
> 
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
>   net/netfilter/nf_flow_table_offload.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 11b6e19420920bc8efda9877af0dab5311c8a096..9a8fc61581400b4e13aa356972d366892bb71b9b 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -1026,6 +1026,9 @@ void nf_flow_offload_add(struct nf_flowtable *flowtable,
>   {
>   	struct flow_offload_work *offload;
>   
> +	if (test_bit(NF_FLOW_HW, &flow->flags))
> +		return;
> +

This change will make the refresh call obsolete as the NF_FLOW_HW bit is 
set on the first flow offload attempt.

>   	offload = nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_REPLACE);
>   	if (!offload)
>   		return;
