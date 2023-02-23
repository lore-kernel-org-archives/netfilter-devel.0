Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D71AC64ED8
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Feb 2023 21:12:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjBWVMB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Feb 2023 16:12:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjBWVL7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Feb 2023 16:11:59 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2095.outbound.protection.outlook.com [40.107.15.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7012D16314
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Feb 2023 13:11:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B+aMhBKAAIzQQsjWJYqoANFZUDYtUyeQUVB/3WGRjt1D/zuGGOrSXK7FI8wM162bqeRePqXrEzmIG8d7g6uogHMFLZ/pBEzHp66yUd97wSNe8qXTyWAt3pYXTkiDx+iDNSgssyIrO1Jn10qhxKtdeaBghlBl2Jjps/mW0WeQ42XIy5Rb8rDfyd6iZmiTNyXw++l8NQv/ssxhXiS/3SbenC9henGWsJ0x+9u0g3+bNk5usP6t4ekwLIWuh8wODQ1KN21zV1C4z0D5NwckHVqjm+P0c49RoUq949gZrtlDewRBhrIrTBWtXOogUo20h8i3/hM8wNLQUgRvDnsrxu9Twg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G0vyHiq78bywXFRQdQ5D/EsEqqbdPS495+u63H0TQeA=;
 b=RAy2VQxujKXbejMLRi+qGdUlOV6UoB2gPbGb0SHATGnuYdsHsWwnyPezPOm1Uc5b0lujAXEd1CPFsLSSsZtWeY4Kgbc5Abvt2PGAFeDgBvfUfCE1A/CVdiVUdss859sSpoDqiorQaZ/qnFxApIBmQz7QTvoHq0mx4SHf5zB1wCaNiQOpmsDDxf2IwhfKJ5RjCgR8RGwiv1g7Ls0MA2FH5pnY3b7ntfcD5X2ArBnYNBOHGP3uSI+iecLN4ow6js+DLRCtgo7PG3oNmiVxWpacUFtYrhOEGb5L4PSZaEyODhAIJj+Lvj3HU+o3gy1EWZjhlgnv9hZkezyfB2cxWPNMcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G0vyHiq78bywXFRQdQ5D/EsEqqbdPS495+u63H0TQeA=;
 b=RSR1dvspzwJHq3Ppnb17XesYiCOUEtaWxwnuXNoTAi6hR8PGTnjfJn2SE6GqW6lPWDnohQ/7DDeykh+ZLNNDXZMi8DErBZLvV1fIttKymmDzR2ru4c3XoRxcJnHDkhRSNlfcBuDFrz+EZ8bUJkBZaR0M/EQWqVgJOXPmKnOYwOw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by AM0P189MB0660.EURP189.PROD.OUTLOOK.COM (2603:10a6:208:1a2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Thu, 23 Feb
 2023 21:11:40 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::13ad:a312:15c6:91dc]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::13ad:a312:15c6:91dc%9]) with mapi id 15.20.6134.019; Thu, 23 Feb 2023
 21:11:40 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [PATCH nft] meta: introduce broute expression
Date:   Thu, 23 Feb 2023 21:29:42 +0100
Message-Id: <20230223202942.16459-1-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0072.SWEP280.PROD.OUTLOOK.COM (2603:10a6:150:a::7)
 To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|AM0P189MB0660:EE_
X-MS-Office365-Filtering-Correlation-Id: a49f0939-2360-4cbd-2623-08db15e28e90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d67795puyyvQMoaB//gDCb4nvPl/+4Xw5Yat6q5Cvu7ATvAOlKiKRdNF8OgMrJ72iFkQeODZAMlAFw8MYk5ZiQEGlrOuxyDfecYvJ12cQehNu0wInGj0yDDS2fwhaujqjA68JDXPbYyExVcma5JIUlIkCC01N2l1n3Hd23+FpOoX02dTSjeq2TknJOOCXghCnHnEnSFJZRszgxl2lyfc4OCFUvw5yazwzHU5bTf7fSBWZhLf5gRXaNT2iSTqouypJ59zGqhf6A36NvoHrxOJvvTg4ePI9yqFNh7kq0jgVqCMVFH6LRt6e3B9JNWIQu7HrErHZKWsWuwvU/a2ePpVyiJBJrESjnYOQZJ2y14TNgbtSQYOtGsz+Dn45sFXuLVecz0U0Mdkq3MD3a/2/Dm3x8H/RNDrmgtxRMMrawaHw87xB0A18ShUYPobSNLECj23iMY3yBwl5PiB+0Y4jWl4ZD8O5iB/t0BWfpdCQGq6NE8mJniM6GxwLCe2Xqao8GXI91ktYkNFrVjQKPwD7pyHmZewzQw5aB4yek3W6UmYPgkp9zyRlFwm7lUa4OgZ0RYIVJa/FDgwh3ezM1YkYHG6M4/WYSTIh6/FKFy+Zr3dpmiaERTzPql/FIBTS4b+5y4DeDvz6BeQQhx2tPyhqrOZa9Wmld4w8CGuorPv+FP9h50zfqjNK7mI5OLsAeTXfw3X
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(346002)(39840400004)(136003)(451199018)(38100700002)(83380400001)(86362001)(36756003)(44832011)(2906002)(8936002)(41300700001)(5660300002)(26005)(186003)(1076003)(6506007)(2616005)(6512007)(54906003)(4326008)(8676002)(316002)(66476007)(66946007)(478600001)(66556008)(966005)(70586007)(6486002)(6916009)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9e8smEYapJF+D+wT7XwHV3PFF25CkmMFU7VlrSGzV4R4SToOi+rZzwnFzhbZ?=
 =?us-ascii?Q?nkBDwamRxIGfZ1OW0c7wReby3TV0tH/eXg4snqFALfDdTOg1rVEQ5RCXV2Gv?=
 =?us-ascii?Q?SM1XTSuCnYCbk52rYnjMppxzPc1Ra4nEWDAosqaty55A4RoivOVKQxDinxUV?=
 =?us-ascii?Q?70xlNSugt3SoiQLrYF1BJq4o4wOgDh0BhEHyYa8t9zKb7AdIVswec+/0iARY?=
 =?us-ascii?Q?PkfIGh0YA2fNE7fdfVqwqVNeNvw7rf7AnMwYD7IvaGhUZ3ApNZ5Om6N0UPll?=
 =?us-ascii?Q?Ni3sNqxgzyqq3IzKWyxwKwz6tNPjDVd0iXy2DjNWSD5uda7Fh53Ni8xpdS/E?=
 =?us-ascii?Q?8EVyFI9j8IGRAaXWCQG1y1TIxOj0O5oqH3SLXIJi5Kex4Q55r+viAyVf22qG?=
 =?us-ascii?Q?LuvNUn4ewmxkxem6Ob7Inxsm8JhLF9scKHtgLtawMq40sqWogyWWbC5iQ2jn?=
 =?us-ascii?Q?bbnOPnSK8YgfU3MSJto82IOaewph7aSRTgJD+dsft5RdbtDKfsYdEm8OeIDf?=
 =?us-ascii?Q?vOc5wNIBgIdDOWw4qR1ajiFMuGdyPltrwKbJuSk0D5AM0nvlaGYzXdPuFB3J?=
 =?us-ascii?Q?+RIDnAmjWZEain8Sw3atgHdrmSmiSBqx6re69tuvdkJzJM/jafqDeB3LgLvr?=
 =?us-ascii?Q?4NHTU9FgAbfkxaEPbjALaCtKnhBynOIJ1BPVi2KmnmI7NfkjaXtBMtz4oFDf?=
 =?us-ascii?Q?+lL75BYcrdyIdgr38bzLuJB8j9egPZ6fNlctja3qQXPMqw5wa454YXLrVDpe?=
 =?us-ascii?Q?qXYQ87wJLgAOYUNhngQn2g7DI1Cd1w8NVwZVLmIGXSNz9B5Yx2aIy/VhrkWZ?=
 =?us-ascii?Q?nAK/8T+aIIz8hL5j2IdV2bRtOF/DTpxnapRtC40eEJ08YOUL8E21bTJvO+9V?=
 =?us-ascii?Q?KwrbeRVyhiDJEBmy7DSWGQDsnBUqEXyvEn7nPMQ+1iJt3t54I8R2hdROJDSG?=
 =?us-ascii?Q?HmESKuph52uzuWCa27DbTjtIVPSb5PRiNoJU/6jkcXr2/A22CnygdmnIy32z?=
 =?us-ascii?Q?V2PANCYuBjruQrtcr45FqI/4io1wtPW+fCjvMtAbfRbR77M58XxwFnnO0ZTG?=
 =?us-ascii?Q?Yn0EEIfxBcbYvripzyIHAmCyCFTdqxsMonq0CpgPRdHNTFOwOBpRoKmpqCnP?=
 =?us-ascii?Q?vkF/67BWje/qv+O2z7no8mqwZrhHwbgoDj7FgfOiSzhiG+dlQ2y3ByIWFWLp?=
 =?us-ascii?Q?VUqH+vtVMfHFbKwi8Cbr/SSgUIKpfxqUTr6RA+MSDNXdf3cg4gz2LLkmo/To?=
 =?us-ascii?Q?v3aPgClJkZHNY/dMwi/4rIkKdTbXpOwJJZ7HIYZqaSia7qwoArzsJL92Mfzw?=
 =?us-ascii?Q?rnOAxTnI9PKRxZrFskIdJya14i2e6y3goba1U6Me9Dj0C+TUrHx/dR4sDy6C?=
 =?us-ascii?Q?lvOYkLjTj7Ie/IXqm6QY+8TAVRsDVMpITHTc3mFfacsv0dJ67qVDaOqkeG9r?=
 =?us-ascii?Q?RfeGqiohGhyXxqvE2LzIByucGHe035FiU1CqYzOgPgRc2VIaGKwBNBi9iq2l?=
 =?us-ascii?Q?ZkM64I28AM8uLTIpnelUKWf0JAGRWSYuYfW/eexoeHJjso5JQ55IsQw56/mJ?=
 =?us-ascii?Q?GWYLOBcvalFLfP7rHpw6ZmY18WTTJqK4fcNCgukvb7lYU52t8Rlx/FLrLh+h?=
 =?us-ascii?Q?KQ=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: a49f0939-2360-4cbd-2623-08db15e28e90
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 21:11:40.2284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vK9iq+DH4uKOb2munWDDyqocKRyPAp9k/0N4dkMn1PmGEKCgwzef3xALIHep+aDZN/+nL0yh4OkDYeJ0Z/JvR7jsd/MetVammwMhhWXM0a4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0P189MB0660
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft userspace tool support broute meta statment proposed in [1].

[1]: https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230223202246.15640-1-sriram.yagnaraman@est.tech/

---
 include/linux/netfilter/nf_tables.h | 2 ++
 src/meta.c                          | 2 ++
 src/parser_bison.y                  | 2 ++
 src/scanner.l                       | 1 +
 4 files changed, 7 insertions(+)

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
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 824e5db8..e3440b2b 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -528,6 +528,7 @@ int nft_lex(void *, void *, void *);
 %token OIFGROUP			"oifgroup"
 %token CGROUP			"cgroup"
 %token TIME			"time"
+%token BROUTE 			"broute"
 
 %token CLASSID			"classid"
 %token NEXTHOP			"nexthop"
@@ -5122,6 +5123,7 @@ meta_key_unqualified	:	MARK		{ $$ = NFT_META_MARK; }
 			|       TIME		{ $$ = NFT_META_TIME_NS; }
 			|       DAY		{ $$ = NFT_META_TIME_DAY; }
 			|       HOUR		{ $$ = NFT_META_TIME_HOUR; }
+			|	BROUTE		{ $$ = NFT_META_BRI_BROUTE; }
 			;
 
 meta_stmt		:	META	meta_key	SET	stmt_expr	close_scope_meta
diff --git a/src/scanner.l b/src/scanner.l
index bc5b5b62..f1ffa053 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -721,6 +721,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "iifgroup"		{ return IIFGROUP; }
 "oifgroup"		{ return OIFGROUP; }
 "cgroup"		{ return CGROUP; }
+"broute"		{ return BROUTE; }
 
 <SCANSTATE_EXPR_RT>{
 	"nexthop"		{ return NEXTHOP; }
-- 
2.34.1

