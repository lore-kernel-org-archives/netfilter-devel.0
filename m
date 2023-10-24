Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44301C00A8F
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Oct 2023 19:51:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344307AbjJXTvf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Oct 2023 15:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343871AbjJXTve (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2023 15:51:34 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B12A10D9
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 12:51:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WzzOIHrv6ATJHIWD+QuxC1LMQa/+fQbRVfr33cGUf73HSxQy868SZ4uVjHS+QjoCQeSj57N4Xr+g/ThWuknWAyu90aVwjbC1h3P4phn5HkU7NKJOBxNWB2Feo7s9fGIbTk9jLQXDam/KTPcbiZcJZaaxqWcHyUWmWTq8Ui2g4jEFIsMi2y6jxHBEzyZbK+pLJGDpZyg1dw9DxqDTWDHgDK+U58UOURWLpiW99CRwvv0+odF/6EVUXJwj4ImlqzbvAuArYUdnmwtxVF9LF8kf/PR4+wI20GSWCATdVLDDyblEfUaSKrkGLs/WPzkLIsHZgyR5pfygfPqiXjphOW9Ymg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qfxMZZVhQM8wyUrSoB84CoyJpngsPF2I2TM6IPPb8Gk=;
 b=Wt470wh1JcxXhoJfhF2ago3ig4gvJaHjBtUZOMTKi48PpHXYyGSb6OInhjyBwcUNuKGPDVbr05wq3lYWtqrfMFlp2NcpV0LsBYH/IieEau0REBEQZX2Tn8M9urdXEZjGuIuo/ajQqB5/T4TLkiqTDhMrZlF96QZPu36SgSWh1Xo2z2pMZ4swiLAFE/D/aJnHlaqt5CYChat5++f0C9u/Q0TcBFrgjjt1/bwI5NcNe0hf4r7ECB0Fi53cBr38rwZ96eIy2tUwQ5a9edZ3gEmr4OH3jUi0EhQn1GYauKuuC6aF2GENRzLwzNSvITPBbBtS4K5B77u2p4tbDe+LsrntNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=strlen.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qfxMZZVhQM8wyUrSoB84CoyJpngsPF2I2TM6IPPb8Gk=;
 b=O7320MrtXa5F+2Jf95mdd5c31fumEmbr3+f8KVprcppSyOD0mIzArsG5d8GjlfaPG16hTw6HkjBFH8eblb30u8fEyQ2wBep2smW7XY5K10sRhZdXOOLgThMwZl08IqHFrkxow+3CJV3DSjcOgHrRfXO1i9yBvTwlOxHCjnKdKYlNtXcOjxI0gA0EfLD7kquQUBeITfrpEVdF1HQtrZ3angtDcb6ioZUS26pzh/fhPFFOweT1zEbamHom0bbeFjD68i+V+nEeWB8e+RoKjnxcXEuxcP8Zp+kPUg++5VbvumhzRVDcnUa5fsFOBEq4BqDV43u5wegMYWMQ8vqMa2UIlg==
Received: from DS7P222CA0009.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::11) by
 CH3PR12MB7545.namprd12.prod.outlook.com (2603:10b6:610:146::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.29; Tue, 24 Oct
 2023 19:51:29 +0000
Received: from DS2PEPF0000343B.namprd02.prod.outlook.com
 (2603:10b6:8:2e:cafe::f9) by DS7P222CA0009.outlook.office365.com
 (2603:10b6:8:2e::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33 via Frontend
 Transport; Tue, 24 Oct 2023 19:51:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS2PEPF0000343B.mail.protection.outlook.com (10.167.18.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.15 via Frontend Transport; Tue, 24 Oct 2023 19:51:28 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 24 Oct
 2023 12:51:16 -0700
Received: from fedora.nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 24 Oct
 2023 12:51:15 -0700
References: <20231024171718.4080012-1-vladbu@nvidia.com>
 <ZTgdvbb3Z8RrFWzJ@calendula>
User-agent: mu4e 1.8.11; emacs 28.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netfilter-devel@vger.kernel.org>, <kadlec@netfilter.org>,
        <fw@strlen.de>, Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH net] netfilter: flowtable: additional checks for
 outdated flows
Date:   Tue, 24 Oct 2023 22:45:31 +0300
In-Reply-To: <ZTgdvbb3Z8RrFWzJ@calendula>
Message-ID: <87pm13pzny.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343B:EE_|CH3PR12MB7545:EE_
X-MS-Office365-Filtering-Correlation-Id: 956759ec-19f8-47f6-bc88-08dbd4ca9d31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FRTz93fpeB3BBoSuR37pRt5TrqYcjKxkzwNKJTEYdceY81O1KKVuSwE1Oka1G7SCkuGr//CECddYuxOCvx+j/DEmaAyVtnLxODKReBWPX3+onGMS+J5QtUrjv0FkJ8FJzbg91Vtwtafm3lWWIFTQbjzDg40wqQvqOOU1zfEwUzb2oKpjCyBb0NX/t1EmRhwoBX+k/Y3HlPATm9EjRualAyCH5e0a2SqyGbAkDJXUBEoGlQ18kVLswTyi7XI5RD++WzLHcvsIU4/zdtQyR4ZrsEhJQLRHXhoMI55S2ageoxBjrb2lM32i5zRF5WZ5lH4UWFyM7J2h7LRtKiNT3ttZrE/K6xmz1xRJ0aKGX0Frfsxy2AXTiJCVy7nxY53X0FJ7qg+UUufl6kZUH/pZZVp1YMAZ7OjuHvjxJEQuH5MsEDGrpfMxWeux4b5TxBW9MaNs/IG5cEzxZqdrFRJwzrw7qm8K4TxxniNVXCGBxcE/k5nqEykJQrYc9AasnM0Pi1ip1kmVmuAdmGmUSq2mOTXz+CtU6z5pSB2gd7Bb1zeeYduNFVku/HOmqiPOWW3c6y13o5BOvQyYMwgroRovLea+UeoQAQXw2SZJuCFnPXiHt42Sy+dwUd4uySC2QIzA6RtIRHpAnfvTXMZ8FTj9m2SzyKz2mIafYUpAvG6IS7iHSdu4WhYX7GexEXLxn3zBMlA+LJf7N5xim4ZgPiv54kpNn4Jv6X/0PzDGf9bngdjglqOvjY4iZP2w3HKYYWa8bPYM7gdh8NNqFXFbYsX2SzT0o7IU7HE4RBkfBSLUFlmvj4A=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(346002)(39860400002)(396003)(230922051799003)(186009)(82310400011)(451199024)(64100799003)(1800799009)(36840700001)(40470700004)(46966006)(36756003)(40480700001)(40460700003)(54906003)(82740400003)(316002)(70586007)(6916009)(86362001)(36860700001)(7636003)(70206006)(356005)(83380400001)(7696005)(2616005)(107886003)(336012)(26005)(426003)(6666004)(16526019)(41300700001)(8936002)(2906002)(966005)(5660300002)(478600001)(47076005)(4326008)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2023 19:51:28.7259
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 956759ec-19f8-47f6-bc88-08dbd4ca9d31
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS2PEPF0000343B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7545
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue 24 Oct 2023 at 21:40, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Vlad,
>
> On Tue, Oct 24, 2023 at 07:17:18PM +0200, Vlad Buslov wrote:
>> Current nf_flow_is_outdated() implementation considers any flow table flow
>> which state diverged from its underlying CT connection status for teardown
>> which can be problematic in the following cases:
>> 
>> - Flow has never been offloaded to hardware in the first place either
>> because flow table has hardware offload disabled (flag
>> NF_FLOWTABLE_HW_OFFLOAD is not set) or because it is still pending on 'add'
>> workqueue to be offloaded for the first time. The former is incorrect, the
>> later generates excessive deletions and additions of flows.
>> 
>> - Flow is already pending to be updated on the workqueue. Tearing down such
>> flows will also generate excessive removals from the flow table, especially
>> on highly loaded system where the latency to re-offload a flow via 'add'
>> workqueue can be quite high.
>> 
>> When considering a flow for teardown as outdated verify that it is both
>> offloaded to hardware and doesn't have any pending updates.
>
> Thanks.
>
> I have posted an alternative patch to move the handling of
> NF_FLOW_HW_ESTABLISHED, which is specific for sched/act_ct:
>
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20231024193815.1987-1-pablo@netfilter.org/
>
> it is a bit more code, but it makes it easier to understand for the
> code reader that this bit is net/sched specific.
>

Thanks for refactoring this, I agree that separating the act_ct-specific
check makes it more obvious.

How would you prefer to solve the conflict with my fix? Should I wait
for your patch to be accepted to net, rebase my fix on top and submit
V2? Or you can incorporate the checks from my fix together with my
signoff and submit it as a single change?

>> Fixes: 41f2c7c342d3 ("net/sched: act_ct: Fix promotion of offloaded unreplied tuple")
>> Reviewed-by: Paul Blakey <paulb@nvidia.com>
>> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
>> ---
>>  net/netfilter/nf_flow_table_core.c | 2 ++
>>  1 file changed, 2 insertions(+)
>> 
>> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
>> index 1d34d700bd09..db404f89d3d7 100644
>> --- a/net/netfilter/nf_flow_table_core.c
>> +++ b/net/netfilter/nf_flow_table_core.c
>> @@ -319,6 +319,8 @@ EXPORT_SYMBOL_GPL(flow_offload_refresh);
>>  static bool nf_flow_is_outdated(const struct flow_offload *flow)
>>  {
>>  	return test_bit(IPS_SEEN_REPLY_BIT, &flow->ct->status) &&
>> +		test_bit(IPS_HW_OFFLOAD_BIT, &flow->ct->status) &&
>> +		!test_bit(NF_FLOW_HW_PENDING, &flow->flags) &&
>>  		!test_bit(NF_FLOW_HW_ESTABLISHED, &flow->flags);
>>  }
>>  
>> -- 
>> 2.39.2
>> 

