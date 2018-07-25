From: "Li,Rongqing" <lirongqing@baidu.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdW3YyXSBuZXRmaWx0ZXI6IHVzZSBrdnphbGxvYyB0?=
 =?utf-8?Q?o_allocate_memory_for_hashtable?=
Date: Wed, 25 Jul 2018 05:49:05 +0000
Message-ID: <2AD939572F25A448A3AE3CAEA61328C2378CDFAA@BC-MAIL-M28.internal.baidu.com>
References: <1532496894-17200-1-git-send-email-lirongqing@baidu.com>
 <c86c7a1d-863d-229c-0383-c2e50aa6c5a2@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
To: Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "kadlec@blackhole.kfki.hu" <kadlec@blackhole.kfki.hu>,
        "fw@strlen.de" <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "edumazet@google.com" <edumazet@google.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <c86c7a1d-863d-229c-0383-c2e50aa6c5a2@gmail.com>
Content-Language: zh-CN
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IEVyaWMgRHVtYXpldCBb
bWFpbHRvOmVyaWMuZHVtYXpldEBnbWFpbC5jb21dDQo+IOWPkemAgeaXtumXtDogMjAxOOW5tDfm
nIgyNeaXpSAxMzo0NQ0KPiDmlLbku7bkuro6IExpLFJvbmdxaW5nIDxsaXJvbmdxaW5nQGJhaWR1
LmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+IHBhYmxvQG5ldGZpbHRlci5vcmc7IGth
ZGxlY0BibGFja2hvbGUua2ZraS5odTsgZndAc3RybGVuLmRlOyBuZXRmaWx0ZXItDQo+IGRldmVs
QHZnZXIua2VybmVsLm9yZzsgY29yZXRlYW1AbmV0ZmlsdGVyLm9yZzsgZWR1bWF6ZXRAZ29vZ2xl
LmNvbQ0KPiDkuLvpopg6IFJlOiBbUEFUQ0hdW3YyXSBuZXRmaWx0ZXI6IHVzZSBrdnphbGxvYyB0
byBhbGxvY2F0ZSBtZW1vcnkgZm9yDQo+IGhhc2h0YWJsZQ0KPiANCj4gDQo+IA0KPiBPbiAwNy8y
NC8yMDE4IDEwOjM0IFBNLCBMaSBSb25nUWluZyB3cm90ZToNCj4gPiBuZl9jdF9hbGxvY19oYXNo
dGFibGUgaXMgdXNlZCB0byBhbGxvY2F0ZSBtZW1vcnkgZm9yIGNvbm50cmFjaywgTkFUDQo+ID4g
YnlzcmMgYW5kIGV4cGVjdGF0aW9uIGhhc2h0YWJsZS4gQXNzdW1pbmcgNjRrIGJ1Y2tldCBzaXpl
LCB3aGljaCBtZWFucw0KPiA+IDd0aCBvcmRlciBwYWdlIGFsbG9jYXRpb24sIF9fZ2V0X2ZyZWVf
cGFnZXMsIGNhbGxlZCBieQ0KPiA+IG5mX2N0X2FsbG9jX2hhc2h0YWJsZSwgd2lsbCB0cmlnZ2Vy
IHRoZSBkaXJlY3QgbWVtb3J5IHJlY2xhaW0gYW5kDQo+ID4gc3RhbGwgZm9yIGEgbG9uZyB0aW1l
LCB3aGVuIHN5c3RlbSBoYXMgbG90cyBvZiBtZW1vcnkgc3RyZXNzDQo+IA0KPiAuLi4NCj4gDQo+
ID4gIAlzeiA9IG5yX3Nsb3RzICogc2l6ZW9mKHN0cnVjdCBobGlzdF9udWxsc19oZWFkKTsNCj4g
PiAtCWhhc2ggPSAodm9pZCAqKV9fZ2V0X2ZyZWVfcGFnZXMoR0ZQX0tFUk5FTCB8IF9fR0ZQX05P
V0FSTiB8DQo+IF9fR0ZQX1pFUk8sDQo+ID4gLQkJCQkJZ2V0X29yZGVyKHN6KSk7DQo+ID4gLQlp
ZiAoIWhhc2gpDQo+ID4gLQkJaGFzaCA9IHZ6YWxsb2Moc3opOw0KPiA+ICsJaGFzaCA9IGt2emFs
bG9jKHN6LCBHRlBfS0VSTkVMKTsNCj4gDQo+IA0KPiBZb3UgY291bGQgcmVtb3ZlIHRoZSBAc3og
Y29tcHV0YXRpb24gYW5kIGNhbGwNCj4gDQo+IGhhc2ggPSBrdmNhbGxvYyhucl9zbG90cywgc2l6
ZW9mKHN0cnVjdCBobGlzdF9udWxsc19oZWFkKSwgR0ZQX0tFUk5FTCk7DQo+IA0KPiBUaGFua3Mg
dG8ga3ZtYWxsb2NfYXJyYXkoKSBjaGVjaywgeW91IGFsc28gY291bGQgcmVtb3ZlIHRoZSA6DQo+
IA0KPiBpZiAobnJfc2xvdHMgPiAoVUlOVF9NQVggLyBzaXplb2Yoc3RydWN0IGhsaXN0X251bGxz
X2hlYWQpKSkNCj4gICAgIHJldHVybiBOVUxMOw0KPiANCj4gVGhhdCB3b3VsZCByZW1vdmUgYSBs
b3Qgb2Ygc3R1ZmYgbm93IHdlIGhhdmUgcHJvcGVyIGhlbHBlcnMuDQoNCg0KT2ssIEkgd2lsbCBz
ZW5kIHYzDQoNClRoYW5rcw0KDQotUm9uZ1FpbmcNCg==
