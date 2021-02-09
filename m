Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 466C8C433E6
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Feb 2021 22:15:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DE2464E6F
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Feb 2021 22:15:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbhBIWMf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Feb 2021 17:12:35 -0500
Received: from correo.us.es ([193.147.175.20]:40676 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233784AbhBIWH4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Feb 2021 17:07:56 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 61005B6337
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Feb 2021 22:35:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4BC51DA730
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Feb 2021 22:35:19 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 40E42DA722; Tue,  9 Feb 2021 22:35:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 109A5DA789;
        Tue,  9 Feb 2021 22:35:17 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 09 Feb 2021 22:35:17 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id CA67142DC6DD;
        Tue,  9 Feb 2021 22:35:16 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 1/2] netfilter: conntrack: skip identical origin tuple in same zone only
Date:   Tue,  9 Feb 2021 22:35:10 +0100
Message-Id: <20210209213511.23298-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210209213511.23298-1-pablo@netfilter.org>
References: <20210209213511.23298-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The origin skip check needs to re-test the zone. Else, we might skip
a colliding tuple in the reply direction.

This only occurs when using 'directional zones' where origin tuples
reside in different zones but the reply tuples share the same zone.

This causes the new conntrack entry to be dropped at confirmation time
because NAT clash resolution was elided.

Fixes: 4e35c1cb9460240 ("netfilter: nf_nat: skip nat clash resolution for same-origin entries")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 234b7cab37c3..ff0168736f6e 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1229,7 +1229,8 @@ nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
 			 * Let nf_ct_resolve_clash() deal with this later.
 			 */
 			if (nf_ct_tuple_equal(&ignored_conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
-					      &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple))
+					      &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple) &&
+					      nf_ct_zone_equal(ct, zone, IP_CT_DIR_ORIGINAL))
 				continue;
 
 			NF_CT_STAT_INC_ATOMIC(net, found);
-- 
2.20.1

