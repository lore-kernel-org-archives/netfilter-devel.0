Return-Path: <SRS0=4S6R=YT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC776CA9EBC
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 11:48:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D3CD2070B
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 11:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbfJZLsS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 26 Oct 2019 07:48:18 -0400
Received: from correo.us.es ([193.147.175.20]:46444 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbfJZLr4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 26 Oct 2019 07:47:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C1FAC8C3C68
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:47:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B481BDA840
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:47:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AA4F2A7E25; Sat, 26 Oct 2019 13:47:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C54D8A7E22;
        Sat, 26 Oct 2019 13:47:50 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:47:50 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8D13842EE393;
        Sat, 26 Oct 2019 13:47:50 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 22/31] netfilter: nf_tables: increase maximum devices number per flowtable
Date:   Sat, 26 Oct 2019 13:47:24 +0200
Message-Id: <20191026114733.28111-23-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191026114733.28111-1-pablo@netfilter.org>
References: <20191026114733.28111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Rise the maximum limit of devices per flowtable up to 256. Rename
NFT_FLOWTABLE_DEVICE_MAX to NFT_NETDEVICE_MAX in preparation to reuse
the netdev hook parser for ingress basechain.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 2 +-
 net/netfilter/nf_tables_api.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 7a2ac82ee0ad..3d71070e747a 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1152,7 +1152,7 @@ struct nft_object_ops {
 int nft_register_obj(struct nft_object_type *obj_type);
 void nft_unregister_obj(struct nft_object_type *obj_type);
 
-#define NFT_FLOWTABLE_DEVICE_MAX	8
+#define NFT_NETDEVICE_MAX	256
 
 /**
  *	struct nft_flowtable - nf_tables flow table
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2664bc388db4..98169af56c0f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1577,7 +1577,7 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
 		list_add_tail(&hook->list, hook_list);
 		n++;
 
-		if (n == NFT_FLOWTABLE_DEVICE_MAX) {
+		if (n == NFT_NETDEVICE_MAX) {
 			err = -EFBIG;
 			goto err_hook;
 		}
-- 
2.11.0

