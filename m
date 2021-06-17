Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 086A4C2B9F4
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Jun 2021 06:50:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8755611BE
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Jun 2021 06:50:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbhFQGwp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Jun 2021 02:52:45 -0400
Received: from mail-bn8nam11on2081.outbound.protection.outlook.com ([40.107.236.81]:11547
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229515AbhFQGwm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Jun 2021 02:52:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z8/8jLdLVHgBcSqSPAagT2+AA8u0PRkrjxNhdgAzpUZiEtcI5lV21IpOt2/oDH4UC/KBj/hTLvWgfPRpz0L3anNiZFcx79D+o5U2RonA6BtwJDqW1oeS1d/sK2ziAwhEvIYzhrgpGF0D0ZBob9vWB2qb6G8tsw1HfKS8zlUBOJtVrMaDlWeOfjxLUUf9nm+3DTWfymGnOs1VeY6m8E+YvKLLJdBomTYblQcCGaYg9FptE9S+vsMkJEQDf+mmIqXEeY+1Q8RkSLxdV/EwjAeJuapWvNSrYgfSLRY0xhEkpUumSLxc7pqNUBLjp8cx8F7mVv7sRUIRNt3w9b3G4JE5tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=biP1bxvG2M8Hc7KYx/T4KBXIdd1Ec4N03645Dy43TL0=;
 b=DbUE8QkjNmtwMn48rjmh1wOk/VzMizOHliBYcEo5VPqbf+E/yinQLmcsS/pG8tF7ky6rWzM0HpMpBWBxrwGvhlYyo5V9+kWVxlS6lX1it5p5Mr7S9x1gLSii7UGjrAkD1zPzceTga0pARF67ChqzQecjkn86eHljr0qjIYLCloyrQSCH6nlH9P1qG2lkIK4f4jexbmYBRyzsIsg6mGU9fufFrhrL/TUZytWM8LDRg6I4assWZbCSCJMPU5+KgRy9J2CZmkesdftGf+eetDuvzBf/CZw5kKvBR/p21nhY+IzEolYxEFtqVUab6gVa9yzlVbWWXATjcDkzarJjLBD7Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=biP1bxvG2M8Hc7KYx/T4KBXIdd1Ec4N03645Dy43TL0=;
 b=AW9VkMVtdlnsRbj1mkqrJMCREY55Jz9ASQe9+j5PonqBpVW6QlU3xPnZCyriLEO5otrHZc/8IUnQcp6TOt/lAq9f4vF9AWkzS+IZb77Wc/d1pwEDH99p/3nKrxuSRwDhSP5S0NrQj0TTKY0mzPnGCKWlEJ4Q0bBLPFWAOeSfOM9xT14ZJcOTCowQ/rKS0xMFJZTR1OwzyBtYfry7pWssxQ23FSWKoSKq3HwNcbxjcDYiN6vCaet/fkN/vlkW79B7Ey1NhshEXV8IVGCcDTJd8z0n2mhcW7UUGDwvAVJ6QkvoOcB4l8e5cxz+YEFDtonyvXTg27Pye9zgPFGWPI/QWg==
Received: from BN6PR19CA0049.namprd19.prod.outlook.com (2603:10b6:404:e3::11)
 by BYAPR12MB3270.namprd12.prod.outlook.com (2603:10b6:a03:137::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.24; Thu, 17 Jun
 2021 06:50:33 +0000
Received: from BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:e3:cafe::ee) by BN6PR19CA0049.outlook.office365.com
 (2603:10b6:404:e3::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend
 Transport; Thu, 17 Jun 2021 06:50:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT007.mail.protection.outlook.com (10.13.177.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4242.16 via Frontend Transport; Thu, 17 Jun 2021 06:50:32 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Jun
 2021 06:50:31 +0000
Received: from c-140-255-1-009.mtl.labs.mlnx (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 17 Jun 2021 06:50:29 +0000
From:   Oz Shlomo <ozsh@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     Paul Blakey <paulb@nvidia.com>, <netfilter-devel@vger.kernel.org>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>
Subject: [PATCH nf-next] docs: networking: Update connection tracking offload sysctl parameters
Date:   Thu, 17 Jun 2021 09:50:06 +0300
Message-ID: <20210617065006.5893-1-ozsh@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0bbeb09c-6753-4d09-5564-08d9315c3431
X-MS-TrafficTypeDiagnostic: BYAPR12MB3270:
X-Microsoft-Antispam-PRVS: <BYAPR12MB327011016D7B0EED3BD17007A60E9@BYAPR12MB3270.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7vZEpqxZ/8HaiQ31U+1m3Zilv6jpoLwLuShyf4UsPkI6IwFiuHRXC3pgp8NtU0nw33uKl0ufjbg61MOtHafGw2AVjNdzww7FpgFRXSTlV7rypuVsb7Dh90OQtRA+GB+05HLbksFKzlw/FQhyyMg5gibTRV5AagShDDCxv/FaVOgGaLwBCnnZT4FNqfXAuX1Rj3QU2Usz9bWo3JTCcmBmGCXE2UL87hx7J9yBE31zykpLlRfGT5FY2vlasNm5puE32ijhNxGFbMLLlskARbNQoo1z2mAYP2sA9tatZzkcFXGqZMsLjY4IcoF1HyxQOsT5M3WTP2HJJQfOsGJnDm/pHqR9jpR+cragdDYNYckCH6EplZTKMDGVtqFxsWWi7utbDEAcQlkPghq6X0uKmbruKdz1FYbdym7jxfL+xJano8g7kWh5p4B2r0Bt5MB3q4xeZSujAQje62uLJajjwViTtUcVAGkg68ne6fCN84PlZ8dOEwA6RuVk7bDg1XQ6v4slopFmAtO/gCOs1vZgUU+ryeZgFh/0RXzkGI/zztI6eqQS0OWYvP1G54J7DOzLaghy2Gayehspw/OWoY1S3kr1ayxIq0po/nBy4T/hC+X3v7MPyfjhZbGuODkCqoG6JD48gWj8H+89wJ2lpsHTK1QHvA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(39850400004)(376002)(346002)(36840700001)(46966006)(4326008)(36756003)(2906002)(86362001)(107886003)(7636003)(426003)(478600001)(6666004)(8936002)(82310400003)(1076003)(26005)(36906005)(316002)(82740400003)(5660300002)(336012)(6916009)(70206006)(54906003)(186003)(70586007)(8676002)(83380400001)(36860700001)(356005)(47076005)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 06:50:32.9427
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bbeb09c-6753-4d09-5564-08d9315c3431
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3270
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Document the following connection offload configuration parameters:
- nf_flowtable_tcp_timeout
- nf_flowtable_tcp_pickup
- nf_flowtable_udp_timeout
- nf_flowtable_udp_pickup

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
---
 Documentation/networking/nf_conntrack-sysctl.rst | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index 11a9b76786cb..0467b30e4abe 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -177,3 +177,27 @@ nf_conntrack_gre_timeout_stream - INTEGER (seconds)
 
 	This extended timeout will be used in case there is an GRE stream
 	detected.
+
+nf_flowtable_tcp_timeout - INTEGER (seconds)
+        default 30
+
+        Control offload timeout for tcp connections.
+        TCP connections may be offloaded from nf conntrack to nf flow table.
+        Once aged, the connection is returned to nf conntrack with tcp pickup timeout.
+
+nf_flowtable_tcp_pickup - INTEGER (seconds)
+        default 120
+
+        TCP connection timeout after being aged from nf flow table offload.
+
+nf_flowtable_udp_timeout - INTEGER (seconds)
+        default 30
+
+        Control offload timeout for udp connections.
+        UDP connections may be offloaded from nf conntrack to nf flow table.
+        Once aged, the connection is returned to nf conntrack with udp pickup timeout.
+
+nf_flowtable_udp_pickup - INTEGER (seconds)
+        default 30
+
+        UDP connection timeout after being aged from nf flow table offload.
-- 
1.8.3.1

