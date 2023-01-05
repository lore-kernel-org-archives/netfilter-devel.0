Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B4C8C3DA7A
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Jan 2023 11:41:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbjAELlU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Jan 2023 06:41:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjAELlS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Jan 2023 06:41:18 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2097.outbound.protection.outlook.com [40.107.105.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E2444C71
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Jan 2023 03:41:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z7QtJnDkCNwoF4kwl4cPDoArspFt2KXeD7WJs7/y5RvjHgxeDYO7cv92BbYcKp7jgXj1JdL8I7lkGliHnA43rU99OLok5muwk8h9z1i48juXEHa1Xa5ekgYhOgtovjZP53relCLHkVOQpkj7U0NzRT9DM2A8QDwmno8bV0N0LCrFwSBu3O038nk3GjcETiGmrplfdiyTzAZIzuLdLd63klNMAL/tNFX9EAODEVrcTJz9JqDlQSoCr4ZyewiUVR4HKd305O1PnHyQFGQMHLJbjwgnJs5oNq7A7X/4MoEJS0SyyYPJ5xlJtbz2elU/m5mqSbnZhQ/lCnsDURnq88Cimw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X4McrrS984WQ0YWrS09Jkwtw8bMdVt4Ad52wenD+6+k=;
 b=jF16u37BEHjUybwR3BS28MaQ6krllW9sHhBLSmf5263dy1adZPLj3hxoaoh71Bo3Z2Oddud0kWkIFJ7HXowK/an/yzOp7t7aJqCQmOD4afOgQYg/xcNSmPMQ9J1eO2gjVgsE6K22sWHDWggI2gus2uTw3Hx0z+rkeTu/aBgEcMg1LsP6i1Xzidsa3Y0IPWBT52+qm4ttODFVKrZ9IWP3/AxhmFfw9r3kLQcL61q0mvZOsAAaZIh8DaII8ffYaDBl4T9D5YvIO4l0D+C64suH287IeWd4aiNaO+yS05BvonHJuPrhc1sp/SBVS8zqXfg9Re/nWsmQEVL749lnw53FyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X4McrrS984WQ0YWrS09Jkwtw8bMdVt4Ad52wenD+6+k=;
 b=R2cueyk9a1tOJoIwQG2XkStAItSFVpc8TJAvc+EPObSxocMTIXlmS5ezX9qGWScm8GWM7QwSaYDxsrXZTPa/zC7MalLVooyq2QvIZ4cyVfv2CoFIjq1+iKVp0P3nZeU1auc4i/1ZKQKYv2BnUs4bOO4n/YLGTQEPxgDer/2Z+NM=
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by DB8P189MB0919.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:167::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.9; Thu, 5 Jan
 2023 11:41:13 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420%3]) with mapi id 15.20.5986.009; Thu, 5 Jan 2023
 11:41:13 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Long Xin <lxin@redhat.com>,
        Claudio Porfiri <claudio.porfiri@ericsson.com>
Subject: RE: [RFC PATCH] netfilter: conntrack: simplify sctp state machine
Thread-Topic: [RFC PATCH] netfilter: conntrack: simplify sctp state machine
Thread-Index: AQHZIDEXupmbZt3GPUa7TaBi/McYSK6OWrgAgAFXCcA=
Date:   Thu, 5 Jan 2023 11:41:13 +0000
Message-ID: <DBBP189MB1433F79520D32E1CB0F8A62A95FA9@DBBP189MB1433.EURP189.PROD.OUTLOOK.COM>
References: <20230104113143.21769-1-sriram.yagnaraman@est.tech>
 <Y7WVAEky9Iy3Ri3T@salvia>
In-Reply-To: <Y7WVAEky9Iy3Ri3T@salvia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DBBP189MB1433:EE_|DB8P189MB0919:EE_
x-ms-office365-filtering-correlation-id: 5a0ce598-72a1-4a63-a290-08daef11bfba
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AQYN3puSTgtDG8gUAKkIJxHu09CY/93OeiGGvBjNx+H/1qVL1yZr+YY0RbZb8HAO8B+UR/gHMs2reLQM4PEKhF045agRhRX7GGt5hXWjzMb1wVImtMakfZraO/oSm80eyNSJdRcDUmuSirZsl4BeakEgVZ4dAm0UqzyV0+VYv8qPCcDLjpdrmRPKDNC1GdRXFfROn0sfGX1YMTAyNn4E91JIwOirdRHBSsc2HUrBqrLcXI/KCs0IZPKxXW5RR4FjtXg6N3fPH9o2XiRkms4AL3v6K0ziz2eol1gs3kIzBVOiBDAM7yEwyeNymX0mpoUFGJAaDRMrThcNzhh3W5psn+7n7DRfHkvXGMppG6qoKOgJrLNSljYQOFdf7igzHd996Zfkm4/RKPaOoPpOyboARiH2+E1gn0X8Jjy6Pq9qac1u0RZJc8We6OPE/U51xKUjENn/1HanQQYDUgr14VZ8/RjZTn1VOrqjaOtuVJQ0lsO+9OIrrtNk+EbVt3XLNZAqfPW/Q+zATXgcO1ZLvotgaL6Wa1AqKcc1h+GxKVQ9BGwKh0D7Jw8A1jGLPzHi/ujXbI4LqNRtvCrvQZO7civCsfES2i7MSvy7lQllQmbXvKYnZVl9rCQg7vIoaXgvCexZ36o1ZzFlJ71ZKRoi5jQvibSO8sAOrvOtoWqPn1MpqvzV5YmQPEEOMTIsyRRAP4XcRNiDyDCGzlmnAuadu3Wakg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(136003)(39840400004)(396003)(451199015)(6916009)(55016003)(2906002)(54906003)(86362001)(316002)(38070700005)(38100700002)(122000001)(33656002)(186003)(6506007)(53546011)(26005)(83380400001)(7696005)(9686003)(44832011)(41300700001)(4326008)(66446008)(66476007)(71200400001)(76116006)(478600001)(8936002)(8676002)(66946007)(5660300002)(66556008)(52536014)(66574015)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ajNjdUxYWis5YmV0MkdKTmJuUU9LejJqWTlOTWpvL3hiM0VnNFNNbEJTQS9B?=
 =?utf-8?B?cEZDdmtZT3hzc0MyUWdGUThKTmxvcWJxRmUyekM0MzZ5d2NIQ0lCWC8yR0JC?=
 =?utf-8?B?Z0RXb1ZWais1ZjZwT291NU4xUytXRUdlcHpKMW1wMkdxbVRsT2NjN0tkNVZH?=
 =?utf-8?B?TW5jbVpsRTVDQmlYc0NWS0I4RjZLUXladDZPOHZDQ1ZjNkc4MjZkQmZzMWtr?=
 =?utf-8?B?eG9TcVhTNUs5K2IxcUlLZ2hUWHQ5eDhNcTMwSkR5Y1R0M2xVL3diZHB0UDhJ?=
 =?utf-8?B?a3NXbFZySktqekI3ais2endnSDE0dDBseE0zY3dxTW53dERyUWN0LytTUXZB?=
 =?utf-8?B?MVo0dGRHRW1mWkcrcjFSSng2SnoyaWFwWHJoVFBwdWJHQW1IeXJHazdIdjVI?=
 =?utf-8?B?bUI5VmN1c3NjK0UvVXJEM2M5RVR5R2FML3dmcStyL1hxNUVaaVVWZTcxSkpJ?=
 =?utf-8?B?YkhVL1htb0tkTDZDQ20wN0tZQm1qM0R3R1NVZHVPOWdEWEZBTWkxZWJ4Q3NC?=
 =?utf-8?B?d29wNlhONjJaeHFpbmo2aTFjYU04YnZzQzlvaXg1RjkrSXRmVVNNaWh1N3Zm?=
 =?utf-8?B?Y1dFSXQwWHlBQUN0Q2I2Y3JNSk9yLzQ0RjNvck5SNGtkd3hhZDVOU2pIY1Rl?=
 =?utf-8?B?YnZSZVIvbnV1QlUwWXduQThrR2RNOU5UeVFaelN0dnJtMjRKTERGR2xuLzVr?=
 =?utf-8?B?dnRldmtVNC9oNjVOaUVSUWhReTU0UG1TY1VnRXFHQ2tCd1NqcXlQaE41ZytJ?=
 =?utf-8?B?RHRPZUtpVTZkZWszNVRkQ0dMMUMrKzZkeTIwNkRhTnpnaUJmOTNKTnphc1lx?=
 =?utf-8?B?eC9IdFBEejZteStpZXplTzg2Nkk4ekhYb3ZDanRLTWNMUEkvQXRGU0VNalNq?=
 =?utf-8?B?SmRwM2JuNU9kYVE1djZzNnZLUWJUZ2pRQ3RSWG10TjlkNHpnVWU4OUZsenFG?=
 =?utf-8?B?V01lbUNKQThkbnV2ZXByV2xSeVNobHpCekNpNDZ6aVRkejZqT1lZR3BkNHNL?=
 =?utf-8?B?T2luOHUwdjRoVmdmeFphb21tNlA5ZEZaYnV4emx5MFFGWTlMaUxpNmkwOG1E?=
 =?utf-8?B?ZVdvSStGQlg1Sk1IaWk0YnAvdENwRitQbkM3SkhzazNmRTR3alF3MkorcDZz?=
 =?utf-8?B?bnlhWHRXdUh1eERISjl0aWNwV0xkZmZndWJHa3lpZVh1K0J3TEU3dEFMMUlE?=
 =?utf-8?B?VnVzRXVkU3lJanRnMjdsOWVlY3c0ZEdqOXJ4dEczbFAxMEFSR1dGVWZRWjFL?=
 =?utf-8?B?L1NJbUpzaDNLUWc4MEQ0TGxZREVjNlJ2L3QzUVVTTzdsNnRCeHBIZktJSU5s?=
 =?utf-8?B?ejNjOHpGeFJEOUhDSjQ3WDA4TmUydzJpeFJoRmRFcXhPWWdMUGZhWmdMZEZK?=
 =?utf-8?B?bVdzRTNhMGlUMXBTd0xRWHlHU0VncWdCRmlRd1dqY2duWkdFVnlxd1F3bjgr?=
 =?utf-8?B?VGc3R0t0Wi8rM05BNCthUHZmS2hpMGZDVnkzQXUzY0lBWFIwQlF3ZnpwRDVs?=
 =?utf-8?B?SVZDcDdrRlUvS2ZQd1RIVGMzdlh0Q3hXeWZxK3FscitXVGliN20xbkJ1MHVD?=
 =?utf-8?B?aTdIOUp6bmIweEVFRTFyK2xYOWNKY1dqNUJhYVhIK0VRYkQwM1RGZE5pQWRQ?=
 =?utf-8?B?WXpudkEyemkzSmZNM2hsYjZvajg0UVlQWllMeWFzbTh5RythYzB4RTllY1R1?=
 =?utf-8?B?ejBTcnVDR3pyeDg3cy9FTlJ6ZjVFY2Y1V0F6dTFIRStTK1ppcFJvTjU4a3hD?=
 =?utf-8?B?L1RPR25zU1hTZGlpTStqMmVxaWhOam9DWmE3dFJjVkFqLzY1QWd4dmpMQjQ4?=
 =?utf-8?B?V0JTQTVOUFBDdVAxdDZienNmcVVBMndDUXFQZkYxMVI2SGNpdEZHNkxoSVZV?=
 =?utf-8?B?Yk1IWUR6bEFpbWdhVXNVeXVoSzBtZ3RTWG00YjVFN0NUd3VHdHNaNHVkTWI5?=
 =?utf-8?B?WHM2eSt2NnZiV0xXWWFzd1FYR3JqT21MSE0xVkg0QjBJY1NqYXVpVkNOTlRu?=
 =?utf-8?B?ajl6Szg0T0tqMlhITzRuc2VpcWNxNEFZRG4yVmJDV1FyOHVRK3dBVWJVNTVa?=
 =?utf-8?B?QjJwOVlrQm0vY25wMDl6bnNWbWxaYlBGeVJTZ0JrVUg1ZDJtUFc3WlA2SU1p?=
 =?utf-8?Q?/cNuOpZueJ/OGnjp5VuUccGcG?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a0ce598-72a1-4a63-a290-08daef11bfba
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2023 11:41:13.6352
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SQf4jd7QHyL6kvKfg8UXqEFfj9uso1q+PTp5B6xtUuGk0vCsz82N/BK89lG2Vic+Ld/X9XIt5epJI6qkLjoR7MDrYpcLhCckD+h1It0xhR4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8P189MB0919
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBQYWJsbyBOZWlyYSBBeXVzbyA8
cGFibG9AbmV0ZmlsdGVyLm9yZz4NCj4gU2VudDogV2VkbmVzZGF5LCA0IEphbnVhcnkgMjAyMyAx
NjowMg0KPiBUbzogU3JpcmFtIFlhZ25hcmFtYW4gPHNyaXJhbS55YWduYXJhbWFuQGVzdC50ZWNo
Pg0KPiBDYzogbmV0ZmlsdGVyLWRldmVsQHZnZXIua2VybmVsLm9yZzsgRmxvcmlhbiBXZXN0cGhh
bCA8ZndAc3RybGVuLmRlPjsNCj4gTWFyY2VsbyBSaWNhcmRvIExlaXRuZXIgPG1sZWl0bmVyQHJl
ZGhhdC5jb20+OyBMb25nIFhpbg0KPiA8bHhpbkByZWRoYXQuY29tPg0KPiBTdWJqZWN0OiBSZTog
W1JGQyBQQVRDSF0gbmV0ZmlsdGVyOiBjb25udHJhY2s6IHNpbXBsaWZ5IHNjdHAgc3RhdGUgbWFj
aGluZQ0KPiANCj4gT24gV2VkLCBKYW4gMDQsIDIwMjMgYXQgMTI6MzE6NDNQTSArMDEwMCwgU3Jp
cmFtIFlhZ25hcmFtYW4gd3JvdGU6DQo+ID4gQWxsIHRoZSBwYXRocyBpbiBhbiBTQ1RQIGNvbm5l
Y3Rpb24gYXJlIGtlcHQgYWxpdmUgZWl0aGVyIGJ5IGFjdHVhbA0KPiA+IERBVEEvU0FDSyBydW5u
aW5nIHRocm91Z2ggdGhlIGNvbm5lY3Rpb24gb3IgYnkgSEVBUlRCRUFULiBUaGlzIHBhdGNoDQo+
ID4gcHJvcG9zZXMgYSBzaW1wbGUgc3RhdGUgbWFjaGluZSB3aXRoIG9ubHkgdHdvIHN0YXRlcyBP
UEVOX1dBSVQgYW5kDQo+ID4gRVNUQUJMSVNIRUQgKHNpbWlsYXIgdG8gVURQKS4gVGhlIHJlYXNv
biBmb3IgdGhpcyBjaGFuZ2UgaXMgYSBmdWxsDQo+ID4gc3RhdGVmdWwgYXBwcm9hY2ggdG8gU0NU
UCBpcyBkaWZmaWN1bHQgd2hlbiB0aGUgYXNzb2NpYXRpb24gaXMNCj4gPiBtdWx0aWhvbWVkIHNp
bmNlIHRoZSBlbmRwb2ludHMgY291bGQgdXNlIGRpZmZlcmVudCBwYXRocyBpbiB0aGUNCj4gPiBu
ZXR3b3JrIGR1cmluZyB0aGUgbGlmZXRpbWUgb2YgYW4gYXNzb2NpYXRpb24uDQo+IA0KPiBEbyB5
b3UgbWVhbiB0aGUgcm91dGVyL2ZpcmV3YWxsIG1pZ2h0IG5vdCBzZWUgYWxsIHBhY2tldHMgZm9y
IGFzc29jaWF0aW9uIGlzDQo+IG11bHRpaG9tZWQ/DQo+IA0KPiBDb3VsZCB5b3UgcGxlYXNlIHBy
b3ZpZGUgYW4gZXhhbXBsZT8NCg0KTGV0J3Mgc2F5IHRoZSBwcmltYXJ5IGFuZCBhbHRlcm5hdGUv
c2Vjb25kYXJ5IHBhdGhzIGJldHdlZW4gdGhlIFNDVFAgZW5kcG9pbnRzIHRyYXZlcnNlIGRpZmZl
cmVudCBtaWRkbGUgYm94ZXMuIA0KSWYgYW4gU0NUUCBlbmRwb2ludCBkZXRlY3RzIG5ldHdvcmsg
ZmFpbHVyZSBvbiB0aGUgcHJpbWFyeSBwYXRoLCBpdCB3aWxsIHN3aXRjaCB0byB1c2luZyB0aGUg
c2Vjb25kYXJ5IHBhdGggYW5kIGFsbCBzdWJzZXF1ZW50IHBhY2tldHMgd2lsbCBub3QgYmUgc2Vl
biBieSB0aGUgbWlkZGxlYm94IG9uIHRoZSBwcmltYXJ5IHBhdGgsIGluY2x1ZGluZyBTSFVURE9X
TiBzZXF1ZW5jZXMgaWYgdGhleSBoYXBwZW4gYXQgdGhhdCB0aW1lLg0K
