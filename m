Return-Path: <SRS0=cZSN=YJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7703FA372A
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Oct 2019 12:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F236205F4
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Oct 2019 12:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393127AbfJPMel (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Oct 2019 08:34:41 -0400
Received: from correo.us.es ([193.147.175.20]:50990 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391219AbfJPMel (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Oct 2019 08:34:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9113018CDC6
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2019 14:34:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 83BCFA7E18
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2019 14:34:36 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7960FDA72F; Wed, 16 Oct 2019 14:34:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 97F09A7E1C
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2019 14:34:34 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 16 Oct 2019 14:34:34 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7854942EE38F
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2019 14:34:34 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 3/4] netfilter: nf_tables: allow only one netdev per flowtable
Date:   Wed, 16 Oct 2019 14:34:30 +0200
Message-Id: <20191016123431.9072-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191016123431.9072-1-pablo@netfilter.org>
References: <20191016123431.9072-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Allow netdevice only once per flowtable, otherwise hit EEXIST.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0e0e35876b53..80ded807d529 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1538,6 +1538,19 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 	return ERR_PTR(err);
 }
 
+static bool nft_hook_list_find(struct list_head *hook_list,
+			       const struct nft_hook *this)
+{
+	struct nft_hook *hook;
+
+	list_for_each_entry(hook, hook_list, list) {
+		if (this->ops.dev == hook->ops.dev)
+			return true;
+	}
+
+	return false;
+}
+
 static int nf_tables_parse_netdev_hooks(struct net *net,
 					const struct nlattr *attr,
 					struct list_head *hook_list)
@@ -1557,6 +1570,10 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
 			err = PTR_ERR(hook);
 			goto err_hook;
 		}
+		if (nft_hook_list_find(hook_list, hook)) {
+			err = -EEXIST;
+			goto err_hook;
+		}
 		list_add_tail(&hook->list, hook_list);
 		n++;
 
-- 
2.11.0

