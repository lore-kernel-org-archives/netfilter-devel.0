From: Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH net-next 0/9] Use __vlan_hwaccel_*() helpers
Date: Sun, 11 Nov 2018 15:26:29 +0000
Message-ID: <28a275b4-4fd5-2c00-217a-c6ab69fb2ad9@mellanox.com>
References: <cover.1541718583.git.mirq-linux@rere.qmqm.pl>
 <20181108.204523.1353698272847299871.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="euc-kr"
Content-Transfer-Encoding: base64
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ajit.khaparde@broadcom.com" <ajit.khaparde@broadcom.com>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "bridge@lists.linux-foundation.org"
        <bridge@lists.linux-foundation.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "fw@strlen.de" <fw@strlen.de>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "kadlec@blackhole.kfki.hu" <kadlec@blackhole.kfki.hu>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "mlindner@marvell.com" <mlindner@marvell.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusn
To: David Miller <davem@davemloft.net>,
        "mirq-linux@rere.qmqm.pl" <mirq-linux@rere.qmqm.pl>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181108.204523.1353698272847299871.davem@davemloft.net>
Content-Language: en-US
Content-ID: <06FE775F916EE14E9363E640078F0015@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

DQoNCk9uIDA5LzExLzIwMTggNjo0NSBBTSwgRGF2aWQgTWlsbGVyIHdyb3RlOg0KPiBGcm9tOiBN
aWNoYampIE1pcm9zqalhdyA8bWlycS1saW51eEByZXJlLnFtcW0ucGw+DQo+IERhdGU6IEZyaSwg
MDkgTm92IDIwMTggMDA6MTc6NTggKzAxMDANCj4gDQo+PiBUaGlzIHNlcmllcyByZW1vdmVzIGZy
b20gbmV0d29ya2luZyBjb3JlIGFuZCBkcml2ZXIgY29kZSBhbiBhc3N1bXB0aW9uDQo+PiBhYm91
dCBob3cgVkxBTiB0YWcgcHJlc2VuY2UgaXMgc3RvcmVkIGluIGFuIHNrYi4gVGhpcyB3aWxsIGFs
bG93IHRvIGZyZWUNCj4+IHVwIG92ZXJsb2FkaW5nIG9mIFZMQU4uQ0ZJIGJpdCB0byBpbmNpZGF0
ZSB0YWcncyBwcmVzZW5jZS4NCj4gDQo+IFRoaXMgbG9va3MgZ29vZCwgc2VyaWVzIGFwcGxpZWQu
DQo+IA0KPiBUaGFua3MuDQo+IA0KDQpIaSBNaWNoYWwsDQoNCldlIHN0YXJ0ZWQgc2VlaW5nIHRo
ZSBjb21waWxhdGlvbiBlcnJvcnMgYmVsb3csIHRoZXkgbG9vayByZWxhdGVkIHRvIA0KdGhpcyBz
ZXJpZXMuDQoNClRoYW5rcywNClRhcmlxDQoNCjAyOjE1OjA5IG5ldC84MDIxcS92bGFuX2NvcmUu
YzogSW4gZnVuY3Rpb24gJ3ZsYW5fZG9fcmVjZWl2ZSc6DQowMjoxNTowOSBuZXQvODAyMXEvdmxh
bl9jb3JlLmM6NjA6MjogZXJyb3I6IGltcGxpY2l0IGRlY2xhcmF0aW9uIG9mIA0KZnVuY3Rpb24g
J19fdmxhbl9od2FjY2VsX2NsZWFyX3RhZyc7IGRpZCB5b3UgbWVhbiANCidfX3ZsYW5faHdhY2Nl
bF9nZXRfdGFnJz8gWy1XZXJyb3I9aW1wbGljaXQtZnVuY3Rpb24tZGVjbGFyYXRpb25dDQowMjox
NTowOSAgIF9fdmxhbl9od2FjY2VsX2NsZWFyX3RhZyhza2IpOw0KMDI6MTU6MDkgICBefn5+fn5+
fn5+fn5+fn5+fn5+fn5+fn4NCjAyOjE1OjA5ICAgX192bGFuX2h3YWNjZWxfZ2V0X3RhZw0KMDI6
MTU6MDkgY2MxOiBzb21lIHdhcm5pbmdzIGJlaW5nIHRyZWF0ZWQgYXMgZXJyb3JzDQowMjoxNTow
OSBtYWtlWzRdOiAqKiogW3NjcmlwdHMvTWFrZWZpbGUuYnVpbGQ6MjkzOiANCm5ldC84MDIxcS92
bGFuX2NvcmUub10gRXJyb3IgMQ0KMDI6MTU6MDkgbWFrZVs0XTogKioqIFdhaXRpbmcgZm9yIHVu
ZmluaXNoZWQgam9icy4uLi4NCjAyOjE1OjExIG1ha2VbM106ICoqKiBbc2NyaXB0cy9NYWtlZmls
ZS5idWlsZDo1MTg6IG5ldC84MDIxcV0gRXJyb3IgMg0KMDI6MTU6MTEgbWFrZVszXTogKioqIFdh
aXRpbmcgZm9yIHVuZmluaXNoZWQgam9icy4uLi4NCjAyOjE1OjE0IG1ha2VbMl06ICoqKiBbTWFr
ZWZpbGU6MTA2MDogbmV0XSBFcnJvciAyDQowMjoxNToxNCBtYWtlWzJdOiAqKiogV2FpdGluZyBm
b3IgdW5maW5pc2hlZCBqb2JzLi4uLg0KMDI6MTU6MzYgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4NC9lbl9yeC5jOiBJbiBmdW5jdGlvbiANCidtbHg0X2VuX3Byb2Nlc3NfcnhfY3En
Og0KMDI6MTU6MzYgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NC9lbl9yeC5jOjg3
ODo0OiBlcnJvcjogDQppbXBsaWNpdCBkZWNsYXJhdGlvbiBvZiBmdW5jdGlvbiAnX192bGFuX2h3
YWNjZWxfY2xlYXJfdGFnJzsgZGlkIHlvdSANCm1lYW4gJ19fdmxhbl9od2FjY2VsX2dldF90YWcn
PyBbLVdlcnJvcj1pbXBsaWNpdC1mdW5jdGlvbi1kZWNsYXJhdGlvbl0NCjAyOjE1OjM2ICAgICBf
X3ZsYW5faHdhY2NlbF9jbGVhcl90YWcoc2tiKTsNCjAyOjE1OjM2ICAgICBefn5+fn5+fn5+fn5+
fn5+fn5+fn5+fn4NCjAyOjE1OjM2ICAgICBfX3ZsYW5faHdhY2NlbF9nZXRfdGFnDQowMjoxNToz
NiBjYzE6IHNvbWUgd2FybmluZ3MgYmVpbmcgdHJlYXRlZCBhcyBlcnJvcnMNCjAyOjE1OjM3IG1h
a2VbN106ICoqKiBbc2NyaXB0cy9NYWtlZmlsZS5idWlsZDoyOTM6IA0KZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NC9lbl9yeC5vXSBFcnJvciAxDQowMjoxNTozNyBtYWtlWzddOiAq
KiogV2FpdGluZyBmb3IgdW5maW5pc2hlZCBqb2JzLi4uLg0KMDI6MTU6MzcgbWFrZVs2XTogKioq
IFtzY3JpcHRzL01ha2VmaWxlLmJ1aWxkOjUxODogDQpkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg0XSBFcnJvciAyDQowMjoxNTozNyBtYWtlWzZdOiAqKiogV2FpdGluZyBmb3IgdW5m
aW5pc2hlZCBqb2JzLi4uLg0KMDI6MTU6MzkgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2VuX3N0YXRzLmM6IEluIGZ1bmN0aW9uIA0KJ21seDVlX2dycF9zd191cGRhdGVf
c3RhdHMnOg0KMDI6MTU6MzkgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3Jl
L2VuX3N0YXRzLmM6MjE2OjE6IA0Kd2FybmluZzogdGhlIGZyYW1lIHNpemUgb2YgMTIwMCBieXRl
cyBpcyBsYXJnZXIgdGhhbiAxMDI0IGJ5dGVzIA0KWy1XZnJhbWUtbGFyZ2VyLXRoYW49XQ0KMDI6
MTU6MzkgIH0NCjAyOjE1OjM5ICBeDQowMjoxNTo0OSBtYWtlWzVdOiAqKiogW3NjcmlwdHMvTWFr
ZWZpbGUuYnVpbGQ6NTE4OiANCmRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94XSBFcnJvciAy
DQowMjoxNTo0OSBtYWtlWzRdOiAqKiogW3NjcmlwdHMvTWFrZWZpbGUuYnVpbGQ6NTE4OiBkcml2
ZXJzL25ldC9ldGhlcm5ldF0gDQpFcnJvciAyDQowMjoxNTo0OSBtYWtlWzNdOiAqKiogW3Njcmlw
dHMvTWFrZWZpbGUuYnVpbGQ6NTE4OiBkcml2ZXJzL25ldF0gRXJyb3IgMg0KMDI6MTU6NDkgbWFr
ZVsyXTogKioqIFtNYWtlZmlsZToxMDYwOiBkcml2ZXJzXSBFcnJvciAyDQowMjoxNTo0OSBtYWtl
WzFdOiAqKiogW3NjcmlwdHMvcGFja2FnZS9NYWtlZmlsZTo2MzogYmlucnBtLXBrZ10gRXJyb3Ig
Mg0KMDI6MTU6NDkgbWFrZTogKioqIFtNYWtlZmlsZToxMzk5OiBiaW5ycG0tcGtnXSBFcnJvciAy
DQo=
