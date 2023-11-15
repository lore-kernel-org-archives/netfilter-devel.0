Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C305CC072A2
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Nov 2023 18:45:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjKOSp0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Nov 2023 13:45:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjKOSp0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Nov 2023 13:45:26 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D50DD6D;
        Wed, 15 Nov 2023 10:45:22 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, fw@strlen.de
Subject: [PATCH net 4/6] netfilter: nf_tables: bogus ENOENT when destroying element which does not exist
Date:   Wed, 15 Nov 2023 19:45:12 +0100
Message-Id: <20231115184514.8965-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231115184514.8965-1-pablo@netfilter.org>
References: <20231115184514.8965-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

destroy element command bogusly reports ENOENT in case a set element
does not exist. ENOENT errors are skipped, however, err is still set
and propagated to userspace.

 # nft destroy element ip raw BLACKLIST { 1.2.3.4 }
 Error: Could not process rule: No such file or directory
 destroy element ip raw BLACKLIST { 1.2.3.4 }
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Fixes: f80a612dd77c ("netfilter: nf_tables: add support to destroy operation")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a761ee6796f6..debea1c67701 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7263,10 +7263,11 @@ static int nf_tables_delsetelem(struct sk_buff *skb,
 
 		if (err < 0) {
 			NL_SET_BAD_ATTR(extack, attr);
-			break;
+			return err;
 		}
 	}
-	return err;
+
+	return 0;
 }
 
 /*
-- 
2.30.2

