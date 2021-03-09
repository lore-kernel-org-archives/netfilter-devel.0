Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E2B4C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 15:10:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0EB565272
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 15:10:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbhCIPKU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Mar 2021 10:10:20 -0500
Received: from mail-eopbgr80129.outbound.protection.outlook.com ([40.107.8.129]:52223
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231785AbhCIPJu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Mar 2021 10:09:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TePCaO1Q+ukwA0ljfDjyEub1y0UuR4C/dRT2KL2JXVHEOGaIPWXYHnfR5QkreoWV7bYdwKto1v9f24QRKTeZ4BSIGtNs/Td7P0nRlVkxRfU35l0vvAvNIwg1C8E2Po/QBTWJZd5KXHGTdJF7BXHgx3ACLNrU+In7kp0xMfqHE3rWAXTLCONc60qNZ3UwXwLz+C/+E21DCLDRdCDiQDwKMAENTAzO7Wl8jbbayzm+dQ9ztCkDi0gEGnXJCpFurd2+d7ZJcALKZ+/+23Lbdetwt8Aw2+xKkZblJaPbMF82jxQod+x9JLHrxAkYU0glz+uFDkD7vlnvdYGhTRlJtMMKyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZBNmX0TBMQkN+Iw4nQ0/aIxFIRN8Mzf0iWrqCP6cp44=;
 b=UeRsPOIbHVmvXONZiJZZolNccuqYXnEvvt2+H23YwW2HcjeVvNbhXZ3X2v+Io+LMtBUzFrvBlJ2ddFwWwiJwSTToravUMwZYX6JxUKOjJIeKPz4N7IBGRhOkUaeiuxTNcd026x7DLCHsFon7phiqa6e4knErgdv6x/kveAuDWeDumRpS707QaFkNRH1hpau49bLvo8+/H6EYz34DjWDalwVyq5l2EH0wAWPAjRvHbJNLeAoEl3w9t5/E6Zi8K57jXoQ7wmjofykGXAmzH/hZdo7+65nCofR3UYAcB1GbsoqwUtEgBUUg4UsZ3LldQEq1aqj07pLghBegJhawAX9z9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZBNmX0TBMQkN+Iw4nQ0/aIxFIRN8Mzf0iWrqCP6cp44=;
 b=euV1s9RLsrK73Ro/7EpOwTVOj2/3wFrT0P3LKqjEiiNt08RbgGP00I389rhaioFoEXQtpzZv6MH9cmeWMg3GS0OtGpxffri47MMVfCoA8PFhCcFK81vpjZ+tTPgQmBLexlSLwHDXyORRZ9B+C1cNfu7g70fgBgYAiwao+ZlBAhk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from VE1PR08MB4989.eurprd08.prod.outlook.com (2603:10a6:803:114::19)
 by VI1PR0801MB1631.eurprd08.prod.outlook.com (2603:10a6:800:5c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Tue, 9 Mar
 2021 15:09:47 +0000
Received: from VE1PR08MB4989.eurprd08.prod.outlook.com
 ([fe80::d1ec:aee1:885c:ad1a]) by VE1PR08MB4989.eurprd08.prod.outlook.com
 ([fe80::d1ec:aee1:885c:ad1a%5]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 15:09:47 +0000
From:   Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To:     netfilter-devel@vger.kernel.org
Cc:     "Signed-off-by : Florian Westphal" <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Subject: [PATCH nft] nftables: xt: fix misprint in nft_xt_compatible_revision
Date:   Tue,  9 Mar 2021 18:09:15 +0300
Message-Id: <20210309150915.8575-1-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.29.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [81.200.17.122]
X-ClientProxiedBy: AM0PR02CA0202.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::9) To VE1PR08MB4989.eurprd08.prod.outlook.com
 (2603:10a6:803:114::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (81.200.17.122) by AM0PR02CA0202.eurprd02.prod.outlook.com (2603:10a6:20b:28f::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 15:09:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36e7d1ab-10dd-42ec-6af4-08d8e30d6059
X-MS-TrafficTypeDiagnostic: VI1PR0801MB1631:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0801MB1631512321814C26D3620E48B7929@VI1PR0801MB1631.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GrYf2f5/USGpKnYN1yc0MdlQpquCFPs0nsDhSyM0rE4MD1qUcHnlYDJhle1X3K0sOmQjC207NPYsixeTnQHUo8+rZtLA90oo4oo/HpVaqk6YASpQI7ANDqtyAfUuQtsKWJSWp4R5elmI6UIv7MvID6eA4eMWwL+YxU9OGaIBXW2kPaDWwpdJnCdff7Jq1LnVAUA/1DrP0XMF3DG3LcF2Ci64RRkExr2+WtuaMOmne+euRYKCIu8PvHNLGNREJpsZOotnXUvK7wzvRxZISZS/7akNC8UusvfybkVt0iMlhj24F8TQc635YTVMpiLxnLAHb9y1zfsRa5wOAg0ZrMwrC9cFOMZWNJlZLefcrXZuLlJsrwsSMwpiHVGLZsfbOJiYfuVyYbgaLW+4V2H85VjwwpqsRrF25iQnpMXuvWZSoz1zSe0V0dvU5yal4dehZTJghfw4E3+2OSRik3Jrm/NKF9EmUlCxZyWd+GvwhZASFp2alDFvYrjp9Yj9WB++12tvEaaU+N6CLeTUqafJVzAJTq3NEwkzJXJLekVj5DS/RAREEnh5Bkoyg+W2ZluLtRZogPr78D6NR1vSk/j373BGFEWOeUJtUjLEs3EinTTzCODZ2hlUF1yj2al3xR7FS0bBGDAwyJTyvWlxQnFKqXA4fw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR08MB4989.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(136003)(346002)(39850400004)(186003)(69590400012)(6486002)(2906002)(26005)(2616005)(956004)(16526019)(52116002)(966005)(107886003)(36756003)(478600001)(6506007)(54906003)(6916009)(4326008)(6666004)(66556008)(66476007)(66946007)(5660300002)(1076003)(83380400001)(6512007)(8936002)(86362001)(8676002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?eRXQg1bi37yRWfAAMtrTatszRkBMo9xi0ccYLKiLlnfa96U98nwk1JJaWRpd?=
 =?us-ascii?Q?5PJxdTL4gzP4DPPBpsOf/rZQbJ4HyBGgSAOFAVt2SMXdYNIa+5fmawmVZO6z?=
 =?us-ascii?Q?LnWya5peQKhfZQReanMnYBFSI7T+9stG+xNkTx9W0MAkTqzgF78A4mtkFVVC?=
 =?us-ascii?Q?wwhNsc+N9ojYS4NpFH7Q6ODK+HXQ0yK3B/miFi1uIkah/xI2hXUR24aJ9iHq?=
 =?us-ascii?Q?9ofzIQRnc+eKVMQMi3i6hdXb/9ulc3QaA9Marf/Y32l/eUn9WxK9hb0dSa8P?=
 =?us-ascii?Q?A+XpgdexoIdbulp98eEZ9MZAZ2qWzmWq6kjitX10MGzjSBdMSJfFZvbF806t?=
 =?us-ascii?Q?GEdJVuTd9/XS6UzUjRY5jZobyn8wM7PD3BOgnCVml6mPc9+uCDwXZE+XoPgv?=
 =?us-ascii?Q?ltot2s59J/IIPrcW6AoOLpIlhO/b4vm3+1y9/HDbfyTSDL4l8mGyTWqtqAMr?=
 =?us-ascii?Q?B96+LxIO0kjKOm/7+acVkzeYQOj4hGJC63H/NFM5i74bm1CZBypyqFTpd3ZD?=
 =?us-ascii?Q?7ASilxQNqY4r6pylKq+tbUQx+Da3/PypxZxJRJfdI6qRnEg2jQG4z/YaBwoS?=
 =?us-ascii?Q?E8jMSu5sCMXhOcXTgIVBKyf60s/sS+8iJIB16f/6vnhl/OGRyqSLx8Vk9C27?=
 =?us-ascii?Q?taoh/erh8WeC2t2HlI8Uaj+VGT31lBeLPj1XDatxWmmSH7s9HEIw+GATvL0b?=
 =?us-ascii?Q?1lE/eFp9YJ6+P6TMVoxgmHPMqCpJNyGODDbZOCQbYSkhq9+fmnkNntrySde1?=
 =?us-ascii?Q?pPduYg2w75z0GbFR49rd10CRV83bsaF8GFSvd2Alo+seM1Rxuwe+rFAN+hFk?=
 =?us-ascii?Q?kF/kjH9fIrc4HixwtCGrsFZgmSrvfD8PQYO6MdANGPgTbDbljUJkMUMU6X2S?=
 =?us-ascii?Q?GIkkStF3a6PjwQZ440dTJAEqipkHr9bceZBaworQQmN4mmMFZZw9Kw1byiJK?=
 =?us-ascii?Q?OX0yIxolr7WwYJ1lmcox2Ur/XLutC91pwGPdUlyjjZQMsJZUPtI63A5A267f?=
 =?us-ascii?Q?BzZq+sMZJTaf0R3/tLVZo4IeCT5YIBWSoaYvLgVZof2si5R03eVBR0VlOdoy?=
 =?us-ascii?Q?YM5UhA9d5aNUNp89ZzRMCC1MT35lqZLcvwgPDq9IN/aaRnwZP7CDPEYkYK6q?=
 =?us-ascii?Q?R6Vyhj1iiYZr3Ix7FBDKhZNPDb8LGD3Xr9lhQV7n3m0UUaknWHBQUDWkzZ8p?=
 =?us-ascii?Q?pNRAvnWjrY8FxYMqewxxeLA1QgET15vYkkV8APEtdr19Jo7uEEDeaDbA1PPA?=
 =?us-ascii?Q?fWmeefGP8iWZJHcl7zzi3303vhDbDsNTdUnIxI/AOrjpYgvomBhpzzIJ/rYX?=
 =?us-ascii?Q?dYflqmX9vgDfdsRozfptwai8?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36e7d1ab-10dd-42ec-6af4-08d8e30d6059
X-MS-Exchange-CrossTenant-AuthSource: VE1PR08MB4989.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 15:09:47.3502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Mwf27niPXDh+Wp4SgIhpeWF/Qfq4MPzSH4DEiX8ebRXZ0BVc6P7g+X4EvlmoAaA00eJuRncYIRSsmlCPVLVQJKVNWtu/U7grEl9wrgXJIw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0801MB1631
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The rev variable is used here instead of opt obviously by mistake.
Please see iptables:nft_compatible_revision() for an example how it
should be.

This breaks revision compatibility checks completely when reading
compat-target rules from nft utility. That's why nftables can't work on
"old" kernels which don't support new revisons. That's a problem for
containers.

E.g.: 0 and 1 is supported but not 2:
https://git.sw.ru/projects/VZS/repos/vzkernel/browse/net/netfilter/xt_nat.c#111

Reproduce of the problem on Virtuozzo 7 kernel
3.10.0-1160.11.1.vz7.172.18 in centos 8 container:

  iptables-nft -t nat -N TEST
  iptables-nft -t nat -A TEST -j DNAT --to-destination 172.19.0.2
  nft list ruleset > nft.ruleset
  nft -f - < nft.ruleset
  #/dev/stdin:19:67-81: Error: Range has zero or negative size
  #		meta l4proto tcp tcp dport 81 counter packets 0 bytes 0 dnat to 3.0.0.0-0.0.0.0
  #		                                                                ^^^^^^^^^^^^^^^

  nft -v
  #nftables v0.9.3 (Topsy)
  iptables-nft -v
  #iptables v1.8.7 (nf_tables)

Kernel returns ip range in rev 0 format:

  crash> p *((struct nf_nat_ipv4_multi_range_compat *) 0xffff8ca2fabb3068)
  $5 = {
    rangesize = 1,
    range = {{
        flags = 3,
        min_ip = 33559468,
        max_ip = 33559468,

But nft reads this as rev 2 format (nf_nat_range2) which does not have
rangesize, and thus flugs 3 is treated as ip 3.0.0.0, which is wrong and
can't be restored later.

(Should probably be the same on Centos 7 kernel 3.10.0-1160.11.1)

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
---
 src/xt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/xt.c b/src/xt.c
index f39acf30..789de992 100644
--- a/src/xt.c
+++ b/src/xt.c
@@ -321,7 +321,7 @@ static int nft_xt_compatible_revision(const char *name, uint8_t rev, int opt)
 	struct nfgenmsg *nfg;
 	int ret = 0;
 
-	switch (rev) {
+	switch (opt) {
 	case IPT_SO_GET_REVISION_MATCH:
 		family = NFPROTO_IPV4;
 		type = 0;
-- 
2.29.2

