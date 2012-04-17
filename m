From: Miguel GAIO <miguel.gaio@efixo.com>
Subject: libiptc: fix retry path in TC_INIT
Date: Tue, 17 Apr 2012 10:29:23 +0200
Message-ID: <1334651363.10712.6.camel@mgo-thinkpad>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-APTXBCjrxRecp1RWe+aZ"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp22.services.sfr.fr ([93.17.128.10]:59342 "EHLO
	smtp22.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab2DQIhy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Apr 2012 04:37:54 -0400
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2202.sfr.fr (SMTP Server) with ESMTP id 07D9970000BF
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Apr 2012 10:29:24 +0200 (CEST)
Received: from [192.168.100.226] (21.67.64.86.rev.sfr.net [86.64.67.21])
	by msfrf2202.sfr.fr (SMTP Server) with ESMTP id B216870000B1
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Apr 2012 10:29:23 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-APTXBCjrxRecp1RWe+aZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi,

There is an issue on TC_INIT retry path:
In error case, TC_FREE is called and close sockfd.
The retry does not reopen then always fail.

The proposing patch reopen sockfd in retry patch.


Miguel

--=-APTXBCjrxRecp1RWe+aZ
Content-Disposition: attachment; filename="libiptc-TC_INIT-fix-retry.patch"
Content-Type: text/x-patch; name="libiptc-TC_INIT-fix-retry.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 6dbb1a9f16c70a60c06559b31eac7ab3af789fa1 Mon Sep 17 00:00:00 2001
From: Miguel GAIO <miguel.gaio@efixo.com>
Date: Tue, 17 Apr 2012 10:16:28 +0200
Subject: [PATCH 2008/2008]  libiptc: TC_INIT fix retry

---
 libiptc/libiptc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 63965e7..cd2ad9d 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -1314,6 +1314,7 @@ TC_INIT(const char *tablename)
 		return NULL;
 	}
 
+retry:
 	sockfd = socket(TC_AF, SOCK_RAW, IPPROTO_RAW);
 	if (sockfd < 0)
 		return NULL;
@@ -1324,7 +1325,6 @@ TC_INIT(const char *tablename)
 		abort();
 	}
 
-retry:
 	s = sizeof(info);
 
 	strcpy(info.name, tablename);
-- 
1.7.9.5


--=-APTXBCjrxRecp1RWe+aZ--
