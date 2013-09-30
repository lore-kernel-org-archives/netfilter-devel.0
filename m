From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 2/3] table: json: fix json style
Date: Mon, 30 Sep 2013 17:05:57 +0200
Message-ID: <20130930150557.32124.88117.stgit@nfdev.cica.es>
References: <20130930150551.32124.23680.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:43578 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754982Ab3I3PGD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:06:03 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 95DE651ED64
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2013 15:06:01 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gfuLc5Pt-sfG for <netfilter-devel@vger.kernel.org>;
	Mon, 30 Sep 2013 17:06:01 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 6A8A951ED40
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2013 17:06:01 +0200 (CEST)
In-Reply-To: <20130930150551.32124.23680.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Be consistent in JSON style.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 0 files changed

diff --git a/src/table.c b/src/table.c
index c095053..93d7745 100644
--- a/src/table.c
+++ b/src/table.c
@@ -349,7 +349,7 @@ EXPORT_SYMBOL(nft_table_parse);
 static int nft_table_snprintf_json(char *buf, size_t size, struct nft_table *t)
 {
 	return snprintf(buf, size,
-			"{\"table\" : {"
+			"{ \"table\" : {"
 			"\"name\" : \"%s\","
 			"\"family\" : \"%s\","
 			"\"flags\" : %d"
diff --git a/tests/jsonfiles/01-table.json b/tests/jsonfiles/01-table.json
index b4fc91b..3f1f715 100644
--- a/tests/jsonfiles/01-table.json
+++ b/tests/jsonfiles/01-table.json
@@ -1 +1 @@
-{"table" : {"name" : "filter","family" : "ip","flags" : 0}}
+{ "table" : {"name" : "filter","family" : "ip","flags" : 0}}
diff --git a/tests/jsonfiles/02-table.json b/tests/jsonfiles/02-table.json
index 01eff74..46b83a3 100644
--- a/tests/jsonfiles/02-table.json
+++ b/tests/jsonfiles/02-table.json
@@ -1 +1 @@
-{"table" : {"name" : "filter2","family" : "ip6","flags" : 0}}
+{ "table" : {"name" : "filter2","family" : "ip6","flags" : 0}}

