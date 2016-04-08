From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] test/shell/run-tests.sh: also unload NAT modules
Date: Fri, 08 Apr 2016 10:47:15 +0200
Message-ID: <146010523543.17551.10690033432370786467.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:40785 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753498AbcDHIrZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Apr 2016 04:47:25 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 2509251F27A
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 08:47:22 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ta1H6r6vgtpI for <netfilter-devel@vger.kernel.org>;
	Fri,  8 Apr 2016 10:47:16 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
	by smtp.cica.es (Postfix) with ESMTP id E03A951F282
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 10:47:15 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Also unload NAT modules between tests.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/shell/run-tests.sh |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 620fe57..0bbb136 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -56,6 +56,7 @@ kernel_cleanup() {
 	nft_exthdr nft_payload nft_cmp \
 	nft_meta nft_meta_bridge nft_counter nft_log nft_limit \
 	nft_hash nft_rbtree nft_ct nft_compat \
+	nft_chain_nat_ipv4 nft_chain_nat_ipv6 \
 	nf_tables_inet nf_tables_bridge nf_tables_arp \
 	nf_tables_ipv4 nf_tables_ipv6 nf_tables
 }

