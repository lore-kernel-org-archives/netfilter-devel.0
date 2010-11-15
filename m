From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH nf-next-2.6] conntrack: one less atomic op in
 nf_ct_expect_insert()
Date: Mon, 15 Nov 2010 23:57:57 +0100
Message-ID: <1289861877.3364.22.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54130 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab0KOW6F (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 17:58:05 -0500
Received: by wyb28 with SMTP id 28so12088wyb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Nov 2010 14:58:03 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Instead of doing atomic_inc(&exp->use) twice,
call atomic_add(2, &exp->use);

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/netfilter/nf_conntrack_expect.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index bbb2140..774f32b 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -323,7 +323,8 @@ static void nf_ct_expect_insert(struct nf_conntrack_expect *exp)
 	const struct nf_conntrack_expect_policy *p;
 	unsigned int h = nf_ct_expect_dst_hash(&exp->tuple);
 
-	atomic_inc(&exp->use);
+	/* two references : one for hash insert, one for the timer */
+	atomic_add(2, &exp->use);
 
 	if (master_help) {
 		hlist_add_head(&exp->lnode, &master_help->expectations);
@@ -345,7 +346,6 @@ static void nf_ct_expect_insert(struct nf_conntrack_expect *exp)
 	}
 	add_timer(&exp->timeout);
 
-	atomic_inc(&exp->use);
 	NF_CT_STAT_INC(net, expect_create);
 }
 


