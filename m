Return-Path: <SRS0=OxIk=DL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B9AC47095
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Oct 2020 19:50:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28BDB2068E
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Oct 2020 19:50:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgJDTuZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 4 Oct 2020 15:50:25 -0400
Received: from correo.us.es ([193.147.175.20]:34982 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726534AbgJDTuO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Oct 2020 15:50:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 930DAEF438
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2020 21:50:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 84057DA791
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2020 21:50:12 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 82744DA722; Sun,  4 Oct 2020 21:50:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 34CEDDA722;
        Sun,  4 Oct 2020 21:50:10 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 04 Oct 2020 21:50:10 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 0BC9942EF9E2;
        Sun,  4 Oct 2020 21:50:10 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 08/11] netfilter: ipset: enable memory accounting for ipset allocations
Date:   Sun,  4 Oct 2020 21:49:37 +0200
Message-Id: <20201004194940.7368-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201004194940.7368-1-pablo@netfilter.org>
References: <20201004194940.7368-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

Currently netadmin inside non-trusted container can quickly allocate
whole node's memory via request of huge ipset hashtable.
Other ipset-related memory allocations should be restricted too.

v2: fixed typo ALLOC -> ACCOUNT

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 920b7c4331f0..6f35832f0de3 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -250,22 +250,7 @@ EXPORT_SYMBOL_GPL(ip_set_type_unregister);
 void *
 ip_set_alloc(size_t size)
 {
-	void *members = NULL;
-
-	if (size < KMALLOC_MAX_SIZE)
-		members = kzalloc(size, GFP_KERNEL | __GFP_NOWARN);
-
-	if (members) {
-		pr_debug("%p: allocated with kmalloc\n", members);
-		return members;
-	}
-
-	members = vzalloc(size);
-	if (!members)
-		return NULL;
-	pr_debug("%p: allocated with vmalloc\n", members);
-
-	return members;
+	return kvzalloc(size, GFP_KERNEL_ACCOUNT);
 }
 EXPORT_SYMBOL_GPL(ip_set_alloc);
 
-- 
2.20.1

