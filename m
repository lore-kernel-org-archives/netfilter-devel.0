Return-Path: <SRS0=QEZg=T4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1831EC04AB6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 07:04:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B10502075B
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 07:04:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=transip.nl header.i=@transip.nl header.b="LKOUg7U+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfE1HED (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 May 2019 03:04:03 -0400
Received: from mail-eopbgr60135.outbound.protection.outlook.com ([40.107.6.135]:27532
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726203AbfE1HED (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 May 2019 03:04:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=transip.nl;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=93FYfH9CPYTOUIOA91OKTH/j+yPTkJwi16aC3qT3g5Y=;
 b=LKOUg7U+bbVUFLOj/N9L1bDafnW7IlNBVf0rfSlYQX78GVp/XeFcw0SS0QEbnTGx/VySf8RDu9C6bU85qfW0BASfirAchXjXDmhSXgYrWrbC9rgAJWgBGBExlRX7xf3Pa5Mz12vU7AcrnbVsZiuNcJVzztpFQt5ZAXM57W6qCuo=
Received: from AM0PR02MB5492.eurprd02.prod.outlook.com (10.255.29.141) by
 AM0PR02MB4049.eurprd02.prod.outlook.com (20.177.43.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Tue, 28 May 2019 07:03:59 +0000
Received: from AM0PR02MB5492.eurprd02.prod.outlook.com
 ([fe80::8032:6f7c:6712:fdcd]) by AM0PR02MB5492.eurprd02.prod.outlook.com
 ([fe80::8032:6f7c:6712:fdcd%6]) with mapi id 15.20.1922.021; Tue, 28 May 2019
 07:03:59 +0000
From:   Robin Geuze <robing@transip.nl>
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: [PATCH] conntrackd: Fix "Address Accept" filter case
Thread-Topic: [PATCH] conntrackd: Fix "Address Accept" filter case
Thread-Index: AQHVFSKmKzha36mmIUqp62mIzCyxuA==
Date:   Tue, 28 May 2019 07:03:59 +0000
Message-ID: <AM0PR02MB5492D0F9BEB5814637C7D5C3AA1E0@AM0PR02MB5492.eurprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=robing@transip.nl; 
x-originating-ip: [2a01:7c8:7c8:f866:11::1003]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d26b6bc1-fc67-4360-5f2f-08d6e33aa85b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM0PR02MB4049;
x-ms-traffictypediagnostic: AM0PR02MB4049:
x-microsoft-antispam-prvs: <AM0PR02MB40499EF0D029A181EB19EB14AA1E0@AM0PR02MB4049.eurprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-forefront-prvs: 00514A2FE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(136003)(366004)(346002)(39840400004)(199004)(189003)(55016002)(5640700003)(91956017)(66476007)(66556008)(64756008)(76116006)(73956011)(86362001)(66946007)(2906002)(305945005)(7696005)(6916009)(6116002)(66446008)(6506007)(102836004)(53936002)(25786009)(14454004)(68736007)(52536014)(5660300002)(74316002)(6436002)(71190400001)(508600001)(71200400001)(9686003)(186003)(74482002)(2501003)(256004)(46003)(316002)(7736002)(476003)(99286004)(8936002)(33656002)(486006)(81166006)(81156014)(2351001)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR02MB4049;H:AM0PR02MB5492.eurprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: transip.nl does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kH83kP5F1LPYXRGM1T9Zdsm/fkyXqO4kOF7285R0xqJf+ZulYac+keUzZmitBH4zMvwnTvBu0WzwFOTw2CWIb/xsdExahGtf5K6MMk58M2+hESu83F77RMTnHC9X7t5aZh1JHYfUil2i3NF9NymonSwkJsHKjS16tCGfgdpfZ4mZRqeFti6euvIg20IRd+dRdON8nK3xDd3I5r6SrARKBpmFpmQWzRvD555EKg6rkNZof05DZXfoateyIN5OHZSaLEg8zh97wlI11TLDRnuCRjH/0716vU546Ui8w1+SDqRHK2mcRi98RGAq2cXFYNhfNUS0BN6D2JWjqunc0UKNvFSf9gunNqt0+kU05eyfP7VL4VR1nb8liapYtn8ftY1bxjH3r7NkGJAqVG7GlwrSq+WkA5hIAyQZu0sIAQB0JM8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: transip.nl
X-MS-Exchange-CrossTenant-Network-Message-Id: d26b6bc1-fc67-4360-5f2f-08d6e33aa85b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2019 07:03:59.0993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a4e75c98-a80e-4605-9b02-f5c4db1859b9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: robing@exchange.transip.nl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR02MB4049
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This fixes a bug in the Address Accept filter case where if you only specif=
y either addresses or masks it would never match.=0A=
=0A=
Signed-off-by: Robin Geuze <robing@transip.nl>=0A=
---=0A=
  src/filter.c | 10 ++++++++--=0A=
 1 file changed, 8 insertions(+), 2 deletions(-)=0A=
=0A=
diff --git a/src/filter.c b/src/filter.c=0A=
index 00a5e96..07b2e1d 100644=0A=
--- a/src/filter.c=0A=
+++ b/src/filter.c=0A=
@@ -335,16 +335,22 @@ ct_filter_check(struct ct_filter *f, const struct nf_=
conntrack *ct)=0A=
 		switch(nfct_get_attr_u8(ct, ATTR_L3PROTO)) {=0A=
 		case AF_INET:=0A=
 			ret =3D vector_iterate(f->v, ct, __ct_filter_test_mask4);=0A=
-			if (ret ^ f->logic[CT_FILTER_ADDRESS])=0A=
+			if (ret && f->logic[CT_FILTER_ADDRESS]) {=0A=
+				break;=0A=
+			} else if (ret && !f->logic[CT_FILTER_ADDRESS]) {=0A=
 				return 0;=0A=
+			}=0A=
 			ret =3D __ct_filter_test_ipv4(f, ct);=0A=
 			if (ret ^ f->logic[CT_FILTER_ADDRESS])=0A=
 				return 0;=0A=
 			break;=0A=
 		case AF_INET6:=0A=
 			ret =3D vector_iterate(f->v6, ct, __ct_filter_test_mask6);=0A=
-			if (ret ^ f->logic[CT_FILTER_ADDRESS])=0A=
+			if (ret && f->logic[CT_FILTER_ADDRESS]) {=0A=
+				break;=0A=
+			} else if (ret && !f->logic[CT_FILTER_ADDRESS]) {=0A=
 				return 0;=0A=
+			}=0A=
 			ret =3D __ct_filter_test_ipv6(f, ct);=0A=
 			if (ret ^ f->logic[CT_FILTER_ADDRESS])=0A=
 				return 0;=0A=
-- =0A=
2.20.1=0A=
