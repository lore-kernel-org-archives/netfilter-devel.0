Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C3BDC433DB
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Feb 2021 00:18:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BE1564FBB
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Feb 2021 00:18:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbhBEASc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Feb 2021 19:18:32 -0500
Received: from correo.us.es ([193.147.175.20]:40582 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231767AbhBEASQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Feb 2021 19:18:16 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 20FC92A3266
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Feb 2021 01:17:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0CF04DA73F
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Feb 2021 01:17:34 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 01A75DA78A; Fri,  5 Feb 2021 01:17:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A68FADA704;
        Fri,  5 Feb 2021 01:17:31 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 05 Feb 2021 01:17:31 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 74DE942EF9E1;
        Fri,  5 Feb 2021 01:17:31 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 2/4] selftests: netfilter: fix current year
Date:   Fri,  5 Feb 2021 01:17:25 +0100
Message-Id: <20210205001727.2125-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210205001727.2125-1-pablo@netfilter.org>
References: <20210205001727.2125-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>

use date %Y instead of %G to read current year
Problem appeared when running lkp-tests on 01/01/2021

Fixes: 48d072c4e8cd ("selftests: netfilter: add time counter check")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/nft_meta.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/netfilter/nft_meta.sh b/tools/testing/selftests/netfilter/nft_meta.sh
index 087f0e6e71ce..f33154c04d34 100755
--- a/tools/testing/selftests/netfilter/nft_meta.sh
+++ b/tools/testing/selftests/netfilter/nft_meta.sh
@@ -23,7 +23,7 @@ ip -net "$ns0" addr add 127.0.0.1 dev lo
 
 trap cleanup EXIT
 
-currentyear=$(date +%G)
+currentyear=$(date +%Y)
 lastyear=$((currentyear-1))
 ip netns exec "$ns0" nft -f /dev/stdin <<EOF
 table inet filter {
-- 
2.20.1

