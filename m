Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 401D6C0032E
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Oct 2023 07:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbjJYHDY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Oct 2023 03:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232579AbjJYHDX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2023 03:03:23 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2055.outbound.protection.outlook.com [40.107.223.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A12116
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Oct 2023 00:03:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OolJFUT6AiNgSSzjg9NZjT+SUuCWKal3xwK5tT3HPKkBhw24c7s1X5+h+MRdS8yTvWug3vsbWC9im2RvEMmwo2RuOoUVK4kw18pzzRFLaP8o+Au6n6pVOXlc1L0jmrhvo8zcZmDVBK4hGXUybOhGIKli9W9ECwjE4Nzc4nOluyZdSpi5DyNHx/2aWoA2J2BTxFjkKf63thx05lWRp3PzDGRVzX1k3YkYVbESQJsI/h/m19RDuTbM84JdPkVGtesyx8ZPJs59soR67eWxCuGc9vnAOuWbKlUcOXl4wmBdePzCFA8PphkX3B2iIxPu9jjZO26pN3AbL49smEGtYZY7AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RhZr+LuiEexA6y+TQwJYWuLHJ1xR/ZUIbWUqr5QtYrA=;
 b=Fyz9jB6gXV/h1LCWfQlHCNBnH6XetBO38POLsKJRCHjRc9a4XQjQidSbpc2sOEqbMIp7lnOvVs1v+HvLoYH8PkzvZXTi221GJ1jJCRO3cID4biYXRrwQBSdGEOdBJushLiXqWEw9uumHbifWjXuFYb3PCB+wl3nbcEBnhUOAo55lFQXCndgZQMYoKuVBGlwHH2Paz6v4Q9tYsfdrosVclKIJ1Oenton6xHocCTfjYTw3iiKBKwJYWyLOC3rHF5KAlaMsnpE3RsMffl0qDdJ4Be3HjiNf2e4lxNbGcKDMwXEoCFXYaHzB6kX8l3EBgVpuK+N+D9NuLXkhZcxSHFCBuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RhZr+LuiEexA6y+TQwJYWuLHJ1xR/ZUIbWUqr5QtYrA=;
 b=ihxT0IY3vIKnECgNHwJj5HBiSg4qahAunZllfAKhqWOadCbz2GrytTVb8Vu7ot60BENvhkFpbEslHzjNmHPAmsdymQ+ZI0Av/HecV9beJvrU619kx8WIRSFbD3Pmxjbd5JBggC+7KQOy8oK2HLyBetACipkG4RO8QzD9e9hota4Oz9+EmVG6G2px4oBs0g8k9CC7IgWC34qUXpLlGH7Rn8BoNKCmyPY6AWqckjWCFv1auyCvE9n/3GfH2WIreW9gO7MqfTkRh9kcVsHkbAByhD0dwog7smt/x1zUaS/tDMm1P9jlrsYhxkRfPW96oXuWrfJv8YiecUrkw+uWyghg2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB5629.namprd12.prod.outlook.com (2603:10b6:510:141::10)
 by SN7PR12MB7881.namprd12.prod.outlook.com (2603:10b6:806:34a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Wed, 25 Oct
 2023 07:03:19 +0000
Received: from PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::e2f2:6c4f:5d58:40e8]) by PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::e2f2:6c4f:5d58:40e8%5]) with mapi id 15.20.6907.022; Wed, 25 Oct 2023
 07:03:18 +0000
Message-ID: <40400a62-9f00-de68-3740-d64f17c72ca3@nvidia.com>
Date:   Wed, 25 Oct 2023 10:03:13 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH nf] netfilter: nf_flow_table: GC pushes back packets to
 classic path
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     vladbu@nvidia.com, fw@strlen.de
References: <20231024193815.1987-1-pablo@netfilter.org>
Content-Language: en-US
From:   Paul Blakey <paulb@nvidia.com>
In-Reply-To: <20231024193815.1987-1-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0270.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37a::15) To PH0PR12MB5629.namprd12.prod.outlook.com
 (2603:10b6:510:141::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB5629:EE_|SN7PR12MB7881:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b430f2d-57ac-40c3-87ee-08dbd5287772
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CIcikeEYtPXTTjrWCgm16RLMxwKyKXF/yfBAK+YbUQmGcV6ibVHZ1Gk/muhnB4dTnJtJpLsr75IDIqB09hSnBjtacohw6dgx7a5+RuYx///wPwjdi8r9ileqNkIikUpp19zYxwJudCsOyYxBV8Eiv7ANbn0DcA8mm9tGW+3EQvJZoWgBjv5cBUdKebfPqeZYuMyy0qper5VeXBYp7cMrrRDcddjVkp3qs6z/Af9LSResZWXAzlYYNv+F0Ycq486OIN5bYuC4+qYJA+9cA24RfpkoPoVvWiEw3hE2nwx07CGykEztzogEbIcraCkGftVIhlZ02djWF9kgA+xmyjKrjgqFEZ2hkPadMUZkxQoKkho+VTkdiOA29wdbzgrq/u7eKMznX5iUh3+LfT7nTgKsg2yTYHHMl/6//EfqFb9PjulHwwgxEzlbNr/OqNZ1F2gTQY38d6QYCLKi1pQfOkla6T0Dk96dx7sWSC6T7tsCOXYWe4Gc8pHHAHsdcmPwyibcnmcg7cnCzcsLb1C9F3TlSsYMdzsZjYycoucWAy+TQOyu1S3yCPFjYpHOSkRhWVZmaGqHTGsHIJQsYPelTMFq91PHtBAK2epFpo+hZZTiO+dmEoSxFlDzPpYnpujpJ0DUWywZOY0dNi8yJlv6mh+BZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5629.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(366004)(346002)(39860400002)(376002)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(66899024)(83380400001)(5660300002)(6666004)(66556008)(41300700001)(86362001)(66946007)(66476007)(478600001)(31696002)(6506007)(6512007)(6486002)(316002)(2906002)(4326008)(36756003)(38100700002)(8936002)(8676002)(53546011)(2616005)(26005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUJxRmtJTFd2NUoxMnZkQUJZb0NVYkszTXJRdUJrcEliK1ZQWUdCNFgrNmY4?=
 =?utf-8?B?dzBxWmxFdDZQMUdyWmgzSjFMdCsxL1lBQkk2UWZTVkJYNjAvMUZ0MzNYV0Zt?=
 =?utf-8?B?YzNuSEg2NmwxMGNNcDcvL3BiUjF4QmRKOW82ZFlwSTRvU0dWcTlEUFMyWXZ6?=
 =?utf-8?B?WDdXTVpYNnlDbUtUZEJDd0hkcm8rREdER1cwclMxNDA5UnRqRUJ2MDVxcVpB?=
 =?utf-8?B?UDBRZCtjLzZPMjZyaVd3cEVJcm5XNXpUa1NNL3FaZVBSSDc2alRMY3V3RHRr?=
 =?utf-8?B?aE9MQ2txWlYvcWhZZElkZTdZczBtN2hkOUl6K3dHUTJEdDlMU2V4a3pJdHVt?=
 =?utf-8?B?NXNuTXpPcEFWVHNJMDV2VmRWUzFWTURCSTZhdk1USmt1MkZLQ2ErbDRoN2Mz?=
 =?utf-8?B?MHBmSG1QWjV4NFZncHkxUUJWcWQ1cmFsTTBLK0tLY2d2bUVKYmFRRkRMTkFs?=
 =?utf-8?B?SGZ3MTFWald2OVNKSHdSbDZUdjFSM3pNcDhiNTlmMUNWVGpJWHVEbDdGY0lE?=
 =?utf-8?B?djljNmVidnFmRzFLWWpSaVdhcjRWVHlwQ1JwbzVOdURZY1hySWEwMS9SbEV6?=
 =?utf-8?B?UlJZQ2h0M1g1dE5MRVpmNHpHR0o1bWhXa2NGSUpZOVJoeXp4WXFDZ01jYitN?=
 =?utf-8?B?MG5YTm9SakZZbTRqRUpsZWhYT1R6RlExV3hLdjI4MlBxRXNZdXE3OHJ6SWFn?=
 =?utf-8?B?a2liK3hya0R6c1ZQbGhMWTBHcjdFdThVS2ZmR2JxMnA2WmlxWVBiZkYrK1Ix?=
 =?utf-8?B?dHh2eE5CdmZMbmJNTDZoakV5MGM1T1RZUHNvRzRoTzFGSUU1RTVRaWZ5MHRL?=
 =?utf-8?B?OUlWVWtoSSthY2F1cm4rR1ZITHk3bCtic21MenRsR3ZsdFY1TUhQT2plVWl4?=
 =?utf-8?B?V01YYW1CdkVlbTR2RU5LWFd1d1d3VHQ1MEN2aHZ1RnFJME1BNmhaeWF6VWFU?=
 =?utf-8?B?THFNN0N3RUhKQjdNSTZlSDNXd1Z4Vnl1WFVpRWJhbXF6N043SHVXTEV6QW5h?=
 =?utf-8?B?bTIyQjNUWGxZMHNYc1U5b0Z5VCtOdDA3ZThGelpKRGZ6OGxwY3NZTFNUdUxt?=
 =?utf-8?B?bUdwa1B4aFpwRTRQUGNSRGpvWUlKT0VxUW16Rmd5V2FEQWo2bUVPSllPcnI0?=
 =?utf-8?B?OCt0Um40NHd6UFFFNW9QKzQzRmtHVXUvdDRyYkRQaXZSMVJVeG5BUE41dW5Z?=
 =?utf-8?B?NjNLUWlvZXgrSHFXcUxUdjdrWHlsVHVkZ29IV0ZVSUNFbzVCQXpKZUh1Nlpu?=
 =?utf-8?B?WkNkQ1NVNTVEUnlrNENIdTkxdmt2dlRZZ2NMSUl0K0tvQzhXZzZ4WE1SOXdo?=
 =?utf-8?B?VldUS2k3OThkTThNaFd3RnVUN0YyWmFCemhPUHlmejVjcVM4WFEvV2oxZE1T?=
 =?utf-8?B?V0ZxMkRoOC9WMk9NcHp4T3Zjd01McUhaQ0N5YlFZN1JwNGJiSnloL3Fwb0pl?=
 =?utf-8?B?SHFmaWdaVS9KellrNUYvWHVzUXNYKzBGS3NNdHBxQkw2TkxrUDkzRzQydUZ4?=
 =?utf-8?B?bTZBeVE0N1EvenhWYXlyb08vcEVRZiswaysyS1gyOVRCbjV4TjVWMCtzZU5Q?=
 =?utf-8?B?bDhPdEY4cjRld3A1dWh0Q2ZiMlptQVdVVUhIZmVMK3FYcTZKbi9hNk5rV2h6?=
 =?utf-8?B?YUo1eDRySGdGTXFQYWd5YlVIOXRCdGpabDdnbW03WUxSbmhmcmpoNlh2M3ZI?=
 =?utf-8?B?SURmMVgvLytzNk1NSnIwcDYwRllCanJ3RUZZdGZTQWl5NS8vVmorVzB6OUNO?=
 =?utf-8?B?c1FUdTRvT29MRU5mVVF2RWt1cUJNZnl0OW1aa0RWcFBQWTBPa2IvSml0SVgz?=
 =?utf-8?B?QXQva2tOU01kSGFqL3lBLzBBOFFrLzNpOS92NVN3M2g1bDJQZVJWaVZhUGtl?=
 =?utf-8?B?T2tzZndWbGplSzFpKzZyWkdHb2xFREJ0Z0tZRHZQbTY4ZjY0ZlU2eFB2eThk?=
 =?utf-8?B?L0J3STlES0hBSVdnR3BpcE9CUkpxOWxEdVEzUDYrWUVUT1JQWktCS2dCQTYw?=
 =?utf-8?B?S3A1TnRjb2ZYLzlmOVlMdTNWMlY1eUFna21DRGVKVDZ3TWh2bTdHYyszZXdh?=
 =?utf-8?B?U0pqdnpUN3VkV0g0RTFZYklBSjJQcHVtZ0p3VkhGSE5Pb1VZb3huRG9tMU9u?=
 =?utf-8?Q?a8z+d7tVt0lD2ypZ2GhQ0f0+r?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b430f2d-57ac-40c3-87ee-08dbd5287772
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5629.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2023 07:03:18.5180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uhd9W2aAJG1Oee8tV6SliXc7o80zB/RQyCHYJFUHqeISswcgEKb9JoIm/mEvMzIXakhm/W2Obb8GIM2HY44gZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7881
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 24/10/2023 22:38, Pablo Neira Ayuso wrote:
> Since 41f2c7c342d3 ("net/sched: act_ct: Fix promotion of offloaded
> unreplied tuple"), flowtable GC pushes back flows with IPS_SEEN_REPLY
> back to classic path in every run, ie. every second. This is because of
> a new check for NF_FLOW_HW_ESTABLISHED which is specific of sched/act_ct.
> 
> In Netfilter's flowtable case, NF_FLOW_HW_ESTABLISHED never gets set on
> and IPS_SEEN_REPLY is unreliable since users decide when to offload the
> flow before, such bit might be set on at a later stage.
> 
> Fix it by adding a custom .gc handler that sched/act_ct can use to
> deal with its NF_FLOW_HW_ESTABLISHED bit.
> 
> Fixes: 41f2c7c342d3 ("net/sched: act_ct: Fix promotion of offloaded unreplied tuple")
> Reported-by: Vladimir Smelhaus <vl.sm@email.cz>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>   include/net/netfilter/nf_flow_table.h |  1 +
>   net/netfilter/nf_flow_table_core.c    | 14 +++++++-------
>   net/sched/act_ct.c                    |  7 +++++++
>   3 files changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
> index d466e1a3b0b1..fe1507c1db82 100644
> --- a/include/net/netfilter/nf_flow_table.h
> +++ b/include/net/netfilter/nf_flow_table.h
> @@ -53,6 +53,7 @@ struct nf_flowtable_type {
>   	struct list_head		list;
>   	int				family;
>   	int				(*init)(struct nf_flowtable *ft);
> +	bool				(*gc)(const struct flow_offload *flow);
>   	int				(*setup)(struct nf_flowtable *ft,
>   						 struct net_device *dev,
>   						 enum flow_block_command cmd);
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 1d34d700bd09..920a5a29ae1d 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -316,12 +316,6 @@ void flow_offload_refresh(struct nf_flowtable *flow_table,
>   }
>   EXPORT_SYMBOL_GPL(flow_offload_refresh);
>   
> -static bool nf_flow_is_outdated(const struct flow_offload *flow)
> -{
> -	return test_bit(IPS_SEEN_REPLY_BIT, &flow->ct->status) &&
> -		!test_bit(NF_FLOW_HW_ESTABLISHED, &flow->flags);
> -}
> -
>   static inline bool nf_flow_has_expired(const struct flow_offload *flow)
>   {
>   	return nf_flow_timeout_delta(flow->timeout) <= 0;
> @@ -407,12 +401,18 @@ nf_flow_table_iterate(struct nf_flowtable *flow_table,
>   	return err;
>   }
>   
> +static bool nf_flow_custom_gc(struct nf_flowtable *flow_table,
> +			      const struct flow_offload *flow)
> +{
> +	return flow_table->type->gc && flow_table->type->gc(flow);
> +}
> +
>   static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
>   				    struct flow_offload *flow, void *data)
>   {
>   	if (nf_flow_has_expired(flow) ||
>   	    nf_ct_is_dying(flow->ct) ||
> -	    nf_flow_is_outdated(flow))
> +	    nf_flow_custom_gc(flow_table, flow))
>   		flow_offload_teardown(flow);
>   
>   	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index 7c652d14528b..0d44da4e8c8e 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -278,7 +278,14 @@ static int tcf_ct_flow_table_fill_actions(struct net *net,
>   	return err;
>   }
>   
> +static bool tcf_ct_flow_is_outdated(const struct flow_offload *flow)
> +{
> +	return test_bit(IPS_SEEN_REPLY_BIT, &flow->ct->status) &&
> +	       !test_bit(NF_FLOW_HW_ESTABLISHED, &flow->flags);
> +}
> +
>   static struct nf_flowtable_type flowtable_ct = {
> +	.gc		= tcf_ct_flow_is_outdated,
>   	.action		= tcf_ct_flow_table_fill_actions,
>   	.owner		= THIS_MODULE,
>   };


Reviewed-by: Paul Blakey <paulb@nvidia.com>
