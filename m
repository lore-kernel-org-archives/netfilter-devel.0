Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4DA9C433DB
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 15:15:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9695A65253
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 15:15:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbhCIPOg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Mar 2021 10:14:36 -0500
Received: from mail-db8eur05on2127.outbound.protection.outlook.com ([40.107.20.127]:11616
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231821AbhCIPO2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Mar 2021 10:14:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=atcLrxgDxvvHwnW9/2jF5Q8qV+9dr1w8jSVTGehYyjKDR8endtW18jzowwWCjqLz+BJ6htp0blbI8vK4jWefe5uTRyZEgy9/gWzRtfTrs+PUyPERmYf+5bGnPen1RswrnBYH4KRXoYls6EBSP7OM5LZtLBbJq1/EVY97HHMzoowGiMgObIuABSfmUOPFfVvbUmmP3MTFfcrTYLvEt7eFZ43yFj5AGUk0Xqcmn5OuHMPak/SI+Cn3WS0RsjxAj30vNwqi+ppLdCG0MxwJwX3Qclsr2CY6W7TpvdKadx2d2PobIuSyjD70TkvtZSnQz2nF+NKCm5ZkTtL/2c/a5ZHBQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FsQACrNUEUz3x040Dsp+JHOrTIUkXz8MVGUMm14/rkk=;
 b=IlPdAd+hmHRR9thBhRuOdHELxmSVc0ii8ja4PlrcMo4Bl69qeRtP7yZ0OoY3+j+jYiC4OS67sMaKhPxhzBVTIpTIp1LkHfJ/K/KIfQORvgLn0bHJmDvBhsfy7VFZl7jwvd434JIK5yDLQED2qafkGV8UcqJfD74ZvsdjJ+i3Zahgd0qdDEqXe2GWfszhlG+0OCB/DolhOk/Uz8seesn5DfM3ADC/U8/43T2rDjxB0Y5ZDwlI3pM0O0H/oM82RpMsKqk0mg0Dvi+U4lW3rT+nsXAW5GiMDkmXh6SPb70TjC1rfnYmOOUqRshPXtar3+qK3d+X3MDanbSIlTkJNAmboA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FsQACrNUEUz3x040Dsp+JHOrTIUkXz8MVGUMm14/rkk=;
 b=T23h/kyIgJg8xRapAvWibp5pEdrIllMfkrwTi3EaH3JREBzcJFZ4eQ2Ws2y4bbMD5MX7Xs4iIkueQBgkvpAFJX5FpOCGCz14g9dZ0UwJPoEdgTFHQxgyUHrqJ6i6/ouXHceBrzNJZx8sfR1E8yvYOJHx/EuZEBrvdw2vtlKcuwI=
Authentication-Results: strlen.de; dkim=none (message not signed)
 header.d=none;strlen.de; dmarc=none action=none header.from=virtuozzo.com;
Received: from VE1PR08MB4989.eurprd08.prod.outlook.com (2603:10a6:803:114::19)
 by VI1PR08MB5519.eurprd08.prod.outlook.com (2603:10a6:803:133::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Tue, 9 Mar
 2021 15:14:26 +0000
Received: from VE1PR08MB4989.eurprd08.prod.outlook.com
 ([fe80::d1ec:aee1:885c:ad1a]) by VE1PR08MB4989.eurprd08.prod.outlook.com
 ([fe80::d1ec:aee1:885c:ad1a%5]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 15:14:26 +0000
Subject: Re: [PATCH nft] nftables: xt: fix misprint in
 nft_xt_compatible_revision
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
References: <20210309150915.8575-1-ptikhomirov@virtuozzo.com>
From:   Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Message-ID: <cd2b40c4-c08a-7cc5-0926-ff318ccdd219@virtuozzo.com>
Date:   Tue, 9 Mar 2021 18:14:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210309150915.8575-1-ptikhomirov@virtuozzo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.200.17.122]
X-ClientProxiedBy: AM0PR10CA0063.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::16) To VE1PR08MB4989.eurprd08.prod.outlook.com
 (2603:10a6:803:114::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.192] (81.200.17.122) by AM0PR10CA0063.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 15:14:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78f1ad44-cb86-4607-c4c0-08d8e30e06f2
X-MS-TrafficTypeDiagnostic: VI1PR08MB5519:
X-Microsoft-Antispam-PRVS: <VI1PR08MB55198D44F989FF102936E2F4B7929@VI1PR08MB5519.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7kiD9m1x/v0TO5OekWYIuyciko3F1f0i+vBDkU6RV0+A9WMI77G8n/J8l/bajYRb3v71TfD5fBJpmPihmm/QObCIYLtz45kGppZqkXILeaW64wheg5hOYXOK+GiB21/BvdLO5OiOa5SH6Pm6h0CNCYR2ztV0q0kNoedmQB1/xsC9aTYKucnyGYxatYRbcNrL8elazJb3Agarb9GnjA77StUHvPpE4OUYffmXQOECngwhgn7Klcz3H1QBocgRT58s8ztl+cks2/oqt4BE5jRPurJb3kaW6Aeb03BDJL/GinGhJafqZp2la3Ais+X7hP3b7QChpRWpWOb5jABzuh3hzY6lWH6hG53oxAkmbCtbmMvat4XXMfoXIQK5rJhKabvbmTdtn3s7oUEhatZYjhthuk6JHkgWhJHEaVq0Quthk5wuZuJBujBHfngLDRzFusIAW+ON2fY/nkv7kdipMYBgpIuXRvcUjrOqVG8z8riyCICRLz0ljcq4mmVHR/dvq6QyrU7/+vNXyISYMAd3AvdAc+4QmyJsYwIM1lfdCtCNNuH/M4LAQVMKzmMIRibQM6OVNGfT6T13SXvl6VpwJAdNeQfQg/jp/rSQDW79RLI1WPme3chtqqxo+bWo+hmtFmATpIJhvJxIwlwRsvNBqsuShZcCSgYxtqLHA9ukvHLQs15IGf4qBLU09n60UkwEnO7n
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR08MB4989.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(376002)(136003)(346002)(366004)(8936002)(31686004)(54906003)(5660300002)(66476007)(8676002)(86362001)(31696002)(966005)(316002)(956004)(83380400001)(4326008)(478600001)(36756003)(52116002)(2616005)(26005)(66946007)(6486002)(66556008)(53546011)(16576012)(2906002)(16526019)(186003)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?alNzdWRTQko5UzBhdEkxV0hvSXN4U29XV0xCYlFkZFgwUk5Panozc1NSREI0?=
 =?utf-8?B?RlB5eHVMeldQby9RT0xUUzBDbXNaUW16Wm5lQ2pPWFNWYkdOMmZpaW9pczVr?=
 =?utf-8?B?c3V0bzR2WXJNVFdYUDZ3bUtKbUdvREFnS1A1aXRMT3FlaGFRb3Btdmh6dXMx?=
 =?utf-8?B?TE9GLzhLODBpbVJGcU11UTB5S29GN0h6emhDMEVnYmtmZFBSQjVMUmN5L0Jr?=
 =?utf-8?B?cDZ0ODcyQmIzUXNlakt5Q09Ga2JnRkRDS01PUXc0cGtvdXlyd2x0NXRXTlhJ?=
 =?utf-8?B?MlBEbzJVeFJ6cnhmMUV2OU9UbXhCbXJsNzYxZk5UWVlZc3laM2NFY2FYdjk1?=
 =?utf-8?B?b20rTzF6UHYrT21WZ3pBTSsxdit3QWVocWI3RWQ3WFVaNFI3Q2ZMTzZ6cUpv?=
 =?utf-8?B?TkJxY25jVzNiUnhtQWZ3dHpLYzBweHpOQUY5M3VQTGh6VEdrYU12TXVxTjEw?=
 =?utf-8?B?N0RLdSt6Wllna08yN2FQdkJtbXREdFYwSWt6dm0yQ2JHaTdLdC92WDBpTnNy?=
 =?utf-8?B?cGI5ZWo1U2VrRVBlMStxbmsvUldJYlY4MHp1MUJoanNGL2s5N25sa2RBcjFR?=
 =?utf-8?B?dHlHSlJSb2lxSi84VnBwellRSHppWlF1V0FBWGFpMmV5TWNvRHBsOEpMVTRj?=
 =?utf-8?B?Y1ZSR2pxUThvazFyOUpWTllUNFU4Y2tJQzFIM1VsU2JkenJYSThvZ0ZYREpm?=
 =?utf-8?B?TVN1ZmR2RXBhTldmb3B5WHliRmdURGtURkkxcjVUdEZVMkFjUzZib21iTldv?=
 =?utf-8?B?TmxDVTVkUlVMbVFlNW56NlFobVQ2Z054a1cweEdqY2VrQXRXL3Q4U3V5LzM1?=
 =?utf-8?B?VUoxYlJyeTcwa2JIN0JMNWUwalM2L0trb3U0WUt1SXYvWER0L2RlUW5mVU1z?=
 =?utf-8?B?QWJTZTZ4MzJEUjBGVGorTjd0OWFNWDVPR0dOY0FSUE5lKzBVVHkvckZESVpz?=
 =?utf-8?B?K2ExVEVLbTVUWWVsWnd2U3pBTXJiODJUa0FWdjJSWE1TSHhhY2MrRTZRT1Qx?=
 =?utf-8?B?SWRzYXBJeklucXpiL2x3UGtmblRzN2FoSmNJYU5kb0ZJYXNURUZyTmY2Slg4?=
 =?utf-8?B?N1JRRnk1RkN4K1djWmQyRkUrNzcwRVZlSkZwZkJXMUY1bE0wcnhFcXFGU2Fr?=
 =?utf-8?B?NVpQaFRJazFVUXg0SGZKM1VPVWI3WGdRc05CVFlpN0trc21lUVZINUJvM3dL?=
 =?utf-8?B?UW0rMlRzNmlwMXFQVnZMaEZLL3Y4N1F1QU1HN0xMTDZBUnVicG1QNmIyWWhF?=
 =?utf-8?B?eE9aZThaZ1BnMWx5bnp4SVFvMUErZFIyZ1M5ZVk0b0FUTkpvR0FBd0hXaUtj?=
 =?utf-8?B?WjgrVjJSZ2ZtdTZnRVl0dVhaUDRJNk9MWUNTQ2hrdjdHNm45K05TRlZ2NlNu?=
 =?utf-8?B?OFc0a1loU3RYNFlKUm51YXQ2em5KKzZpamJYa0pRN1dmeHNLUk94MXdhaWVD?=
 =?utf-8?B?VWlTbzhoTlNDM01mcE4vVmJySklHN05yU24rMTVXVW0rd3NGN2t0RFBvenpl?=
 =?utf-8?B?cWhvYWl4RVR5TzcycVYrZEdHY1EwZnNLMk13Rm95U2hvbVplcTEzdm9vVVBU?=
 =?utf-8?B?SGtLdG4xYWlLMmpwa2tNb3ZxWEJBemlLL2VRZEt1bFE4N1hSL2pQaW0rVGUr?=
 =?utf-8?B?WDBmNTh1aGNuc3JNeWk1NC9PYzFGOVp2ekgxQ3RqN1VQUkdzVGtEei9VWmdu?=
 =?utf-8?B?WnlmWG5OK0Q1QXpkMG1pQ1NmZVR1Wkt0c0cyckk1Mks3SHVKQWZQbzdzd242?=
 =?utf-8?Q?GSJYEud+ihoIlG1/jQYk64pFFJIKkU+Je3yL0eQ?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78f1ad44-cb86-4607-c4c0-08d8e30e06f2
X-MS-Exchange-CrossTenant-AuthSource: VE1PR08MB4989.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 15:14:26.0454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TM1GbyjXrILZUxShOajZa0m812XLaExUyn7SXtcwBR9pGs9mJo+kkrdxlVNLCGiuRh75d5rL439sIC6MYQexRbM0cSu1oc2+Gz0yKO5CenU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5519
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian, sorry for miscopying your name in CC from git...

On 3/9/21 6:09 PM, Pavel Tikhomirov wrote:
> The rev variable is used here instead of opt obviously by mistake.
> Please see iptables:nft_compatible_revision() for an example how it
> should be.
> 
> This breaks revision compatibility checks completely when reading
> compat-target rules from nft utility. That's why nftables can't work on
> "old" kernels which don't support new revisons. That's a problem for
> containers.
> 
> E.g.: 0 and 1 is supported but not 2:
> https://git.sw.ru/projects/VZS/repos/vzkernel/browse/net/netfilter/xt_nat.c#111
> 
> Reproduce of the problem on Virtuozzo 7 kernel
> 3.10.0-1160.11.1.vz7.172.18 in centos 8 container:
> 
>    iptables-nft -t nat -N TEST
>    iptables-nft -t nat -A TEST -j DNAT --to-destination 172.19.0.2
>    nft list ruleset > nft.ruleset
>    nft -f - < nft.ruleset
>    #/dev/stdin:19:67-81: Error: Range has zero or negative size
>    #		meta l4proto tcp tcp dport 81 counter packets 0 bytes 0 dnat to 3.0.0.0-0.0.0.0
>    #		                                                                ^^^^^^^^^^^^^^^
> 
>    nft -v
>    #nftables v0.9.3 (Topsy)
>    iptables-nft -v
>    #iptables v1.8.7 (nf_tables)
> 
> Kernel returns ip range in rev 0 format:
> 
>    crash> p *((struct nf_nat_ipv4_multi_range_compat *) 0xffff8ca2fabb3068)
>    $5 = {
>      rangesize = 1,
>      range = {{
>          flags = 3,
>          min_ip = 33559468,
>          max_ip = 33559468,
> 
> But nft reads this as rev 2 format (nf_nat_range2) which does not have
> rangesize, and thus flugs 3 is treated as ip 3.0.0.0, which is wrong and
> can't be restored later.
> 
> (Should probably be the same on Centos 7 kernel 3.10.0-1160.11.1)
> 
> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> ---
>   src/xt.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/xt.c b/src/xt.c
> index f39acf30..789de992 100644
> --- a/src/xt.c
> +++ b/src/xt.c
> @@ -321,7 +321,7 @@ static int nft_xt_compatible_revision(const char *name, uint8_t rev, int opt)
>   	struct nfgenmsg *nfg;
>   	int ret = 0;
>   
> -	switch (rev) {
> +	switch (opt) {
>   	case IPT_SO_GET_REVISION_MATCH:
>   		family = NFPROTO_IPV4;
>   		type = 0;
> 

-- 
Best regards, Tikhomirov Pavel
Software Developer, Virtuozzo.
