Return-Path: <SRS0=xc7Z=RE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BB90C43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Mar 2019 05:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A77D20854
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Mar 2019 05:59:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="c4yCENa+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725982AbfCAF7K (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Mar 2019 00:59:10 -0500
Received: from m12-11.163.com ([220.181.12.11]:44105 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725931AbfCAF7K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Mar 2019 00:59:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=tUOcAXbC57tewSd2Ua
        HB7li6S8FsNoFf+1c7U8KA+CA=; b=c4yCENa+R1ix9ZCJLSAsNAifQJJoD6UZH+
        BR80lUsDrMnFx4tgCKsMNYYsOuw30kmJARh9SjDGNJ5p/g/T4VGQwxuPs1RPRuzw
        KPau58SSgqgKX+PkjERf3cF9L6dA/W9kEguYzbkZzqkJUX4j/lcXLyjmN7QJMbak
        kUZC+qtis=
Received: from localhost.localdomain (unknown [111.231.88.23])
        by smtp7 (Coremail) with SMTP id C8CowACnRAqWyXhcUuxTHw--.49115S2;
        Fri, 01 Mar 2019 13:56:48 +0800 (CST)
From:   Su Yanjun <suyanjun218@163.com>
To:     pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     suyj.fnst@cn.fujitsu.com, suyanjun218@163.com
Subject: [PATCH] netfilter: nf_ct_helper: Fix possible panic when nf_conntrack_helper_unregister is used in an unloadable module
Date:   Fri,  1 Mar 2019 13:56:06 +0800
Message-Id: <1551419766-1039-1-git-send-email-suyanjun218@163.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: C8CowACnRAqWyXhcUuxTHw--.49115S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Cr47ZryDXrWrWFykXFW5Wrg_yoW8Cw4fpw
        1Sg343tw1kJFsYyws7uw4xZ3W8trZ3ZF45Xrn3JFyfZw4Dtw1DuFWfKrW7WFW5Jr4fJrnF
        yw1Yvw13Aa4kAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07boOzsUUUUU=
X-Originating-IP: [111.231.88.23]
X-CM-SenderInfo: pvx1t0xmxqjiqy6rljoofrz/1tbiTgBqy1UC8p9ojQAAsw
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Su Yanjun <suyj.fnst@cn.fujitsu.com>

Because nf_conntrack_helper_unregister maybe used in an unloadable module,
it uses 'synchronize_rcu' which may cause kernel panic.

According to the artical:
RCU and Unloadable Modules
https://lwn.net/Articles/217484/

When we have a heavy rcu callback load, then some of the callbacks might be
deferred in order to allow other processing to proceed. sychnorize_rcu does
not wait rcu callback complete and module may be unloaded before callback
done.

This patch uses rcu_barrier instead of synchronize_rcu will prevent this
situation.

Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
---
 net/netfilter/nf_conntrack_helper.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 274baf1..0ee9378 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -397,8 +397,15 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 
 	/* Make sure every nothing is still using the helper unless its a
 	 * connection in the hash.
+	 *
+	 * 'synchronize_rcu' may have problem when rcu callback function
+	 * is used in unloadable modules. Use rcu_barrier instead, so that
+	 * it will wait until rcu callback completes before modules are
+	 * unloaded.
+	 * More detail about rcu_barrier please see:
+	 * https://lwn.net/Articles/217484/
 	 */
-	synchronize_rcu();
+	rcu_barrier();
 
 	nf_ct_expect_iterate_destroy(expect_iter_me, NULL);
 	nf_ct_iterate_destroy(unhelp, me);
@@ -406,7 +413,7 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 	/* Maybe someone has gotten the helper already when unhelp above.
 	 * So need to wait it.
 	 */
-	synchronize_rcu();
+	rcu_barrier();
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
 
-- 
2.7.4


