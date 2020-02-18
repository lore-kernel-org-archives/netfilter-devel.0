Return-Path: <SRS0=aYEw=4G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76951C34031
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Feb 2020 22:21:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 590FF206E2
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Feb 2020 22:21:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgBRWVK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Feb 2020 17:21:10 -0500
Received: from correo.us.es ([193.147.175.20]:57480 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbgBRWVJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Feb 2020 17:21:09 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0B318303D08
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Feb 2020 23:21:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EEA6EDA3A0
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Feb 2020 23:21:07 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E462EDA38F; Tue, 18 Feb 2020 23:21:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0C941DA7B6;
        Tue, 18 Feb 2020 23:21:06 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Feb 2020 23:21:06 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E095442EE38E;
        Tue, 18 Feb 2020 23:21:05 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 1/9] netfilter: xt_hashlimit: reduce hashlimit_mutex scope for htable_put()
Date:   Tue, 18 Feb 2020 23:20:53 +0100
Message-Id: <20200218222101.635808-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200218222101.635808-1-pablo@netfilter.org>
References: <20200218222101.635808-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

It is unnecessary to hold hashlimit_mutex for htable_destroy()
as it is already removed from the global hashtable and its
refcount is already zero.

Also, switch hinfo->use to refcount_t so that we don't have
to hold the mutex until it reaches zero in htable_put().

Reported-and-tested-by: syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_hashlimit.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index bccd47cd7190..cc475a608f81 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -36,6 +36,7 @@
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/mutex.h>
 #include <linux/kernel.h>
+#include <linux/refcount.h>
 #include <uapi/linux/netfilter/xt_hashlimit.h>
 
 #define XT_HASHLIMIT_ALL (XT_HASHLIMIT_HASH_DIP | XT_HASHLIMIT_HASH_DPT | \
@@ -114,7 +115,7 @@ struct dsthash_ent {
 
 struct xt_hashlimit_htable {
 	struct hlist_node node;		/* global list of all htables */
-	int use;
+	refcount_t use;
 	u_int8_t family;
 	bool rnd_initialized;
 
@@ -315,7 +316,7 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 	for (i = 0; i < hinfo->cfg.size; i++)
 		INIT_HLIST_HEAD(&hinfo->hash[i]);
 
-	hinfo->use = 1;
+	refcount_set(&hinfo->use, 1);
 	hinfo->count = 0;
 	hinfo->family = family;
 	hinfo->rnd_initialized = false;
@@ -420,7 +421,7 @@ static struct xt_hashlimit_htable *htable_find_get(struct net *net,
 	hlist_for_each_entry(hinfo, &hashlimit_net->htables, node) {
 		if (!strcmp(name, hinfo->name) &&
 		    hinfo->family == family) {
-			hinfo->use++;
+			refcount_inc(&hinfo->use);
 			return hinfo;
 		}
 	}
@@ -429,12 +430,11 @@ static struct xt_hashlimit_htable *htable_find_get(struct net *net,
 
 static void htable_put(struct xt_hashlimit_htable *hinfo)
 {
-	mutex_lock(&hashlimit_mutex);
-	if (--hinfo->use == 0) {
+	if (refcount_dec_and_mutex_lock(&hinfo->use, &hashlimit_mutex)) {
 		hlist_del(&hinfo->node);
+		mutex_unlock(&hashlimit_mutex);
 		htable_destroy(hinfo);
 	}
-	mutex_unlock(&hashlimit_mutex);
 }
 
 /* The algorithm used is the Simple Token Bucket Filter (TBF)
-- 
2.11.0

