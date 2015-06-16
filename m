From: Miroslav Kratochvil <exa.exa@gmail.com>
Subject: [PATCH nft] datatype: fix packet mark type name
Date: Tue, 16 Jun 2015 17:05:58 +0200
Message-ID: <CAO0uZ+_a-=vhw9QfUNZ0EdaDE6z+P-gBsfGLDGdTQJVeD3cpTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org, kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:32998 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbbFPPGA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 11:06:00 -0400
Received: by lblr1 with SMTP id r1so12941823lbl.0
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jun 2015 08:05:58 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Original was conflicting with "mark" keyword from scanner.l, preventing
creation of named sets with this type. Name "packetmark" corresponds
with the documentation, and the renaming can't create any regressions
as the "mark" name could not have been ever used in any setup.

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
