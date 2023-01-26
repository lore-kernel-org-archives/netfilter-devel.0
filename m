Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED1DBC05027
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Jan 2023 09:02:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236504AbjAZJCu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Jan 2023 04:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236663AbjAZJCc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Jan 2023 04:02:32 -0500
Received: from outbound.mail.protection.outlook.com (mail-ve1eur01on2113.outbound.protection.outlook.com [40.107.14.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3786C555
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jan 2023 01:02:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M/U8P/5CdtVr3aL9DXJs15CxRGMdT7rMzbPXp1ctW+oF63INdIO3+CK8tBz2BmDn39JfRQKmZOu382sxG4N26HVuARuaU01u4HH5sK2Fd2I1gdwjD7ovgSKcAIs4XRUQu9ODxElt4OnbUAi72SebrpfJmnU9P60EUViUPcGsj22LDycubx36VsjWUpncCeiUr2gH792NJyQzN+FXyGO7QCGwJDty5qgzYRBaKrtGtddHNC8Ef+2idqlYzKqpEWKJ07ETvwsaz88TN7+l0vN6gTEV70k8r0rxtepPKy77JdZft+epM0D1W7nAiSa1BLbXT4giOslJHFldV34UkLWJPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CN5HuR4XyjOnJHuipDr5mByDTJB/7rOIkyHOFejxzes=;
 b=WRHdolj0+4LwQw1uYkq8DkGDqCUxzIU605E+ossVpHbTG1IYcF4elXjykkuwd/pd43ChmTHW6ircHp8sYOOuuuFBn07/EzVsqZUDfD/B10G3V6cEpG98zdIHkh/frZnsb7qt3JG/rnpbhLT50vFrn1nfyrYQp3YVxAyFb+Wttyc+Q2s7QZR5g4ZrPJTHZmoHV0zMlqiIKiy634vLpdI+/mq+6Og5deZhI+RJechi8GL63JvE/9TtKtbo7hvft8OIrJq0FpuStmXqPB3biD3Za1gGnJrskFqukhiJfPJIqgbvZT89w17uCNaEo4CU5d2IlLaXZKa8OGqkIAbwX3wkAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CN5HuR4XyjOnJHuipDr5mByDTJB/7rOIkyHOFejxzes=;
 b=O4gr1q1cpYO3HNmjp8Q80Sl1bfTnvUj8stbYiYNZvKod2CFHoYpAyb10pw/JyMPZfau2wIkLcxiDWjZ+dHuUWPttOMqkUD5b8m9Dj52GulTo73o5U26xqGs09Kz1XvAxWXHQEXBIwFma4+PClCIpEzcDV71RHBNroCnGuYcPDbU=
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by PR3P189MB0953.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:47::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 09:02:15 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420%7]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 09:02:15 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: RE: [PATCH nf] Revert "netfilter: conntrack: fix bug in
 for_each_sctp_chunk"
Thread-Topic: [PATCH nf] Revert "netfilter: conntrack: fix bug in
 for_each_sctp_chunk"
Thread-Index: AQHZMSaDCMPS0hht/E6OebsFD80o5K6wZg1Q
Date:   Thu, 26 Jan 2023 09:02:14 +0000
Message-ID: <DBBP189MB1433AB4076A05619FC93A59C95CF9@DBBP189MB1433.EURP189.PROD.OUTLOOK.COM>
References: <20230126013521.21836-1-fw@strlen.de>
In-Reply-To: <20230126013521.21836-1-fw@strlen.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DBBP189MB1433:EE_|PR3P189MB0953:EE_
x-ms-office365-filtering-correlation-id: 40813a4a-47ce-44ce-181c-08daff7c04e3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5e20BHiC6JFkID8joIXw7z8Z3IJBoqf1UhAwrZRSdu6qSYNuGqLCztDJT7QCK9NfX444lKG8Ohr5ZoXb974qqmtsPCeg7kVsWA2Ev5n0xUbVRWq5fiuCrL0R71+Tq4HdnScLjOoiT5i+o8T12xkLYvBwAtMYnQ9hQYHqWWXlm60yrwSqAw5NC/sznWLYVFBemXfHkWrBwWpQwYJxURHHHeu3mYgnZtdqkDtx/Q4G2+UeM0dxieCLjcJ8fg/gfC8k/A29ZgZo9lpJgXaQgB/e7ow7bEPF1OcLm+xMONzZRu+3GVLh/NTnHqzBvmFeVSUSpNdyiJaTBDLm9SlZxHSaF0/gmBBhJevp1qZjjulO2z6BzXTKK63vqUjESQM1hKtjnjDQaYBJidlT5vTimkHvHyKrumLwnwOCEUC0l6tcJFlf7Eaj9Bvr746h1akdbjWrR7DRWEXA/lo6kVEkld3CHNTzA6X12E7VmBsD0UcXfpNifQNEQms0p6kIkq4aIMg7co+ZH7CwH0qgCcDQ6A1mD1N9xvRVR3lam70LALm2rWEj0UGLIkZfzQnRypbi416xIyLlf/Ny95g+Fv6qlLYIVzIVvZMIMILPSNh+B0xQYw6m62nbYK7E0nfevm5RqeDLt3XEfXBKC950/C+HRIvhG0SnIgJquB1WYfKXN1vbbxOJM2aPZe8YDPxJ5bC5E5fl2Pk6gu6EzKzLFQDbAdNyO+fTXIwT64SrkYTKnzz8w5c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(136003)(39840400004)(376002)(451199018)(8936002)(38100700002)(6506007)(52536014)(53546011)(44832011)(9686003)(26005)(186003)(33656002)(966005)(55016003)(38070700005)(71200400001)(7696005)(2906002)(86362001)(478600001)(5660300002)(316002)(110136005)(83380400001)(66946007)(41300700001)(76116006)(66556008)(66476007)(66446008)(8676002)(64756008)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VGR2K1RxWHptV0hmc1BtdEVXRENxclVwZVJLOGRMZGZJVGJPOTlRUDRLZXlY?=
 =?utf-8?B?aExiZkNKeG13enI0d1ZNcDVCRkdXY05XMnBSbjFlT3BGOEc2aUFMZElNUWcx?=
 =?utf-8?B?VzdNbVNGT0ZxcjR2V1FIZ3dJNkxHM1laVnZrUVpON3NTYlpNaitYVXFFeE1Y?=
 =?utf-8?B?Q3Vvdm5sak0vay9BZVNaWDBiTnVMd05yVFMva3kvT0NuUGJRSEkzcEQ3Tll6?=
 =?utf-8?B?S3dMNEZpM1NnYWMySjVKdUZRZGJBd1VrdGdSdWwrVCtRTW55a01KZ3IyYmVK?=
 =?utf-8?B?c3lOUFF2LzBqTCttcFpVUzRQRysrVk82NUxEOVVqdlArWlhhQ0VxaExvUnJs?=
 =?utf-8?B?RkpKK3ptNmhKUmZFbmROM1QvUEF6ams5VDZ2Q3hrTm9RVXZOb1g5aExINVdy?=
 =?utf-8?B?SUMxVVVXU2g1bzVRMFZGN2NqcVF3UEhkZE9INEd0bUt3QTZQdnc1MFpMZytN?=
 =?utf-8?B?WkFLRS9sYTd1S0t2TFRGTkJJcExVTUV0SW9LRktIQStBdzVRM3VUZHltdUk4?=
 =?utf-8?B?QWZjcVJkT3BxWi9vYzViSmRQRDhjMDRXM3VKalg2SHhpYkNzcGJaeXJIb2o4?=
 =?utf-8?B?My85VU5tU1RDUWRFVmlFN1FXY3ZxWGwraVV1SG9mRmlOcEwxNmN3NkQrZ2Q5?=
 =?utf-8?B?dEF5bXA3dzNITlp0ZzJ6RXFWRURqUTFEMkZrMXAzTWVlbE5lYjJqQlZJUHIr?=
 =?utf-8?B?RnoyaXdzTjBmdW1yTzY0MUNudk01ck44ZTZNNVRZcEk1WFZyYktTazFGNFUw?=
 =?utf-8?B?WjhTbFhqWjNjUlBRWGpVL2xWdnRNU1l4OGZRU09ETFJadnI0K2tSTmdCN1dH?=
 =?utf-8?B?U0dwM1dac1hWSXoyM2IxaEV5TWN4VGg3Umg5UjRlYkhYbW51ZTkxcFZOeXE5?=
 =?utf-8?B?Y0ZVWVhJNkJNTFk4OGtxbktSZGhybm50UDZDZUNZc3NYSExqQWU3OFN5d1Qz?=
 =?utf-8?B?QmZXeEZTUHFmYlE5THIySkJsVjZFa09pMEpxN2VtZjU0WmxPdi85aU4xOUN1?=
 =?utf-8?B?b0JVaUtDcWMxbkxoazVVRTZ3SUphaitpN1hQWG1TbkNSUlYzV05seUZEamlp?=
 =?utf-8?B?WXJKYlpkb2RtR2puWTNwb3IxNXRYNmtwOHhUL1VlTlgxa2ZGMjNVYUpzaWps?=
 =?utf-8?B?b0ZYUS9iVEUrTXV1bGppMXFzUFhZN3NOOVowL0xRYk4zbjdiUGdUNk92L1R3?=
 =?utf-8?B?YWl2WklDUjdXNzNQZFZKWk01ME9PWHFWR0QzcDhsN2RxeCtBNzVRdnRaaUZ5?=
 =?utf-8?B?MjV3dnFnTm5Jck5SakdRYWc5Nk5pWmo3VHFjdFhWbmtjeit0bG1QOCtnTHhw?=
 =?utf-8?B?Zm1Ka0VCb2RqS0lQQjNaUXRHSTRKTVdyQ1h5SXNFcjA5TWcxWW5Ga1VrbENU?=
 =?utf-8?B?cUF2aGFOMmx2cGc2L2tpamFPNUlqQ3dxWVJyQklrR1FmS0dOQ2E0THZ1YUpq?=
 =?utf-8?B?SHBoNkZCVW1iVFV6VVRrTTNxY2hUOG1zS0VSZmFvV2diRzRqWldMd0tJYWVP?=
 =?utf-8?B?ODZJYTViZU44OHBiWjZ2R1hicE1jdUhoQko5S3gxUHExdGNaTWsrNmhIT3hy?=
 =?utf-8?B?ZmhiVU55RzJaTW0xT2xvbHQ4SDM3ZU01RFhFYTN4Mkt2YjBLdTJta0xRV25X?=
 =?utf-8?B?ZWdGSTZPbnBENjQ4alZZVzZTOE1jTlRFOFc1OWF2Mm1KMDEyekFDaXhNNDlN?=
 =?utf-8?B?akorZ1hqeDA5MXVQQnhyeVA3VGRIalk2dktuSkppdCtmdVIzam85OXhMdHZF?=
 =?utf-8?B?V0pkWWVyeVVaMDRhRERJOVBFaytmZ0JwVXdua2ZBYmNVNWVaZ1BGdTJ5bWJq?=
 =?utf-8?B?c1dtR3RDUklSMlduTkkvdm1uSTFiZlRjcHlVUWpSaHBQQjBkMjBWcll0MzFM?=
 =?utf-8?B?QnJPY0hOOGttMGJDWWxMVi9LbWltdUFZbXNVN2VwalRHd3hDK0pIdFJsUmpw?=
 =?utf-8?B?aHppZGhsYkJUdHBHR2RGVUpJajN4ajNhajFOYVFTWjZkaUhGNWZIdW1OMEsy?=
 =?utf-8?B?eWI5QWs0MkY3Z2E2WkxTRDByMkMyRVF5MXZjRFNSWFJjL2FuL2RuaHYxRTI5?=
 =?utf-8?B?OHI1ckw3d0Ewa09JM0pLM0psNU1sOFZTcSszSTJpSmZOdmlyYThCWlBnTzda?=
 =?utf-8?Q?HHAg/Gm7mwDIXDag8BEuZ8DTD?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 40813a4a-47ce-44ce-181c-08daff7c04e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2023 09:02:14.9209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ojq9uQkATZBJ2VJHlamDrKJFkZmMsWng4tbCFv2czeqJVyt4Wm1gLKwgBGEw6+2oa4mw+DgqSKAsTaGQas1T7jrS7eSe8CrfpzYq4P9IDsM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3P189MB0953
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEZsb3JpYW4gV2VzdHBoYWwg
PGZ3QHN0cmxlbi5kZT4NCj4gU2VudDogVGh1cnNkYXksIDI2IEphbnVhcnkgMjAyMyAwMjozNQ0K
PiBUbzogbmV0ZmlsdGVyLWRldmVsQHZnZXIua2VybmVsLm9yZw0KPiBDYzogRmxvcmlhbiBXZXN0
cGhhbCA8ZndAc3RybGVuLmRlPg0KPiBTdWJqZWN0OiBbUEFUQ0ggbmZdIFJldmVydCAibmV0Zmls
dGVyOiBjb25udHJhY2s6IGZpeCBidWcgaW4NCj4gZm9yX2VhY2hfc2N0cF9jaHVuayINCj4gDQo+
IFRoZXJlIGlzIG5vIGJ1Zy4gIElmIHNjaC0+bGVuZ3RoID09IDAsIHRoaXMgd291bGQgcmVzdWx0
IGluIGFuIGluZmluaXRlIGxvb3AsIGJ1dA0KPiBmaXJzdCBjYWxsZXIsIGRvX2Jhc2ljX2NoZWNr
cygpLCBlcnJvcnMgb3V0IGluIHRoaXMgY2FzZS4NCj4gDQoNCkFoIHllcywgcGVyaGFwcyB5b3Vy
IGNvbW1lbnQgd2FzIGZvciBbMV0sIHdoZXJlIGZvcl9lYWNoX3NjdHBfY2h1bmsoKSBpcyB1c2Vk
IG9ubHkgb25jZSBpbiBuZl9jb25udHJhY2tfc2N0cF9wYWNrZXQoKSwgYW5kIEkgZGlkbid0IGNo
ZWNrIGZvciAoc2NoKS0+bGVuZ3RoLg0KVGhlIChzY2gpLT5sZW5ndGggY2hlY2sgaW4gZG9fYmFz
aWNfY2hlY2tzKCkgd2FzIGFsbW9zdCBpbnZpc2libGUgdG8gbWUgOigNCg0KWzFdIGh0dHBzOi8v
cGF0Y2h3b3JrLm96bGFicy5vcmcvcHJvamVjdC9uZXRmaWx0ZXItZGV2ZWwvcGF0Y2gvMjAyMzAx
MTEwOTQ2NDAuMjQ2NjMtMS1zcmlyYW0ueWFnbmFyYW1hbkBlc3QudGVjaC8gDQoNCj4gQWZ0ZXIg
dGhpcyBjaGFuZ2UsIHBhY2tldHMgd2l0aCBib2d1cyB6ZXJvLWxlbmd0aCBjaHVua3MgYXJlIG5v
IGxvbmdlcg0KPiBkZXRlY3RlZCBhcyBpbnZhbGlkLCBzbyByZXZlcnQgJiBhZGQgY29tbWVudCB3
cnQuIDAgbGVuZ3RoIGNoZWNrLg0KPiANCj4gRml4ZXM6IDk4ZWUwMDc3NDUyNSAoIm5ldGZpbHRl
cjogY29ubnRyYWNrOiBmaXggYnVnIGluIGZvcl9lYWNoX3NjdHBfY2h1bmsiKQ0KPiBTaWduZWQt
b2ZmLWJ5OiBGbG9yaWFuIFdlc3RwaGFsIDxmd0BzdHJsZW4uZGU+DQo+IC0tLQ0KPiAgSXQgbWln
aHQgYmUgYSBnb29kIGlkZWEgdG8gbWVyZ2UgZG9fYmFzaWNfY2hlY2tzIGFuZCBzY3RwX2Vycm9y
ICB0byBhdm9pZA0KPiBmdXR1cmUgcGF0Y2hlcyBhZGRpbmcgZm9yX2VhY2hfc2N0cF9jaHVuaygp
IGVhcmxpZXIgaW4gdGhlICBwaXBlbGluZS4NCj4gDQo+ICBuZXQvbmV0ZmlsdGVyL25mX2Nvbm50
cmFja19wcm90b19zY3RwLmMgfCA1ICsrKy0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRp
b25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL25ldC9uZXRmaWx0ZXIv
bmZfY29ubnRyYWNrX3Byb3RvX3NjdHAuYw0KPiBiL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNr
X3Byb3RvX3NjdHAuYw0KPiBpbmRleCA5NDVkZDQwZTcwNzcuLjJmNDQ1OTQ3ODc1MCAxMDA2NDQN
Cj4gLS0tIGEvbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfcHJvdG9fc2N0cC5jDQo+ICsrKyBi
L25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX3Byb3RvX3NjdHAuYw0KPiBAQCAtMTQyLDEwICsx
NDIsMTEgQEAgc3RhdGljIHZvaWQgc2N0cF9wcmludF9jb25udHJhY2soc3RydWN0IHNlcV9maWxl
ICpzLA0KPiBzdHJ1Y3QgbmZfY29ubiAqY3QpICB9ICAjZW5kaWYNCj4gDQo+ICsvKiBkb19iYXNp
Y19jaGVja3MgZW5zdXJlcyBzY2gtPmxlbmd0aCA+IDAsIGRvIG5vdCB1c2UgYmVmb3JlICovDQo+
ICAjZGVmaW5lIGZvcl9lYWNoX3NjdHBfY2h1bmsoc2tiLCBzY2gsIF9zY2gsIG9mZnNldCwgZGF0
YW9mZiwgY291bnQpCVwNCj4gIGZvciAoKG9mZnNldCkgPSAoZGF0YW9mZikgKyBzaXplb2Yoc3Ry
dWN0IHNjdHBoZHIpLCAoY291bnQpID0gMDsJXA0KPiAtCSgoc2NoKSA9IHNrYl9oZWFkZXJfcG9p
bnRlcigoc2tiKSwgKG9mZnNldCksIHNpemVvZihfc2NoKSwgJihfc2NoKSkpICYmDQo+IAlcDQo+
IC0JKHNjaCktPmxlbmd0aDsJXA0KPiArCShvZmZzZXQpIDwgKHNrYiktPmxlbiAmJgkJCQkJXA0K
PiArCSgoc2NoKSA9IHNrYl9oZWFkZXJfcG9pbnRlcigoc2tiKSwgKG9mZnNldCksIHNpemVvZihf
c2NoKSwgJihfc2NoKSkpOw0KPiAJXA0KPiAgCShvZmZzZXQpICs9IChudG9ocygoc2NoKS0+bGVu
Z3RoKSArIDMpICYgfjMsIChjb3VudCkrKykNCj4gDQo+ICAvKiBTb21lIHZhbGlkaXR5IGNoZWNr
cyB0byBtYWtlIHN1cmUgdGhlIGNodW5rcyBhcmUgZmluZSAqLw0KPiAtLQ0KPiAyLjM5LjENCg0K
