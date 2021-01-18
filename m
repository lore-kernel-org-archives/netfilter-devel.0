Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,TVD_SPACE_RATIO autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E151C433E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Jan 2021 07:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CDBF22240
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Jan 2021 07:39:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730146AbhARHj1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Jan 2021 02:39:27 -0500
Received: from mail-vi1eur05on2060.outbound.protection.outlook.com ([40.107.21.60]:48097
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726139AbhARHjU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Jan 2021 02:39:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hAsFv0CdWUDN/ghWqSpzhn/+BXoklj4HOIopSyuKv07w103dp79V2hV6m235moOKqB/6oPeKwKLoCs4JtF9UgcLGyGeVO4htGMED4wbPrcMlzilSYQ0m5sQvzuvN0X3Ah+G0a2u5Hf8+rx4QWz9YURyHXDxc4kWcW3vlQVXTgtLrW4vhrlGKUP4uHAF4RrrYyHYqkQMbTNYD+6tZlPrLhwuF37YUAMtrRmgBJKUS9mHwtfzlgcb8mXn0/GMnikQpLsVihlZMLuOw7GHkKJyy0wmsxBACngikLngJdY68kBdHKZXUk06oO28geeTu8xWaxyc8ccFmv2dv+CDsHyUcgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iyKrp7I82f3wYzsbQR/1Jeu1cFgJoa6hSbBVeuarAhw=;
 b=PthsnUmjzM8iX0j9CZE0sGj8reL0y5lHS80cYIxD95yxhBAoOw1cUOr8Bg3ro627rXVA7C7z+QUTG+zexaIZt4N0EO+2DLkQ93fN9HK5rSE5oFLqeFDxEvJzq9c5QF/kE8MqpfLdFcssI3FQeaXG1dTWiyh3YcCrq+e6s61izAn2GaVLq9Dqr0P2J2QVcFGoznzNAE1hRK9Re9et2xmcOaWEet6bchu0sW0c303UVcokDHoU1ydloNQuH5ucFz2J9itgXECZQfiUokgSaihLpa7+3vk4ZSly0rrBH622FIp76aT2La1SZ3+YPts3tIvK9NWU3AfgIKQhj9xtHeqgCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=boskalis.com; dmarc=pass action=none header.from=boskalis.com;
 dkim=pass header.d=boskalis.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=boskalis.onmicrosoft.com; s=selector1-boskalis-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iyKrp7I82f3wYzsbQR/1Jeu1cFgJoa6hSbBVeuarAhw=;
 b=5KVQ/mCM5+tBaQKuBX17Zp5ukb4iNANgWdI5+vvMfqELjYkvPK7WND9PCcMgwt89XS0+vVly0AqVDPNxuPgkWX5ogCDJbyjrBpCuCAB4x6pHEA+/R2FAQM2SCkRJTkDrRxaK9HYI/KnxEh0YnEwy7I7METJZ/mv7xEQmWJb3e1I=
Received: from AM8PR04MB8034.eurprd04.prod.outlook.com (2603:10a6:20b:249::18)
 by AM0PR04MB4243.eurprd04.prod.outlook.com (2603:10a6:208:66::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Mon, 18 Jan
 2021 07:38:33 +0000
Received: from AM8PR04MB8034.eurprd04.prod.outlook.com
 ([fe80::1c36:ddda:6d41:cbc4]) by AM8PR04MB8034.eurprd04.prod.outlook.com
 ([fe80::1c36:ddda:6d41:cbc4%6]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 07:38:33 +0000
From:   "Vink, Ronald" <ronald.vink@boskalis.com>
To:     "'netfilter-devel@vger.kernel.org'" <netfilter-devel@vger.kernel.org>
Subject: Unsubscibe
Thread-Topic: Unsubscibe
Thread-Index: AdbtbOqyYItTJlXxT+mojycI5s6yKQ==
Date:   Mon, 18 Jan 2021 07:38:33 +0000
Message-ID: <AM8PR04MB80340310520FE4903EA81DAE99A40@AM8PR04MB8034.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=boskalis.com;
x-originating-ip: [77.248.152.42]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 94c984d2-c61d-4d7a-48cb-08d8bb840ed7
x-ms-traffictypediagnostic: AM0PR04MB4243:
x-microsoft-antispam-prvs: <AM0PR04MB4243359D87BB5A4E2041204E99A40@AM0PR04MB4243.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ySlWZFYHkbAtc4FgUOBbnOchLw0mnlMPu+qugVVkpoozatomb3UHJJlGzHk1VGHVuUDYzQgwhpJcW//DgevxbK5H+dOcEca88ExI8qbu0Lk/YVj9rQHHOPf55SP1fXT7E32eHksrjkmY7AvIiHSafgYdKhu3QyKMKk68jUJZ5s7+1MsNqlfdrUwGL3hA6pOVfe7OCjhotxOI2fpsnYDPhcuWpB8EpLKReKaxzcHaF1sHUqo4iW2fjBqZxA8tFfAE7Z0CCiTL6r7QVo2S723g1dl4zDI1/YEjFFdD0D8SvofHKBk8RuQuveOJ5QEiXc3k
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB8034.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(366004)(346002)(396003)(66446008)(8676002)(66476007)(621065003)(73894004)(86362001)(26005)(52536014)(55236004)(6916009)(66556008)(6506007)(7696005)(7116003)(3480700007)(64756008)(76116006)(55016002)(66946007)(2906002)(9686003)(8936002)(71200400001)(186003)(4270600006)(33656002)(478600001)(316002)(491001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Q0lZeEJuWmJnVnlwT3lvQy9GdzUzZnNRMnpMMkx3K3NQVUJOM2hPazh6bkxL?=
 =?utf-8?B?T25hRlZZdmx4dVN5bDhGLzFwSTl2L29rQlM2Yzk0T0xXU0p6WXA0RzdGMWJo?=
 =?utf-8?B?aVlwYzJmQVIxT0N5VEluQklwSXF0d1ZHSlJaZzFUTDdTL0M4aXRkWGJjNGFQ?=
 =?utf-8?B?TWZxVGZjcUp0OC9WZk9Nd0pUQXpvVmtSZStEWlpRaGp4RWh5ZlVUNWZ0QU5j?=
 =?utf-8?B?ZW93ZVE1bGVXblZyZU44OWVDb3pycDNCSmYwZUgrMGJtbC9DY3ZJWjQ2c1kx?=
 =?utf-8?B?dmpUaEVFbzJOMnJSN3pCbGY2am9oUEFKY1ZEMk0venBNMlBSL2RsUlhJN3Vi?=
 =?utf-8?B?S1dpNitaMUFDVmZieHI0QmFPWmMxVG85V0t0aFRqTFJUbnp0VlhtK3g2RmN1?=
 =?utf-8?B?K0VEaC92SjlFM0ZjY0NaK0RvaGp5VXhaZEVDSFMwNDgwZUw3cFRMazlibHBp?=
 =?utf-8?B?OENRdGh3NTVodHRnaUdmTlNQT1J4ai9FUm5WSlBkR0FQSm5DRERLdXdsWGNl?=
 =?utf-8?B?NUF2QlRTbFFWS0daaTFQaEV5K1BSZ1BWMWJuRS91K3Q1Z0pPWlQrTFBueWMx?=
 =?utf-8?B?aU80S0ZQdUptZWRUU3BQSGdJZ0NQWllFRXhaNHZzS20vbjBLV1BtSU1kNllu?=
 =?utf-8?B?NVY1V1VQT2g5ckIzdVFBVVBuenovQUxsMFdQZGdmS3RtT3BPY1A4dzY1U3M3?=
 =?utf-8?B?dHpsaGNwcUgraVFxTjNIM3UvRHlQaEl2R3F3d3YwQXZDdCs5TnRBdm1xRUVI?=
 =?utf-8?B?VlhlL2ZIc2JZaHovY3dGWWdHUU52aEtsZDVqYjFhUFBOWHM0Yk5jT0R4YzFD?=
 =?utf-8?B?TnVSaHo4QWhOZHAxZkZlTmU4Z3ZoeFpIL0JKYjMyRXlkR0IrbVM3VjMweDU1?=
 =?utf-8?B?dHRYd0E5cHJxU3d4dkN2b3g0L0VYOThDR2FrWkIwUU8rZXdPYStraHRPOGQr?=
 =?utf-8?B?ZzlJY3NBeThWZ3FQVzliUXdQSks3NDcwTXAyYW1VUmpkNjJYVnFYQWt1STB4?=
 =?utf-8?B?TjFqa21xU1hXOVczZ0p6Z3B6ckk4Q2Ixem9mQ3hqT09adlp4amJUcmhoMldm?=
 =?utf-8?B?eDdzNFRnRGZHU1ZQMWJCR2tGTDRUMUdHVWk1QjJtL3pCNmtQaUNVbEZ0Z2M3?=
 =?utf-8?B?ZVpzdlBPTkdCM3JodlBYdGVxTnVyV3VPQmFhVWxiRUNHSFVkUnd2V2twVlZs?=
 =?utf-8?B?bHJJTEJ1TDk1WXNzbFo0TVd0bEVqQnF4WE1nd2JuY2luckMzOGZBbUhOTUFH?=
 =?utf-8?B?c082bEVLM3hIMExtOHg1NUdiZ1BBUWRIeW9kak9nOVZ5Q1lTOHRkb0d4L3Zs?=
 =?utf-8?Q?VWOKQoN/NncPg=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: boskalis.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB8034.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94c984d2-c61d-4d7a-48cb-08d8bb840ed7
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2021 07:38:33.1006
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e9059df4-f2a9-48d6-8182-7f566ea15afa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tax9w2H3Oz3GAmC0mEv5bA4wsrbtcc8S8K7vvH+AKviqeTmejeU29JtztHpg9wvNpmSyYqzzCzPnP7zdIx5rOX2XEtyUcb7dbAW40kJiIL0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4243
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

DQo=
