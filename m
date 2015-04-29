From: Miroslav Kratochvil <exa.exa@gmail.com>
Subject: [PATCH nft] datatype: fix packet mark type name
Date: Wed, 29 Apr 2015 11:14:56 +0200
Message-ID: <CAO0uZ+9UObxpAse5JGuXML-xV65DwqNfZ0Yui69UHY2YZvi5Lg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:32889 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031668AbbD2JO5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Apr 2015 05:14:57 -0400
Received: by lbbzk7 with SMTP id zk7so15488816lbb.0
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2015 02:14:56 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Original was conflicting with "mark" keyword from scanner.l, preventing
creation of named sets with this type.

Ref.: https://bugzilla.netfilter.org/show_bug.cgi?id=1012

---
 src/datatype.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/datatype.c b/src/datatype.c
index c93f76a..d204ed1 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -686,7 +686,7 @@ static struct error_record *mark_type_parse(const
struct expr *sym,

 const struct datatype mark_type = {
     .type        = TYPE_MARK,
-    .name        = "mark",
+    .name        = "packetmark",
     .desc        = "packet mark",
     .size        = 4 * BITS_PER_BYTE,
     .byteorder    = BYTEORDER_HOST_ENDIAN,
-- 
2.1.4
