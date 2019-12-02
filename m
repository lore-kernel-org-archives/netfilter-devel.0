Return-Path: <SRS0=20nZ=ZY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66EBCC432C0
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 18:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 449432070A
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 18:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbfLBSwL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Dec 2019 13:52:11 -0500
Received: from correo.us.es ([193.147.175.20]:47720 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727464AbfLBSwK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 13:52:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 45D54BAEB2
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Dec 2019 19:52:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 36FA9DA70E
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Dec 2019 19:52:07 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2C876DA70D; Mon,  2 Dec 2019 19:52:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 245FCDA70E
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Dec 2019 19:52:05 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 02 Dec 2019 19:52:05 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 06D8942EE38E
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Dec 2019 19:52:04 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] netlink: off-by-one write in netdev chain device array
Date:   Mon,  2 Dec 2019 19:52:03 +0100
Message-Id: <20191202185203.730187-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

==728473== Invalid write of size 8
==728473==    at 0x48960F2: netlink_delinearize_chain (netlink.c:422)
==728473==    by 0x4896252: list_chain_cb (netlink.c:459)
==728473==    by 0x4896252: list_chain_cb (netlink.c:441)
==728473==    by 0x4F2C654: nftnl_chain_list_foreach (chain.c:1011)
==728473==    by 0x489629F: netlink_list_chains (netlink.c:478)
==728473==    by 0x4882303: cache_init_objects (rule.c:177)
==728473==    by 0x4882303: cache_init (rule.c:222)
==728473==    by 0x4882303: cache_update (rule.c:272)
==728473==    by 0x48A7DCE: nft_evaluate (libnftables.c:408)
==728473==    by 0x48A86D9: nft_run_cmd_from_buffer (libnftables.c:449)
==728473==    by 0x10A5D6: main (main.c:338)

Fixes: 3fdc7541fba0 ("src: add multidevice support for netdev chain")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 7306e358ca39..486e12473726 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -415,7 +415,7 @@ struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
 						    &policy);
 			nftnl_chain_get_u32(nlc, NFTNL_CHAIN_POLICY);
 		if (nftnl_chain_is_set(nlc, NFTNL_CHAIN_DEV)) {
-			chain->dev_array = xmalloc(sizeof(char *));
+			chain->dev_array = xmalloc(sizeof(char *) * 2);
 			chain->dev_array_len = 1;
 			chain->dev_array[0] =
 				xstrdup(nftnl_chain_get_str(nlc, NFTNL_CHAIN_DEV));
@@ -425,7 +425,7 @@ struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
 			while (dev_array[len])
 				len++;
 
-			chain->dev_array = xmalloc(len * sizeof(char *));
+			chain->dev_array = xmalloc((len + 1)* sizeof(char *));
 			for (i = 0; i < len; i++)
 				chain->dev_array[i] = xstrdup(dev_array[i]);
 
-- 
2.11.0

