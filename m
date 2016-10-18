From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] tests: shell: update kernel modules to clean
Date: Tue, 18 Oct 2016 10:49:34 +0200
Message-ID: <147678057414.13185.13617317125083465042.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:34140 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751635AbcJRIta (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Oct 2016 04:49:30 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 7080A51F2E3
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Oct 2016 08:49:27 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id BTwDJgOIjph8 for <netfilter-devel@vger.kernel.org>;
        Tue, 18 Oct 2016 10:49:22 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 6CE4E51F2CA
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Oct 2016 10:49:22 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Arturo Borrero Gonzalez <arturo@debian.org>

Let's keep the kernel_cleanup() function updated with latest
kernel changes:

 * added nft_quota, nft_queue, nft_numgen, nft_range
 * rename nft_hash to nft_set_hash
 * keep nft_hash as well
 * rename nft_rbtree to nft_set_rbtree

The idea is to run each test in a clean evironment.

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 tests/shell/run-tests.sh |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 3277655..ff24344 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -54,9 +54,11 @@ kernel_cleanup() {
 	nft_redir_ipv4 nft_redir_ipv6 nft_redir \
 	nft_dup_ipv4 nft_dup_ipv6 nft_dup nft_nat \
 	nft_masq_ipv4 nft_masq_ipv6 nft_masq \
-	nft_exthdr nft_payload nft_cmp \
+	nft_exthdr nft_payload nft_cmp nft_range \
+	nft_quota nft_queue nft_numgen \
 	nft_meta nft_meta_bridge nft_counter nft_log nft_limit \
-	nft_hash nft_rbtree nft_ct nft_compat \
+	nft_hash nft_ct nft_compat \
+	nft_set_hash nft_set_rbtree \
 	nft_chain_nat_ipv4 nft_chain_nat_ipv6 \
 	nf_tables_inet nf_tables_bridge nf_tables_arp \
 	nf_tables_ipv4 nf_tables_ipv6 nf_tables

