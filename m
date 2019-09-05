Return-Path: <SRS0=iWGL=XA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D036C43331
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Sep 2019 16:04:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48912206DE
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Sep 2019 16:04:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390839AbfIEQEW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Sep 2019 12:04:22 -0400
Received: from correo.us.es ([193.147.175.20]:53076 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390804AbfIEQEL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Sep 2019 12:04:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BB2FE1228CA
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Sep 2019 18:04:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AB829B8011
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Sep 2019 18:04:07 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A12DCB7FFB; Thu,  5 Sep 2019 18:04:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9A194DA7B6;
        Thu,  5 Sep 2019 18:04:05 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 05 Sep 2019 18:04:05 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6A16F42EE38E;
        Thu,  5 Sep 2019 18:04:05 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 5/8] netfilter: not mark a spinlock as __read_mostly
Date:   Thu,  5 Sep 2019 18:03:57 +0200
Message-Id: <20190905160400.25399-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190905160400.25399-1-pablo@netfilter.org>
References: <20190905160400.25399-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

when spinlock is locked/unlocked, its elements will be changed,
so marking it as __read_mostly is not suitable.

and remove a duplicate definition of nf_conntrack_locks_all_lock
strange that compiler does not complain.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c   | 3 +--
 net/netfilter/nf_conntrack_labels.c | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 81a8ef42b88d..0c63120b2db2 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -73,8 +73,7 @@ struct conntrack_gc_work {
 };
 
 static __read_mostly struct kmem_cache *nf_conntrack_cachep;
-static __read_mostly spinlock_t nf_conntrack_locks_all_lock;
-static __read_mostly DEFINE_SPINLOCK(nf_conntrack_locks_all_lock);
+static DEFINE_SPINLOCK(nf_conntrack_locks_all_lock);
 static __read_mostly bool nf_conntrack_locks_all;
 
 /* every gc cycle scans at most 1/GC_MAX_BUCKETS_DIV part of table */
diff --git a/net/netfilter/nf_conntrack_labels.c b/net/netfilter/nf_conntrack_labels.c
index d1c6b2a2e7bd..522792556632 100644
--- a/net/netfilter/nf_conntrack_labels.c
+++ b/net/netfilter/nf_conntrack_labels.c
@@ -11,7 +11,7 @@
 #include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_labels.h>
 
-static __read_mostly DEFINE_SPINLOCK(nf_connlabels_lock);
+static DEFINE_SPINLOCK(nf_connlabels_lock);
 
 static int replace_u32(u32 *address, u32 mask, u32 new)
 {
-- 
2.11.0

