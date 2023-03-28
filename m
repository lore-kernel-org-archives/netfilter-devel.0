Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9965CC76195
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Mar 2023 07:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbjC1H2z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Mar 2023 03:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjC1H2y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Mar 2023 03:28:54 -0400
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2102.outbound.protection.outlook.com [40.107.247.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB2BB4
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Mar 2023 00:28:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K2QcSPe8Tba9HvNQd2rB5PPyiHa65y410NM9FkqYDdtfdSml1SRD2w3aBPPXfOsT4xYI2w31xIDIMrfNYSP028xTFLINvr5uQqsDVJZAWtyogFfY2VTjOy7ugW+qjc0hIPrEJtvTBpBM2jrzUnvgeKFOgUnlOiMHjxrqTLJ7wXxaAR6n3HWmWbGyaiQW37quZ+PBXCu7ZhxMXyydZo0KpNbuMahOifzjmzHLCF0YMZEcfkCpInQ7Nxdy2tYVdtVx38u8FvHufj/9IQokWQUBWysaiXqSlNhvDshDXCHkpdSHzcIeBK81PD1pLxRiqE+qkZLtGAWU0K9Pb7ymzf78Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fFO4XxNW8ACQ/jq+Bd0M9dH0IB9i3UKt/trA4mkQg34=;
 b=jjFzc4RjFiNaQhnX2mLBy+CEO1qefUwO4acyi9hYIqbZItnNfaXgjD6Mwjgya6OGzEVno76WCSbHwN68ZMi8hQ87WVF9wkdn7mMVCot3cvLmZTAjFgO4NhD3zY6IfxTo1OnC3GF1WHkdI2nX2F4b8NbadHXPoyu27r6GwwG+B+j57JCKgKX6UNSiTVmIEzhZKsZIhpHTOhwb+VGpME9Usq4AvAqMmd13rkpuKSY3h1A+YpemSnYWU81BFthrmD+v1g4ti48G/fA/JM+gVgBWdvCAm1QXJIH+ib1XqtAjNut+uSiHbe3OJUVTrXmHyg9N0psNL5RdexlH3m+9U3RJ/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prodrive-technologies.com; dmarc=pass action=none
 header.from=prodrive-technologies.com; dkim=pass
 header.d=prodrive-technologies.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=prodrive-technologies.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fFO4XxNW8ACQ/jq+Bd0M9dH0IB9i3UKt/trA4mkQg34=;
 b=mO6OQEsqIcI7cRgl+hel94YuPE32JwP9RopYLexAZ+5j5pttujOCXUkf9QN0bxAbTH+gTQOb/79tqGm85B+tk6/OXza83OH5wutAscLqor+2ZY+SlIi/W0i4ZbuBIn4IwLLoT/GiUZpD8/ueF5Ok1ASJ1UHOAQQYs9B5egjLOGY=
Received: from AM9PR02MB7660.eurprd02.prod.outlook.com (2603:10a6:20b:43f::24)
 by PR3PR02MB6442.eurprd02.prod.outlook.com (2603:10a6:102:7a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Tue, 28 Mar
 2023 07:28:51 +0000
Received: from AM9PR02MB7660.eurprd02.prod.outlook.com
 ([fe80::8203:5198:960f:908b]) by AM9PR02MB7660.eurprd02.prod.outlook.com
 ([fe80::8203:5198:960f:908b%8]) with mapi id 15.20.6222.033; Tue, 28 Mar 2023
 07:28:50 +0000
From:   Kevin Peeters <kevin.peeters@prodrive-technologies.com>
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: RE: iptables patch
Thread-Topic: iptables patch
Thread-Index: AdlhRd8vxRo6EOAnSHqnLy8oibYvxwAADfyQAAAMYkAAAAsqkA==
Date:   Tue, 28 Mar 2023 07:28:50 +0000
Message-ID: <AM9PR02MB766039341028D34A400D381CA8889@AM9PR02MB7660.eurprd02.prod.outlook.com>
References: <AM9PR02MB76606476D4EED1FF1938F8A8A8889@AM9PR02MB7660.eurprd02.prod.outlook.com>
 <AM9PR02MB766074FF89D28CE6655CA0B6A8889@AM9PR02MB7660.eurprd02.prod.outlook.com>
 <AM9PR02MB7660795D89727FA09BD370DFA8889@AM9PR02MB7660.eurprd02.prod.outlook.com>
In-Reply-To: <AM9PR02MB7660795D89727FA09BD370DFA8889@AM9PR02MB7660.eurprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=prodrive-technologies.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR02MB7660:EE_|PR3PR02MB6442:EE_
x-ms-office365-filtering-correlation-id: adf5aaa9-17ac-453e-4067-08db2f5e13d2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wyP2r0PURqoB9zAWZpS7KLFqaUYP8R1BEPH3eCce27PfieY041y+3suOQasOfSzENeMuc2pQQF7hN32iDX1wJrC7STxCvufIFV4u4/gIOn5twGkmobakkSHUrx/ctSrXqIOBMwu1Pfg2aU/YeXMfbh3wZvta3HRD3DlDYIgtUZsY0Pbl7fYlHaY+bjrIIchVHcUpZ3qGQrVdcRyqJTZevUODNmyxOk8yxsEvlHHnfQYOPhJIxCcdvpQtkEzHOVpWglaEGNFQMKWQFVzeArsBM4vU0zx6yvIgZ4yZXCUIKB/p1+JSd2qObgIs2Ndp1wyJ0ZCcbruVtTdzzRSLrG+a5KI2Rd6kuHVGBF+H7RTIrUEzqvc+KvzAg3Dpx0OZLPxTEJxpQAT/2wYxawROHNMjglPiylCZsmwUKmClGYruzoYYVke2pWdlUeU/P6gJPOrynu6q1nPPiVdo+DS5KXR++zESEAAgkqQsT1aKDTk9vRk9jr550ZaBzYMPJkVnvO7j9zylPWamNMTre6isubD9/Jn8UYYYZA46Ut4Xw4kjKBc8oQoVOM+eta9kObtU3nJjXPHuZiyD9BLb2Zn/gvWNjmiuz7DGbNHyahtbWSvrl5HRW3Anldrm9s3AyqRCqfSI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR02MB7660.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39850400004)(376002)(346002)(136003)(396003)(366004)(451199021)(38070700005)(122000001)(38100700002)(55016003)(86362001)(2940100002)(66476007)(64756008)(66946007)(33656002)(8676002)(76116006)(66556008)(66446008)(6916009)(186003)(5660300002)(7116003)(83380400001)(8936002)(41300700001)(52536014)(478600001)(7696005)(71200400001)(6506007)(9686003)(26005)(316002)(3480700007)(2906002)(44832011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sD8KLMY6I04FkKzhyjajq0JRy7Q86bmb3edV7FJsFk51zZqlIiXzRWiAuNv+?=
 =?us-ascii?Q?lmKa3qVcy2dB6CTdOWRutSSq281ymJtjo3oQeQOxlYQvnk8LNaaB04dkJ1vF?=
 =?us-ascii?Q?Atn/9TVGXYLCCmxJ83AbtZ0Mo5rA82iJ9m04raXc2grWUSdpOamFWkX6+znB?=
 =?us-ascii?Q?wga6fCyLzFsbXn+LI+h3UZW5sjg/S9OT5SPLEem0zGxvGGShUyeUiecufpWb?=
 =?us-ascii?Q?FywXLEgVHwpxVlEJGNAEaS495TNXcwB5/yxDafkwEg3JsOgp+FiA+NigDgPE?=
 =?us-ascii?Q?zhoTmae38ybNYtA3//IBMiQsljRvn7GyZZI4WY+eATZv0iWh0CthdTYGWcQf?=
 =?us-ascii?Q?G6Ekok1Vg4Mxc95wWgl05i7Sfeob7EwaXN7OUcJGOIj7dKJeybaQYQQ7BF/3?=
 =?us-ascii?Q?2HAxW7lFYiVkGH8+0v3jZva9FJfHETMzlX37eZTm25QaVBTwEZQddCV6lSwe?=
 =?us-ascii?Q?Hp2dNScYfQngf2jFn6DFoQ1li+LYfNf+bz+1WYLbNAgBjYDjNoE4IJMbqh1o?=
 =?us-ascii?Q?kufS1odzWwXK02+at7rtBm6Wlld4VYut0ZWgMHNjO/aJrgpDz6DKDeiPAHky?=
 =?us-ascii?Q?ybUmZGv6GZl216U+Cxqa1gkLMpjP1CB6Kjb0Un+ajj9FauDMvilY+UyJDmAL?=
 =?us-ascii?Q?Pt8kiHt8+55PiRKRsgOnfosiTFVr6BpfbAkVpKTA/m6YGTrw/PlAp3+hFtel?=
 =?us-ascii?Q?zNt7wdPTVGJ3EbeJOx6m6s2BmSLOVKmW8ps5PhYz7T+fWVwWhF9hThTRXLvt?=
 =?us-ascii?Q?xwmXfGjoauIcg/g9Ct+SKzvxSMQlRqLSW96Lh+cZM18J5vgvdjnb3XSuYbJB?=
 =?us-ascii?Q?iN4WamGUdeivmCt9uYMhPdgbDbbSSJ+Tjg+gdx/ZtvVce/HiyHK421Zw4IIn?=
 =?us-ascii?Q?gIu4aoQ9GjL8MBcmkfWncQDwTcUWE5HuBPIsMEH6X7MqGtUN7OhsKbYkWBfR?=
 =?us-ascii?Q?s6flcmz55jH2T+0kqjsA450B3G4HqxAo8oFsaKwoZq5AMoZiIyotYBIdm683?=
 =?us-ascii?Q?Q+lG+hTvsVOaKKZ2EnAZnJ6p1HJ3jPEdLSovGKs5BOwdq0fIOXHOS8BhIqGj?=
 =?us-ascii?Q?rrgLMlMKxdaQobkq160kVfx1eC3thX1UBcHu6aqmrrpOAodx4kDehqf+Qg97?=
 =?us-ascii?Q?0o/n8CcD3UCYwGM4I/4H7IrIJKwJ+B5GuXesE0F7AOr128GQjLKtZUHTEK6k?=
 =?us-ascii?Q?sHUBEnPQPkZRpmY61FNiyQMi2gWWK0f/rO7uAayTN7IRomjDfEuJupuCU1xH?=
 =?us-ascii?Q?0UtDFjPFw/WWmQWXOe2YKspmBza4CscRmtdU9rUuZSgyyTX81JF3sCiMhhyu?=
 =?us-ascii?Q?W+1bHJlxObGurCHpCRm59V+dpKCNFTvebnX9KGxwcyx0EgN/ezSHtBWoK8qx?=
 =?us-ascii?Q?ZYtDFEK8LrI8JrYjVjJN27q33bjuq4AzYbdAOIeRgHVLXgzdg6pyhPwSxYCD?=
 =?us-ascii?Q?E+T9gbq6H/QsvUwXGn5dk4Sy2wQM0dCKpyihMrexhOjAJO++6OJ73aiKnqGR?=
 =?us-ascii?Q?b3qx4kEzTR4Qtdixdh+NwfpdAFA4wkglMmjL8/vX/xrTRLNCn7EAtV99K2Om?=
 =?us-ascii?Q?E7LbxnMRjE0sH5WpzwX1YcEv8V9DtdfdPgQzbugAZ1Hv5lM3KIEp3FZzVRHT?=
 =?us-ascii?Q?Cw8UQ0sUN4wLn28Lo38oe7M=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: prodrive-technologies.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR02MB7660.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adf5aaa9-17ac-453e-4067-08db2f5e13d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2023 07:28:50.9021
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 612607c9-5af7-4e7f-8976-faf1ae77be60
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F0x/g8ptVpTP2z1vpl3myGkwWos186CkhIYSelXTAbUrA2LZDtV6A73yZP26Lrex8ox3bJ4+hbZVJF2jeJ3cyyxfpxDeg3pFlJISIS2SZlBytGfvMZIHky5BiaZ6tnrL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR02MB6442
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

I am using the 'iptables' source code in one of my software projects. More =
in detail, I am calling libiptc and libxtables from my own software API to =
add/delete/... iptables firewall rules.

While developing, I bumped into one issue while using libxtables and made a=
 patch for it which we now use on our checkout of the 'iptables' repository=
. We do however use multiple checkouts of this repository in different plac=
es and don't want to add the patch to each of those checkouts.
Would it be possible for you to add this patch to the mainline of your repo=
sitory so we can stop patching it locally?

The details about the patch:
In libxtables/xtables.c:

The libxtables code uses a xtables_pending_matches, xtables_pending_targets=
, xtables_matches and xtables_targets pointer list to track all (pending) m=
atches and targets registered to the current iptables command. In my code, =
I add/delete firewall rules multiple times from one main process (without k=
illing the main process in between) by calling xtables_init_all, xtables_re=
gister_target and xtables_register_match every time. When a rule is added, =
I call xtables_fini to clean up.

I do notice when adding a rule in my code twice that on the second time, th=
e (pending) targets/matches lists are not empty and when I try to register =
the same target (the one I registered in the previous rule) again, it links=
 to itself and creates an infinite loop.

I managed to fix it by setting the pointers to NULL in xtables_fini.

The patch:
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 96fd783a..ac9300c7 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -327,6 +327,48 @@ void xtables_announce_chain(const char *name)
 		notargets_hlist_insert(name);
 }
=20
+static void xtables_release_matches(void)
+{
+	struct xtables_match **dptr, **ptr;
+
+	for (dptr =3D &xtables_pending_matches; *dptr; ) {
+		ptr =3D &((*dptr)->next);
+		*dptr =3D NULL;
+		dptr =3D ptr;
+
+	}
+	xtables_pending_matches =3D NULL;
+
+	for (dptr =3D &xtables_matches; *dptr; ) {
+		ptr =3D &((*dptr)->next);
+		*dptr =3D NULL;
+		dptr =3D ptr;
+
+	}
+	xtables_matches =3D NULL;
+}
+
+static void xtables_release_targets(void)
+{
+	struct xtables_target **dptr, **ptr;
+
+	for (dptr =3D &xtables_pending_targets; *dptr; ) {
+		ptr =3D &((*dptr)->next);
+		*dptr =3D NULL;
+		dptr =3D ptr;
+
+	}
+	xtables_pending_targets =3D NULL;
+
+	for (dptr =3D &xtables_targets; *dptr; ) {
+		ptr =3D &((*dptr)->next);
+		*dptr =3D NULL;
+		dptr =3D ptr;
+
+	}
+	xtables_targets =3D NULL;
+}
+
 void xtables_init(void)
 {
 	/* xtables cannot be used with setuid in a safe way. */
@@ -366,6 +408,8 @@ void xtables_fini(void)
 	dlreg_free();
 #endif
 	notargets_hlist_free();
+	xtables_release_matches();
+	xtables_release_targets();
 }
=20
 void xtables_set_nfproto(uint8_t nfproto)

Thanks in advance!

Kind regards,
Kevin Peeters
