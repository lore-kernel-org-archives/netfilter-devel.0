Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACD71C43217
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Dec 2022 09:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiLAJYv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Dec 2022 04:24:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiLAJY2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Dec 2022 04:24:28 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2096.outbound.protection.outlook.com [40.107.6.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA9D8EE6D
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2022 01:23:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g8+vO4MzjZjbdRq8XVERGCdzyqjFcLY9XO8AaIFEUWdw3vhuET9cym9kr9WWPdfuJugY4A5iP36vHSf424Dc7Zg4Df11hw34Ayho4sUCSv1CaVFA1j7GRnasyXSDjq8bWBmYdxGU9w2ZN2S99YzX6c6Xnzrlprdl2FkCpMFQ5lCuvTUxBZFHF7XK5hg/p1rHQaD33wwYehDglAdoV0va0EAQSCIT6dJ5FROs1iR6o16rf4WKMc6bt57yIx6M0ilsBa/J94/FdAYfCCQnZBWs4JqkEdxw+vyoE7jrteJE6wFjY6uBaAvO/tVt2Pkmzv7n0gvY4qDUu6Xi3qWSqNs+NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oXqgQ3WkriBetb9IqeJgWHsg683ZDZFZXBP+acnRbR8=;
 b=K/XKVbOpOtK5pgFT276yTtyJeEjTwW1ARnVu39SUtL9ibTGAM+r0GyGsDYPtcpvfFpJkT8azIkwoEhDpnFD6EblBskQyGJ66KX5FwN/b/3HAuycfsEvwaeul2PB9a2XmNk9YRkzIq/9LB95IKIFp3s6ABrnfoc4r9a360412inp/co4IAwRRmb2GD7FScXb7VkU/WI/obKpg5BmFJs8NusR4IU5fYnfF1axRlXNKX8PLGGJypj1BW82u54P8eldof9voAPcS/ry5Ufi1fTe6Z41L9am3ym3Npco41gHEJA7UDveyb6b0USie9RVAz80L2x/wDOPj0Em0i6Bt7eH9kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oXqgQ3WkriBetb9IqeJgWHsg683ZDZFZXBP+acnRbR8=;
 b=BulN9DDclFVxplzkFVHdcy/rY4AK9lLh5ysNLZMOHDmBLcbOhLptlyWbN892frxVEmrX6KZ2O5yoi6tNM29hNSeAWpAvOONwC3qPZQxUqBIwt8Q5AOhADeCQ2gWaq/w/dxMyKZI5AW1gvRnrqrW/TkS1qoQV45TtBHjiep16SFY=
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by VI1P189MB2536.EURP189.PROD.OUTLOOK.COM (2603:10a6:800:1c3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Thu, 1 Dec
 2022 09:23:17 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::9a8b:297a:91d9:67c8]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::9a8b:297a:91d9:67c8%8]) with mapi id 15.20.5880.008; Thu, 1 Dec 2022
 09:23:16 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>,
        "claudio.porfiri@ericsson.com" <claudio.porfiri@ericsson.com>
Subject: Re: [PATCH v3] netfilter: conntrack: add sctp DATA_SENT state
Thread-Topic: [PATCH v3] netfilter: conntrack: add sctp DATA_SENT state
Thread-Index: AQHY8U8PQqbppKgwmUOloDh+DWMSjq5X33IAgAELBoA=
Date:   Thu, 1 Dec 2022 09:23:16 +0000
Message-ID: <cef2fac5-0ee7-ff99-3114-c14168089041@est.tech>
References: <20221104171835.1224-1-sriram.yagnaraman@est.tech>
 <Y4eShs1cQ7V0mk9n@salvia>
In-Reply-To: <Y4eShs1cQ7V0mk9n@salvia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DBBP189MB1433:EE_|VI1P189MB2536:EE_
x-ms-office365-filtering-correlation-id: 29f8883b-2df4-45c6-6af8-08dad37dadf2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M9c/jc0sLW14Cl4mpITsjl0FAsjpFQQsgiDnLhc7nMgrGXVib1oyUmdbkE3MqPkibb3FroW3dOA0iFH5ImV4eVMSnkkp0e08RsP/b3BX0PtntN4y6v6QgGNOlSWMZkNl3mWJgvjztB1NEjkQ2n4LZf1oo/hHsH3vxGcHWV1MXIwkqd22uKManksJuZcToSblJiSr0YwhV1+YMUzFo4wV/DX0uKjCpmwr0vIw7TfeiQwgqwlhQgrQkPoyg4vhrP598mcbCijz+2+sT1PGGKcuti1SV2d9YaK8fArR4cb92Djvk4J/1GmQpAVjhRL24yCzXTQSEMqNOjUo75ywFQlLz9y2KqZ1JiC9btx58GLOg0zLiQRGPxQBnZOx2L/9uP8rNHnYlPnRnr07+wEBivTAhY2YMiTBEOK0FI+NrdOzisywZDlWCkgoE9oyUzpoF8Zqh2bkghWswvas9Quk045ecfFShI8RQaBS4nTciOYy1Fn1KIT1o8SI664ZsGNp0FqPL1q1LWo+j5VpCflAYqdWVKDaJ+8nAXALXftDr11azym+QnqC/45tqqsvTs8wiyGm3EOWUUXJ0GSHLznRMPratIsIYuMQ4bJqfxyqEcqQjtmtbKEJRn4xI8BEj4DnEl85OySxfnCwRAvLN2DRMHm0dQC4ufnbgwc2bDq5dLoQl4f/8q04fSWRnmVEsOl4/3Biw0M6L5vGpE+Kg3W6TUYFPXZYy0RNXwhkpOSfXpQEilQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(366004)(376002)(39830400003)(396003)(451199015)(54906003)(316002)(6506007)(6486002)(71200400001)(478600001)(53546011)(26005)(6512007)(186003)(36756003)(6916009)(2616005)(122000001)(38100700002)(38070700005)(31696002)(86362001)(83380400001)(76116006)(4326008)(66946007)(66446008)(8676002)(64756008)(91956017)(66556008)(66476007)(8936002)(44832011)(31686004)(5660300002)(41300700001)(2906002)(4001150100001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?enNKNkUzdGRuVks0VkUxSitnQnc5a0k1OGh6VDlMT3pUa1A3aHREczdxam5Y?=
 =?utf-8?B?TUc4V3NQWFhycFpmYmZ1MTZPL0xpQjUvTHY5a3M3aTA4enlUVUQ4aUQvU1dw?=
 =?utf-8?B?Wk9jczZHUmt4anJvYWdDZm9iQ0tjZHE4K2FKUk9mZG4rRzNkOHd4d3Z2cFdE?=
 =?utf-8?B?b01DN2lTc1JBSFd2WWcwbzVpSmxaTHlmb2l0aWZHL0hlRXZvYWFJNTZMWm9Z?=
 =?utf-8?B?a05EbnUyeEVHbkMzcGN0UXg3ZGlIclRWN1MwT2tzMGYxL0VuaDlpSy8yS21t?=
 =?utf-8?B?L3pBMUlTUEZuNXdmWi9qb2ttcm5aUGRvYjhvcnMzblZvVWU4MWNsTzQwZGE0?=
 =?utf-8?B?NnBHY1RFVWdSL0NGUmN0NVBZOTRzYWNQZjAveGRiNDc1d3RaR0dtU2sybnJ2?=
 =?utf-8?B?U1VyeEowNkVrNzAyT1N3dnpQbFJGMFRBSWt5M1lsazIxZEY2aWVLdkt0VEs3?=
 =?utf-8?B?NEhzRkdOVzkzUElkOTM3ZE83R0R5aDVMckRHTnpoK2FaazVTWmF6eGx6eHM1?=
 =?utf-8?B?aVhMZmljNTR4WWMvcnJPN2IyL3Bxc1VuaElqMk0veFd5ck1nNmJ2eDNpekhi?=
 =?utf-8?B?QzVaSW9qbWlqQ3o3cC9DLzdmYmR1NXVuNjJWRHBpZVhEbEtNc1RKN3JNTHM4?=
 =?utf-8?B?VmF0NGJMVmZvSXZ0YjliYlovSHR1ZU94RVI3VXVPQktwVnlWWmtJMUszbE9Z?=
 =?utf-8?B?ZTVaemJNR1VjTEFSZ2lyaE1YQXdYc2h2NGRXNUd4emF5VC9Obnl3V1o1MzhW?=
 =?utf-8?B?d2J5SjhyMDkzRGF1dDFWblV2UW04eTVYL1Z3WkZjNFVFZVhlMlRsR1R1ZFRx?=
 =?utf-8?B?V051aFZML3VIaUpGd2hlZG9KR3hRclA3NUhjRnc4MDNiZXlTWnBPYXI5WFBu?=
 =?utf-8?B?T1FMQVFGaHRYWEREbjA5T2d4RDBtRHRQWm91NDB1U2I1UllnbThUMFhhSEkw?=
 =?utf-8?B?UjJkTi81UWdpekp3QXNmaE93aUs4bzBsSVVudUFRTnpNcmVNSEVoczB4cU1I?=
 =?utf-8?B?MHFMWSt4c3hybUdjYVM2azA1RXJWemIwU0Q4MTBMWlFrcjREVm4yV2dHR3My?=
 =?utf-8?B?cGlUdzh0cDJhdlJFSnM4SDhvQnk0Sld2dU4xNXl0VW5ZZWFud21EZ015dko0?=
 =?utf-8?B?VXZYZVdmaGdGOFo1MklILzk1ay9qZnQzTWZOZElVS3lWeWx4dTVzQjIwWm9P?=
 =?utf-8?B?K2hKMnFaeW1TRlVKK1MrTXJOMDNqVkY5TnpUVTdUNXcwNDhiRURvaUpuQURj?=
 =?utf-8?B?TWJaZWU4T1dYd1Z2NnR6cFZRMjNRM1JPQjJhYkVUblRybE9MTWtQc2hodkJJ?=
 =?utf-8?B?NW1odnZVVzA5NHlBYXVJakVreFNHWmVPdld4MWx2Y2FBZ0JsSFJaditjUkF6?=
 =?utf-8?B?SlNmSTlLa3lZY0JONVEvUWRWWVV3OTFKMzFHT29hM0g1NFI0Z2piZlgxZUI5?=
 =?utf-8?B?WVdna2drSnltcTBENTJJNDVqcVJ0M3owLzNVdnBEdWs0bGh1REVMaWF6eWxm?=
 =?utf-8?B?OXh6cndHUGdMTzZIOVJBbmQybHYwMGRiQk5mMGFCMmpsMlUvMGFYcDl1MmRl?=
 =?utf-8?B?ZmQxaEw3VXNjV21uY3VIc0dDQkR6MzZOSDU3azV6N2ZYRnlpdEpyM2w4aVpV?=
 =?utf-8?B?ZWZUWUNINTlTOVp2Z3d5NkVYTUZrUnNWY3IwSDNNWGM5Sk1tWFpmZ3MvRlhr?=
 =?utf-8?B?QWdrS29neEFQUmJxS3RKR1Z0Z0dLZk9BRmRvRE9GMjhsUUQ0ZFJiU2ZnSEhQ?=
 =?utf-8?B?bUhtWmcyb0NCOXpHbTE4cVowL084ZkJKSkZpZVVXaEZVRHNaazNFS0RzWnFx?=
 =?utf-8?B?Sm1TdDNqVUtLL1hZdGtyL3NXcDVDaVlobkVpWUdCVm1VbDAxa1FsKzU5alJm?=
 =?utf-8?B?eGZwSGdidXJHcDlOSXk1bFBLbjMySzAxZkVsMnJ3dlg3M3dNeldrbGEyUlFD?=
 =?utf-8?B?OElsaW9RYm1WekM1ZVQ3bkQyWU8yQUp3b1VkdTg4SHdjSkZwVHhORWgweTlD?=
 =?utf-8?B?VTB3dzlLNFNZbmh1RTh2eXlCbWM1ZXVTUHA0VEFCRTdoaHpmUy9oaWFpRFJB?=
 =?utf-8?B?ZUJhVy9mSGJSOTlnTXh1RW5FVnNXNXExVERyYXgvK1kzZHlUVWllbnMwWHB2?=
 =?utf-8?Q?nDi3NXA7RIXJ+VR6/1urWHTIu?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A357F36AAACBBA419450511CF56E8340@EURP189.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 29f8883b-2df4-45c6-6af8-08dad37dadf2
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2022 09:23:16.8440
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d1aia6tAuMsEiy21rUZVcG9YOfAvKrmd9uZvfTNXfNXXBUUbHRlKdIpA8OknwsPEf3Jeqyhtk2gOHgO4GtZ7nelIlW8d3aFL6RpJkiVoIW0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P189MB2536
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

T24gMjAyMi0xMS0zMCAxODoyNywgUGFibG8gTmVpcmEgQXl1c28gd3JvdGU6DQo+IE9uIEZyaSwg
Tm92IDA0LCAyMDIyIGF0IDA2OjE4OjM1UE0gKzAxMDAsIFNyaXJhbSBZYWduYXJhbWFuIHdyb3Rl
Og0KPj4gQ2hhbmdlcyBzaW5jZSB2MjoNCj4+IC0gQWJhbmRvbmVkIHRoZSBzY3RwIG5vX3JhbmRv
bV9wb3J0IHBhdGNoIGZyb20gdGhlIHNlcmllcw0KPj4NCj4+IFNDVFAgY29ubnRyYWNrIGN1cnJl
bnRseSBhc3N1bWVzIHRoYXQgdGhlIFNDVFAgZW5kcG9pbnRzIHdpbGwNCj4+IHByb2JlIHNlY29u
ZGFyeSBwYXRocyB1c2luZyBIRUFSVEJFQVQgYmVmb3JlIHNlbmRpbmcgdHJhZmZpYy4NCj4+DQo+
PiBCdXQsIGFjY29yZGluZyB0byBSRkMgOTI2MCwgU0NUUCBlbmRwb2ludHMgY2FuIHNlbmQgYW55
IHRyYWZmaWMNCj4+IG9uIGFueSBvZiB0aGUgY29uZmlybWVkIHBhdGhzIGFmdGVyIFNDVFAgYXNz
b2NpYXRpb24gaXMgdXAuDQo+PiBTQ1RQIGVuZHBvaW50cyB0aGF0IHNlbmRzIElOSVQgd2lsbCBj
b25maXJtIGFsbCBwZWVyIGFkZHJlc3Nlcw0KPj4gdGhhdCB1cHBlciBsYXllciBjb25maWd1cmVz
LCBhbmQgdGhlIFNDVFAgZW5kcG9pbnQgdGhhdCByZWNlaXZlcw0KPj4gQ09PS0lFX0VDSE8gd2ls
bCBvbmx5IGNvbmZpcm0gdGhlIGFkZHJlc3MgaXQgc2VudCB0aGUgSU5JVF9BQ0sgdG8uDQo+Pg0K
Pj4gU28sIHdlIGNhbiBoYXZlIGEgc2l0dWF0aW9uIHdoZXJlIHRoZSBJTklUIHNlbmRlciBjYW4g
c3RhcnQgdG8NCj4+IHVzZSBzZWNvbmRhcnkgcGF0aHMgd2l0aG91dCB0aGUgbmVlZCB0byBzZW5k
IEhFQVJUQkVBVC4gVGhpcyBwYXRjaA0KPj4gYWxsb3dzIERBVEEvU0FDSyBwYWNrZXRzIHRvIGNy
ZWF0ZSBuZXcgY29ubmVjdGlvbiB0cmFja2luZyBlbnRyeS4NCj4+DQo+PiBBIG5ldyBzdGF0ZSBo
YXMgYmVlbiBhZGRlZCB0byBpbmRpY2F0ZSB0aGF0IGEgREFUQS9TQUNLIGNodW5rIGhhcw0KPj4g
YmVlbiBzZWVuIGluIHRoZSBvcmlnaW5hbCBkaXJlY3Rpb24gLSBTQ1RQX0NPTk5UUkFDS19EQVRB
X1NFTlQuDQo+PiBTdGF0ZSB0cmFuc2l0aW9ucyBtb3N0bHkgZm9sbG93cyB0aGUgSEVBUlRCRUFU
X1NFTlQsIGV4Y2VwdCBvbg0KPj4gcmVjZWl2aW5nIEhFQVJUQkVBVC9IRUFSVEJFQVRfQUNLL0RB
VEEvU0FDSyBpbiB0aGUgcmVwbHkgZGlyZWN0aW9uLg0KPj4NCj4+IFN0YXRlIHRyYW5zaXRpb25z
IGluIG9yaWdpbmFsIGRpcmVjdGlvbjoNCj4+IC0gREFUQV9TRU5UIGJlaGF2ZXMgc2ltaWxhciB0
byBIRUFSVEJFQVRfU0VOVCBmb3IgYWxsIGNodW5rcywNCj4+ICAgIGV4Y2VwdCB0aGF0IGl0IHJl
bWFpbnMgaW4gREFUQV9TRU5UIG9uIHJlY2V2aW5nIEhFQVJUQkVBVCwNCj4+ICAgIEhFQVJUQkVB
VF9BQ0svREFUQS9TQUNLIGNodW5rcw0KPj4gU3RhdGUgdHJhbnNpdGlvbnMgaW4gcmVwbHkgZGly
ZWN0aW9uOg0KPj4gLSBEQVRBX1NFTlQgYmVoYXZlcyBzaW1pbGFyIHRvIEhFQVJUQkVBVF9TRU5U
IGZvciBhbGwgY2h1bmtzLA0KPj4gICAgZXhjZXB0IHRoYXQgaXQgbW92ZXMgdG8gSEVBUlRCRUFU
X0FDS0VEIG9uIHJlY2VpdmluZw0KPj4gICAgSEVBUlRCRUFUL0hFQVJUQkVBVF9BQ0svREFUQS9T
QUNLIGNodW5rcw0KPj4NCj4+IE5vdGU6IFRoaXMgcGF0Y2ggc3RpbGwgZG9lc24ndCBzb2x2ZSB0
aGUgcHJvYmxlbSB3aGVuIHRoZSBTQ1RQDQo+PiBlbmRwb2ludCBkZWNpZGVzIHRvIHVzZSBwcmlt
YXJ5IHBhdGhzIGZvciBhc3NvY2lhdGlvbiBlc3RhYmxpc2htZW50DQo+PiBidXQgdXNlcyBhIHNl
Y29uZGFyeSBwYXRoIGZvciBhc3NvY2lhdGlvbiBzaHV0ZG93bi4gV2Ugc3RpbGwgaGF2ZQ0KPj4g
dG8gZGVwZW5kIG9uIHRpbWVvdXQgZm9yIGNvbm5lY3Rpb25zIHRvIGV4cGlyZSBpbiBzdWNoIGEg
Y2FzZS4NCj4gQXBwbGllZCwgdGhhbmtzDQo+DQo+IE9uZSByZXF1ZXN0IG9mIG1pbmU6IFdvdWxk
IHlvdSBzZW5kIGEgcGF0Y2ggdG8gZXh0ZW5kDQo+DQo+ICAgICAgICAgRG9jdW1lbnRhdGlvbi9u
ZXR3b3JraW5nL25mX2Nvbm50cmFjay1zeXNjdGwucnN0DQo+DQo+IHRvIGRvY3VtZW50IHNjdHAg
dGltZW91dHM/DQo+DQo+IFRoYW5rcy4NCg0KWWVzLCBzdXJlIHdpbGwgZG8uDQoNCg==
