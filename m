Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1499AC433DB
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Mar 2021 03:31:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1CBD64E90
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Mar 2021 03:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbhCEDbK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Mar 2021 22:31:10 -0500
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:43902 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhCEDbK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Mar 2021 22:31:10 -0500
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 54835891AE;
        Fri,  5 Mar 2021 16:31:08 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1614915068;
        bh=KD1juPyXNCgiool63yGexf0dRtNlatc2uFIxPsMc+Xk=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=v1Vam4TOnkrX079zzIV8KehQMJy0kMy2wJpRjdG5hX7yWu28s77ZDfdzcmdKxFdEA
         AQF8Au8N4klze+h1a5pAGubiMBGrmfSxYH7qaUya2rD+KK6jW+zbYt5FqEcoOcxbtu
         kB57vQW9VTmZO6DNP1QVhOysiPag6h5r9vCIkABGPGLslsZOG8l0uZoWjpEIweDLQS
         s9GpLchVWvECXwat6SQpDcpVQ7phrUAGRZQ/BSCtCoOwas9YubGl8boBBQHEWUsX/l
         7L8bEvzXy47myorTaj4vAmU9dyX86tAemshBFAFJps2dxluQmgpSdkg9qIcaIq52iI
         AIuXDOk55VORQ==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B6041a5d90000>; Fri, 05 Mar 2021 16:30:33 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Fri, 5 Mar 2021 16:30:31 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.012; Fri, 5 Mar 2021 16:30:31 +1300
From:   Mark Tomlinson <Mark.Tomlinson@alliedtelesis.co.nz>
To:     "fw@strlen.de" <fw@strlen.de>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "kadlec@netfilter.org" <kadlec@netfilter.org>
Subject: Re: [PATCH 3/3] netfilter: x_tables: Use correct memory barriers.
Thread-Topic: [PATCH 3/3] netfilter: x_tables: Use correct memory barriers.
Thread-Index: AQHXEJYqSIGupJItGUut6XOWJvc4xKpymfUAgAFKuQA=
Date:   Fri, 5 Mar 2021 03:30:30 +0000
Message-ID: <631d774f41a564b28d40a5639a58f1ab0d7f6e03.camel@alliedtelesis.co.nz>
References: <20210304013116.8420-1-mark.tomlinson@alliedtelesis.co.nz>
         <20210304013116.8420-4-mark.tomlinson@alliedtelesis.co.nz>
         <20210304074648.GJ17911@breakpoint.cc>
In-Reply-To: <20210304074648.GJ17911@breakpoint.cc>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:df5:b000:23:2d77:907a:1462:3c65]
Content-Type: text/plain; charset="utf-8"
Content-ID: <4016757BD182D84D86CB42E80B012C05@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=C7uXNjH+ c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dESyimp9J3IA:10 a=j5wOGto6lCVxjVACX6YA:9 a=QEXdDO2ut3YA:10
X-SEG-SpamProfiler-Score: 0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

T24gVGh1LCAyMDIxLTAzLTA0IGF0IDA4OjQ2ICswMTAwLCBGbG9yaWFuIFdlc3RwaGFsIHdyb3Rl
Og0KPiBNYXJrIFRvbWxpbnNvbiA8bWFyay50b21saW5zb25AYWxsaWVkdGVsZXNpcy5jby5uej4g
d3JvdGU6DQo+ID4gQ2hhbmdpbmcgdG8gdXNpbmcgc21wX21iKCkgaW5zdGVhZCBvZiBzbXBfd21i
KCkgZml4ZXMgdGhlIGtlcm5lbCBwYW5pYw0KPiA+IHJlcG9ydGVkIGluIGNjMDBiY2FhNTg5OSwN
Cj4gDQo+IENhbiB5b3UgcmVwcm9kdWNlIHRoZSBjcmFzaGVzIHdpdGhvdXQgdGhpcyBjaGFuZ2U/
DQoNClllcy4gSW4gb3VyIHRlc3QgZW52aXJvbm1lbnQgd2Ugd2VyZSBzZWVpbmcgYSBrZXJuZWwg
cGFuaWMgYXBwcm94LiB0d2ljZQ0KYSBkYXksIHdpdGggYSBzaW1pbGFyIG91dHB1dCB0byB0aGF0
IHNob3duIGluIFN1YmFzaCdzIHBhdGNoIChjYzAwYmNhYTU4OTkpLg0KV2l0aCB0aGlzIHBhdGNo
IHdlIGFyZSBub3Qgc2VlaW5nIGFueSBpc3N1ZS4gVGhlIENQVSBpcyBhIGR1YWwtY29yZSBBUk0N
CkNvcnRleC1BOS4NCg0KPiA+IEhvdyBtdWNoIG9mIGFuIGltcGFjdCBpcyB0aGUgTUIgY2hhbmdl
IG9uIHRoZSBwYWNrZXQgcGF0aD8NCg0KSSB3aWxsIHJ1biBvdXIgdGhyb3VnaHB1dCB0ZXN0cyBh
bmQgZ2V0IHRoZXNlIHJlc3VsdHMuDQoNCkkgaGF2ZSBhIHNjcmlwdCB3aGljaCBtYWtlcyBhcm91
bmQgMjAwIGNhbGxzIHRvIGlwdGFibGVzLiBUaGlzIHdhcyB0YWtpbmcNCjExLjU5cyBhbmQgbm93
IGlzIGJhY2sgdG8gMS4xNnMuDQoNCg==
