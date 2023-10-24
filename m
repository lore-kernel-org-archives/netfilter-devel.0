Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5735C25B47
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Oct 2023 20:18:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344155AbjJXUSA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Oct 2023 16:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343823AbjJXUR7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2023 16:17:59 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE21E8
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 13:17:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U+0L5d35V9+oKmZjBzRaTwKTDeBy/gU0NMZnlM3RupbMrch9nvb5e9pzkc0FV6DtOyVs1T5VdP732jzKGO5oiPrmssb6eFcsR7BQeLRgaZZE1eFK1c39ffnIG7bqp++LHQXwng11CYF850gv3XzbQw1aqZ+WjgmRCfoPRclm2O6fuKjtMkOffLOqyXIfBRRbYPipOpAAPeu3Rhhrudzbm3dn+NqlDkfUyu3JK+94V413DUmDTMlCUvhwJdA1rsHOa6QdXLO6XnvDbJLrWi2PX9d8AoWWv0EUgySWWYi+tSQNlaFX+GvM0ABKZkgp8Hnd3sLUp+eTqg+7ZBGCAZy8xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ebsgYvQ5h9fMcntwRYI+RXMUJ0yKue8EreafkIuWF0U=;
 b=UlauOzRud1Ls9NzxH1Rriq5H9dHbEq7N1l4lIT4F+hrQIT+eUhZYsoDwwCv0m49Ho4azMVITYRl+3UQHWC5Og8yd08pfYYpNpV7BydMrslDbftQ0pno2ssRxgLoW3X9P4wPu7hwqt4w7dmQvInsA+x+Vk676mDQ8zuYt2X5BP9qsyIYQF4yntLSCzypEPz8VpJV1nznZKFN95KJg4TsWpIfZjKLJ105uszg9l2aX8WAHQJnZtw30OxGg7VqXk8dRueSoOEzg07ooZgB0Dnozc6wtJleCV9/V9QspkkuCVAdsAce2bCglMEGFFz8Kc6NMXFkvVXCNdZXl7mDy+B+Hpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=strlen.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ebsgYvQ5h9fMcntwRYI+RXMUJ0yKue8EreafkIuWF0U=;
 b=piS4JzFoKert/4q5BCPsRshECPoOyr9GpqOF9SpfCX8ImkKFJ+rrJT3sGA88vYv8KljKqvDYR32pe6XiXYLsIMxpDDEAJjhyjDEZ0Nlwbj4VWoAEHAGhQfsoLvwyMzSsNehYUt0TrFX0ZC+nkELYd4EsCccFlHM3tGHfkJCn/1s6Pc1PQbcQcw7dkhR/++LkhQE3IiKkw03jrtebmiVsZ6/AqxxENuIJRABZBy7VPZlT8D+vrqep08V9JKcxBZP7DaakJzrxwJhb5kE8qM8aPyy6V4L87U8+WommObvLOGW1/GxBDZezqBDGotFqtkQXP5UBIVkVSntyboz3Q+J37w==
Received: from DM6PR02CA0102.namprd02.prod.outlook.com (2603:10b6:5:1f4::43)
 by SJ2PR12MB9238.namprd12.prod.outlook.com (2603:10b6:a03:55d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Tue, 24 Oct
 2023 20:17:54 +0000
Received: from CY4PEPF0000E9D5.namprd05.prod.outlook.com
 (2603:10b6:5:1f4:cafe::f8) by DM6PR02CA0102.outlook.office365.com
 (2603:10b6:5:1f4::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.19 via Frontend
 Transport; Tue, 24 Oct 2023 20:17:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000E9D5.mail.protection.outlook.com (10.167.241.76) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.15 via Frontend Transport; Tue, 24 Oct 2023 20:17:53 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 24 Oct
 2023 13:17:44 -0700
Received: from fedora.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 24 Oct
 2023 13:17:43 -0700
References: <20231024171718.4080012-1-vladbu@nvidia.com>
 <ZTgdvbb3Z8RrFWzJ@calendula> <87pm13pzny.fsf@nvidia.com>
 <ZTgkGTiGbbcHcFWN@calendula>
User-agent: mu4e 1.8.11; emacs 28.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netfilter-devel@vger.kernel.org>, <kadlec@netfilter.org>,
        <fw@strlen.de>, Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH net] netfilter: flowtable: additional checks for
 outdated flows
Date:   Tue, 24 Oct 2023 23:16:31 +0300
In-Reply-To: <ZTgkGTiGbbcHcFWN@calendula>
Message-ID: <87h6mfpyfu.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D5:EE_|SJ2PR12MB9238:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f699aba-7958-41ce-959f-08dbd4ce4da4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UDPXvrsVQmlgjmlblbDm6XDsWUw7PNgUyefiK4TpvE8oronaGj2r1h7NQGr2Wm+iY+e7LnG+iHQ3Jtp+cy7juofQIeCFZuXPSPJg5pCwRA+V/5xvrmk7/CVhOO9djkMm6+/bar8siSUnDUlL8RbtveqJ/nFVmetbMfNcBa0kFQkeWDmHUaDWAs1PGs3XgJp3ZBDRSWgTdPv3hlCs4d0hfDb64nZFBMmzxgHoEl4RNXGguwfgrRYBqfX+IEg0de/HR8xL2LGiUp5Urbm4OxHt9tcTEj4g3pBEpR1XW0dVNZ/kjO8nEeK5u/xDNFcE8nAbRzRvaTt8RIr5yloBp90BQqVVRXgs4UtHLJ8bNsw2vMXurgU5lzXW+a5vz4aBDpdvNSgzBmY367R6Wd7HZjWrrhTTkqZMCw5Qi8NDUV+ecsmzO7gSBL0KqMNv5I1kb4827GP+wwl2/xfoWfCZp36ZSnwXeAvnJPTpCG76DJFL21TSNVYdRCsbLorIDlNa1iCkYfGvAW+Tue5hcSl+6KHYE9NqrYVwgoBk2/aCNbYC9TVWORP7URGoNrH04lRSpw3r97UwxBF8u6KayCL2G+ZnNoBVkbRAUX0sPpuJh7PAF/6gQ31FKF0T2B+BTt48ed16Nmx0EHu5cvudS9BYYmDjGUOTrxh+406s3UDqYZVi5RdcStbqm/et1lxoayzmwSQx54dHAoS4qbfcuDju7vi1a9s7KKf8BblMjSy3F9v7E6R6QqN3l5bg6qugImmVoy1uJIr4I34pzLQ2Fzi8UaDDo82KOFvR+22RTACF05rQxb8=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(346002)(136003)(396003)(230922051799003)(64100799003)(82310400011)(186009)(1800799009)(451199024)(36840700001)(46966006)(40470700004)(40460700003)(2906002)(6666004)(316002)(426003)(356005)(83380400001)(2616005)(26005)(7696005)(107886003)(70206006)(70586007)(478600001)(86362001)(82740400003)(16526019)(47076005)(336012)(7636003)(36860700001)(966005)(5660300002)(54906003)(41300700001)(36756003)(40480700001)(8936002)(8676002)(4326008)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2023 20:17:53.2946
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f699aba-7958-41ce-959f-08dbd4ce4da4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9238
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue 24 Oct 2023 at 22:07, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Oct 24, 2023 at 10:45:31PM +0300, Vlad Buslov wrote:
>> On Tue 24 Oct 2023 at 21:40, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> > Hi Vlad,
>> >
>> > On Tue, Oct 24, 2023 at 07:17:18PM +0200, Vlad Buslov wrote:
>> >> Current nf_flow_is_outdated() implementation considers any flow table flow
>> >> which state diverged from its underlying CT connection status for teardown
>> >> which can be problematic in the following cases:
>> >> 
>> >> - Flow has never been offloaded to hardware in the first place either
>> >> because flow table has hardware offload disabled (flag
>> >> NF_FLOWTABLE_HW_OFFLOAD is not set) or because it is still pending on 'add'
>> >> workqueue to be offloaded for the first time. The former is incorrect, the
>> >> later generates excessive deletions and additions of flows.
>> >> 
>> >> - Flow is already pending to be updated on the workqueue. Tearing down such
>> >> flows will also generate excessive removals from the flow table, especially
>> >> on highly loaded system where the latency to re-offload a flow via 'add'
>> >> workqueue can be quite high.
>> >> 
>> >> When considering a flow for teardown as outdated verify that it is both
>> >> offloaded to hardware and doesn't have any pending updates.
>> >
>> > Thanks.
>> >
>> > I have posted an alternative patch to move the handling of
>> > NF_FLOW_HW_ESTABLISHED, which is specific for sched/act_ct:
>> >
>> > https://patchwork.ozlabs.org/project/netfilter-devel/patch/20231024193815.1987-1-pablo@netfilter.org/
>> >
>> > it is a bit more code, but it makes it easier to understand for the
>> > code reader that this bit is net/sched specific.
>> >
>> 
>> Thanks for refactoring this, I agree that separating the act_ct-specific
>> check makes it more obvious.
>> 
>> How would you prefer to solve the conflict with my fix? Should I wait
>> for your patch to be accepted to net, rebase my fix on top and submit
>> V2? Or you can incorporate the checks from my fix together with my
>> signoff and submit it as a single change?
>
> Rebased here as per your request:
>
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20231024200243.50784-1-pablo@netfilter.org/
>
> I took the freedom to take your Signed-off-by: and Paul's Reviewed-by:
> which is not the best way to go, but please acknowledge this is fine
> in this exceptional case.

Ack. Replied to the patch with my signed-off-by. Thanks!

>
> We can handle this via nf.git tree, there were no plans to send a PR
> to netdev, but I think these fixes are worth to (try to) get them
> there in time for the 6.6 release.
>
> Thanks.

