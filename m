Return-Path: <SRS0=d1l0=BZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFD98C433E4
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Aug 2020 22:19:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E1AF20657
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Aug 2020 22:19:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbgHOWS7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:18:59 -0400
Received: from correo.us.es ([193.147.175.20]:38950 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728979AbgHOWS4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Aug 2020 18:18:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 77A09DA8B8
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Aug 2020 12:32:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6C56ADA84A
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Aug 2020 12:32:25 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 61F28DA73F; Sat, 15 Aug 2020 12:32:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 52254DA730;
        Sat, 15 Aug 2020 12:32:23 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 15 Aug 2020 12:32:23 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [213.143.48.187])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 6541042EF4E0;
        Sat, 15 Aug 2020 12:32:22 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 7/8] selftests: netfilter: kill running process only
Date:   Sat, 15 Aug 2020 12:32:00 +0200
Message-Id: <20200815103201.1768-8-pablo@netfilter.org>
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

Avoid noise like the following:
nft_flowtable.sh: line 250: kill: (4691) - No such process

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/nft_flowtable.sh | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
index e98cac6f8bfd..a47d1d832210 100755
--- a/tools/testing/selftests/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -250,8 +250,14 @@ test_tcp_forwarding_ip()
 
 	sleep 3
 
-	kill $lpid
-	kill $cpid
+	if ps -p $lpid > /dev/null;then
+		kill $lpid
+	fi
+
+	if ps -p $cpid > /dev/null;then
+		kill $cpid
+	fi
+
 	wait
 
 	check_transfer "$ns1in" "$ns2out" "ns1 -> ns2"
-- 
2.20.1

