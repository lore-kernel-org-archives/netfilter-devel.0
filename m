From: gapsf <gapsf@yandex.ru>
Subject: [PATCH ] nftables kernel tree: nf_tables_ipv4.c: typo in struct filter_ipv4 initialization
Date: Sat, 22 Jun 2013 20:43:50 +0700
Message-ID: <76071371908630@web29g.yandex.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----==--bound.7608.web29g.yandex.ru"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward19.mail.yandex.net ([95.108.253.144]:46210 "EHLO
	forward19.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671Ab3FVNnx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 22 Jun 2013 09:43:53 -0400
Received: from web29g.yandex.ru (web29g.yandex.ru [95.108.253.238])
	by forward19.mail.yandex.net (Yandex) with ESMTP id 021ED1120FE5
	for <netfilter-devel@vger.kernel.org>; Sat, 22 Jun 2013 17:43:50 +0400 (MSK)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


------==--bound.7608.web29g.yandex.ru
Content-Disposition: attachment;
	filename="0001-nf_tables_ipv4.c-typo-in-struct-filter_ipv4-init.patch"
Content-Transfer-Encoding: base64
Content-Type: text/x-c;
	name="0001-nf_tables_ipv4.c-typo-in-struct-filter_ipv4-init.patch"

RnJvbSA4ODk3MWNhMzZjZWM2MWYzOWU4YTI0ZTY0NjBlZjNjZGE1ZGIxNmRiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBnYXBzZiA8Z2Fwc2ZAeWFuZGV4LnJ1PgpEYXRlOiBUaHUsIDIw
IEp1biAyMDEzIDIzOjI4OjI2ICswNzAwClN1YmplY3Q6IFtQQVRDSF0gbmZfdGFibGVzX2lwdjQu
YzogdHlwbyBpbiBzdHJ1Y3QgZmlsdGVyX2lwdjQgaW5pdGlhbGl6YXRpb24KCi0tLQogbmV0L2lw
djQvbmV0ZmlsdGVyL25mX3RhYmxlc19pcHY0LmMgfCAxIC0KIDEgZmlsZSBjaGFuZ2VkLCAxIGRl
bGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvbmV0L2lwdjQvbmV0ZmlsdGVyL25mX3RhYmxlc19pcHY0
LmMgYi9uZXQvaXB2NC9uZXRmaWx0ZXIvbmZfdGFibGVzX2lwdjQuYwppbmRleCBhYjZiNDA3Li41
ZGZiMmFlIDEwMDY0NAotLS0gYS9uZXQvaXB2NC9uZXRmaWx0ZXIvbmZfdGFibGVzX2lwdjQuYwor
KysgYi9uZXQvaXB2NC9uZXRmaWx0ZXIvbmZfdGFibGVzX2lwdjQuYwpAQCAtMTAwLDcgKzEwMCw2
IEBAIHN0YXRpYyBzdHJ1Y3QgbmZfY2hhaW5fdHlwZSBmaWx0ZXJfaXB2NCA9IHsKIAkuZm4JCT0g
ewogCQlbTkZfSU5FVF9MT0NBTF9JTl0JPSBuZnRfZG9fY2hhaW5faXB2NCwKIAkJW05GX0lORVRf
TE9DQUxfT1VUXQk9IG5mdF9kb19jaGFpbl9pcHY0LAotCQlbTkZfSU5FVF9MT0NBTF9PVVRdCT0g
bmZ0X2RvX2NoYWluX2lwdjQsCiAJCVtORl9JTkVUX0ZPUldBUkRdCT0gbmZ0X2RvX2NoYWluX2lw
djQsCiAJCVtORl9JTkVUX1BSRV9ST1VUSU5HXQk9IG5mdF9kb19jaGFpbl9pcHY0LAogCQlbTkZf
SU5FVF9QT1NUX1JPVVRJTkddCT0gbmZ0X2RvX2NoYWluX2lwdjQsCi0tIAoxLjguMy5tc3lzZ2l0
LjAKCg==
------==--bound.7608.web29g.yandex.ru--
