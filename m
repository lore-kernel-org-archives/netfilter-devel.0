Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C639C6379F
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Jan 2023 22:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjAQWGb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Jan 2023 17:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbjAQWEb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Jan 2023 17:04:31 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2123.outbound.protection.outlook.com [40.107.21.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BF35AA46
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Jan 2023 12:13:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TBhlL4KdytClshjoqiwAXGjBSvrWJIWLaeI/negiVPTtQqkP7pGhonFJREa1yRN8wxcjP/Zul2E1t/ggLJXK6xDSkI4yWb5bkuAaPoLBy+U+n04vJCKhjjfHVQn1KvgrxbouXQyTlAVqOW/pUm4o+gF7q13D9c2V52OpMYyBKGpa7GYOvERWrzLoxbe0wjKyi2PxDlmg4ExJOnCOcsasO/Ylh1wZy4QB9JVvTgL+fWJIVoVD/UtbS83XHIokFYEfFk1N7tJ5VNJk2PXIwwsmeQoBP8/Uq05XPExWuTee80JkUaKBrDMfa9/Zcn30BTkn2WjMoP1XHbHOa8rICZTtYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iOIMynUaVXng+z8ABcHJmDv2UuQFQkRT2ah+Auhdivo=;
 b=XNdBo+EJgfVJgwVO1BG/Txh695dmQP3qmiKhzwnwuSKLBbLArFPg1jcz4LKbR5yzYzfpPex9wxlNUBt0ZQbVsu2jsnzd1zdoy4NRAFLGV1soi7EnD1h0ueApdF7kbiZu3tUcDI6Qx5CpfMrKVcGeR/NPS7AV5j3pLjF49qbp2bJRrp+W/jElhLeqvJpwrpI10FV2j7eyiZOIl3trWM37ihIQYHPKuLHBemtd4+M94X/OJL+pybKLCb1k4k7gL8eLaSFI+uH261Zk7bxKfm7ZludbXaAnXJLH4DZRMKFr0XDPJEivzsih4EwgIHfeeqFitYXsl8scl+r3U5ybqXjEoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iOIMynUaVXng+z8ABcHJmDv2UuQFQkRT2ah+Auhdivo=;
 b=bhd51aTkwMqoPqFU6DWn7gIryf3dk3BhdvDo1GQ+965Hx0lZ2kXXmrK9kjjypEdLb7rd4kibEWBjN0UcWxoEbxVnGq6xBtTjlNr7D2cWOc4rEctSK6soDG4Csj7xUjAX2pq4MEC0jIeUrrQN76B7X76j6q8QUXm/NmWMdWhrov8=
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by GV1P189MB2012.EURP189.PROD.OUTLOOK.COM (2603:10a6:150:63::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 20:13:51 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420%8]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 20:13:51 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Long Xin <lxin@redhat.com>,
        Claudio Porfiri <claudio.porfiri@ericsson.com>
Subject: RE: [PATCH 3/3] netfilter: conntrack: unify established states for
 SCTP paths
Thread-Topic: [PATCH 3/3] netfilter: conntrack: unify established states for
 SCTP paths
Thread-Index: AQHZKY3yn0wJta5YCEGNTxBpLscLNq6igdkAgAACAoCAAIOvYA==
Date:   Tue, 17 Jan 2023 20:13:50 +0000
Message-ID: <DBBP189MB143338BCC8AB37889F78518E95C69@DBBP189MB1433.EURP189.PROD.OUTLOOK.COM>
References: <20230116093556.9437-1-sriram.yagnaraman@est.tech>
 <20230116093556.9437-4-sriram.yagnaraman@est.tech> <Y8aMgOo0XImPyS54@salvia>
 <Y8aOLydRlSqemdf/@salvia>
In-Reply-To: <Y8aOLydRlSqemdf/@salvia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DBBP189MB1433:EE_|GV1P189MB2012:EE_
x-ms-office365-filtering-correlation-id: dc72b058-9e07-420b-f2dd-08daf8c75985
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UT9mRY+fBeZld9bsdVMPAVy8/6XQFngoqXVRuF0m5KzAkMxHqcDMKgfJ4T3TVhXdK9cJeOB5sOs3Zp3FdBE3DvQEpoD0iUXPnSNs+ZkyG2dCxHiNjyN91PG82qyUYHhaokptSQYUI0Bujbnf6cm5oAngvwKlKTvA+ZFxFIfSvAsToB63nqXviMwKTGndB5mSLhmLpHpt/KcT+kPN4Xknq0PvI9UXnDNgQs/aj9fmPlYBOiygFDOUcP/rUtiP+YSPjkWZvd16BktaWjmacWbDmniJug32biTaVHP2GNLqDlh7oqnzajmxVAJZCYIPT/W1rB7f3qCkPC3GmGi4wxABl/gCgX2nZLxZaaLfu0JA7Q8dv5KWFoaLyw2XjbMEleDTAKLQ0Vq1gw3TDn9+taSuKKFHoJLfd/hydOItRYj4NBxnfHCm/fp/C85ZKyRuh9w8UckdsjoLWDU/+LgKbm3N5LXPd5Yym7lnHo2eKx8snHSlRdftjwUTnyT3a6tfEHEg10eMBtgUh7Q44Z4sDjT4gycJ8Q8d4AZ6DK2UFIace6s6L3ZmZVk8G965Uan/VTJruUiEP6AgVPf2KvRzdMSrmHp9ZsNpxOP2coQsdvQpkT8bJX0reCvGTNeU/OcOcPPdqfu6QZpENE41v6rfNzTk0DxYuyW4cI5w90XoIA3w9ct/S5miMtihrMEcEQdtaNlJAeTwDlWsGevOTfkqQ2pL/65A3njnGFHh0ZwBRRMVYgM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(39840400004)(366004)(136003)(451199015)(83380400001)(54906003)(9686003)(966005)(71200400001)(7696005)(478600001)(33656002)(55016003)(186003)(38070700005)(38100700002)(86362001)(122000001)(2906002)(52536014)(53546011)(6506007)(44832011)(26005)(8936002)(8676002)(66446008)(76116006)(6916009)(64756008)(66556008)(4326008)(66946007)(66476007)(316002)(5660300002)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R1Yxc0tSd0poYXlQVnBkYXVKSEJ1VWZyTGlpaU1zcTAvSmg2dHFaWVVJRXhU?=
 =?utf-8?B?UUUvYXowSlNCTzk5UnJxZk1EeEExY0VxekFwTVpXQ0JQaWhUay9SVnVRYU11?=
 =?utf-8?B?MEV3bGVLaUF0RnlQNnhQQlBHTVRTOVFaMXRQUmNyREI5TVJkZTA1YlR2YkYz?=
 =?utf-8?B?aVJpaW0reVQ4NXpWWm5uWjJGWW9sZFZPVlJTOXp4aTJxdGlDT280UGk4NWo3?=
 =?utf-8?B?b1o5OXV4Z3lpTWNxY3pUNmFnbXZjcTZQdFBOeUNUbUVyaWlvNG5mMVA5Qlp6?=
 =?utf-8?B?QzB4YTlTS2pPU3MrWmR0ajZTUkdpY21iUHphbkVqZWhEcTFZRXllbEprNU5B?=
 =?utf-8?B?SUNMU2JvVVk2RUFRTmFkcVZnNHpMenZ1TnNJbWJDejc0UG90eS9hc2ZES0l3?=
 =?utf-8?B?ckJ3WG4zcGFoQTBNNzloR1hOSFZWa2lxV0NLM1pFcGNMNkIxa21FRlNZOWZY?=
 =?utf-8?B?ZGtLckw4Q1dMZ01qRjBBWUdJNEV6TjMvckswcXJEQ2RUTlBLSmMvUXdYT2Nv?=
 =?utf-8?B?T1lld0lncTUzTFd4VlV5VG43TWJRSEtqU3lRZi9PcExwR0NFUk9kY0VtOWp4?=
 =?utf-8?B?OTAzajFlTjMxbitRZ2QxTzU4L01wc29oa3ZXbHVHMFhjWnRYVEN5QzcrR3d2?=
 =?utf-8?B?WWRiZjNxaWpUMjFIbGRUYktMdk9ZckdpV3EzK0VoNE1YekRLUHFKSSs4ci9i?=
 =?utf-8?B?bU5MRHRDVEFoOEg0TDFHb3YwWlJYTmRwd05FRGpjaDc4RHJ2QUY5alVnMk95?=
 =?utf-8?B?NUJ6MkdXZ3dkVEZ6Z2ViN1gxM0krcHBCNzQrWHFCaUdKOExXa0ptZVQrTitH?=
 =?utf-8?B?M3NyNkpDV0hhYVNkYzZOSExOb3gvU0x5NWJCQVhOd3hvTDZETzFDY2pHbDN5?=
 =?utf-8?B?VkZVUm8zR05kMmVXSXgyY3RnNUxYall1azhzVDdxeElHMEJGRDhWT3ZYc2hH?=
 =?utf-8?B?UlhyWElxK1RwQVRKMDNONjREWG1uNnV2bG9FY0ZjM3JUWHE1SElKMmFJUUR4?=
 =?utf-8?B?bkRXb09SbzAvRU5PSFd3TVpHeWJzdXJZTk5lSkZ0bWJnTW52VEZ0M2RmbHBO?=
 =?utf-8?B?UHJkdko1bWoxZGkyRjNPMTZlbVFRY1hobG11c1Bpc0YyVXNCTW1vNmY3MHpr?=
 =?utf-8?B?cUlMekhFaWUvSk5oZWVDeXlLV2h3ZVBUMytrOXEySENyYVo0UEJlYnZvd0c5?=
 =?utf-8?B?dzdmTXhKeWNKemFSaEJJdjJJd2Iyb3J0cVU0RE03cEczRDdwOGdzWnE2RGh4?=
 =?utf-8?B?bzhSRm9KV09ZN09rWUZ3b2FVeXltR2NhVEdaTGZLc2hvRE9GZ3JZc1lMS082?=
 =?utf-8?B?MXA2YnMrQ01uRSthcVVFSWFDZHRCTm56Vjg0bGlzTVZHZWxnSGlDRVlWOVNS?=
 =?utf-8?B?TXNYa1ZmU3ljTEhsclR6R2crN3orVkpDN2ZuOTNSbHpxREVHYThwZWVLMGdE?=
 =?utf-8?B?N2JnTGlWQVJseUhSWXNQWEZIZmg2ZFFyTlZ3SVZ1eEJ5c0ZuVmJVdGFvWHJm?=
 =?utf-8?B?RVVGdUwrTyt5MGphZjREbkxkamlubGpFaVVBUFJKRVdNbDJmaDk2UUVoY3l6?=
 =?utf-8?B?TUxrOEpqRkVuLzhWWVNxYTAyS1VZNG92d1E4UlI2S1lxbUhwQXhKVExTZGZD?=
 =?utf-8?B?ak9TcUxWZlVkeFpCbnFmYU04czdYNWVJd1ozcXNuVDFxeUMxV2M3R0JidHNQ?=
 =?utf-8?B?MEdsMHVkd0IzODVKUGJTZzZKbkhXektITjIxTGJEalhYWUNUbTRuM1hoMkkr?=
 =?utf-8?B?WENBY25LeHZGbHlMelNlcEJSNmRzeDY3d205VEJuOWpVeUZvOElWNmJTVHkw?=
 =?utf-8?B?OHdhVmViTVIwQ1IyMzAxZC9FekhKN1E5Rk12b24ydFRIaW5rWjg3VGM3SitQ?=
 =?utf-8?B?dEpWN3N3c2dqUE5aWERqUVFzM2VibVBSQytUMHJ5WDNUbHBIbWFJTElKMWhx?=
 =?utf-8?B?ejBvak91Z2dBRUxEdG5wcWh1dnhkYjk5bHpuMnZ0MDlySFBzK01LNml5dE1z?=
 =?utf-8?B?V21JcFBkc1VwTkYzM2Fmam1ycGk0bGJsalhoNjJ3ZjlmRVM2QlJTQ1RqRVJM?=
 =?utf-8?B?NG93cjl0OTdKNDlmUFZmSUxoTWRkQjdEYzRoa3VRV3Z1OXBDN3JZSFdCL05F?=
 =?utf-8?Q?xVra5xTigiw1dzrHGp2LgNnqN?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: dc72b058-9e07-420b-f2dd-08daf8c75985
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2023 20:13:51.0165
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7i5pQjc2oY140EatnU38OIMvzo4kVUnw+Wp5HSzUJnaLPMTMOfQaRy1ZkFjF4NA1lVHfAsbrSK17qxwc9wPm/Spxx/ZDNcXWl01Ws3+DEZc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1P189MB2012
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBQYWJsbyBOZWlyYSBBeXVzbyA8
cGFibG9AbmV0ZmlsdGVyLm9yZz4NCj4gU2VudDogVHVlc2RheSwgMTcgSmFudWFyeSAyMDIzIDEz
OjAyDQo+IFRvOiBTcmlyYW0gWWFnbmFyYW1hbiA8c3JpcmFtLnlhZ25hcmFtYW5AZXN0LnRlY2g+
DQo+IENjOiBuZXRmaWx0ZXItZGV2ZWxAdmdlci5rZXJuZWwub3JnOyBGbG9yaWFuIFdlc3RwaGFs
IDxmd0BzdHJsZW4uZGU+Ow0KPiBNYXJjZWxvIFJpY2FyZG8gTGVpdG5lciA8bWxlaXRuZXJAcmVk
aGF0LmNvbT47IExvbmcgWGluDQo+IDxseGluQHJlZGhhdC5jb20+OyBDbGF1ZGlvIFBvcmZpcmkg
PGNsYXVkaW8ucG9yZmlyaUBlcmljc3Nvbi5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMy8z
XSBuZXRmaWx0ZXI6IGNvbm50cmFjazogdW5pZnkgZXN0YWJsaXNoZWQgc3RhdGVzIGZvciBTQ1RQ
DQo+IHBhdGhzDQo+IA0KPiBPbiBUdWUsIEphbiAxNywgMjAyMyBhdCAxMjo1NDo0MFBNICswMTAw
LCBQYWJsbyBOZWlyYSBBeXVzbyB3cm90ZToNCj4gPiBPbiBNb24sIEphbiAxNiwgMjAyMyBhdCAx
MDozNTo1NkFNICswMTAwLCBTcmlyYW0gWWFnbmFyYW1hbiB3cm90ZToNCj4gPiA+IEFuIFNDVFAg
ZW5kcG9pbnQgY2FuIHN0YXJ0IGFuIGFzc29jaWF0aW9uIHRocm91Z2ggYSBwYXRoIGFuZCB0ZWFy
IGl0DQo+ID4gPiBkb3duIG92ZXIgYW5vdGhlciBvbmUuIFRoYXQgbWVhbnMgdGhlIGluaXRpYWwg
cGF0aCB3aWxsIG5vdCBzZWUgdGhlDQo+ID4gPiBzaHV0ZG93biBzZXF1ZW5jZSwgYW5kIHRoZSBj
b25udHJhY2sgZW50cnkgd2lsbCByZW1haW4gaW4NCj4gPiA+IEVTVEFCTElTSEVEIHN0YXRlIGZv
ciA1IGRheXMuDQo+ID4gPg0KPiA+ID4gQnkgbWVyZ2luZyB0aGUgSEVBUlRCRUFUX0FDS0VEIGFu
ZCBFU1RBQkxJU0hFRCBzdGF0ZXMgaW50byBvbmUNCj4gPiA+IEVTVEFCTElTSEVEIHN0YXRlLCB0
aGVyZSByZW1haW5zIG5vIGRpZmZlcmVuY2UgYmV0d2VlbiBhIHByaW1hcnkgb3INCj4gPiA+IHNl
Y29uZGFyeSBwYXRoLiBUaGUgdGltZW91dCBmb3IgdGhlIG1lcmdlZCBFU1RBQkxJU0hFRCBzdGF0
ZSBpcyBzZXQNCj4gPiA+IHRvDQo+ID4gPiAyMTAgc2Vjb25kcyAoaGJfaW50ZXJ2YWwgKiBtYXhf
cGF0aF9yZXRyYW5zICsgcnRvX21heCkuIFNvLCBldmVuIGlmDQo+ID4gPiBhIHBhdGggZG9lc24n
dCBzZWUgdGhlIHNodXRkb3duIHNlcXVlbmNlLCBpdCB3aWxsIGV4cGlyZSBpbiBhDQo+ID4gPiBy
ZWFzb25hYmxlIGFtb3VudCBvZiB0aW1lLg0KPiA+ID4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IFNy
aXJhbSBZYWduYXJhbWFuIDxzcmlyYW0ueWFnbmFyYW1hbkBlc3QudGVjaD4NCj4gPiA+IC0tLQ0K
PiA+ID4gIC4uLi91YXBpL2xpbnV4L25ldGZpbHRlci9uZl9jb25udHJhY2tfc2N0cC5oICB8ICA0
ICstDQo+ID4gPiAgLi4uL2xpbnV4L25ldGZpbHRlci9uZm5ldGxpbmtfY3R0aW1lb3V0LmggICAg
IHwgIDQgKy0NCj4gPiA+ICBuZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19wcm90b19zY3RwLmMg
ICAgICAgfCA5MCArKysrKysrKy0tLS0tLS0tLS0tDQo+ID4gPiAgbmV0L25ldGZpbHRlci9uZl9j
b25udHJhY2tfc3RhbmRhbG9uZS5jICAgICAgIHwgMTYgLS0tLQ0KPiA+ID4gIDQgZmlsZXMgY2hh
bmdlZCwgNDIgaW5zZXJ0aW9ucygrKSwgNzIgZGVsZXRpb25zKC0pDQo+ID4gPg0KPiA+ID4gZGlm
ZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9saW51eC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX3NjdHAu
aA0KPiA+ID4gYi9pbmNsdWRlL3VhcGkvbGludXgvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19zY3Rw
LmgNCj4gPiA+IGluZGV4IGM3NDI0NjlhZmUyMS4uMTUwZmMzYzA1NmVhIDEwMDY0NA0KPiA+ID4g
LS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L25ldGZpbHRlci9uZl9jb25udHJhY2tfc2N0cC5oDQo+
ID4gPiArKysgYi9pbmNsdWRlL3VhcGkvbGludXgvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19zY3Rw
LmgNCj4gPiA+IEBAIC0xNSw4ICsxNSw4IEBAIGVudW0gc2N0cF9jb25udHJhY2sgew0KPiA+ID4g
IAlTQ1RQX0NPTk5UUkFDS19TSFVURE9XTl9SRUNELA0KPiA+ID4gIAlTQ1RQX0NPTk5UUkFDS19T
SFVURE9XTl9BQ0tfU0VOVCwNCj4gPiA+ICAJU0NUUF9DT05OVFJBQ0tfSEVBUlRCRUFUX1NFTlQs
DQo+ID4gPiAtCVNDVFBfQ09OTlRSQUNLX0hFQVJUQkVBVF9BQ0tFRCwNCj4gPiA+IC0JU0NUUF9D
T05OVFJBQ0tfREFUQV9TRU5ULA0KPiA+ID4gKwlTQ1RQX0NPTk5UUkFDS19IRUFSVEJFQVRfQUNL
RUQsCS8qIG5vIGxvbmdlciB1c2VkICovDQo+ID4gPiArCVNDVFBfQ09OTlRSQUNLX0RBVEFfU0VO
VCwJLyogbm8gbG9uZ2VyIHVzZWQgKi8NCj4gPg0KPiA+IF9EQVRBX1NFTlQgd2FzIGFkZGVkIGlu
IHRoZSBwcmV2aW91cyBkZXZlbG9wbWVudCBjeWNsZSwgdG8gbXkNCj4gPiBrbm93bGVkZ2VkIGl0
IGhhcyBiZWVuIHByZXNlbnQgaW4gNi4xLXJjIG9ubHkuIFRoZW4gSSB0aGluayB5b3UgY2FuDQo+
IA0KPiBBY3R1YWxseSwgSSBtZWFuIDYuMi1yYyByZWxlYXNlcy4NCj4gDQo+ID4gcG9zdCBhIHBh
dGNoIHRvIHJldmVydCB0aGlzIGV4cGxhaW5pbmcgd2h5IHRoZXJlIGlzIG5vIG5lZWQgZm9yDQo+
ID4gX0RBVEFfU0VOVCBhbnltb3JlLiBZb3UgY2FuIHJldmVydCBpdCBiZWZvcmUgdGhpcyBwYXRj
aCAod2l0aCBteQ0KPiA+IHN1Z2dlc3Rpb24sIHlvdXIgc2VyaWVzIHdpbGwgY29udGFpbiB3aXRo
IDQgcGF0Y2hlcykuDQoNCkkgb25seSByZW1vdmVkIHRoZSBEQVRBX1NFTlQgc3RhdGUsIFNDVFAg
dHJhY2tlciBzdGlsbCByZWFjdHMgdG8gREFUQS9TQUNLIGNodW5rcyB0byBtb3ZlIHRvIEhFQVJU
QkVBVF9TRU5UIHN0YXRlLiBCdXQgSSByZWFsaXplIHRoYXQgcmVhY3RpbmcgdG8gREFUQS9TQUNL
IHdvcmtzIG9ubHkgZm9yIG5ldyBjb25uZWN0aW9ucywgd2hpbGUgb24gY29ubmVjdGlvbiByZS11
c2Ugd2Ugc3RpbGwgZGVwZW5kIG9uIEhFQVJUQkVBVCBmb3IgdGhlIHNlY29uZGFyeSBwYXRocy4g
UGVyaGFwcywgSSBzaG91bGQgcmV2ZXJ0IHRoZSB3aG9sZSBwYXRjaCBhcyB5b3Ugc3VnZ2VzdC4N
Cg0KPiA+DQo+ID4gT25lIHF1ZXN0aW9uIG9mIG1pbmU6IERpZCB5b3UgZXh0cmFjdCB0aGUgbmV3
IGVzdGFibGlzaGVkIHRpbWVvdXQgZnJvbQ0KPiA+IFJGQywgd2hlcmUgdGhpcyBmb3JtdWxhIGNh
bWUgZnJvbT8NCj4gPg0KPiA+IDIxMCBzZWNvbmRzID0gaGJfaW50ZXJ2YWwgKiBtYXhfcGF0aF9y
ZXRyYW5zICsgcnRvX21heA0KDQpUb29rIGl0IGZyb20gdGhlIEhFQVJUQkVBVF9BQ0tFRCBzdGF0
ZSB0aW1lb3V0LCBleHBsYWluZWQgaW4gdGhlIHBhdGNoIHRoYXQgaW50cm9kdWNlZCB0aGUgc3Rh
dGU6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8yMDE1MDcxNDEyMjMxMS44REE4RUEwQzlB
QHVuaWNvcm4uc3VzZS5jei8NCkFuIFNDVFAgZW5kcG9pbnQgd2lsbCByZXRyeSBhIHBhdGggZXZl
cnkgImhiX2ludGVydmFsIiBzZWNvbmRzIGZvciAibWF4X3BhdGhfcmV0cmFucyIgdGltZXMgd2l0
aCBhIHRpbWVvdXQgb2YgInJ0b19tYXgiLCBiZWZvcmUgdHJlYXRpbmcgaXQgYXMgdW5yZWFjaGFi
bGUuIFNvLCBJIGFtIGd1ZXNzaW5nIHRoYXQgaXMgdGhlIHNjaWVuY2UgYmVoaW5kIHRoZSBmb3Jt
dWxhLg0KDQo+ID4NCj4gPiBBbmQgdGhhbmtzLCBpZiB0aGlzIHdvcmtzIGZvciB5b3UsIEkgcHJl
ZmVyIHRoaXMgaW5jcmVtZW50YWwgYXBwcm9hY2gNCj4gPiBieSBpbXByb3ZpbmcgdGhlIGV4aXN0
aW5nIFNDVFAgdHJhY2tlci4NCg0KVGhhbmtzIGZvciB0YWtpbmcgdGhlIHRpbWUgdG8gcmV2aWV3
LiBJIHdpbGwgY29tZSBiYWNrIHdpdGggbW9yZSBpbXByb3ZlbWVudHMgb25jZSB0aGlzIHNlcmll
cyBpcyBhcHByb3ZlZCA6KQ0K
