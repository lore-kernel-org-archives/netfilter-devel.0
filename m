From: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Subject: Re: [PATCH v2 nf-next 5/5] netfilter: nft: rt nexthop for inet family
Date: Sat, 22 Oct 2016 16:08:52 +0000
Message-ID: <1477152531.5024.53.camel@cohaesio.com>
References: <1476902504.1161.24.camel@cohaesio.com>
         <CAML_gOdd7=XOk+5csafW2zUjzTqzqufSp7L=3CpS8FBf6r+9nA@mail.gmail.com>
         <1476966980.1161.52.camel@cohaesio.com>
         <CAML_gOd9JSCHWQqnGN8FqdhghFHqCgDX_TiXgdpYnegROArmpQ@mail.gmail.com>
         <1476971559.1161.58.camel@cohaesio.com>
         <CAML_gOcPkygs4P95MAEDJJFRMvchKgONN-VFg45pso+Oc0B_GQ@mail.gmail.com>
         <1477023411.1161.83.camel@cohaesio.com>
         <CAML_gOfD0z7DTScvCOgMSqDZNdMB3TZ35pgRpikSFqdq_GRX5A@mail.gmail.com>
         <20161021092130.GA1987@salvia>
         <CAML_gOfecSTOHk-qSGhSwO4pFY9MW5FcBiFyZkqKZM4RAgL2NQ@mail.gmail.com>
         <20161021165830.GA1556@salvia>
         <CAML_gOdU_pChiyd08O-BPPk=r42PJ-38kTyZdngwQxboS9ToKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "zlpnobody@gmail.com" <zlpnobody@gmail.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bender.cohaesio.com ([212.97.128.130]:44083 "EHLO
        mail.cohaesio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934425AbcJVQJR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 22 Oct 2016 12:09:17 -0400
In-Reply-To: <CAML_gOdU_pChiyd08O-BPPk=r42PJ-38kTyZdngwQxboS9ToKw@mail.gmail.com>
Content-Language: en-US
Content-ID: <C70298DB5D404246A9A14C6D9DE702EB@surftown.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

SGkgTGlwaW5nIGFuZCBQYWJsbywNCg0KT24gbMO4ciwgMjAxNi0xMC0yMiBhdCAwOTo0NCArMDgw
MCwgTGlwaW5nIFpoYW5nIHdyb3RlOg0KPiBIaSBQYWJsbywNCj4gMjAxNi0xMC0yMiAwOjU4IEdN
VCswODowMCBQYWJsbyBOZWlyYSBBeXVzbyA8cGFibG9AbmV0ZmlsdGVyLm9yZz46DQo+ID4gDQo+
ID4gV2Ugc3RpbGwgbmVlZCBkYXRhdHlwZSBpbmZvcm1hdGlvbiBmb3IgdGhlIGluZXQgZmFtaWx5
LCBmcm9tIHRoZQ0KPiA+IG5ldGxpbmtfZGVsaW5lYXJpemUgc3RlcCwgd2hlbiBkdW1waW5nIGJh
Y2sgdGhlIHBvbGljeSB0bw0KPiA+IHVzZXJzcGFjZS4NCj4gPiBHaXZlbiB0aGF0IHdlIGNhbm5v
dCBpbmZlciB0aGUgZGF0YXR5cGUgZnJvbSB0aGUgZGF0YSBzaXplLCBhcyB0aGlzDQo+ID4gd291
bGQgYmUgMTYgYnl0ZXMgZm9yIGJvdGggY2FzZXMsIHdlIHdvdWxkIHN0aWxsIG5lZWQgdG8gYW5u
b3RhdGUNCj4gPiB0aGlzDQo+ID4gY29udGV4dCBpbmZvcm1hdGlvbiBzb21ld2hlcmUuIFRoZSBl
eGlzdGluZyBhcHByb2FjaCBpcyBwcm92aWRpbmcNCj4gPiB0aGlzDQo+ID4gZGF0YXR5cGUgaW5m
b3JtYXRpb24uDQo+IA0KPiBZZXMsIHRoZSBORlRBX1JUX0ZBTUlMWSBhdHRyIHdpbGwgc2ltcGxp
Znkgb3VyIHdvcmssIHdpdGhvdXQgdGhpcyB3ZQ0KPiB3aWxsIGhhdmUgbXVjaCBtb3JlIHdvcmsg
aW4gbmZ0IHV0aWxpdHkuDQo+IA0KPiBTaW5jZSBBbmRlcnMgc3VnZ2VzdHMgdGhlIGZvbGxvd2lu
ZyB1c2FnZSBpbiBJTkVUIGZhbWlseToNCj4gwqAjIG5mdCBhZGQgcnVsZSBpbmV0IGZpbHRlciBw
b3N0cm91dGluZyBldGhlciB0eXBlIGlwNiBydCBpcDYgbmV4dGhvcC4uLg0KPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBeXl5eXl5eXl5e
Xl5eDQoNCkknbSBjb25zaWRlcmluZyB0byBjaGFuZ2UgdGhlIHN5bnRheCB0byBqdXN0ICJydCBu
ZXh0aG9wIiBhbmQgdGhlbg0KZGV0ZXJtaW5lIHRoZSBmYW1pbHkgaW1wbGljaXRseSBmcm9tDQpj
dHgtPnBjdHgucHJvdG9jb2xbUFJPVE9fQkFTRV9ORVRXT1JLX0hEUl0uZGVzYyAod2hpY2ggbXVz
dCBiZSBzZXQgdmlhDQoiZXRoZXIgdHlwZSIsICJtZXRhIG5mcHJvdG8iIG9yIHNpbWlsYXIsIHdo
ZW4gdXNlZCBmcm9tIHRoZSBpbmV0DQpmYW1pbHkpIGluwqBleHByX2V2YWx1YXRlX3J0KCkgaW4g
c3RlYWQgb2YgdmVyaWZ5aW5nIGl0LiBUaGlzIGFsc28gc2VlbXMNCnRvIGJlIHdoYXQgTkZfQ1Rf
U1JDIGV0Yy4gY3VycmVudGx5IGRvZXMuDQoNCkhvdyBkb2VzIHRoaXMgc291bmQ/DQoNCj4gU28g
SSB0aGluayBpdCdzIGJldHRlciB0byBhZGQgaW1wbGljdCBkZXBlbmRlbmN5IHJ1bGVzIGluIGlu
ZXQNCj4gZmFtaWx5Og0KPiBmb3IgcnQgaXAgbmV4dGhvcDogd2UgYWRkICJtZXRhIG5mcHJvdG8g
aXB2NCINCj4gZm9yIHJ0IGlwNiBuZXh0aG9wOiB3ZSBhZGQgIm1ldGEgbmZwcm90byBpcHY2Ig0K
PiANCj4gVGhlbiBsaWtlIE5GVF9DVF9TUkMgZG8sIHdlIGNhbiBpbXBsZW1lbnQgYSBzaW1pbGFy
DQo+ICpjdF9leHByX3VwZGF0ZV90eXBlKiwgYW5kIGNhbGwgaXQgaW4gbmV0bGlua19kZWxpbmVh
cml6ZSBzdGVwLg0KDQpCdXTCoGN0X2V4cHJfdXBkYXRlX3R5cGUgaXMgb25seSB1c2VkIGR1cmlu
ZyB0aGUgbmV0bGlua19kZWxpbmVhcml6ZQ0KcG9zdHByb2Nlc3Mgc3RlcCwgYW5kIHRoYXQgY2F1
c2VzIHByb2JsZW1zLCB3aGVuIGl0IGlzIHVzZWQgaW4NCmNvbWJpbmF0aW9uIHdpdGggZmxvdyBz
dGF0ZW1lbnRzIGFzIGRlc2NyaWJlZCBpbiBvdGhlciBtYWlsLg0KDQo+IEkgYWdyZWUgdGhpcyB3
aWxsIGFkZCBtdWNoIG1vcmUgd29yayBpbiBuZnQgdXRpbGl0eSwgYW5kIGFjdHVhbGx5LA0KPiB1
c2UgdGhlIE5GVEFfUlRfRkFNSUxZIGF0dHIsIGlmIHdlIGRpZCBub3QgYWRkICJldGhlciB0eXBl
IGlwNiINCj4gb3IgIm1ldGEgbmZwcm90byBpcHY2IiwgInJ0IGlwNiBuZXh0aG9wIiBjYW4gc3Rp
bGwgd29yayB3ZWxsIGluDQo+IElORVQgZmFtaWx5Lg0KDQpXb3VsZCB5b3Ugb2JqZWN0IHRvIGRy
b3BwaW5nIChpLmUuIGtlcm5lbCB3aWxsIG5vdCByZXF1aXJlIGl0IGFuZA0KdXNlcnNwYWNlIHdp
bGwgbm90IGluY2x1ZGUgaXQpIHRoZSBORlRBX1JUX0ZBTUlMWSBhdHRyaWJ1dGUgZm9yIGlwIGFu
ZA0KaXA2IGZhbWlsaWVzLCBidXQgdW5jb25kaXRpb25hbGx5IGluY2x1ZGluZyBpdCBmb3IgdGhl
IGluZXQgZmFtaWx5Pw0KDQpSZWdhcmRzLA0KQW5kZXJz
