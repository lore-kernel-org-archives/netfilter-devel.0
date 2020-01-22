Return-Path: <SRS0=e21D=3L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1237CC33CB6
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jan 2020 22:05:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D087724673
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jan 2020 22:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgAVWFe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Jan 2020 17:05:34 -0500
Received: from correo.us.es ([193.147.175.20]:40488 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbgAVWFe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Jan 2020 17:05:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 500F715C10D
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jan 2020 23:05:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 42BB9DA702
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jan 2020 23:05:33 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3800ADA707; Wed, 22 Jan 2020 23:05:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3C65DDA702
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jan 2020 23:05:31 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 22 Jan 2020 23:05:31 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2000042EF9E0
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jan 2020 23:05:31 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] tests: shell: update list of rmmod modules
Date:   Wed, 22 Jan 2020 23:05:26 +0100
Message-Id: <20200122220526.260796-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200122220526.260796-1-pablo@netfilter.org>
References: <20200122220526.260796-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

* Missing nft_fib_inet.
* nft_chain_nat_ipv4 and nft_chain_nat_ipv6 became nft_chain_nat.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/run-tests.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 29a2c3988cdc..2c4154898805 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -73,10 +73,10 @@ kernel_cleanup() {
 	nft_exthdr nft_payload nft_cmp nft_range \
 	nft_quota nft_queue nft_numgen nft_osf nft_socket nft_tproxy \
 	nft_meta nft_meta_bridge nft_counter nft_log nft_limit \
-	nft_fib nft_fib_ipv4 nft_fib_ipv6 \
+	nft_fib nft_fib_ipv4 nft_fib_ipv6 nft_fib_inet \
 	nft_hash nft_ct nft_compat nft_rt nft_objref \
 	nft_set_hash nft_set_rbtree nft_set_bitmap \
-	nft_chain_nat_ipv4 nft_chain_nat_ipv6 \
+	nft_chain_nat \
 	nft_chain_route_ipv4 nft_chain_route_ipv6 \
 	nft_dup_netdev nft_fwd_netdev \
 	nft_reject nft_reject_inet \
-- 
2.11.0

