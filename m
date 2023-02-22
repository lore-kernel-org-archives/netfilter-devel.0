Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E973C61DA4
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Feb 2023 16:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbjBVQgc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Feb 2023 11:36:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjBVQg3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Feb 2023 11:36:29 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2135.outbound.protection.outlook.com [40.107.249.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8823D92F
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Feb 2023 08:36:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P6t7WS+ku3yd4wjwigLUbQIJ+mfTkscIBjR5N1E70H8N5CxhM8DwAx1KwT96DwB/34DusPH/5qcswliDgbjhl0/7sDxGeiE1HkEpvv/lt2hE4V516e8csk5bknoPRK1D5y9nsGNWqX4H+Rj66nEtzo1EprGEysp/3gc6Xn5vYCy0sTty4TP05zhnihAQcnbMS19/IQslofCZajrOfzOJHR+3Yytu/kqGjaXe/bZdnBIvhpLurYJnvR0FGrPsJt11KGFiPj5vwTbD5dJzg8otaxA/gdh3DFnk2qgG+AF/ZHtbaQ+iB4Y7egKLB9Rjfl2YNUa5eioMO+LqCatfTPLhxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zrs2/9YFrhxDdHvCN8pdkrQyKAXAsSXeW1At6EUz7m4=;
 b=NEM/FErIrSiifa8PyJGSM1ZvZIQLlMoDS3yZCd6cvgKVYDsffqwnY6CQoHknrIP8MS7U99AtH23D+9ffEs7LeNY4aKWEFpmR7cFSOX7ovDD+PfHXI4Vz9HUgC45vd5CYjx0Ml8P1Qko3FYQxZLEv2m5X+qxYU9aS5zBpR31IzA2ibTuqxAvI7C28Gx3mThfCFJLNRqTWDhDK1x9xx6tKSX8qxrMc/WGaFAR5jEkvnEZSMy8A+5nYv0+chuzixGnRJtPe2xLKm0rUJz5Fe1eDDenfBGBtChZ4g9sqsasFQ85UiFlPKe+Dy+5TCMs0OZgUQdh8dP1m8ILlE9L4lUz4pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zrs2/9YFrhxDdHvCN8pdkrQyKAXAsSXeW1At6EUz7m4=;
 b=FkLnuMkasEj6OzRTYDOUhzpLrbU2Ggge63YEzpXn/bVr0K3q9/4/bs7nTxFC3MMcCdzZbwftW46P+DdJwIkdHFobqQPGDzaPK1bi7aEFsTPbbb3fa2DRu/46/+UEPLG9wooRjLrOzqB3f9juKdJIxtZNu5POG9+nox8yRP/OEPk=
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by AS8P189MB2362.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5bc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Wed, 22 Feb
 2023 16:36:14 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::13ad:a312:15c6:91dc]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::13ad:a312:15c6:91dc%9]) with mapi id 15.20.6134.019; Wed, 22 Feb 2023
 16:36:13 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     Florian Westphal <fw@strlen.de>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: RE: [RFC nf-next PATCH] netfilter: nft: introduce broute chain type
Thread-Topic: [RFC nf-next PATCH] netfilter: nft: introduce broute chain type
Thread-Index: AQHZRq1SzmiwH5iiMky01tW5G+Z0YK7a1r6AgABMm2A=
Date:   Wed, 22 Feb 2023 16:36:13 +0000
Message-ID: <DBBP189MB14339BC26D99041EBDE6BE5C95AA9@DBBP189MB1433.EURP189.PROD.OUTLOOK.COM>
References: <20230222110337.15951-1-sriram.yagnaraman@est.tech>
 <20230222113731.GE12484@breakpoint.cc>
In-Reply-To: <20230222113731.GE12484@breakpoint.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DBBP189MB1433:EE_|AS8P189MB2362:EE_
x-ms-office365-filtering-correlation-id: 991155e2-6baa-4667-b0be-08db14f2e94a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8Ph36WM5X54VddPupyI0Zpci7Oy4CJlxYFDYUm9GdPqaDIOewY9m+56ymdYGGQriwuFN4DbK+claFZxzAhZVKawV/2GnePuVlBshXULwoWwIsFGih3cyLQ1d6ydzyyHvr0cHWMhQNlZLY0lABFH+G5Cw3MVbAeCLwGAksXLzxChVK6FGr+K5KBG1yBSxuLjpA6jOxpM/MJXaKj63urY658zmtj8boD+Uql01Ri4veZ/ypdpuTjQV7mIH8LQVQQxW63X7crxdeC2t6U42IxbNc/QqCSU6CUmizBTjaX0cVaQB4DxR4ntCrBhUSYOcnITD8aKZWfJB5iL7HQUIrS7a/R1xuMna/Kk+uKl/lLWr8AgXpc2503w3fxCutdPsSUnPQDO5ljEXMPxnlYv9In836bQvwvM9N32YuGrAiRCrS72VOgZH+n64mz5CiR/PXlVZuAlRotLiX7F2NfgBisUsZ2g5j6SIHKnDGOfgyg2YZXgUsrEpgdjkwMt/4pjtGHp5kp+sMf28eFqGkE0++gBsj3pGVD55CCUm3N0S6ty74y9yUtmgcwCo8rA/qsbDvTriTR1pw076CIbQVXFEIRcZd+EXLZI1yEsmfblKJXIRpKz97euAP3TEu7CIfOW79vdewJ0EIVY0CZ4nmBJZV54aGLTCOQSlq2bt2t6OkABsT3c/xyOchjlTHyC3Sk4ILSBN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(366004)(346002)(136003)(39840400004)(451199018)(83380400001)(41300700001)(9686003)(186003)(54906003)(26005)(33656002)(86362001)(6506007)(316002)(478600001)(53546011)(7696005)(966005)(71200400001)(55016003)(66556008)(6916009)(76116006)(64756008)(66946007)(8676002)(66446008)(4326008)(66476007)(38070700005)(2906002)(38100700002)(122000001)(5660300002)(8936002)(52536014)(44832011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VnBFRVhHUkR3eVN1dlJTUkZnRy9VazhTN0JqZEFHV2w3Y2VIcEhnV3ZZQ01u?=
 =?utf-8?B?SDVqTFhhdm5QQjgzWFdtWGZSS1lpczdndGkvbmtkUXRPaDJTcnI2T1VlSDZP?=
 =?utf-8?B?TlFkSTk3ODBlOFUzbWd6cm10SnI3cmZoK0FmeEJYQktWVXpyTVhhNE9ZWWs2?=
 =?utf-8?B?cTFNMWN3WWxER2RxOHhpbkpvVWVPWENnN0p1ck9NQk9kdExaNGF3YjFuRElK?=
 =?utf-8?B?aEI4Z3NPMmt5bjdvK3pGUjNOY0duV0RpMkpSY3hUU05qbnQzb05YSVowYWU4?=
 =?utf-8?B?bzFpQjlIUjVSeTd2K3VkRitJQUtjZUlsM0JGZ2FRbmlJenlOZTdhTjArYzRn?=
 =?utf-8?B?YlRYeWdLcG9OaDVweWlHVFVWR3lLUzRPU3hNRXRsUFZhWVZIamlPYnlWZ1Zm?=
 =?utf-8?B?QlVRZVg2RnNNNEJSc3dUeXBsODMxMDROUzdJZEdKTXM4VWdQaEtpekpXWlJC?=
 =?utf-8?B?T1ZSVnN1K0tGSjFEY01yTi9JTDYrL2tmejBSMHZadjlISkhZWklyTS9CTzRq?=
 =?utf-8?B?SHo2Um1OUFIvVGxRMkhKcFpJNy9xNW12eHNUUUhHT1hOQjZnZHVFcE9DaFBa?=
 =?utf-8?B?RVhUak5JYUxLSU05YkRQSUlJMmZQTXVWakxQUnBRY3MvUlhTN1E2UVJDRjRn?=
 =?utf-8?B?VmVnaldrcU53b0hIWkRicm1kN1ZibU15RktiVW9UOFMyMGxTZ1I1V2crc0ZG?=
 =?utf-8?B?WmY4cGNUbDVaTXk0V0UzbGtGeEdvRmJ6ZTVUdkE1Q0VGYW12RjR2dFVVUWxj?=
 =?utf-8?B?eEFIS1BkNFZwSGYxVng2Ync5VVRQYy9hMXRjbjFiOTNYditUUEVocWFXYzdJ?=
 =?utf-8?B?Z2JCM3hjR1oyMVhQckJadDVXVjAwTnU2NVl4c1FLUHVwOWdMbkxqcGtKWTVR?=
 =?utf-8?B?OHlocWlqUUhmSzRTK3Frcmw3VkpseDFKYys4dWI4VXhkQ1VFTHQxNUhpY25V?=
 =?utf-8?B?aFYzUUllMmJxVE5mYTZWdlFNVGdmdlU4eTVqZ1RuY0Ric0hkTjJCcnlTQXEx?=
 =?utf-8?B?US95clJLN2xxNDN1MlByUVNPWXprSEtkbFNNVFlNOU1kc0p0RVROWW9pWVJJ?=
 =?utf-8?B?aThWWlhVRU1mcWFobThUeXNtTkcrVHFIdkxzNXM2ejVnU1BINGpyVTRmb1Z5?=
 =?utf-8?B?dHRjVkdMTmRHeWdIaE05QXYyYjlzZmxFK1gvTkJweWoyVlBxTzF0SVI1WFVp?=
 =?utf-8?B?T2pDV0syaUc3Q0ppQ2x5L0xVNlF4UXJlUGhZT2s2S21HcWw0T3lubEZPWlpU?=
 =?utf-8?B?a2xkd1JqMVNMNzI1aUxHRSt6VWE4WHFMRHNrZ1hCeWNKMk9FWTNMZ2MzR3lB?=
 =?utf-8?B?MGh2USswVVBPTERUM3V3U3hISWRHMGtERW54ZFQ5TEpqRGZIVXNIQTVOeVln?=
 =?utf-8?B?RWwwUm03Nm1SSlNpWWFnVVJVcE1Yc3Rmc0U4TzBnUnVwZ2Z6ZTVnRGh0WWxp?=
 =?utf-8?B?Qko5TWd1RFdLV3lQRFlqaEtId2RXQWl4VmJ6MHlMS24vRlZnRzBCYUhUOUZu?=
 =?utf-8?B?bFZObUlBWEtkMVBOSDdQdDEwYnBJT0ZpaHl6ZDIrd2w5Wmpuays1L0FOMDla?=
 =?utf-8?B?UnhkQTRwVlpPMlplVmFueGdWOG0ycTEvSVlBQW5ySjlXWEVLNGgxS2NXSFp3?=
 =?utf-8?B?bkdabUVXY0lSWXFTdnVUajZ0U01SbnVMTlVzdmZuUlIxN1Z4ellkQVJwai82?=
 =?utf-8?B?T2hxTERmTm1IUUlZZW5BZFgveXROc3dTeVo3RnB3Z3B4ODM2NGVOZHk1a21B?=
 =?utf-8?B?T3VwRllDcU5ISXpsQnIyemkxUFVRemtpYlZoSEMyaHhRSktqdEVvOXJMWlE1?=
 =?utf-8?B?ZVBtOHlRRjRja29ZRU1LdDdqNy9EbGhZTWVKOWVmeUJQUzhBZEpWZWhReXV0?=
 =?utf-8?B?ZHZMK2d1WVYwOGNOMjQ0UVgxVXIvUzRJUXJHL1JsTFhrc2ZyWFRkdi9DTytF?=
 =?utf-8?B?ajByOElJN1AwdWtXdXpsL2lzYkIxdXNyVzNtRDk4TGtTbCtoWWN3TjhzTzRs?=
 =?utf-8?B?MXRJUEJ4S0tFeDJac0JrcWVvYlEvZjZpQWM2eGRLTGE1bDBPRVowbGx2N0dG?=
 =?utf-8?B?Qm1QUDZ0TVNzb3V0bll3a1N6V2hBZnVFL2hwN3p4SGNJTEEzcGxFUlZBTHhD?=
 =?utf-8?Q?vsxbeHLfd+6zliwvfq2Iwyo9P?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 991155e2-6baa-4667-b0be-08db14f2e94a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2023 16:36:13.1060
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cCPHmeUE6WS+GOCT9Vaqc9ZQXG0KKLyI5XyiWN62cK/h4O3gKYH9KtBOOjI0hq9Se/KG21n14ojvGma/EPi3vF+c9ZikYfaJX4eU3FcXg3E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P189MB2362
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBGbG9yaWFuIFdlc3RwaGFsIDxm
d0BzdHJsZW4uZGU+DQo+IFNlbnQ6IFdlZG5lc2RheSwgMjIgRmVicnVhcnkgMjAyMyAxMjozOA0K
PiBUbzogU3JpcmFtIFlhZ25hcmFtYW4gPHNyaXJhbS55YWduYXJhbWFuQGVzdC50ZWNoPg0KPiBD
YzogbmV0ZmlsdGVyLWRldmVsQHZnZXIua2VybmVsLm9yZzsgRmxvcmlhbiBXZXN0cGhhbCA8ZndA
c3RybGVuLmRlPjsgUGFibG8NCj4gTmVpcmEgQXl1c28gPHBhYmxvQG5ldGZpbHRlci5vcmc+DQo+
IFN1YmplY3Q6IFJlOiBbUkZDIG5mLW5leHQgUEFUQ0hdIG5ldGZpbHRlcjogbmZ0OiBpbnRyb2R1
Y2UgYnJvdXRlIGNoYWluIHR5cGUNCj4gDQo+IFNyaXJhbSBZYWduYXJhbWFuIDxzcmlyYW0ueWFn
bmFyYW1hbkBlc3QudGVjaD4gd3JvdGU6DQo+ID4gSXMgdGhlcmUgYW55IGludGVyZXN0IG9yIHBs
YW4gdG8gaW1wbGVtZW50IEJST1VURSBjaGFpbiB0eXBlIGZvciBuZnRhYmxlcz8NCj4gDQo+IEkn
bSBub3QgYXdhcmUgb2YgYW55b25lIHdvcmtpbmcgb24gYnJvdXRlIGZvciBuZnRhYmxlcy4NCj4g
Tm90IHN1cmUgYSBuZXcgY2hhaW4gdHlwZSBpcyBnb29kLCBpdCBzZWVtcyBiZXR0ZXIgdG8gaW1w
bGVtZW50IGl0IHZpYSBhIG5ldw0KPiBleHByZXNzaW9uLg0KPiANCj4gPiBXZSBoYXZlIGEgc2l0
dWF0aW9uIHdoZW4gYSBuZXR3b3JrIGludGVyZmFjZSB0aGF0IGlzIHBhcnQgb2YgYSBicmlkZ2UN
Cj4gPiBpcyB1c2VkIHRvIHJlY2VpdmUgUFRQIGFuZC9vciBFQVBPTCBwYWNrZXRzLiBVc2Vyc3Bh
Y2UgZGFlbW9ucyB0aGF0DQo+ID4gdXNlIEFGX1BBQ0tFVCB0byBjYXB0dXJlIHNwZWNpZmljIGV0
aGVyIHR5cGVzIGRvIG5vdCByZWNlaXZlIHRoZQ0KPiA+IHBhY2tldHMsIGFuZCB0aGV5IGFyZSBp
bnN0ZWFkIGJyaWRnZWQuIFdlIGFyZSBjdXJyZW50bHkgc3RpbGwgdXNpbmcNCj4gPiBldGFibGVz
IC10IGJyb3V0ZSB0byBzZW5kIHBhY2tldHMgcGFja2V0cyB1cCB0aGUgc3RhY2suIFRoaXMNCj4g
PiBmdW5jdGlvbmFsaXR5IHNlZW1zIHRvIGJlIG1pc3NpbmcgaW4gbmZ0YWJsZXMuIEJlbG93IHlv
dSBjYW4gZmluZCBhDQo+ID4gcHJvcG9zYWwgdGhhdCBjb3VsZCBiZSB1c2VkLCBvZiBjb3Vyc2Ug
dGhlcmUgaXMgc29tZSB3b3JrIHRvIGludHJvZHVjZQ0KPiA+IHRoZSBjaGFpbiB0eXBlIGFuZCBh
IGRlZmF1bHQgcHJpb3JpdHkgaW4gbmZ0YWJsZXMgdXNlcnNwYWNlIHRvb2wuDQo+IA0KPiBDYW4n
dCB5b3UganVzdCBvdmVycmlkZSB0aGUgZGVzdGluYXRpb24gbWFjIHRvIHBvaW50IHRvIHRoZSBi
cmlkZ2UgZGV2aWNlDQo+IGl0c2VsZj8NCg0KWWVzLCBidXQgdGhlbiB3ZSB3aWxsIGhhdmUgdG8g
cnVuIHRoZSB1c2VyIHNwYWNlIGRhZW1vbiBvbiB0aGUgYnJpZGdlIGluc3RlYWQuIE15IHN0YWtl
aG9sZGVycyB3YW50IHRvIGNvbnRpbnVlIHJ1bm5pbmcgb24gdGhlIGJyaWRnZSBwb3J0L3NsYXZl
IHRoZSBwYWNrZXRzIGFyZSByZWNlaXZlZCBvbiwgYW5kIGhlbmNlIHRoaXMgcmVxdWVzdCB0byBz
dXBwb3J0IEJST1VURS4NCg0KPiANCj4gPiBJIGNvdWxkIHNlZSB0aGVyZSBhcmUgb3RoZXIgdXNl
cnMgYXNraW5nIGZvciBCUk9VVEU6DQo+ID4gWzFdOiBodHRwczovL2J1Z3ppbGxhLm5ldGZpbHRl
ci5vcmcvc2hvd19idWcuY2dpP2lkPTEzMTYNCj4gPiBbMl06DQo+ID4gaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvbmV0ZmlsdGVyLQ0KPiBkZXZlbC8yMDE5MTAyNDExNDY1My5HVTI1MDUyQGJyZWFr
cG8NCj4gPiBpbnQuY2MvDQo+ID4gWzNdOiBodHRwczovL21hcmMuaW5mby8/bD1uZXRmaWx0ZXIm
bT0xNTQ4MDcwMTAxMTY1MTQNCj4gPg0KPiA+IGJyb3V0ZSBjaGFpbiB0eXBlIGlzIGp1c3QgYSBj
b3B5IGZyb20gZXRhYmxlcyAtdCBicm91dGUgaW1wbGVtZW50YXRpb24uDQo+ID4gTkZfRFJPUDog
c2tiIGlzIHJvdXRlZCBpbnN0ZWFkIG9mIGJyaWRnZWQsIGFuZCBtYXBwZWQgdG8gTkZfQUNDRVBU
Lg0KPiA+IEFsbCBvdGhlciB2ZXJkaWN0cyBhcmUgcmV0dXJuZWQgYXMgaXQgaXMuDQo+ID4NCj4g
PiBQbGVhc2UgYWR2aXNlIGlmIHRoZXJlIGFyZSBiZXR0ZXIgd2F5cyB0byBzb2x2ZSB0aGlzIGlu
c3RlYWQgb2YgdXNpbmcNCj4gPiB0aGUgYnJfbmV0ZmlsdGVyX2Jyb3V0ZSBmbGFnLg0KPiANCj4g
VGhlIGJyX25ldGZpbHRlcl9icm91dGUgZmxhZyBpcyByZXF1aXJlZCwgYnV0IEkgZG9uJ3QgbGlr
ZSBhIG5ldyBjaGFpbiB0eXBlIGZvcg0KPiB0aGlzLCBub3Iga2VlcGluZyB0aGUgZHJvcC9hY2Nl
cHQgb3ZlcnJpZGUuDQo+IA0KPiBJJ2QgYWRkIGEgbmV3ICJicm91dGUiIGV4cHJlc3Npb24gdGhh
dCBzZXRzIHRoZSBmbGFnIGluIHRoZSBza2IgY2IgYW5kIHNldHMNCj4gTkZfQUNDRVBULCB1c2Vh
YmxlIGluIGJyaWRnZSBmYW1pbHkgLS0gSSB0aGluayB0aGF0IHRoaXMgd291bGQgYmUgbXVjaCBt
b3JlDQo+IHJlYWRhYmxlLg0KPiANCj4gQXMgdGhpcyBleHByZXNzaW9uIHdvdWxkIGJlIHZlcnkg
c21hbGwgSSdkIG1ha2UgaXQgYnVpbHRpbiBpZiBuZnRhYmxlcyBicmlkZ2UNCj4gc3VwcG9ydCBp
cyBlbmFibGVkLg0K
