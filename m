From: "Zheng Weibin" <zwb@xanet.edu.cn>
Subject: Re: ip_conntrack_hash() problem
Date: Fri, 11 Oct 2002 11:51:55 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <008901c270d9$bce2f5c0$26301bd2@zwb>
References: <20020905115208.4D0A02C064@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: base64
Cc: "Andi Kleen" <ak@suse.de>, "Harald Welte" <laforge@gnumonks.org>,
   "Netfilter Mailing List" <netfilter-devel@lists.netfilter.org>,
   "Linux Kernel mailing list" <linux-kernel@vger.kernel.org>,
   "Patrick Schaaf" <bof@bof.de>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Rusty Russell" <rusty@rustcorp.com.au>,
   "Martin Wilck" <Martin.Wilck@Fujitsu-Siemens.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

YW55b25lIHRlc3QgdGhlIHBhdGNoPyBJIGZpbmQgaXQgaXMgbm90IGFwcGxpY2FibGUgdW5kZXIg
Mi41LjM2LiBBbmQgDQpJIG1ha2UgZWZmb3J0cyB0byBwYXRjaCB0aGUgMi40LjE4LCBnZXQgYWx3
YXlzIE9vcHMuDQoNClpoZW5nDQoNCg0KLS0tLS0gT3JpZ2luYWwgTWVzc2FnZSAtLS0tLSANCkZy
b206ICJSdXN0eSBSdXNzZWxsIiA8cnVzdHlAcnVzdGNvcnAuY29tLmF1Pg0KVG86ICJNYXJ0aW4g
V2lsY2siIDxNYXJ0aW4uV2lsY2tARnVqaXRzdS1TaWVtZW5zLmNvbT4NCkNjOiAiQW5kaSBLbGVl
biIgPGFrQHN1c2UuZGU+OyAiSGFyYWxkIFdlbHRlIiA8bGFmb3JnZUBnbnVtb25rcy5vcmc+OyAi
TmV0ZmlsdGVyIE1haWxpbmcgTGlzdCIgPG5ldGZpbHRlci1kZXZlbEBsaXN0cy5uZXRmaWx0ZXIu
b3JnPjsgIkxpbnV4IEtlcm5lbCBtYWlsaW5nIGxpc3QiIDxsaW51eC1rZXJuZWxAdmdlci5rZXJu
ZWwub3JnPjsgIlBhdHJpY2sgU2NoYWFmIiA8Ym9mQGJvZi5kZT4NClNlbnQ6IFRodXJzZGF5LCBT
ZXB0ZW1iZXIgMDUsIDIwMDIgNzoxNSBQTQ0KU3ViamVjdDogUmU6IGlwX2Nvbm50cmFja19oYXNo
KCkgcHJvYmxlbSANCg0KDQpJbiBtZXNzYWdlIDwxMDMxMjEwMzQyLjk3ODUuMTU5LmNhbWVsQGJp
a2VyLnBkYi5mc2MubmV0PiB5b3Ugd3JpdGU6DQo+IEFtIERvbiwgMjAwMi0wOS0wNSB1bSAwMi4z
OSBzY2hyaWViIFJ1c3R5IFJ1c3NlbGw6DQo+IA0KPiA+IFRoaXMgd29yayBpcyBhbHJlYWR5IGRv
bmU6DQo+ID4gaHR0cDovL3d3dy5rZXJuZWwub3JnL3B1Yi9saW51eC9rZXJuZWwvcGVvcGxlL3J1
c3R5L3BhdGNoZXMvTmV0ZmlsdGVyL2Nvbm50DQpyYWNrX2hhc2hpbmcucGF0Y2guZ3oNCj4gDQo+
IFdlbGwsIGJlYXV0aWZ1bC4NCj4gV2lsbCB0aGlzIGdvIGludG8gdGhlIG1haW4gbGluZSBrZXJu
ZWwgYW55IHRpbWUgc29vbj8NCj4gKEknZCBiZSBmb3IgdGhhdCkuDQo+IA0KPiBJZiB0aGVyZSdz
IHN0aWxsIG5lZWQgZm9yIGRpc2N1c3Npb24gcmVnYXJkaW5nIHRoaXMgcGF0Y2gsIGFzIHRoZSB0
aHJlYWQNCj4gc3VnZ2VzdHMsIEknZCBwcm9wb3NlIHRvIGdvIGZvciBhbiBpbnRlcm1lZGlhdGUs
IGxlc3MgaW50cnVzaXZlIGZpeCBsaWtlDQo+IG1pbmUgZmlyc3QuDQoNCkknbGwgZmVlZCB0aGlz
IHRocm91Z2ggMi41LCBvbmNlIGl0J3MgaGFkIHNvbWUgbW9yZSB0ZXN0aW5nIChoaW50DQpoaW50
ISkuICBUaGVuIEhhcmFsZCB3aWxsIG1ha2UgYSBjYWxsIG9uIDIuNC4NCg0KUnVzdHkuDQotLQ0K
ICBBbnlvbmUgd2hvIHF1b3RlcyBtZSBpbiB0aGVpciBzaWcgaXMgYW4gaWRpb3QuIC0tIFJ1c3R5
IFJ1c3NlbGwuDQoNCg0KDQo=
