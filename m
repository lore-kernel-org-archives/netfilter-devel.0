Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D00E5C00A8F
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Oct 2023 20:16:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344112AbjJXUQZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Oct 2023 16:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343823AbjJXUQZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2023 16:16:25 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94C5E8
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 13:16:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N2O3LlbLUc4j2G78uSW2I06EaUE6kQHDQx9nEEiqzpSvnzHZkZ2qj7jFDa4J+bseAvCsFCUUn2TLPsCcqMOab2yrKguNWgGFmHGdROnShP99sa+dQxn1H55fP51lSWZdmXDCJL5XokMcyiOh0hsvhwSJJUMiiZq8hVYO3ZTtB7QXFoVDJJ6BEk3IaB4DFGUMFLFSLEbpALGBrMJYZ1IMfJZOUS8u5JnuA1yCCXiVXddGlU3T81UQC4jtutYXWKFFN962L0BVqTxtasgd7i32nrziXxAOA+sAOUvOgG+mkJfjqB9y8iPm0KDDWWx+oXYkcIobntG5XneGggF7kVnXhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YavDOBrLdktUqNJfRPWdO9OAsaAmw4L2khalNyNXhUw=;
 b=aQa6FNHOlnToAmkudGv7rE7yLkEVZUitJLrHiKmTwRRgp0IDMKXfLJnynOI07k9RnmJN09RdopjNeQjDMf6VvDPvboCUX8Fxg3UTSwQTCYkg/9u+6Q13bru7FPjYhEjmsliuY3Ow4AKUOsLUOsihLtzvYprToxm3UzuAuxQn3K2olwENaqknHHZFK5n8D2KPka59PPMf41unmRoJImydoN6KHktCza2LK0X9mcGJ12B2qzZBFbKts02xzKv4mpfqGY3lbRCoaFXT0WbMiwByzfo2SUF8IuXQXvXTq9EDvUZtXTIjfvhsrZWKkGecyp+e9apIsquZO3oF4lpc3ExgzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YavDOBrLdktUqNJfRPWdO9OAsaAmw4L2khalNyNXhUw=;
 b=lsGCbFHg5yvBqkemtiArOcQOeWXiH1zGQbkfj/ZVd8pno4l/XrsBw3tk54LILZj7zQNxaICA4N7I/9A1TGwTs2QWiC7A3m89y75YvYd2pU1Eg6UsrZDR2gswJmQkzh5FNng4viTKiRfRGEgFX/c+h76zREkSGgYIekBGW4lTD2csQBIUu+KHuocXnpTZgfp45+vIGJSxhzvhgXloj7oBTxFUy1/Yw3FgdUKc2CNIBuuclNwos7SwwCoc13aP/P9lo0/+y9nWuE8QRiNwFy5VBYsbJXNOwiQx/MRN9BtKvhuis0K3yvCppDHo1AGflJacgk7NgGkkVdMNmYlPs23pXA==
Received: from CY5P221CA0092.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:9::22) by
 IA0PR12MB9048.namprd12.prod.outlook.com (2603:10b6:208:408::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Tue, 24 Oct
 2023 20:16:20 +0000
Received: from CY4PEPF0000E9D7.namprd05.prod.outlook.com
 (2603:10b6:930:9:cafe::3f) by CY5P221CA0092.outlook.office365.com
 (2603:10b6:930:9::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.19 via Frontend
 Transport; Tue, 24 Oct 2023 20:16:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000E9D7.mail.protection.outlook.com (10.167.241.78) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.15 via Frontend Transport; Tue, 24 Oct 2023 20:16:20 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 24 Oct
 2023 13:16:08 -0700
Received: from fedora.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 24 Oct
 2023 13:16:07 -0700
References: <20231024200243.50784-1-pablo@netfilter.org>
User-agent: mu4e 1.8.11; emacs 28.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netfilter-devel@vger.kernel.org>, <paulb@nvidia.com>
Subject: Re: [PATCH nf] sched: act_ct: additional checks for outdated flows
Date:   Tue, 24 Oct 2023 23:09:22 +0300
In-Reply-To: <20231024200243.50784-1-pablo@netfilter.org>
Message-ID: <87lebrpyii.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D7:EE_|IA0PR12MB9048:EE_
X-MS-Office365-Filtering-Correlation-Id: ae61583b-2dcd-4c2b-60a8-08dbd4ce161a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vwVA8ebUvDfbgSV/CLEMz2V/FxSt+J30vijN8XiV8ELHE6sUJmM/cqp3qhMmJNG3DPbL7qcLC+BQyBhjvy+DEEyLZGN6fmPaotImW3YV52h8RbEcLv3QOPTh1f4anPFf2WjTx40IivWoFnKURgXbMlWBWtKrSr3NFihBW5DZqjmKFr/Hw7fYwFixrnKZgbFeErYHwCxFEJx5bldhqWx1Con7H8yylfAbFnQpMSnUpQOgk/YZLD3mHrsL+O9Igz/uGbEUX62dSChgvQV0GmN3F9Yo0CpnPnTp/SJJcx1yB7lchbCGSi5vSiXFsOnquf2N069saaWyzSBQhWYbDQN/0wHcQyq8+Jz8AxnA2FF/284R5zUMLg07beWV9aHMZT4PNQ/Ahe4Q10BdXgn5LCYu8b2pn83hA82XmwNcuBsk3HzEJG0ERNXVtqNvp3Q+7W/c8VTzx27ZwKpZKs91NHKmO6tWmu0MZhjKMHehNG2TjPDbIvRB7JPUTMVricnEtixcZ9p+xkBhmUZwa/IUBcimGuUeukZ/STtNGVNZeZ4OisiMbSNT2DSob1wggt1xJynKh1GzrYpW+7Xr5evbC0BqFHiccBCylvBP0lBcYy1N4VpEPmao148FDFJYsUGhmJ7fnIZoh0SD7+DSMSgRLqfY7xvlFWSJHjJ7pxXkSJNSnc8xtB+c6ZN5p3XPtSYUhQKJ5058S6e9nEu+fETCawuKAWjXI0RlJNTaHHVpQE/eyNdJoCCQms4ZXDCUdRw5nThIXA4ZkE3qemGL01LcEZ0VFQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(136003)(376002)(39860400002)(230922051799003)(186009)(1800799009)(451199024)(82310400011)(64100799003)(40470700004)(36840700001)(46966006)(356005)(26005)(2906002)(36860700001)(41300700001)(86362001)(5660300002)(40460700003)(36756003)(4326008)(8676002)(8936002)(478600001)(6916009)(7696005)(16526019)(7636003)(107886003)(6666004)(316002)(70206006)(70586007)(82740400003)(54906003)(83380400001)(966005)(40480700001)(2616005)(336012)(426003)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2023 20:16:20.1142
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae61583b-2dcd-4c2b-60a8-08dbd4ce161a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB9048
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue 24 Oct 2023 at 22:02, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
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

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
