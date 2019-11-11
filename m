Return-Path: <SRS0=qfGK=ZD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56FB0C43331
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Nov 2019 23:35:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32FED21925
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Nov 2019 23:35:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbfKKXe6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Nov 2019 18:34:58 -0500
Received: from correo.us.es ([193.147.175.20]:43048 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726887AbfKKXer (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Nov 2019 18:34:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B5FB62A2BCD
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Nov 2019 00:34:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A564E66DC
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Nov 2019 00:34:43 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9AFFFDA801; Tue, 12 Nov 2019 00:34:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A5D0AB7FF2;
        Tue, 12 Nov 2019 00:34:41 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 12 Nov 2019 00:34:41 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 663EF42EF4E0;
        Tue, 12 Nov 2019 00:34:41 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     saeedm@mellanox.com
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: [PATCH mlx5-next 4/7] net/mlx5: Accumulate levels for chains prio namespaces
Date:   Tue, 12 Nov 2019 00:34:27 +0100
Message-Id: <20191111233430.25120-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191111233430.25120-1-pablo@netfilter.org>
References: <20191111233430.25120-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Tc chains are implemented by creating a chained prio steering type, and
inside it there is a namespace for each chain (FDB_TC_MAX_CHAINS). Each
of those has a list of priorities.

Currently, all namespaces in a prio start at the parent prio level.
But since we can jump from chain (namespace) to another chain in the
same prio, we need the levels for higher chains to be higher as well.
So we created unused prios to account for levels in previous namespaces.

Fix that by accumulating the namespaces levels if we are inside a chained
type prio, and removing the unused prios.

Issue: 1929510
Change-Id: I73e106aeb81d8b534c6d17572d7148f26fc8aaf6
Fixes: 328edb499f99 ('net/mlx5: Split FDB fast path prio to multiple namespaces')
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c          | 10 +++++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index e22366ecdf6c..2e69f7989747 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -952,7 +952,7 @@ esw_get_prio_table(struct mlx5_eswitch *esw, u32 chain, u16 prio, int level)
 		flags |= (MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT |
 			  MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
 
-	table_prio = (chain * FDB_TC_MAX_PRIO) + prio - 1;
+	table_prio = prio - 1;
 
 	/* create earlier levels for correct fs_core lookup when
 	 * connecting tables
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 881fe85934b1..0da932b6bae9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2400,9 +2400,17 @@ static void set_prio_attrs_in_prio(struct fs_prio *prio, int acc_level)
 	int acc_level_ns = acc_level;
 
 	prio->start_level = acc_level;
-	fs_for_each_ns(ns, prio)
+	fs_for_each_ns(ns, prio) {
 		/* This updates start_level and num_levels of ns's priority descendants */
 		acc_level_ns = set_prio_attrs_in_ns(ns, acc_level);
+
+		/* If this a prio with chains, and we can jump from one chain
+		 * (namepsace) to another, so we accumulate the levels
+		 */
+		if (prio->node.type == FS_TYPE_PRIO_CHAINS)
+			acc_level = acc_level_ns;
+	}
+
 	if (!prio->num_levels)
 		prio->num_levels = acc_level_ns - prio->start_level;
 	WARN_ON(prio->num_levels < acc_level_ns - prio->start_level);
-- 
2.11.0

