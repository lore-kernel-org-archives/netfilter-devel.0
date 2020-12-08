Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B13CC1B0D8
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Dec 2020 18:01:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FD1623B44
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Dec 2020 18:01:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730897AbgLHSBt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Dec 2020 13:01:49 -0500
Received: from correo.us.es ([193.147.175.20]:37654 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728633AbgLHSBs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 13:01:48 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7BF1D154E82
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Dec 2020 19:00:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6B6E7DA78F
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Dec 2020 19:00:58 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 60FB9DA78E; Tue,  8 Dec 2020 19:00:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 41A18DA73D;
        Tue,  8 Dec 2020 19:00:56 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 08 Dec 2020 19:00:56 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 266A64265A5A;
        Tue,  8 Dec 2020 19:00:56 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     olteanv@gmail.com
Subject: [PATCH nf] netfilter: nftables: comment indirect serialization of commit_mutex with rtnl_mutex
Date:   Tue,  8 Dec 2020 19:01:01 +0100
Message-Id: <20201208180101.14705-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add an explicit comment in the code to describe the indirect
serialization of the holders of the commit_mutex with the rtnl_mutex.
Commit 90d2723c6d4c ("netfilter: nf_tables: do not hold reference on
netdevice from preparation phase") already describes this, but a comment
in this case if better for reference.

Reported-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c2f59879a48d..9a080767667b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1723,6 +1723,10 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 	}
 
 	nla_strlcpy(ifname, attr, IFNAMSIZ);
+	/* nf_tables_netdev_event() is called under rtnl_mutex, this is
+	 * indirectly serializing all the other holders of the commit_mutex with
+	 * the rtnl_mutex.
+	 */
 	dev = __dev_get_by_name(net, ifname);
 	if (!dev) {
 		err = -ENOENT;
-- 
2.20.1

