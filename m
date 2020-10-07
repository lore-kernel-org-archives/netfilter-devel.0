Return-Path: <SRS0=fUKQ=DO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18B4FC4741F
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Oct 2020 00:10:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E73F620739
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Oct 2020 00:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgJGAKn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Oct 2020 20:10:43 -0400
Received: from correo.us.es ([193.147.175.20]:46982 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726884AbgJGAKj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Oct 2020 20:10:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 71B6A1F0CF2
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Oct 2020 02:10:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 63EFBDA78C
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Oct 2020 02:10:37 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 58BE2DA73F; Wed,  7 Oct 2020 02:10:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 726F1DA72F;
        Wed,  7 Oct 2020 02:10:34 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 07 Oct 2020 02:10:34 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 47D8242EF42A;
        Wed,  7 Oct 2020 02:10:34 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 1/4] selftests: netfilter: add cpu counter check
Date:   Wed,  7 Oct 2020 02:10:24 +0200
Message-Id: <20201007001027.2530-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201007001027.2530-1-pablo@netfilter.org>
References: <20201007001027.2530-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>

run task on first CPU with netfilter counters reset and check
cpu meta after another ping

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/nft_meta.sh | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/netfilter/nft_meta.sh b/tools/testing/selftests/netfilter/nft_meta.sh
index d250b84dd5bc..17b2d6eaa204 100755
--- a/tools/testing/selftests/netfilter/nft_meta.sh
+++ b/tools/testing/selftests/netfilter/nft_meta.sh
@@ -33,6 +33,7 @@ table inet filter {
 	counter infproto4count {}
 	counter il4protocounter {}
 	counter imarkcounter {}
+	counter icpu0counter {}
 
 	counter oifcount {}
 	counter oifnamecount {}
@@ -54,6 +55,7 @@ table inet filter {
 		meta nfproto ipv4 counter name "infproto4count"
 		meta l4proto icmp counter name "il4protocounter"
 		meta mark 42 counter name "imarkcounter"
+		meta cpu 0 counter name "icpu0counter"
 	}
 
 	chain output {
@@ -119,6 +121,18 @@ check_one_counter omarkcounter "1" true
 
 if [ $ret -eq 0 ];then
 	echo "OK: nftables meta iif/oif counters at expected values"
+else
+	exit $ret
+fi
+
+#First CPU execution and counter
+taskset -p 01 $$ > /dev/null
+ip netns exec "$ns0" nft reset counters > /dev/null
+ip netns exec "$ns0" ping -q -c 1 127.0.0.1 > /dev/null
+check_one_counter icpu0counter "2" true
+
+if [ $ret -eq 0 ];then
+	echo "OK: nftables meta cpu counter at expected values"
 fi
 
 exit $ret
-- 
2.20.1

