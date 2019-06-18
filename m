Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B03AC31E5B
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:22:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3461D213F2
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:22:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729061AbfFROWt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 10:22:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51156 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbfFROWt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 10:22:49 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hdF0W-0004yF-Dq; Tue, 18 Jun 2019 14:22:44 +0000
From:   Colin King <colin.king@canonical.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][V2][next] netfilter: synproxy: ensure zero is returned on non-error return path
Date:   Tue, 18 Jun 2019 15:22:44 +0100
Message-Id: <20190618142244.16463-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently functions nf_synproxy_{ipc4|ipv6}_init return an uninitialized
garbage value in variable ret on a successful return.  Fix this by
returning zero on success.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: d7f9b2f18eae ("netfilter: synproxy: extract SYNPROXY infrastructure from {ipt, ip6t}_SYNPROXY")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/netfilter/nf_synproxy_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 50677285f82e..7bf5202e3222 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -798,7 +798,7 @@ int nf_synproxy_ipv4_init(struct synproxy_net *snet, struct net *net)
 	}
 
 	snet->hook_ref4++;
-	return err;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(nf_synproxy_ipv4_init);
 
@@ -1223,7 +1223,7 @@ nf_synproxy_ipv6_init(struct synproxy_net *snet, struct net *net)
 	}
 
 	snet->hook_ref6++;
-	return err;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(nf_synproxy_ipv6_init);
 
-- 
2.20.1

