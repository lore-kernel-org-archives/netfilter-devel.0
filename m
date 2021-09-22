Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8855C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Sep 2021 14:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EF656115A
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Sep 2021 14:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235014AbhIVOen (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Sep 2021 10:34:43 -0400
Received: from esa5.fujitsucc.c3s2.iphmx.com ([68.232.159.76]:32983 "EHLO
        esa5.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233176AbhIVOem (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Sep 2021 10:34:42 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Sep 2021 10:34:42 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1632321193; x=1663857193;
  h=from:to:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=d/RriK/Ejfm3DH8/3Q1mmkTa+mWsnzBa2nRvU+8avH0=;
  b=Xu+JC2g/nmXJgkFkhvgnEFkaVlNlseMa+HD7DqcRmRMcn/QLkQe3cmiO
   fA2y2iCzYnsSeUTqD6guPtbRGQKyQJ7Cxhs3dq8EyTI34uHMIfQfgFwwu
   V/+fzZRzbCJ2rI2AsqDkCz2JCsluywJYbUMcYmPJV3+lAUnCGk6zf0dXe
   8MqD6ClPCleD4cgZmP+ofQW3Ho+U2orIys+1m+osy1nsk7MYsuXLMm5Wz
   dm80PtO87Gz3g9JuMQ0KNaA2XBBVwq/Fqg5aaejD5r+Gu8w9QhHdMRB2F
   lqbj0iYnWO93lpkwF75Khgd1agzeQxUC7Oz1HC5SPijZbJU0avDP/mWuw
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="39729461"
X-IronPort-AV: E=Sophos;i="5.85,314,1624287600"; 
   d="scan'208";a="39729461"
Received: from mail-os2jpn01lp2059.outbound.protection.outlook.com (HELO JPN01-OS2-obe.outbound.protection.outlook.com) ([104.47.92.59])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 23:26:04 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q8Z8dhZ/VkbsjJ9dH01ciWlhryuCE0CBj3AystZkG93cF2OJgi3aXuwn6WsZX2D3mkZWUlIdK7yMjojCTCdp5JyW7jMTiVg2rVGd8EhOCYgMDAqtK2h5ts2mBiCUuH9MU1QRD48KH4I44yXmoUQxXNZivMxBo52YNcd/ZkBqkseiYcYV2xXT9x2YmJKdXyQO2kn4VkcdfcgwbaVgcu/TtOsxC5F1dxQNLJiF10/EBjm67oDMukQh/baLPdWSc5QP9+OsOCrw5b2a8frLq82fx/reYg6L4HgvDQPrYr5VYegBDczzIDC7sxNUrPTVu04sSgrYrs+JnFG7tZYXu0Oy6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=6sJEQNgfsufj2ZR8wPhoaYac2mc7ynbZGlsFjR4gaTM=;
 b=ACVFGp6apJU6ROIeOwxyLCFfKOr1htgv5WEUexg31uhGKCbFB5bo1QKwesqoQXFHFtKCKx1EcUArf4b2xcxK9yro9+CgMs3h1C4hGFgDsejSdeg0eIGXhziPjdAQbFi9dpeB33rCZnVCuy05cQINlb9HA3bf2Y5Gl9hUPpcxNz0LAFoPEfFcTv3DjgW/fvloBNNwl3GNXwSzFE+zRUo6NbR6zBDxD9W9h64g3F6+IDyvmVX7sii3ntmkdvHStHlhPiIE3WFCb1zqEy1C20OUirU+fg3gwou1ya03zSrlTkizn+g69NZKvVTy8Xv6gZOwaZsNQDXs5jqLmAfIvNv2RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6sJEQNgfsufj2ZR8wPhoaYac2mc7ynbZGlsFjR4gaTM=;
 b=FhGFXIHq+5JGQSDroguPbZ5WC4WicjkSvbPX6twbmSbVPRhsbNgIMAyqh+nyoiAgah4Mtm4DxlHSsiPWfQJqN4lGX+xrToepjcxIFMIkHTbRutYrqTu2rTgcUEvLOegUsyDkQX0UJ44ZkiYOq6O2t8TvywYVmYfnMV62hyxIWuM=
Received: from TYAPR01MB4160.jpnprd01.prod.outlook.com (2603:1096:404:c9::13)
 by TYAPR01MB6252.jpnprd01.prod.outlook.com (2603:1096:402:3f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.18; Wed, 22 Sep
 2021 14:26:00 +0000
Received: from TYAPR01MB4160.jpnprd01.prod.outlook.com
 ([fe80::510a:d079:9d49:1822]) by TYAPR01MB4160.jpnprd01.prod.outlook.com
 ([fe80::510a:d079:9d49:1822%6]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 14:26:00 +0000
From:   "mizuta.takeshi@fujitsu.com" <mizuta.takeshi@fujitsu.com>
To:     "'netfilter-devel@vger.kernel.org'" <netfilter-devel@vger.kernel.org>
Subject: [PATCH iptables] xtables-translate: add missing argument and option
 to usage
Thread-Topic: [PATCH iptables] xtables-translate: add missing argument and
 option to usage
Thread-Index: AdevubTwl1yUoLx3TH2tSE5VfdWMaw==
Date:   Wed, 22 Sep 2021 14:26:00 +0000
Message-ID: <TYAPR01MB4160D345C99412EED8FFF1C38EA29@TYAPR01MB4160.jpnprd01.prod.outlook.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=true;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2021-09-22T13:56:32Z;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED?;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ActionId=603329f3-e87e-4f1f-b058-3972f3084ad0;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=0
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: df715494-076a-43f2-466c-08d97dd4e6cb
x-ms-traffictypediagnostic: TYAPR01MB6252:
x-microsoft-antispam-prvs: <TYAPR01MB6252466B32800D7C117B6B0E8EA29@TYAPR01MB6252.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:265;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tuniQWBCykk4lcq412YO5lbm5SrFQ2Bjr1gRK5f7zszmt0FfbPs3NQKE6FuwSz1euD3FZm7QS/sDOr7nhv5aUChyuzVRtiCeQwsD+y2QNBgi1qmBk1IZlFt2LXc3/RxLn6+V4yHIzcKJpApAyTUXqtchKq9vi7iAEINBSg+jHdSUUqWS7N34h9S8RJCrwdOxpwo6sPCKEmliVpYYI84iNJkfEmkG7SiRayqkN473ZtElMYPn6jc7jpBN/OsvPrDjod5KOWqI8LnCmAeVeTrp+kqc9NoYHsTkY8JO+6wPE5OzMzjx4AR9EQjggp8dlOvOdaW4Kun7JbwJ3xeIxYqMl0pCVrdU2CNLWC0bG/RK1aQWIrn5nGZoNGvfuAAd9aMxH+8UlcfsF3flpiVhSxNrlOt+7cnQ57QQgoodffslXGZ1jwZTxKjUUR8R5fv3fN1yvGrkNU4ghB5b+lKgCmMHD7Q5A3la0ig5XA0uGPkSOiBi6VRXQpmNwY97JQQ3CcY4bT0RKQzUJM1RQE2yvuQy1F6VJG81JWhPTKmFnCP8Q9eahXoGQ0WyqBeh6cdZFMp3OAcDfUKTC4GjgsqRvIJ5FbL/cWfQNkj5KU7/HFmRGEjwtaaXr9cHwQkbnkXJx+M8PHYmTrHe45v/yJlOSFF479OKjV6MHrETrXuaRCPDdpa7r5MjiGch1E1MK7jlYefVGzIEhfte08b1n9l2U1nHuPQJYvnZlrCLdXUatEmMpjE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYAPR01MB4160.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(64756008)(66476007)(66446008)(66556008)(9686003)(122000001)(6506007)(26005)(8936002)(66946007)(186003)(86362001)(38100700002)(55016002)(76116006)(8676002)(38070700005)(83380400001)(6916009)(7696005)(508600001)(4744005)(71200400001)(2906002)(5660300002)(85182001)(33656002)(316002)(52536014)(491001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-2022-jp?B?Q3V4UnpxR1pNcFk1ME9YNVhWbXJQd3RWdC9Lc1hFenFxaUxPaFFOVHFO?=
 =?iso-2022-jp?B?S0hzRGRDQ1ZiZjJXQUdYczRrbWFLQjcwdnJxd0ZTWWxmK1BBT2lVRXBz?=
 =?iso-2022-jp?B?NG5WbG1NbUFMWWJzVXV6ZmgwN2JsRUdvZHEzd21lbjkzR0o4dUJHZldZ?=
 =?iso-2022-jp?B?RnpCR2NoRHdsWUE5TkxQQXRuSHFJZkpFNmtIOUxOcG11bHhzVjRTYnB3?=
 =?iso-2022-jp?B?VW5XYStzTTBiVTNLYUQvTWZsSEh0UXkxa3k5c1hSZ2Y0NitiTUhpOVRk?=
 =?iso-2022-jp?B?NWRNUlFtWHF5bmRhSU9BZWd5RnpBQkpFYmtVTldOcmJZNFZXUzBKTGts?=
 =?iso-2022-jp?B?NUc2S25QeEVFUUh0aUd4OEFuc1djbVo1OTFrNUlBdHkrYUk2OTNtQUEv?=
 =?iso-2022-jp?B?VlhwRk51bXNSVFpLa3dPNkZEaDdxY0R4dXhiOXhxL1lwYllIa3JEdnNh?=
 =?iso-2022-jp?B?Q3BManhBZVhUUnU0TEhOeTFCeWNtekI4TmpUQnU0OENCL3NTeU9ZT3Zs?=
 =?iso-2022-jp?B?NEpEU0lKdURRZTM4LzZTSHRUdDZBeG5rKy80WkJILzRFRGJtYW56bjM1?=
 =?iso-2022-jp?B?UTVJQWd5NXc4a0RYdjlUZE1vaEZucFdxZEZpWnBCOENPZExIZjdtTHo4?=
 =?iso-2022-jp?B?UVR4M2JQaldSZVZzZ1U3V04rU0wvYlNJVHdxYXRJekNKSFJPQ2lpc0N1?=
 =?iso-2022-jp?B?OGFsYzhrcVhMWG9nWGFuUTZBVGdiaDgrV1pmZ0cveDdlKzVUWElxNFdp?=
 =?iso-2022-jp?B?VU9uWDY4dmhWZ3V0cU53M3NDandDS1ZpNjhEK2hlbndmSjlIS0s1WHFJ?=
 =?iso-2022-jp?B?cTN3ZkVBdUFzWXJBRytiZ3RnWEtRa2dqT3dWbkNjbXF2MDhXeE9YR0tU?=
 =?iso-2022-jp?B?UWhmNjJzVkpCclN3QlZOTEFNVDZhaVNuUlQwYWx1Z2V3YWNZcXdyaDU5?=
 =?iso-2022-jp?B?aXJRc01oU3gxc3plQmpGTTRRMkUvbVUzUUlxRlJ3OHVRc0VoTktuMHRu?=
 =?iso-2022-jp?B?NGxEK05nL205M0dua3RobmltNUxkUzlVc2kyN09OQ2V5STU1a0tkZzBH?=
 =?iso-2022-jp?B?djZwVGNqMEFZdnpFdzFsTFlyTlM4Sm50cEY2bVFiR2lTMmdCNUVCbDB0?=
 =?iso-2022-jp?B?Y2pUWHFXbnBreDRQMUFZYUNmdEE1QjFoZGZlUy9jSjMvaVV0Vm0veWs1?=
 =?iso-2022-jp?B?ZW5JamZMZm1VU21mUXJZMGcyYWpuS0crV0g3M0p4RXo1blBqZS9LakZG?=
 =?iso-2022-jp?B?RFU1UW1UZXpiL2hkN2JDSVhxWmovbnR4MUt1SS8rS2JpTTA5bmpiY1Q3?=
 =?iso-2022-jp?B?TU9QblJ4RWk2emJhWHptejB6bjB4SS9XN1VvV09aTStrL1pxUXlDeGU5?=
 =?iso-2022-jp?B?YVpCWnpiUW1YSEwrRDdJOU1RRGsveUZ4NUF4UjZESHR5M0RXRzJwY2Z1?=
 =?iso-2022-jp?B?M3E2NU1xMUpSV2R3ZlFWSVhBeVFhUktmcmo1OGY5TzdWNnEzZFA0K1BR?=
 =?iso-2022-jp?B?Y2FKLzFRbEw4Z2w1bzlZcWVxeG9DV25sTlhlTzBrR1ZyTHpyZ3Rhaytz?=
 =?iso-2022-jp?B?aGVwdFFGSTlES2NYaXBvZ25IVTljMEZkc1dwRjVmZWlrT1dTVWtBcWxo?=
 =?iso-2022-jp?B?NDlaWGNiMnRJWHk1NmJ6NjlOMFY2eXE3ZS9xbW1lcnVQV2FCSGRGamg5?=
 =?iso-2022-jp?B?YTFFNDZER3MvcXhMODE3RUxnUW1hT3hrcjVJc2o3SzRXdUlyaWx0M1ZY?=
 =?iso-2022-jp?B?bnBwd3RicTlTUlVyMzhlT0xMTm1SOE5GOGRtRzR0UDNLb0tMdnd5SzBP?=
 =?iso-2022-jp?B?THlaQ0NvUC9TNFlNemhJRlVFWjA0WGdXMzJZcERWa1IyU2ZCMXFYdmhO?=
 =?iso-2022-jp?B?NE4vT0ErazdhTzNvQVZWOGF3bGJQYWJYZkg0RU5WNUwwRmxCall1aWw4?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYAPR01MB4160.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df715494-076a-43f2-466c-08d97dd4e6cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 14:26:00.7396
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /RkqBynDMacDV5UHTn6TkWADHS9Qpfpug0oHrIEs8CyoB9x2x0i/JdbPMFreFCV9DjXhr0gcfrnzwo9mzOKXstJqbGLaLYST6o3RHU7v44g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB6252
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In xtables-translate usage, the argument <FILE> for the -f option and
the -V|--version option are missing, so added them.

Signed-off-by: MIZUTA Takeshi <mizuta.takeshi@fujitsu.com>
---
 iptables/xtables-translate.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 49f44b6f..2a00a850 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -354,9 +354,10 @@ static void print_usage(const char *name, const char *=
version)
 {
 	fprintf(stderr, "%s %s "
 			"(c) 2014 by Pablo Neira Ayuso <pablo@netfilter.org>\n"
-			"Usage: %s [-h] [-f]\n"
+			"Usage: %s [-h] [-f <FILE>] [-V]\n"
                         "	[ --help ]\n"
-                        "	[ --file=3D<FILE> ]\n", name, version, name);
+                        "	[ --file=3D<FILE> ]\n"
+                        "	[ --version ]\n", name, version, name);
         exit(1);
 }
=20
--=20
2.31.1

