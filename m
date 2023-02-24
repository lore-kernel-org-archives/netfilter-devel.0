Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F991C61DA3
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Feb 2023 09:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjBXJ6f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Feb 2023 04:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbjBXJ6e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Feb 2023 04:58:34 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2134.outbound.protection.outlook.com [40.107.22.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8476E61F09
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Feb 2023 01:58:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vm8kdW9S1LUKadYX3GCdGJvtY+RxmmKJyCfRysHQizd4jzjwDbhcISQej6XlzyaKsYqaGEM2ov60qjAfaOM9Fozsjf7QwRDxUqaUj/nOOE2IVSP4VODS1KxttbJ/BjpVGKmDX5NF6/BWilMj4x/RZiIv3yiFmjNT7+cyUxIwjKKSCWz/CQElDI+Zl+lEjEoONe8F6Ap204aBKwUiRbBLaB2P5eqbFI0DyQmdV1aOQdV23QORzm0T7QdEYzIer5PrvHOuXXFY6v0nMDxfKPctzaIe1x1aA0bcg9PLsEAtTXL1GAzVeggu9EHljHLLdnhRhO+THttcp2majTypOi6fEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tqRygrOHCfBrf5r3T1QZqjW0cVw973BI6St+IWPVpug=;
 b=ZSWliP11OP+uVYZubWMfbcdZV1DRLMLQOOYI7eLtdJO0Qdk00u8E/8nAIdxGYweCZp70kHo4XbQTdjzM20TayDm2q9L2YbwTUoU/GhK1cFltjtk9jz1lFbEpppv/bSL2IbVdX67vH4pTbmzCqhBcFBs/az0MSnjjqf4lTqAqGkdNtgutblItymHxtr2JPN4B3keJMRppchvfXcj0B+uzi3GMl8QSAcrjGrYij7+0sOxKMrlB1Lo5C2So630z4dQYkELILl/pxml5a4UIiUb9Orv+MG8W3XIQYreOdb339KNeTOXL9zL6cQLPOPxiq0zZtK3ZDxbHpS7sc4CAGkXQXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tqRygrOHCfBrf5r3T1QZqjW0cVw973BI6St+IWPVpug=;
 b=c50pHfV9cpXk+XRAbSvUMgmfrWs8zqn0w3oS1ZFx1NrQ1piafvXR1CtGiS6xoq1GPAyXD+eng0UDAiE1/b/q9RyrlMO3Y/krg/o//FtuC5ZeN5reqVmTNwvH9FlCfQ7VJj7KTDGyYA2jAvAD6oqqQb/ss/GzQoKYlNGsTh8n39E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by DU0P189MB2250.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:3e2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Fri, 24 Feb
 2023 09:58:21 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::13ad:a312:15c6:91dc]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::13ad:a312:15c6:91dc%9]) with mapi id 15.20.6134.024; Fri, 24 Feb 2023
 09:58:21 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [PATCH nft v2] meta: introduce broute expression
Date:   Fri, 24 Feb 2023 10:57:35 +0100
Message-Id: <20230224095735.19317-1-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0076.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:a::35) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|DU0P189MB2250:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ca356c6-9c35-486b-f6ae-08db164da97b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: axqHcTOrU1JuWIenGd0/FUQ3tZoMpsbfS5rk2G65blkeywFnmA6OM+VeOJBBQ7NH+GNYz7WdOLIhuqJuIO28igILh+A9DQ/mLOAvDBIXx8Jr63gTRJW391BLgzWqgQ9bCdcKEkkEyR4YEdhfFChlGjKoQm6VbnUIZcqezxZj0A2BhAukEH/i4nu0KBYj0f31VJCe6dK/ZJYXQDoNWvEUSjJKR7/GYc5LYI4NrmQNOBNauI8RV+TYfC7/Qg9DMDyzuHmtMDC6YW0lKjr0cbAsoMh9oFzC21suuwWc/xrCWGcqv4ftuQJSqi4H6oeUUS4VsL7ed4aq4EaqsZqmBEnAyTD9lZ9BUfxWJlgB7xug9FscK9cG4e6dFRvsdrFXC4TjXfs2q4AHiS9lWZw88sQRVcS8k6sjnGXvfJDUkXgJlEz+uKbwHhRtg6hY2xeAG2VrRyIfPsq7D+l/ZPtWbuIWkTv+yAnZpzrgcsLIvXH3ry+4B8RGfidL2u5gk1GA65oTW4M6qP4NRfhSAqtt4ryT0I2HxV+83g+cIiRumumHN8C4U3TxA4NchVi39CjNijAdVYGI0qIn9ioKJfE6Urfg1RBTlmJodOtmaXrHNxphuJ7BztCbpTeVUm4Gd29r8zSIHhVMnMqMpqsOBkeeTRtmeDJeX4vxqRg8mXrMIJ6OL8QiOaVrYV1gTzpUW4299Vm3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(346002)(136003)(39840400004)(451199018)(41300700001)(8936002)(86362001)(44832011)(6916009)(70586007)(66946007)(4326008)(5660300002)(66476007)(8676002)(66556008)(83380400001)(2906002)(36756003)(316002)(966005)(54906003)(6486002)(478600001)(26005)(6666004)(186003)(6506007)(6512007)(1076003)(2616005)(38100700002)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XT07xshmmQ5ablFIMjLP4JubqlJo5LwXRXmsfto1BXZbvu014BGehDEkOGH4?=
 =?us-ascii?Q?wc8kznu8ACABp3ES5mDzpsaWnCHpvA7Vn3t3UJ+cAP8FFqM6K14tJ0NpjnYQ?=
 =?us-ascii?Q?9i8fFUsvpWEK3oXhXU540Mgf4KCd0Qu7WoLQirqsVaDXRmQ8JM6rDUoJa5yU?=
 =?us-ascii?Q?PMvGihNoRnF++44GBe9CSlKsVF/oiTEgDYNEAsOy5LpasQKBlnoSqURIhooJ?=
 =?us-ascii?Q?B1pXKBq9fXWGBWsnQGQXieaXIlmckkTMkr+BW4ikBPv8tRclWUrGOgXzfY7E?=
 =?us-ascii?Q?DC1+OsbtvvSle4hOyBk39I4aJ8iGYAWXxr4XfyqVZTWXMNWFXlTk7skmapDM?=
 =?us-ascii?Q?XaA96kaUo/GkAM+sy75CxM/3ml+f/+2heib+37+DB0dIACiBJLQcwJQvRHIJ?=
 =?us-ascii?Q?P7GPxRxo59gamAsrMbOpLyfOgR6xutWV4cmwOMtnvyhX3ht/Y1OGqp0xIpSk?=
 =?us-ascii?Q?lLI3diBRt5+Xvx4iNFatBn9RQow51M15G3c/Mz7/CVZwK1jJsOyL7jlXYuYe?=
 =?us-ascii?Q?Qy0yq94JmoHE+vNWPXiEVUne9tD/Pi+LWl02HYEsimC8VqyYxoiGAFgyd6c1?=
 =?us-ascii?Q?WDC40Y6URoYQZbWfyKFN2Q6qoB9C5bv09rsUZRExnoDmu7HwCJn5l2pfj3mX?=
 =?us-ascii?Q?AALCsIhgKDtpmKhLNKjQmEAxzQ+/xvI9yHxuzScob7whV+APU16g7yI8JL4n?=
 =?us-ascii?Q?P/P0VgnojuEQTbRwkKOODeREvJ4JzWJDGkN/5TVa28ZtNlmggv37ABvmUHyF?=
 =?us-ascii?Q?baREauaue9MWbm1aqlCdSZjMQ06BwJghmV7EKH53LBq0PFoRQsJFAfAwLTuS?=
 =?us-ascii?Q?Cke2ygAk6cW62+8uZjZV9Tq2qtZPfmUW+N9BDqshYbjkZZV0DXMQ9TUMFTg8?=
 =?us-ascii?Q?0y+wLRrEenNIRc0Ro1APgJ1S0q3nb15T1y+GkeN23LY9ZgHevXe4VoNnDsc5?=
 =?us-ascii?Q?CGR1Bvz6LFTR1jc17jzy5fAeQCz6BxctbkVyBTyUas1Jwai8L5opzC61eEQS?=
 =?us-ascii?Q?vvJDytHh6wAhumsHD3m74GpA6azdqXgz/Fuujl6CFauXa0ZLi+oLu1GQ7Q1n?=
 =?us-ascii?Q?qXzfBNFDzJICQhUIEocsKvoxFkSuUnq393FYO9nNgkfHXF7LYcYGpVyLFMn7?=
 =?us-ascii?Q?w1x5PK2uf/Zs8gHFs/NEWL5xVgyrXkYD2ZQAWn7yOUK1ZCNo7tgmtp2DpICj?=
 =?us-ascii?Q?TBfqSWYJ7QLYxR7bE3bol0k5KabjugqdYdRl5n1iXR+hZHcKEHVQm0iXyQhb?=
 =?us-ascii?Q?zBCN1NwvdwRckaaYCH28Gt5pHHBTe2hg8mFPguIQ97lq/fYLVF6opb7pKuX9?=
 =?us-ascii?Q?HihiB9axsRPJAt+i06tt/px+aZqg5GE65QpjW/38GQeT3lK/7r2cnAseYuzg?=
 =?us-ascii?Q?72YCdNC8XHTKY8Smar+riiIKE085W11J1NGJEokMXR66BSTd+3LDILch1ZXM?=
 =?us-ascii?Q?Mjs0J6GjJrzOaYyxDjxaG91hkxJbPjNWB1yFU0o4b2FpuFxP0a2UosjFiOvN?=
 =?us-ascii?Q?2D5jBY+ey27Ckf0TTYb78tePWOSyQO+0Sco661GCbEEa0orc9KMaMgzQYEpQ?=
 =?us-ascii?Q?TfZ41c6deVxH8vncAyoOti0l6xt/oTbuEwCX2LXoaZVy4phhOjmoh/H6aGIO?=
 =?us-ascii?Q?YA=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ca356c6-9c35-486b-f6ae-08db164da97b
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 09:58:21.5933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lSZfpAhDIECD/dSsvKMIe/0qntGM0sUnJaQFRpDvRnTX2bJ5+GDqiqTeftjhp8X/VMyD9GNdGqd5mhc765G7lfzJoKE6RYS+64tcI2J+dOc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0P189MB2250
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft userspace tool support broute meta statment proposed in [1].

[1]: https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230224095251.11249-1-sriram.yagnaraman@est.tech/

Signed-off-by: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
---
 doc/statements.txt                  | 5 ++++-
 include/linux/netfilter/nf_tables.h | 2 ++
 src/meta.c                          | 2 ++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index 0532b2b1..4e7e2654 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -296,7 +296,7 @@ A meta statement sets the value of a meta expression. The existing meta fields
 are: priority, mark, pkttype, nftrace. +
 
 [verse]
-*meta* {*mark* | *priority* | *pkttype* | *nftrace*} *set* 'value'
+*meta* {*mark* | *priority* | *pkttype* | *nftrace* | *broute*} *set* 'value'
 
 A meta statement sets meta data associated with a packet. +
 
@@ -316,6 +316,9 @@ pkt_type
 |nftrace |
 ruleset packet tracing on/off. Use *monitor trace* command to watch traces|
 0, 1
+|broute |
+broute on/off. packets are routed instead of being bridged|
+0, 1
 |==========================
 
 LIMIT STATEMENT
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index ff677f3a..9c6f02c2 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -931,6 +931,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_TIME_HOUR: hour of day (in seconds)
  * @NFT_META_SDIF: slave device interface index
  * @NFT_META_SDIFNAME: slave device interface name
+ * @NFT_META_BRI_BROUTE: packet br_netfilter_broute bit
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -969,6 +970,7 @@ enum nft_meta_keys {
 	NFT_META_TIME_HOUR,
 	NFT_META_SDIF,
 	NFT_META_SDIFNAME,
+	NFT_META_BRI_BROUTE,
 	__NFT_META_IIFTYPE,
 };
 
diff --git a/src/meta.c b/src/meta.c
index 013e8cba..6f9ed06b 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -698,6 +698,8 @@ const struct meta_template meta_templates[] = {
 	[NFT_META_SDIFNAME]	= META_TEMPLATE("sdifname", &ifname_type,
 						IFNAMSIZ * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
+	[NFT_META_BRI_BROUTE]	= META_TEMPLATE("broute",   &integer_type,
+						1    , BYTEORDER_HOST_ENDIAN),
 };
 
 static bool meta_key_is_unqualified(enum nft_meta_keys key)
-- 
2.34.1

