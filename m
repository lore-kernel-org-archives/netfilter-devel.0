Return-Path: <SRS0=d1l0=BZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73860C433E3
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Aug 2020 22:19:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50AEA20657
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Aug 2020 22:19:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbgHOWSz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:18:55 -0400
Received: from correo.us.es ([193.147.175.20]:38944 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728871AbgHOWSy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Aug 2020 18:18:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5FFC4DA890
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Aug 2020 12:32:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 51937DA84B
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Aug 2020 12:32:22 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 47000DA840; Sat, 15 Aug 2020 12:32:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2B1CDDA730;
        Sat, 15 Aug 2020 12:32:20 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 15 Aug 2020 12:32:20 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [213.143.48.187])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 40C5B42EF4E0;
        Sat, 15 Aug 2020 12:32:19 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 5/8] selftests: netfilter: add checktool function
Date:   Sat, 15 Aug 2020 12:31:58 +0200
Message-Id: <20200815103201.1768-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200815103201.1768-1-pablo@netfilter.org>
References: <20200815103201.1768-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>

avoid repeating the same test for different toolcheck

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../selftests/netfilter/nft_flowtable.sh      | 33 +++++++------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
index d3e0809ab368..68a183753c6c 100755
--- a/tools/testing/selftests/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -21,29 +21,18 @@ ns2out=""
 
 log_netns=$(sysctl -n net.netfilter.nf_log_all_netns)
 
-nft --version > /dev/null 2>&1
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not run test without nft tool"
-	exit $ksft_skip
-fi
-
-ip -Version > /dev/null 2>&1
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not run test without ip tool"
-	exit $ksft_skip
-fi
-
-which nc > /dev/null 2>&1
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not run test without nc (netcat)"
-	exit $ksft_skip
-fi
+checktool (){
+	$1 > /dev/null 2>&1
+	if [ $? -ne 0 ];then
+		echo "SKIP: Could not $2"
+		exit $ksft_skip
+	fi
+}
 
-ip netns add nsr1
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not create net namespace"
-	exit $ksft_skip
-fi
+checktool "nft --version" "run test without nft tool"
+checktool "ip -Version" "run test without ip tool"
+checktool "which nc" "run test without nc (netcat)"
+checktool "ip netns add nsr1" "create net namespace"
 
 ip netns add ns1
 ip netns add ns2
-- 
2.20.1

