From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH] iptables: extensions: Fix MARK target help
Date: Mon, 27 Nov 2017 16:18:43 +0100
Message-ID: <2dc68ff2-6492-a28b-e85d-94f8e1ba0dc9@chello.at>
Reply-To: mart.frauenlob@chello.at
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------A677904647EFB2FC23534E7B"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-dmta-at01-2.mx.upcmail.net ([62.179.121.146]:43016 "EHLO
        vie01a-dmta-at01-2.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752281AbdK0PSv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Nov 2017 10:18:51 -0500
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
        by vie01a-dmta-at01.mx.upcmail.net with esmtp (Exim 4.88)
        (envelope-from <mart.frauenlob@chello.at>)
        id 1eJLBJ-0007n4-Ov
        for netfilter-devel@vger.kernel.org; Mon, 27 Nov 2017 16:18:49 +0100
Content-Language: de-AT
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------A677904647EFB2FC23534E7B
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

A typo in the help output of: iptables -j MARK -h.

--------------A677904647EFB2FC23534E7B
Content-Type: text/plain; charset=UTF-8;
 name="0001-iptables-extensions-Fix-MARK-target-help.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="0001-iptables-extensions-Fix-MARK-target-help.patch"

RnJvbSBiZjNmN2ZmZjgxZmFmNWRjMTRmY2I3ZDUxNmZjYzQ3YmQ0MDZmNDk4IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBNYXJ0IEZyYXVlbmxvYiA8bWFydC5mcmF1ZW5sb2JA
Y2hlbGxvLmF0PgpEYXRlOiBNb24sIDI3IE5vdiAyMDE3IDE1OjQ5OjU4ICswMTAwClN1Ympl
Y3Q6IFtQQVRDSF0gaXB0YWJsZXM6IGV4dGVuc2lvbnM6IEZpeCBNQVJLIHRhcmdldCBoZWxw
LgoKU2lnbmVkLW9mZi1ieTogTWFydCBGcmF1ZW5sb2IgPG1hcnQuZnJhdWVubG9iQGNoZWxs
by5hdD4KLS0tCiBleHRlbnNpb25zL2xpYnh0X01BUksuYyB8IDIgKy0KIDEgZmlsZSBjaGFu
Z2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2V4dGVu
c2lvbnMvbGlieHRfTUFSSy5jIGIvZXh0ZW5zaW9ucy9saWJ4dF9NQVJLLmMKaW5kZXggYzJm
MTVlMy4uMTJiMTY5NSAxMDA2NDQKLS0tIGEvZXh0ZW5zaW9ucy9saWJ4dF9NQVJLLmMKKysr
IGIvZXh0ZW5zaW9ucy9saWJ4dF9NQVJLLmMKQEAgLTc2LDcgKzc2LDcgQEAgc3RhdGljIHZv
aWQgbWFya190Z19oZWxwKHZvaWQpCiAiICAtLXNldC1tYXJrIHZhbHVlWy9tYXNrXSAgIENs
ZWFyIGJpdHMgaW4gbWFzayBhbmQgT1IgdmFsdWUgaW50byBuZm1hcmtcbiIKICIgIC0tYW5k
LW1hcmsgYml0cyAgICAgICAgICAgQmluYXJ5IEFORCB0aGUgbmZtYXJrIHdpdGggYml0c1xu
IgogIiAgLS1vci1tYXJrIGJpdHMgICAgICAgICAgICBCaW5hcnkgT1IgdGhlIG5mbWFyayB3
aXRoIGJpdHNcbiIKLSIgIC0teG9yLW1hc2sgYml0cyAgICAgICAgICAgQmluYXJ5IFhPUiB0
aGUgbmZtYXJrIHdpdGggYml0c1xuIgorIiAgLS14b3ItbWFyayBiaXRzICAgICAgICAgICBC
aW5hcnkgWE9SIHRoZSBuZm1hcmsgd2l0aCBiaXRzXG4iCiAiXG4iKTsKIH0KIAotLSAKMi43
LjQKCg==
--------------A677904647EFB2FC23534E7B--
