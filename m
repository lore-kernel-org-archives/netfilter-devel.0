Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F849C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jun 2022 10:44:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234604AbiFOKo3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Jun 2022 06:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346667AbiFOKo2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Jun 2022 06:44:28 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2076.outbound.protection.outlook.com [40.107.244.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D063506C0
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2022 03:44:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Co1QhdKzyO6bAHy3f8u5qYyWb8GV+fVTny4ShC9+XrqxhEIA8rUDmO8Z6S8M9+OXTvoK+Luds+hmJ2i6g1e4lVoDaeytbtOeX3qG5CDEkMoKRgEoXsC71mLeAMT9VIwjr9oF5V9ons5THhKXucy09w43OtoycNvNS7KUSweQDzNB8yvFITaSv27EJFqybYN7Iy2+efN0ZoSG7DAS3hJnM4Ij+6sm5YnmBZcsfIYlpPmxr75XKcLInmu+Le3vqE5BYtmuMU/dfCKh71pio0g741zp5Xd89Mt8uUnleoXhP79UlJpkSQtwEyxYsPXeYO8ulYMwGC3XUmIpEI2/JpcM1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j3NRjGW9QAzyYT2ZMrcgzR6XudHJ7/y1Zr9IxoeWbA8=;
 b=HBu0WHuELnR0AVtZ+zHGnG3GL3/4SZe0LS7tuSIi6/GcFzPevkL4HgiK1JKlPH96lFAm8RFhQyVkuAX6juNR/37tDa9hzWdyfFYCEOipcwcP5nNwG0YQGa+Xp2FZPzRMgqX2IVq5TeXUbSOEy+8Q7IQw7VhpLDXhOlB8Zw4vnuPDMX2Tn9hzfZvRyeQjiw/bBA0ZspSkF8jWYhY84p+Fbnl9/nvKTU7PmZd54gzETA5TTdU0ngLV0obaoDrLEq9qGyh1J1m9gZV1rowqsU0Unebltie0jIA3wrvmJOYnpajlTg1pmM1sZO+YMr6fb0p8xxeNf9DRak9IOHZzTbegPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j3NRjGW9QAzyYT2ZMrcgzR6XudHJ7/y1Zr9IxoeWbA8=;
 b=eBueqXApaoUggzfT6ufBVulgt9epuHWu7N3lRl6sKI3/O7md2LbvXr4X61Rh44GYI7iJ35IR5sS1vFIogmyWS9Wwa/Pibh+Id8Ije8d8lbponk2p/9E/gTEw+RFcVVCAt5TcXO3rXptZ3+wZgaAnrKlN9wj2ofSMOkH2HTip7Y4W3M4YYC+xX2PFTuIoafyCvqG0GOLW3zY87DlBjzt1KnRJsYExdat7SlDX3BTNoOybnd7lokk/wFAr3BDA0Y7BVNEnj8JBDXekwhU/j5YmsAUFxJlHrWwZy3u4xPi6o2Ps840J7+CtS7WRnXFfVPKDXbJYXA4ddG8f4E8nbhleOg==
Received: from BN6PR1401CA0016.namprd14.prod.outlook.com
 (2603:10b6:405:4b::26) by MWHPR12MB1167.namprd12.prod.outlook.com
 (2603:10b6:300:8::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.17; Wed, 15 Jun
 2022 10:44:24 +0000
Received: from BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4b:cafe::12) by BN6PR1401CA0016.outlook.office365.com
 (2603:10b6:405:4b::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.19 via Frontend
 Transport; Wed, 15 Jun 2022 10:44:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT013.mail.protection.outlook.com (10.13.176.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Wed, 15 Jun 2022 10:44:23 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 15 Jun
 2022 10:44:14 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 15 Jun
 2022 03:44:13 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Wed, 15 Jun
 2022 03:44:11 -0700
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netfilter-devel@vger.kernel.org>
CC:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <ozsh@nvidia.com>, <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v4 1/2] net/sched: act_ct: set 'net' pointer when creating new nf_flow_table
Date:   Wed, 15 Jun 2022 12:43:54 +0200
Message-ID: <20220615104355.391249-2-vladbu@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220615104355.391249-1-vladbu@nvidia.com>
References: <20220615104355.391249-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7fbce75-ea71-4192-9b36-08da4ebc02e5
X-MS-TrafficTypeDiagnostic: MWHPR12MB1167:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB116700C5508F6E510E2A869BA0AD9@MWHPR12MB1167.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3iUgyheYAPBWFnbPJasZ8kyevfL1QB32axAyqh1426hkpJb1w3fGK/Ip3gpy5KwZ9o/ya+zXr+S4jiQ9zgwag/64fSouM0C7qV7Jv5IeO5jCQqOjElS4reSO78V1mY0Mjlcm7AjGydKXQLBi2IxOq9RXjySXWAfj4xGAH7MQ6nvG7K7fIWjit85anoqmkSdXcMwlJkrJ/VFYnnpIJbcIL0PJ2UlckKnAWJzzsFcvsLwG++zgzs55XwDkBxpAAl689cyubCRZ2+ItshVFfmsH0DuIcUHqSoNFfKbyLSkYcGMRSKSzm5u7dcYQldJyOYj1UaujHQgCL731/edbH7VlJrmL8F5o/lG3rB7oGeIdJbUvEpWRbbH12kf4Ws9R49pQ90H44SSO12Z9GfW/B412GyQ7fBwa6xuINJ2iG4Wb/v8VIuKsc3+vNeS8hKo5y2p0PdlqUHh9UKWJELJF2tl6jsBUuYEdfDZRlk7rE3yFV0xFzfUAefsLbX2isRLPp9q4CIkSrd5JUzLrtGrtKcf40nJvtQQE+xASIAYKK0cmCu97D55MKmGTSehn3RjKoqbkhN68ZLbbCbLsaiYY+TzzSURM7j9/MV6sKMqEsEIWx6hMaTkxgrFVr913DVF477Koy+1AZgiGCjR4kaE7yl7gL1t0bweAIFp6G76YwYGIdMes1v624upfuSGeTBQ8t67EADSGOd/WoOb9nWjBmQ4Fsg==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(46966006)(36840700001)(40470700004)(36860700001)(5660300002)(316002)(8936002)(82310400005)(81166007)(26005)(356005)(2906002)(54906003)(7696005)(6916009)(6666004)(2616005)(508600001)(8676002)(4326008)(70206006)(70586007)(186003)(83380400001)(336012)(1076003)(426003)(36756003)(47076005)(40460700003)(107886003)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 10:44:23.3891
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e7fbce75-ea71-4192-9b36-08da4ebc02e5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1167
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Following patches in series use the pointer to access flow table offload
debug variables.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
---
 net/sched/act_ct.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index e013253b10d1..d55afb8d14be 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -277,7 +277,7 @@ static struct nf_flowtable_type flowtable_ct = {
 	.owner		= THIS_MODULE,
 };
 
-static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
+static int tcf_ct_flow_table_get(struct net *net, struct tcf_ct_params *params)
 {
 	struct tcf_ct_flow_table *ct_ft;
 	int err = -ENOMEM;
@@ -303,6 +303,7 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
 	err = nf_flow_table_init(&ct_ft->nf_ft);
 	if (err)
 		goto err_init;
+	write_pnet(&ct_ft->nf_ft.net, net);
 
 	__module_get(THIS_MODULE);
 out_unlock:
@@ -1391,7 +1392,7 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 	if (err)
 		goto cleanup;
 
-	err = tcf_ct_flow_table_get(params);
+	err = tcf_ct_flow_table_get(net, params);
 	if (err)
 		goto cleanup;
 
-- 
2.36.1

