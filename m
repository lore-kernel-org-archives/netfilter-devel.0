Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AB7DC38159
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Jan 2023 11:59:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbjARL7U (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Jan 2023 06:59:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbjARL6p (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2023 06:58:45 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2130.outbound.protection.outlook.com [40.107.105.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7EA37B79
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2023 03:15:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fqzDAAs9tdjYy/trCWmnyDg3mJprCL+RGML+d48m7zFhWAh0dxLXjvRtOFNhXXiTugOSQ1fF2gVpRd8gxvT6TIChLdaWw3gG5ZcZrFnVgWmwd3p8hmtjlM2Oec/YNDQvqb9fIA7Dwe1m6fYgVtLMj1xPE3/fEE69O7I9bwCWCSAkAe/h1PQ75c+HcKP/bWQX3Fv1TrnX73cXR58zFCHWyDqJyJdjSvz0KK6YTTS8EB9WsWGlCEdysoIlEm/SaebEodrvfst5VOVubXzT5mzL4c3t5Fr4plsqEdXOVpD2pjVqSzIMfO7w5EcdEgBepw35XfplsfjvWICtJ7Cfu3XqcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JJ+HTH+QHeC2JlvOBDne8BTWryVYvU2RwcC9b/sCSrk=;
 b=C/PXOdK6eiK9Eoc78hqNeJ5IbCPZwvtHGojQx2ztzofedBYiXEB3HNF9oGcUrVn3yJ9fmveb6pB3NIsVwFJrXwwA0ptjHMjxtvPR+FGJhvFwJT3Ri9CuOi3HJAG2XYVbT9OdQ2FQgfmOHa8GO5Muy3htDbWH44Fy4baH22vRV2sv75MdCuCLbZpp2n7HLfp1q2DXxqp80E9KYp/osrp6kfH/5af651iO2+mTE81SBsjHns8TAF/3qhZgMwKwAXcrgkXdkrZm3iKVD+Hh3OetSLJ+3STDxA3cQpTp9gtggdpiv+LEHq+J0a3GsIWJHicA/CWxMaG0v+Qqx0D+UEQhdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JJ+HTH+QHeC2JlvOBDne8BTWryVYvU2RwcC9b/sCSrk=;
 b=UbphcCLcwx6YyWS7XycXD5xoAKcBgszWQVbUED1uqJ/8XmAIFgl0N0Eb7P/cCQaRWVCii5dOVcZPXO4kxCkuJ1GNwO9exQYjniK8REJ2Zf2N8r5HRZeBzv+1Eb/NT/quWpFGgrUyGgJgMT0BTUtDMfUxGw6I1vJC5vTFa/ZoUp4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by VI1P18901MB0783.EURP189.PROD.OUTLOOK.COM (2603:10a6:800:123::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 11:15:09 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420%8]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 11:15:09 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Long Xin <lxin@redhat.com>,
        Claudio Porfiri <claudio.porfiri@ericsson.com>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [PATCH v2 0/4] sctp conntrack fixes
Date:   Wed, 18 Jan 2023 12:14:55 +0100
Message-Id: <20230118111459.32551-1-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GVYP280CA0007.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:fa::27) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|VI1P18901MB0783:EE_
X-MS-Office365-Filtering-Correlation-Id: 45c0e8dd-020c-4b51-303a-08daf945426e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UP0n3YtrdU2iilOOFu5+vwD+qaW+99Jod6lyYfRk0QeFcMkuaa3Qxi/gXOFR/fUhc4Rtq47pMlgiW6P4uW/cBwKMAj+yzxogYsO9fkYG96Mp1ArLZ9BwTtpzvP5sbx/oYeSSxTyWnJ4DOwfHLbAJ6LkWXsJzi+2QuIVFlhpJiSSBbOMAVvABPcPMYWY7uCq++VnPWOXbs0xqPGaB8XYHTFDhTOPs7OCoB3wNxwZWbYcRb3cyXoChlsMRk82tKyb33Ut72hNceYU+PSR0q4jD0ml7PmRVOSFxUCAu5F1k3OX/0tpgfwT/9xPnuNiEiWcfQLP29Dhm11m6o5MOciNCbn/SaSeS9Aw+n0QWj8nueiGkKRcb+B1aEZQMwqCo/sI50yZKK+726WCcQntXFKWtooKt2QMx4JMMwiN0ahPSM0XGFEu+XbCuQIRZ5zMY/YVY2n8U6ZddMK9RtNPhVfIYbonBvp55uzn7KuGzFMsZ9Kkn3ZpsmeJZU3XIBBulaoW7uKYy8yiLxUcFtJOxBecPP+fq4TSoJ93iYqYVvPAlJfBEeoP1aQ8ZcvOJR6MzrwWYVNzxeppa3o150FvU516KCudXoflC2iTSqC63UpJaNv8RJOeWXBBuc5IjqD0+CZMSTJ9rSUIVhbVw3yP4w27mYGkKhPeaQ1WGpRR3utAk6obdCEBIbTxX+u14h3rYD5S29qPJIiYCD57qUw2jSN5am28z51hmMLcuDK39sDTxAbs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(396003)(39830400003)(136003)(346002)(376002)(451199015)(2906002)(38100700002)(86362001)(66476007)(36756003)(316002)(2616005)(1076003)(6916009)(54906003)(4326008)(44832011)(6506007)(8676002)(70586007)(66946007)(41300700001)(66556008)(83380400001)(5660300002)(6512007)(6486002)(26005)(478600001)(6666004)(966005)(8936002)(186003)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pDJD4ErFLIZyfBTIZ+llHdpFQb3Yr3bzPQDEUh1Z/93NqlAsC9+8/Qb9W/hu?=
 =?us-ascii?Q?AhPRQWX9kSW23j2IjaHrH/oscXmKmr8WwZvZSUi5bU/mFT4Ecrx3a4YtX8pb?=
 =?us-ascii?Q?bwAGAkPG0BwP2J7eOxJsdgJZ4Da0qZB4OWzHFJGzDFKFZDsx2CSVuByL6FTT?=
 =?us-ascii?Q?VU7CwrR/nMHps4AQYsKWmap6r1xLxIDDXH/B4JEkwkzRQeP6mS3bk9+yLQ1L?=
 =?us-ascii?Q?bUwJ+2wh0WyzuCghhMX0fdvLaOrNDNDYreXnqYq2C4tTm6PFZ501s2akPxPh?=
 =?us-ascii?Q?GOQxj7Fi7vaSSMW9x3v1xGKzu+hUuC9L014jy1uSdvRJGIcGSTjukXQwEH18?=
 =?us-ascii?Q?uV283esqCx9ub2KXUEQYsEnfdbCVJEvmu/3NlvlahNxqxfPA4o2BufVaUDhG?=
 =?us-ascii?Q?TL3QN0QSwrnf9OGwQ3U9zU1nHe3yQIcwUWmUmf8DtkVxS7cRs4FMI2w5MBuH?=
 =?us-ascii?Q?QvFGC7u+y7rBNdAwhkXnYygR92nIjgfiHxpJ0asBffw5rqs+ZaGFTorqX79I?=
 =?us-ascii?Q?lR262+U3Dur2NNRmL28+eyobpNftQR3N8j6nuVSjaU6U0SLXyi/tQu4HGxjs?=
 =?us-ascii?Q?djHBZjnBwnhdtCPg6hp+pvhHPricoNMGNwd+CONtAwYlvKidf7KKt61JUgMH?=
 =?us-ascii?Q?J2L1zGXxbjO++Jh4EdMixMtD55D6uTOj2e/S4s4xkR8ooUm5eE2TMrDrEMBS?=
 =?us-ascii?Q?WbF/3TyM2xlHxvd10GRvCDM9cWy74CmAbXkmRaz9xUZzpWLGXic7Q7AUIjHL?=
 =?us-ascii?Q?vpMB527pej0wg6KrRcog5earjgsDx3bDtSQgV3keNmULvg4GkbmfWW/lQ+BA?=
 =?us-ascii?Q?cxCZPQU/OngIQiBLkafGVxrn4GDxgCYABwLMIuLF5jAAipHMoy+iK5ys7EDn?=
 =?us-ascii?Q?lMxNcFbOcLWZ6hLBoswQzd4kgUGnkuF+/8v9AvJEvZ1FfXL2ZK3wwn+LNs1A?=
 =?us-ascii?Q?XE8n3RzOREM/O9imfWV7lkRzZhN/rzkLWVNBrJuAgF6cWf4V56ODqYmFuBL5?=
 =?us-ascii?Q?dcPapeo1zZLtHsoIQVxfrexOSawGUIumU4Hb3XY757MA0J7WTHBT87Zzde65?=
 =?us-ascii?Q?WqUGp+syY50fycR3bhJiWRq1+twD93uOm7UzPydr32Ty6r9ItfNy9oGb6EWY?=
 =?us-ascii?Q?/a9OQooK7aDPS3ZCM3uSwjgvPz4JRsGP6fqWq/hq9o+sHTOl4RB9Y8Ia14/o?=
 =?us-ascii?Q?Kcq4wTC+4hiESb0zHzpaSJvm8Hi1m+XbA/Zzhe4309LFtUxmHS46tIf/49qA?=
 =?us-ascii?Q?jVuMTz8+oOUYq3VKI48e6eWbYuTWaHLlyj7BHGeTe7RsfMIxCb9KieQlHJTB?=
 =?us-ascii?Q?Gnb9xRkPbgsetRvmlcMEbIrkucECE1ggRT5G59hu+PRanyq9SqH2JWeD3tP5?=
 =?us-ascii?Q?s5zZhDLoIdEck7cqDirAfKRg/KzKtGFcocJnGaRjps/9CZpSjaQxP6mxDvM4?=
 =?us-ascii?Q?QC7i/J52MDXgJlDCdQbMId+QBVAdHhRETa66yGjGuvFWw23a9kIfIbLl7kx6?=
 =?us-ascii?Q?ndK3BuuAS/HeTP/OtnxP3co0iHU9AFKJf4/5ugi6zfKiWaqYa1T0CEsRO6Yf?=
 =?us-ascii?Q?y1QjPfmK297Dj5RpFhyvEdSNB3tlRU5buJkaJurIQ4xgBfX28X3sVQElXSG2?=
 =?us-ascii?Q?EQ=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 45c0e8dd-020c-4b51-303a-08daf945426e
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 11:15:09.0329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fCBE/a0PQxZEeTQlKSxB70XmeOBjuTJvdpbeRGVDwnNC/AUZwLKR3dlrz8qQW0CiiWlrnP1v4tgctsrfXa1T3M3NArIBUZHDR0uAuBDmnKE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P18901MB0783
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A less diruptive change as opposed to below RFC patch:
https://lore.kernel.org/netfilter-devel/20230104113143.21769-1-sriram.yagnaraman@est.tech/

This contains a couple of bug fixes to existing bugs that were found
during the review of the above patch series, and also a patch that
unifies the ESTABLISHED states for primary and secondary paths.

Changes since v1:
- Reverted bff3d0534804: DATA_SENT state
- Set assured bit if new state is ESTABLISHED and direction is reply,
  regardless of the old state. Paths established by HEARTBEAT also gets
  the assured bit.
- Update nf_conntrack_sysctl documentation

Sriram Yagnaraman (4):
  netfilter: conntrack: fix vtag checks for ABORT/SHUTDOWN_COMPLETE
  netfilter: conntrack: fix bug in for_each_sctp_chunk
  Revert "netfilter: conntrack: add sctp DATA_SENT state"
  netfilter: conntrack: unify established states for SCTP paths

 .../networking/nf_conntrack-sysctl.rst        |  10 +-
 .../uapi/linux/netfilter/nf_conntrack_sctp.h  |   4 +-
 .../linux/netfilter/nfnetlink_cttimeout.h     |   4 +-
 net/netfilter/nf_conntrack_proto_sctp.c       | 159 ++++++++----------
 net/netfilter/nf_conntrack_standalone.c       |  16 --
 5 files changed, 75 insertions(+), 118 deletions(-)

-- 
2.34.1

