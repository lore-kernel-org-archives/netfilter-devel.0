Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8037DC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Jun 2022 09:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbiFBJrK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Jun 2022 05:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233192AbiFBJrJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Jun 2022 05:47:09 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80119.outbound.protection.outlook.com [40.107.8.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB7C271798
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2022 02:47:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RwafKwWWEacQr7sKWGLmIa4LkKHPHh4xpwieEt4lp9UUkPqBp0eIT6AM8tp5SzvRk4UDzb3M55qpMzzim2iFhhtRNaf6a1tcKHWYvqM3kWv96feJHpb50/qLqltR8reVijzkUQklXzcKPRNB7gC/V2vafcv55iXjOGGcO+/oWA/X1fVJSEyFSIqg2njn/rPs1jKOl9j2XGM2n3vIUetY0EDvW8laaivUP+zPe74CFKLvWO0S/jQ/8BkMZBvVfmWTCoEXxnlg3tSA6Fi9gY3YaAOpuSeJ7BmJqT157SJIfLR70vXbhRRYgph+7vee9CiE/y59PL9c8IzbLWt6ovbauA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7SpFScIBfDSqbZs54JdCk45PCjwbH75g5TkruoPQT0I=;
 b=KElIavAI+lFTt2w3zogTK5tXNujLD6Og3diXLcrMBfhzdiun13EWLgddhY+5NVFtVWvSuxvp+830iP8Nz2y999Djud4rUsVtOi2OgwcDGMcC3QH2lr4YZt1adjr7WcanCfNFwNSw1CDrOITQZpR3F088b0a+9BQJL/IKpNnWalyIh4Yp4+degSrF/lY42W8VLmiaCBhrj6PPtGiFgC/vjAtt3fBkpcTNK0oLQxG04mqZxedWr0T06Xieq1UgmTAh9ayYdMHbAjW4mR2lKekA0CfSFLIjZjjRBOjLcTUUbZRLfiNs6srIECtxixOaH+NU2Jasi/nkrmt4RhrH6W0cZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7SpFScIBfDSqbZs54JdCk45PCjwbH75g5TkruoPQT0I=;
 b=CjyxsVlghz4oPyLPmzQx7rqSz0nlZR2LIKnp9zJr24lyhZLABfWuTIosAL/FIQZkG6y+mm1c7vK5qitv80qIauW8md9XNJZx1Labk062CZnOeh4xmxhnzquS/FpT/O48tG0I+Dgx0EuhkLhb0GvlIOWfPOcUDMsSJOKagQg+m+Q=
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by PAXP189MB1694.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:132::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Thu, 2 Jun
 2022 09:47:04 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::d134:243f:8166:a391]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::d134:243f:8166:a391%9]) with mapi id 15.20.5314.013; Thu, 2 Jun 2022
 09:47:04 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Alternative SCTP l4 tracker?
Thread-Topic: Alternative SCTP l4 tracker?
Thread-Index: Adh2ZPr9HhZ1yw7MSPK/TEsm4xJgIA==
Date:   Thu, 2 Jun 2022 09:47:04 +0000
Message-ID: <DBBP189MB14330946CBC8D2A8E953652595DE9@DBBP189MB1433.EURP189.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 96501251-2bf4-47a4-8f74-08da447cd999
x-ms-traffictypediagnostic: PAXP189MB1694:EE_
x-microsoft-antispam-prvs: <PAXP189MB16942B3E5D461F0908D72ACB95DE9@PAXP189MB1694.EURP189.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KYWR55lWsopQZ5T7v63FDXWG5csSz3T5F+4USRyACGjoBj+2BTPCxXgQXvOakOm5j/zVn4IzWJDcaz2+dHhCU8L8FNyivUvrFJYJmRqSu1EEi0zmm9xEDSZo3D/O5jFXT37msK6cUeTHT56nyjl54Jd1y2MHTSEXfkvD7K0bm15X9kCfSjl8miZtTkJGodSvX26uTsuVXIYbNb0cQtFrCMasHm61eNf9ixkA8peXhM5oojihsaHrpmW3T9MXgbJ01OzWNP4EGC3B/wPmFn/UaGl57vxL61Wtwm64oO2LH2gNpgCwkbs/OzxbX2Vl6a8GCvUy5xL81qIufrTGF3WrEyFIXGYgLcqHxhJkSxwnJV5GXLm4If2FZRKyTOAGn+z0+8uY/i8GRDa+qGjRhKViPOC95q5Zo4MQElhIjq+NR3zu5rJA5Ltu5Ax6USZSHxPFutVMPAdQRXvFNPDBwyhNpVDAH2JGqDJPjET0RsoDPOWgtozk/QcV78ltVOWQjbVwR+lUj9seF1W/3uDU6TZpxIZjFkMj+oQvUmDP9QHQ5LSl8eejUAyfBlWy/aJhbFi+ococCelL3MY9bHz3JXYmtNIGNIYqJ84q5UDkMa6ojUStLO+irkxrgrMCpEnZVhXA0SueoqLm3uInKM8zGQ6LxTf0nWDDaliomCn0i6usGOioDZuvD7bLc9C94mAivOYfKoF4qLyR4mAGP7KoKBVzeEG+yJCi9e0SD/cQNpoWmlPUuYB+lMNVq80LbFRiIBlNYtVTFH+n8v2C0ijwbn7nDR7x5ObS0ZBamFf+zby/iiw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(136003)(376002)(346002)(39830400003)(366004)(396003)(52536014)(9686003)(44832011)(8936002)(26005)(2906002)(38100700002)(64756008)(5660300002)(8676002)(76116006)(66946007)(66476007)(66556008)(66446008)(122000001)(33656002)(71200400001)(86362001)(316002)(55016003)(508600001)(38070700005)(186003)(6506007)(966005)(41300700001)(7696005)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Mlo5dVRtTGdQQ3QzL0FsNmtvakd4MkQ1bEFwUzQyYitoUGljVW10WUJubk9t?=
 =?utf-8?B?WXNvSGxWakRqQUJtM1lqSHFycmZLbEhYQ0ZaME12b3A4NUhNU2FWM2d6VkQ5?=
 =?utf-8?B?MXdCYjJKK1VGRUwrOG9lR0hvMDJXSzlhVW9ObzdNZkgxNDRjL2pTeFZmVk1E?=
 =?utf-8?B?d0NkMmFQZTZTbzJMTnRiNDJ6c0Fxb09OemNZTkh6S3lkVU13N2tYRU9tZ3Qz?=
 =?utf-8?B?VW1iVjI4R3BmTVpNNnFxdWxkT1BhYlZDWk45eUdyY1g3VnpVa2dha3l5ZWxo?=
 =?utf-8?B?WmZGM08vSXl5K3YxR01nS3N6QmVGZzVFR0RNYkMvYk4xSTNnMEFLQUY5b3gw?=
 =?utf-8?B?bXpuTHFOVTd5dnY2cER2djBXVGJUanVBcVJWNXJKUmZNT2I5SXFEV0FVL0Q1?=
 =?utf-8?B?cG93QWYyUWNPbTl2R01heUkrdG5YWm9BU2o2UGFlWjRBcXhsTXF5Z3V0dUp4?=
 =?utf-8?B?ZTR3ZnVURWo3ckwrRFBkZU5EUXl4UUdYWG1DOStLaWhJVTVlcFVhQ01jR1R4?=
 =?utf-8?B?VVZKR3ZaWDBsc1Z2UEhKcTZ5WVFTZk9ES1dMZmdsbW51VG1JN3hyVWNvVldQ?=
 =?utf-8?B?ZkJyc21YNFRLWE9MRG5Ya1l0d1JQY1REMmZJZHorSStSOUM5V3NMSURvN3Bt?=
 =?utf-8?B?anV0RnVLR2M2ckFwdVl4NzJncmVWaHRrNTh1ZFZuZU1RZzAvK0xSZmZBVlZH?=
 =?utf-8?B?Q1QvN1NGWitVa1dGa0VHZUxmZ0szbDdhNVcwV1pheVFhVWxadGI0Wnl0UzNS?=
 =?utf-8?B?RVB5ZFNOYUVmNkJhWHJrSVYvQ3NSaE5sNHNSZU9JTVNmNjBFK2lkN2cwN3dx?=
 =?utf-8?B?akxEQ056TVpHT3ZWUXE1cDhnYkg5RFBucnZLRUlOQ0tGOHV2R2gyUXM1S2tM?=
 =?utf-8?B?bUlKRmVsZG1Sa2ZpNTN2bzBjWEgyOUZoeThWWFJTcGp4WWs3V0w2NS9idm8z?=
 =?utf-8?B?S2JHYk1XeHBpRXdGZFB0TTJNWEZWc0R3MkY3bzhFblQwT1hLTFdWdGIrUmZX?=
 =?utf-8?B?ays1WFdFTnk4MHhaSnVCL3JoYmVXQzEvNGZPOFdwWGIxTGgweitldE16cGpV?=
 =?utf-8?B?YWhWUm5wbWZqbkhIWW8rMmRvditDZWRjQUxSTzFWelptTzIxUlVIYlV3WHFM?=
 =?utf-8?B?MkpERnA1MUpKR0ZkRktLLzVHT0t1MDRkbkNrRFowZXRHd1VOa2xPMnVmQ3VG?=
 =?utf-8?B?UTV2eDdMYnhXUHFZTFF1ZFZldGJraUYxVEkyNnlqYmFSVzJsMm9SbFJGTi82?=
 =?utf-8?B?ZmtHeHFEdFgwZmVkeXdqUnNUQm5PZGl1VHlYdUtIWWNKVk14aFBTWDZuREZH?=
 =?utf-8?B?N29JSFhNWWo1aGV0M0dtYTNPTFk3YWtITUkrUTAzeTlJcUo0YzVYTkdUVGFK?=
 =?utf-8?B?WXlOZ0dMbkVxQlRWRnFvd3U1Wm1YMEkrc3N1RmdObENkVWd5UlhPd0FmTFBl?=
 =?utf-8?B?T1pTbmVkVGtBNE4zRWkxa21mQjNZd3U4UnhIQ0ZjT21qV0NhV2R3b1UzUFFN?=
 =?utf-8?B?OVI2ajM2NHBNUTlaSnNkZWxmbnpHYVNFd0JzL3VjUFU2UUhENFlKY05jS1pY?=
 =?utf-8?B?TlpPZzc1VVA0Wkw4aWZrZGJRUTJNR1A5SlMzU0ViQVltaDcrZlEwZWxodUhK?=
 =?utf-8?B?clJkaUh2bWxjYjhKVGZRMWwrWTViNTdzODVycmlxWVpUSXZXN0U3RDNZalA4?=
 =?utf-8?B?WGdJUy9nMDZHNTBycU51SFJrU0NIM1RqZis0TE9tWnNuQzV6cW0zWjdiNHRC?=
 =?utf-8?B?NU5QRERDbUhJcHhHRkNIblYwQTdaNklqTFVJd0VYUHpaYjVoRGU5cFcyRmFH?=
 =?utf-8?B?bEZQZGZ0WStsSUJXTVA5cnBoeWNybzZ3RWhWU3pzcWpDMVJha1k0eG5FNWJp?=
 =?utf-8?B?bFMveEwrcXM0SE1VZ3FJRkpiMWd6T2l1dnpEZnpoSUdCRHhWMEs5UTlKc0NT?=
 =?utf-8?B?ajZiQnBjT1ZwNS80eGY5amEvSjdVSFpqa3dhZ1c4SkJlZmo5VkdxSkZGRnJI?=
 =?utf-8?B?LzNaNTByZVUxNEF5amdlWEh4MHZMaHZZM0FPeFpSUzk3MDN1UWFwVUEvWWp2?=
 =?utf-8?B?eUcybkM5dWZ1bk1hZkNNUmNQazJJdmxLOHRoRDFGQVJaT3lEYy9ZQWRjRFpZ?=
 =?utf-8?B?cVp5R0M4VW41UnlUbVJUNm5XNmswVnRJYWlYSXRGZ1ZWT3pIVm45RjdiV3RT?=
 =?utf-8?B?MVRFNEdoQTljU24yMk1DaEViMjk3SnUxeWFtN1dzMmprYnJqb3RGbXNNSU9h?=
 =?utf-8?B?VE1oTlpPcHFSOVR1azMzcTBIT2xUVytLV3h0NlNUUy9oRGt1c3l2V0F6TkJV?=
 =?utf-8?B?RlAyVXlOODV2MmFqT2JXQTd0RWFWWkV3WnErQnJ2Z1FCVVl2NzkvdUZKcmVh?=
 =?utf-8?Q?BoiBELG7wH01Us50=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 96501251-2bf4-47a4-8f74-08da447cd999
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2022 09:47:04.3538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lryM9UVkJnJ7Q/Yku1Mi7XWHCTMdmR+RhykYuAR8Xjamkk2SENWF9dS9m9bASWjeqb8wOrVyr5RefeEv8x5oe4n3Re3YyDLGhbbdx0r6K0U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXP189MB1694
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGksDQoNCkkgYW0gYnVpbGRpbmcgYSBzaW1wbGUgY29ubnRyYWNrIG1vZHVsZSBmb3IgU0NUUCBw
cm90b2NvbC4gSXQgaXMgc3BlY2lmaWVkIGluIGEgZHJhZnQgdGhhdCBzdGlsbCB1bmRlciByZXZp
ZXc6IGh0dHBzOi8vd3d3LmlldGYub3JnL2FyY2hpdmUvaWQvZHJhZnQtcG9yZmlyaS10c3Z3Zy1z
Y3RwLW5hdHN1cHAtMDMudHh0DQpUaGUgaWRlYSB3aXRoIHRoZSBkcmFmdCBpcyB0byBvbmx5IGxv
b2sgYXQgU0NUUCBJTklUIGNodW5rcyBhbmQgdXNlIHRpbWVycyB0byBoYW5kbGUgdGhlIHJlc3Qg
b2YgdGhlIHN0YXRlIGhhbmRsaW5nLiANCg0KSSB3b3VsZCBsaWtlIHRvIG1pbmltaXplIHRoZSBu
dW1iZXIgb2YgY2hhbmdlcyBJIG1ha2UgaW5zaWRlIHRoZSBleGlzdGluZyBjb25udHJhY2ssIHNp
bmNlIHRoaXMgaXMganVzdCBhIHJlc2VhcmNoIHByb2plY3QgYXMgb2Ygbm93Lg0KVGhlIHF1ZXN0
aW9uIGlzIGlmIGl0IGlzIHBvc3NpYmxlIHRvIGhhdmUgYW4gZXh0ZXJuYWwgY29ubnRyYWNrIG1v
ZHVsZSB0aGF0IGhhbmRsZXMgU0NUUCBpbnN0ZWFkIG9mIHRoZSBidWlsdC1pbiBTQ1RQIGw0IHRy
YWNrZXI/DQoNCkkgaGF2ZSB0cmllZCB0aGUgZm9sbG93aW5nIGlkZWFzLCBidXQgYW0gbm90IGhh
cHB5IHdpdGggYW55IG9mIHRoZW0NCjEuIFJlZ2lzdGVyIGEga3Byb2JlIGZvciBuZl9jb25udHJh
Y2tfc2N0cF9wYWNrZXQoKSBhbmQgZG8gbXkgdHJhY2tpbmcgdGhlcmUsIGJ1dCBnZXR0aW5nIHRo
ZSBvcmlnaW5hbCBmdW5jdGlvbiBhcmd1bWVudHMgaXMgbWVzc3kgYW5kIHRoZSBvcmlnaW5hbCBu
Zl9jb25udHJhY2tfc2N0cF9wYWNrZXQgaXMgc3RpbGwgY2FsbGVkDQoyLiBDaGFuZ2UgTkZfQ1Rf
UFJPVE9fU0NUUCB0byB0cmlzdGF0ZSBhbmQgbG9hZCBteSBtb2R1bGUgYXQgc3RhcnQgdXAgaW5z
dGVhZCBvZiB0aGUgb3JpZ2luYWwgU0NUUCBsNCB0cmFja2VyLCBhbmQgdXNlIGEgZnVuY3Rpb24g
cG9pbnRlciBmb3IgbmZfY29ubnRyYWNrX3NjdHBfcGFja2V0KCkNCjMuIE1vZGlmeSBleGlzdGlu
ZyBTQ1RQIGw0IHRyYWNrZXIgZGlyZWN0bHkgDQoNCkkgd291bGQgYmUgaGFwcHkgdG8gdHJ5IGFu
eSBvdGhlciBzdWdnZXN0aW9uIHNvbWVvbmUgaGVyZSBtaWdodCBoYXZlLg0KDQpCUiwNCi9Tcmly
YW0NCg==
