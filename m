From: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Subject: Re: [PATCH v2 nf-next 5/5] netfilter: nft: rt nexthop for inet family
Date: Sat, 22 Oct 2016 15:25:53 +0000
Message-ID: <1477149951.5024.38.camel@cohaesio.com>
References: <1476902043.1161.14.camel@cohaesio.com>
         <1476902504.1161.24.camel@cohaesio.com>
         <CAML_gOdd7=XOk+5csafW2zUjzTqzqufSp7L=3CpS8FBf6r+9nA@mail.gmail.com>
         <1476966980.1161.52.camel@cohaesio.com>
         <CAML_gOd9JSCHWQqnGN8FqdhghFHqCgDX_TiXgdpYnegROArmpQ@mail.gmail.com>
         <1476971559.1161.58.camel@cohaesio.com>
         <CAML_gOcPkygs4P95MAEDJJFRMvchKgONN-VFg45pso+Oc0B_GQ@mail.gmail.com>
         <1477023411.1161.83.camel@cohaesio.com>
         <CAML_gOfD0z7DTScvCOgMSqDZNdMB3TZ35pgRpikSFqdq_GRX5A@mail.gmail.com>
         <1477038412.1053.13.camel@cohaesio.com>
         <CAML_gOfoAg4-uzQAqRx926p7YWj_kk1ZFqe-NQtXA73Par01PQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>
To: "zlpnobody@gmail.com" <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bender.cohaesio.com ([212.97.128.130]:44700 "EHLO
        mail.cohaesio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937392AbcJVPZ5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 22 Oct 2016 11:25:57 -0400
In-Reply-To: <CAML_gOfoAg4-uzQAqRx926p7YWj_kk1ZFqe-NQtXA73Par01PQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <9CC364328656064CBB6892BFC2068696@surftown.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

SGkgTGlwaW5nLA0KDQpPbiBmcmUsIDIwMTYtMTAtMjEgYXQgMjA6NDIgKzA4MDAsIExpcGluZyBa
aGFuZyB3cm90ZToNCj4gSGkgQW5kZXJzLA0KPiANCj4gMjAxNi0xMC0yMSAxNjoyNiBHTVQrMDg6
MDAgQW5kZXJzIEsuIFBlZGVyc2VuIHwgQ29oYWVzaW8gPGFrcEBjb2hhZXNpDQo+IG8uY29tPjoN
Cj4gWy4uLl0NCj4gPiANCj4gPiBJIGhhZCBhIGxvb2sgYXQgaXQuIFRoaXMgY29uc3RydWN0IGlz
IHVzZWQgZm9yIE5GVF9DVF9TUkMgYW5kDQo+ID4gTkZUX0NUX0RTVCwgd2hlcmUgdGhlIGluaXQg
ZnVuY3Rpb24ganVzdCByZXR1cm5zIHRoZSBJUHY2IGxlbmd0aA0KPiA+IGZvcg0KPiA+IHRoZSBp
bmV0IGZhbWlseS4gQnV0IEknbSBub3Qgc3VyZSBob3cgdGhpcyBjYW4gd29yayBmb3IgdXNlcnNw
YWNlLA0KPiA+IGFuZA0KPiA+IGF0IGxlYXN0IGZvciBjdXJyZW50IG5mdGFibGVzIHRoZXJlIGFy
ZSBwcm9ibGVtczoNCj4gPiANCj4gPiAjIG5mdCBmbHVzaCBydWxlc2V0DQo+ID4gIyBuZnQgYWRk
IHRhYmxlIGluZXQgZmlsdGVyDQo+ID4gIyBuZnQgYWRkIGNoYWluIGluZXQgZmlsdGVyIGlucHV0
DQo+ID4gIyBuZnQgYWRkIHJ1bGUgaW5ldCBmaWx0ZXIgaW5wdXQgZXRoZXIgdHlwZSBpcCBmbG93
IHRhYmxlIGFjY3QgXHsNCj4gPiBjdCBvcmlnaW5hbCBzYWRkciB0aW1lb3V0IDYwMHMgY291bnRl
ciBcfQ0KPiA+ICMgbmZ0IGxpc3QgcnVsZXNldA0KPiA+IEtpbGxlZA0KPiA+ICMgbmZ0IGxpc3Qg
ZmxvdyB0YWJsZXMNCj4gPiBLaWxsZWQNCj4gDQo+IEkgZ3Vlc3MgdGhlcmUncyBhIGJ1ZyBpbiBu
ZnQgdXRpbGl0eSwgc2FtZSBwcm9ibGVtIGV4aXN0cyBpbiBpcC9pcDYNCj4gZmFtaWx5Lg0KDQpJ
IGxvb2tlZCBpbnRvIHdoeSB0aGlzIGhhcHBlbnMuwqANCg0KbmV0bGlua19kZWxpbmVhcml6ZV9y
dWxlKCkgbG9vcHMgdGhyb3VnaCB0aGUgZXhwcmVzc2lvbnMgYW5kDQpjYWxsc8KgbmV0bGlua19w
YXJzZV9ydWxlX2V4cHIoKSBmb3IgZWFjaCBvZiB0aGVtIChtZXRhLCBjbXAsIHBheWxvYWQsDQpj
bXAsIGN0LCBkeW5zZXQpLiBuZXRsaW5rX3BhcnNlX3J1bGVfZXhwcigpIGNhbGxzwqBuZXRsaW5r
X3BhcnNlX2V4cHIoKSwNCndoaWNoIGNhbGxzIHRoZSBzcGVjaWZpYyBleHByZXNzaW9uIHBhcnNl
cnMuDQoNClRoZSBwcm9ibGVtIGJlZ2lucyBmb3IgdGhlIGN0IGV4cHJlc3Npb24sIHdoZXJlwqBu
ZXRsaW5rX3BhcnNlX2N0KCkgYW5kDQpuZXRsaW5rX3BhcnNlX2N0X2V4cHIoKSBpcyBjYWxsZWQs
IHdoaWNoIGNhbGxzwqBjdF9leHByX2FsbG9jKCkuIFRoZQ0KbGF0dGVyIGZpbGxzIGEgbmV3IGV4
cHIgd2l0aCBkYXRhIGZyb20gY3RfdGVtcGxhdGVzW10sIHdoaWNoDQpoYXPCoCZpbnZhbGlkX3R5
cGUgd2l0aCBsZW5ndGggMCBmb3LCoE5GVF9DVF9TUkMuDQoNClRoaXMgZXhwciBpcyB0aGVuIHVz
ZWQgaW7CoG5ldGxpbmtfcGFyc2VfZHluc2V0KCksIHdoZXJlDQoNCiAgICAgICAgaWYgKGV4cHIt
PmxlbiA8IHNldC0+a2V5bGVuKSB7DQogICAgICAgICAgICAgICAgZXhwciA9IG5ldGxpbmtfcGFy
c2VfY29uY2F0X2V4cHIoY3R4LCBsb2MsIHNyZWcsIHNldC0+a2V5bGVuKTsNCg0Kd2l0aCAoZXhw
ci0+bGVuID0gMCkgPCAoc2V0LT5rZXlsZW4gPSAzMikgdHJpZXMgdG8gcGFyc2UgaXQgYXMgYQ0K
Y29uY2F0ZW5hdGVkIGV4cHJlc3Npb24gZXZlbiB0aG91Z2ggaXQncyBub3QsIGFuZCBlbmRzIHVw
IGluIGFuIGVuZGxlc3MNCmxvb3A6DQoNCiAgICAgICAgd2hpbGUgKGxlbiA+IDApIHsNCgkJLi4u
DQogICAgICAgICAgICAgICAgbGVuIC09IG5ldGxpbmtfcGFkZGVkX2xlbihleHByLT5sZW4pOw0K
ICAgICAgICAgICAgICAgIHJlZyArPSBuZXRsaW5rX3JlZ2lzdGVyX3NwYWNlKGV4cHItPmxlbik7
DQogICAgICAgIH0NCg0KVGhlcmUncyBjb2RlIGluwqBjdF9leHByX3VwZGF0ZV90eXBlKCkgdG8g
Zml4IHVwIHRoZSBkYXRhIGZyb20NCmN0X3RlbXBsYXRlc1tdIGZvcsKgTkZUX0NUX1NSQyBhbmQg
b3RoZXJzLCBidXQgdGhpcyBpcyBiYXNlZCBvbiBkYXRhDQpmcm9twqBzdHJ1Y3QgcHJvdG9fY3R4
ICpjdHggYW5kIHRob3NlIGFyZSBub3QgYXZhaWxhYmxlDQppbsKgY3RfZXhwcl9hbGxvYygpLg0K
DQpJIGRvbid0IGtub3cgaG93IHRvIHNvbHZlIHRoaXMuDQoNClJlZ2FyZHMsDQpBbmRlcnM=
