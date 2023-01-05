Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C77E3C3DA7D
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Jan 2023 12:11:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbjAEMLu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Jan 2023 07:11:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232901AbjAEMLs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Jan 2023 07:11:48 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2108.outbound.protection.outlook.com [40.107.249.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0418958D0B
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Jan 2023 04:11:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CMe/ncTVJLNZyzektF7+msOAzs0MNjvzpmwb/LLVuC7ys+wOlk3JDG2VLC0vm6oCQnz5L462sMwedXV4fZVNSd/KQQAwKgDK0Jm2GJBr3EYnjNDfTpwx7BWC0ajmCYEhi+khB6o83EQ2sqxbeBA4oV4z6PaJpI0/OwRj04Kzgs24Sy2iaE/Df5vzxropcS+WBzSs0sBW2RVc+sGC40PERyvuXA9jnDimogRNqSIoHDDXvfndMiVoSljcKh8720lMhVrJq/z5Jr3/bgzrNe4mlbGgWvzJ2O7UglM2b0tC2asuvCMd2n9EDS539iG+oF/B8e/0PgVAb+74KjPx/d+Egg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Frx2TdjOIDFiNW8gKjLfL9D7J/mjFsa6vIwOq5aMj8A=;
 b=WW7U05xMXiH3BftvU5q77+BrI36Y691f1q7w4VP3TFKSlalQTJKVES9oZtLivqgVofD5jbJW00AkFHBGOAukFehIx5I8paG1rte6CJLnmWmj15b+7WrO084BOCfnELaxXSDUFl3CDfYA8Sq4tUAMQjymXxTKhW2DsDgjrEG9zm3rdZ32Mduqp/aZzIkBeRxkQn6lLs8mm7+KspT+faCgn9A727u2FDATJrQ5eVNFiOoi5346JAsCkgcIHh/mCkwTeeKoitwQolcYdrcj8KZEeCOEuL8jkFpvH8OX1adpNMH8DZBEQCpiuzIwQO+q3FJeBa1YF4wLU8/FqUdi4IoU+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Frx2TdjOIDFiNW8gKjLfL9D7J/mjFsa6vIwOq5aMj8A=;
 b=cL6htheJpe8IRDcKYLOa0ZijmkNYiuaVlZMll8yHOsmEEdzrZ+LQE9amcr3h7qCNhMqZ9E+ItmuOpO4y403A7ZzqTltxFOs0AnlWmUhoCKqCJ17UXKZjPzfOZ/dNoiCOVfq9d/wMvWL/bIjKaZWUfdkp7drBFujxv0rLU2P/+nI=
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by AS4P189MB1919.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:4b7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.7; Thu, 5 Jan
 2023 12:11:44 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420%3]) with mapi id 15.20.5986.009; Thu, 5 Jan 2023
 12:11:44 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Long Xin <lxin@redhat.com>,
        Claudio Porfiri <claudio.porfiri@ericsson.com>
Subject: RE: [RFC PATCH] netfilter: conntrack: simplify sctp state machine
Thread-Topic: [RFC PATCH] netfilter: conntrack: simplify sctp state machine
Thread-Index: AQHZIDEXupmbZt3GPUa7TaBi/McYSK6OWrgAgAFXCcCAAAamAIAAAT6w
Date:   Thu, 5 Jan 2023 12:11:44 +0000
Message-ID: <DBBP189MB14337144265DA856B8321D1695FA9@DBBP189MB1433.EURP189.PROD.OUTLOOK.COM>
References: <20230104113143.21769-1-sriram.yagnaraman@est.tech>
 <Y7WVAEky9Iy3Ri3T@salvia>
 <DBBP189MB1433F79520D32E1CB0F8A62A95FA9@DBBP189MB1433.EURP189.PROD.OUTLOOK.COM>
 <Y7a6VqqMmW191RIG@salvia>
In-Reply-To: <Y7a6VqqMmW191RIG@salvia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DBBP189MB1433:EE_|AS4P189MB1919:EE_
x-ms-office365-filtering-correlation-id: e61ca123-19e0-494b-5887-08daef160310
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J6HZM2rR+XU2bKyBnAiHAhB5UfXBIGvTTkwUeVQ8o80TyZAuZASpO6cnSIeWHbw/UA9FWqnBG9SjLKQ0tV8j2ScFZjGpjHz5QirL2khM59uUFF0krC0qOjwhgcMZR10qoByXQkSFrXByrxBCPsUEglvjMuPLV7jKG2VdcbQd8lDkYDBTTMnaz1ENsFGtBFHM6iPBXu/oKcGwKvfWz03Lcj71FTXg17Q15w7lqjqQOzSo/WOqHbDCfdZxC+tBd+yZAXdaGWrR9g3tjsQwW+bpm3pdEo3GPT9zgJrWG+ieFousZgv1oYF5Ds2/W2ugF28yfCriOv717Cik3MjMO1hJQh1CWSn0Qlh1ARm6NGCMkiGKkeKw61L7s5yM89sWYShWZlYYJc2b+d/rcOedVgH//NVeeBQ2JWYZQkbcp26HzyjBkP3sNWsXgJHZcq3j9xzpkEfbgqAjRbxZHjfc4bHgG0I0fBm4D3imCZaGd3lv6gtSxMLLl0L29hst9/SnZ17xCdCGSLR7a/wEnjW5G1BqEEc8mrm1vue7+dP4oO/mWbKJSgqGb7fYzw+mRLBeDu+w04v6Bse9H+rNORVNbsaVsd1OtowWJQEgf/kPQgjp2b8dxMgIkPmBWpbwSuQal68qqmJbAWZJwPsopF87q3XxjQ7v7kPRXpSSd+F2iE2XNvhdOR5YYJ0kp/4lUeBvMTe4h5R+jRZu8rbCxZGl3E6k7w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(39840400004)(376002)(136003)(366004)(396003)(346002)(451199015)(122000001)(86362001)(38100700002)(33656002)(83380400001)(44832011)(4326008)(5660300002)(52536014)(38070700005)(2906002)(8936002)(8676002)(64756008)(76116006)(66446008)(66556008)(66946007)(66476007)(7696005)(66574015)(41300700001)(55016003)(478600001)(26005)(6506007)(186003)(9686003)(53546011)(6916009)(54906003)(316002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Szc5L0ZlZ2ltaFhGVmtuMFh5NmhvQmc4ZHNDbGhoT0Z4allpVG5YZVdYZnZo?=
 =?utf-8?B?VncvQmZQN2Z5N1VoQ2sxalkyY2cvdmlrQ0RsYXd3Q0RDWk1TZnNVUTZIdGM1?=
 =?utf-8?B?TnZFMmJOeVZrMWdhZjVCdnY3VmFTL3NNaGE2TXowRHNVbkJZRXU0RGFmLytM?=
 =?utf-8?B?UWlQTllQV1dJYlc1dlpCaitJZDhzMVNZVzFPK3hIcmcra1NNZEo4RmNOa0Jv?=
 =?utf-8?B?S0F2NEtWL2VPQkZLQ055SEs5UFlIRkptcDlMdXJiT3ZNNDRFZFhEVjVWVVNP?=
 =?utf-8?B?Y0Vhb1RzcXpXWWFWdU1QcDlPZE9UeFhUY0I0VVdPVWZsYkNmZmM0K2x1TVQ2?=
 =?utf-8?B?K1JYVCtSVkp6TFNHRkc5ZE5ncXg1RVNxdmcxTm9LcmJTYWIwd0lXSmg4bHFL?=
 =?utf-8?B?RW5NSUJoZ2M3S3F2Zks1M2g4V3YvMWx4eDRhWm1EdW4waEtBS1NlbTZxeXlH?=
 =?utf-8?B?dnM3VklFK242Rnc2NGoyL0ZudUR1bExjWlc5YWVoQkUyZVMrM2xPWGxhNUZu?=
 =?utf-8?B?UzdsZThLQ0xPb2Vmc0dBc0p6eUl3dXgzd2hpMERXVFIwWlVuMFpxd0RHTHVJ?=
 =?utf-8?B?cEh5aUZxMG1xUzBpN1pobjZSVlZnLzRxZ0M0a2wvbzh2N3JJeTdkWTVHM3I3?=
 =?utf-8?B?OGxWazcreEZFaXlmU1pWKzRCN3FveisvaEdwd1h2RFNwLzRNcVFHR1lqVGF2?=
 =?utf-8?B?TGNMcThCbmdBakZLRHdtMEdQZHBwTXhNNlRLcm5qQkFZNHZNRDRrRUZRWjIr?=
 =?utf-8?B?cUFMTHg5SjkwL3BmK25jTjZvT3BIM1I2RnpxQWN5U3F6YjQxaFlIallXeHBQ?=
 =?utf-8?B?Y3NIVUp6aXJDeTBvMk50T1JlQUo3TGw4ck12ZFBSeHZwS2t0UlBSeUV3YmlF?=
 =?utf-8?B?WDhrREltQ1RqSGVsbWw5UkdkRHUzSUN5T0RIeGJvbklFcjhIOTk1L1NuMW91?=
 =?utf-8?B?NGt1YWZjZUVhUjVQL3N2UDB0MmZVb0loU0pmeGwxMDJMNEVMSzZuc2RYdVNa?=
 =?utf-8?B?R1liQlk2a1BkYzRTaHBoVDZRcmtBcnVZVGlKVGpEbjk4eFVvSCtjd1JhUSt0?=
 =?utf-8?B?cCtuU041TnJuQUs1SDJXN2hvSzR4ck5yYXB0WTZ5YmlFVlJWdENJS1paYlkw?=
 =?utf-8?B?YkRhMlgzUnFVSWJsR0VtWmcxU3RPMDBQWkZ1dCtPQk1lSlR0VDFzdk5zVVlF?=
 =?utf-8?B?NDFYSTFoRU9OTmtMWUdxQktEUEpPVnRjeWd3ekhSblNEQXR1MUdxaEFXcnFI?=
 =?utf-8?B?SWx4WGlEV0hPNHpKY1p1ZVJQWURpSnpldUNndEljNyt4SWNhSFFpdlpqN1Av?=
 =?utf-8?B?dStYd3JjazRzdnRCMlRpRWlXVExwbUcwQnBGbFRjdTVSeWkvVk1YYkMya0Rj?=
 =?utf-8?B?dTdSRGpsb2FQalZjU2JIVmpYd1g1ZjdTRWp5YUlhU0pyVy9NWFhWdzFpemsw?=
 =?utf-8?B?dTFPOTBaVTZsYkUyclhmTVVmSzh6dm1NMDRxUUptZGNRTTRhcUU5aXBkaFlm?=
 =?utf-8?B?aStmN2IyOWlDR3N4TTI0R1BjT05WMmRxaTROdWJCSFJ1WkhINVdyMVVwWUsr?=
 =?utf-8?B?T0k1YW9tZGk4RjR1YnBjdisvTm45ajdhVmNIWkQzaDk2VEJSLzlvWFpQT3Jr?=
 =?utf-8?B?MEFJU0VQNlJKc1Zxd3BmMjYvcGkva3FGZ0RoOVBRdXpNajFYbUJuTCtSMWNw?=
 =?utf-8?B?ZkpGT1B0WDBqTDJXMjFVdkNzZmx4K0IzZnpCRXM4cGRFRGJ2b2l5cFVkR0dw?=
 =?utf-8?B?K25OeDVCSzY4TGF6N1pIazRNTkdLNncwZ3hJZGQyUmsrQUN5VDBIRm5HajB2?=
 =?utf-8?B?ZHBsUXRRUDh4aDJOS3ZBdkxCV0VDdVAwdFJ4a2poVzZqT1AvTGsrdFJ0a1M3?=
 =?utf-8?B?WEl6Tzh4eEJXTGRxelUrKzlnOTV1SiswV25DbDR6WE13Qk5KY29oZytBVS9R?=
 =?utf-8?B?N29xc29ncHRrcHo3S1dScXVmKysvK3UrWS9PcFVZZWJVRDhzbGlROTB1MCtk?=
 =?utf-8?B?UlhGc0NnSERlbzVxN3FKTmxMY2hQN1I2UkkzczhoM0JVMDBlMzFHc3p0NXBN?=
 =?utf-8?B?Ykx3UEJBbHhDT1hVWkREb2tkOXRvWnVGN1VVcmw1dVhBZ043Vnk2SmhDeHkz?=
 =?utf-8?Q?zFaqmInpMZ62mUTgYFqyPA9jq?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: e61ca123-19e0-494b-5887-08daef160310
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2023 12:11:44.5431
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: haRJ9baBG2NM38V4CBB4xwnH8LC104m2sVsgy0iEUHbfAOLS0z6Pmyy6uxqJvl2doEEjIrwRz2xm14l0VBRgWl29JzQ9I3kgs3qQ3YTLWZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4P189MB1919
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBQYWJsbyBOZWlyYSBBeXVzbyA8
cGFibG9AbmV0ZmlsdGVyLm9yZz4NCj4gU2VudDogVGh1cnNkYXksIDUgSmFudWFyeSAyMDIzIDEy
OjU0DQo+IFRvOiBTcmlyYW0gWWFnbmFyYW1hbiA8c3JpcmFtLnlhZ25hcmFtYW5AZXN0LnRlY2g+
DQo+IENjOiBuZXRmaWx0ZXItZGV2ZWxAdmdlci5rZXJuZWwub3JnOyBGbG9yaWFuIFdlc3RwaGFs
IDxmd0BzdHJsZW4uZGU+Ow0KPiBNYXJjZWxvIFJpY2FyZG8gTGVpdG5lciA8bWxlaXRuZXJAcmVk
aGF0LmNvbT47IExvbmcgWGluDQo+IDxseGluQHJlZGhhdC5jb20+OyBDbGF1ZGlvIFBvcmZpcmkg
PGNsYXVkaW8ucG9yZmlyaUBlcmljc3Nvbi5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUkZDIFBBVENI
XSBuZXRmaWx0ZXI6IGNvbm50cmFjazogc2ltcGxpZnkgc2N0cCBzdGF0ZSBtYWNoaW5lDQo+IA0K
PiBPbiBUaHUsIEphbiAwNSwgMjAyMyBhdCAxMTo0MToxM0FNICswMDAwLCBTcmlyYW0gWWFnbmFy
YW1hbiB3cm90ZToNCj4gPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gPiBGcm9t
OiBQYWJsbyBOZWlyYSBBeXVzbyA8cGFibG9AbmV0ZmlsdGVyLm9yZz4NCj4gPiA+IFNlbnQ6IFdl
ZG5lc2RheSwgNCBKYW51YXJ5IDIwMjMgMTY6MDINCj4gPiA+IFRvOiBTcmlyYW0gWWFnbmFyYW1h
biA8c3JpcmFtLnlhZ25hcmFtYW5AZXN0LnRlY2g+DQo+ID4gPiBDYzogbmV0ZmlsdGVyLWRldmVs
QHZnZXIua2VybmVsLm9yZzsgRmxvcmlhbiBXZXN0cGhhbA0KPiA+ID4gPGZ3QHN0cmxlbi5kZT47
IE1hcmNlbG8gUmljYXJkbyBMZWl0bmVyIDxtbGVpdG5lckByZWRoYXQuY29tPjsgTG9uZw0KPiA+
ID4gWGluIDxseGluQHJlZGhhdC5jb20+DQo+ID4gPiBTdWJqZWN0OiBSZTogW1JGQyBQQVRDSF0g
bmV0ZmlsdGVyOiBjb25udHJhY2s6IHNpbXBsaWZ5IHNjdHAgc3RhdGUNCj4gPiA+IG1hY2hpbmUN
Cj4gPiA+DQo+ID4gPiBPbiBXZWQsIEphbiAwNCwgMjAyMyBhdCAxMjozMTo0M1BNICswMTAwLCBT
cmlyYW0gWWFnbmFyYW1hbiB3cm90ZToNCj4gPiA+ID4gQWxsIHRoZSBwYXRocyBpbiBhbiBTQ1RQ
IGNvbm5lY3Rpb24gYXJlIGtlcHQgYWxpdmUgZWl0aGVyIGJ5DQo+ID4gPiA+IGFjdHVhbCBEQVRB
L1NBQ0sgcnVubmluZyB0aHJvdWdoIHRoZSBjb25uZWN0aW9uIG9yIGJ5IEhFQVJUQkVBVC4NCj4g
PiA+ID4gVGhpcyBwYXRjaCBwcm9wb3NlcyBhIHNpbXBsZSBzdGF0ZSBtYWNoaW5lIHdpdGggb25s
eSB0d28gc3RhdGVzDQo+ID4gPiA+IE9QRU5fV0FJVCBhbmQgRVNUQUJMSVNIRUQgKHNpbWlsYXIg
dG8gVURQKS4gVGhlIHJlYXNvbiBmb3IgdGhpcw0KPiA+ID4gPiBjaGFuZ2UgaXMgYSBmdWxsIHN0
YXRlZnVsIGFwcHJvYWNoIHRvIFNDVFAgaXMgZGlmZmljdWx0IHdoZW4gdGhlDQo+ID4gPiA+IGFz
c29jaWF0aW9uIGlzIG11bHRpaG9tZWQgc2luY2UgdGhlIGVuZHBvaW50cyBjb3VsZCB1c2UgZGlm
ZmVyZW50DQo+ID4gPiA+IHBhdGhzIGluIHRoZSBuZXR3b3JrIGR1cmluZyB0aGUgbGlmZXRpbWUg
b2YgYW4gYXNzb2NpYXRpb24uDQo+ID4gPg0KPiA+ID4gRG8geW91IG1lYW4gdGhlIHJvdXRlci9m
aXJld2FsbCBtaWdodCBub3Qgc2VlIGFsbCBwYWNrZXRzIGZvcg0KPiA+ID4gYXNzb2NpYXRpb24g
aXMgbXVsdGlob21lZD8NCj4gPiA+DQo+ID4gPiBDb3VsZCB5b3UgcGxlYXNlIHByb3ZpZGUgYW4g
ZXhhbXBsZT8NCj4gPg0KPiA+IExldCdzIHNheSB0aGUgcHJpbWFyeSBhbmQgYWx0ZXJuYXRlL3Nl
Y29uZGFyeSBwYXRocyBiZXR3ZWVuIHRoZSBTQ1RQDQo+ID4gZW5kcG9pbnRzIHRyYXZlcnNlIGRp
ZmZlcmVudCBtaWRkbGUgYm94ZXMuIElmIGFuIFNDVFAgZW5kcG9pbnQgZGV0ZWN0cw0KPiA+IG5l
dHdvcmsgZmFpbHVyZSBvbiB0aGUgcHJpbWFyeSBwYXRoLCBpdCB3aWxsIHN3aXRjaCB0byB1c2lu
ZyB0aGUNCj4gPiBzZWNvbmRhcnkgcGF0aCBhbmQgYWxsIHN1YnNlcXVlbnQgcGFja2V0cyB3aWxs
IG5vdCBiZSBzZWVuIGJ5IHRoZQ0KPiA+IG1pZGRsZWJveCBvbiB0aGUgcHJpbWFyeSBwYXRoLCBp
bmNsdWRpbmcgU0hVVERPV04gc2VxdWVuY2VzIGlmIHRoZXkNCj4gPiBoYXBwZW4gYXQgdGhhdCB0
aW1lLg0KPiANCj4gT0ssIHRoZW4gb24gdGhlIHByaW1hcnkgbWlkZGxlIGJveCB0aGUgU0NUUCBm
bG93IHdpbGwganVzdCB0aW1lb3V0Pw0KPiAoYmVjYXVzZSBubyBtb3JlIHBhY2tldHMgYXJlIHNl
ZW4pLg0KDQpZZXMsIHRoZXkgd2lsbCB0aW1lb3V0IHVubGVzcyB0aGUgcHJpbWFyeSBwYXRoIGNv
bWVzIHVwIGJlZm9yZSB0aGUgU0hVVERPV04gc2VxdWVuY2UuIEFuZCB0aGUgZGVmYXVsdCB0aW1l
b3V0IGZvciBhbiBFU1RBQkxJU0hFRCBTQ1RQIGNvbm5lY3Rpb24gaXMgNSBkYXlzLCB3aGljaCBp
cyBhICJsb25nIiB0aW1lIHRvIGNsZWFuLXVwIHRoaXMgZW50cnkuDQoNCj4gDQo+IE9yIHRoZSBz
Y2VuYXJpbyB5b3UgZGVzY3JpYmUgaXMgdGhpcz8gQXNzdW1pbmcgYSBtaWRkbGUgYm94IHRoYXQg
aXMgYW4NCj4gYWx0ZXJuYXRlL3NlY29uZGFyeSBwYXRoLCB0aGVuIHN1Y2ggbWlkZGxlIGJveCAo
d2hpY2ggZGlkIG5vdCBzZWUgYW55IG90aGVyDQo+IHBhY2tldHMgYmVmb3JlIGZvciB0aGlzIGNv
bm5lY3Rpb24pIHN0YXJ0cyBzZWVpbmcgcGFja2V0cyBmb3IgdGhpcyBmbG93LCBzbw0KPiBwYWNr
ZXRzIGFyZSBkcm9wcGVkIGJ5IHRoZSBzZWNvbmRhcnkgbWlkZGxlIGJveCAod2hpY2ggbm93IGJl
Y2FtZSB0aGUNCj4gcHJpbWFyeSBwYXRoIGFmdGVyIHRoZSBuZXR3b3JrIGZhaWx1cmUpPw0KDQpX
aXRoIGQ3ZWUzNTE5MDQyNyAoIm5ldGZpbHRlcjogbmZfY3Rfc2N0cDogbWluaW1hbCBtdWx0aWhv
bWluZyBzdXBwb3J0IikgYW5kIGJmZjNkMDUzNDgwNCAoIm5ldGZpbHRlcjogY29ubnRyYWNrOiBh
ZGQgc2N0cCBEQVRBX1NFTlQgc3RhdGUgIikgdGhlcmUgaXMgc29tZSBtdWx0aWhvbWluZyBzdXBw
b3J0LCBzbyBzZWNvbmRhcnkgbWlkZGxlYm94ZXMgc2hvdWxkIGhhdmUgYW4gZW50cnkgYWxyZWFk
eS4gU0NUUCBlbmRwb2ludHMgY2FuIHNlbmQgcGFja2V0cyB0byBzZWNvbmRhcnkgdHJhbnNwb3J0
IGFkZHJlc3NlcyBhY2NvcmRpbmcgdG8gdGhlIFJGQywgYW5kIHRoZXkgZG8gcGF0aCBtb25pdG9y
aW5nIG9mIHNlY29uZGFyeSBwYXRocyB1c2luZyBIRUFSVEJFQVQgd2hlbiBuZWVkZWQuDQo=
