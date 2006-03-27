From: Krzysztof Oledzki <olenf@ans.pl>
Subject: [POM-NG 8/10] Fix the time extension for 2.6.16 kernels
Date: Mon, 27 Mar 2006 14:20:40 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0603271420150.17940@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1998454620-1143462040=:17940"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1998454620-1143462040=:17940
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

[POM-NG 8/10] Fix the time extension for 2.6.16 kernels

This patch allows the time extension to be used with 2.6.16 kernels

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>

diff -Nur patch-o-matic-ng-20060311-orig/patchlets/time/linux-2.6/net/ipv4/netfilter/ipt_time.c patch-o-matic-ng-20060311/patchlets/time/linux-2.6/net/ipv4/netfilter/ipt_time.c
--- patch-o-matic-ng-20060311-orig/patchlets/time/linux-2.6/net/ipv4/netfilter/ipt_time.c	2005-11-03 19:20:25.000000000 +0100
+++ patch-o-matic-ng-20060311/patchlets/time/linux-2.6/net/ipv4/netfilter/ipt_time.c	2006-03-21 23:44:09.000000000 +0100
@@ -48,6 +48,7 @@
        const struct net_device *out,
        const void *matchinfo,
        int offset,
+      unsigned int protoff,
        int *hotdrop)
  {
  	const struct ipt_time_info *info = matchinfo;   /* match info for rule */
@@ -81,7 +82,7 @@

  static int
  checkentry(const char *tablename,
-           const struct ipt_ip *ip,
+           const void *ip,
             void *matchinfo,
             unsigned int matchsize,
             unsigned int hook_mask)
---187430788-1998454620-1143462040=:17940
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=time.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0603271420400.17940@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=time.patch

W1BPTS1ORyA4LzEwXSBGaXggdGhlIHRpbWUgZXh0ZW5zaW9uIGZvciAyLjYu
MTYga2VybmVscw0KDQpUaGlzIHBhdGNoIGFsbG93cyB0aGUgdGltZSBleHRl
bnNpb24gdG8gYmUgdXNlZCB3aXRoIDIuNi4xNiBrZXJuZWxzDQoNClNpZ25l
ZC1vZmYtYnk6IEtyenlzenRvZiBQaW90ciBPbGVkemtpIDxvbGVAYW5zLnBs
Pg0KDQpkaWZmIC1OdXIgcGF0Y2gtby1tYXRpYy1uZy0yMDA2MDMxMS1vcmln
L3BhdGNobGV0cy90aW1lL2xpbnV4LTIuNi9uZXQvaXB2NC9uZXRmaWx0ZXIv
aXB0X3RpbWUuYyBwYXRjaC1vLW1hdGljLW5nLTIwMDYwMzExL3BhdGNobGV0
cy90aW1lL2xpbnV4LTIuNi9uZXQvaXB2NC9uZXRmaWx0ZXIvaXB0X3RpbWUu
Yw0KLS0tIHBhdGNoLW8tbWF0aWMtbmctMjAwNjAzMTEtb3JpZy9wYXRjaGxl
dHMvdGltZS9saW51eC0yLjYvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwdF90aW1l
LmMJMjAwNS0xMS0wMyAxOToyMDoyNS4wMDAwMDAwMDAgKzAxMDANCisrKyBw
YXRjaC1vLW1hdGljLW5nLTIwMDYwMzExL3BhdGNobGV0cy90aW1lL2xpbnV4
LTIuNi9uZXQvaXB2NC9uZXRmaWx0ZXIvaXB0X3RpbWUuYwkyMDA2LTAzLTIx
IDIzOjQ0OjA5LjAwMDAwMDAwMCArMDEwMA0KQEAgLTQ4LDYgKzQ4LDcgQEAN
CiAgICAgICBjb25zdCBzdHJ1Y3QgbmV0X2RldmljZSAqb3V0LA0KICAgICAg
IGNvbnN0IHZvaWQgKm1hdGNoaW5mbywNCiAgICAgICBpbnQgb2Zmc2V0LA0K
KyAgICAgIHVuc2lnbmVkIGludCBwcm90b2ZmLA0KICAgICAgIGludCAqaG90
ZHJvcCkNCiB7DQogCWNvbnN0IHN0cnVjdCBpcHRfdGltZV9pbmZvICppbmZv
ID0gbWF0Y2hpbmZvOyAgIC8qIG1hdGNoIGluZm8gZm9yIHJ1bGUgKi8NCkBA
IC04MSw3ICs4Miw3IEBADQogDQogc3RhdGljIGludA0KIGNoZWNrZW50cnko
Y29uc3QgY2hhciAqdGFibGVuYW1lLA0KLSAgICAgICAgICAgY29uc3Qgc3Ry
dWN0IGlwdF9pcCAqaXAsDQorICAgICAgICAgICBjb25zdCB2b2lkICppcCwN
CiAgICAgICAgICAgIHZvaWQgKm1hdGNoaW5mbywNCiAgICAgICAgICAgIHVu
c2lnbmVkIGludCBtYXRjaHNpemUsDQogICAgICAgICAgICB1bnNpZ25lZCBp
bnQgaG9va19tYXNrKQ0K

---187430788-1998454620-1143462040=:17940--
