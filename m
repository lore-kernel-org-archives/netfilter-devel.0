Return-Path: <SRS0=qfGK=ZD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E83FBC43331
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Nov 2019 23:30:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6C5421655
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Nov 2019 23:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbfKKXaK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Nov 2019 18:30:10 -0500
Received: from correo.us.es ([193.147.175.20]:41004 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726902AbfKKXaJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Nov 2019 18:30:09 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BEBC51C4381
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Nov 2019 00:30:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B05A8FF13B
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Nov 2019 00:30:04 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A0135B8007; Tue, 12 Nov 2019 00:30:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B18E5B7FF2;
        Tue, 12 Nov 2019 00:30:02 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 12 Nov 2019 00:30:02 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4588542EF4E0;
        Tue, 12 Nov 2019 00:30:02 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, paulb@mellanox.com,
        ozsh@mellanox.com, majd@mellanox.com, saeedm@mellanox.com
Subject: [PATCH net-next 2/6] netfilter: nf_flow_table: remove union from flow_offload structure
Date:   Tue, 12 Nov 2019 00:29:52 +0100
Message-Id: <20191111232956.24898-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191111232956.24898-1-pablo@netfilter.org>
References: <20191111232956.24898-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Drivers do not have access to the flow_offload structure, hence remove
this union from this flow_offload object as well as the original comment
on top of it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 88c8cd248213..7f892d6c1a6d 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -74,10 +74,7 @@ struct flow_offload {
 	struct flow_offload_tuple_rhash		tuplehash[FLOW_OFFLOAD_DIR_MAX];
 	struct nf_conn				*ct;
 	u32					flags;
-	union {
-		/* Your private driver data here. */
-		u32		timeout;
-	};
+	u32					timeout;
 };
 
 #define NF_FLOW_TIMEOUT (30 * HZ)
-- 
2.11.0

