Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 467A4E80A92
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 06:17:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjI0GRT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 02:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjI0GRR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 02:17:17 -0400
X-Greylist: delayed 145 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 26 Sep 2023 23:17:16 PDT
Received: from jari.cn (unknown [218.92.28.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5EF4397
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Sep 2023 23:17:16 -0700 (PDT)
Received: from chenguohua$jari.cn ( [182.148.12.64] ) by
 ajax-webmail-localhost.localdomain (Coremail) ; Wed, 27 Sep 2023 14:13:33
 +0800 (GMT+08:00)
X-Originating-IP: [182.148.12.64]
Date:   Wed, 27 Sep 2023 14:13:33 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   chenguohua@jari.cn
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] netfilter: Clean up errors in nf_conntrack_h323_asn1.h
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.1-cmXT6 build
 20230419(ff23bf83) Copyright (c) 2002-2023 www.mailtech.cn
 mispb-4e503810-ca60-4ec8-a188-7102c18937cf-zhkzyfz.cn
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <33d535ba.863.18ad54575ed.Coremail.chenguohua@jari.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: AQAAfwBn+D0NyBNlwuW9AA--.623W
X-CM-SenderInfo: xfkh0w5xrk3tw6md2xgofq/1tbiAQAFEWFEYxtJMwAQsi
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Rml4IHRoZSBmb2xsb3dpbmcgZXJyb3JzIHJlcG9ydGVkIGJ5IGNoZWNrcGF0Y2g6CgpFUlJPUjog
ImZvbyAqIGJhciIgc2hvdWxkIGJlICJmb28gKmJhciIKClNpZ25lZC1vZmYtYnk6IEd1b0h1YSBD
aGVuZyA8Y2hlbmd1b2h1YUBqYXJpLmNuPgotLS0KIGluY2x1ZGUvbGludXgvbmV0ZmlsdGVyL25m
X2Nvbm50cmFja19oMzIzX2FzbjEuaCB8IDQgKystLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0
aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L25ldGZp
bHRlci9uZl9jb25udHJhY2tfaDMyM19hc24xLmggYi9pbmNsdWRlL2xpbnV4L25ldGZpbHRlci9u
Zl9jb25udHJhY2tfaDMyM19hc24xLmgKaW5kZXggYmQ2Nzk3ZjgyM2IyLi41MTRkYTNlOGM4YTgg
MTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19oMzIzX2Fz
bjEuaAorKysgYi9pbmNsdWRlL2xpbnV4L25ldGZpbHRlci9uZl9jb25udHJhY2tfaDMyM19hc24x
LmgKQEAgLTg4LDggKzg4LDggQEAgdHlwZWRlZiBzdHJ1Y3QgewogICogRGVjb2RlIEZ1bmN0aW9u
cwogICoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKiovCiAKLWludCBEZWNvZGVSYXNNZXNzYWdlKHVuc2lnbmVk
IGNoYXIgKmJ1Ziwgc2l6ZV90IHN6LCBSYXNNZXNzYWdlICogcmFzKTsKLWludCBEZWNvZGVROTMx
KHVuc2lnbmVkIGNoYXIgKmJ1Ziwgc2l6ZV90IHN6LCBROTMxICogcTkzMSk7CitpbnQgRGVjb2Rl
UmFzTWVzc2FnZSh1bnNpZ25lZCBjaGFyICpidWYsIHNpemVfdCBzeiwgUmFzTWVzc2FnZSAqcmFz
KTsKK2ludCBEZWNvZGVROTMxKHVuc2lnbmVkIGNoYXIgKmJ1Ziwgc2l6ZV90IHN6LCBROTMxICpx
OTMxKTsKIGludCBEZWNvZGVNdWx0aW1lZGlhU3lzdGVtQ29udHJvbE1lc3NhZ2UodW5zaWduZWQg
Y2hhciAqYnVmLCBzaXplX3Qgc3osCiAJCQkJCSBNdWx0aW1lZGlhU3lzdGVtQ29udHJvbE1lc3Nh
Z2UgKgogCQkJCQkgbXNjbSk7Ci0tIAoyLjE3LjEK
