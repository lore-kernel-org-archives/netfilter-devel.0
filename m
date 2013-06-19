From: gapsf <gapsf@yandex.ru>
Subject: [PATCH] fix filenames typo in print_usage and file header
Date: Wed, 19 Jun 2013 14:22:10 +0700
Message-ID: <1166283489.20130619142210@yandex.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="----------E3E81B439B33F24"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward20.mail.yandex.net ([95.108.253.145]:54545 "EHLO
	forward20.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933830Ab3FSH1y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Jun 2013 03:27:54 -0400
Received: from smtp19.mail.yandex.net (smtp19.mail.yandex.net [95.108.252.19])
	by forward20.mail.yandex.net (Yandex) with ESMTP id 8DED31041520
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Jun 2013 11:22:12 +0400 (MSK)
Received: from smtp19.mail.yandex.net (localhost [127.0.0.1])
	by smtp19.mail.yandex.net (Yandex) with ESMTP id 6F476BE0644
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Jun 2013 11:22:12 +0400 (MSK)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

------------E3E81B439B33F24
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: quoted-printable

From=20ccb45b16c88959737670ef79e5aba47c406b2f70 Mon Sep 17 00:00:00 2001
From: gapsf <gapsf@yandex.ru>
Date: Thu, 13 Jun 2013 22:30:34 +0700
Subject: [PATCH] fix filenames typo in print_usage and file header

---
 src/nf-table-add.c         | 2 +-
 src/nf-table-delete.c      | 2 +-
 src/nl-cls-delete.c        | 2 +-
 src/nl-link-list.c         | 2 +-
 src/nl-link-name2ifindex.c | 2 +-
 src/nl-rule-list.c         | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/nf-table-add.c b/src/nf-table-add.c
index 58ce30f..2989503 100644
--- a/src/nf-table-add.c
+++ b/src/nf-table-add.c
@@ -17,7 +17,7 @@
 static void print_usage(void)
 {
        printf(
-       "Usage: nf-ct-add <family> <name>\n"
+       "Usage: nf-table-add <family> <name>\n"
        );
        exit(1);
 }
diff --git a/src/nf-table-delete.c b/src/nf-table-delete.c
index a15e772..7a49a01 100644
--- a/src/nf-table-delete.c
+++ b/src/nf-table-delete.c
@@ -17,7 +17,7 @@
 static void print_usage(void)
 {
        printf(
-       "Usage: nf-ct-delete <family> <name>\n"
+       "Usage: nf-table-delete <family> <name>\n"
        );
        exit(1);
 }
diff --git a/src/nl-cls-delete.c b/src/nl-cls-delete.c
index cfdc170..95abd54 100644
--- a/src/nl-cls-delete.c
+++ b/src/nl-cls-delete.c
@@ -18,7 +18,7 @@ static struct nl_sock *sock;
 static void print_usage(void)
 {
        printf(
-       "Usage: nl-cls-list [OPTION]... [CLASSIFIER]\n"
+       "Usage: nl-cls-delete [OPTION]... [CLASSIFIER]\n"
        "\n"
        "Options\n"
        " -i, --interactive     Run interactively\n"
diff --git a/src/nl-link-list.c b/src/nl-link-list.c
index 5e1e3f6..2f30aad 100644
--- a/src/nl-link-list.c
+++ b/src/nl-link-list.c
@@ -1,5 +1,5 @@
 /*
- * src/nl-link-dump.c  Dump link attributes
+ * src/nl-link-list.c  Dump link attributes
  *
  *     This library is free software; you can redistribute it and/or
  *     modify it under the terms of the GNU Lesser General Public
diff --git a/src/nl-link-name2ifindex.c b/src/nl-link-name2ifindex.c
index b04af04..6be58e8 100644
--- a/src/nl-link-name2ifindex.c
+++ b/src/nl-link-name2ifindex.c
@@ -14,7 +14,7 @@
=20
 static void print_usage(void)
 {
-       printf("Usage: nl-link-ifindex2name <ifindex>\n");
+       printf("Usage: nl-link-name2ifindex <ifindex>\n");
        exit(0);
 }
=20
diff --git a/src/nl-rule-list.c b/src/nl-rule-list.c
index 8b474fa..d4f1d79 100644
--- a/src/nl-rule-list.c
+++ b/src/nl-rule-list.c
@@ -1,5 +1,5 @@
 /*
- * src/nl-rule-dump.c     Dump rule attributes
+ * src/nl-rule-list.c     Dump rule attributes
  *
  *     This library is free software; you can redistribute it and/or
  *     modify it under the terms of the GNU Lesser General Public
--=20
1.8.3.msysgit.0
 
------------E3E81B439B33F24
Content-Type: TEXT/X-C;
 name="0001-fix-filenames-typo-in-print_usage-and-file-header.patch"
Content-transfer-encoding: base64
Content-Disposition: attachment;
 filename="0001-fix-filenames-typo-in-print_usage-and-file-header.patch"

RnJvbSBjY2I0NWIxNmM4ODk1OTczNzY3MGVmNzllNWFiYTQ3YzQwNmIyZjcwIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBnYXBzZiA8Z2Fwc2ZAeWFuZGV4LnJ1PgpEYXRlOiBU
aHUsIDEzIEp1biAyMDEzIDIyOjMwOjM0ICswNzAwClN1YmplY3Q6IFtQQVRDSF0gZml4IGZp
bGVuYW1lcyB0eXBvIGluIHByaW50X3VzYWdlIGFuZCBmaWxlIGhlYWRlcgoKLS0tCiBzcmMv
bmYtdGFibGUtYWRkLmMgICAgICAgICB8IDIgKy0KIHNyYy9uZi10YWJsZS1kZWxldGUuYyAg
ICAgIHwgMiArLQogc3JjL25sLWNscy1kZWxldGUuYyAgICAgICAgfCAyICstCiBzcmMvbmwt
bGluay1saXN0LmMgICAgICAgICB8IDIgKy0KIHNyYy9ubC1saW5rLW5hbWUyaWZpbmRleC5j
IHwgMiArLQogc3JjL25sLXJ1bGUtbGlzdC5jICAgICAgICAgfCAyICstCiA2IGZpbGVzIGNo
YW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9z
cmMvbmYtdGFibGUtYWRkLmMgYi9zcmMvbmYtdGFibGUtYWRkLmMKaW5kZXggNThjZTMwZi4u
Mjk4OTUwMyAxMDA2NDQKLS0tIGEvc3JjL25mLXRhYmxlLWFkZC5jCisrKyBiL3NyYy9uZi10
YWJsZS1hZGQuYwpAQCAtMTcsNyArMTcsNyBAQAogc3RhdGljIHZvaWQgcHJpbnRfdXNhZ2Uo
dm9pZCkKIHsKIAlwcmludGYoCi0JIlVzYWdlOiBuZi1jdC1hZGQgPGZhbWlseT4gPG5hbWU+
XG4iCisJIlVzYWdlOiBuZi10YWJsZS1hZGQgPGZhbWlseT4gPG5hbWU+XG4iCiAJKTsKIAll
eGl0KDEpOwogfQpkaWZmIC0tZ2l0IGEvc3JjL25mLXRhYmxlLWRlbGV0ZS5jIGIvc3JjL25m
LXRhYmxlLWRlbGV0ZS5jCmluZGV4IGExNWU3NzIuLjdhNDlhMDEgMTAwNjQ0Ci0tLSBhL3Ny
Yy9uZi10YWJsZS1kZWxldGUuYworKysgYi9zcmMvbmYtdGFibGUtZGVsZXRlLmMKQEAgLTE3
LDcgKzE3LDcgQEAKIHN0YXRpYyB2b2lkIHByaW50X3VzYWdlKHZvaWQpCiB7CiAJcHJpbnRm
KAotCSJVc2FnZTogbmYtY3QtZGVsZXRlIDxmYW1pbHk+IDxuYW1lPlxuIgorCSJVc2FnZTog
bmYtdGFibGUtZGVsZXRlIDxmYW1pbHk+IDxuYW1lPlxuIgogCSk7CiAJZXhpdCgxKTsKIH0K
ZGlmZiAtLWdpdCBhL3NyYy9ubC1jbHMtZGVsZXRlLmMgYi9zcmMvbmwtY2xzLWRlbGV0ZS5j
CmluZGV4IGNmZGMxNzAuLjk1YWJkNTQgMTAwNjQ0Ci0tLSBhL3NyYy9ubC1jbHMtZGVsZXRl
LmMKKysrIGIvc3JjL25sLWNscy1kZWxldGUuYwpAQCAtMTgsNyArMTgsNyBAQCBzdGF0aWMg
c3RydWN0IG5sX3NvY2sgKnNvY2s7CiBzdGF0aWMgdm9pZCBwcmludF91c2FnZSh2b2lkKQog
ewogCXByaW50ZigKLQkiVXNhZ2U6IG5sLWNscy1saXN0IFtPUFRJT05dLi4uIFtDTEFTU0lG
SUVSXVxuIgorCSJVc2FnZTogbmwtY2xzLWRlbGV0ZSBbT1BUSU9OXS4uLiBbQ0xBU1NJRklF
Ul1cbiIKIAkiXG4iCiAJIk9wdGlvbnNcbiIKIAkiIC1pLCAtLWludGVyYWN0aXZlICAgICBS
dW4gaW50ZXJhY3RpdmVseVxuIgpkaWZmIC0tZ2l0IGEvc3JjL25sLWxpbmstbGlzdC5jIGIv
c3JjL25sLWxpbmstbGlzdC5jCmluZGV4IDVlMWUzZjYuLjJmMzBhYWQgMTAwNjQ0Ci0tLSBh
L3NyYy9ubC1saW5rLWxpc3QuYworKysgYi9zcmMvbmwtbGluay1saXN0LmMKQEAgLTEsNSAr
MSw1IEBACiAvKgotICogc3JjL25sLWxpbmstZHVtcC5jCUR1bXAgbGluayBhdHRyaWJ1dGVz
CisgKiBzcmMvbmwtbGluay1saXN0LmMJRHVtcCBsaW5rIGF0dHJpYnV0ZXMKICAqCiAgKglU
aGlzIGxpYnJhcnkgaXMgZnJlZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQg
YW5kL29yCiAgKgltb2RpZnkgaXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgTGVzc2Vy
IEdlbmVyYWwgUHVibGljCmRpZmYgLS1naXQgYS9zcmMvbmwtbGluay1uYW1lMmlmaW5kZXgu
YyBiL3NyYy9ubC1saW5rLW5hbWUyaWZpbmRleC5jCmluZGV4IGIwNGFmMDQuLjZiZTU4ZTgg
MTAwNjQ0Ci0tLSBhL3NyYy9ubC1saW5rLW5hbWUyaWZpbmRleC5jCisrKyBiL3NyYy9ubC1s
aW5rLW5hbWUyaWZpbmRleC5jCkBAIC0xNCw3ICsxNCw3IEBACiAKIHN0YXRpYyB2b2lkIHBy
aW50X3VzYWdlKHZvaWQpCiB7Ci0JcHJpbnRmKCJVc2FnZTogbmwtbGluay1pZmluZGV4Mm5h
bWUgPGlmaW5kZXg+XG4iKTsKKwlwcmludGYoIlVzYWdlOiBubC1saW5rLW5hbWUyaWZpbmRl
eCA8aWZpbmRleD5cbiIpOwogCWV4aXQoMCk7CiB9CiAKZGlmZiAtLWdpdCBhL3NyYy9ubC1y
dWxlLWxpc3QuYyBiL3NyYy9ubC1ydWxlLWxpc3QuYwppbmRleCA4YjQ3NGZhLi5kNGYxZDc5
IDEwMDY0NAotLS0gYS9zcmMvbmwtcnVsZS1saXN0LmMKKysrIGIvc3JjL25sLXJ1bGUtbGlz
dC5jCkBAIC0xLDUgKzEsNSBAQAogLyoKLSAqIHNyYy9ubC1ydWxlLWR1bXAuYyAgICAgRHVt
cCBydWxlIGF0dHJpYnV0ZXMKKyAqIHNyYy9ubC1ydWxlLWxpc3QuYyAgICAgRHVtcCBydWxl
IGF0dHJpYnV0ZXMKICAqCiAgKglUaGlzIGxpYnJhcnkgaXMgZnJlZSBzb2Z0d2FyZTsgeW91
IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yCiAgKgltb2RpZnkgaXQgdW5kZXIgdGhlIHRl
cm1zIG9mIHRoZSBHTlUgTGVzc2VyIEdlbmVyYWwgUHVibGljCi0tIAoxLjguMy5tc3lzZ2l0
LjAKCg==
------------E3E81B439B33F24--

