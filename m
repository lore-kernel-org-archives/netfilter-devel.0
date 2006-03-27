From: Krzysztof Oledzki <olenf@ans.pl>
Subject: [POM-NG 2/10] Fix the ipp2p extension for 2.6.16 kernels
Date: Mon, 27 Mar 2006 14:16:18 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0603271415210.17495@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1250178567-1143461778=:17495"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, ipp2p@ipp2p.org
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

---187430788-1250178567-1143461778=:17495
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

[POM-NG 2/10] Fix the ipp2p extension for 2.6.16 kernels

This patch allows the ipp2p extension to be used with 2.6.16 kernels

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>

diff -Nur patch-o-matic-ng-20060320-orig/patchlets/ipp2p/linux-2.6/net/ipv4/netfilter/Makefile.ladd patch-o-matic-ng-20060320/patchlets/ipp2p/linux-2.6/net/ipv4/netfilter/Makefile.ladd
--- patch-o-matic-ng-20060320-orig/patchlets/ipp2p/linux-2.6/net/ipv4/netfilter/Makefile.ladd	2004-07-13 13:43:15.000000000 +0200
+++ patch-o-matic-ng-20060320/patchlets/ipp2p/linux-2.6/net/ipv4/netfilter/Makefile.ladd	2006-03-22 00:02:30.000000000 +0100
@@ -1,2 +1,2 @@
-obj-$(CONFIG_IP_NF_MATCH_LIMIT) += ipt_limit.o
+obj-$(CONFIG_IP_NF_MATCH_RECENT) += ipt_recent.o
  obj-$(CONFIG_IP_NF_MATCH_IPP2P) += ipt_ipp2p.o
diff -Nur patch-o-matic-ng-20060320/patchlets/ipp2p/linux-2.6/net/ipv4/netfilter/ipt_ipp2p.c patch-o-matic-ng-20060320-x/patchlets/ipp2p/linux-2.6/net/ipv4/netfilter/ipt_ipp2p.c
--- patch-o-matic-ng-20060320/patchlets/ipp2p/linux-2.6/net/ipv4/netfilter/ipt_ipp2p.c	2005-02-01 11:09:48.000000000 +0100
+++ patch-o-matic-ng-20060320-x/patchlets/ipp2p/linux-2.6/net/ipv4/netfilter/ipt_ipp2p.c	2006-03-22 00:04:26.000000000 +0100
@@ -520,6 +520,7 @@
        const struct net_device *out,
        const void *matchinfo,
        int offset,
+      unsigned int protoff,
        int *hotdrop)
  {
      const struct ipt_p2p_info *info = matchinfo;
@@ -598,7 +599,7 @@

  static int
  checkentry(const char *tablename,
-            const struct ipt_ip *ip,
+            const void *ip,
  	    void *matchinfo,
  	    unsigned int matchsize,
  	    unsigned int hook_mask)
---187430788-1250178567-1143461778=:17495
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=1-ipp2p.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0603271416180.17495@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=1-ipp2p.patch

W1BPTS1ORyAyLzEwXSBGaXggdGhlIGlwcDJwIGV4dGVuc2lvbiBmb3IgMi42
LjE2IGtlcm5lbHMNCg0KVGhpcyBwYXRjaCBhbGxvd3MgdGhlIGlwcDJwIGV4
dGVuc2lvbiB0byBiZSB1c2VkIHdpdGggMi42LjE2IGtlcm5lbHMNCg0KU2ln
bmVkLW9mZi1ieTogS3J6eXN6dG9mIFBpb3RyIE9sZWR6a2kgPG9sZUBhbnMu
cGw+DQoNCmRpZmYgLU51ciBwYXRjaC1vLW1hdGljLW5nLTIwMDYwMzIwLW9y
aWcvcGF0Y2hsZXRzL2lwcDJwL2xpbnV4LTIuNi9uZXQvaXB2NC9uZXRmaWx0
ZXIvTWFrZWZpbGUubGFkZCBwYXRjaC1vLW1hdGljLW5nLTIwMDYwMzIwL3Bh
dGNobGV0cy9pcHAycC9saW51eC0yLjYvbmV0L2lwdjQvbmV0ZmlsdGVyL01h
a2VmaWxlLmxhZGQNCi0tLSBwYXRjaC1vLW1hdGljLW5nLTIwMDYwMzIwLW9y
aWcvcGF0Y2hsZXRzL2lwcDJwL2xpbnV4LTIuNi9uZXQvaXB2NC9uZXRmaWx0
ZXIvTWFrZWZpbGUubGFkZAkyMDA0LTA3LTEzIDEzOjQzOjE1LjAwMDAwMDAw
MCArMDIwMA0KKysrIHBhdGNoLW8tbWF0aWMtbmctMjAwNjAzMjAvcGF0Y2hs
ZXRzL2lwcDJwL2xpbnV4LTIuNi9uZXQvaXB2NC9uZXRmaWx0ZXIvTWFrZWZp
bGUubGFkZAkyMDA2LTAzLTIyIDAwOjAyOjMwLjAwMDAwMDAwMCArMDEwMA0K
QEAgLTEsMiArMSwyIEBADQotb2JqLSQoQ09ORklHX0lQX05GX01BVENIX0xJ
TUlUKSArPSBpcHRfbGltaXQubw0KK29iai0kKENPTkZJR19JUF9ORl9NQVRD
SF9SRUNFTlQpICs9IGlwdF9yZWNlbnQubw0KIG9iai0kKENPTkZJR19JUF9O
Rl9NQVRDSF9JUFAyUCkgKz0gaXB0X2lwcDJwLm8NCmRpZmYgLU51ciBwYXRj
aC1vLW1hdGljLW5nLTIwMDYwMzIwL3BhdGNobGV0cy9pcHAycC9saW51eC0y
LjYvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwdF9pcHAycC5jIHBhdGNoLW8tbWF0
aWMtbmctMjAwNjAzMjAteC9wYXRjaGxldHMvaXBwMnAvbGludXgtMi42L25l
dC9pcHY0L25ldGZpbHRlci9pcHRfaXBwMnAuYw0KLS0tIHBhdGNoLW8tbWF0
aWMtbmctMjAwNjAzMjAvcGF0Y2hsZXRzL2lwcDJwL2xpbnV4LTIuNi9uZXQv
aXB2NC9uZXRmaWx0ZXIvaXB0X2lwcDJwLmMJMjAwNS0wMi0wMSAxMTowOTo0
OC4wMDAwMDAwMDAgKzAxMDANCisrKyBwYXRjaC1vLW1hdGljLW5nLTIwMDYw
MzIwLXgvcGF0Y2hsZXRzL2lwcDJwL2xpbnV4LTIuNi9uZXQvaXB2NC9uZXRm
aWx0ZXIvaXB0X2lwcDJwLmMJMjAwNi0wMy0yMiAwMDowNDoyNi4wMDAwMDAw
MDAgKzAxMDANCkBAIC01MjAsNiArNTIwLDcgQEANCiAgICAgICBjb25zdCBz
dHJ1Y3QgbmV0X2RldmljZSAqb3V0LA0KICAgICAgIGNvbnN0IHZvaWQgKm1h
dGNoaW5mbywNCiAgICAgICBpbnQgb2Zmc2V0LA0KKyAgICAgIHVuc2lnbmVk
IGludCBwcm90b2ZmLA0KICAgICAgIGludCAqaG90ZHJvcCkNCiB7DQogICAg
IGNvbnN0IHN0cnVjdCBpcHRfcDJwX2luZm8gKmluZm8gPSBtYXRjaGluZm87
DQpAQCAtNTk4LDcgKzU5OSw3IEBADQogDQogc3RhdGljIGludA0KIGNoZWNr
ZW50cnkoY29uc3QgY2hhciAqdGFibGVuYW1lLA0KLSAgICAgICAgICAgIGNv
bnN0IHN0cnVjdCBpcHRfaXAgKmlwLA0KKyAgICAgICAgICAgIGNvbnN0IHZv
aWQgKmlwLA0KIAkgICAgdm9pZCAqbWF0Y2hpbmZvLA0KIAkgICAgdW5zaWdu
ZWQgaW50IG1hdGNoc2l6ZSwNCiAJICAgIHVuc2lnbmVkIGludCBob29rX21h
c2spDQo=

---187430788-1250178567-1143461778=:17495--
