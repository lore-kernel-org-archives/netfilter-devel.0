Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BBBFC636D6
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Feb 2023 16:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbjBVQhl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Feb 2023 11:37:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbjBVQhk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Feb 2023 11:37:40 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2106.outbound.protection.outlook.com [40.107.249.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19B3360B8
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Feb 2023 08:37:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XjK2LfjZNi7DdbsGSJ07dwIoYH1whgIbnPE1MRnCui03qEfM9edYk/V57fT2asn9f0VWuQ+gVqnFHFaCD6sR7apccc26+Z8XYIfASA/ersAtlbGo0LHYoy77vHH/ICyWV23rpyikidGRbpFayVIGwHkGTDrPJx3F4bGwl1/pTxVDgnlo0S/EPO2EnnzMTa16M+p214JSuoU/CWlE/zvOy8wL5jwFhCFkXHGsvW8ZmTqqmT57+bZMzkVD1GxDhsYu/J/oK1b/Gvmu8BMS35ofOQVeB71oioeI+BKnUJTPh8HJF8ZNlE5NSyh38zThqFNj1oDpKRGDK5SVm0f2ZHgF8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E98DVefgHMuQjd2KSkqN1VpdhaD8q7Ri6X8dFFydAzI=;
 b=ahrS3ZOEV2kM6V0RzqJcVv92H1cmvan3tks9RzA4KfMbWdkDTnJgc4BwWNY9e79wbey05gsx5QJmSLE1C3S/cC8sSBWVWAr9ahWW6T12sK3NsR4foOI/HXJj4SG4V7WBBN1W6pHyOLVHapZK3nNRyMW3HyVIKa0ra9w5aGgKbY5J2+yzMq6NFpKkRmCghBywhcaJLDFtw3tJ0zX2P39wcftkzKurVlH6V6pcG0T1QmGf3I1ZJkgLHNXNbTFkEzCgsiaZhzBsNz1xB7lBSjGhMFJ7rwSZXgjDF5xfyUomrjeFS6g4CXAa/KgcqMKFbVCA0v/tJjF6/3VIrvIyaof43w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E98DVefgHMuQjd2KSkqN1VpdhaD8q7Ri6X8dFFydAzI=;
 b=F+xAyn8Sx9wC2dJeUNO6TxXwu9xMALtlWihTVkpww9hzy92k47QhGPS0icERPfnA7aS8Mg9nWyujpLSJrTmNaL4fxPH2IcACTnuWX4S9COsi5N0oh+SnlLxqPLzG4XbC6h4PMUpc3pLELAMTHjFnrvoyGILfKDjpS9hmVPAdLck=
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by AS8P189MB2362.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5bc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Wed, 22 Feb
 2023 16:37:36 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::13ad:a312:15c6:91dc]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::13ad:a312:15c6:91dc%9]) with mapi id 15.20.6134.019; Wed, 22 Feb 2023
 16:37:35 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     Florian Westphal <fw@strlen.de>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: RE: [RFC nf-next PATCH] netfilter: nft: introduce broute chain type
Thread-Topic: [RFC nf-next PATCH] netfilter: nft: introduce broute chain type
Thread-Index: AQHZRq1SzmiwH5iiMky01tW5G+Z0YK7a1r6AgAADNoCAAFBDsA==
Date:   Wed, 22 Feb 2023 16:37:35 +0000
Message-ID: <DBBP189MB14339986817662F00B5C0D2295AA9@DBBP189MB1433.EURP189.PROD.OUTLOOK.COM>
References: <20230222110337.15951-1-sriram.yagnaraman@est.tech>
 <20230222113731.GE12484@breakpoint.cc> <20230222114901.GF12484@breakpoint.cc>
In-Reply-To: <20230222114901.GF12484@breakpoint.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DBBP189MB1433:EE_|AS8P189MB2362:EE_
x-ms-office365-filtering-correlation-id: 101151d6-61c1-44d0-d151-08db14f31a9d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sMCeF/wTa9nmMS1VIdD1Ry06yUP/XmTCt9cr6bLDPj4QumWNjj5isVup4BiF9xKveM7IFV2C+cfX3XmgO2LELLfCGlZkcSgdn0hXWaTwnVGm6fcxMm+fbWDu8rLgzAYMYgNMNYGgPl1nuz4qgK5bz4ynMcu/QFSA003GcOx5jb/HTw4/2Ogq3hZmPPamFU8UMQ/mYB4strEh0yZvxaOoVV69lU01lRTYLYZVLbamSyz6KzygOk2Kf3G6bvMVrSQj/iYeECrNdICaBbAhEp7PG+pq9fkOEuRexXysXKaMTLt3nzNDJ93JYKn4fEX2u+QWhfrlnyNQKwH399Lo7r/5C6RPaZpbC7+6B+VkQjIiEqD9cGCOy5l44ETiA6Ax2pIcI4LPb6Z6TdSRYqa+BrgEwsJdDP8jaw39H0ZiFHSTi8+GIXlyh9huGQtalkHjuItNRw/qXHlu9G2ZQ/Td00/dh/nvY/+vxrmJC8davMv2WRCJWF7vnzZB5JbaQugw67M+PxVa/fmAfWyTTJrCX4HXE/IKQotC4Fa1wtqzm2yNVPh0CHhqsJX76zWWmYCTmrEj1UsjlLeKVaXWxaJBpSsr6SEieLgAYHSGBcCMMX1sIbtkigHqu8e5T3wj9iJj2Q+/KeQPPchUWr9qkNNt0ja5UKiB7aUxQWave5vfa4hbA/nuQEy4zQ1ITdwn9itHMn2wKeX9yyB0ElJhhuXpklTu9A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(366004)(346002)(136003)(39840400004)(451199018)(83380400001)(41300700001)(9686003)(186003)(54906003)(26005)(33656002)(86362001)(6506007)(316002)(478600001)(53546011)(7696005)(71200400001)(55016003)(66556008)(6916009)(76116006)(64756008)(66946007)(8676002)(66446008)(4326008)(66476007)(38070700005)(2906002)(38100700002)(122000001)(5660300002)(8936002)(52536014)(4744005)(44832011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TG9aYnhOZStGSTZKQzNnM3FEZXc5ekdjdHR5Q1Q5eUZnTWtWN0svQnlXc3RK?=
 =?utf-8?B?ejZscld3ekxqb0VZMElHUmFEKzg2YmpFRVMybTZ5TWFrMWpKSmplTG9tc21X?=
 =?utf-8?B?N2YrNmRvUUhVWTg2SS9xKzVHbEYzRG80MGRlSjIwYU9vSVA1VHRqblB0UVJC?=
 =?utf-8?B?UVZ3U1N5S05kS2JTS3dlMTRMSDhDS0tqdGlkNTNuU0ZVcncvRytHTlA2dFpU?=
 =?utf-8?B?ZnNnRzlFR0Z0QVRxVVRVdC9yeTFRUUFLQ3V0bjVSWDNCRGtTUGxDbGw3NDBv?=
 =?utf-8?B?WVNyUysxc2FMSlNqWVpwSi9VNEhRWi90S2NzYzBTYWhhY3F0a1BmdEpiaGZY?=
 =?utf-8?B?S2dac1l2OGZQNFBLT0k5cm9SOWkvVTdBeE9ncHN6bUlzT1FHcG4vMnBJV2x6?=
 =?utf-8?B?VGdNYUNyeXB6R045dDhHVTJlbGE5SWgvSFczdjZkRGUrc0c3bVRPMFAwMEx2?=
 =?utf-8?B?MlRUbnJGZmVuVkVubGlmTDBZaFVvbGIxSUJLQUp4ZlJzbXI4eTVaUzBKS0tR?=
 =?utf-8?B?OFBCTTZXbkR1OVE2ZVRrUWpYWGhMWFMxVndCU21JYldrTGRmOUMwNW1IZDBi?=
 =?utf-8?B?cFZiOXdyQkE0cExhUmUxcTZ0WnBWRWZnQkZ6cElqcGhaNXFHTkFLZEFONi81?=
 =?utf-8?B?QjVzN256WXI0Q1NXa0JtRnB2REdXbDR5Z2hXZ295dERvQ2JBTlVXRytZb2dD?=
 =?utf-8?B?S1V0MHZ0dktTVFZZbEE3MTVZTVpIeFBHcEdHRXZZM2FzbzZPOVlxUERCNCtI?=
 =?utf-8?B?Q0FIQTVEdkRHSmV0WW9paTd6WVV1ZElTbVBHdnJXRnNsWUIreWMrTDdIWUls?=
 =?utf-8?B?a1IyWGFXZ0E3a2ZCUWVRQWlSdCtCdEwydGRBdElnRHp0bDRGTGJsUnJIT0RO?=
 =?utf-8?B?WlJXNzQxV2s0bHlYOUVudkl3ZXpVYmE5RU5JUXBkMnNoYUlCbUhxaksrY2gr?=
 =?utf-8?B?bUkzcVJENjJsVUZZTlVzRkgzdkl3djRFZ20yUWQyYTZKb1NkT2Q0d09Lc1Fx?=
 =?utf-8?B?eEFCU3c2bk9kb2VwSlNuT1R6OVVobG1Pb3g3NjA5NkF6RnIxcmV4a1dRQXcr?=
 =?utf-8?B?YnVQWlUzTmxUbU0yNVVoMjRiVmhoZnFKQVFRK0dDSFlVMyszV0pxRTNIc2VS?=
 =?utf-8?B?TDlzdzVIKzNDTXJ4L1JDUTZFZDJ4alM0Ny8wa245eGZlYkZMMFZoM1FOb0xU?=
 =?utf-8?B?WThwVDNmcEI3WEhRVkRYSVBHbk5xczFEZGg0ZzdpNkVaVS8yK0JucFBUV2Fz?=
 =?utf-8?B?cWlYTjAzSm9kdE1MZmt4T3lpT0g5cTNSU01CL2hMUUw2aDFNT1liRFhUSVFQ?=
 =?utf-8?B?VFdSODY5S3NUUG55ZDFScHRNYXc4UGZtaHJqRzIxVElqeFNJZFBZaGMyN1JM?=
 =?utf-8?B?d2FmVkw3c3J4SVBvSXlZejlidU5ES1ZqUDNQTmhnTWVEaStqK0w0NyswRStY?=
 =?utf-8?B?WVNOenczU0N0dkgvamdrbWNkTzgvVGo0VHZoWnRWSXpXb1BtTjIvMnVQUUlj?=
 =?utf-8?B?cFU4WEJiQ3d3U200cFhhQjRIcVlmQnFJTU1GeXcrT0xLTkdCeG1Qa1VUVHM1?=
 =?utf-8?B?ZzJVWUl6VDFQdnlWNVlqdXc2bnZIUi9OYW9GTWFhOUtabVgzZkVTYThuN0Yv?=
 =?utf-8?B?Q1RLUWdBMFoyTzNoN2F1Nm9IVzRVZFR5UmFZVEQzSk9NazRZZnJGQmdGa2dG?=
 =?utf-8?B?TDVZekhlbXl5UUhLdnhHQkZWN0RKVGZxT0FKWnhBbW5IaUtsUEhGdmQyeXJ0?=
 =?utf-8?B?MlR0M0JoNXFHV0FaK2Njb1NpS1RLTWVFMlE4MEc2TDhvSnpEalBWQTJVSTNM?=
 =?utf-8?B?U3JQVDFsT3NZVjJJZ1ZJdjdoSk4xTGtzQ0p1R2lpNVFoUXpoVVhEaENiMy9t?=
 =?utf-8?B?TktVVE0ram1DSFg1eWg5VTZCYzRkWXEwOTF2TVluaEJINTl0VVVrNEdaYVdl?=
 =?utf-8?B?TWVKeEZNeWhjMUQxWUZnanZTTDlxV1JScTVVVnh6RC9oYU1HTWl4OHlWWnM5?=
 =?utf-8?B?c2x0MmNmc0JldnE5aFkzTHNwRzZzL3pScFR6SmNPYktuRHV4MFBPMG5iWXJX?=
 =?utf-8?B?N0FaTkM5ODg1b1VibE0yaXF2TTJoRmJCNlU5NW1URUNnNHExa25tS2RreXBv?=
 =?utf-8?Q?mNDvYWFyPMpeJtcliaNlCLmhU?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 101151d6-61c1-44d0-d151-08db14f31a9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2023 16:37:35.8591
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6T6mh3WSAknXF96bHyVJ5CexQcAPpvzgwQA/hMuTIi3a5Eev2sRqOSDKkiaqT5K/RKiHCL01h1WGaP9mLhv90NeB0leU80S1hnDTRivpcoc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P189MB2362
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRmxvcmlhbiBXZXN0cGhh
bCA8ZndAc3RybGVuLmRlPg0KPiBTZW50OiBXZWRuZXNkYXksIDIyIEZlYnJ1YXJ5IDIwMjMgMTI6
NDkNCj4gVG86IEZsb3JpYW4gV2VzdHBoYWwgPGZ3QHN0cmxlbi5kZT4NCj4gQ2M6IFNyaXJhbSBZ
YWduYXJhbWFuIDxzcmlyYW0ueWFnbmFyYW1hbkBlc3QudGVjaD47IG5ldGZpbHRlci0NCj4gZGV2
ZWxAdmdlci5rZXJuZWwub3JnOyBQYWJsbyBOZWlyYSBBeXVzbyA8cGFibG9AbmV0ZmlsdGVyLm9y
Zz4NCj4gU3ViamVjdDogUmU6IFtSRkMgbmYtbmV4dCBQQVRDSF0gbmV0ZmlsdGVyOiBuZnQ6IGlu
dHJvZHVjZSBicm91dGUgY2hhaW4gdHlwZQ0KPiANCj4gRmxvcmlhbiBXZXN0cGhhbCA8ZndAc3Ry
bGVuLmRlPiB3cm90ZToNCj4gPiBUaGUgYnJfbmV0ZmlsdGVyX2Jyb3V0ZSBmbGFnIGlzIHJlcXVp
cmVkLCBidXQgSSBkb24ndCBsaWtlIGEgbmV3IGNoYWluDQo+ID4gdHlwZSBmb3IgdGhpcywgbm9y
IGtlZXBpbmcgdGhlIGRyb3AvYWNjZXB0IG92ZXJyaWRlLg0KPiA+DQo+ID4gSSdkIGFkZCBhIG5l
dyAiYnJvdXRlIiBleHByZXNzaW9uIHRoYXQgc2V0cyB0aGUgZmxhZyBpbiB0aGUgc2tiIGNiIGFu
ZA0KPiA+IHNldHMgTkZfQUNDRVBULCB1c2VhYmxlIGluIGJyaWRnZSBmYW1pbHkgLS0gSSB0aGlu
ayB0aGF0IHRoaXMgd291bGQgYmUNCj4gPiBtdWNoIG1vcmUgcmVhZGFibGUuDQo+IA0KPiBPciwg
ZXZlbiBzaW1wbGVyLCBleHRlbmQgbmZ0X21ldGFfYnJpZGdlLmMgYW5kIGV4dGVuZCBuZnQgdXNl
cnNwYWNlIHRvDQo+IHN1cHBvcnQ6DQo+IA0KPiAgIG5mdCAuLi4gbWV0YSBicm91dGUgc2V0IDEg
YWNjZXB0DQo+IA0KPiBXZSBhbHNvIHN1cHBvcnQgbmZ0cmFjZSB0aGlzIHdheSwgc28gdGhlcmUg
aXMgcHJlY2VkZW5jZSBmb3IgaXQuDQoNCk5pY2UsIHRoYW5rIHlvdSwgSSBjYW4gaW1wbGVtZW50
IGl0IHZpYSBhIG1ldGEgZXhwcmVzc2lvbiB0aGVuLiBXaWxsIGNvbWUgYmFjayB3aXRoIHYyIHBh
dGNoIHNvb24uDQo=
