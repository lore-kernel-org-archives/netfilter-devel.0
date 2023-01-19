Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DE56C004D4
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Jan 2023 08:28:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjASI2K (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Jan 2023 03:28:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbjASI1e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Jan 2023 03:27:34 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2108.outbound.protection.outlook.com [40.107.14.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5CA66F9E
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jan 2023 00:27:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FodLebKMz9MiFhjKTp19HT2YKZMDHPKebG5bTPDToTgDLXaxofKMrDTuVeq5kBDWzHEbUb3ScWw02z/euuJOvuR5PZjfwPTACy1He/N7cxmpti0XE+kDHULXTlqgUg73XGUGu4GB8I34HTdt0HtFGvDyRIhJe4WsdZ76EhILt9rciMhR4+C/ECq7cheLbexGhw1iYPl59OVYMR/S5tDMTO37NDCgHiGOcEqM+8dWrYJtOlL/Cqb78SKECqGJw9BYy2PwPXduV9LFxkb5x9r8RIqlwRSLpZBGB9L01g1R2vm5pmIFJM5j729ncgoxhdkoFRHlwtz+rqMhX9XgKDczNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uj9l8ArHJ0AO/OmDTIJ++X0efF9bZgrEg79+JVgkEsQ=;
 b=UMLLs/u/UeCgFJ/WYCf5FpF+cpEeLcSRfzvEkoubEsJLTLRJovVFt5dj3BxaoydlLrM3U/A8Yk+11Slb2LFEJCsWK8b5eebCjtpgfi2XbQEnKgsrypqGodgOZUgLyxiBhYpHOQQDe9yIk5M4oM6xXOT9vwmIMP3SCdqidblQn9F7sd6X7gVe2VVkUKR569i81weEXli2nFilMwSKLfVUFKCs7cNcF5TwWPvqjeEjY66beDoTrKww+H6CWvBPmfMTjCQnIc+kbL4ydoD2E07oX1PprkvAVyCMToZOf1CT5qwNlxsb4mIl5Iso/E4gbZjooY5MuhxbtDHmpzFyUynM7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uj9l8ArHJ0AO/OmDTIJ++X0efF9bZgrEg79+JVgkEsQ=;
 b=CAZcJg20whe/c2PS6hG1Y+AIv8kPJLyIVti+SPROUHlCEBMO2n7LdcDOF9L38MS4LERvVUc2eMTq6nDLPHmBk/uidhduPv3C+LiY7BGfNQDTruhpsG+C42cObrS3VyjIX7ERpGO6wVWHIdt741mdHiSyA9m+Tm2Yz0MAAxerqk4=
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by AS2P189MB2537.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:646::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Thu, 19 Jan
 2023 08:27:27 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420%8]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 08:27:27 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Long Xin <lxin@redhat.com>,
        Claudio Porfiri <claudio.porfiri@ericsson.com>
Subject: RE: [PATCH v3 4/4] netfilter: conntrack: unify established states for
 SCTP paths
Thread-Topic: [PATCH v3 4/4] netfilter: conntrack: unify established states
 for SCTP paths
Thread-Index: AQHZKzHgogZwHVavok2VJqcBm3Ppeq6kTKiAgAEbySA=
Date:   Thu, 19 Jan 2023 08:27:27 +0000
Message-ID: <DBBP189MB14337339D62954EE69D352C695C49@DBBP189MB1433.EURP189.PROD.OUTLOOK.COM>
References: <20230118113853.8067-1-sriram.yagnaraman@est.tech>
 <20230118113853.8067-5-sriram.yagnaraman@est.tech> <Y8gQIUaGTnbS5mEN@salvia>
In-Reply-To: <Y8gQIUaGTnbS5mEN@salvia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DBBP189MB1433:EE_|AS2P189MB2537:EE_
x-ms-office365-filtering-correlation-id: 8382431e-9990-4e42-7f98-08daf9f6ffee
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hDHqdYU6ymeaz45zkrMLy5E+a8Lba8AoHnDxSD2TqgvV485ZaOHkuCE3BS3G2/Q+6ONmeHFPYxRFXbQ9iSLG3PH7hASmxP9R8l/aCNWNbUthcRgRe/AGXSKT/xma5LXxxRF8/tOQDT9shGRiBYI+FlppEh5jsC3JUOjyQ+ITVSYY6bqPyF2DQUTwR+hlgU1koXP0HT8OUuwwZhXd1afoGvhliLrh8tg4SJwBALXf6WRP+xsEaCKznJ/FjjuO2qLr/ktkK4WvW0zZcfgl7vq/04UpvP3mkbXodhpLRlREt2i+7jaxoR7ZFVmG/djqvY4RTSLxIzzWxvyMEEPGKw11tw460IiU4GQNg1Q7XzB9kRwTc26vxI8WrZHyIhzwc9QCEY1sMD8jyR7KAgBVmBOCvfxwrTJDituIoRvVmfrx4+YR6+ysFQkVVXYaJoPpcHWkaSydnP24sn5UL/TTrUr1TcsLxZFm+ECTgJS+Hy2QDXIHMaILCe6ZQRSWBDe9HzIIj1/EMVOYRbpq2t0Unxr55+Zt+T+f7DfcjV5pd4d4B9C8zXS7PZ9uCYtwRUc5baFbPQTa0pGF3ICWlCUPpM0QM26NBi8SdMpypKsi1f3py8WcxGWI8Fh2XFuxVog9JO1yWhvKySTbuVdvKGVDCr/rP3RXxyXYw24iunqy5/DjUBBx4QImL0+DCaK8GwMSLCogzdtSKW1kHz92QDHHGH0A9w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(39840400004)(376002)(136003)(366004)(451199015)(71200400001)(7696005)(53546011)(6506007)(316002)(478600001)(9686003)(26005)(186003)(6916009)(38100700002)(54906003)(4326008)(44832011)(64756008)(66476007)(66556008)(76116006)(41300700001)(66446008)(52536014)(83380400001)(2906002)(8936002)(5660300002)(122000001)(38070700005)(8676002)(66946007)(55016003)(86362001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dmNxQTZ0TTlrd2FYQlNpdEJxMHR0azVxSXZwc2FvVDkvOUtlWWFNSzk3VjVu?=
 =?utf-8?B?ZXNVdHZVOXNlZXU5cjl1cS9JTEJuejRib1RNVDhtWTNQMHV1YXZjUVVtajdr?=
 =?utf-8?B?UWl2MjJXcXFCazd3Y1k5czJrNm9yVFVwWTNZR01zQlNDcVdjcGdEdGRubUR4?=
 =?utf-8?B?ajlsUzZoNjBrREt0b2NReVN3aGJ3VFhVQmhuM1BBbWJwWDY5akZzUm1qMUcw?=
 =?utf-8?B?T0g0cHBzM0tWeDNWYTdhZThKYVhOenlGTnFDb2RRTnBGVXFydHZvNndMRmpV?=
 =?utf-8?B?U0pPa0tETTRVSkZxQ01WZmErSVdIdWhPTlpqb1diSG53bjhYZzVoVW1wVjNV?=
 =?utf-8?B?Ri9FM2MyTUZkeVhka2U4OWJ0NXF3N1VENDVzckV3ZjU5TEx2ZHZBZzZiSEsx?=
 =?utf-8?B?QVNWMmxyN0JvdHBjTEZyaWVDeUV3THk0c01KclZjUzFTajVIVEJyd0lzV2Jm?=
 =?utf-8?B?cU03RURNem5CQU5mdStpVEFrTU1Lc282dSs5SjB1N0hNaHBsaUkwQ2Y0ZVUy?=
 =?utf-8?B?M3NmeWRtZjZYSHNEdm9qV25ZdXlid0taZ1hmYlE0eUhlb0JCbkdwZHQ4dTky?=
 =?utf-8?B?bGpTZzNXTzVlSjh5ekhWZVd3RkovUG5Ncm54a2JpN3ZkNFp0cHR6c3EySXJ1?=
 =?utf-8?B?NExSc2FkM3VzODR3aDdqOHZaUThJQTBBTGo2VjNWSlJqQjNEWUNDVXNwS0Nn?=
 =?utf-8?B?YkR1U0ZCWng4dlh4YnU0eXRFRmlxNEJUODY3YXpPaVJyQ0owVjRVdElLOCtq?=
 =?utf-8?B?SGVuWFdHQlNRbFFhajg3djd0ODVDalE4UWNrR0dZSDR3ZkFneE9Cell6YzRC?=
 =?utf-8?B?dGhnRFc3QXdCNFNjbHA3K1VpOXNMSDZXdlJDRUFyTWtESVhWL01pUUxIaFJR?=
 =?utf-8?B?dkhYRmdJd3VBNzFzREl2WUtDa21oR2R0bFFBSGlpYUNMclptS01sNkJRMlBx?=
 =?utf-8?B?Q0kyYmZqQVdJVDU0Wlcyb29jWGJCVUtMNDRPSEdsRTRxOUlaZVlQQndISVpm?=
 =?utf-8?B?SFZ0cVJYVzJOcVFCRHFjUXVMV2dGZElHU1doeWJwSll5OEUzUm9LS0VxRHoz?=
 =?utf-8?B?YWlnTC9WS2JvTjNoSGRHVTAwR0hXZFFTSGlzU3hnSHptLzJweUFwTzdSZmVI?=
 =?utf-8?B?d2tSa1pxcGRZNHVKSGFlQS8zYmNINGl4bFN3WDJNa204UDZDZnpiV2ZzOEdO?=
 =?utf-8?B?amV5U3VtcDBpcXdJdUJRa2RLY1Z0Ukl6SStyV2hMVE0xby91bVg2emd0YytD?=
 =?utf-8?B?aEJpeXBoL1NGSytQNHNQaUpYaGpDcGZhdGY2bDBwbG14Rkp5c1FBNUM2ZUJH?=
 =?utf-8?B?NzdOZmwrRmVOS0NqSUpDdmE5SXEwTldlZWI1T2pVbUpacVB6VVBrWFpRY3NF?=
 =?utf-8?B?MklPN3dVSlVGZ2RHMDFJU0VqakF2UGljWWZVK3FiMXJvNDZMeFhwL0JNaWNP?=
 =?utf-8?B?dlZvTHd5NE5Mems3SGs5aGpHOE1FWmxjUUZEWEFMOGdDeGVtcnovZDdyaXlY?=
 =?utf-8?B?UkZhbGJydVB1NjBhM0w5Qmk4RU4rZE9ha1FjRGEwcStkdmtYYkhNZ1FyZDdM?=
 =?utf-8?B?WjdWZEp1WWJFY2tFVnMzbjNKeVBTMXdIUXBqQXFhRm11bzBBZG5mVWtnS2dl?=
 =?utf-8?B?MHU3czJkcEFIVlg0c1J3R3lXR09wYVlzT1c1RUJsYXYzaXBraitwWXFRNWlK?=
 =?utf-8?B?aHQwOWo4bHNjWkJJMzBVQlQ4Z20zem13aysxY1JlVGVYYTBxWUtGM0NFK0FD?=
 =?utf-8?B?NGFabk9nYWRlbDBuZXJWWTEyVGlyRHpmbjJqL0pWWFhFdEFPbHdaVnlMczhi?=
 =?utf-8?B?aEdJdTN1UGZEaWNrWStUZ3VpQktlSUxEVFM0MTVZYTZUbW1xREpHMUdPVjdZ?=
 =?utf-8?B?QzZlcHdQT1lOVVdsRFpUWjdDVEl2SUZUWEUxa1RqTjI0U1BYVjRWT3Vadk5F?=
 =?utf-8?B?a2JkZml0N2FGYTZ1S1VJMDluSmUwbGFHRVRwTXlIMHVLMXkxdHNRL2tYc3RY?=
 =?utf-8?B?cisyTk5BTG10WmkwMnBWZmUvMG8rZ20yL0tlU2hDYVRBcTM3STJyYzIyN2s1?=
 =?utf-8?B?TXJUUHVNQnNCNUFuNmNmZmtGbkV0Q1YvUFAyTkY5ZE80dFB2aCtuSXFRcHdm?=
 =?utf-8?Q?/kqAJEq0sCBUBTqndC+HP1MXp?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 8382431e-9990-4e42-7f98-08daf9f6ffee
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 08:27:27.7125
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sV57HtzeX5lXYBVaP4K0hmQK92cswdgR6rLp11ytBtowrfEZzL/2Ty9dAGT/XsjxgnUkcwlAfo7UwYRPUSJsYD+CMG+3lHkpEQwDiDchFMQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2P189MB2537
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBQYWJsbyBOZWlyYSBBeXVzbyA8
cGFibG9AbmV0ZmlsdGVyLm9yZz4NCj4gU2VudDogV2VkbmVzZGF5LCAxOCBKYW51YXJ5IDIwMjMg
MTY6MjkNCj4gVG86IFNyaXJhbSBZYWduYXJhbWFuIDxzcmlyYW0ueWFnbmFyYW1hbkBlc3QudGVj
aD4NCj4gQ2M6IG5ldGZpbHRlci1kZXZlbEB2Z2VyLmtlcm5lbC5vcmc7IEZsb3JpYW4gV2VzdHBo
YWwgPGZ3QHN0cmxlbi5kZT47DQo+IE1hcmNlbG8gUmljYXJkbyBMZWl0bmVyIDxtbGVpdG5lckBy
ZWRoYXQuY29tPjsgTG9uZyBYaW4NCj4gPGx4aW5AcmVkaGF0LmNvbT47IENsYXVkaW8gUG9yZmly
aSA8Y2xhdWRpby5wb3JmaXJpQGVyaWNzc29uLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2
MyA0LzRdIG5ldGZpbHRlcjogY29ubnRyYWNrOiB1bmlmeSBlc3RhYmxpc2hlZCBzdGF0ZXMgZm9y
DQo+IFNDVFAgcGF0aHMNCj4gDQo+IE9uIFdlZCwgSmFuIDE4LCAyMDIzIGF0IDEyOjM4OjUzUE0g
KzAxMDAsIFNyaXJhbSBZYWduYXJhbWFuIHdyb3RlOg0KPiA+IEFuIFNDVFAgZW5kcG9pbnQgY2Fu
IHN0YXJ0IGFuIGFzc29jaWF0aW9uIHRocm91Z2ggYSBwYXRoIGFuZCB0ZWFyIGl0DQo+ID4gZG93
biBvdmVyIGFub3RoZXIgb25lLiBUaGF0IG1lYW5zIHRoZSBpbml0aWFsIHBhdGggd2lsbCBub3Qg
c2VlIHRoZQ0KPiA+IHNodXRkb3duIHNlcXVlbmNlLCBhbmQgdGhlIGNvbm50cmFjayBlbnRyeSB3
aWxsIHJlbWFpbiBpbiBFU1RBQkxJU0hFRA0KPiA+IHN0YXRlIGZvciA1IGRheXMuDQo+ID4NCj4g
PiBCeSBtZXJnaW5nIHRoZSBIRUFSVEJFQVRfQUNLRUQgYW5kIEVTVEFCTElTSEVEIHN0YXRlcyBp
bnRvIG9uZQ0KPiA+IEVTVEFCTElTSEVEIHN0YXRlLCB0aGVyZSByZW1haW5zIG5vIGRpZmZlcmVu
Y2UgYmV0d2VlbiBhIHByaW1hcnkgb3INCj4gPiBzZWNvbmRhcnkgcGF0aC4gVGhlIHRpbWVvdXQg
Zm9yIHRoZSBtZXJnZWQgRVNUQUJMSVNIRUQgc3RhdGUgaXMgc2V0IHRvDQo+ID4gMjEwIHNlY29u
ZHMgKGhiX2ludGVydmFsICogbWF4X3BhdGhfcmV0cmFucyArIHJ0b19tYXgpLiBTbywgZXZlbiBp
ZiBhDQo+ID4gcGF0aCBkb2Vzbid0IHNlZSB0aGUgc2h1dGRvd24gc2VxdWVuY2UsIGl0IHdpbGwg
ZXhwaXJlIGluIGEgcmVhc29uYWJsZQ0KPiA+IGFtb3VudCBvZiB0aW1lLg0KPiANCj4gVGhhbmtz
IGZvciBuZXcgcGF0Y2hzZXQgdmVyc2lvbi4gT25lIHF1ZXN0aW9uIGJlbG93Lg0KPiANCj4gPiBA
QCAtNTIzLDggKzUxMiw3IEBAIGludCBuZl9jb25udHJhY2tfc2N0cF9wYWNrZXQoc3RydWN0IG5m
X2Nvbm4gKmN0LA0KPiA+DQo+ID4gIAluZl9jdF9yZWZyZXNoX2FjY3QoY3QsIGN0aW5mbywgc2ti
LCB0aW1lb3V0c1tuZXdfc3RhdGVdKTsNCj4gPg0KPiA+IC0JaWYgKG9sZF9zdGF0ZSA9PSBTQ1RQ
X0NPTk5UUkFDS19DT09LSUVfRUNIT0VEICYmDQo+ID4gLQkgICAgZGlyID09IElQX0NUX0RJUl9S
RVBMWSAmJg0KPiA+ICsJaWYgKGRpciA9PSBJUF9DVF9ESVJfUkVQTFkgJiYNCj4gPiAgCSAgICBu
ZXdfc3RhdGUgPT0gU0NUUF9DT05OVFJBQ0tfRVNUQUJMSVNIRUQpIHsNCj4gPiAgCQlwcl9kZWJ1
ZygiU2V0dGluZyBhc3N1cmVkIGJpdFxuIik7DQo+ID4gIAkJc2V0X2JpdChJUFNfQVNTVVJFRF9C
SVQsICZjdC0+c3RhdHVzKTsNCj4gDQo+IFdoeSBvbGRfc3RhdGUgPT0gU0NUUF9DT05OVFJBQ0tf
Q09PS0lFX0VDSE9FRCB3YXMgcmVtb3ZlZCB0byBzZXQNCj4gb24gdGhlIGFzc3VyZWQgYml0Pw0K
PiANCg0KVGhlcmUgaXMgbW9yZSB0aGFuIG9uZSBzdGF0ZSBmcm9tIHdoaWNoIHdlIGNhbiB0cmFu
c2l0aW9uIHRvIEVTVEFCTElTSEVEIG5vdywgQ09PS0lFX0VDSE9FRCBhbmQgSEVBUlRCRUFUX1NF
TlQuIEkgd2lsbCBhZGQgYSAib2xkX3N0YXRlICE9IG5ld19zdGF0ZSIgY2hlY2sgaW5zdGVhZCwg
c28gd2UgZG9uJ3Qgc2V0IEFTU1VSRUQgZXZlcnkgdGltZSB0aGVyZSBpcyBhIHBhY2tldCBpbiB0
aGUgUkVQTFkgZGlyZWN0aW9uLiBJIHdpbGwgd2FpdCBmb3Igb3RoZXIgcmV2aWV3IGNvbW1lbnRz
LCBiZWZvcmUgcHVzaGluZyBhbm90aGVyIHBhdGNoc2V0IHZlcnNpb24uDQoNCj4gVGhhbmtzLg0K
