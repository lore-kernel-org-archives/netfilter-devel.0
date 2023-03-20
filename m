Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41AE6C6FD1D
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Mar 2023 23:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjCTXfR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Mar 2023 19:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjCTXfR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Mar 2023 19:35:17 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A6235ED2
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Mar 2023 16:35:13 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 007E72C0380
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2023 12:35:07 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1679355308;
        bh=1I+qIeAHOD0qyqjxyrwbLz0MEplwgXrPOPQ46bdgodA=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=YqsMUMjs3se4AtnP8xb6MePpm1etKdNaFQYYjD9lFG6p7e9u9uwm5CcLhi3Q5Aq/q
         fyWM89+uTqm1kxWniEiOrKfKEjzq6k311Jor54Y+xDJnNc0Pa/WOJZ8eqdF7IHRcqw
         BJjJzzXi/BujrMG7t1UuaB9ORB5bnToCUXOI87jwL4kp6TfcwVyp3yqKRYyq/lxkLX
         Ven4zvxnhxbJl719K/7eW+AWQ5ulsbwjf3F9U9Um+XHIS+QlfG/EunmEjaprhOgnwX
         jCahAtbTBlSZWlnmN/gQU4ajHhvMnPXTqjBFpU6O8PpUa0RIUZPOuolm29gsCqulM5
         RcdR6byJvOGNg==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B6418edab0001>; Tue, 21 Mar 2023 12:35:07 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.48; Tue, 21 Mar 2023 12:35:07 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.048; Tue, 21 Mar 2023 12:35:07 +1300
From:   Kyuwon Shim <Kyuwon.Shim@alliedtelesis.co.nz>
To:     "fw@strlen.de" <fw@strlen.de>
CC:     "pablo@netfilter.org" <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH v2] ulogd2: Avoid use after free in unregister on global
 ulogd_fds linked list
Thread-Topic: [PATCH v2] ulogd2: Avoid use after free in unregister on global
 ulogd_fds linked list
Thread-Index: AQHZUideLQbRgBEB7UC4KTxWHYeCqa78dosAgAbj/gCAABjBAIAAF66A
Date:   Mon, 20 Mar 2023 23:35:07 +0000
Message-ID: <d23bee4947bdfe49fbd98b61dd108e354db7db76.camel@alliedtelesis.co.nz>
References: <1678233154187.35009@alliedtelesis.co.nz>
         <20230309012447.201582-1-kyuwon.shim@alliedtelesis.co.nz>
         <ZBL9TEfTBqwoEZH5@strlen.de>
         <7ee33839d49fe210dfb7347ea25724e9f43046e0.camel@alliedtelesis.co.nz>
         <20230320221022.GA4659@breakpoint.cc>
In-Reply-To: <20230320221022.GA4659@breakpoint.cc>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <9EC1BA4B68C4FB49A008F9204FD5E5FA@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=F6spiZpN c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=oKJsc7D3gJEA:10 a=IkcTkHD0fZMA:10 a=k__wU0fu6RkA:10 a=8jfsoyV6mlj2mIl-efYA:9 a=QEXdDO2ut3YA:10
X-SEG-SpamProfiler-Score: 0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

VGhhbmsgeW91IEZsb3JpYW4hDQpIYXZlIGEgZ3JlYXQgZGF5IQ0KT24gTW9uLCAyMDIzLTAzLTIw
IGF0IDIzOjEwICswMTAwLCBGbG9yaWFuIFdlc3RwaGFsIHdyb3RlOg0KPiBLeXV3b24gU2hpbSA8
S3l1d29uLlNoaW1AYWxsaWVkdGVsZXNpcy5jby5uej4gd3JvdGU6DQo+ID4gSGksIEZsb3JpYW4N
Cj4gPiBUaGlzIGlzIHZhbGdyaW5kIGxvZ3MuDQo+ID4gDQo+ID4gPT00Nzk3PT0gTWVtY2hlY2ss
IGEgbWVtb3J5IGVycm9yIGRldGVjdG9yDQo+ID4gPT00Nzk3PT0gQ29weXJpZ2h0IChDKSAyMDAy
LTIwMjIsIGFuZCBHTlUgR1BMJ2QsIGJ5IEp1bGlhbiBTZXdhcmQNCj4gPiBldA0KPiA+IGFsLg0K
PiA+ID09NDc5Nz09IFVzaW5nIFZhbGdyaW5kLTMuMTkuMCBhbmQgTGliVkVYOyByZXJ1biB3aXRo
IC1oIGZvcg0KPiA+IGNvcHlyaWdodA0KPiA+IGluZm8NCj4gPiA9PTQ3OTc9PSBDb21tYW5kOiB1
bG9nZCAtdiAtYyAvZXRjL3Vsb2dkLmNvbmYNCj4gPiA9PTQ3OTc9PSBJbnZhbGlkIHJlYWQgb2Yg
c2l6ZSA0DQo+ID4gPT00Nzk3PT0gICAgYXQgMHg0MDVGNjA6IHVsb2dkX3VucmVnaXN0ZXJfZmQg
KHNlbGVjdC5jOjc0KQ0KPiA+ID09NDc5Nz09ICAgIGJ5IDB4NEU0RTNERjogPz8/IChpbg0KPiA+
IC91c3IvbGliL3Vsb2dkL3Vsb2dkX2lucHBrdF9ORkxPRy5zbykNCj4gPiA9PTQ3OTc9PSAgICBi
eSAweDQwNTAwMzogc3RvcF9wbHVnaW5zdGFuY2VzICh1bG9nZC5jOjEzMzUpDQo+ID4gPT00Nzk3
PT0gICAgYnkgMHg0MDUwMDM6IHNpZ3Rlcm1faGFuZGxlcl90YXNrICh1bG9nZC5jOjEzODMpDQo+
ID4gPT00Nzk3PT0gICAgYnkgMHg0MDUxNTM6IGNhbGxfc2lnbmFsX2hhbmRsZXJfdGFza3MgKHVs
b2dkLmM6NDI0KQ0KPiA+ID09NDc5Nz09ICAgIGJ5IDB4NDA1MTUzOiBzaWduYWxfY2hhbm5lbF9j
YWxsYmFjayAodWxvZ2QuYzo0NDMpDQo+ID4gPT00Nzk3PT0gICAgYnkgMHg0MDYxNjM6IHVsb2dk
X3NlbGVjdF9tYWluIChzZWxlY3QuYzoxMDUpDQo+ID4gPT00Nzk3PT0gICAgYnkgMHg0MDNDRjM6
IHVsb2dkX21haW5fbG9vcCAodWxvZ2QuYzoxMDcwKQ0KPiA+ID09NDc5Nz09ICAgIGJ5IDB4NDAz
Q0YzOiBtYWluICh1bG9nZC5jOjE2NDkpDQo+ID4gPT00Nzk3PT0gIEFkZHJlc3MgMHg0YTg0ZjQw
IGlzIDE2MCBieXRlcyBpbnNpZGUgYSBibG9jayBvZiBzaXplDQo+ID4gNCw4NDgNCj4gPiBmcmVl
J2QNCj4gDQo+IFl1Y2ssIHRoYW5rcyBmb3IgdGhlIGJhY2t0cmFjZS4gIEkndmUgYXBwbGllZCB0
aGUgcGF0Y2ggd2l0aCBhbg0KPiBhbWVuZGVkDQo+IGNoYW5nZWxvZyBhbmQgYSBjb21tZW50IHdy
dC4gOjpzdG9wIGRvaW5nIHN1Y2ggdGhpbmdzLg0K
