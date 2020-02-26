Return-Path: <SRS0=IqR4=4O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D909BC4BA32
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Feb 2020 22:55:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5A8F2072D
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Feb 2020 22:55:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgBZWzG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Feb 2020 17:55:06 -0500
Received: from correo.us.es ([193.147.175.20]:36442 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727902AbgBZWzC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Feb 2020 17:55:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 09B221C4385
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Feb 2020 23:54:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ED811DA3A0
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Feb 2020 23:54:52 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E2D14DA38F; Wed, 26 Feb 2020 23:54:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 186A8DA788;
        Wed, 26 Feb 2020 23:54:51 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 26 Feb 2020 23:54:51 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E6F0942EF4E0;
        Wed, 26 Feb 2020 23:54:50 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 6/6] netfilter: xt_hashlimit: unregister proc file before releasing mutex
Date:   Wed, 26 Feb 2020 23:54:42 +0100
Message-Id: <20200226225442.9598-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200226225442.9598-1-pablo@netfilter.org>
References: <20200226225442.9598-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

Before releasing the global mutex, we only unlink the hashtable
from the hash list, its proc file is still not unregistered at
this point. So syzbot could trigger a race condition where a
parallel htable_create() could register the same file immediately
after the mutex is released.

Move htable_remove_proc_entry() back to mutex protection to
fix this. And, fold htable_destroy() into htable_put() to make
the code slightly easier to understand.

Reported-and-tested-by: syzbot+d195fd3b9a364ddd6731@syzkaller.appspotmail.com
Fixes: c4a3922d2d20 ("netfilter: xt_hashlimit: reduce hashlimit_mutex scope for htable_put()")
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_hashlimit.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 7a2c4b8408c4..8c835ad63729 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -402,15 +402,6 @@ static void htable_remove_proc_entry(struct xt_hashlimit_htable *hinfo)
 		remove_proc_entry(hinfo->name, parent);
 }
 
-static void htable_destroy(struct xt_hashlimit_htable *hinfo)
-{
-	cancel_delayed_work_sync(&hinfo->gc_work);
-	htable_remove_proc_entry(hinfo);
-	htable_selective_cleanup(hinfo, true);
-	kfree(hinfo->name);
-	vfree(hinfo);
-}
-
 static struct xt_hashlimit_htable *htable_find_get(struct net *net,
 						   const char *name,
 						   u_int8_t family)
@@ -432,8 +423,13 @@ static void htable_put(struct xt_hashlimit_htable *hinfo)
 {
 	if (refcount_dec_and_mutex_lock(&hinfo->use, &hashlimit_mutex)) {
 		hlist_del(&hinfo->node);
+		htable_remove_proc_entry(hinfo);
 		mutex_unlock(&hashlimit_mutex);
-		htable_destroy(hinfo);
+
+		cancel_delayed_work_sync(&hinfo->gc_work);
+		htable_selective_cleanup(hinfo, true);
+		kfree(hinfo->name);
+		vfree(hinfo);
 	}
 }
 
-- 
2.11.0

