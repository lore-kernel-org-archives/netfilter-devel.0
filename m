Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D4B4C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Mar 2022 16:24:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234677AbiCOQZO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Mar 2022 12:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233862AbiCOQZN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Mar 2022 12:25:13 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E24B313DD7
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2022 09:24:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RF7DnsJ2MlZ6gWaXz1wsL4cIH65hmVjWRIXXk1dCKPiSpT8fw72cr2DIjMwEReLHCMdD/TBKKVWaz0AZBbHxDTLnkO0kbFaxuoqHg6R0C4yp/qr09Vb5OSuAFelJxrB6OasLyDUMIzQi+0x8FEIs4mHbqfGxTfZX+2CgI+w2O8+IPxB2O6+967bYvrZw3p4KP5UYIfMxv0PLcvf93+XOtfR5l/5pNTjdfiBAi9zID3Y2KCtteAIBnqEzMvdibtCilXIBd41N7b3KbMXrRI9/HiajwxoR8lcQ3Arg8ePg8cRBei3Vo1dZcJZoptfnekKWGUrqZSqKfeRfydY1GpP6iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NhEKjmy64Xz40XO2wCPPDpZs1J0dm4cjZ+aXLYxq00s=;
 b=fcNjnMm5kwqTeNeH1tovGbSvCsemr7s6n1iJcaRMZ7YFp/i8CDhUdgQZXSTMmM0DJCz/hCXKCobVG16kgk8zTe4Ea6ymTkh021d2LmHpauS5BS55IL48TVpEbFihrhX1PCUFQMj+PTs9kH/ocQ2vwfZaDohQAW+/i8suGh2QPZtM4WsSLTW7YFy+Lr92SP3A5uTDWbRQjZFtrP0gsG8p1zMqvFN5LKFPUKKxNuZ5qUxla4Bve2IowmyFEzj+vA0K4w3qmQwiBFQZ9uHJiHUjp/rY5bnSpEwEZHuFsYlHNUy/WtuCj369l/t2yYm2lVJzDcbSGRTfSh/PhF0qVchK0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NhEKjmy64Xz40XO2wCPPDpZs1J0dm4cjZ+aXLYxq00s=;
 b=rx1A2xeMeX9OhNJNwjHP0/hYBAIcuuK0K2EDYyCA1bB6SnYJBL+cz6KEvRdjcbXPCZjV0QXOEVcL7Flf6bILN0r7rGxlkIbmbVGp4B6eAYFc3HbVa7Ng4J8UssEcnJ5e3iGjIKJbtl0k3zoyWLjFjR9eX0h6nQMs9KsQ7jRkd0Hv/bCAPz76ivdeghSy5i44Sfn7ePvG0/NetmHtRvkmurwUe0ACd/NX4qMYHiFwpcuU2Oi6jUODzNZVNX/lXEpCxP2N8WQyptLzSVkeH31U/XpxQVlGD0UjQwln+eax72ZcyJQ87CRvqhTlICAF2OLHxbck5U288xju5vmMUn3S8Q==
Received: from BN9PR03CA0115.namprd03.prod.outlook.com (2603:10b6:408:fd::30)
 by CH0PR12MB5204.namprd12.prod.outlook.com (2603:10b6:610:bb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.24; Tue, 15 Mar
 2022 16:23:59 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fd:cafe::c) by BN9PR03CA0115.outlook.office365.com
 (2603:10b6:408:fd::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26 via Frontend
 Transport; Tue, 15 Mar 2022 16:23:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Tue, 15 Mar 2022 16:23:58 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 15 Mar
 2022 16:23:58 +0000
Received: from fedora.nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 15 Mar
 2022 09:23:54 -0700
References: <20220222151003.2136934-1-vladbu@nvidia.com>
 <20220222151003.2136934-3-vladbu@nvidia.com> <YiZ9fQ8oMSOn5Su2@salvia>
 <87o82bug3d.fsf@nvidia.com> <YjBpFDc+rOqhSPrW@salvia>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netfilter-devel@vger.kernel.org>, <kadlec@netfilter.org>,
        <fw@strlen.de>, <ozsh@nvidia.com>, <paulb@nvidia.com>
Subject: Re: [PATCH net-next 2/8] netfilter: introduce total count of hw
 offloaded flow table entries
Date:   Tue, 15 Mar 2022 18:18:17 +0200
In-Reply-To: <YjBpFDc+rOqhSPrW@salvia>
Message-ID: <87tubztca0.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aebd551a-439a-4d91-b2a6-08da06a035a9
X-MS-TrafficTypeDiagnostic: CH0PR12MB5204:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB52049EA8CD99FE578D61A90EA0109@CH0PR12MB5204.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RSjSsa7kZkmE67mTtVd16CHzIFO34LU8IMUwaLWrf0RgQathIakLT7DMORTzJV183CEA48lhJAUk9lG13B1FGcpK9zaS7nWZe3+DL9+2eenROV9tVVX+CcKw26ffubXQeKdaYG0c6xeuGb830AWK5Age1sTHXnRHUfcama/LQ5Aqs69Z4biTAZYZekP5sRMgfz3nogxtOLg0Ymt9QjOl4VsEeEOF1igsBqEMFbATkcp4Tc5GktIr9lmNdzsaZLdvt0sRu/rAwctiSZT3BPEOOrMiKPaeGQ1MmgvdlurdphdDCHyTKo5NzeZC3Zx5nwqCX2fXho+I9G6HU9S46l7WflQ8SeA4AvAbnIDEYvkMLsaU0/sOdxk0bXWIppQQG0SLgyemKWRT88X6O+RwRanYIVVVCK1qciQtK3rhvPrz9KDE+2EhHpPCfSu9EK5C1j0y1nsPby4XYZqWsfZz9IpR8diyVUZWNYxBRVw2ZSto02chnnW7QELcVLvQrBBmLn8yrj7CsyDlcGctSto9+8EAp5Mp8Th4lFHjqp866fHtLzCtJ2tWlLi3Kr7GA0Obxkzo6hr1rFCzq5inSbvKreQJI1Hung5rtMNM+nOQCmwoNuC+YiUpDjN5UEL9oR2PuNl3TTWTWMCIqNd1tOqIAr3Zwj5QWmVjxcjMOOiU29qJOo15xCJOdfvFgSzD1D8STjhBoLgopMZRIyrh14CPLWY58w==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(186003)(81166007)(26005)(356005)(107886003)(426003)(336012)(82310400004)(16526019)(86362001)(6666004)(2906002)(7696005)(2616005)(508600001)(47076005)(36756003)(4326008)(8676002)(5660300002)(70206006)(70586007)(36860700001)(8936002)(83380400001)(40460700003)(6916009)(54906003)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 16:23:58.9475
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aebd551a-439a-4d91-b2a6-08da06a035a9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5204
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue 15 Mar 2022 at 11:23, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sat, Mar 12, 2022 at 08:56:49PM +0200, Vlad Buslov wrote:
> [...]
>> Hi Pablo,
>> 
>> Thanks for reviewing my code and sorry for the late reply.
>> 
>> We explored the approach you propose and found several issues with it.
>> First, the nice benefit of implementation in this patch is that having
>> counter increment in flow_offload_add() (and test in following patch)
>> completely avoids spamming the workqueue when the limit is reached which
>> is an important concern for slower embedded DPU cores. Second, it is not
>> possible to change it when IPS_HW_OFFLOAD_BIT is set at the very end of
>> flow_offload_work_add() function because in following patch we need to
>> verify that counter is in user-specified limit before attempting
>> offload. Third, changing the counter in wq tasks makes it hard to
>> balance correctly. Consider following cases:
>> 
>> - flow_offload_work_add() can be called arbitrary amount of times per
>>   flow due to refresh logic. However, any such flow is still deleted
>>   only once.
>> 
>> - flow_offload_work_del() can be called for flows that were never
>>   actually offloaded (it is called for flows that have NF_FLOW_HW bit
>>   that is unconditionally set before attempting to schedule offload task
>>   on wq).
>>
>> Counter balancing issues could maybe be solved by carefully
>> conditionally changing it based on current value IPS_HW_OFFLOAD_BIT, but
>> spamming the workqueue can't be prevented for such design.
>>
>> > That also moves the atomic would be away from the packet path.
>> 
>> I understand your concern. However, note that this atomic is normally
>> changed once for adding offloaded flow and once for removing it. The
>> code path is only executed per-packet in error cases where flow has
>> failed to offload and refresh is called repeatedly for same flow.
>
> Thanks for explaining.
>
> There used to be in the code a list of pending flows to be offloaded.
>
> I think it would be possible to restore such list and make it per-cpu,
> the idea is to add a new field to the flow_offload structure to
> annotate the cpu that needs to deal with this flow (same cpu deals
> with add/del/stats). The cpu field is set at flow creation time.

What would be the algorithm to assign the cpu field? Some simple
algorithm like round-robin will not take into account CPU load of
unrelated tasks (for example, OvS which is also CPU-intensive) and
offload tasks on contested cores will get less CPU time, which will
result unbalanced occupancy where some cores are idle and other have
long list of offload tasks. Any advanced algorithm will be hard to
implement since we don't have access to scheduler internal data. Also,
in my experience not all offload tasks take same amount of CPU time (for
example, offloading complex flows with tunnels takes longer than simple
flows and deletes take less time than adds), so having access to just
the current lists sizes doesn't directly translate to list processing
time.

>
> Once there is one item, add work to the workqueue to that cpu.
> Meanwhile the workqueue does not have a chance, we keep adding more
> items to the workqueue.
>
> The workqueue handler then zaps the list of pending flows to be
> offloaded, it might have more than one single item in the list.

I understand the proposal but I'm missing the benefit it provides over
existing workqueue approach. Both standard kernel linked list and
workqueue are unbounded and don't count their elements which means we
would still have to implement approach similar to what is proposed in
existing series - add atomic to manually count the size and reject new
elements over some maximum (including, in case of unified list, flow
deletions that we don't really want to skip).

>
> So instead of three workqueues, we only have one. Scalability is
> achieved by fanning out flows over CPUs.

But existing nf_ft_offload_* wokrqueues are already parallel and
unbound, so they already fan out tasks over CPU cores and probably also
do it better than any custom algorithm that we can come up with since
threads are scheduled by the system scheduler that takes into account
current CPU load.
