Return-Path: <SRS0=WPBU=CJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6F75C433E6
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Aug 2020 09:37:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2CD02068F
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Aug 2020 09:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgHaJhd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 Aug 2020 05:37:33 -0400
Received: from correo.us.es ([193.147.175.20]:40382 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgHaJg7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Aug 2020 05:36:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D10FC15AEB3
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2020 11:36:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C1D0CDA84B
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2020 11:36:56 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B750FDA73F; Mon, 31 Aug 2020 11:36:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9C5DEDA78D;
        Mon, 31 Aug 2020 11:36:54 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 31 Aug 2020 11:36:54 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 72AEB42EF4E0;
        Mon, 31 Aug 2020 11:36:54 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 3/8] selftests: netfilter: fix header example
Date:   Mon, 31 Aug 2020 11:36:43 +0200
Message-Id: <20200831093648.20765-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200831093648.20765-1-pablo@netfilter.org>
References: <20200831093648.20765-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>

nft_flowtable.sh is made for bash not sh.
Also give values which not return "RTNETLINK answers: Invalid argument"

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/nft_flowtable.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
index a47d1d832210..28e32fddf9b2 100755
--- a/tools/testing/selftests/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -11,7 +11,7 @@
 # result in fragmentation and/or PMTU discovery.
 #
 # You can check with different Orgininator/Link/Responder MTU eg:
-# sh nft_flowtable.sh -o1000 -l500 -r100
+# nft_flowtable.sh -o8000 -l1500 -r2000
 #
 
 
-- 
2.20.1

