Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A8CECAAD2
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Sep 2022 05:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbiIAFHq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Sep 2022 01:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232809AbiIAFHo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Sep 2022 01:07:44 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70048.outbound.protection.outlook.com [40.107.7.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96BD116E25;
        Wed, 31 Aug 2022 22:07:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mMhEILy2VQ0NzIftfjosPLdrExMDmz4dI+UvOBzZ0Dh+fNb2YCpC4ypwoSPOUMo0QeupT+wMrYp8b7p3gP2Wj8jVhxnQjmDDWJpq6ktkRu4EyG7TRmaaojeTPblvtAmHKYX62SNANXWf5d+WsJx0i7vpx9eWk6VPwbVdW6M1Ubtu1TlaT1I+UQq683+H/b1oh4NXE/9MRE82hhvyQOO+JAOkDqhU63D5K8CPoSCtkgMKNn4NizLIQepX2UBfy73rDhDOS9zmhDB/dlugXNH/6Ju3kx1gj2wvmdg5rjDPBgtU+n3fJKK2iqBBMLH0T6rxDGWL8me/mj+pIj4DHeyZSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HVhO2C0qKZ9n1akp4bEbF9haTxka5RpaNXvzBScLL/c=;
 b=QGGEvF413vgYqqeETfgEx15lDiewST+OOaDbzNrtRMfC5GBmHRmb0zDhD8YXtTMbvTb9GwKLEPe+8sPn6mSTkDhEGrV04YzMAuEGUbR6rwUsT86Q9PRdWUKlGxH30TZymhqjc3Vc7Qvz9DlCZ3b9WusWTbvMM9Zs8xp3QN5r36voDE05RUagMSCEtHufq3nJCEWvvzxKXiSCtI5uvt0oroUDHY9k4Mrdffkkk/mBYfrBRlQ0ZSJX8zB/bPprhDwdbpGgWIgfjI3QfDkKSPb92+6MJBmf0Mlu8mDBE4hcPbpvakx4nXHnU5NL9mC+O4mxEiAkREdfDbaf4edlgsuhTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=boskalis.com; dmarc=pass action=none header.from=boskalis.com;
 dkim=pass header.d=boskalis.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=boskalis.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HVhO2C0qKZ9n1akp4bEbF9haTxka5RpaNXvzBScLL/c=;
 b=iDUzH3eK9QRF7W0dEYXJLT1rKaj2fElLBrg9NZE1zDWBJrl2h+UTtufEXg8S6d0mR4OqByn7m9gYxCn9x4XH5qcpnH0Tg9ujCS0XZJFz5CFG58wUO8KoythpNgqsEGlz+m9flB4yG0w8plTc0hIkVn+j53Q3w/2UhkRivKRlzFebL4NVx74MxLeqeNmx0yfX1zUP+HRPDf9gDkE/emS3NcrNhRjkYVaq4iJB6cGOq15aamcHlsAobTE7A4MJ+vYpGfQOrKJBE0ZWihDU0/4uGx8BIFLVesQ8zUVjEF/NFVM/8FbQOxjK8H1oWjq/Lw10tz2VDaNL0tt6zi5CiaRf5g==
Received: from AS1PR04MB9501.eurprd04.prod.outlook.com (2603:10a6:20b:4d2::5)
 by VI1PR0402MB2862.eurprd04.prod.outlook.com (2603:10a6:800:b6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.11; Thu, 1 Sep
 2022 05:07:39 +0000
Received: from AS1PR04MB9501.eurprd04.prod.outlook.com
 ([fe80::dd29:e249:961f:d57b]) by AS1PR04MB9501.eurprd04.prod.outlook.com
 ([fe80::dd29:e249:961f:d57b%9]) with mapi id 15.20.5566.015; Thu, 1 Sep 2022
 05:07:38 +0000
From:   "Vink, Ronald" <ronald.vink@boskalis.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
CC:     "lwn@lwn.net" <lwn@lwn.net>,
        "netfilter@vger.kernel.org" <netfilter@vger.kernel.org>,
        "netfilter-announce@lists.netfilter.org" 
        <netfilter-announce@lists.netfilter.org>
Subject: RE: [ANNOUNCE] 17th Netfilter Workshop in Seville, Spain
Thread-Topic: [ANNOUNCE] 17th Netfilter Workshop in Seville, Spain
Thread-Index: AQHYvVQLs1qAIz5Rp0unvvtfIzsbW63KBotg
Date:   Thu, 1 Sep 2022 05:07:38 +0000
Message-ID: <AS1PR04MB9501282712816CD553AEB936997B9@AS1PR04MB9501.eurprd04.prod.outlook.com>
References: <Yw+F/N3y9vIHnY+3@salvia>
In-Reply-To: <Yw+F/N3y9vIHnY+3@salvia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=boskalis.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9d30931e-e908-4a8c-696c-08da8bd7e42d
x-ms-traffictypediagnostic: VI1PR0402MB2862:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 803lGFsX9wUTj/CD/snnjiERi5fTFwNQzRqV2nEIsreve2s5F2D8tXPtg6Xp/D1/B3l4upZrQLjuVYOWWdLRVVOqsq+XCtG9R+qJgg1j2kMZpPl8sjXJJTLulh2lqucaXwKQqJUVqdBAtzl91gBoNYsKmwmKklfEFfyL4125CBIaOt5kbQ7FwPaOSBg+zpx/2dSPkTfYylRSvhWxpNlrAF/R+LeDZsQjwniBAxiR613ie5jsb4s9a5F43vx43J1YoLjjdp9D0f41bScH1n67E6P6PemTlhWUoUZn80Ow7qxKG1W62XVF1RcLRUrRMD+ZI9+4NpuwlriaE/a8DBNPIvY94jNTMMh+qbxRLpOkdWBu7Pqtqx7QdzCMg6UEbSQvPP3jXb+78PbbKmNns0oXkZ+2FE6LPTxPjd3iNFF4hue0pWlLlaEeOK12p1aoHfpF6UDDlFBICjVs4tAxiTRttPEU+wx/g9Y7wo7VNjbsfQt+AWp388X0cX9HH2Kr1KI+ZTrYoEQEXmlbxzZoYESEzbH5vVMEJ2wY0kt9DU7beT0PzL53ci2wvHlsFC0EPpJQBTgf6LxNrNwukeW8OeCYyJQPNHNqAWffuyIGxjf0QVhrGKBryxOf4sEJ9r818IfPbpVfGzAzK0L6xd6Kqqek1eMTGaVNZc2X4OojhNXfXXjbUin3V12+mtMSDo6D4MgfaQusiaMovkVAiwFVjNjdG2ZaoiWzBUhLCUnkLnTVW655JUb83TIUX4BJF4vvd3joxn+rzU5NyIVgzm/x1BKby4LRaFoptxByW5wnpJeUUGY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS1PR04MB9501.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(136003)(376002)(396003)(366004)(26005)(53546011)(71200400001)(186003)(52536014)(6506007)(7696005)(9686003)(5660300002)(8936002)(33656002)(41300700001)(45080400002)(86362001)(966005)(478600001)(38070700005)(83380400001)(316002)(54906003)(2906002)(110136005)(122000001)(38100700002)(76116006)(66946007)(55016003)(4326008)(8676002)(64756008)(66446008)(66476007)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cmQ3M2U0YzlGQVVRN2NKSkt3bFJUOHNKNnY2bDk1bXNSQXowY3phdnBVcmQ0?=
 =?utf-8?B?bzlqaDZkRUlXV1R1NkdnU2duRS8yZGF5eWlNRXVoS1RSZ3Y5Q0dMc3ljMGNk?=
 =?utf-8?B?bXZqS3pBL1lMMWxtTWlja3hnK0szb0lGdEdCNzEvcDZWVDlLNGpOT01ZUXB0?=
 =?utf-8?B?M2dWZm11U1Z0OFVLdDJuZDVxeEpmdlFJMURqZm1EUWlUM1JyMkNHUXhqWmVS?=
 =?utf-8?B?aDNBRUVVOGROdFFpM0ZVVGo5c0hCS0hqYmNWSGJtZmx2RW5ZMmhrbzJhV3BD?=
 =?utf-8?B?NVRTQ285OTVWeUozT1hVa2gzOVlRdThwNnF5WXU2WHdVTGxaK1gzN2RUUUNM?=
 =?utf-8?B?ZGlIbE9CT2pkUU1qMnFnbG1lZnRDQy9zcnN0dkc5bEdnU0pwOHpkendGY0JL?=
 =?utf-8?B?cTd6M2tYQlVnUE1UYUVPWnNBczg0SWlLTmx4Mi9nQnNzV3JYR2pndGJIamNn?=
 =?utf-8?B?TDdJOU9IZzZZOHNwQXplbmVhS1ZrT3ZiSXU3NmRBUksrYnhGbHltR2hobjcx?=
 =?utf-8?B?aU9qNTJDSFlPVnp1R0k0UlB6c1ozcWlwcTFOUmxETk96RWNxUUxSLzVMc0dP?=
 =?utf-8?B?NkhYOXFjMERHYkhzZXFkbGZ2MHR0alJRUHpxcDd0Z2trUzZ2RWZEbFNWUEU3?=
 =?utf-8?B?TnV0YXhNVFB6VEcwMW9jbE1vWFVBd2tZTDJ1VkMwVTRjem1waXpraEEwTWR2?=
 =?utf-8?B?ZWlIZ3BCbFJSNVgyUldwYWduSHhNSHJheGwyVDhHRDg2eVh1Y2tJbEtCVEp4?=
 =?utf-8?B?clBubTAySFBZZTRCaHErY2Z6ZXFhQjhtRHVaNW5CWXRaZW1EUmEzemxMZHlC?=
 =?utf-8?B?V1hFNW5OS2FGd2FweGI4UnV3bTFYM2ZVWXE5ZG1vRU1wR0lWNlMya1UraTlw?=
 =?utf-8?B?akhwNTVBNVd3WXo5dU9kZ0NBMm5EcjVTUFFLVUNqRHZMaUh1OG44SG15RGl0?=
 =?utf-8?B?a244V1NrUUl0WkR1dVBtUVNDeWVPWEVta1pPa2NINUQyK2c4ZzNsUldWU0FU?=
 =?utf-8?B?OWdTRkRnSlpJbExXeEVXSlRSWkFsT0dhc2U2SStpN0pXTEQ0dzZmYlBnVndp?=
 =?utf-8?B?Ump6dDVJMCtST3BDbTFYd3BZaXg0UkdadVJxN1V0WFVlWUJWbHd2OEtaN09a?=
 =?utf-8?B?Vk1VNlNMOTBSajcwVWhmei9tUmJYc2JSRUhQcW5LS0pPUUo3SEx1bVhISy9h?=
 =?utf-8?B?S1BUUEVuMG5zYlArQU0vbEtGM2puNEF5b3FLS2Q3eE1WYi9odFZjNUo5LzMw?=
 =?utf-8?B?ZUNNcEdoRDhNblBYNTU4Z2xKbmg3ODNuYmRFelRzSERMb1Y2QVpTQkdZd1ly?=
 =?utf-8?B?TDA0S0JscmpMN3hEbWx6eVlIWExxWW1XZzJ3VDN5U1MveEF3USt5UC80UVB1?=
 =?utf-8?B?TUFCcTRGR2hLQnQvZDVhRUVUb2FMNmRMaWhiT0ZCUkdHZmhXU0p6TFJrNjh0?=
 =?utf-8?B?MlFGZzF4WkxibFJoWmk3L3NwakNwT1Fvc29UTUx0UlY3OEdwTHVNRkM2endB?=
 =?utf-8?B?TnhnUWtCUVdKU2wxQnY4NGJJMjVhUGwyOXhOQ1BJUHlOYlFZU2RMeVQyNUJO?=
 =?utf-8?B?UWNpYTZEUmt3QTU5bkkrVUZqWXJpbHdoWC9sU2VwbzYrY1Bab01RelY3eU9T?=
 =?utf-8?B?ajBraDhicWljNmpad2xsS1VrdTgrajBvaEU4eEJIZnFlUEZ5bmF6TVdQR1Ft?=
 =?utf-8?B?dWJGOFlKOXNMc3ZoLzBrNFlCSFlqTXl3ODJSdjZvclB6UzZWTlFUdWhCeUM4?=
 =?utf-8?B?UG5uNFhpMUQ5WjMrSlFJWmNPa3RWRm9sOW5QSk1ldk8vTzdnREdieERpbHky?=
 =?utf-8?B?RjhTc01UZjZHdEZHbFdrRW4rZDJrMkVxWUJCSEw0MUFHZzVHUHEwcTN5UjA1?=
 =?utf-8?B?SFMxZ2Mvc2wrSVdhN0FBUEhxNGVsT01yZHR6N3hoTUNrdHpZeXJnWFlzSEhV?=
 =?utf-8?B?K1RCMzZIOUY0VU1Fd2Y3cVdmbU1KOEdQRzRCSXNNNmo2VWltUzZRWXR0czlF?=
 =?utf-8?B?RHlDaUFHVlU2bVVEUGVIbXRjVnNKNHN6RTg4UTljVGE1VDRTbHJOd0FoZjFT?=
 =?utf-8?B?SHpnM3Ftd3FrcXNlcjRUcjlaazRQVmxzSyt5TVBxMkdCVXhNVnBWd3lKb3k2?=
 =?utf-8?Q?+4UD8eYgn7HFzF1BMwdgQo2ae?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: boskalis.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS1PR04MB9501.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d30931e-e908-4a8c-696c-08da8bd7e42d
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2022 05:07:38.8288
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e9059df4-f2a9-48d6-8182-7f566ea15afa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wU2tfdriY2MJI+5tV+fiHkYDYNFMZ4xZIM3LmE06aROdh/JgJBPT5kJLmb81wLuKjZvU32AvM335qpITLcuV1OecvKF3DqGL+Am/xKlfaWA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2862
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

UGxlYXNlIHVuc3Vic2NyaWJlIG1lIGZyb20gdGhlIGxpc3QNCg0KLS0tLS1PcmlnaW5hbCBNZXNz
YWdlLS0tLS0NCkZyb206IG5ldGZpbHRlci1hbm5vdW5jZSA8bmV0ZmlsdGVyLWFubm91bmNlLWJv
dW5jZXNAbGlzdHMubmV0ZmlsdGVyLm9yZz4gT24gQmVoYWxmIE9mIFBhYmxvIE5laXJhIEF5dXNv
DQpTZW50OiB3b2Vuc2RhZyAzMSBhdWd1c3R1cyAyMDIyIDE4OjAyDQpUbzogbmV0ZmlsdGVyLWRl
dmVsQHZnZXIua2VybmVsLm9yZw0KQ2M6IGx3bkBsd24ubmV0OyBuZXRmaWx0ZXJAdmdlci5rZXJu
ZWwub3JnOyBuZXRmaWx0ZXItYW5ub3VuY2VAbGlzdHMubmV0ZmlsdGVyLm9yZw0KU3ViamVjdDog
W0FOTk9VTkNFXSAxN3RoIE5ldGZpbHRlciBXb3Jrc2hvcCBpbiBTZXZpbGxlLCBTcGFpbg0KDQpI
aSwNCg0KV2UgYXJlIHBsZWFzZWQgdG8gYW5ub3VuY2UgYSBuZXcgcm91bmQgaW4gdGhlIE5ldGZp
bHRlciB3b3Jrc2hvcCBzZXJpZXMuDQpUaGlzIHllYXIgdGhpcyBldmVudCB3aWxsIHRha2UgcGxh
Y2UgZnJvbSBPY3RvYmVyIDIwIHRvIE9jdG9iZXIgMjEsIDIwMjIuDQpUaGUgZXZlbnQgd2lsbCBi
ZSBoZWxkIGF0IFpldmVuZXQgWzFdIGZhY2lsaXRpZXMgaW4gTWFpcmVuYSBkZWwgQWxqYXJhZmUs
DQpTZXZpbGxlLCBTcGFpbi4NCg0KVGhlIE5ldGZpbHRlciBXb3Jrc2hvcCAoTkZXUykgaXMgdGhl
IHByZW1pZXIgZXZlbnQgb3JnYW5pemVkIGJ5IGFuZCBmb3INCnRoZSBOZXRmaWx0ZXIgY29tbXVu
aXR5LiBEdXJpbmcgdGhlIHdvcmtzaG9wIGRheXMsIExpbnV4IG5ldHdvcmsgYW5kDQpOZXRmaWx0
ZXIgZGV2ZWxvcGVycyBtZWV0IGFuZCBkaXNjdXNzIHRoZSBzdGF0dXMgb2Ygb25nb2luZyBkZXZl
bG9wbWVudHMNCnJlbGF0ZWQgdG8gTmV0ZmlsdGVyIGFuZCBwbGFucyBmb3IgdGhlIGZ1dHVyZS4N
Cg0KQXR0ZW5kYW5jZSByZXF1aXJlcyBhbiBpbnZpdGF0aW9uLiBMaW51eCBuZXR3b3JrIGRldmVs
b3BlcnMgd2l0aA0Kc2lnbmlmaWNhbnQgY29udHJpYnV0aW9ucyB0byBhbnkgb2YgdGhlIE5ldGZp
bHRlciBzdWJzeXN0ZW1zIGFuZCB1c2Vycw0Kd2l0aCBpbnRlcmVzdGluZyB1c2UgY2FzZXMgYW5k
IG9wZW4gcHJvYmxlbXMgYXJlIGFsc28gd2VsY29tZS4gV2UgaGF2ZQ0KdHJhZGl0aW9uYWxseSBo
ZWxkIGEgc3BhY2UgZm9yIHNpc3RlciBwcm9qZWN0cyB0aGF0IGJ1aWxkIG9uIHRoZQ0KTmV0Zmls
dGVyIGluZnJhc3RydWN0dXJlIHN1Y2ggYXMgdGhlIExpbnV4IFZpcnR1YWwgU2VydmVyIHByb2pl
Y3QuDQoNCllvdSBjYW4gc2VuZCB1cyBhIHByb3Bvc2FsIHRvIGNvcmV0ZWFtQG5ldGZpbHRlci5v
cmcgaW4gYSB2ZXJ5IGxpZ2h0DQpmb3JtYXQ6IHRpdGxlIGFuZCBxdWljayBhYnN0cmFjdCAobm8g
bW9yZSB0aGFuIDUwMCB3b3JkcyEpLCBhcyB3ZWxsIGFzDQp0aGUgZXN0aW1hdGVkIHRpbWUuIE5v
dCBsYXRlciB0aGFuIFNlcHRlbWJlciAzMC4NCg0KV2UgYXJlIGFsc28gbG9va2luZyBmb3Igc3Bv
bnNvcnMgdG8gY292ZXIgZXhwZW5zZXMsIGlmIHlvdSB0aGluayB5b3UgY2FuDQpoZWxwIHVzIHJh
aXNlIGZ1bmRzIHRvIGhvbGQgdGhlIHdvcmtzaG9wLCBwbGVhc2UgY29udGFjdCB1cyBhdA0KY29y
ZXRlYW1AbmV0ZmlsdGVyLm9yZyBhbmQgd2Ugd2lsbCBiZSBnbGFkIHRvIHNlbmQgeW91IG91ciBz
cG9uc29yc2hpcA0KcG9saWN5Lg0KDQpKb2luIHVzLg0KDQpbMV0gaHR0cHM6Ly9ldXIwMy5zYWZl
bGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/dXJsPWh0dHBzJTNBJTJGJTJGd3d3LnpldmVu
ZXQuY29tJTJGJmFtcDtkYXRhPTA1JTdDMDElN0NSLlZpbmslNDBib3NrYWxpcy5ubCU3Qzg0YjRi
ZTg5NTQyYzQ3YjhiMDcwMDhkYThiNmIyY2UzJTdDZTkwNTlkZjRmMmE5NDhkNjgxODI3ZjU2NmVh
MTVhZmElN0MwJTdDMCU3QzYzNzk3NTU4OTY3MTgxMDE5NSU3Q1Vua25vd24lN0NUV0ZwYkdac2Iz
ZDhleUpXSWpvaU1DNHdMakF3TURBaUxDSlFJam9pVjJsdU16SWlMQ0pCVGlJNklrMWhhV3dpTENK
WFZDSTZNbjAlM0QlN0MzMDAwJTdDJTdDJTdDJmFtcDtzZGF0YT05Z2I3MENOSWp3Ynd3JTJCbm1J
T2poMmVFVlZYQVMlMkZERVVuQiUyRlFkUXZ1QiUyRkklM0QmYW1wO3Jlc2VydmVkPTANCg0KUC5T
OiBUaGlzIGVkaXRpb24gd2lsbCBjZWxlYnJhdGUgMjQgeWVhcnMgc2luY2UgdGhpcyBwcm9qZWN0
IGJlZ2FuIGluIHRoZQ0KICAgICBmYWxsIG9mIDE5OTguDQo=
