Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FD15C7EE2F
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 May 2023 15:08:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbjE0PIM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 27 May 2023 11:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbjE0PIH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 27 May 2023 11:08:07 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 07C46E3;
        Sat, 27 May 2023 08:08:07 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        sashal@kernel.org
Subject: [PATCH -stable,4.14 11/11] netfilter: nf_tables: fix register ordering
Date:   Sat, 27 May 2023 18:08:11 +0200
Message-Id: <20230527160811.67779-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230527160811.67779-1-pablo@netfilter.org>
References: <20230527160811.67779-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ d209df3e7f7002d9099fdb0f6df0f972b4386a63 ]

[ We hit the trace described in commit message with the
kselftest/nft_trans_stress.sh. This patch diverges from the upstream one
since kernel 4.14 does not have following symbols:
nft_chain_filter_init, nf_tables_flowtable_notifier ]

We must register nfnetlink ops last, as that exposes nf_tables to
userspace.  Without this, we could theoretically get nfnetlink request
before net->nft state has been initialized.

Fixes: 99633ab29b213 ("netfilter: nf_tables: complete net namespace support")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[apanyaki: backport to v4.14-stable]
Signed-off-by: Andrew Paniakin <apanyaki@amazon.com>
---
 net/netfilter/nf_tables_api.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 345fa29f34b9..241a3032d0e6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6105,18 +6105,25 @@ static int __init nf_tables_module_init(void)
 		goto err1;
 	}
 
-	err = nf_tables_core_module_init();
+	err = register_pernet_subsys(&nf_tables_net_ops);
 	if (err < 0)
 		goto err2;
 
-	err = nfnetlink_subsys_register(&nf_tables_subsys);
+	err = nf_tables_core_module_init();
 	if (err < 0)
 		goto err3;
 
+	/* must be last */
+	err = nfnetlink_subsys_register(&nf_tables_subsys);
+	if (err < 0)
+		goto err4;
+
 	pr_info("nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>\n");
-	return register_pernet_subsys(&nf_tables_net_ops);
-err3:
+	return err;
+err4:
 	nf_tables_core_module_exit();
+err3:
+	unregister_pernet_subsys(&nf_tables_net_ops);
 err2:
 	kfree(info);
 err1:
-- 
2.30.2

