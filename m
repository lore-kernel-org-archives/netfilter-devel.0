Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A83EAC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Feb 2022 15:11:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbiBVPMQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 10:12:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbiBVPMQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 10:12:16 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2067.outbound.protection.outlook.com [40.107.236.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5299114745
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Feb 2022 07:11:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V9RqrnoPGXwnKCdm2yXK/ddkLtZRb/xK4di1Kkss0d7Cw8q2tIcLvTjgtWd2UHRxwQc5u2hw8oqF0izYmukFxAjsd94n0wfD8fj2zn5vMTKCMOL87/uh1a3G95dc0flF03YZtXlk1a7a4fdWkbaOvO8ALG/sbutG6ou5M7btXMjrDzYsxLT+03hO5jg6olgtZzRC7YbP+UvlevAszUaqa+TqVrruBj2VWnAC6MtNvW2T1BUpVENkqevRb5vBm3DOf393qq8P/bSnjtCdu+Ag5mh6ih+8tOiVafQlgXlu36F6qowjOBWBWTZYCfIiiVWt9fHGTOT33V8C7LIzfQQWtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dfvvn26i2ZDWky8ZE8LLkT08iYQHz4BKlutkfJkENRA=;
 b=jEMR7BiU5EGlljbPK+/cCe48qP/okGBYGssAZTKXmrRjNi0D12TofpTfRusExEuiMawP1y7v3gocmjS0ZjVBvgMfdkzLrpE3n+yrHwxunBIB9i385IrqET4sDYUCOzHoxdcz8PYkkChptnXi3wYI0QnKIRccYKOdXcq9jRICN9CDY6HuSs0MSpOXKVMaTIAP99e96dN44GqBWn6Tn+krLkn+0dPnMfOnDiZ+4lHbXDxUoz4fJGoM66CVtvqUCh6xMDb45s5T8ePkw4CEgoxTNd2yWrG4k59kldt1n9tPnAdpiSCBciq3q7fhBNUaNLqwpF5TdgQAIzIfUIn7q++CRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dfvvn26i2ZDWky8ZE8LLkT08iYQHz4BKlutkfJkENRA=;
 b=GupPXWz7Yt+WwZ5++w6eITPcsortHmXOkUJYEfBZ3ZWBkQcuv+lPnr1EXQT+lxUgoFbjqB4uTrq3llIFAL0Aaem8Q7ciB1lxsY+6pYjeypdHwErOVcUYigviQHPywUJJogFNDt00ZVG0WQP5ljGJonFNg7OjP+cvQqIW+seSlwIdXwSdcDv3RUgeEidYktit4ZB0UjMc9M+tzSGbcYCa+qcXRo8O7i9WGyccwFNBqdyjACnr+XuA5Sp/8Tu5EWW/1cgO/hWL33SJ8mjLzyMni+b1+giGA71tDZq4qJtChcsr2YYurBm9coDyTWlbGiR23Duunxr7Ald9HjYW8OtKJg==
Received: from DM6PR11CA0050.namprd11.prod.outlook.com (2603:10b6:5:14c::27)
 by SN6PR12MB4672.namprd12.prod.outlook.com (2603:10b6:805:12::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.19; Tue, 22 Feb
 2022 15:11:47 +0000
Received: from DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:14c:cafe::b6) by DM6PR11CA0050.outlook.office365.com
 (2603:10b6:5:14c::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16 via Frontend
 Transport; Tue, 22 Feb 2022 15:11:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT024.mail.protection.outlook.com (10.13.172.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Tue, 22 Feb 2022 15:11:46 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 22 Feb
 2022 15:10:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 22 Feb 2022
 07:10:43 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Tue, 22 Feb
 2022 07:10:42 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netfilter-devel@vger.kernel.org>
CC:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <ozsh@nvidia.com>, <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next 1/8] net/sched: act_ct: set 'net' pointer when creating new nf_flow_table
Date:   Tue, 22 Feb 2022 17:09:56 +0200
Message-ID: <20220222151003.2136934-2-vladbu@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220222151003.2136934-1-vladbu@nvidia.com>
References: <20220222151003.2136934-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: acaf4d8b-651c-4c07-3755-08d9f615a4ba
X-MS-TrafficTypeDiagnostic: SN6PR12MB4672:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB4672BA5336ECF958AFD34DBAA03B9@SN6PR12MB4672.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gFbXsh+XjiiBdpie3gyVI5IfW+ktljqRUCPYQlt6E4hG/An8fXKRE9EiqSM1chMQHw2cmx9L0JHz73mZR/j/EDb7pYJk7MwU1k2uJQRAHsTp+Xb+xntJp0qt1YZbwxAsULGv2J/8aYznQUQ6vf4yTmGS5H+EuxlhH9ub+CzyD7cYZtSUVoKmXxtRLr+ELI8FFr3D9O8djAHxrHwf+9isTFGI8dVuyl+CahvN8tLh1cQIlA8ymMwmuzg+d3A6KH0pBb4gvTa4fP/NEat42OikQ37+FGdsiCRHFfuYdG5a2+WDceWMXRzPHg5RE+YNlazzgeXmtbT8i/ExyHWl7X2lRBNTmp4U6zw+sNAhFaUT1EoylOigM1ykyMN+eU5sLaEs05zabeIa7HrCXUisXwo+szruAjJPVxI8TOz87LfkYmmVObPsHlpUsPPkQIq6DRFx5tGzQGHqUeTby7ELJtKm96XxNLFD5fvDbQfRgq0lQr7O6wLG3zzE2ukKmfH83Vl0xnU639rQ5Nz0YK+VQ3UKNwLj9mUM7zfWCFj3eHhcrTZMPf6s1hgK0v1wMd9HcyComlFVt6Q9+eRQWfbVYiEMet3QxyjxpuXH7D5U8jp895h4sj5pgec1MWj9JqMSMZ3F2/f2C+go9HyL2v6cb0kjVUqNVxJbCH371idsH017mBs7SEt6TkPiLT5OGYdQF2IxuOnts0+y07rMdAB4sCoThA==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(4326008)(81166007)(8676002)(1076003)(26005)(70206006)(70586007)(82310400004)(356005)(2616005)(107886003)(186003)(508600001)(86362001)(316002)(2906002)(36860700001)(7696005)(40460700003)(426003)(336012)(83380400001)(8936002)(47076005)(36756003)(5660300002)(54906003)(6916009)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 15:11:46.6643
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: acaf4d8b-651c-4c07-3755-08d9f615a4ba
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4672
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Following patches in series use the pointer to access flow table offload
debug variables.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
---
 net/sched/act_ct.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 7108e71ce4db..a2624f6c4d92 100644
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
@@ -1321,7 +1322,7 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 	if (err)
 		goto cleanup;
 
-	err = tcf_ct_flow_table_get(params);
+	err = tcf_ct_flow_table_get(net, params);
 	if (err)
 		goto cleanup;
 
-- 
2.31.1

