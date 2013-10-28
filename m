From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft tool PATCH] src: include <stdio.h>
Date: Tue, 29 Oct 2013 00:27:10 +0100
Message-ID: <20131028232710.11563.530.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:43616 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757491Ab3J1X1Z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Oct 2013 19:27:25 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 1A87A51ED81
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Oct 2013 23:27:18 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HLijr7v1uTo2 for <netfilter-devel@vger.kernel.org>;
	Tue, 29 Oct 2013 00:27:12 +0100 (CET)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id DB97851ED6E
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Oct 2013 00:27:12 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This prevents compile errors:
	[...] error: unknown type name =E2=80=98FILE=E2=80=99

when using with the libnftables patch 'src: add fprintf API functions'.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/netlink_delinearize.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 3bb143b..8318e5c 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -10,6 +10,7 @@
  */
=20
 #include <stdlib.h>
+#include <stdio.h>
 #include <stdbool.h>
 #include <string.h>
 #include <limits.h>

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
