Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E6D9C05027
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Jan 2023 16:16:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbjAWQQb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Jan 2023 11:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbjAWQQa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Jan 2023 11:16:30 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4231041A
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jan 2023 08:16:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fNRV7QmzG66L57w4UAa2rjpv8t61M5RX8kcSTcLYIbJvGjWgOY42Qz0ec0udo733VxJtpkrZIglfJCu2ArUE7ENp9akkEfHQRqkhIJ9sRA5Pdr7H7VDuyznf7CNpqJMuSp+2AGWCRoRAF0yu/xrXaVxT5pyZhLhBiuR3DOadFYLfMJHMWCaHLVapH1bdLIIJ61YgsAzS5eJo1DcRm03lQzk1BlwkjOmbaIG2FgqFRAz14pduebCljZcQ0O6ZEy5Esig3erDAm1GbknUtyJKUr+rVmNW+lckeImIc+VbIA0aUx/fuWYIdyQRP0LXUcKQQcZbYdqPBQ91r4fyOVoOuMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZtZHsxDrJ7usOJcAJLXtGDK6WgrRbpPyECPaSkjoGtU=;
 b=dswYg23bhw8sPpfV2akpJywqdlWwotzaX3kbSRkEuu16ngc1Rpnpab8xl8owyRllRXYyKA8CH1h/iaRlm/cVCCEl/NpK/5widVm6uQKCx2TPXGwYq52e+jXB7K9lIW28gDQOC5wxCcr6pOCl/Gr1u9EtHRudznn9t2YTmbXZIgwKs+QZITvPVd3a2DmpmMXBjB4mBTr7zvv5yAm4qUMX07Rv4iN+dg8HP5BpiuT8mDjqYlcc10TZW1rLoP/B/KSzipf3vApEhh/7/ipxWLbr3NzIFpBSQOiGIKbH1R9iA9EbpffemjTGqoqWb/wYCKennKX+8KHua8HtxRopdZArQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZtZHsxDrJ7usOJcAJLXtGDK6WgrRbpPyECPaSkjoGtU=;
 b=dyz3VPqV+tgb0NocMVedZBxSC4ZnwQNY4RNakyTkEhQk0A+dDdAAdtSQBUlK472nNtsmNcIj8X/Zo5HbiO3VJeEQMhY0D00lrppqUZTNyJSiVj7tO6XZpOlIzplfTV3qeOqgL9Oj1pM10V8ZxLAFJs6UfD2v5YPl/FqSePcWFifX+20BVaTyz9braZNBiW3D5Nq1h8edU3PzA6REALsvAZpBePqE3CSdKHTDbuBW7WxARAk+wsllLkArGrKyt+UsZSEe9mYFZUgLNeQvReN+TIVJJHhJnoB1DCduVPVFpNC1SLOfXU/Dw6YGeMOEq/Ep+Ak+jG4WcpWutzzIRmLZHQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
 by DM4PR12MB6616.namprd12.prod.outlook.com (2603:10b6:8:8e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Mon, 23 Jan
 2023 16:16:26 +0000
Received: from CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::db1d:e068:3fd6:ed08]) by CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::db1d:e068:3fd6:ed08%8]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 16:16:26 +0000
Message-ID: <a6323260-da2e-1403-4764-423219b604a4@nvidia.com>
Date:   Mon, 23 Jan 2023 18:16:21 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101
 Thunderbird/109.0
Subject: Re: [PATCH nf-next] netfilter: conntrack: udp: fix seen-reply test
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
References: <20230123120433.98002-1-fw@strlen.de>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <20230123120433.98002-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0602.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:295::16) To CH0PR12MB5330.namprd12.prod.outlook.com
 (2603:10b6:610:d5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR12MB5330:EE_|DM4PR12MB6616:EE_
X-MS-Office365-Filtering-Correlation-Id: 967eaa54-6745-4583-15e6-08dafd5d2d7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ciwZJiA+ywq+aRLjFvR1jnfYtgynCl+/aNfAoiAwUlyAMwyMBK8yyLfqQmzipnq3XY6qKGXGVTCFpOITetawWTxbEpKuBB9UGn33hMw9GXF2gfmKvltY7Ngv9QGewhkqSET61WSK/kaUXMq8eZbAo+xUfbdrydfZT/vKunlTRqUX9tcB4nmxz8KmIlDHMU7yGzD+Qi55euvTsp3KxdVwWcrRq+xktZQVVL7yb1bhHtRBAcjIdblguq00lQ/8595D/ecu2QLMsL1RHvDKUGKVaMHPPKB2NnGZnEKHj/8KBEzSKT714YHKSSPPeR5ezVJe97po1TsENh/qXkpsAqUhaUJOsU8MuR01kxRaGw7Fwy0MxH/SeS7yeUByitTkYBg6zeAWFG0C6vLReijJDrYB4MqHTqnL6o0JJVMoNnMxtgOyzd7PeOSyi3ctvOaiXM2IDKVbk0zi5j1rpwh/84/HjQCooOoErzDWfPEhLLC0I90pv1nYSC5SRr9LSP0GIaGoj8dytO2h2aqTND+cEWjM3UqDO+DKuA/Bt6FCrV78YMh1QGTStgB9vz4Cnuv5uwbNWztyOSC2GyuuzHX7OeN/9CLdxf5CCc83vbxyrR0P2SX03Y94MGmCTuhS/TbN+mh2aCNrRRCMnMrI0UDNQOoxc7jyFKEiaB6EXiBgDMKz1YkSvPPWboFz3Dj9m3uaw7z+qo0mDIWi8WLBW3X/3gctCZXisIDXU2wu2gTXmpfy1kc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(376002)(396003)(366004)(136003)(451199015)(5660300002)(8936002)(31686004)(4744005)(66476007)(66556008)(8676002)(66946007)(83380400001)(31696002)(38100700002)(6506007)(6666004)(53546011)(478600001)(186003)(2906002)(26005)(110136005)(6512007)(316002)(36756003)(2616005)(6486002)(41300700001)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cE1Kd1JuRCs4cnZyY0g1NEloaWlOdDVPZTZFSkhmM29VdGV5eFZWSmt0OFht?=
 =?utf-8?B?YkdJaitZcElwTG9NYVJjYTkzUHdTcTJyOTFScXFHYlgyM1dTNFFleE9wUnlw?=
 =?utf-8?B?SkM4OVhGbnFmcDFWYlpTR2FLYzBGY3FMZnc3ZTRYd3oxSzI0ckpVM2dWOW5s?=
 =?utf-8?B?M0pTUHRXTmtEQXhGVUdJdDhpZEMxdC9od1RZTTlQMkZsaHN4WHZsakhKU0ZF?=
 =?utf-8?B?YWdMSXZNdGdzZGQ1cUhkZmRHUlhwckErQ1NBby8wSXdDNUYrR29XNE1kV29m?=
 =?utf-8?B?Ri9QQUdSOW9wR1hBS1NWSWZkeU8xWGdPZmFtdWFMSm1GMTRFYkJRT2NkenB3?=
 =?utf-8?B?aTJFUmswcXR5QlA4aUpGTU1LT1hIRzAzTFlYa3dZVjNvSmNCLytWd2lzL3Y0?=
 =?utf-8?B?bzJNS3BIZ3M0RUo3R09VcVNTNjk0UnhocWN0bURPa3M1VnREM3BTZGdUeFJD?=
 =?utf-8?B?NlRLbHBmZ0I5VVNUcFFJSklQbTRxejFyUzN6b1NpYXZmTEJmT3pxYllhS1Qz?=
 =?utf-8?B?OWRMZ2g2TWJVczh6QWc1WUpON3NyUVFrcFFtTmtVdE5pTGtOcUNWOGdzUGdT?=
 =?utf-8?B?eCt5SmtINFpnTXNGZlJacHJxOVNoRm1VeXAwSmR1Tk9GNDJRNXQvQnRXanhH?=
 =?utf-8?B?R0xiMzBtMEExYWlOSWd4MDRyOFF4aVFJRm1RMTRWcjJ6TW1VRVFsbmNLRXhS?=
 =?utf-8?B?ZWhVR0xDbzFSTzg2V2szQkJ2VGsydkUxc0YrYUhMbU5DTFl1WHNuTXhDMlVv?=
 =?utf-8?B?aGxhYW1OMVVZVE9LdnN5M1RPOFp5eU1iZ3VoNGtFSDF0SDMzNWJjQmVIckJW?=
 =?utf-8?B?Zy9MRzFDVWJjb0RvUnR3VEowc0Uwc3F0SHI0cTJLZmtoZ1pRRUs2ZjI5bWFj?=
 =?utf-8?B?TmlIUEhaSXNWWWdLLzdBZ2UwTjRkaEVjNE1DdVFKR2VJWGl3RU1BdkdibDVB?=
 =?utf-8?B?ZTBhaVNBdWY4c2Y1QzlWVnZEc1F6R09zU2tTbW5Walh1R2FkOFlZS0dTaEl5?=
 =?utf-8?B?eXJFV2xtWHVmLzZQU05ac0c1c3pCc01zMzM1VGJ4WlhHdjhZVFhnOGRJSXEx?=
 =?utf-8?B?YW44Rkk2dUNrcDZSWHBXTHZEM1lVQkVyalBHb2JmYXF5NUhHaXBlNHplaFBj?=
 =?utf-8?B?cUdaV2g5WFZNZFVUWXc5QWxpWG8zMnFGZmJCRlNYbFI5MEJlbE9HZCs0RWI5?=
 =?utf-8?B?Mk9vWXRNaWhYRG9RckhncDdpaVRPK3BhaTNCSlRjbnRvNkE3TXhWVmkyeFpR?=
 =?utf-8?B?cmExYkVqUU1PNzZTUWVOTVZCOXEyZFJFRXd2UXg5dHZLVHAybkhwY0xUOEhk?=
 =?utf-8?B?MURnM1Z4dHNFZ3AxMzNTelNTTllzeG9zNTJGY3V2MGs2Y3BxeElDWHFuZ0hE?=
 =?utf-8?B?MjFGTDNlVWlXa08vOGpHN1IxQTNLSlJSM0x0c0NBUjluNWYyYzc5RXNOdVNT?=
 =?utf-8?B?NW92eFZuTGp4emFtMXBqYjdtRVdvZTdreWxqblpKVm53VGN0R2piWUdaOUp6?=
 =?utf-8?B?ZGhnRG0wVU8zOWdWKzNmVFNObjQ5L2RmSWlDZTZLbzJRRDZqeFI1Vi82ekxP?=
 =?utf-8?B?QkozU1F4cThlQ2VyR09rN2tpZ2hTdm9KSW9vUzlTT3NodGFsZ25DWDlYTDI4?=
 =?utf-8?B?eVlKZGRtVHZJZmJXcjlnV3hKT2pkYW9HSkI1aEdGdVlRSHh5TlM3OXYzVzlU?=
 =?utf-8?B?elcvcU5SQjRXUG9wWVExNkhMSTg2cTFxcTlDZTBWcm1pWTY2UTlHR0FRTHoz?=
 =?utf-8?B?R2trT0J4YnFnSy9INHQvNXcrZzdLR2ZjbnV3UENnTHczQlhsbUN3aVBjRzcw?=
 =?utf-8?B?ZlJYUXFHMDZ4RDlnMXlTYm1EUy9nYnlXTlJvZGEzL1pjc01tbldycGJQR09W?=
 =?utf-8?B?bEMxY0MvSVlDL0JDNlBhQVVKQ3RWS3g3cU5uV0tKSlJrSnVMZkhvZXJsWVJn?=
 =?utf-8?B?ZFZ3SE14OUFWcGVkU0g0VnRyRHIxN3hsZWxKYUZ2VHlmVnlsbE5jVWpuM0Vz?=
 =?utf-8?B?RXM1SWE3LzZpM1h2WFV3WGhaTFFVNVFqa2ZIMXhYSUVzcWRvSnYzN2pYeUdN?=
 =?utf-8?B?WmVCdlNCTzU3R2lKNGIrN01hRkVwa0FYcUtpOW9XMk5kTUlnYjVhekQ0M2xp?=
 =?utf-8?Q?ylfSlqCNJ0u3l7C3ZfH0Qi+dT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 967eaa54-6745-4583-15e6-08dafd5d2d7e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 16:16:26.6026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: szohlg9ei9GDy8OFv7p1u7Z3KNzlnEAabuNbsOA2V0mcz/vlL6Q7yKQiuazuXkA1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6616
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 23/01/2023 14:04, Florian Westphal wrote:
> IPS_SEEN_REPLY_BIT is only useful for test_bit() api.
> 
> Fixes: 4883ec512c17 ("netfilter: conntrack: avoid reload of ct->status")
> Reported-by: Roi Dayan <roid@nvidia.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nf_conntrack_proto_udp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
> index 6b9206635b24..0030fbe8885c 100644
> --- a/net/netfilter/nf_conntrack_proto_udp.c
> +++ b/net/netfilter/nf_conntrack_proto_udp.c
> @@ -104,7 +104,7 @@ int nf_conntrack_udp_packet(struct nf_conn *ct,
>  	/* If we've seen traffic both ways, this is some kind of UDP
>  	 * stream. Set Assured.
>  	 */
> -	if (status & IPS_SEEN_REPLY_BIT) {
> +	if (status & IPS_SEEN_REPLY) {
>  		unsigned long extra = timeouts[UDP_CT_UNREPLIED];
>  		bool stream = false;
>  

Reviewed-by: Roi Dayan <roid@nvidia.com>

thanks
