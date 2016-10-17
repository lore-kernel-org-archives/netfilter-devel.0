From: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Subject: Re: [PATCH nf-next 2/5] netfilter: nft: basic routing expression
Date: Mon, 17 Oct 2016 12:30:57 +0000
Message-ID: <1476707457.1038.56.camel@cohaesio.com>
References: <1476625229.1038.3.camel@cohaesio.com>
         <1476625378.1038.6.camel@cohaesio.com>
         <CAOkSjBjevzzsf9abD=uHcdzg98X3adRB4LzHef1-QMTYa_NKrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "arturo@debian.org" <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bender.cohaesio.com ([212.97.128.130]:41615 "EHLO
        mail.cohaesio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933878AbcJQMbB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2016 08:31:01 -0400
In-Reply-To: <CAOkSjBjevzzsf9abD=uHcdzg98X3adRB4LzHef1-QMTYa_NKrg@mail.gmail.com>
Content-Language: en-US
Content-ID: <1DFFA765ED7CFD4F99D52BAC15F53E56@surftown.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

SGkgQXJ0dXJvLA0KDQpPbiBtYW4sIDIwMTYtMTAtMTcgYXQgMDk6NDEgKzAyMDAsIEFydHVybyBC
b3JyZXJvIEdvbnphbGV6IHdyb3RlOg0KPiBPbiAxNiBPY3RvYmVyIDIwMTYgYXQgMTU6NDIsIEFu
ZGVycyBLLiBQZWRlcnNlbiB8IENvaGFlc2lvDQo+IDxha3BAY29oYWVzaW8uY29tPiB3cm90ZToN
Cj4gPiANCj4gPiBGcm9tOiBBbmRlcnMgSy4gUGVkZXJzZW4gPGFrcEBjb2hhZXNpby5jb20+DQo+
ID4gDQo+ID4gSW50cm9kdWNlIGJhc2ljIGluZnJhc3RydWN0dXJlIGZvciBuZnRhYmxlcyBydCBl
eHByZXNzaW9uIGZvcg0KPiA+IHJvdXRpbmcNCj4gPiByZWxhdGVkIGRhdGEuIEluaXRpYWxseSAi
cnQgY2xhc3NpZCIgaXMgaW1wbGVtZW50ZWQgaWRlbnRpY2FsIHRvDQo+ID4gIm1ldGENCj4gPiBy
dGNsYXNzaWQiLCBzaW5jZSBpdCBpcyBtb3JlIGxvZ2ljYWwgdG8gaGF2ZSB0aGlzIG1hdGNoIGlu
IHRoZQ0KPiA+IHJvdXRpbmcNCj4gPiBleHByZXNzaW9uIGdvaW5nIGZvcndhcmQuDQo+ID4gDQoN
Cj4gPiArc3RhdGljIGNvbnN0IHN0cnVjdCBuZnRfZXhwcl9vcHMgKg0KPiA+ICtuZnRfcnRfc2Vs
ZWN0X29wcyhjb25zdCBzdHJ1Y3QgbmZ0X2N0eCAqY3R4LA0KPiA+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgY29uc3Qgc3RydWN0IG5sYXR0ciAqIGNvbnN0IHRiW10pDQo+ID4g
K3sNCj4gPiArwqDCoMKgwqDCoMKgwqBpZiAodGJbTkZUQV9SVF9LRVldID09IE5VTEwpDQo+ID4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiBFUlJfUFRSKC1FSU5WQUwpOw0K
PiA+ICsNCj4gPiArwqDCoMKgwqDCoMKgwqBpZiAodGJbTkZUQV9SVF9EUkVHXSkNCj4gPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuICZuZnRfcnRfZ2V0X29wczsNCj4gPiAr
DQo+ID4gK8KgwqDCoMKgwqDCoMKgcmV0dXJuIEVSUl9QVFIoLUVJTlZBTCk7DQo+ID4gK30NCj4g
DQo+IEkgZG9uJ3QgdW5kZXJzdGFuZCB3aHkgeW91IHVzZSBzZWxlY3Rfb3BzLg0KPiANCj4gRG8g
eW91IHBsYW4gdG8gZXh0ZW5kIHRoaXMgZXhwciBiZWhhdmlvdXIgaW4gdGhlIG5lYXIgZnV0dXJl
Pw0KDQpObywgSSBoYXZlIGNoYW5nZWQgdGhpcyB0byB1c2UgIi5vcHMgPcKgJm5mdF9ydF9nZXRf
b3BzIiBmb3IgcGF0Y2ggMi01Lg0KSSBoYXZlIGFsc28gZml4ZWQgdGhlIGNvbW1lbnQgZm9ywqBl
bnVtIG5mdF9ydF9rZXlzIGluIHBhdGNoIDEgYW5kIHRoZQ0KcGF0Y2hlcyBmb3IgbGlibmZ0bmwg
YW5kIG5mdGFibGVzLg0KDQpJJ2xsIGhvbGQgb24gdG8gdGhlbSBmb3IgYSBmZXcgZGF5cyB0byBz
ZWUsIGlmIHRoZXJlIGFyZSBvdGhlcg0KY29tbWVudHMsIGFuZCB0aGVuIHBvc3QgdmVyc2lvbiAy
Lg0KDQpUaGFua3MgZm9yIHJldmlld2luZy4NCg0KUmVnYXJkcywNCkFuZGVycyBLLiBQZWRlcnNl
bg0K
