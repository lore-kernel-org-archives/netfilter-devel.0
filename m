Return-Path: <SRS0=bPAQ=64=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03960C433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 May 2020 12:19:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3A70206A5
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 May 2020 12:19:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgENMTW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 May 2020 08:19:22 -0400
Received: from correo.us.es ([193.147.175.20]:54246 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbgENMTW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 May 2020 08:19:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9C1F315AEB0
        for <netfilter-devel@vger.kernel.org>; Thu, 14 May 2020 14:19:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8B736DA710
        for <netfilter-devel@vger.kernel.org>; Thu, 14 May 2020 14:19:19 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8AC4ADA703; Thu, 14 May 2020 14:19:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 83A69DA714;
        Thu, 14 May 2020 14:19:17 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 14 May 2020 14:19:17 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 5D69A42EF42B;
        Thu, 14 May 2020 14:19:17 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 1/6] netfilter: conntrack: avoid gcc-10 zero-length-bounds warning
Date:   Thu, 14 May 2020 14:19:08 +0200
Message-Id: <20200514121913.24519-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514121913.24519-1-pablo@netfilter.org>
References: <20200514121913.24519-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

gcc-10 warns around a suspicious access to an empty struct member:

net/netfilter/nf_conntrack_core.c: In function '__nf_conntrack_alloc':
net/netfilter/nf_conntrack_core.c:1522:9: warning: array subscript 0 is outside the bounds of an interior zero-length array 'u8[0]' {aka 'unsigned char[0]'} [-Wzero-length-bounds]
 1522 |  memset(&ct->__nfct_init_offset[0], 0,
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from net/netfilter/nf_conntrack_core.c:37:
include/net/netfilter/nf_conntrack.h:90:5: note: while referencing '__nfct_init_offset'
   90 |  u8 __nfct_init_offset[0];
      |     ^~~~~~~~~~~~~~~~~~

The code is correct but a bit unusual. Rework it slightly in a way that
does not trigger the warning, using an empty struct instead of an empty
array. There are probably more elegant ways to do this, but this is the
smallest change.

Fixes: c41884ce0562 ("netfilter: conntrack: avoid zeroing timer")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack.h | 2 +-
 net/netfilter/nf_conntrack_core.c    | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 9f551f3b69c6..90690e37a56f 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -87,7 +87,7 @@ struct nf_conn {
 	struct hlist_node	nat_bysource;
 #endif
 	/* all members below initialized via memset */
-	u8 __nfct_init_offset[0];
+	struct { } __nfct_init_offset;
 
 	/* If we were expected by an expectation, this will be it */
 	struct nf_conn *master;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index c4582eb71766..0173398f4ced 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1519,9 +1519,9 @@ __nf_conntrack_alloc(struct net *net,
 	ct->status = 0;
 	ct->timeout = 0;
 	write_pnet(&ct->ct_net, net);
-	memset(&ct->__nfct_init_offset[0], 0,
+	memset(&ct->__nfct_init_offset, 0,
 	       offsetof(struct nf_conn, proto) -
-	       offsetof(struct nf_conn, __nfct_init_offset[0]));
+	       offsetof(struct nf_conn, __nfct_init_offset));
 
 	nf_ct_zone_add(ct, zone);
 
-- 
2.20.1

