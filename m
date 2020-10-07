Return-Path: <SRS0=fUKQ=DO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A3DEC4363D
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Oct 2020 00:11:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4098120739
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Oct 2020 00:11:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgJGALJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Oct 2020 20:11:09 -0400
Received: from correo.us.es ([193.147.175.20]:47002 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726785AbgJGAKm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Oct 2020 20:10:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6E99E1F0CF6
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Oct 2020 02:10:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 62117DA722
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Oct 2020 02:10:39 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 57C65DA730; Wed,  7 Oct 2020 02:10:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3E86FDA722;
        Wed,  7 Oct 2020 02:10:37 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 07 Oct 2020 02:10:37 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 1598D42EF42A;
        Wed,  7 Oct 2020 02:10:37 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 4/4] selftests: netfilter: add time counter check
Date:   Wed,  7 Oct 2020 02:10:27 +0200
Message-Id: <20201007001027.2530-5-pablo@netfilter.org>
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

Check packets are correctly placed in current year.
Also do a NULL check for another one.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/nft_meta.sh | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_meta.sh b/tools/testing/selftests/netfilter/nft_meta.sh
index 18a1abca3262..087f0e6e71ce 100755
--- a/tools/testing/selftests/netfilter/nft_meta.sh
+++ b/tools/testing/selftests/netfilter/nft_meta.sh
@@ -23,6 +23,8 @@ ip -net "$ns0" addr add 127.0.0.1 dev lo
 
 trap cleanup EXIT
 
+currentyear=$(date +%G)
+lastyear=$((currentyear-1))
 ip netns exec "$ns0" nft -f /dev/stdin <<EOF
 table inet filter {
 	counter iifcount {}
@@ -33,6 +35,8 @@ table inet filter {
 	counter il4protocounter {}
 	counter imarkcounter {}
 	counter icpu0counter {}
+	counter ilastyearcounter {}
+	counter icurrentyearcounter {}
 
 	counter oifcount {}
 	counter oifnamecount {}
@@ -55,6 +59,8 @@ table inet filter {
 		meta l4proto icmp counter name "il4protocounter"
 		meta mark 42 counter name "imarkcounter"
 		meta cpu 0 counter name "icpu0counter"
+		meta time "$lastyear-01-01" - "$lastyear-12-31" counter name ilastyearcounter
+		meta time "$currentyear-01-01" - "$currentyear-12-31" counter name icurrentyearcounter
 	}
 
 	chain output {
@@ -100,8 +106,7 @@ check_lo_counters()
 
 	for counter in iifcount iifnamecount iifgroupcount iiftypecount infproto4count \
 		       oifcount oifnamecount oifgroupcount oiftypecount onfproto4count \
-		       il4protocounter \
-		       ol4protocounter \
+		       il4protocounter icurrentyearcounter ol4protocounter \
 	     ; do
 		check_one_counter "$counter" "$want" "$verbose"
 	done
@@ -116,6 +121,7 @@ check_one_counter oskuidcounter "1" true
 check_one_counter oskgidcounter "1" true
 check_one_counter imarkcounter "1" true
 check_one_counter omarkcounter "1" true
+check_one_counter ilastyearcounter "0" true
 
 if [ $ret -eq 0 ];then
 	echo "OK: nftables meta iif/oif counters at expected values"
-- 
2.20.1

