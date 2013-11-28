From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 2/2] tests: extend test-script to also tests
	parsing
Date: Thu, 28 Nov 2013 12:30:16 +0100
Message-ID: <20131128113016.11152.36686.stgit@nfdev.cica.es>
References: <20131128113010.11152.61271.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:34076 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758533Ab3K1LaS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:30:18 -0500
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 9766751ED74
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Nov 2013 11:30:17 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PRq35KhXQP8H for <netfilter-devel@vger.kernel.org>;
	Thu, 28 Nov 2013 12:30:17 +0100 (CET)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 686E051ED13
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Nov 2013 12:30:17 +0100 (CET)
In-Reply-To: <20131128113010.11152.61271.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Lets test the XML/JSON parsing with test-script.sh.

Singed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/test-script.sh |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/test-script.sh b/tests/test-script.sh
index 458f818..b766421 100755
--- a/tests/test-script.sh
+++ b/tests/test-script.sh
@@ -18,3 +18,5 @@
 ./nft-rule-test
 ./nft-set-test
 ./nft-table-test
+./nft-parsing-test xmlfiles
+./nft-parsing-test jsonfiles

