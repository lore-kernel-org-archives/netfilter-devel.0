Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC9C6C0032E
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Oct 2023 07:33:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbjJYHdG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Oct 2023 03:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232695AbjJYHcc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2023 03:32:32 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAB21728
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Oct 2023 00:32:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EVw14/l97Ytsd40eHshwa1P93hM9eyj4tZX88QTkI2+9HILgxQjLFV6f8THA2EOwqH/vtdzUE4Cai19+HEDUfYoTkAeZ04rvcqLV960iLNxqF0vVYzm22ucqWT/pkeQu0Jt4jvSWW4HtSX0oXA2Ikqt4PjV0j7kAQqiqkvgGcQo5ykyRfLc7LfxngTL3WtkbM0HN3RMTavWo77UarBe8fJX8tJjbfh703mJ35q03iZefmVJqTYSQi+SEQHq28SoP0AzZhX32UfxttjA5zq1mNsBBqsQAZPxvCXIUJKSXUnE1UIMsVnr3oYF3VzgaTTZxifhaZMAKh4M6tZSms4yXKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sTUikOre1pkg+uV/ceiW9+VnDYVc8UctjYaVoJPYdQ0=;
 b=OeuDq2TgPJcfRwfKEUkX1lh1AyELqWVgf906MvKYb/1AIzi/EqZaL9D2R+RAH02VC9LLGorZIDepzplMV7OFvyGVOfzRE7M1D+Yuy1IPSHAWiFu2Vc/rgcVRSDioLpuAMPuMbStoGIusOJWZk4+x2Z/2sq5ehdeJRDaL6tRCSqbKoeGRRkKRU6tr53zd19M27Rbh+S9D1yTdfYMkr2K90VPxOPI/mlVJ9x8n8Lm6hl09l+F2kUMQ8NqkfpyphtA4b4/Hkz4/w6d9DuAJQsEgrEJHyMl+k83/OBimK2vnSfahu6fgf5regrw5tIcZCkAgebnrnvK7lB4vXLz1yXh6MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sTUikOre1pkg+uV/ceiW9+VnDYVc8UctjYaVoJPYdQ0=;
 b=FAte5YqO3xRkeyY9AXdKtEjKw5XSQc3siFcNirA964D492uxDrFYQmeDs0B7RIqELYdQIU6fFPJIjDkhHvhTf7NtRV5h7aSDxE1vd96hrRRZGoRJ3c0wSbue/MOL0+JNwVr7Uj0NoG6wUepA41NEcgXH5OD3iCVZUm61aHHYOoEjUxJJ+KxUBBFxfoyKBltXekLQuOfe7UmoGweU0zvnXZtEie4qPGmf8gJvGWfvR197UT+WSw5Mc/IIeI4edlAQvlhllRZPNBrI2EAx4H3mDyVIQtm2slOAjtDX0dGiywMG44a0AZOb1pZMf4fDIOcwA4V/aP4HfPV3ok8SMj4qsw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB5629.namprd12.prod.outlook.com (2603:10b6:510:141::10)
 by BL1PR12MB5093.namprd12.prod.outlook.com (2603:10b6:208:309::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.19; Wed, 25 Oct
 2023 07:32:18 +0000
Received: from PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::e2f2:6c4f:5d58:40e8]) by PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::e2f2:6c4f:5d58:40e8%5]) with mapi id 15.20.6907.022; Wed, 25 Oct 2023
 07:32:17 +0000
Message-ID: <0137b038-0007-8f25-1a15-48b023cb1ea9@nvidia.com>
Date:   Wed, 25 Oct 2023 10:32:11 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH nf] sched: act_ct: additional checks for outdated flows
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     vladbu@nvidia.com
References: <20231024200243.50784-1-pablo@netfilter.org>
Content-Language: en-US
From:   Paul Blakey <paulb@nvidia.com>
In-Reply-To: <20231024200243.50784-1-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0349.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::25) To PH0PR12MB5629.namprd12.prod.outlook.com
 (2603:10b6:510:141::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB5629:EE_|BL1PR12MB5093:EE_
X-MS-Office365-Filtering-Correlation-Id: 90907f69-a297-4445-c392-08dbd52c8431
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +Is6nEKKlUYcPIaf5HDd419qXF9igj38/fSHuVM1hHRzX9hzF628DxtnSw8cpkBP6GCd68XWnxy5fdFJb5ms/m0GBtbFyt3SgZKbODII1S425i77q67EyvbUOUMZVDqOeHO2+Wv9f/lYxqx7/doSHVQwyiT44JkvjySQ6hw//6s8vvAZ2fOjVN7YDo2AEvZc/WeM8qrKNjqashU26n1WmEGiOl3bhO9RUUfH/+b7cg+gDvzMgFPCJVRAjFIVRbKTakXncfh9w0phjL4EJAh5yiMjZiv7HqJQw4HotmB+JcBMj/kGIcBZmWVybOSldYGfb1ix/FCFqtkdmUf2880QJSaCHExpCIhD/sYkrqakGr/XaS8wAd8whrtzrs5S64eYHbelAPPAjkwfT2DgiUvGvE+hWDPSEaFj/Jf5DV2ItrIeP/tIucjVGH6Esg1Af6ACiAdWcdHfxRTn8C9E2Tz1J9NjUOm2/4hg3MaBFci8XFBY23r8LO3NL3K7mqw9m3aiZUahccFvY8su3EDkvJHLVczfQZ+lmbXNILD+kS3jGr0qX00F3bdYQDaBUbCLSzYGlhoejnn4ytno/TMEiLbB+6fwbhQyzQKwfMQxcMWovsGWLBFpf+rvoTWbE0xC7AalueQkv63NNv3g9Fvqfjj2re5G/4K8PudCpRBW46iOSIMjFfgqsrF38ydTzlYx+d2o
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5629.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(366004)(376002)(346002)(136003)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(41300700001)(6506007)(6666004)(53546011)(478600001)(107886003)(2616005)(6512007)(66556008)(66476007)(66946007)(36756003)(316002)(31696002)(6486002)(966005)(86362001)(26005)(83380400001)(38100700002)(8676002)(8936002)(4326008)(5660300002)(31686004)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TmxwS3Q5RXlyekd2RUQ5eFNNU1pvZXVtUGliS1J5bUVJYTNwVVFPMDVFbXh0?=
 =?utf-8?B?RVhYbE05NWg2TGdHVm9oeFRzb0NYcXZFaUJXNU9WQmJXR3RXMFlBNTRackI3?=
 =?utf-8?B?Q0Z3cFMwQ3ZPWHl0MkhHUlRPb2FUNlV1Yk9jN054MnZlSVh3N0IzU1hvajlL?=
 =?utf-8?B?L3ZFOUI0NXRXYWhQWFZjc0hKdjB5U2hZaXRSUVdBSHVCQXY0aC9qNklTcWo2?=
 =?utf-8?B?U3JmcHFRNlVHZXE2UzFacnBZNHNzTTVpTTR3bGtIQi96YnpLaGVhMDJqc0RR?=
 =?utf-8?B?OVRnbEJDR1NYNTdsUlp0TFVnVTQ0Vms5MHlIRXlyWE9xUnNhbHRISHlhQWNX?=
 =?utf-8?B?ak9HTXB2bXhxRnhvbEdEa3krRnVtQXlPb1VBbGJyQU1oZXhxRks1QkVtTlYv?=
 =?utf-8?B?OWY4bWJvbWx6Z1pKRXhpc0xkVExlNkVUOTY3dldUbDVzTUNKLzNEQmhEYXlt?=
 =?utf-8?B?bEhSMWwwNWNYeElyOUVlOURRZjkxTGpGTG1pRVAyUHd2bnJjUDJOMXA0UXVq?=
 =?utf-8?B?UjdZSnNCZkdWeFRwV09zMlY3U3dnVWFkbzdMYnNyeHJwSzFLSGxKUHUzaHUx?=
 =?utf-8?B?SXk4Sk9GcVRSUFJtUE9yb2xvUXdIWnVlUUZ4aUpTcEhBNlJhZ2h2Qy9BYSs4?=
 =?utf-8?B?TTU2OUgyOUF1L3JBK3ZVZHBXczBmTTdXUzAzbE5WbDE1TmV4aXNmMUNYNzdC?=
 =?utf-8?B?YURmeFZERE9UblhpMEtPWG9weEc0OTFGbDR3NEhSaStXdk83ejB3dEtiUEhI?=
 =?utf-8?B?dXZUZERaNlBNRVZtZXFodEcyYUg3NHkrSEJsUGZMblhULzlDeUU5NUJBRkNW?=
 =?utf-8?B?RnlzWGpVUThmZHRUVXJnM0VsVGJWWFBNQU41SlhTTHJxb25RR09yNlgvNG1I?=
 =?utf-8?B?SDNmWWZQQVJFQzFrTGhFZXNpbXhWajBDMzRjWXdXZDk4RzVMNVoyeU9RVHZ3?=
 =?utf-8?B?dTlzWGVwZUh5NlVKQ3VuQ2JOTGVBaXpjeFdlVXJzZzgzYTdRR01XcWhWL1Fu?=
 =?utf-8?B?cVdHL2hhTHdhYzY4cy9RaU9Eam5Va3BDbmtPclFXcE1DMUJ2NzBEV3VFV0Z4?=
 =?utf-8?B?aTRXRXc3L2tkaWdlMDJ5VGt3QU5zNVlydkpLMFhpWmFRTnpLYXQyaGpVejlO?=
 =?utf-8?B?WXVSMkFTTllvK1hVV0oyWTFCbHRZY3l5c3pvQkxVdFNqZ3dxcUpEcWdiU0VC?=
 =?utf-8?B?SGJSY0dWNDZobXVSWmRtVERnc28xamt4TWpTbnZZTnc4VDY1b1Fhd0J3UXpa?=
 =?utf-8?B?UFRobFNaREV4dTJIdjFRSG5pKzFSc1pUL1RCYXJ5eGlKRFpsU0FGM0V2NTd2?=
 =?utf-8?B?dW54ZDl3QUJ3MjdIdWhuSTJHRE9LOTVaTXcvbDRPRFJHTVpoTCsrczZVRjNs?=
 =?utf-8?B?OGtDMDRjU1dYTFA3UFk0dWcwNUdkMUtnVzJwT2huMTFFekRNVitjb0huZDA3?=
 =?utf-8?B?R3Yra29CZXQ5RkVpQVBBSVJtU0VFajJCN0lmTEcxTEc1eFhFM1VtSlA5V2ln?=
 =?utf-8?B?S1NNN01BS3crRkRZbE9ibWdZeGc5VDNHZ0Y1RE9jQkFRR1paNnpGYlhjZUU3?=
 =?utf-8?B?aFhmWG1uc1BGWEszTEc4a25HbElGdHNKUHVjR05QeGdwQjIzYVdJb3pYOUtz?=
 =?utf-8?B?Y0dsdWZwRDlzRzkrdGtISER5emw1TGNsb05iQktpZXBTdlQxdmYrYnhldmFI?=
 =?utf-8?B?UVZZaVNCeHZVdlFabmlzNHVTbVk0Sko4ZFBBRFpnSDc4NzNScjArYnZTVlpD?=
 =?utf-8?B?NGJ6RGc3MkhCQlJNNVlUWldXZEhCc2RzMkNwbUhDcFZPbDFvWStuVkN5bnY4?=
 =?utf-8?B?U0pVMkhRek41dFhpalZYU1VneFo3MEdsdXlBQzV4YXc0S3ZwZnFna0hPc3ht?=
 =?utf-8?B?bENrblYxa3VUZWpSWFovTkswczllMEM1SkQxempEU2FIaFZQcUt4bnlEZlBT?=
 =?utf-8?B?WXpyQ2FNMDJTTVRwaTFKcmxFRDBRanhYMWNuVUJtZHprajMydlFQemthb08v?=
 =?utf-8?B?blBrcEJVQU51bXRoZnBkQUJaKy90bWt4d3ZHT1BkNmszNVZmcUN1bE1qaEds?=
 =?utf-8?B?emFoOWx0UnhCMFpqanFWZzBQSHBEMFArOVplZEdRV1R4b1A5L095c2EyN0JP?=
 =?utf-8?Q?I1GcODbFDA/ls7L8/k43h6Ern?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90907f69-a297-4445-c392-08dbd52c8431
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5629.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2023 07:32:17.8505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YxxZuzN0irqWfMHOtqdeEmf1bQ3C15xHEyq3JWll0WCX0yOxt55QGBanhFH8J+TV4zLkjmdinUoYyvi571iuXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5093
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 24/10/2023 23:02, Pablo Neira Ayuso wrote:
> From: Vlad Buslov <vladbu@nvidia.com>
> 
> Current nf_flow_is_outdated() implementation considers any flow table flow
> which state diverged from its underlying CT connection status for teardown
> which can be problematic in the following cases:
> 
> - Flow has never been offloaded to hardware in the first place either
> because flow table has hardware offload disabled (flag
> NF_FLOWTABLE_HW_OFFLOAD is not set) or because it is still pending on 'add'
> workqueue to be offloaded for the first time. The former is incorrect, the
> later generates excessive deletions and additions of flows.
> 
> - Flow is already pending to be updated on the workqueue. Tearing down such
> flows will also generate excessive removals from the flow table, especially
> on highly loaded system where the latency to re-offload a flow via 'add'
> workqueue can be quite high.
> 
> When considering a flow for teardown as outdated verify that it is both
> offloaded to hardware and doesn't have any pending updates.
> 
> Fixes: 41f2c7c342d3 ("net/sched: act_ct: Fix promotion of offloaded unreplied tuple")
> Reviewed-by: Paul Blakey <paulb@nvidia.com>
> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> I am taking Vlad's patch and rebasing as per his request:
> 
> This patch requires:
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20231024193815.1987-1-pablo@netfilter.org/
> 
>   net/sched/act_ct.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index 0d44da4e8c8e..fb52d6f9aff9 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -281,6 +281,8 @@ static int tcf_ct_flow_table_fill_actions(struct net *net,
>   static bool tcf_ct_flow_is_outdated(const struct flow_offload *flow)
>   {
>   	return test_bit(IPS_SEEN_REPLY_BIT, &flow->ct->status) &&
> +	       test_bit(IPS_HW_OFFLOAD_BIT, &flow->ct->status) &&
> +	       !test_bit(NF_FLOW_HW_PENDING, &flow->flags) &&
>   	       !test_bit(NF_FLOW_HW_ESTABLISHED, &flow->flags);
>   }
>   

Reviewed-by: Paul Blakey <paulb@nvidia.com>
