Return-Path: <SRS0=QEZg=T4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99C0BC04AB6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 09:24:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DD332075B
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 09:24:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=transip.nl header.i=@transip.nl header.b="GmM4hpw+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbfE1JYW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 May 2019 05:24:22 -0400
Received: from mail-eopbgr50094.outbound.protection.outlook.com ([40.107.5.94]:51246
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726279AbfE1JYV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 May 2019 05:24:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=transip.nl;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fE1chyaANAk5P0fxPMRj201BMTZjzj3J1yBfQ0CLQ7Y=;
 b=GmM4hpw+Bw9qr2iMIRTk1Rs0GFhTqShp084kw6xEyU8RSP9iOhkaJQDX45u9wJ7L+UHGKoGxjk9acjC3ECgO1XS41TP8Oh6pHuejj50fmCelGlpbWj6b6wgWZwdzdqwC5qdieLhjLOzphCu/reF3p829umFF2RZPfJTgl8x/Rcw=
Received: from AM0PR02MB5492.eurprd02.prod.outlook.com (10.255.29.141) by
 AM0PR02MB4017.eurprd02.prod.outlook.com (20.177.43.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Tue, 28 May 2019 09:24:18 +0000
Received: from AM0PR02MB5492.eurprd02.prod.outlook.com
 ([fe80::8032:6f7c:6712:fdcd]) by AM0PR02MB5492.eurprd02.prod.outlook.com
 ([fe80::8032:6f7c:6712:fdcd%6]) with mapi id 15.20.1922.021; Tue, 28 May 2019
 09:24:18 +0000
From:   Robin Geuze <robing@transip.nl>
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: [PATCH] Apply userspace filter on resync with internal cache disabled
Thread-Topic: [PATCH] Apply userspace filter on resync with internal cache
 disabled
Thread-Index: AQHVFTbqFwRcnO3s5kWLDNiSoZj+SQ==
Date:   Tue, 28 May 2019 09:24:18 +0000
Message-ID: <AM0PR02MB549235F7DFDD08E5C47E2B0AAA1E0@AM0PR02MB5492.eurprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=robing@transip.nl; 
x-originating-ip: [2a01:7c8:7c8:f866:11::1003]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2bba79df-130a-4641-f8a8-08d6e34e428e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(2017052603328)(7193020);SRVR:AM0PR02MB4017;
x-ms-traffictypediagnostic: AM0PR02MB4017:
x-microsoft-antispam-prvs: <AM0PR02MB401754CFC8EF389A0B1AA684AA1E0@AM0PR02MB4017.eurprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-forefront-prvs: 00514A2FE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(39840400004)(396003)(376002)(136003)(189003)(199004)(6436002)(305945005)(486006)(476003)(64756008)(66556008)(66946007)(66446008)(66476007)(46003)(508600001)(71200400001)(71190400001)(7736002)(14454004)(316002)(102836004)(6506007)(55016002)(52536014)(5640700003)(256004)(5660300002)(14444005)(186003)(99286004)(76116006)(91956017)(7696005)(73956011)(74316002)(4744005)(86362001)(2501003)(81156014)(81166006)(33656002)(68736007)(53936002)(9686003)(2351001)(25786009)(74482002)(2906002)(6916009)(8936002)(8676002)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR02MB4017;H:AM0PR02MB5492.eurprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: transip.nl does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5g7suA6X02EWPs+N2WhayiyLnZwHfbzVlyonJb9SiByAFGZCOmzCqJt31lXcuBsDIssk0+pFo0jCmmFUVJAjPphthbQSaVswO2tox98b8pMtM/lKMq0atf0aw6n5cT6LWmjtyfizAh6J6TG16vnhHlLDD4jiOFDK44A4cpFfTQHzf8OljOFk3ouJWBPPqPTIXSk7MaqfKTgcBVd6h5JVfTTBaUOM5Pd5/pn19vxmqb6S3z1gLSEWmHJHDGy5qaD8LjAzAJnS09gbiJKhHyLkaCyMp8+Z0VBtxQ9NrBim+YZYEafN/yj9ePCN1XK0ibqUVV3VaU+Pxc14TRP9zESPeU9uzUOCJpB4ldc1yiO2ZUvpF3fJdZraX9XPd0V0fKFp7GdlGu/VKvsJdNtdjJ7Fvt3kmJ0maZxC9jf7c492TwE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: transip.nl
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bba79df-130a-4641-f8a8-08d6e34e428e
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2019 09:24:18.1495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a4e75c98-a80e-4605-9b02-f5c4db1859b9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: robing@exchange.transip.nl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR02MB4017
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Always apply the userspace filter when doing a direct sync from the kernel =
when internal cache is disabled, since a dump does not apply a kernelspace =
filter.=0A=
=0A=
Signed-off-by: Robin Geuze <robing@transip.nl>=0A=
---=0A=
 src/sync-notrack.c | 3 +++=0A=
 1 file changed, 3 insertions(+)=0A=
=0A=
diff --git a/src/sync-notrack.c b/src/sync-notrack.c=0A=
index 1b53e1b..b765c1a 100644=0A=
--- a/src/sync-notrack.c=0A=
+++ b/src/sync-notrack.c=0A=
@@ -72,6 +72,9 @@ static int kernel_resync_cb(enum nf_conntrack_msg_type ty=
pe,=0A=
 {=0A=
 	struct nethdr *net;=0A=
 =0A=
+	if (ct_filter_conntrack(ct, 1))=0A=
+		return NFCT_CB_CONTINUE;=0A=
+=0A=
 	net =3D BUILD_NETMSG_FROM_CT(ct, NET_T_STATE_CT_NEW);=0A=
 	multichannel_send(STATE_SYNC(channel), net);=0A=
 =0A=
-- =0A=
2.20.1=0A=
