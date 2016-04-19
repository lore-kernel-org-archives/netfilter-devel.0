From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH] expr: ct: fix typo unknow vs unknown
Date: Tue, 19 Apr 2016 14:54:46 +0200
Message-ID: <146107048656.24580.723189658185274524.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:52202 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753420AbcDSMy4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Apr 2016 08:54:56 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 83EF851F1FF
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Apr 2016 12:54:53 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4wTczesxoE0B for <netfilter-devel@vger.kernel.org>;
	Tue, 19 Apr 2016 14:54:48 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
	by smtp.cica.es (Postfix) with ESMTP id 2CE6251F243
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Apr 2016 14:54:47 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Reported by Debian's lintian tool.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/ct.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/expr/ct.c b/src/expr/ct.c
index 4bee6b1..a38f40c 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -199,7 +199,7 @@ static const char *ctdir2str(uint8_t ctdir)
 	case IP_CT_DIR_REPLY:
 		return "reply";
 	default:
-		return "unknow";
+		return "unknown";
 	}
 }
 

