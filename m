From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] examples: give credits to Pablo Neira Ayuso
Date: Wed, 10 Jul 2013 12:17:32 +0200
Message-ID: <20130710101732.29118.89099.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:59438 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751667Ab3GJKRn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 06:17:43 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 6B6AF51EDB7
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 10:17:41 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QqX62Wy5uZt8 for <netfilter-devel@vger.kernel.org>;
	Wed, 10 Jul 2013 12:17:36 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 3E72151EDBC
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 12:17:34 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo wrote the code I copy-pasted, so give credits.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/nft-chain-xml-add.c |    1 +
 examples/nft-rule-xml-add.c  |    1 +
 examples/nft-table-xml-add.c |    1 +
 3 files changed, 3 insertions(+)

diff --git a/examples/nft-chain-xml-add.c b/examples/nft-chain-xml-add.c
index 80a513d..799f901 100644
--- a/examples/nft-chain-xml-add.c
+++ b/examples/nft-chain-xml-add.c
@@ -1,4 +1,5 @@
 /*
+ * 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  * 2013 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/examples/nft-rule-xml-add.c b/examples/nft-rule-xml-add.c
index 7bd44ff..604517b 100644
--- a/examples/nft-rule-xml-add.c
+++ b/examples/nft-rule-xml-add.c
@@ -1,4 +1,5 @@
 /*
+ * 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  * 2013 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/examples/nft-table-xml-add.c b/examples/nft-table-xml-add.c
index 41df5b4..4486e68 100644
--- a/examples/nft-table-xml-add.c
+++ b/examples/nft-table-xml-add.c
@@ -1,4 +1,5 @@
 /*
+ * 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  * 2013 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify it

