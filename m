From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] include: add stdint.h to common.h
Date: Tue, 21 Jan 2014 13:08:32 +0100
Message-ID: <20140121120832.18045.30403.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:53856 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754103AbaAUMIo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jan 2014 07:08:44 -0500
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id B3A0251ED76
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Jan 2014 12:08:41 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id frq9Xx-IVpVJ for <netfilter-devel@vger.kernel.org>;
	Tue, 21 Jan 2014 13:08:36 +0100 (CET)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 6EA6151ED67
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Jan 2014 13:08:34 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Avoid:

/usr/local/include/libnftnl/common.h:25:49: error: unknown type name =E2=
=80=98uint16_t=E2=80=99
/usr/local/include/libnftnl/common.h:25:63: error: unknown type name =E2=
=80=98uint16_t=E2=80=99
/usr/local/include/libnftnl/common.h:26:10: error: unknown type name =E2=
=80=98uint16_t=E2=80=99
/usr/local/include/libnftnl/common.h:26:25: error: unknown type name =E2=
=80=98uint32_t=E2=80=99


Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/libnftnl/common.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/libnftnl/common.h b/include/libnftnl/common.h
index 9d18b2b..f0c20f0 100644
--- a/include/libnftnl/common.h
+++ b/include/libnftnl/common.h
@@ -1,6 +1,8 @@
 #ifndef _LIBNFTNL_COMMON_H_
 #define _LIBNFTNL_COMMON_H_
=20
+#include <stdint.h>
+
 enum {
 	NFT_PARSE_EBADINPUT	=3D 0,
 	NFT_PARSE_EMISSINGNODE,

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
