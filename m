Return-Path: <SRS0=Ro/3=TA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B760EC43219
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Apr 2019 20:41:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69ECB2080C
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Apr 2019 20:41:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=darbyshire-bryant.me.uk header.i=@darbyshire-bryant.me.uk header.b="WO/wa60k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfD3Ul2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Apr 2019 16:41:28 -0400
Received: from mail-eopbgr10084.outbound.protection.outlook.com ([40.107.1.84]:37701
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726166AbfD3Ul1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Apr 2019 16:41:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=darbyshire-bryant.me.uk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1FHsqVcOtA0U7rTFtbRiq0WNLWrextncgcMQ1N3g0IE=;
 b=WO/wa60kyO4wpU7dURzc/0EpAFDK3Ii/945g+5kEJhYQ3O1HhVSshNwNwE97l6U1djnrT5i2czghLlnC+YwI3QQ8PrySxqwJObWgpOKOGzPAOH31k6C94XVFDSYytNLc9FCxmtDmGfDOQJctiQuovkuY/RVG/JDjWA0lQL+2Fxs=
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com (10.171.105.143) by
 VI1PR0302MB3328.eurprd03.prod.outlook.com (52.134.13.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.14; Tue, 30 Apr 2019 20:40:41 +0000
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::b584:8ced:9d52:d88e]) by VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::b584:8ced:9d52:d88e%6]) with mapi id 15.20.1835.018; Tue, 30 Apr 2019
 20:40:41 +0000
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [RFC nf-next v2 1/2] netfilter: connmark: introduce savedscp
Thread-Topic: [RFC nf-next v2 1/2] netfilter: connmark: introduce savedscp
Thread-Index: AQHU7t/XZZNa/M1kFUOfQp3g6ArKE6ZUwuOAgACJTwA=
Date:   Tue, 30 Apr 2019 20:40:41 +0000
Message-ID: <5E006285-FB1F-4948-87BE-BD1B8D0321E2@darbyshire-bryant.me.uk>
References: <FEBDDE5A-DC07-4E41-84B3-C5033EB20CCE@darbyshire-bryant.me.uk>
 <20190409142333.68403-1-ldir@darbyshire-bryant.me.uk>
 <20190409142333.68403-2-ldir@darbyshire-bryant.me.uk>
 <20190430122913.lyz7qjh5eebx7lpk@salvia>
In-Reply-To: <20190430122913.lyz7qjh5eebx7lpk@salvia>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ldir@darbyshire-bryant.me.uk; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2a02:c7f:1240:ee00::dc83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1ae21f44-d116-4c8e-3eeb-08d6cdac1c5f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:VI1PR0302MB3328;
x-ms-traffictypediagnostic: VI1PR0302MB3328:
x-microsoft-antispam-prvs: <VI1PR0302MB3328C641DB4DDBF1B46F51B5C93A0@VI1PR0302MB3328.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 00235A1EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39830400003)(136003)(366004)(376002)(396003)(199004)(189003)(6486002)(305945005)(14454004)(7736002)(53936002)(53546011)(6506007)(102836004)(6512007)(99286004)(256004)(508600001)(8936002)(229853002)(5660300002)(14444005)(82746002)(68736007)(71190400001)(8676002)(6436002)(71200400001)(36756003)(81156014)(81166006)(86362001)(83716004)(446003)(476003)(186003)(2616005)(2906002)(33656002)(25786009)(6246003)(97736004)(64756008)(91956017)(73956011)(76116006)(46003)(74482002)(11346002)(316002)(66476007)(66556008)(76176011)(6916009)(66446008)(6116002)(66946007)(93886005)(4326008)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0302MB3328;H:VI1PR0302MB2750.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: darbyshire-bryant.me.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: u4llfop2oYTS6g47Pu4glwbw14I8zolprdbE5+siyr4ZGeN44tM1weQ9iTr/shboWYDMc7ujM168S6QPS+U1z00G4NNyN0VP229NxHHnkFaouKDtO5TKkwUNX2M9IwohtjCYPnApv65JeRQjH+EVT3gGgtsjfcm6/+Ss+aKnB05zKKxQiP5EWJYtDjrPcvc2v67qFngMHItICMXOMqf2Goq88fom/AJxOOV//rDPrWmtqUoBGG6Zey6jX5gicn4EzpL7d51L3zxRxQwbkreLlvB4ytxkExsjOJlipKixTQbpjVfmA5auaA50ZOViqXcMpwoq4j7rJHdNtJ+h1sXRBTeV1aH1MP4FtjcNFcjzdn3vyDr0gU+E1tr7T2ePHi3qonZQOdRsiLlEpWSErG5OJjNV3OsTdzivBvXDIrvc4X4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2BDF19D73EF0C24BB236D662D119F255@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: darbyshire-bryant.me.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ae21f44-d116-4c8e-3eeb-08d6cdac1c5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2019 20:40:41.2466
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9151708b-c553-406f-8e56-694f435154a4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB3328
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGkgUGFibG8sDQoNClRoYW5rcyBmb3IgcmV2aWV3LiAgU29tZSBhbnN3ZXJzIGlubGluZQ0KDQo+
IE9uIDMwIEFwciAyMDE5LCBhdCAxMzoyOSwgUGFibG8gTmVpcmEgQXl1c28gPHBhYmxvQG5ldGZp
bHRlci5vcmc+IHdyb3RlOg0KPiANCj4gT24gVHVlLCBBcHIgMDksIDIwMTkgYXQgMDI6MjM6NDZQ
TSArMDAwMCwgS2V2aW4gJ2xkaXInIERhcmJ5c2hpcmUtQnJ5YW50IHdyb3RlOg0KPj4gZGlmZiAt
LWdpdCBhL2luY2x1ZGUvdWFwaS9saW51eC9uZXRmaWx0ZXIveHRfY29ubm1hcmsuaCBiL2luY2x1
ZGUvdWFwaS9saW51eC9uZXRmaWx0ZXIveHRfY29ubm1hcmsuaA0KPj4gaW5kZXggMWFhNWM5NTVl
ZTFlLi4yNDI3MmNhYzJkMzcgMTAwNjQ0DQo+PiAtLS0gYS9pbmNsdWRlL3VhcGkvbGludXgvbmV0
ZmlsdGVyL3h0X2Nvbm5tYXJrLmgNCj4+ICsrKyBiL2luY2x1ZGUvdWFwaS9saW51eC9uZXRmaWx0
ZXIveHRfY29ubm1hcmsuaA0KPj4gQEAgLTE2LDcgKzE2LDggQEANCj4+IGVudW0gew0KPj4gCVhU
X0NPTk5NQVJLX1NFVCA9IDAsDQo+PiAJWFRfQ09OTk1BUktfU0FWRSwNCj4+IC0JWFRfQ09OTk1B
UktfUkVTVE9SRQ0KPj4gKwlYVF9DT05OTUFSS19SRVNUT1JFLA0KPj4gKwlYVF9DT05OTUFSS19T
QVZFRFNDUA0KPiANCj4gSSdkIHByZWZlciB5b3UgaW1wbGVtZW50IHRoaXMgaW4gbmZ0YWJsZXMs
IG1vcmUgY29tbWVudHMgYmVsb3cuDQoNCkkgd2lsbCBsb29rIGludG8gdGhpcy4gbmZ0YWJsZXMg
aXMgbmV3IHRvIG1lLg0KDQo+IA0KPj4gfTsNCj4+IA0KPj4gZW51bSB7DQo+PiBkaWZmIC0tZ2l0
IGEvbmV0L25ldGZpbHRlci94dF9jb25ubWFyay5jIGIvbmV0L25ldGZpbHRlci94dF9jb25ubWFy
ay5jDQo+PiBpbmRleCAyOWMzOGFhN2Y3MjYuLjZjNjNjZjQ3NjM0MiAxMDA2NDQNCj4+IC0tLSBh
L25ldC9uZXRmaWx0ZXIveHRfY29ubm1hcmsuYw0KPj4gKysrIGIvbmV0L25ldGZpbHRlci94dF9j
b25ubWFyay5jDQo+PiBAQCAtNDIsNiArNDIsNyBAQCBjb25ubWFya190Z19zaGlmdChzdHJ1Y3Qg
c2tfYnVmZiAqc2tiLCBjb25zdCBzdHJ1Y3QgeHRfY29ubm1hcmtfdGdpbmZvMiAqaW5mbykNCj4+
IAl1X2ludDMyX3QgbmV3X3RhcmdldG1hcms7DQo+PiAJc3RydWN0IG5mX2Nvbm4gKmN0Ow0KPj4g
CXVfaW50MzJfdCBuZXdtYXJrOw0KPj4gKwl1OCBkc2NwOw0KPj4gDQo+PiAJY3QgPSBuZl9jdF9n
ZXQoc2tiLCAmY3RpbmZvKTsNCj4+IAlpZiAoY3QgPT0gTlVMTCkNCj4+IEBAIC03NCw2ICs3NSwz
NCBAQCBjb25ubWFya190Z19zaGlmdChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBjb25zdCBzdHJ1Y3Qg
eHRfY29ubm1hcmtfdGdpbmZvMiAqaW5mbykNCj4+IAkJCW5mX2Nvbm50cmFja19ldmVudF9jYWNo
ZShJUENUX01BUkssIGN0KTsNCj4+IAkJfQ0KPj4gCQlicmVhazsNCj4+ICsJY2FzZSBYVF9DT05O
TUFSS19TQVZFRFNDUDoNCj4gDQo+IENvdWxkIHlvdSBhZGQgYSBuZXcgcmV2aXNpb24gYW5kIGEg
bmV3IGZsYWcgZmllbGQgZm9yIHRoaXM/IHNvIGl0IGp1c3QNCj4gYWRkcyB0aGUgZHNjcCB0byB0
aGUgbWFyayBhcyB5b3UgbmVlZC4NCg0KTm90IHN1cmUgSSB1bmRlcnN0YW5kIHRoaXMuICBEbyB5
b3UgbWVhbiBtYWtlIGl0IHBhcnQgb2YgWFRfQ09OTk1BUktfU0FWRQ0KYW5kIGhhdmUgc29tZXRo
aW5nIGxpa2Ug4oCYaW5mby0+ZHNjcG1hc2vigJk/ICBJZiAoIWluZm8tPmRzY3BtYXNrKSBkbyBk
c2NwDQpzdHVmZiBlbHNlIGRvIHRoZSBvcmlnaW5hbCByb3V0aW5lPw0KDQo+IA0KPj4gKwkJaWYg
KCFpbmZvLT5jdG1hcmspDQo+PiArCQkJZ290byBvdXQ7DQo+PiArDQo+PiArCQlpZiAoc2tiLT5w
cm90b2NvbCA9PSBodG9ucyhFVEhfUF9JUCkpIHsNCj4+ICsJCQlpZiAoc2tiLT5sZW4gPCBzaXpl
b2Yoc3RydWN0IGlwaGRyKSkNCj4+ICsJCQkJZ290byBvdXQ7DQo+PiArDQo+PiArCQkJZHNjcCA9
IGlwdjRfZ2V0X2RzZmllbGQoaXBfaGRyKHNrYikpID4+IDI7DQo+PiArDQo+PiArCQl9IGVsc2Ug
aWYgKHNrYi0+cHJvdG9jb2wgPT0gaHRvbnMoRVRIX1BfSVBWNikpIHsNCj4+ICsJCQlpZiAoc2ti
LT5sZW4gPCBzaXplb2Yoc3RydWN0IGlwdjZoZHIpKQ0KPj4gKwkJCQlnb3RvIG91dDsNCj4gDQo+
IFRoaXMgaXMgYWxyZWFkeSBndWFyYW50ZWVkIHRvIGhhdmUgYSB2YWxpZCBJUCBoZWFkZXIgaW4g
cGxhY2UsIG5vIG5lZWQNCj4gZm9yIHRoaXMgY2hlY2suDQoNCk9rLCB0aGFua3MgLSByZW1vdmlu
ZyBjb2RlIGlzIGVhc3kgKGFuZCBmYXN0ZXIpIDotKQ0KDQpPbmNlIGFnYWluIHRoYW5rcyBmb3Ig
eW91ciByZXZpZXcgJiB0aW1lLg0KDQo+IA0KPj4gKw0KPj4gKwkJCWRzY3AgPSBpcHY2X2dldF9k
c2ZpZWxkKGlwdjZfaGRyKHNrYikpID4+IDI7DQo+PiArDQo+PiArCQl9IGVsc2UgeyAvKiBwcm90
b2NvbCBkb2Vzbid0IGhhdmUgZGlmZnNlcnYgLSBnZXQgb3V0ISAqLw0KPj4gKwkJCWdvdG8gb3V0
Ow0KPj4gKwkJfQ0KPj4gKw0KPj4gKwkJbmV3bWFyayA9IChjdC0+bWFyayAmIH5pbmZvLT5jdG1h
cmspIF4NCj4+ICsJCQkgIChpbmZvLT5jdG1hc2sgfCAoZHNjcCA8PCBpbmZvLT5zaGlmdF9iaXRz
KSk7DQo+PiArDQo+PiArCQlpZiAoY3QtPm1hcmsgIT0gbmV3bWFyaykgew0KPj4gKwkJCWN0LT5t
YXJrID0gbmV3bWFyazsNCj4+ICsJCQluZl9jb25udHJhY2tfZXZlbnRfY2FjaGUoSVBDVF9NQVJL
LCBjdCk7DQo+PiArCQl9DQo+PiArCQlicmVhazsNCj4+IAljYXNlIFhUX0NPTk5NQVJLX1JFU1RP
UkU6DQo+PiAJCW5ld190YXJnZXRtYXJrID0gKGN0LT5tYXJrICYgaW5mby0+Y3RtYXNrKTsNCj4+
IAkJaWYgKGluZm8tPnNoaWZ0X2RpciA9PSBEX1NISUZUX1JJR0hUKQ0KPj4gQEAgLTg2LDYgKzEx
NSw3IEBAIGNvbm5tYXJrX3RnX3NoaWZ0KHN0cnVjdCBza19idWZmICpza2IsIGNvbnN0IHN0cnVj
dCB4dF9jb25ubWFya190Z2luZm8yICppbmZvKQ0KPj4gCQlza2ItPm1hcmsgPSBuZXdtYXJrOw0K
Pj4gCQlicmVhazsNCj4+IAl9DQo+PiArb3V0Og0KPj4gCXJldHVybiBYVF9DT05USU5VRTsNCj4+
IH0NCj4+IA0KPj4gLS0gDQo+PiAyLjIwLjEgKEFwcGxlIEdpdC0xMTcpDQo+PiANCg0KDQpDaGVl
cnMsDQoNCktldmluIEQtQg0KDQpncGc6IDAxMkMgQUNCMiAyOEM2IEM1M0UgOTc3NSAgOTEyMyBC
M0EyIDM4OUIgOURFMiAzMzRBDQoNCg==
