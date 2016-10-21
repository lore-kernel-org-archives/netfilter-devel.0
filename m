From: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Subject: Re: [PATCH v2 nf-next 5/5] netfilter: nft: rt nexthop for inet family
Date: Fri, 21 Oct 2016 08:26:52 +0000
Message-ID: <1477038412.1053.13.camel@cohaesio.com>
References: <1476902043.1161.14.camel@cohaesio.com>
         <1476902504.1161.24.camel@cohaesio.com>
         <CAML_gOdd7=XOk+5csafW2zUjzTqzqufSp7L=3CpS8FBf6r+9nA@mail.gmail.com>
         <1476966980.1161.52.camel@cohaesio.com>
         <CAML_gOd9JSCHWQqnGN8FqdhghFHqCgDX_TiXgdpYnegROArmpQ@mail.gmail.com>
         <1476971559.1161.58.camel@cohaesio.com>
         <CAML_gOcPkygs4P95MAEDJJFRMvchKgONN-VFg45pso+Oc0B_GQ@mail.gmail.com>
         <1477023411.1161.83.camel@cohaesio.com>
         <CAML_gOfD0z7DTScvCOgMSqDZNdMB3TZ35pgRpikSFqdq_GRX5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>
To: "zlpnobody@gmail.com" <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bender.cohaesio.com ([212.97.128.130]:42078 "EHLO
        mail.cohaesio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753294AbcJUI04 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Oct 2016 04:26:56 -0400
In-Reply-To: <CAML_gOfD0z7DTScvCOgMSqDZNdMB3TZ35pgRpikSFqdq_GRX5A@mail.gmail.com>
Content-Language: en-US
Content-ID: <70AE91D29961CC4DB5BA2079024F57BA@surftown.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

SGkgTGlwaW5nLA0KDQpPbiBmcmUsIDIwMTYtMTAtMjEgYXQgMTQ6MTcgKzA4MDAsIExpcGluZyBa
aGFuZyB3cm90ZToNCj4gMjAxNi0xMC0yMSAxMjoxNiBHTVQrMDg6MDAgQW5kZXJzIEsuIFBlZGVy
c2VuIHwgQ29oYWVzaW8gPGFrcEBjb2hhZXNpDQo+IG8uY29tPjoNCg0KPiA+ID4gQnV0IGFmdGVy
IEkgdGhpbmsgaXQgY2FyZWZ1bGx5LCBJIHRoaW5rIHRoZSBORlRBX1JUX0ZBTUlMWSBhdHRyDQo+
ID4gPiBzZWVtcyB1c2VsZXNzLCB3ZSBjYW4gY29tYmluZSB0aGVzZSBmb3VyIGZpbGVzIG5mdF9y
dC5jLA0KPiA+ID4gbmZ0X3J0X2lwdjQuYywgbmZ0X3J0X2lwdjYuYyBhbmQgbmZ0X3J0X2luZXQu
YyBpbnRvIGEgc2luZ2xlIG9uZQ0KPiA+ID4gZmlsZSBuZnRfcnQuYy4NCj4gPiANCj4gPiBNeSBp
bXBsZW1lbnRhdGlvbiBpcyBiYXNlZCBvbiB0aGUgc3VnZ2VzdGlvbiBmcm9tIFBhYmxvIGF0DQo+
ID4gaHR0cDovL21hcmMuaW5mby8/bD1uZXRmaWx0ZXItZGV2ZWwmbT0xNDc0Mzg1MzE1MDI2ODYm
dz00IC4NCj4gDQo+IFllcywgYnV0IGFmdGVyIEkgY2FyZWZ1bGx5IHJlYWQgeW91ciBjb2Rlcywg
SSBmaW5kIHRoYXQgdGhlIHJlbGF0ZWQNCj4gaW1wbGVtZW50YXRpb24gY29kZSBhYm91dCB0aGUg
ZmFtaWx5IGF0dHIgaXMgbm90IHZlcnkgZ29vZC4NCj4gDQo+IFdpdGhvdXQgdGhlIGZhbWlseSBh
dHRyLCB3ZSBjYW4gc3RpbGwgbWFrZSBldmVyeXRoaW5nIHdlbGwsIGFuZA0KPiB0aGUgY29kZXMg
d2lsbCBiZWNvbWUgbW9yZSBjbGVhbiBhbmQgc3RyYWlnaHRmb3J3YXJkLg0KPiANCj4gQXMgYSBz
dW1tYXJ5Og0KPiBGb3IgaXAgZmFtaWx5LCBuZXh0aG9wIG11c3QgYmUgaXB2NA0KPiBGb3IgaXA2
IGZhbWlseSwgbmV4dGhvcCBtdXN0IGJlIGlwdjYNCj4gRm9yIGluZXQgZmFtaWx5LCBuZXh0aG9w
IGNhbiBiZSBzZWxlY3RlZCBieSBwa3QtPnBmIGFuZCB3ZSBjYW4gYWRkDQo+IGFuIGltcGxpY3Qg
cnVsZSB0aGF0IHRoZSB1c2VyIGNhbm5vdCBkbyB3cm9uZyBvcGVyYXRpb24uDQo+IA0KPiBTbyBJ
IHRoaW5rIHRoZSBORlRBX1JUX0ZBTUlMWSBhdHRyIGlzIGFsbW9zdCB1c2VsZXNzLg0KPiANCj4g
PiANCj4gPiANCj4gPiA+IA0KPiA+ID4gRm9yIGV2YWwsIHdlIGNhbiB1c2UgcGt0LT5wZiB0byBk
ZWNpZGUgd2hpY2ggcnQgb3IgcnQ2IG5leHRob3ANCj4gPiA+IHRvIGJlIGxvYWRlZCwgc28gaXAv
aXA2L2luZXQgZmFtaWx5IGhhcyB0aGUgc2FtZSBsb2dpY2FsIG5vdywNCj4gPiA+IGZvciBleGFt
cGxlOg0KPiA+IA0KPiA+IFllcywgYnV0IHBrdC0+cGYgaXMgbm90IGF2YWlsYWJsZSBpbiBpbml0
LCB3aGVyZSB3ZSBoYXZlIHRvIGFuc3dlcg0KPiA+IHdoYXQNCj4gPiB0aGUgZGF0YSBzaXplIHdp
bGwgYmUuDQo+IA0KPiBJbiBpbml0IGN0eC0+YWZpLT5mYW1pbHkgaXMgYXZhaWxhYmxlLCBhIGV4
YW1wbGUgY29kZSBpcyBpbg0KPiBuZnRfY3RfZ2V0X2luaXQoKSwNCj4geW91IGNhbiB0YWtlIGEg
bG9vayBhdCB0aGlzLg0KDQpJIGhhZCBhIGxvb2sgYXQgaXQuIFRoaXMgY29uc3RydWN0IGlzIHVz
ZWQgZm9yIE5GVF9DVF9TUkMgYW5kDQpORlRfQ1RfRFNULCB3aGVyZSB0aGUgaW5pdCBmdW5jdGlv
biBqdXN0IHJldHVybnMgdGhlIElQdjYgbGVuZ3RoIGZvcg0KdGhlIGluZXQgZmFtaWx5LiBCdXQg
SSdtIG5vdCBzdXJlIGhvdyB0aGlzIGNhbiB3b3JrIGZvciB1c2Vyc3BhY2UsIGFuZA0KYXQgbGVh
c3QgZm9yIGN1cnJlbnQgbmZ0YWJsZXMgdGhlcmUgYXJlIHByb2JsZW1zOg0KDQojIG5mdCBmbHVz
aCBydWxlc2V0DQojIG5mdCBhZGQgdGFibGUgaW5ldCBmaWx0ZXINCiMgbmZ0IGFkZCBjaGFpbiBp
bmV0IGZpbHRlciBpbnB1dA0KIyBuZnQgYWRkIHJ1bGUgaW5ldCBmaWx0ZXIgaW5wdXQgZXRoZXIg
dHlwZSBpcCBmbG93IHRhYmxlIGFjY3QgXHsgY3Qgb3JpZ2luYWwgc2FkZHIgdGltZW91dCA2MDBz
IGNvdW50ZXIgXH0NCiMgbmZ0IGxpc3QgcnVsZXNldA0KS2lsbGVkDQojIG5mdCBsaXN0IGZsb3cg
dGFibGVzDQpLaWxsZWQNCg0KVGhlIGxhdHRlciB0d28gY29tbWFuZHMgYXJlIGtpbGxlZCBieSB0
aGUgT09NIGtpbGxlciBhZnRlciBhIGZldw0Kc2Vjb25kcy4gU2FtZSB0aGluZyBoYXBwZW5zIGZv
ciAnZXRoZXIgdHlwZSBpcDYnLCB3aGlsZSBpdCB3b3JrcyBmaW5lDQp3aXRoICdpcCBzYWRkcicg
b3IgJ3J0IGlwIG5leHRob3AnIGluIHN0ZWFkIG9mICdjdCBvcmlnaW5hbCBzYWRkcicuDQoNClJl
Z2FyZHMsDQpBbmRlcnM=
