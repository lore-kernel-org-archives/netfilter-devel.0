Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08CEAC64ED8
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Feb 2023 09:03:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbjBXJDw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Feb 2023 04:03:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjBXJDb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Feb 2023 04:03:31 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2138.outbound.protection.outlook.com [40.107.21.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F0D39CF1
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Feb 2023 01:03:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BVZWwJ3hk8WsRclu5vDiQ2IMsyhxbHg9Nfq/C6gaFtke7zj0uPGZxfn5+vfWAd18WIpJG0Meh9qVvReUvDrj7Dd3XADf9lDEIeHK1aAj3NjN8RnoueMlcLWo+92d/KA/5kxTtXwucRHFurzC4auG7pboSGmqbmu8ise6kClD+qsqgk6WBgISfx5NAJx7wGbBpiOsB8029z3Gbku9MpxUkR86gxgYtJZypY3+ZNDR4ObbwyDyPjcW0B12iLH/YoR5fltJWIq2qsmZGdYq+eVIr6B07OhCW/DAckiCabOb141rC7sFq/RZkEhCYHaXZYbUiyZ2gX7h1vczMcFScRT3qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=co+hYZhLemqU1XRWNhTa5dbhFm6K6U/E8Egjkhj8LVs=;
 b=V13/yXJO9JOqPRwvGvrKwYUJQ5sRUM4BhvlnJWSSZ/TdIsIYkSa9UW06vEkohCVIlVEhg03puVPx4GLI3d7imb/7T63ygeNq1ptbLk6OO/GRXQnu6UvxtTz5QEZJW8YvkyKTWeiCtxkoWeyONnLeT23OKdnVN0eaTUQIX7j3EmCaAJcrUWx06fYK/8IJHe52vg3ONIKkKUYGM1qjhKbi8hzkvWTC7MuKPW4DV9w2ZMypLxf0zHP0riS+v4kS+v/+5XK3dhwiWdr59n9lG1jJBewMYZMwXapxoQJKsPxuY+uDfp+Piax2EwPjclJ/Qqye1IqEn0+pxbvxsZ2WAQk/ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=co+hYZhLemqU1XRWNhTa5dbhFm6K6U/E8Egjkhj8LVs=;
 b=VfAfkIDxh4M58X1taqzOOx8NkABPn042OgKFv68RdIdreXXZ0REjNwrPERzvzfK+SH9849shbu/cJ2dVp9PpAvGHrgze2C5kEGqTIiauZkt8cneoP63N0RLihPkYev489M0v/btsc9+buvPweNNdP55w5hBHVUaih2Mgy9mB1kg=
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by GV2P189MB2478.EURP189.PROD.OUTLOOK.COM (2603:10a6:150:de::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Fri, 24 Feb
 2023 09:03:22 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::13ad:a312:15c6:91dc]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::13ad:a312:15c6:91dc%9]) with mapi id 15.20.6134.024; Fri, 24 Feb 2023
 09:03:22 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     Florian Westphal <fw@strlen.de>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: RE: [PATCH nf-next] netfilter: bridge: introduce broute meta
 statement
Thread-Topic: [PATCH nf-next] netfilter: bridge: introduce broute meta
 statement
Thread-Index: AQHZR8p1szwDSoa3M0W1B49/uPrLWq7dJgYAgACnEPA=
Date:   Fri, 24 Feb 2023 09:03:22 +0000
Message-ID: <DBBP189MB14336D817E987CEBA648123195A89@DBBP189MB1433.EURP189.PROD.OUTLOOK.COM>
References: <20230223202246.15640-1-sriram.yagnaraman@est.tech>
 <20230223230146.GD26596@breakpoint.cc>
In-Reply-To: <20230223230146.GD26596@breakpoint.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DBBP189MB1433:EE_|GV2P189MB2478:EE_
x-ms-office365-filtering-correlation-id: b2999ae1-24ea-4ca1-c1da-08db1645fb03
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0J0+KmG7llFTCu+FmuBPlj5MXyVdMjIg2YP37/26WV/1qIJuYjhJ16Cof+3WpVupyZUUnwOKFrdOAH0Z5lhr2Yukz51b+nBPxma5wLWQaQhaw0qgAixfDQ9MyBB17//JMsYYRR367fFOXzdLJk6HuBFK/nxwC1F1QO19DE54ehh/YlA71slj0M8QNzopapUqdkTA9HtKDHJWqKv7hBxypNkzA/T3QmCiTVcbO1iNHMlCIR++u9CW6vFG6BtyF9IGPey+pQeALQ9IORNpDDKXoqc71jTHlPILmIXt2HwJaa69yCp7U8g/U9eZ/DpZ/P054xIw9zxP6RFOno7nF+WNHDy78qRqjGOMF+cERVx0ZI90A8FpHnLKm+I+7McNbZHa1GWdOJYU0YjMUigejIBxS7YGi1oQaLozS/vRrmFO5dQ2Gxzfhr2faMq9zjyQlvx8CRzn9+kLukKv3TAuNZEvAiqs20GXl/gdQhIYAceFToohAF7MU++mPoI7T2G9d2cLq0B+kN40Ne+xx8h4kfULaHbulQwaTPJfiw+kALzlcaFEgdUepM5HPFF6TNw3BjhaPSX0FgdAMaF3KbHb69anb5UeMLOowogAqn7cfwYX5mO/AhTtSD/XqiZnLnBfPjxjrrdBcoWPEJKLda0q9Kn+qtph4/OlzoutA98R9NGew6Cz2FslWAEE6AL4s2S2oyw9z+FQfHyFBKUD3gtFWNS5/w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(366004)(39840400004)(396003)(136003)(346002)(376002)(451199018)(52536014)(8936002)(122000001)(54906003)(316002)(53546011)(38070700005)(9686003)(26005)(186003)(478600001)(6506007)(33656002)(71200400001)(7696005)(86362001)(55016003)(2906002)(44832011)(38100700002)(6916009)(5660300002)(66556008)(64756008)(66446008)(66476007)(66946007)(76116006)(8676002)(83380400001)(41300700001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SXA3ampNZWxHYkV4SEdwQ2FuVHhvcmRncjE2enJ0VDFKdmNHNEtMK2ZyK25D?=
 =?utf-8?B?NkxVb1ZaM3ZSb3BKZ0EyWW0wUTI4R25mSVZEOEJWODhQbTgyWFJtQW9xL3VR?=
 =?utf-8?B?Wm1zWm5FblA3MnFMT0tESUtVVDJJQXpOTW83b0E5Y3FrNzMvSUZJamY1SUdy?=
 =?utf-8?B?VlBidlFlaWMxaFJXcjZtMXhNVlJURVJDblVSN0F4Rk1rODhpYlVrc0k2bFg5?=
 =?utf-8?B?Yy81by8wUVR0dExpVXRwNUNjaFpZVnhTa2kwUHFMNDlxb3cwS1NxaUIxY095?=
 =?utf-8?B?MHU1dFVxTHZKUjlyWjNPckcyUFJJeDRYTGVGNy9ReGY2aFcyZFhPZFNPSXgx?=
 =?utf-8?B?bTJ2NEFrYjV0NmtlcW5IamdMZmg0NU5FanY2b2YzZWVwUTZkWGRoZ1d2L3RQ?=
 =?utf-8?B?Uk52UThVNFRoZDdiZ2M3amlpN09Ta0JzN1NUQytkKzZYdkJPdkNzQWdpLzI1?=
 =?utf-8?B?MEFWOVVZai9DQytyU2VOSFdWRktzTHdFeGxwOXZrdG5yczZBRDNvUElGNytY?=
 =?utf-8?B?VmYwS0VveTdwRWtkMGk1Tmhqdk90N0NrV21ycGIzL05DdEVuMlExTUprZEpV?=
 =?utf-8?B?YjRqT0xnWUptTitHY2VqNUc1ZStJWHh0TzQzTWdIQmNaUDlnZ0ZoOGFhT0Jt?=
 =?utf-8?B?TitEaGFQM09HWWpuVVU3VjU3aHllMXh3WjkzQWVxZW9MN1dDN3NVQmxpdDEw?=
 =?utf-8?B?UUExQ3IwbjJHQU1hNW9LNGN0QXBsQ09aTVZjMCtYSVV0bnMva1RkcXg4QmRt?=
 =?utf-8?B?dWRSaHZRK1E5cEZnUk9zRS84ODZzTGpvTjg2OUd0cUxleHgwN25wY3NKZmNK?=
 =?utf-8?B?T0lmOG1iUmxLenFUTnV5V01sejlKYStxcVEyQVh2MVB6cUFVUXRNUzNDQUZY?=
 =?utf-8?B?RkcrRlJJNFZmUUUrNE9KamVISk9icnBDTjlBL0d3OXQvTUFLNkRzWkxUWWps?=
 =?utf-8?B?Vy83ZDQ5UW5YcmJhZy9xTTFIQlppNHdtTDJueWdvYkhFK25kMGFsd2VldFlt?=
 =?utf-8?B?ZngyRURlVDNycE1KaWFoQmRUWWVVSFJqOUtWMzJRK1UvUmpMeDQyRi95REZN?=
 =?utf-8?B?M2tPSzhVWWtiN0xTcGNwVXVFdFZiMUVvNzBTd2ZUQjBvejIyaU5tZW5ES3dI?=
 =?utf-8?B?UnBsaGxaYlRyRXg4ODZlM3J6QnVLSVZFcmtISS9RM0FLUEVaRTc2bjczY1hv?=
 =?utf-8?B?cHVHeDkwVjlNalpLOFVhSit3K0dURHRJczBhaTFPUEoveTFHZ2tjWXN1SlhN?=
 =?utf-8?B?RXYrcFVSQmxtOXVPR0ljOUpvUnBSMWJrblRuL3AxdzFaRFgxZHNEVjNkT2lt?=
 =?utf-8?B?RlFDaWVXL2pUTVkzRUZQS3NQZDE3Qk9PTnkxVWtZbTlLdWZwU2RienFRTFJR?=
 =?utf-8?B?ekxZTTZIVHlPZmNNQ0U4VFpZY2NUdm9INkJhYWYxYVRDWTZxSG9ZRUgxZDVE?=
 =?utf-8?B?Q2dBR29xTFpKTzlZVUJ3NDh3alRhSUMxcVRpZGdmaWdwWTJ6alhYODhGMzln?=
 =?utf-8?B?Qit5S3N3MlRxYVFQelVaZG54OThpa1hqMUc1YVJuLzFuUU1HMVNBZUNndXJl?=
 =?utf-8?B?NjZQbm1MSG5LU2lvUUk3UEcra2xvNTZXZG53eUwxRDlOOUZMT3c4dTJwb3hR?=
 =?utf-8?B?YzZWeGx3cG9KU2VkcUtTSWdVUU10eHMxKzYwazdsOUViSkNwSmUzZGlObk9F?=
 =?utf-8?B?RFZSSkpiV2VJU05QUy9Icmtzdk5FQXZiYUVJeVhDeTJkQVM2RGdLVS92NG9h?=
 =?utf-8?B?WlJGalhuMTIzRjJTZHh1RjBDTHZ1MjFPL1BlZ3Z1ZVdnc1dwZWh6N09vWDE1?=
 =?utf-8?B?YXNaa0hXVlB3WTg5ZlRZS1BGWm1jcUVtRDhQUDZ6V1pISW5vVnlFTHVPN1Bx?=
 =?utf-8?B?MWtlM0lqMU8yMXFmRkFVYS91N3V0NHhQTXBFN3hrL1JUZ1VSNGE2emgyOFNq?=
 =?utf-8?B?cHg1bUdlcXJTZ3NETGZYZ2t1YWdQQXVKL3lmRkVROEprTlVQRmwxYVM2UkVQ?=
 =?utf-8?B?R1VzZHZaUkVtUW1JVmI1VE5nbXpGQmhxME16c2JZYTczeHoxT042SzJJYkpt?=
 =?utf-8?B?UFdEd09uM1YxaGJRSCt0QXFZQ1ZuWUEvNEZQNm5nSEg5YVBUQU4vY3IwMUZ1?=
 =?utf-8?B?R3NpUlJNTVR1VFhPa2k4MDNCc3NoYUpZTjB0Y2pWdmNDZGdkSm40UnlmSCtw?=
 =?utf-8?B?Znc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: b2999ae1-24ea-4ca1-c1da-08db1645fb03
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2023 09:03:22.2470
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KOXNc5+JT58Gh0q4Zg4p/bv8qCL/zPkvgF5xN0U3e073a1tbozRjeZwuxLvIVXwiu0TdUgb3J4+rafMLhBVP1WYfUvKZjDUZodmoIh4+22U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2P189MB2478
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

DQoNCkhpIEZsb3JpYW4sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTog
RmxvcmlhbiBXZXN0cGhhbCA8ZndAc3RybGVuLmRlPg0KPiBTZW50OiBGcmlkYXksIDI0IEZlYnJ1
YXJ5IDIwMjMgMDA6MDINCj4gVG86IFNyaXJhbSBZYWduYXJhbWFuIDxzcmlyYW0ueWFnbmFyYW1h
bkBlc3QudGVjaD4NCj4gQ2M6IG5ldGZpbHRlci1kZXZlbEB2Z2VyLmtlcm5lbC5vcmc7IEZsb3Jp
YW4gV2VzdHBoYWwgPGZ3QHN0cmxlbi5kZT47IFBhYmxvDQo+IE5laXJhIEF5dXNvIDxwYWJsb0Bu
ZXRmaWx0ZXIub3JnPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5mLW5leHRdIG5ldGZpbHRlcjog
YnJpZGdlOiBpbnRyb2R1Y2UgYnJvdXRlIG1ldGENCj4gc3RhdGVtZW50DQo+IA0KPiBTcmlyYW0g
WWFnbmFyYW1hbiA8c3JpcmFtLnlhZ25hcmFtYW5AZXN0LnRlY2g+IHdyb3RlOg0KPiA+ICt2b2lk
IG5mdF9tZXRhX2JyaWRnZV9zZXRfZXZhbChjb25zdCBzdHJ1Y3QgbmZ0X2V4cHIgKmV4cHIsDQo+
ID4gKwkJCSAgICAgIHN0cnVjdCBuZnRfcmVncyAqcmVncywNCj4gPiArCQkJICAgICAgY29uc3Qg
c3RydWN0IG5mdF9wa3RpbmZvICpwa3QpDQo+IA0KPiBzdGF0aWM/DQo+IA0KPiA+ICt7DQo+ID4g
KwkJZGVzdCA9IGV0aF9oZHIoc2tiKS0+aF9kZXN0Ow0KPiA+ICsJCWlmIChza2ItPnBrdF90eXBl
ID09IFBBQ0tFVF9IT1NUICYmDQo+ID4gKwkJICAgICFldGhlcl9hZGRyX2VxdWFsKHNrYi0+ZGV2
LT5kZXZfYWRkciwgZGVzdCkgJiYNCj4gPiArCQkgICAgZXRoZXJfYWRkcl9lcXVhbChwLT5ici0+
ZGV2LT5kZXZfYWRkciwgZGVzdCkpDQo+ID4gKwkJCXNrYi0+cGt0X3R5cGUgPSBQQUNLRVRfT1RI
RVJIT1NUOw0KPiANCj4gV2UgYWxyZWFkeSBzdXBwb3J0IG92ZXJyaWRlIG9mIHNrYi0+cGt0X3R5
cGUsIEkgd291bGQgcHJlZmVyIGlmIHVzZXJzIHRvIHRoaXMNCj4gZXhwbGljaXRseSBmcm9tIHRo
ZWlyIHJ1bGVzZXQgaWYgdGhleSBuZWVkIGl0Lg0KDQpPaywgdGhhdCBpcyBiZXR0ZXIsIEkgd2ls
bCByZW1vdmUgdGhpcyBjaHVuay4NCg0KPiANCj4gPiArCXByaXYtPmtleSA9IG50b2hsKG5sYV9n
ZXRfYmUzMih0YltORlRBX01FVEFfS0VZXSkpOw0KPiANCj4gSSB0aGluayB5b3UgbmVlZCB0byBj
aGVjayBmb3IgIXRiW05GVEFfTUVUQV9LRVldIGFuZCBiYWlsIG91dCBiZWZvcmUgdGhpcw0KPiBs
aW5lLg0KDQpXZSBhbHJlYWR5IHZhbGlkYXRlIHRoaXMgaW4gbmZ0X21ldGFfYnJpZGdlX3NlbGVj
dF9vcHMoKSwgaXNu4oCZdCB0aGF0IGVub3VnaD8NCg0KPiANCj4gPiArCXN3aXRjaCAocHJpdi0+
a2V5KSB7DQo+ID4gKwljYXNlIE5GVF9NRVRBX0JSSV9CUk9VVEU6DQo+ID4gKwkJbGVuID0gc2l6
ZW9mKHU4KTsNCj4gPiArCQlicmVhazsNCj4gDQo+IENhbiB5b3UgYmFpbCBvdXQgaWYgdGhpcyBp
cyBjYWxsZWQgZnJvbSBzb21ldGhpbmcgZWxzZSB0aGFuIFBSRVJPVVRJTkcgaG9vaz8NCj4gDQo+
IFlvdSBjYW4gbG9vayBhdCBuZnRfdHByb3h5LmMgb3Igc2ltaWxhciBvbiBob3cgdG8gZG8gdGhp
cy4NCg0KbmZ0X21ldGFfc2V0X3ZhbGlkYXRlKCkgYWxyZWFkeSBjaGVja3MgbWV0YSBzdGF0ZW1l
bnRzIGNhbiBvbmx5IGJlIHVzZWQgaW4gdGhlIFBSRVJPVVRJTkcgaG9vay4gSXNuJ3QgdGhhdCBl
bm91Z2g/DQo=
