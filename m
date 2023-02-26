Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 838B3C6FA8E
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Feb 2023 10:17:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjBZKRT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 26 Feb 2023 05:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBZKRS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Feb 2023 05:17:18 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2135.outbound.protection.outlook.com [40.107.249.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046AB5FC4
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Feb 2023 02:17:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kwr2eYIwOlypFRsrTO6+ksQqeKFH6lpb7gOVyE+M9OukIzuJuCHofnGtyW7NGucA85rAGj1JXFUeAWCcsY4xZKisgAvnW13kTPTHvPueWJNsJ4v7yM8lZSNDNli3Ey8qblT6Dr9QO1lKIXA03h79N/gSMd7vfbzsLmjS3nPtrTLt14jjDqXUWnwv7OYA6djPtl1pgh+TgRRtsi7xX5LappIkruUXvzVQPVjecg72G6Cc9e/AMkRMZesXEogrSIT0WXI0qXqFOcKmYA4UicVkdbg1Eo2Un2DuWpGsXDa7B8uZlHJLCGSVW/AcW1g36Rac+HOgBLY8GA3zygDhttr7lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fhEFCg8gIEdguGgg3h1kxbZ96KZH69mLRJEL81fAeEk=;
 b=HBd/xnHW8f4SOd6p80TAgtmoC1nkwJzaTdzylV0vLhCP0u3lUFiEMsUgfoTefOU0qzP+N3jtBjI7+QpJ72sh64o10nrVL3Mx+LSTHCFt8rHO6zn421yWGwlaOdMdAQApsEMA5+Ay85PHbRfr8jFtlk8qfFfuvjwoT3cOqookyeuogpxIi4TSYI4A04iCJGq3gTpC0awKQFxPwdrRXtkgmS+AsrUyvDToL/ALFMeocH+vaepqsFInFWv5fxS0AUEvugOgUNuP0i+7LVcLV7AfHR84gaQIrryknSziQ3NzsfwEvNftxkMvCn7edD9fGvrLqRkfx3Q1THhFt454you45g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fhEFCg8gIEdguGgg3h1kxbZ96KZH69mLRJEL81fAeEk=;
 b=DiwYRbh9e2fMagcOz+DvvoyKGX6OFX8mohukFJ78S3OQqnwcnidjLma3nDOoJgtHbSqjoXoG+C414+Qf8sQmryEmsQgk2636Pr21M+A1MEuyJ2WpV0bpOHHpWu2cq4N6vZU26a/geelNucAYHoU4siNfA9SKMf94EaCZ0xmqjTs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by AM7P189MB0791.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:11d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.26; Sun, 26 Feb
 2023 10:17:15 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::13ad:a312:15c6:91dc]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::13ad:a312:15c6:91dc%9]) with mapi id 15.20.6134.026; Sun, 26 Feb 2023
 10:17:15 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [PATCH libnftnl] expr: meta: introduce broute meta expression
Date:   Sun, 26 Feb 2023 10:53:08 +0100
Message-Id: <20230226095308.12940-1-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GVYP280CA0004.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:fa::6) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|AM7P189MB0791:EE_
X-MS-Office365-Filtering-Correlation-Id: a349e570-ca5f-4460-b3df-08db17e2a1dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZXIFNlS8m4UOiROJbf4MisUwBkZdG7i9A+EHozIjDZ+xJ6PTHNywGgLxeuAsHY77MsNmPQ2KdovGnB1xgUBPyRbiFltn+9adAau6JCtXdg6Z2PiBw+Tqwbdp/MOHu7YLKFLciEN6bSxqvr7HDqr7FK+8MMxVeQgiZT3qC0LY4hk7Ih7lKmdhZTfnoUx2G2gWhvr63MWGagSDiE5mb60NtbEK/UjnGKFOlT0T752EehYLGhB6MaoRd2VWguAlsnDkgXsloDr8Wluqz8ptVsQagtVPrWNhSePzPTBkQ8QHPXO5qofNkCx7Z/z0OvzanmaeHUzPDQkbl1nnzyrEG11i77vOkHqAL0eu4to54zfIGPqcC4Zkl5BElt/7Jztxk/nVR3yYnnNRMiNCG5dXDIGjwbnobYdACSQ/kSaiKGffRnxLQmGx5AqIqoFZ3IRTrz7A9EhHm/x1GOqpH1xP3ZPjoAM6R/4z62WZjDXDOuRonduOCBR+X4jQvmoJAca7QgLVKSyd9cE9naOGmzh/OrfIUoFpLiD6Ei8zM9QID/rUkh4FKAyLtnjhTGOFTdd39WmuV0AnL435//H0VzgKZxMfGGPGMkR3ckGeYfjG+plzlrVnVwVDswdSizk8aNFWtF2XFfmSeVDt4IWas17y3H+4gDBQwsaxZ+w4TpazOKHhoKxXN0Bqpf0jM7NjcUkQWmZI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(346002)(39830400003)(136003)(396003)(376002)(451199018)(6486002)(966005)(316002)(83380400001)(36756003)(86362001)(54906003)(2906002)(44832011)(5660300002)(66946007)(66556008)(66476007)(4326008)(8936002)(6916009)(8676002)(70586007)(41300700001)(6512007)(1076003)(6506007)(478600001)(2616005)(6666004)(186003)(26005)(38100700002)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Wfr20CyKm6LziB/1di9Bhnw/7stDQeh3KyRTSlK1pfD6sQZwTPTMgCCdCd/Q?=
 =?us-ascii?Q?QoXqpLFqS6iepITmfYRw4IRxaLQeRpIseRN0H3i7gU5CWqWVUHStYNrUwWGU?=
 =?us-ascii?Q?D2IoaYDyCIDamGgGGQ68XBnGucgdsOlXjVCT2wKG/bdysM1N/M6Ic2LHTHVh?=
 =?us-ascii?Q?W2Jv3b9FSYfIPt5TqthlPLw7dNuMHvkFJ00KKZq9LsT+NRqr70t+HtvaUaqs?=
 =?us-ascii?Q?yFHOi7GVQatS8rQX/0t97gzzmZxmjr+KvXymDt7Eq968/8dcxxCBb3rSjQLF?=
 =?us-ascii?Q?WWWolwJc5Y/ikDzkMfTTwflDquTD2j5U5tlKk9NQr7HBvnExomKT1dj6oTZ0?=
 =?us-ascii?Q?M+1WjRwn4NxF2rKMdeEu5HQKNReYh6rG3zoo39okd3rF87mRB9xtdjVZNvcy?=
 =?us-ascii?Q?X1d8GErl7oHcosxLYi/Hkt4oaz7SZIjWD22kDj/tiaIth42XiguBGn2IrKJO?=
 =?us-ascii?Q?fEyrHSgJRbyuL6DDiIbybO+DQwpmn3sz87P1seyhwBjiP8oqtv/nCtFQU7oV?=
 =?us-ascii?Q?bGmsgXQSV0aPTLSN/Gmqxs3j+zAtYDRdiUEU/j0/GYy9Pl9lP/6YblB69j+E?=
 =?us-ascii?Q?F2MSy1SMhqLMMJ5TfYZj5tT0rGHdJ7m+YUi414bI6/rabxRD7uklQ+kx5q5B?=
 =?us-ascii?Q?aRqtQ49qem8S3r5asmCUytPVEDYvq3oEqQ5wKGz/OJykLj3gEXvfLdL81PFq?=
 =?us-ascii?Q?5+IqYulz0ZvNvtOxoeli4XiU8ooiGgq7gI/qYMFUxUcWoXA8SXBYV3IOAneG?=
 =?us-ascii?Q?wXDJwcCZVvIJVT0wGePE81HNFkRJHI+306UocJzLa2vFpW0S/5aiAJlNjxSE?=
 =?us-ascii?Q?QvKgs52JOgfimA6tmEyjvtqp0wGKOx2Y/da0veTnMxymgoets1ZoPa1aGawo?=
 =?us-ascii?Q?jzV41hhmSSjBy+Z+xhIUEcdlHBvcmW5M+7xVI/K9cfL3oPdo70CyhRopn1S+?=
 =?us-ascii?Q?u1XVhdNLoUchAJCzTucI+rjgN0sQg1hZQfZEr3Hss7vfpTjBTsqcUnyU0uOJ?=
 =?us-ascii?Q?s3ARecyyspi0/yLpIRceCFrsKOwe6vWlXIIHvDkjreVWBj+K+Or4GbH+hFfW?=
 =?us-ascii?Q?QbRd5w3Lv7uFG8z0U35xh0y0aeGFL8Wz/1wTR/74PnwB71srRhPzm8OyNvqZ?=
 =?us-ascii?Q?UM1mXw884U1ZL/7yI0rsCFXjpZ6QqGDOKyJgDkDmykOrrP10j5t1yKrFg515?=
 =?us-ascii?Q?7MgZmrivbx0kYKelqqRhS75j7+zACgHYuk3rwT7NPurEAn1J/oJHkZJpCy6m?=
 =?us-ascii?Q?OkzQDT5YvUIM8y/2jbI/NQtoX4STKqcQXgopXq+9ejnTLvWwT6h8tBCeyNl3?=
 =?us-ascii?Q?DkizBrNQw6z+g4c2680ZwBGpKf97lV7lv9GNrLGMO32yKlVLkS3llSzoE5Kb?=
 =?us-ascii?Q?msij4IR1gOIL95vWRud3RDIX7jLhdzzoaIJoxvN5tddzLfJCaYAtUQVWhQJB?=
 =?us-ascii?Q?rIlHXzS6VjSEjdpozt9ygO9vsJCw/kWUr7Ia0EXUuJ6tZIfU3/3oMCDD8OeQ?=
 =?us-ascii?Q?HzB8LCmXUXoCphhh/a8vbdFuOb2z3sTrljuMwBGttY4TYIKTFU24YrQNJiMc?=
 =?us-ascii?Q?sWQ/evgi2tzUTYwSQb5hrvMeTEZSbu6nRQCG1+EqIrE4lpQbNEaeXRq0EfS1?=
 =?us-ascii?Q?UA=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: a349e570-ca5f-4460-b3df-08db17e2a1dd
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2023 10:17:15.0015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZinmF1o+1b1qNCmquSYUUgpOooWmt38FYhlsTzwhMhz2ipzxLlP02fjI8eTUHoTlUkJcS/yEP+Hpytdtzhy5i4PcI3t/NgPuN0yzQJVCxLs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7P189MB0791
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

libnftnl support for broute meta statement introduced in [1].
[1]: https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230224095251.11249-1-sriram.yagnaraman@est.tech/

Signed-off-by: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
---
 include/linux/netfilter/nf_tables.h | 2 ++
 src/expr/meta.c                     | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 4608646..c48b193 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -914,6 +914,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_TIME_HOUR: hour of day (in seconds)
  * @NFT_META_SDIF: slave device interface index
  * @NFT_META_SDIFNAME: slave device interface name
+ * @NFT_META_BRI_BROUTE: packet br_netfilter_broute bit
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -952,6 +953,7 @@ enum nft_meta_keys {
 	NFT_META_TIME_HOUR,
 	NFT_META_SDIF,
 	NFT_META_SDIFNAME,
+	NFT_META_BRI_BROUTE,
 	__NFT_META_IIFTYPE,
 };
 
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 96544a4..183f441 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -22,7 +22,7 @@
 #include <libnftnl/rule.h>
 
 #ifndef NFT_META_MAX
-#define NFT_META_MAX (NFT_META_SDIFNAME + 1)
+#define NFT_META_MAX (NFT_META_BRI_BROUTE + 1)
 #endif
 
 struct nftnl_expr_meta {
@@ -168,6 +168,7 @@ static const char *meta_key2str_array[NFT_META_MAX] = {
 	[NFT_META_TIME_HOUR]	= "hour",
 	[NFT_META_SDIF]		= "sdif",
 	[NFT_META_SDIFNAME]	= "sdifname",
+	[NFT_META_BRI_BROUTE]	= "broute",
 };
 
 static const char *meta_key2str(uint8_t key)
-- 
2.34.1

