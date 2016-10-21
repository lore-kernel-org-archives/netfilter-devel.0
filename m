From: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Subject: Re: [PATCH v2 nf-next 5/5] netfilter: nft: rt nexthop for inet family
Date: Fri, 21 Oct 2016 04:16:51 +0000
Message-ID: <1477023411.1161.83.camel@cohaesio.com>
References: <1476902043.1161.14.camel@cohaesio.com>
         <1476902504.1161.24.camel@cohaesio.com>
         <CAML_gOdd7=XOk+5csafW2zUjzTqzqufSp7L=3CpS8FBf6r+9nA@mail.gmail.com>
         <1476966980.1161.52.camel@cohaesio.com>
         <CAML_gOd9JSCHWQqnGN8FqdhghFHqCgDX_TiXgdpYnegROArmpQ@mail.gmail.com>
         <1476971559.1161.58.camel@cohaesio.com>
         <CAML_gOcPkygs4P95MAEDJJFRMvchKgONN-VFg45pso+Oc0B_GQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>
To: "zlpnobody@gmail.com" <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bender.cohaesio.com ([212.97.128.130]:38872 "EHLO
        mail.cohaesio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751091AbcJUEQz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Oct 2016 00:16:55 -0400
In-Reply-To: <CAML_gOcPkygs4P95MAEDJJFRMvchKgONN-VFg45pso+Oc0B_GQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <200F862DAC4E434E93B27536F3F66135@surftown.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

SGkgTGlwaW5nLA0KDQpPbiBmcmUsIDIwMTYtMTAtMjEgYXQgMTA6MDYgKzA4MDAsIExpcGluZyBa
aGFuZyB3cm90ZToNCj4gSGkgQW5kZXJzLA0KPiANCj4gMjAxNi0xMC0yMCAyMTo1MiBHTVQrMDg6
MDAgQW5kZXJzIEsuIFBlZGVyc2VuIHwgQ29oYWVzaW8gPGFrcEBjb2hhZXNpDQo+IG8uY29tPjoN
Cj4gPiBPSywgc28gd291bGQgaXQgYmUgb2theSB0byByZXBsYWNlIGl0IHdpdGgNCj4gPiANCj4g
PiBwcmludGtfb25jZShLRVJOX1dBUk5JTkcgS0JVSUxEX01PRE5BTUUgIiBBZGRyZXNzIGZhbWls
aWVzIGRvIG5vdA0KPiA+IG1hdGNoXG4iKTsNCj4gPiANCj4gPiA/DQoNCj4gVG8gdGhpcyBxdWVz
dGlvbiwgSSB0aGluayBpdCdzIGJldHRlciB0byBkbyBORlRfQlJFQUsgc2xpZW50bHksIHRoZQ0K
PiB3YXJuaW5nDQo+IG1lc3NhZ2Ugc2VlbXMgdXNlbGVzcy4gQWN0dWFsbHkgdGhpcyBjYW4gYmUg
YXZvaWRlZCBpbiB1c2Vyc3BhY2UsDQo+IGkuZS4gaW4gbmZ0Lg0KDQpXZWxsLCBhcyBtZW50aW9u
ZWQgdGhlIHN1Z2dlc3RlZCB1c2Vyc3BhY2UgaW1wbGVtZW50YXRpb24gZm9yIG5mdCBkb2VzDQph
dm9pZCBpdCBieSByZXF1aXJpbmcgJ2V0aGVyIHR5cGUnIHRvIGJlIHNwZWNpZmllZCwgd2hlbiBy
dCBuZXh0aG9wIGlzDQp1c2VkIGZyb20gdGhlIGluZXQgZmFtaWx5LCBzbyBJIGZvdW5kIGl0IHJl
YXNvbmFibGUgdG8gaXNzdWUgYSB3YXJuaW5nLA0KaWYgaXQgaGFwcGVuZWQgYW55d2F5Lg0KDQpC
dXQgb2theSwgSSBzZWUgeW91ciBwb2ludCwgYW5kIEknbGwgcmVtb3ZlIHRoZSB3YXJuaW5nLg0K
DQo+IEZvciBleGFtcGxlLCBpZiB5b3UgYWRkIHRoZSBmb2xsb3dpbmcgcnVsZSBpbiB0aGUgaW5l
dCBmYW1pbHk6DQo+IMKgICMgbmZ0IGFkZCBydWxlIGluZXQgZmlsdGVyIG91dHB1dCBpcCBkYWRk
ciAxLjEuMS4xDQo+IA0KPiBBbiBpbXBsaWN0IHJ1bGUgd2lsbCBiZSBhZGRlZCwgYW5kIHRoaXMg
Y2FuIGFsc28gYmUgYXBwbGllZCB0byBydA0KPiBleHByLA0KPiB3ZSBzaG91bGQgZmlyc3QgY29t
cGFyZSBuZnByb3RvIGlzIEFGX0lORVQgb3Igbm90Og0KPiDCoMKgwqBbIG1ldGEgbG9hZCBuZnBy
b3RvID0+IHJlZyAxIF0NCj4gwqDCoMKgWyBjbXAgZXEgcmVnIDEgMHgwMDAwMDAwMiBdDQo+IA0K
PiBCdXQgYWZ0ZXIgSSB0aGluayBpdCBjYXJlZnVsbHksIEkgdGhpbmsgdGhlIE5GVEFfUlRfRkFN
SUxZIGF0dHINCj4gc2VlbXMgdXNlbGVzcywgd2UgY2FuIGNvbWJpbmUgdGhlc2UgZm91ciBmaWxl
cyBuZnRfcnQuYywNCj4gbmZ0X3J0X2lwdjQuYywgbmZ0X3J0X2lwdjYuYyBhbmQgbmZ0X3J0X2lu
ZXQuYyBpbnRvIGEgc2luZ2xlIG9uZQ0KPiBmaWxlIG5mdF9ydC5jLg0KDQpNeSBpbXBsZW1lbnRh
dGlvbiBpcyBiYXNlZCBvbiB0aGUgc3VnZ2VzdGlvbiBmcm9tIFBhYmxvIGF0DQpodHRwOi8vbWFy
Yy5pbmZvLz9sPW5ldGZpbHRlci1kZXZlbCZtPTE0NzQzODUzMTUwMjY4NiZ3PTTCoC4NCg0KPiBG
b3IgZXZhbCwgd2UgY2FuIHVzZSBwa3QtPnBmIHRvIGRlY2lkZSB3aGljaCBydCBvciBydDYgbmV4
dGhvcA0KPiB0byBiZSBsb2FkZWQsIHNvIGlwL2lwNi9pbmV0IGZhbWlseSBoYXMgdGhlIHNhbWUg
bG9naWNhbCBub3csDQo+IGZvciBleGFtcGxlOg0KDQpZZXMsIGJ1dCBwa3QtPnBmIGlzIG5vdCBh
dmFpbGFibGUgaW4gaW5pdCwgd2hlcmUgd2UgaGF2ZSB0byBhbnN3ZXIgd2hhdA0KdGhlIGRhdGEg
c2l6ZSB3aWxsIGJlLg0KDQpSZWdhcmRzLA0KQW5kZXJz
