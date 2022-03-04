Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33F9AC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Mar 2022 16:10:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232931AbiCDQLD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Mar 2022 11:11:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234650AbiCDQLC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Mar 2022 11:11:02 -0500
X-Greylist: delayed 312 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 04 Mar 2022 08:10:11 PST
Received: from mx1.tetrasec.net (mx1.tetrasec.net [66.245.177.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72904165C02
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Mar 2022 08:10:11 -0800 (PST)
Received: from mx1.tetrasec.net (mail.local [127.0.0.1])
        by mx1.tetrasec.net (Postfix) with ESMTP id 2F0F81DD3D7
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Mar 2022 16:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=bsod.eu; h=mime-version
        :date:content-type:from:message-id:subject:to; s=selector1; bh=j
        ltXjnPteKU0+ftdwqJGs07/G08=; b=EGAYy11bETMJQx7IgqmmFCAcaM21o3ycu
        tLIq88yJ20tiDdVulY99Ofo4odX4pxPEzQY+GrrZQ7zi21rXBmYUSHXOCmiuVa5M
        y3I77BO4BAFN2XREo4BfWk311GBs8FsnMQsR7rVmcJim06C20L+mGgtFMGP3zPga
        6iY4b180vP+Sv3B6UMP2aTIpKdNEbz+jZHC7O4df7mJxJSI1HuuX23N9Mzj10woF
        tCzPjico1Rn9A7+mwP5e+ssSfmLGNIANwUAwVtkA2Yzm8VzxPthYPKYuFtuR9NaF
        7+pXM1s902huTy0vMn5YeTnKg/6KJplnpO4KUknFHQrTX3l7j5Hpg==
Received: from yavin4.bsod.eu (unknown [172.21.190.5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: francesco@bsod.eu)
        by mx1.tetrasec.net (Postfix) with ESMTPSA id 245E21DD3CF
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Mar 2022 16:04:57 +0000 (UTC)
MIME-Version: 1.0
Date:   Fri, 04 Mar 2022 16:04:57 +0000
Content-Type: multipart/mixed;
 boundary="--=_RainLoop_673_140853688.1646409897"
X-Mailer: RainLoop/1.16.0
From:   "Francesco Colista" <francesco@bsod.eu>
Message-ID: <09e7a20bc7b49c23630bd131f499108b@bsod.eu>
Subject: nftables 1.0.2 building issues
To:     netfilter-devel@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


----=_RainLoop_673_140853688.1646409897
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello.

I'm the maintainer of nftables in Alpine Linux (www.alpinelinux.org).

With the latest release (1.0.2), has been added an "examples" dir [1].
The building phase fails because it search in the standard library nftabl=
es/libnftables.h which does not exists.

Downstream we fixed this issue in this way:  https://git.alpinelinux.org/=
aports/commit/?id=3Dd15572ba655e7c48622fa87aca1c1a29f12b883b

You can find the patch attached...even though I'm sure that there's a mor=
e elegant solution to this issue :)

Thanks for considering.

[1] https://git.netfilter.org/nftables/commit/?id=3D5b364657a35f4e4cd5d22=
0ba2a45303d729c8eca


.: Francesco Colista

----=_RainLoop_673_140853688.1646409897
Content-Type: application/octet-stream;
 name="0001-examples-fix-include-path.patch"
Content-Disposition: attachment;
 filename="0001-examples-fix-include-path.patch"
Content-Transfer-Encoding: base64

RnJvbSBjYWQ2NDY2MzhhMzVjYzYwZWQ3Mjc3YzUwNjkxNzI5NGZlMDNmMmQ0IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBGcmFuY2VzY28gQ29saXN0YSA8ZnJhbmNlc2NvLmNv
bGlzdGFAZ21haWwuY29tPgpEYXRlOiBGcmksIDQgTWFyIDIwMjIgMTY6Mzg6NDcgKzAxMDAK
U3ViamVjdDogW1BBVENIXSBleGFtcGxlczogZml4IGluY2x1ZGUgcGF0aAoKV2hlbiBidWls
ZGluZyB0aGUgZXhhbXBsZXMgZGlyIGZpbGVzLCBidWlsZCBmYWlscwogPG5mdGFibGVzL2xp
Ym5mdGFibGVzLmg+IGlzIG5vdCB5ZXQgaW4gcGxhY2UuCgpUaGlzIHBhdGNoIGFsbG93cyB0
byBwb2ludCBkaXJlY3RseSB0byB0aGUgbmZ0YWJsZXMvbGlibmZ0YWJsZXMuaCB3aXRoaW4g
dGhlIHNvdXJjZSB0cmVlCgpTaWduZWQtb2ZmLWJ5OiBGcmFuY2VzY28gQ29saXN0YSA8ZnJh
bmNlc2NvLmNvbGlzdGFAZ21haWwuY29tPgotLS0KIGV4YW1wbGVzL25mdC1idWZmZXIuYyAg
ICB8IDIgKy0KIGV4YW1wbGVzL25mdC1qc29uLWZpbGUuYyB8IDIgKy0KIDIgZmlsZXMgY2hh
bmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2V4
YW1wbGVzL25mdC1idWZmZXIuYyBiL2V4YW1wbGVzL25mdC1idWZmZXIuYwppbmRleCAxYzRi
MWUwNC4uNWJkODRiMzQgMTAwNjQ0Ci0tLSBhL2V4YW1wbGVzL25mdC1idWZmZXIuYworKysg
Yi9leGFtcGxlcy9uZnQtYnVmZmVyLmMKQEAgLTEsNiArMSw2IEBACiAvKiBnY2MgbmZ0LWJ1
ZmZlci5jIC1vIG5mdC1idWZmZXIgLWxuZnRhYmxlcyAqLwogI2luY2x1ZGUgPHN0ZGxpYi5o
PgotI2luY2x1ZGUgPG5mdGFibGVzL2xpYm5mdGFibGVzLmg+CisjaW5jbHVkZSAiLi4vaW5j
bHVkZS9uZnRhYmxlcy9saWJuZnRhYmxlcy5oIgogCiBjb25zdCBjaGFyIHJ1bGVzZXRbXSA9
CiAJImZsdXNoIHJ1bGVzZXQ7IgpkaWZmIC0tZ2l0IGEvZXhhbXBsZXMvbmZ0LWpzb24tZmls
ZS5jIGIvZXhhbXBsZXMvbmZ0LWpzb24tZmlsZS5jCmluZGV4IDBjODMyZjIyLi5lM2MzNTY4
ZSAxMDA2NDQKLS0tIGEvZXhhbXBsZXMvbmZ0LWpzb24tZmlsZS5jCisrKyBiL2V4YW1wbGVz
L25mdC1qc29uLWZpbGUuYwpAQCAtMSw2ICsxLDYgQEAKIC8qIGdjYyBuZnQtanNvbi1maWxl
LmMgLW8gbmZ0LWpzb24tZmlsZSAtbG5mdGFibGVzICovCiAjaW5jbHVkZSA8c3RkbGliLmg+
Ci0jaW5jbHVkZSA8bmZ0YWJsZXMvbGlibmZ0YWJsZXMuaD4KKyNpbmNsdWRlICIuLi9pbmNs
dWRlL25mdGFibGVzL2xpYm5mdGFibGVzLmgiCiAKIGludCBtYWluKHZvaWQpCiB7Ci0tIAoy
LjM1LjEKCg==

----=_RainLoop_673_140853688.1646409897--
