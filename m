Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2D41C761A6
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Mar 2023 11:55:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjC3LzI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Mar 2023 07:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbjC3LzG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Mar 2023 07:55:06 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on20713.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe1a::713])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A150B46C
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Mar 2023 04:54:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ND9rUT1m5EMqReNmw8DXqaN+aB8NJ4QPl6BFZfs9FiTV5frIFNuuAWMlYQh9DwGWrlpBytJMYEM1lERabDyjaWMKjG/35sjQ4xa3yZczJBtld9yiK7W/RqWFpJF213ve/bZmKY5WBGaDwQ9HQ+4yt+eXSuqQ3Gg6YeepGJzyeRShJS5NoduxsAT4+5fT0bR+IghKM6HIIpCdyQKDQ4fXhk1BPVkwGFGIfEIyrL2Hjoc9Hd9YXOsPZ9zebTujoc+oALY+MXSIG9td2OteOBEohhaC3S+mlMLM2fM68X1qfCCuGwPu5A4MixDf8WaYg4Ob8L67n5iRRt2DMVdgx9Uj7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4E6P9rlT07ZDFuH7jIKgpRkTdLt5zetHAmtAIcjAOl4=;
 b=Iz67uW2G2uQJWQ7PmYrtcaT9rzGAPdIkO+L4wT9xB9WCaBUCNVjKsWwrRQnAj3Sy27qGhSGrGH6QucpwfugIesS1jp+57MiboRqsyfa2YxQCUQzEMPNjaVrDB/WeUfLOLHomHrXnMKR+HFGRq58xL7l5xVLsSQ0tGfjaCnOUyl4kac4otMF8h3lxhh1WWRJt+gXnzx6RFKh7BI9/hJjKv9/B8gJE6FoRn7Tz312v0PTsNHIKJcqeCG9T0qt0Sy+ifa8Q4RVCxMI2Zkyy939o8/IkLTM77zP6i/1zwv87MGB+vwZHdBqFklSn5g2LG73hiaZDEvyOlPDFTi5yRZ6bmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4E6P9rlT07ZDFuH7jIKgpRkTdLt5zetHAmtAIcjAOl4=;
 b=cVYxSNV2BQ/54Emt0gaqYi+ulbLhACHEEkJmJfKTse8YWnijFmuvZzQ1VSRcytKPa+7iF5ovlR3i0h+ahXqfxbHBwHc3e8GsAlk0rKwFzHyxBLVIYx3h9XYQqkvISSqlYLNaMv112kAR18ZST7uDEpbsM4+B7TzS0uXD9/GuKw8=
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by AS4P189MB2254.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:582::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.34; Thu, 30 Mar
 2023 11:54:30 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::13ad:a312:15c6:91dc]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::13ad:a312:15c6:91dc%6]) with mapi id 15.20.6254.021; Thu, 30 Mar 2023
 11:54:30 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     Jan Engelhardt <jengelh@inai.de>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: RE: [RFC PATCH] nft: autocomplete for libreadline
Thread-Topic: [RFC PATCH] nft: autocomplete for libreadline
Thread-Index: AQHZYvvLQiXHKIeUi0ulmD6F5WOXW68TNd8AgAAAUcA=
Date:   Thu, 30 Mar 2023 11:54:30 +0000
Message-ID: <DBBP189MB1433A50ACB1020757E63F569958E9@DBBP189MB1433.EURP189.PROD.OUTLOOK.COM>
References: <20230330112535.31483-1-sriram.yagnaraman@est.tech>
 <69r697s-n01r-s6qs-q766-1n31826q6s0@vanv.qr>
In-Reply-To: <69r697s-n01r-s6qs-q766-1n31826q6s0@vanv.qr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DBBP189MB1433:EE_|AS4P189MB2254:EE_
x-ms-office365-filtering-correlation-id: ca471c88-5947-4a19-a17f-08db31158584
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nYiWjgCuaFswkNuo85GNBFYujUSCPmDF47EexfY+GjsCskYj5Kh9bF9KHMT4YKR5+7Q5xjn5kRCVKQqmL33/OOmZyQ7l+opZx+dAY5qmEru8EE1vt0Fxn3O8nBuvbmuw5iAdhcag5dzCwC7PijN/58znXXaB/md9+yONRn1V9zj5hkSnMDZRwQRHy4gRQI7gJ+ZQ/686cjL06BIDz2sjW/becmN1jePZ6KBLJmaZsP1nOI+fWJ62tuMkoyZX72/LxfjfPmIhrV1G/FY5Vtc7bevC3jWTMEsx6ntwshqgiRTZ5WuL8ai7GAa2Uj36relXnMY+cYVPzqLNDOi4NbsML8C6ZnAhpbKpIE2PXN55pqkAZoTZcu5iTJJSxXF7FYZn96rdIkpBk0MhTuxktisGfOu/w0oka4FciG88fOOJzJ3JvtgJIr8sylx9FiNfDvT8gulDLlBAzLgiVUCM7pQto2bQJ+dbY34l+QFkLCCxEB1mKxorrNgACZvo7piygGTPQHAexRqt06cbAonQ2y0Unw+gc1we3rh7JfZxWz0Z9PzWV5tvIgaJdgQDN0eDK3ifTNIoIUyffJZNko5gr9t6hqZMLdnc+687WC38RzOUi0HcISfblXlYdxGegpn4SDdO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(376002)(396003)(346002)(39840400004)(451199021)(55016003)(64756008)(6916009)(8676002)(66476007)(66446008)(66946007)(66556008)(4326008)(122000001)(5660300002)(316002)(38100700002)(52536014)(54906003)(41300700001)(76116006)(186003)(8936002)(83380400001)(6506007)(9686003)(53546011)(478600001)(7696005)(71200400001)(44832011)(38070700005)(86362001)(4744005)(2906002)(33656002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q3JUVEkrbHBGUGUwZVVJdzh4WnhyanhmVkl2ZFF1U1pIdkpFZVlnRzNHOEEz?=
 =?utf-8?B?dkorSVZuZ1JXOVNGWFpVRG51dkhrT0JqSVY5UHRiL29jTWI3enlvRFZzUDlT?=
 =?utf-8?B?c09hYzJxcEF6Sy9hQWFpalRUc0hLVnNRN25hUEpVeThPaURtaXJ3d1ZQbVkx?=
 =?utf-8?B?SFdnSjh1S25wY3NDU0x0V2FIcFZ5NDhPMnZOQStZcXU3K2ZIU0RCUXJ6WEhW?=
 =?utf-8?B?OVdKcFdRa2FYNFh2aG9wZTJ1QnBnL1JuZkE2MlZMMjFuM0J0Zm1IY2wzTHNN?=
 =?utf-8?B?VmFLNnJpczllQzAxZ0JRb3VQVDB3cFh0dy9RS05pRTdhdTBPNXJMVkJmV3p3?=
 =?utf-8?B?TkJTTlQ3cm5neU5iVHpuemV0RTRTZGhRTGpxbkErSHRpMHZ0WTBMcHdYOWFq?=
 =?utf-8?B?d0RQVzZnc1p3aUQwRkF5NG9sc1o1RTMzM3k1dnlHS2puaVkrSTdhci8rUDQ1?=
 =?utf-8?B?SnJBU2hYY0lKb0RQemRidEtaSG1jZXBEUzNGVjFZaXVCMHhGTU13ZU5YVDV3?=
 =?utf-8?B?S0RiY1lOVHZTNHFhaENRMENaWG0yY1Y4L0ZKMTN6b0lKQmNnSjRQRE96R0U0?=
 =?utf-8?B?dDU0QnY3Y0MwdzQyTThvckc4V3ZCN1dXYk4xZDNRZVQ5VUU4UGQvQVV2WklQ?=
 =?utf-8?B?RVJ5dUszVFlGcFdYZWZjeXRNZ3FpSFgxY2hXU01lQSs1ZGVkWmhURTJkaWdG?=
 =?utf-8?B?MlhoYUoxL01wREQ5Y016T003Y3lCWjU0RUp2YmoxbHUyVTNiZkMyU1A1UzFY?=
 =?utf-8?B?N2I5WWM0YkRNaXhOUnRBZDJjdXd3ckIzdlVlclM4QlRmUE9JMzh5Yk5YbE8w?=
 =?utf-8?B?Z0E3bUhHT0piNnVhR2xaTjMwQUsrcWFTZVZEanBraFF5NXVwL0VOeXBjNUNK?=
 =?utf-8?B?T2hXT0t4d2E2ZEJHZzh2akRPd3JaZVdXNThwdmR1d3g4SzNVL1ZQcjRGWUxn?=
 =?utf-8?B?ckpNM2hQWCtPaUgyeDBVNXFWSi9WbldpcmlQUjd5cVhOYnJ6SFlJZVFSR0th?=
 =?utf-8?B?c3hMQlhjQm13VGlHU2hDM2hxbmt0R0hTaUYzejROTSt2ZXpTblUxN2tXcEFJ?=
 =?utf-8?B?VkdhSzJWOVdTSkIrVW9NZzhqQklXWkREWVZ2RjBDeGFQMDVqREd6WjNFdUNL?=
 =?utf-8?B?TFZGWG1Genp0QmJEbWVscEE3U1JyK3p4czJQK25JWkU4WDJ6amtqMTFlT21B?=
 =?utf-8?B?TFMwVjUxOEZkS201SEVFQ0c0S3VPVWpXbWtjNnB3VDA5NVZOdkNma2JtYk0z?=
 =?utf-8?B?S21tcm1hOXB2aWxxNnRYcys4VGszaTJ4TDB4RCtLR01XL3ZONWxDZUNmalVZ?=
 =?utf-8?B?ZVhUVGtTbEY5NWlYL2NTdUVBZ3pUa3lHeno0VjZHODlWTE1CNWtuQlRhTGh2?=
 =?utf-8?B?RHU2MDRGNDN6b2ZDSHpWSjN6ODdxU2drd2I4R0RjdDYwb2VrNlRLeFRmR3hQ?=
 =?utf-8?B?NWdnOXJrZUxidWVCcWx6cGdaVE9DeWdiLzVnV3VmeVNJd3pkL0JCUFFabVoz?=
 =?utf-8?B?UWhvTnZvajBObTBIMmFHRHBaRHluVE1TamtPSEMraVEvdEhkeHlyK1lQN3Zj?=
 =?utf-8?B?QXo1dHlydTRscld3cDVXeEU1U2kxbWVRSkEyL0cyb05leXdPNkprdmgydE05?=
 =?utf-8?B?RXptdU5UUUVjUDJwamozQlM5cWlCWEtyYUdwMUJRaU4rWkt5azJNSGdIWlFF?=
 =?utf-8?B?amxYbTM2c1RFMHcvakFRUFBSR0ZFME1XazdhV3Z2WjBWc0VmV2FaK1JzRnNa?=
 =?utf-8?B?dThGSTZsY2ZOajVlZ1MweEJXSUo3ekpjTUtYNmdJL2w2MFU2UnZVQUhORndC?=
 =?utf-8?B?MWk1Q0taWHV6eGdNQlRFSW5oYTBGR1J6QzcvSUlDbXN5akR5U3k3WXlYRWI1?=
 =?utf-8?B?bTNyRnpFTWdIa1h5bk4vVlFXNk5PQkd1UFZ3V1RHQ1RON1JDcHZiR0ZTVEho?=
 =?utf-8?B?T2RsRkVacTFxek9GUFlOQlY5VVJtWGxFS3o3NjhqcEJ0VHpTUENBcUZJR2dl?=
 =?utf-8?B?WldpaTI4eGdQdy9aYlVZU3JHTGhuZjdIRmorcjdNZ01wa0hwQUc5VCtDdzhS?=
 =?utf-8?B?RzZTd0ZWL0lMRzJScXhxcnoxVXFDUmU5QUVITFVoaENhVDVKUFVBSGZLTDJE?=
 =?utf-8?Q?Dcls9kYCWZqp6F5iyNeg2YPev?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: ca471c88-5947-4a19-a17f-08db31158584
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 11:54:30.6799
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wf3PKVHQQDGdWBaaIVRygP3bWlgQkPaIkVaCtYJwLc3jscGDwOq9AKLmCnGKQV37bDEJ3qWx/nUxVghrSZRG9TuIZVqJI0FnXEyuXNrpGI8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4P189MB2254
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEphbiBFbmdlbGhhcmR0IDxq
ZW5nZWxoQGluYWkuZGU+DQo+IFNlbnQ6IFRodXJzZGF5LCAzMCBNYXJjaCAyMDIzIDEzOjUxDQo+
IFRvOiBTcmlyYW0gWWFnbmFyYW1hbiA8c3JpcmFtLnlhZ25hcmFtYW5AZXN0LnRlY2g+DQo+IENj
OiBuZXRmaWx0ZXItZGV2ZWxAdmdlci5rZXJuZWwub3JnOyBQaGlsIFN1dHRlciA8cGhpbEBud2wu
Y2M+OyBQYWJsbyBOZWlyYQ0KPiBBeXVzbyA8cGFibG9AbmV0ZmlsdGVyLm9yZz47IEZsb3JpYW4g
V2VzdHBoYWwgPGZ3QHN0cmxlbi5kZT4NCj4gU3ViamVjdDogUmU6IFtSRkMgUEFUQ0hdIG5mdDog
YXV0b2NvbXBsZXRlIGZvciBsaWJyZWFkbGluZQ0KPiANCj4gDQo+IE9uIFRodXJzZGF5IDIwMjMt
MDMtMzAgMTM6MjUsIFNyaXJhbSBZYWduYXJhbWFuIHdyb3RlOg0KPiANCj4gPi1saWJuZnRhYmxl
c19MSUJWRVJTSU9OPTI6MDoxDQo+ID4rbGlibmZ0YWJsZXNfTElCVkVSU0lPTj0zOjA6MQ0KPiAN
Cj4gXiBUaGlzIGxvb2tzIHZlcnkgbXVjaCBpbmNvcnJlY3QuDQoNCkkgY29uZmVzcyB0aGF0IEkg
aGF2ZSBubyBpZGVhIGhvdyB0aGlzIHZlcnNpb25pbmcgd29ya3MuIEkgd2FzIHVuYWJsZSB0byBh
ZGQgdGhlIG5ldyBsaWJuZnRhYmxlcyBBUEkgd2l0aG91dCBjaGFuZ2luZyB0aGlzIG51bWJlci4N
ClBsZWFzZSBhZHZpc2Ugd2hhdCBJIHNob3VsZCB1c2UuDQoNCj4gDQo+ID4tLS0gYS9pbmNsdWRl
L25mdGFibGVzL2xpYm5mdGFibGVzLmgNCj4gPisrKyBiL2luY2x1ZGUvbmZ0YWJsZXMvbGlibmZ0
YWJsZXMuaA0KPiA+K2NoYXIgKipuZnRfZ2V0X2V4cGVjdGVkX3Rva2VucyhzdHJ1Y3QgbmZ0X2N0
eCAqbmZ0LCBjb25zdCBjaGFyICpsaW5lLCBjb25zdA0KPiBjaGFyICp0ZXh0KTsNCj4gPi0tLSBh
L2luY2x1ZGUvcGFyc2VyLmgNCj4gPisrKyBiL2luY2x1ZGUvcGFyc2VyLmgNCj4gPitleHRlcm4g
Y2hhciAqKmV4cGVjdGVkX21hdGNoZXMgKHN0cnVjdCBuZnRfY3R4ICpuZnQsIHN0cnVjdCBwYXJz
ZXJfc3RhdGUNCj4gKnN0YXRlLA0KPiA+KwkJCQljb25zdCBjaGFyICp0ZXh0KTsNCg==
