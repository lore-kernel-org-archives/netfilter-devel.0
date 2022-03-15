Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29BF3C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Mar 2022 16:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350267AbiCOQxr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Mar 2022 12:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350268AbiCOQxq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Mar 2022 12:53:46 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2040.outbound.protection.outlook.com [40.107.95.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A869C574BA
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2022 09:52:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a/FrulMVDFgKWAzMz4z0yXf5WDPGG58mDYvSLnS1MPYn3Drd6a5c0aAwqLz1y3GJMt1UVx8kwgphCZ3Fvd9kWvcC7jxJSUi7ctqU2/X66CmPbWgKhmjJu4bUYGZuyMGeFoHOzWwEYXBQv7OsH9wVzV4nzdu/p8jRKGW91WR3mknQ451NDx5VCJqusVbam7EEwLFaa2QAOoviHpwZkluyAlSYEyFSt7TL7Qm6OSkQLdyexiohRQ8boZ9rgN3MyeNo/H1JVfLktNmLGq1IaVyU7w4nQFQS8L8dLerUY2f2mso8eFFNBtP7ObuYTvJyhmQWZYPkDFx3D1+QoDaxpSM40Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y2Tua4XZ31eEZUBUaY2AbGy0hutUpsRJcIuqmUkc9Hg=;
 b=KVNf1UzRmvIXx2o1Ch8rLavQJioOcd//uP0rdkbYBCqrnGvECps7Hh1ByXPAPz//O6+boJpWWJm33DB/oPEm6qBa+q/n2KnzhpCVqJlaL50e3I7nCnwmD+zFOEDi1zAMt7z970nctO61M/Ose7WBNdN2NQMZr7Nv2e5dFUpQdEHIX3ervqg/xW1iBjyxdB71YYaqYBhBvU6cyADzgnBZAJqs5OXQkFeuzJFbZcVd/1W44HoNC/376CLTBYe+G/iYfp9n/BilM8MfiE1rSGSwfUUIoPvMePu/dM9EY6KaKDDcXMJZMdcqlKmf0p1W/KnrHWXt5GmOHIqKOK48+S175g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y2Tua4XZ31eEZUBUaY2AbGy0hutUpsRJcIuqmUkc9Hg=;
 b=ftHTie90xzkizTX/nhCZmW8uPpg0Z31W711Z8v6mBFhR2CReaURciua17nEAHnJG/VNxO3yiUX3n2M1o9K6LLWw62bFaiXh+ActzRoos6N6TLnim7+BOmga846Q3KUPFsbf77MoBLWY1Z6dTHaJ8f0aB8U8fKhSs/jjHM4rvwHfx81hqQfPWtuQ9HfbFiUgBfhu6WnlVXzDajULd/zCGzFM0GIVstTQMDURcedc1PXbR8VRBMKp+XbnVA7rortLDf7g8XRQF/gBET3vbrQf8WI15ZTlaUIOsoCKn5oleoRvCaedrv8C3dmV630Az6KsH3MqWKRkbbIbfTE4Wa9CHcw==
Received: from BN1PR12CA0012.namprd12.prod.outlook.com (2603:10b6:408:e1::17)
 by CY4PR12MB1495.namprd12.prod.outlook.com (2603:10b6:910:e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.25; Tue, 15 Mar
 2022 16:52:31 +0000
Received: from BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e1:cafe::a5) by BN1PR12CA0012.outlook.office365.com
 (2603:10b6:408:e1::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.28 via Frontend
 Transport; Tue, 15 Mar 2022 16:52:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT024.mail.protection.outlook.com (10.13.177.38) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Tue, 15 Mar 2022 16:52:31 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 15 Mar
 2022 16:52:30 +0000
Received: from fedora.nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 15 Mar
 2022 09:52:27 -0700
References: <20220222151003.2136934-1-vladbu@nvidia.com>
 <20220222151003.2136934-9-vladbu@nvidia.com> <YiaL5a8akGHoIXLE@salvia>
 <877d8zue2n.fsf@nvidia.com> <YjBqkv6YTyxd/VFy@salvia>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netfilter-devel@vger.kernel.org>, <kadlec@netfilter.org>,
        <fw@strlen.de>, <ozsh@nvidia.com>, <paulb@nvidia.com>
Subject: Re: [PATCH net-next 8/8] netfilter: flowtable: add hardware offload
 tracepoints
Date:   Tue, 15 Mar 2022 18:36:50 +0200
In-Reply-To: <YjBqkv6YTyxd/VFy@salvia>
Message-ID: <87lexbtayf.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a02ea6d5-67e1-4355-a851-08da06a4324e
X-MS-TrafficTypeDiagnostic: CY4PR12MB1495:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB14952B5C96B5388DCC907E8CA0109@CY4PR12MB1495.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YNM/8qfJlHKANRWYtwr7uHfg7f1aMiiCPdMcCzPovqHbUveOXBrpY3wBIdnBoJQUNtrGdNGEeqNmesQjFBYih+srhNy326FJTehfJNCH6SbIJ3waKDwHCuFket7mQqFJw1HOXSGW3/1raWi9jOcQpfl8iBVu/kyZt21ee5s6D0RLPdflZp1qSQLo0+JgOZY6PaFauEd8FW5bicKk1AkV99xSUTj4EHrTEKWnQ3OQvYL5b6lazLAyYw1LXXeYGBfS9yeMOuZL2vdBRtwcDHtlTw+gUaM8wmH7WA0WZ0fkJgMO7tUDDzzjQxPnB7IlhNG6fErohVOak7umsOQPLIDO8uYQ1vG+jRPQQj4+qWdfwUIINvjLcL9pExrIw46PxHGFfOJIDWNeSGd0E5U92bXEjte6b+eWSwTR3Y3hGyrMvCCjrnXWHq3xrtBsXVDwt4XUM83MuEQOud6Gq8HiSP6juttHuzE3cBQ7dBKZvJSw8T1yq5YZrYEOlZfikbGhZgIHbkP9X4feVuh4aQlxX5ihzJjINvPDJa2z1x4nhlr4q9brc+yAo1T9mLAaFijiOpwaatDM1z/6qEhnWOzZgbRslTvbVZK+U4+y/qFR/TwLmRG0jTqgUMpdxDCIg3MGNy7B9sfvZvj+mt/n8YZ0iMNyvWr8wMmYdHzDBCT2jePbm56DxHapgTZxbY4lBvbOxN6fzzPxt+rnWnIJgw3d7kwTGw==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(70586007)(2906002)(426003)(5660300002)(7696005)(8936002)(508600001)(36756003)(70206006)(47076005)(336012)(36860700001)(8676002)(2616005)(186003)(83380400001)(26005)(86362001)(40460700003)(54906003)(6666004)(107886003)(82310400004)(356005)(4326008)(16526019)(81166007)(6916009)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 16:52:31.3046
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a02ea6d5-67e1-4355-a851-08da06a4324e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1495
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Tue 15 Mar 2022 at 11:29, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sat, Mar 12, 2022 at 10:05:55PM +0200, Vlad Buslov wrote:
>> 
>> On Mon 07 Mar 2022 at 23:49, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> > On Tue, Feb 22, 2022 at 05:10:03PM +0200, Vlad Buslov wrote:
>> >> Add tracepoints to trace creation and start of execution of flowtable
>> >> hardware offload 'add', 'del' and 'stats' tasks. Move struct
>> >> flow_offload_work from source into header file to allow access to structure
>> >> fields from tracepoint code.
>> >
>> > This patch, I would prefer to keep it back and explore exposing trace
>> > infrastructure for the flowtable through netlink.
>> >
>> 
>> What approach do you have in mind with netlink? I used tracepoints here
>> because they are:
>> 
>> - Incur no performance penalty when disabled.
>> 
>> - Handy to attach BPF programs to.
>> 
>> According to my experience with optimizing TC control path parsing
>> Netlink is CPU-intensive. I am also not aware of mechanisms to leverage
>> it to attach BPF.
>
> Sure, no question tracing and introspection is useful.
>
> But could you use the generic workqueue trace points instead?

I can. In fact, this is exactly what I use to implement such scripts for
current upstream:

tracepoint:workqueue:workqueue_queue_work
/ str(args->workqueue) == "nf_ft_offload_add" /
{
    ...
}


However note that such approach:

1. Requires knowledge of kernel infrastructure internals. We would like
to make it accessible to more users than just kernel hackers.

2. Is probably slower due to string comparison. I didn't benchmark CPU
usage of scripts that rely on workqueue tracepoints vs their
re-implementation using new dedicated tracepoints from this patch
though.

>
> This is adding tracing infrastructure for a very specific purpose, to
> inspect the workqueue behaviour for the flowtable.
>
> And I am not sure how you use this yet other than observing that the
> workqueue is coping with the workload?

Well, there are multiple different metrics that can constitute "coping".
Besides measuring workqueue size we are also interested in task
processing latency histogram, current workqueue task creation rate vs
task processing rate, etc. We could probably implement all of these
without any tracepoints at all by using just kprobes, but such programs
would be much more complicated and fragile.

