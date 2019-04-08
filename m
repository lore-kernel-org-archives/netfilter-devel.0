Return-Path: <SRS0=Xgm7=SK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71A0CC10F13
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Apr 2019 23:17:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 253E8206BA
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Apr 2019 23:17:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=darbyshire-bryant.me.uk header.i=@darbyshire-bryant.me.uk header.b="LhLp8omc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfDHXRX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 19:17:23 -0400
Received: from mail-eopbgr80058.outbound.protection.outlook.com ([40.107.8.58]:63207
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726228AbfDHXRX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 19:17:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=darbyshire-bryant.me.uk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a7w7ktIef9v12fQSxE46JgHYUbPTpBJJe1FDP1hx2MY=;
 b=LhLp8omcPbLMsTXuqKijEt8zmSoxgP5BgeEp9GIjGDVKo7ouWrbLxGzwF3E/WmnhbYX3sWYosBhheF+9Hxt7TB3/wn1xpwXXlqgArXzvJ0Qsg9+m94rxsO+9ptn+ZXB93nZb+RZZ0EKTAq4i6nUjKmgviHeSEsiBQlTpgaV4gXY=
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com (10.171.105.143) by
 VI1PR0302MB2735.eurprd03.prod.outlook.com (10.171.105.140) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1771.19; Mon, 8 Apr 2019 23:16:38 +0000
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::b584:8ced:9d52:d88e]) by VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::b584:8ced:9d52:d88e%5]) with mapi id 15.20.1771.016; Mon, 8 Apr 2019
 23:16:38 +0000
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH 1/1] netfilter: connmark: introduce savedscp
Thread-Topic: [PATCH 1/1] netfilter: connmark: introduce savedscp
Thread-Index: AQHU4k0wbxhUbO7O10G3RjU1k8f4WaYy8x0AgAAKg4A=
Date:   Mon, 8 Apr 2019 23:16:38 +0000
Message-ID: <FEBDDE5A-DC07-4E41-84B3-C5033EB20CCE@darbyshire-bryant.me.uk>
References: <20190324142314.92539-1-ldir@darbyshire-bryant.me.uk>
 <20190324142314.92539-2-ldir@darbyshire-bryant.me.uk>
 <20190408223900.jizstw6bhjwt2w63@salvia>
In-Reply-To: <20190408223900.jizstw6bhjwt2w63@salvia>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ldir@darbyshire-bryant.me.uk; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2a02:c7f:1240:ee00::dc83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9ba70ad5-b105-498f-fce9-08d6bc7840ae
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600139)(711020)(4605104)(2017052603328)(7193020);SRVR:VI1PR0302MB2735;
x-ms-traffictypediagnostic: VI1PR0302MB2735:
x-microsoft-antispam-prvs: <VI1PR0302MB2735460D1E1C1F8E7D144CDDC92C0@VI1PR0302MB2735.eurprd03.prod.outlook.com>
x-forefront-prvs: 0001227049
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39830400003)(396003)(136003)(366004)(376002)(199004)(189003)(36756003)(8676002)(8936002)(97736004)(46003)(486006)(11346002)(305945005)(86362001)(25786009)(5660300002)(7736002)(74482002)(99286004)(6116002)(71190400001)(68736007)(446003)(476003)(2616005)(229853002)(6916009)(83716004)(6436002)(71200400001)(6486002)(76176011)(53936002)(82746002)(256004)(4326008)(6512007)(508600001)(14444005)(53546011)(6246003)(102836004)(186003)(81156014)(316002)(81166006)(106356001)(14454004)(105586002)(6506007)(2906002)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0302MB2735;H:VI1PR0302MB2750.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: darbyshire-bryant.me.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: S/ZhwJ95Zk/myJs0aKleuSs9cR3bvRL/AqEbso8vENb9deOxWi5KfZpUuvPY2r3L8+Yi7BcL1ZwLj4EiMdY2apTRtGPhXGtarPKy1l2lDjfJOkWHy7vy2oheX422S8Xq85HxCwX9YqFZNMSXMJPyJAMCKGSsjLc+5QielEz322+RpomGKtk54UVnwnLVtNHCyYmQleLRDQSXORakHc2FlyK2D6uDBR7taMJ/fbVXlGh3Qrm6hI9daSQ7sWWrwsROGtFqwRdOYiwG82KuDJ8rR5DFTPy7JcDwUxheqyXKyTbspHkSUQCSSQVy/rVHXtnTNmvNE479ScZTiNi1MWu1/ZPQhGGahx8I6b4qe1R4TOlvTpp1g4PdU2po8QVL4VxOU8epwtDg6Z+cIAruF4/uKOr1ssTKUwVuU10ISvinEVQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <98E6103444ECD5449670D932F7437462@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: darbyshire-bryant.me.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ba70ad5-b105-498f-fce9-08d6bc7840ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2019 23:16:38.5700
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9151708b-c553-406f-8e56-694f435154a4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB2735
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

DQoNCj4gT24gOCBBcHIgMjAxOSwgYXQgMjM6MzksIFBhYmxvIE5laXJhIEF5dXNvIDxwYWJsb0Bu
ZXRmaWx0ZXIub3JnPiB3cm90ZToNCj4gDQo+IEhpIEtldmluLA0KPiANCj4gT24gU3VuLCBNYXIg
MjQsIDIwMTkgYXQgMDI6MjM6NDVQTSArMDAwMCwgS2V2aW4gJ2xkaXInIERhcmJ5c2hpcmUtQnJ5
YW50IHdyb3RlOg0KPj4gc2F2ZWRzY3AgaXMgYSBtZXRob2Qgb2Ygc3RvcmluZyB0aGUgRFNDUCBv
ZiBhbiBpcCBwYWNrZXQgaW50byBjb25udHJhY2sNCj4+IG1hcmsuICBJbiBjb21iaW5hdGlvbiB3
aXRoIGEgc3VpdGFibGUgdGMgZmlsdGVyIGFjdGlvbiAoY29ubmRzY3AgYnV0IG1heQ0KPj4gZW5k
IHVwIGJlaW5nIGludGVncmF0ZWQgaW50byBjb25ubWFyaykgRFNDUCB2YWx1ZXMgYXJlIGFibGUg
dG8gYmUgc3RvcmVkDQo+PiBvbiBlZ3Jlc3MgYW5kIHJlc3RvcmVkIG9uIGluZ3Jlc3MgYWNyb3Nz
IGxpbmtzIHRoYXQgb3RoZXJ3aXNlIGFsdGVyIG9yDQo+PiBibGVhY2ggRFNDUC4NCj4+IA0KPj4g
VGhpcyBpcyB1c2VmdWwgZm9yIHFkaXNjcyBzdWNoIGFzIENBS0Ugd2hpY2ggYXJlIGFibGUgdG8g
c2hhcGUgYWNjb3JkaW5nDQo+PiB0byBwb2xpY2llcyBiYXNlZCBvbiBEU0NQLg0KPj4gDQo+PiBJ
bmdyZXNzIGNsYXNzaWZpY2F0aW9uIGlzIHRyYWRpdGlvbmFsbHkgYSBjaGFsbGVuZ2luZyB0YXNr
IHNpbmNlDQo+PiBpcHRhYmxlcyBydWxlcyBoYXZlbid0IHlldCBydW4gYW5kIHRjIGZpbHRlci9l
QlBGIHByb2dyYW1zIGFyZSBwcmUtTkFUDQo+PiBsb29rdXBzLCBoZW5jZSBhcmUgdW5hYmxlIHRv
IHNlZSBpbnRlcm5hbCBJUHY0IGFkZHJlc3NlcyBhcyB1c2VkIG9uIHRoZQ0KPj4gdHlwaWNhbCBo
b21lIG1hc3F1ZXJhZGluZyBnYXRld2F5Lg0KPj4gDQo+PiBUaGUgaW5ncmVzcyBwcm9ibGVtIGlz
IHNvbHZlZCBieSB0aGUgdGMgZmlsdGVyLCBidXQgdGhlIHRjIHBlb3BsZSBkaWRuJ3QNCj4+IGxp
a2UgdGhlIGlkZWEgb2YgdGMgc2V0dGluZyBjb25udHJhY2sgbWFyayB2YWx1ZXMsIHRob3VnaCB0
aGV5IGFyZSBvaw0KPj4gd2l0aCByZWFkaW5nIGNvbm50cmFjayB2YWx1ZXMgYW5kIGhlbmNlIHJl
c3RvcmluZyBEU0NQIGZyb20gY29ubnRyYWNrDQo+PiBtYXJrcy4NCj4+IA0KPj4geF90YWJsZXMg
Q09OTk1BUksgd2l0aCB0aGUgbmV3IHNhdmVkc2NwIGFjdGlvbiBzb2x2ZXMgdGhlIHByb2JsZW0g
b2YNCj4+IHN0b3JpbmcgdGhlIERTQ1AgdG8gdGhlIGNvbm50cmFjayBtYXJrLg0KPj4gDQo+PiBJ
dCBhY2NlcHRzIDIgcGFyYW1ldGVycy4gIFRoZSBtYXJrIGlzIGEgMzJiaXQgdmFsdWUgd2l0aCB1
c3VhbGx5IG9uZQ0KPj4gYml0IHNldC4gIFRoaXMgYml0IGlzIHNldCB3aGVuIHNhdmVkc2NwIHNh
dmVzIHRoZSBEU0NQIHRvIHRoZSBtYXJrLg0KPj4gVGhpcyBpcyB1c2VmdWwgdG8gaW1wbGVtZW50
IGEgJ29uZSBzaG90Jw0KPj4gaXB0YWJsZXMgYmFzZWQgY2xhc3NpZmljYXRpb24gd2hlcmUgdGhl
ICdjb21wbGljYXRlZCcgaXB0YWJsZXMgcnVsZXMgYXJlDQo+PiBvbmx5IHJ1biBvbmNlIHRvIGNs
YXNzaWZ5IHRoZSBjb25uZWN0aW9uIG9uIGluaXRpYWwgKGVncmVzcykgcGFja2V0IGFuZA0KPj4g
c3Vic2VxdWVudCBwYWNrZXRzIGFyZSBhbGwgbWFya2VkL3Jlc3RvcmVkIHdpdGggdGhlIHNhbWUg
RFNDUC4gIEEgbWFyaw0KPj4gb2YgemVybyBkaXNhYmxlcyB0aGUgc2V0dGluZyBvZiBhIHN0YXR1
cyBiaXQvcy4NCj4+IA0KPj4gVGhlIG1hc2sgaXMgYSAzMmJpdCB2YWx1ZSBvZiBhdCBsZWFzdCA2
IGNvbnRpZ3VvdXMgYml0cyBhbmQgcmVwcmVzZW50cw0KPj4gdGhlIGFyZWEgd2hlcmUgdGhlIERT
Q1Agd2lsbCBiZSBzdG9yZWQuDQo+PiANCj4+IGUuZy4NCj4+IA0KPj4gaXB0YWJsZXMgLUEgUU9T
X01BUktfZXRoMCAtdCBtYW5nbGUgLWogQ09OTk1BUksgLS1zYXZlZHNjcC1tYXJrIDB4MDEwMDAw
MDAvMHhmYzAwMDAwMA0KPj4gDQo+PiBXb3VsZCBzdG9yZSB0aGUgRFNDUCBpbiB0aGUgdG9wIDYg
Yml0cyBvZiB0aGUgMzJiaXQgbWFyayBmaWVsZCwgYW5kIHVzZQ0KPj4gdGhlIExTQiBvZiB0aGUg
dG9wIGJ5dGUgYXMgdGhlICdEU0NQIGhhcyBiZWVuIHN0b3JlZCcgbWFya2VyLg0KPiANCj4gSSdk
IHByZWZlciB3ZSBleHBsb3JlIGhvdyB0byBleHByZXNzIHRoaXMgaW4gbmZ0YWJsZXMsIEkgdGhp
bmsgdGhlDQo+IG1haW4gcHJvYmxlbSBoZXJlIGlzIHRoYXQgd2UgZG8gbm90IHN1cHBvcnQgZm9y
IGRhdGF0eXBlIGNvbXBhdGliaWxpdHkNCj4gLyBjYXN0aW5nIHlldCwgaGVuY2UgZHNjcCBjYW5u
b3QgYmUgYXNzaWduIHRvIHRoZSBtYXJrLiBCdXQgd2Ugb25seQ0KPiBuZWVkIHRvIHVwZGF0ZSB1
c2Vyc3BhY2UgY29kZSB0byBhY2hpZXZlIHRoaXMuDQo+IA0KPiBUaGFua3MuDQoNCkhpIFBhYmxv
LA0KDQpUaGFua3MgZm9yIGdldHRpbmcgYmFjayB0byBtZS4gIEkga25vdyBub3RoaW5nIG9mIG5m
dGFibGVzIHNvIHRoaXMgd2lsbCBiZQ0K4oCYaW50ZXJlc3RpbmfigJkuICBJIGhhdmUgYSB2MiBv
ZiB0aGUgcGF0Y2ggd2l0aCBhIHZlcnkgbWlub3IgdHdlYWsgdGhhdCBJIHdpbGwNCnNlbmQgdG9t
b3Jyb3cgYW5kIEkgYWxzbyBoYXZlIGEgdXNlcnNwYWNlIOKAmGlwdGFibGVz4oCZIHBhdGNoIHRo
YXQgc2hvd3MgdGhlDQp1c2VyIHNpZGUgb2YgdGhpbmdzIGlmIGl0IHdpbGwgaGVscC4NCg0KRm9y
IGF2b2lkYW5jZSBvZiBkb3VidCwgdGhlIHR3byB2YWx1ZXMgcGFzc2VkIGJ5IOKAlHNhdmVkc2Nw
LW1hcmsgYXJlIGJvdGgNCjMyIGJpdCBiaXQgbWFza3MuICBPbmUgbXVzdCBiZSBhIGNvbnRpZ3Vv
dXMgNiBiaXQgZmllbGQgYW5kIHNwZWNpZmllcyB3aGVyZQ0KaW4gdGhlIGNvbm5tYXJrIGZpZWxk
IHRvIHN0b3JlIHRoYXQgcGFja2V04oCZcyBEU0NQIHZhbHVlLiAgSXQgZG9lcyBub3Qgc3BlY2lm
eQ0KdGhlIERTQ1AgdmFsdWUgaXRzZWxmLg0KDQpUaGUgc2Vjb25kIHZhbHVlIGlzIGFnYWluICh1
c3VhbGx5KSBhIHNpbmdsZSBiaXQgbWFzayBhbmQgc3BlY2lmaWVzIGEgYml0IGluDQp0aGUgY29u
bm1hcmsgZmllbGQgdGhhdCBpcyBTRVQgYnkgdGhlIOKAlHNhdmVkc2NwLW1hcmsgYWN0aW9uLg0K
DQpuZnRhYmxlcyB1c2Vyc3BhY2UgbXVzdCBhbHJlYWR5IGhhdmUgYSBtZXRob2Qgb2YgcGFzc2lu
ZyAzMmJpdCBiaXRtYXNrcz8NCg0KZS5nLiBhIOKAmGRzY3BtYXNr4oCZIG9mIDB4ZmMwMDAwMDAg
c3BlY2lmaWVzIHRvIHN0b3JlIHRoZSBwYWNrZXTigJlzIGRzY3AgZmllbGQgaW4NCnRoZSB0b3Ag
NiBiaXRzIG9mIHRoZSBjb25udHJhY2sgY29ubm1hcms6DQoNCuKAlOKAlOKAlDB4RkPigJTigJTi
gJTigJTigJTigJTigJTigJTigJQwMDAwMDAwLeKAlA0KfFRPUCA2IGJpdHMgfCB+fn5+fn5+fn5+
fn5+DQrigJTigJTigJTigJTigJTigJTigJTigJTigJTigJTigJTigJTigJTigJTigJTigJTigJTi
gJTigJQNCg0KICAgIF4NCiAgICB8IHNoaWZ0ZWQgYXMgcmVxdWlyZWQNCiAgICDigJTigJTigJTi
gJQNCiAgICAgICAgfA0KLWRpZmZzZXJ2IGZpZWxkIC0NCnwgNiBiaXRzIERTQ1AgICB8DQotLS0t
LS0tLS0tLS0tLS0tLQ0KDQpIb3BlZnVsbHkgSSBoYXZlIG5vdCBtaXN1bmRlcnN0b29kIHlvdXIg
cG9pbnRzPyENCg0KDQpDaGVlcnMsDQoNCktldmluIEQtQg0KDQpncGc6IDAxMkMgQUNCMiAyOEM2
IEM1M0UgOTc3NSAgOTEyMyBCM0EyIDM4OUIgOURFMiAzMzRBDQoNCg==
