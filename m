From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [TRIVIAL] Two trivial patches for 2.6
Date: Tue, 2 Sep 2003 16:19:40 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0309021616090.8566@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-23717851-41380598-1062512380=:8566"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---23717851-41380598-1062512380=:8566
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hello,

consider these patches for inclusion, they are against 2.6.0-test4,

1) remove unused destroy callback in ip6t_ipv6header.c
2) convert ip6t_LOG and ip6t_MARK to C99 initializers.

I'm sending them mime'd cause my MUA tends to spoil the inbody patches
sometimes.

Regards,
Maciej
---23717851-41380598-1062512380=:8566
Content-Type: TEXT/plain; name="ipv6header.diff"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.51.0309021619400.8566@dns.toxicfilms.tv>
Content-Description: ipv6header.diff
Content-Disposition: attachment; filename="ipv6header.diff"

ZGlmZiAtdSBsaW51eC0yLjYuMC10ZXN0Mi9uZXQvaXB2Ni9uZXRmaWx0ZXIv
aXA2dF9pcHY2aGVhZGVyLmMgbGludXgtMi42LjAtdGVzdDQvbmV0L2lwdjYv
bmV0ZmlsdGVyL2lwNnRfaXB2NmhlYWRlci5jDQotLS0gbGludXgtMi42LjAt
dGVzdDIvbmV0L2lwdjYvbmV0ZmlsdGVyL2lwNnRfaXB2NmhlYWRlci5jCTIw
MDMtMDctMjcgMTk6MTI6MDkuMDAwMDAwMDAwICswMjAwDQorKysgbGludXgt
Mi42LjAtdGVzdDQvbmV0L2lwdjYvbmV0ZmlsdGVyL2lwNnRfaXB2NmhlYWRl
ci5jCTIwMDMtMDktMDIgMDA6MTk6MDEuMjk1MTczNTQ0ICswMjAwDQpAQCAt
MTI2LDE4ICsxMjYsMTAgQEANCiAJcmV0dXJuIDE7DQogfQ0KIA0KLXN0YXRp
YyB2b2lkDQotaXB2NmhlYWRlcl9kZXN0cm95KHZvaWQgKm1hdGNoaW5mbywN
Ci0JCSAgIHVuc2lnbmVkIGludCBtYXRjaGluZm9zaXplKQ0KLXsNCi0JcmV0
dXJuOw0KLX0NCi0NCiBzdGF0aWMgc3RydWN0IGlwNnRfbWF0Y2ggaXA2dF9p
cHY2aGVhZGVyX21hdGNoID0gew0KIAkubmFtZQkJPSAiaXB2NmhlYWRlciIs
DQogCS5tYXRjaAkJPSAmaXB2NmhlYWRlcl9tYXRjaCwNCiAJLmNoZWNrZW50
cnkJPSAmaXB2NmhlYWRlcl9jaGVja2VudHJ5LA0KLQkuZGVzdHJveQk9ICZp
cHY2aGVhZGVyX2Rlc3Ryb3ksDQogCS5tZQkJPSBUSElTX01PRFVMRSwNCiB9
Ow0K

---23717851-41380598-1062512380=:8566
Content-Type: TEXT/plain; name="ip6t_c99.diff"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.51.0309021619401.8566@dns.toxicfilms.tv>
Content-Description: ip6t_c99.diff
Content-Disposition: attachment; filename="ip6t_c99.diff"

ZGlmZiAtdSBsaW51eC0yLjYuMC10ZXN0Mi9uZXQvaXB2Ni9uZXRmaWx0ZXIv
aXA2dF9MT0cuYyBsaW51eC0yLjYuMC10ZXN0NC9uZXQvaXB2Ni9uZXRmaWx0
ZXIvaXA2dF9MT0cuYw0KLS0tIGxpbnV4LTIuNi4wLXRlc3QyL25ldC9pcHY2
L25ldGZpbHRlci9pcDZ0X0xPRy5jCTIwMDMtMDctMjcgMTg6NTk6NDMuMDAw
MDAwMDAwICswMjAwDQorKysgbGludXgtMi42LjAtdGVzdDQvbmV0L2lwdjYv
bmV0ZmlsdGVyL2lwNnRfTE9HLmMJMjAwMy0wOS0wMiAwMDoxNzozNy42NTE4
ODkyNTYgKzAyMDANCkBAIC0zNTEsOSArMzUxLDEyIEBADQogCXJldHVybiAx
Ow0KIH0NCiANCi1zdGF0aWMgc3RydWN0IGlwNnRfdGFyZ2V0IGlwNnRfbG9n
X3JlZw0KLT0geyB7IE5VTEwsIE5VTEwgfSwgIkxPRyIsIGlwNnRfbG9nX3Rh
cmdldCwgaXA2dF9sb2dfY2hlY2tlbnRyeSwgTlVMTCwgDQotICAgIFRISVNf
TU9EVUxFIH07DQorc3RhdGljIHN0cnVjdCBpcDZ0X3RhcmdldCBpcDZ0X2xv
Z19yZWcgPSB7DQorCS5uYW1lCQk9ICJMT0ciLA0KKwkudGFyZ2V0CQk9ICZp
cDZ0X2xvZ190YXJnZXQsDQorCS5jaGVja2VudHJ5CT0gJmlwNnRfbG9nX2No
ZWNrZW50cnksDQorCS5tZQkJPSBUSElTX01PRFVMRSwNCit9Ow0KIA0KIHN0
YXRpYyBpbnQgX19pbml0IGluaXQodm9pZCkNCiB7DQpkaWZmIC11IGxpbnV4
LTIuNi4wLXRlc3QyL25ldC9pcHY2L25ldGZpbHRlci9pcDZ0X01BUksuYyBs
aW51eC0yLjYuMC10ZXN0NC9uZXQvaXB2Ni9uZXRmaWx0ZXIvaXA2dF9NQVJL
LmMNCi0tLSBsaW51eC0yLjYuMC10ZXN0Mi9uZXQvaXB2Ni9uZXRmaWx0ZXIv
aXA2dF9NQVJLLmMJMjAwMy0wOC0yOSAyMzoyNjozNi4wMDAwMDAwMDAgKzAy
MDANCisrKyBsaW51eC0yLjYuMC10ZXN0NC9uZXQvaXB2Ni9uZXRmaWx0ZXIv
aXA2dF9NQVJLLmMJMjAwMy0wOS0wMiAwMDoxNzoyNy41Mzg0MjY3MzYgKzAy
MDANCkBAIC00OSw4ICs0OSwxMiBAQA0KIAlyZXR1cm4gMTsNCiB9DQogDQot
c3RhdGljIHN0cnVjdCBpcDZ0X3RhcmdldCBpcDZ0X21hcmtfcmVnDQotPSB7
IHsgTlVMTCwgTlVMTCB9LCAiTUFSSyIsIHRhcmdldCwgY2hlY2tlbnRyeSwg
TlVMTCwgVEhJU19NT0RVTEUgfTsNCitzdGF0aWMgc3RydWN0IGlwNnRfdGFy
Z2V0IGlwNnRfbWFya19yZWcgPSB7DQorCS5uYW1lCQk9ICJNQVJLIiwNCisJ
LnRhcmdldAkJPSAmdGFyZ2V0LA0KKwkuY2hlY2tlbnRyeQk9ICZjaGVja2Vu
dHJ5LA0KKwkubWUJCT0gVEhJU19NT0RVTEUsDQorfTsNCiANCiBzdGF0aWMg
aW50IF9faW5pdCBpbml0KHZvaWQpDQogew0K

---23717851-41380598-1062512380=:8566--
