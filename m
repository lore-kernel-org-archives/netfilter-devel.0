Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EF7EC43460
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Apr 2021 04:12:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BED7611BF
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Apr 2021 04:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235064AbhDPEMk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Apr 2021 00:12:40 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:21925 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234757AbhDPEMj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Apr 2021 00:12:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1618546335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gZNDL3z0rwVzyhzEkzJKhlmUkKRNnxFMabW5T9UqxVY=;
        b=eQpQdHi45PbBvsInT5lX39aZIC7XAW0UUgBm4+Jf4ZO7ZoKEGK3VKgQooAlMvXoWATGCck
        8iSTiMHgqdCO8GovSRFrA+Dm8N17cnBEV9DaZlKnI+V9YphNWo0C2vk3ZMMTx3O8OY/+JO
        n9/oIGz5O2wVEufXfls9LwQcQXszax8=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2050.outbound.protection.outlook.com [104.47.12.50]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-16-j3pwjIu1NRe8Q7oomr_TCw-1; Fri, 16 Apr 2021 06:12:14 +0200
X-MC-Unique: j3pwjIu1NRe8Q7oomr_TCw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YVmR8l9l3FZyMywGXfxsre5FifHDL97WcHcXhzhtMlrnBKX5UMyNVPTp5WcuSqyVUs/f1NfYIvCzAVcta75HUiXTxuXONaxScMrfND4pp8nL+5j1tV8WKLrmdX+1VtczhLRHyjo7HdBvT2Shy18LrFptKRlV3XINH+j/4bqLZbguQei3TtQGxw/KD89/2BlLe0LyW8KTjxeRSaZe+z0EF8MzE7S1nUgpxFUsVx/XNxqe6sXn7dlQq0QA7tlZina7STR3QmRvZqUFbffoApR2kAUvzc9WzYCiqpDuFFHcDVNhSdLlWNsHSdevMIPkzEwAvVQ+jMrsVhcGnXFX075r0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cj9DkhqT/xehEdf0VLFvSQ6wDgeYfbGzQA+ABkNScPs=;
 b=M7teGzEJ1vIvevjIdl13RUj3FoL0jHpie5zGZqxESul4w1M/ArGqFFx6uANlgj8HmaFqf6QqrmJCesv/C9ho9la5k+YCkaIQoN/zJZR9ezjPLL72qhuhNrUTFuNMN86WKbaL+7ytHT8rOJz9Us9tTfOHRHQQxEPn+zSIzhEEfgis06ydzUHpTxPL6QMycwE+QtF0BftB0hql53uww33BjSWaNfeQsCE0xyNupNvPtWmyogMx2IC4ZMOgein3oCfs5qHxP9W+WLV45q8VH0/ntamxy0VTfYk/Y4SDhDcI1mMdW0TTIATkLAu+HmsXF7V2FEM+2JNIHVl3mI87aEA1+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: netfilter.org; dkim=none (message not signed)
 header.d=none;netfilter.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB5584.eurprd04.prod.outlook.com (2603:10a6:803:d5::10)
 by VI1PR04MB6991.eurprd04.prod.outlook.com (2603:10a6:803:12d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 04:12:13 +0000
Received: from VI1PR04MB5584.eurprd04.prod.outlook.com
 ([fe80::8b3:2975:72d7:de70]) by VI1PR04MB5584.eurprd04.prod.outlook.com
 ([fe80::8b3:2975:72d7:de70%7]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 04:12:13 +0000
From:   Firo Yang <firo.yang@suse.com>
To:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
CC:     sflees@suse.de, firogm@gmail.com, Firo Yang <firo.yang@suse.com>
Subject: [PATCH v2 2/2] ebtables: Spewing an error if --concurrent isn't first argument
Date:   Fri, 16 Apr 2021 12:11:41 +0800
Message-ID: <20210416041141.27891-3-firo.yang@suse.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416041141.27891-1-firo.yang@suse.com>
References: <20210416041141.27891-1-firo.yang@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [36.130.189.239]
X-ClientProxiedBy: HK2PR02CA0152.apcprd02.prod.outlook.com
 (2603:1096:201:1f::12) To VI1PR04MB5584.eurprd04.prod.outlook.com
 (2603:10a6:803:d5::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (36.130.189.239) by HK2PR02CA0152.apcprd02.prod.outlook.com (2603:1096:201:1f::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 04:12:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b61d933d-71c1-49fa-30cf-08d9008dcfc9
X-MS-TrafficTypeDiagnostic: VI1PR04MB6991:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6991FD040B751A7EDFA28173884C9@VI1PR04MB6991.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bvQygGoWC2RMvsD3skirJ5nqWMh/K2KN2rfVR+9CmizTtn2XdfJCvefs457r+YRlaqzA+79KqlXeSh7dXjoauFR35dBxtmX9Oor/gtPfea98x14wX+uEcIqpo/yA0oVuUVV3xf7p9rtgeSaqGM9Jdx8ZFHOCgnfSFBMfBSQwiRL7kaKIY1BCJZ/CY2/zMCcHuFHaTUTSP83cps1jtCFguFD6Qumit9z75owC4d8a1ZkJMGjfn9sMKmE4uS2LOVyytKMyqAWq57rctM+OB03lXGIvv60xTDCg4zz3guRBdDLowGCzkYdFtQsLFfYWS69ghHNAO6s7baTee9+CalOP6fIZxALS+GdhrwL6UqI5zdGcoHCDVKubAfR/7nOBVL0x6xs692ioDq5U5VF9z141wWkN1fgRlVGGsCx83T2539NBViKSuXBIRxjTT7yq7E5QXLZRHTXVpISh6EC42qAeDkmF970F4C+TMdf1GrwBMdZL7aLGh87mOqXRxcBOEiCsQohUy3GXfg8G+PcSf9XJnfpLrw6Q71sYMGe5GUqN18nQJI1a5sq6wIzqnqIvTmOvI83ZQhHnpHDGdg2CvoiWHT5+5iV79QlV+fHJV2YsK1gNNhwGwhINtE+wPWzSOeewEQ67mf1lWOv2dMtM71Hvv3xoLcNvVKhJA3OVgQ4ayf4KNfZqIefWo0XuboyQIhqv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5584.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(376002)(366004)(346002)(2906002)(107886003)(6486002)(44832011)(6512007)(316002)(2616005)(52116002)(4326008)(86362001)(66476007)(956004)(6506007)(186003)(5660300002)(4744005)(16526019)(8936002)(66946007)(36756003)(66556008)(478600001)(38100700002)(1076003)(69590400012)(38350700002)(8676002)(83380400001)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?yUYimnFdIuW8yeyM9as7qga9kUv2yrIT5/UvIrKtCFiVwtiT7JYPNsoQA574?=
 =?us-ascii?Q?3QmoEVlneEQFwwwIdlKrQEMdhusIN1NgHx5OoBEGJNxDBEG+IE/yUZSVvmng?=
 =?us-ascii?Q?KNSKmhDb+08CE8YYtMwN3pKrY9htdSQZ7qu1KwcbeDIcE/E1XXy+riMdAI8q?=
 =?us-ascii?Q?wcvtB/I2/HXl6sDP3sXSnctGfNKTEI/vrpYlgjIkcqYrO5Rgc82dC9++sBCy?=
 =?us-ascii?Q?j38lESKUqmSzICMBzBwgNI/QkhJQskrJxzm6utLpBHqAwq8AEb8VOTjIWs03?=
 =?us-ascii?Q?JbvR9j8N9LDUTGYXSihs2YRC+yWWPlSOkK3E8Z6EudztONputTm8Nabpnhi8?=
 =?us-ascii?Q?hHbs4SlRTr5gFWUHrjyVir3pHrxbK9tmaKFNg1BJ21y90BkChyCe0PgCV2Yj?=
 =?us-ascii?Q?PbdatVr1fxxSQ6MWVhneCmEkmHbhxB16s7WaWIDfuJUhl+qo09eCEmgvGvhr?=
 =?us-ascii?Q?KG3ZfWqehARmUBvD55vsatf+aO9u1/uy98iBr/1Q9vPZHgIr9Ab/jn8BlpNk?=
 =?us-ascii?Q?KnpWnCDfGd4TKFVgtUf9iX0KUck67OU3SIHw0v5VJ2u0rFppvXxmmF/UfzrK?=
 =?us-ascii?Q?FyJ8wXXZFbxD0GHRwN7dac/zaEDWUiWw33CuzyoG2b+TGKZZtHOwhaWk2l+5?=
 =?us-ascii?Q?+E09eMrhay9f+PEBIaxx0qebc1Ew7d+Dt2+J/7ohA9eRmIyYU8hP4r0iBAy1?=
 =?us-ascii?Q?2m6unNku2NxYUPCNgj0uThpiF9BsTjQ9qHC7vr29eDBSRosJdBj3MQ2Z40yY?=
 =?us-ascii?Q?WVn5/EyFqf937KhQG9X+iSrHGx4dHkxbjtxI+gzZ5nDFKriMU0vHrObaFt8Z?=
 =?us-ascii?Q?s76KM91Cx1AWCTkIz1eDQ+hMaHiwKDcw+uc/sfSM/WfbJY/Lke10cHs6BHzZ?=
 =?us-ascii?Q?CCkLxsaE2ZNuoOfN8EV3fpFlqg4iuqA68bnnM+UPVwts5skRAnz83zoWUMXr?=
 =?us-ascii?Q?30L6ZddyQWqywIWYMfg2UHT8MLWcPXkY4oqJyZduZgm2S2KNkM0Gy4CxsfT1?=
 =?us-ascii?Q?xJYESex+QaBCRZ+e2zxj6H6P2X5Z1TIn3CEb/NiJLviaoD6QUT8tJMCkEK5T?=
 =?us-ascii?Q?+oxp2/HGYi9sEwwOh+NX90zDJYnmLxZ3I+PUuYRhoozlmcDNNw/OjOkYRKmB?=
 =?us-ascii?Q?/WPDQ5IG19+sPYkhHMz0I6XGtxxJUT7r/PVNOuNoKI+AmP8LoyzlJS77LXvv?=
 =?us-ascii?Q?gULzIWVEQ59tbVAhP5QatgX33dDCruAhUL8NGcdnG77h/PSljeByxL8d5n/9?=
 =?us-ascii?Q?XKXYwMlLD9MtAp1D9i+vwHs1HDfwKxJpnaM0npI4Ms1N0YfxBNxpFhRGDEkv?=
 =?us-ascii?Q?cJIG4pXxhmRUfIvGHKq0Pq5i?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b61d933d-71c1-49fa-30cf-08d9008dcfc9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5584.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 04:12:13.2719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yfEMDMKV881knBKeXRy1Rt8lnAvILvuCaYEJkB3dudKPXqSfpoJzUHL1tt5ypnLmTaeUoGEud3NKSJOdib7tKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6991
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Our customer reported a following issue:
If '--concurrent' was passed to ebtables command behind other arguments,
'--concurrent' will not take effect sometimes; for a simple example,
ebtables -L --concurrent. This is becuase the handling of '--concurrent'
is implemented in a passing-order-dependent way.

Fixed this problem as Pablo Neira Ayuso suggested by simply spewing
an error like following:
./ebtables-legacy -L --concurrent
Please put the --concurrent option first.

Signed-off-by: Firo Yang <firo.yang@suse.com>
---
 ebtables.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/ebtables.c b/ebtables.c
index f7dfccf..c1f5c2b 100644
--- a/ebtables.c
+++ b/ebtables.c
@@ -1041,6 +1041,8 @@ big_iface_length:
 			strcpy(replace->filename, optarg);
 			break;
 		case 13 : /* concurrent */
+			if (OPT_COMMANDS)
+				ebt_print_error2("Please put the --concurrent option first");
 			use_lockfd =3D 1;
 			break;
 		case 1 :
--=20
2.30.2

