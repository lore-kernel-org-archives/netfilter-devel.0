Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24E1CC64ED6
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Feb 2023 10:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjBZKSm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 26 Feb 2023 05:18:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBZKSj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Feb 2023 05:18:39 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2119.outbound.protection.outlook.com [40.107.21.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3198393FF
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Feb 2023 02:18:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BPA5OB+GUMV3JiefcQjkKwUVUH3+y/AFkrvwF5IJ0Nc+cf2AOLf//SHgBsBiUf1V3KJu4hjvonNmBicvZHuQNYUNoKy59RdIpMKd/RZYHpTRViZI4M4a9dAUr/Dzz2IVhDYIjVTmKTnoajFTR5DzR8iscI1NG0naegCg+TzM1aHJxW8ff1YtATgWoCBfF91EcYV2n0UBUlSgm5LBOQdwXn93KNmSJ7IZxxq6FbBTAgkWQ5OJuulCYnuzuBjxDgc5TLfodyI5LsZWUgKytgNCle62ZMhV9cfj4v3FWmbVaxnhm6m97dt7Pz9OM2L3J7AbnVoDm+yMKgvAitD4y29Isg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zf3Ef8MuMQ0R0N+KRZO1rRSkrWUKtj0qTiv7uPx/JzY=;
 b=hrOmb9TT3+4QGztLFWIogPrbeRwCCicdWJadTBu83MY4jpme5HuUV8LruNphO5/xwLXB/PC43MBuUZ/rA8D1FvP82MxiLGklu3Ok7MY+EtZ6UOy3RBTr1YoVNdcIlNuOExBu85fVlFvytHdAvFbo7OZ+vkwTUTRZTkZA27joj01ewhd3QgvPt+SL3TMgrNjO7vrfqs+P8NaV1Oywq99i6prbs82La3ZZRxpfuVLMbuhuFxbIHR4HbN/xpDj/Iwj3ngSyW0hy7H2SoBsWORT/aaOj1uXknX/53t5YAw2ur5nUaFyy+LbEwBpBN2ZfBB0QdVS+V3+6jM+yW0w4UTiJFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zf3Ef8MuMQ0R0N+KRZO1rRSkrWUKtj0qTiv7uPx/JzY=;
 b=bqytXOz5OogEWfcowRtrgrMFSIBytcwcvGm3Z6mokMB8HCGctFtajsju1L44J+shcV+Vq/Qg9S5Kpil+yxF+I2SHQjEj6reF2qMrEymZMWP5KT5jGyzlcg3t06YlJFTmvFoEaKr2H4yuT3TYGsdfDfXbwoEjoaGrqvcWnORZg6w=
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by GV1P189MB2291.EURP189.PROD.OUTLOOK.COM (2603:10a6:150:98::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.27; Sun, 26 Feb
 2023 10:18:34 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::13ad:a312:15c6:91dc]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::13ad:a312:15c6:91dc%9]) with mapi id 15.20.6134.026; Sun, 26 Feb 2023
 10:18:34 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     Florian Westphal <fw@strlen.de>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: RE: [PATCH nft v2] meta: introduce broute expression
Thread-Topic: [PATCH nft v2] meta: introduce broute expression
Thread-Index: AQHZSDaH6gbTXtJZXUKsHjCYbyv0ba7d6qoAgAMcATA=
Date:   Sun, 26 Feb 2023 10:18:34 +0000
Message-ID: <DBBP189MB1433355F89E3D55A7586A7E095AE9@DBBP189MB1433.EURP189.PROD.OUTLOOK.COM>
References: <20230224095735.19317-1-sriram.yagnaraman@est.tech>
 <20230224104836.GG26596@breakpoint.cc>
In-Reply-To: <20230224104836.GG26596@breakpoint.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DBBP189MB1433:EE_|GV1P189MB2291:EE_
x-ms-office365-filtering-correlation-id: 1983445e-4329-476c-153c-08db17e2d175
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EHTMFtKiK7tkvN3CzXhLcH8Wz3zc6gE7RQ3XKVn/geIxq/RkWmnuFqSiPrSxp4REJJPje9go2YsURLs261H8I5aC8mVxA0RaUJEV1mr+ZGRCCP/mWFYsLvkkHLjKjkYczfAtIELVYyovoplNOmsEdamlsGxFXYkMmnzPYJF4ijiRXQo8TQFjVuK8Hjg6KVVZKTOKFi5H0TEg4sI/9I//ugTSMcKl+IidaMcYFuOptG82mr3+xuBU3C6LVRDd/OmrTutn4IHeVwJ8LD0Ct6O/m3jj2JGKIXrkr62KPavWW3is+gL5vpYnLxVKyrw58mik4wMRb5ncGw3qxJD2XYPOAgGCuGr+oOPQXC5RfB8tMbOeVueyohgmoUAStPRWsyVp9Awa8iy4rKT15EleCnw/Ia2/0dJGoQ87vnuh2mbXlnghXZT9q1ZI/zTQyrSmo6EwJh+bQxWYGND7spdj7vS04dobfMKTywgJZ3aBykKC84WS64h/kXXZAKvQdyPnvqrCAfj88eCnSe0KWs3QLWemCwNZ0itn7Mdog6ZOkAJHZi9kRXZMpVOV6ypV38aAZeQdH2o0mZDS5LuLO5jMLCNP7GPmFEz2jweRIrvO/cdePM/K75mgydlwB/LPHGwM2L0ucq3wukhGULi82zuBeWc2eQLwx3zdWItOQDAVR0yF3smDqxXtbKzN2mZKhOMdDQjV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(346002)(396003)(376002)(39830400003)(451199018)(83380400001)(8676002)(38100700002)(122000001)(86362001)(8936002)(5660300002)(478600001)(55016003)(33656002)(38070700005)(53546011)(966005)(6506007)(66556008)(66476007)(66446008)(64756008)(4326008)(6916009)(4744005)(7696005)(2906002)(71200400001)(44832011)(66946007)(316002)(76116006)(9686003)(186003)(41300700001)(52536014)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cjBwcy9ubm5WRjBWVUlQbTY2VVhqd1hYU3JXcDFtTWRpdjdZL2FsWkFyZXA2?=
 =?utf-8?B?eVMxcEVETnUyQXFmZU5pL3hNMTdOT3p2UnJBckk1VHQ4R2taOExMSzd2UjJ0?=
 =?utf-8?B?UDlxQVZ0MVFYZ2ZtVWxvQytYUHBJbzJxcGhOVDB4QWxkK29FTlZxM09KR0Nj?=
 =?utf-8?B?RnVNbVhnc3d4ZzB3c1puY1BRMkFaZWs4UzdyNXh6dm02UjZjM1lRSlIwRzdi?=
 =?utf-8?B?aFQ3TGJrbFJsVWRybzVCSFprRzdHMFVveGRkelZVR2lUN1JkTzByVFA4NTc2?=
 =?utf-8?B?RUNMbWhYR0NTaHk4dHlkQnFlaTRwMG9FN2Z0NDVEVmlLUnlvSmVuSTZPYUpV?=
 =?utf-8?B?SEtxaWZnQlhmS0NKN3I4Q20rUy9HblkvRjNvL0Y0Nk1uQVRkYlNLNWVLZi9O?=
 =?utf-8?B?dXpvSGhLY2lobk90akhUL3hIY2E3aVAxZmZEeGNQL1RpMWVkNTQ3Ukh6WGw4?=
 =?utf-8?B?ZGZ3RlVIbE9rVkNWblcvY2lxa0xiYXl3V0JaVjF4aHA1MFZtYXh0SmIzNTA2?=
 =?utf-8?B?U0V0Y1FHK0F3cnRmUVBzUXlHVmVTOHBWbmVBOW0wL1UzS0UxOVR4K1BHRytm?=
 =?utf-8?B?dmdhcmlNZ0h6Q1kremRhYnk4L3hPUzdKNzVzRnpOcDR4bmRXSk5vbjZRb3Rn?=
 =?utf-8?B?R3k1YnpoOFRYY1NPQkJRU3YyYVN1SDQ2VFI1d0gxMjN5N2swbk80NkRZSjE5?=
 =?utf-8?B?am1adm1Wai9pWllrUnZBNlZpQ2FySmNTS2loQjN1Q1dzZjBPbWZtVkFQUjB1?=
 =?utf-8?B?N3ZoRWFGL3dqeTBYbzRZMGRteXJwT2Ixc3VpblREWkhRd2JvckVlVWhXT3kv?=
 =?utf-8?B?YVRmNlZrQm5jemorUlhkQXpOZ3lLM0YzMjB3YmpuQjdMYkIyMjd5MWxGWGtx?=
 =?utf-8?B?UTZlRE9pZ2FGSGVqTnBjQUdWTGxtR3lld0FSSlpmbHI2Rm1NMzh1Z0Q4MGN0?=
 =?utf-8?B?eEdJNWljQkE5TnRFT1hRSmIxb1kyeFVCY1lBZnBwVlIxTkllS3pVNUZJMG1L?=
 =?utf-8?B?TUdoOXlUdHRETklBVTNFRDFBdU94VXV1S0RROUN2bExTWjJGUS93cnBoRXZn?=
 =?utf-8?B?dzgxSEFUOUQybTlqYUE2Q2RadzgrL3I4akF1ZHBtUlYxbVpCaWc1M1g4aGlN?=
 =?utf-8?B?TEJwUDVlSHpsS3dzMHd0M3FUZzUrQlRKaFc4THEwQTZDUDFrVFFObVA5ZTkw?=
 =?utf-8?B?dU5HUnQ2WmhpUlVLSU9Wa1hzeEdXSU0rTnJuSjVXVzNRQkgxeGYraVZ0NXNt?=
 =?utf-8?B?amFXc2FYOUZ2a3Rnd0U4bHdHV2JScmwrREROVFRTb3lYLzBaWlo2cm9OWUlz?=
 =?utf-8?B?WGRhVVFIK0VLQ3ZtTGF4amJqZVhGa0s2ZEJBV1Yzd0hoZE1mcHVrWDlWRHNU?=
 =?utf-8?B?aUF4ekRkY2NFMlQwUXJMMjFZbFFLclFRNTJxb0o4eGVXNG1uY0M4OWdCK0J0?=
 =?utf-8?B?a202M3ovMEdVRHExLzh3QU5MdGFBSWlmYXpzNzBubUpIS1VyMStFNkdEMnFn?=
 =?utf-8?B?eW5aN3R3NFlLODBGbmVOL1NkV2ZiaytOQXo4TTJaYUJFVGV5VXN2N25FTDZR?=
 =?utf-8?B?S3JLWTY3aU1IT0pLNEVHdjRFdlNnQ0RjSEU4MTRzclhBNDk0YVdURXl3TnNn?=
 =?utf-8?B?aHZocUxtZmt3WGU2SkhycTNGSm5sMUpkRGNqSDlZN0R1dDVUTkR2dFhseEtu?=
 =?utf-8?B?SEdLWHFFbUw5K2Z3dFAyVTQ5UTlsaE5qNU5LcnREbXdJRVg3VE5yVHRGRFUr?=
 =?utf-8?B?UmhicXp3dW5xSnkyMTNSSXY0UklsYmw1aW80NGEyZGkwWXZDYnhHVjNxL0Y0?=
 =?utf-8?B?bnZtejJnWEtiQUdLNzZFSFVYQTRqWG5IMk16OFpxcEFxeG5QdEhqUmo1QklN?=
 =?utf-8?B?VlBseFY4eWNWVmtjZjhCc3ZqSXZPNnZQTW51Z1lQMGVUTWZyNUQyWnhBQ096?=
 =?utf-8?B?T1laUjcxRE1LSXoxaEFCYjl6aDJDVTl2L3o2YldRNTdHL0VGQzV0ZWRIdnNu?=
 =?utf-8?B?NG1nWTNsVCtVZjBPR1dPQjl1ZEpTU0REVUJnQUNVcXdzbmtqQ0RHbDhjR2k1?=
 =?utf-8?B?Q2txb1ZmSE9lNHFsQzNFSGhxSjJOQWlWOVlJUlFKWFBwdFY5OWhUalNPR2g4?=
 =?utf-8?B?dU0xZWNrWGZSVzZBOHlIR2ZGTzRyaHJHNWdVTkxpVlMzSUpVTjBuRm1Laldl?=
 =?utf-8?B?Z2hRS2hKd2dLc2ZKTCtnSE4xTlF3VWNJUFdLa3piMjlDSWlrLzhxcDI3eENl?=
 =?utf-8?B?U0JXbExQUC9pMUN0dTNHOVhSd2l3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 1983445e-4329-476c-153c-08db17e2d175
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2023 10:18:34.6903
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ifoVPmXatWb8IBVplc/nIgiNLtaIHePiaU0OwhulqgFqKZEBZHqLtlesprT7ivTnQIEvTkGrbuytsAExAX2JKmm4haLmf0NfNwXVFe4kxu0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1P189MB2291
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRmxvcmlhbiBXZXN0cGhh
bCA8ZndAc3RybGVuLmRlPg0KPiBTZW50OiBGcmlkYXksIDI0IEZlYnJ1YXJ5IDIwMjMgMTE6NDkN
Cj4gVG86IFNyaXJhbSBZYWduYXJhbWFuIDxzcmlyYW0ueWFnbmFyYW1hbkBlc3QudGVjaD4NCj4g
Q2M6IG5ldGZpbHRlci1kZXZlbEB2Z2VyLmtlcm5lbC5vcmc7IEZsb3JpYW4gV2VzdHBoYWwgPGZ3
QHN0cmxlbi5kZT47IFBhYmxvDQo+IE5laXJhIEF5dXNvIDxwYWJsb0BuZXRmaWx0ZXIub3JnPg0K
PiBTdWJqZWN0OiBSZTogW1BBVENIIG5mdCB2Ml0gbWV0YTogaW50cm9kdWNlIGJyb3V0ZSBleHBy
ZXNzaW9uDQo+IA0KPiBTcmlyYW0gWWFnbmFyYW1hbiA8c3JpcmFtLnlhZ25hcmFtYW5AZXN0LnRl
Y2g+IHdyb3RlOg0KPiA+IG5mdCB1c2Vyc3BhY2UgdG9vbCBzdXBwb3J0IGJyb3V0ZSBtZXRhIHN0
YXRtZW50IHByb3Bvc2VkIGluIFsxXS4NCj4gPg0KPiA+IFsxXToNCj4gPiBodHRwczovL3BhdGNo
d29yay5vemxhYnMub3JnL3Byb2plY3QvbmV0ZmlsdGVyLWRldmVsL3BhdGNoLzIwMjMwMjI0MDk1
DQo+ID4gMjUxLjExMjQ5LTEtc3JpcmFtLnlhZ25hcmFtYW5AZXN0LnRlY2gvDQo+IA0KPiBMR1RN
Lg0KPiANCj4gQ2FuIHlvdSBtYWtlIGEgZm9sbG93dXAgcGF0Y2ggdGhhdCBhZGRzIGEgdGVzdCBj
YXNlIHRvDQo+IHRlc3RzL3B5L2JyaWRnZS9tZXRhLnQNCj4gDQo+IGFuZCBhIG5ldyB0ZXN0IGZp
bGUsIGUuZy4NCj4gdGVzdHMvcHkvYnJpZGdlL3JlZGlyZWN0LnQgPw0KPiANCj4gRmlyc3Qgb25l
IGlzIGV4cGVjdGVkIHRvIGZhaWwgKG9ubHkgaW5wdXQgaXMgdGVzdGVkKSwgYnV0IHNlY29uZCBv
bmUgc2hvdWxkIHBhc3MuDQo+IA0KPiBNYWtlIHN1cmUgdGhpcyB3b3JrcyB3aXRoIC1qIChqc29u
IGFzIHdlbGwpLg0KPiANCj4gVGhhbmtzLg0KDQpUaGFuayB5b3UgZm9yIHRoZSByZXZpZXdzLg0K
SSBoYXZlIG5vdyBhZGRlZCB0aGUgdGVzdHMgaW4gdjMsIEkgaG9wZSBJIGhhdmUgZ290IHRoZW0g
cmlnaHQuDQoNCg==
