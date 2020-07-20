Return-Path: <SRS0=qgEK=A7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2398C433E8
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jul 2020 16:32:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACD412070A
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jul 2020 16:32:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="1BzcJb5U";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="TZmK83GN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387503AbgGTQcN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jul 2020 12:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731569AbgGTP4p (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jul 2020 11:56:45 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7F9C061794;
        Mon, 20 Jul 2020 08:56:45 -0700 (PDT)
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595260604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4/ywCu1ddv/vjOuhHxWVQ4Une/Z767iKPljoFb/YuCo=;
        b=1BzcJb5UXd9c4r6mNPmIM30L+gZYQxNQR0/b8PAyf1hjroGleHqyfcIg/GcGhtqzO3JuRw
        iC6/myoxUzA7UUKI3oSXwesluhzC+hRLlB69BBrpMbPLlVhuY25AzQe1BT9YbsYyulIsgk
        TMhI215XiZdwxT111e/mfm68LHqWS5XDSd1leoJLXm/PhzZpPn65TrInWZDEfF+VOydiGi
        +KCmnea6qh1WEL/amO/GMRqBxcZeOqBX73KvYil15o1L0x2KPpLgVDYBOmXZV1YBBzf6tC
        QblCTyNdPThEpNzzNwgB0SZV6QPPaqh37vMS2eikcEAOz+IIHn3Myu+7+3Uwew==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595260604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4/ywCu1ddv/vjOuhHxWVQ4Une/Z767iKPljoFb/YuCo=;
        b=TZmK83GNtq3Vst9FIUeDTWJH2SozMZJcueFXszjMIJRTjrivYQVEcdDuytGUGcwEWTzQqT
        LXEKHCzqIguBjgBg==
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH v4 15/24] netfilter: nft_set_rbtree: Use sequence counter with associated rwlock
Date:   Mon, 20 Jul 2020 17:55:21 +0200
Message-Id: <20200720155530.1173732-16-a.darwish@linutronix.de>
In-Reply-To: <20200720155530.1173732-1-a.darwish@linutronix.de>
References: <20200519214547.352050-1-a.darwish@linutronix.de>
 <20200720155530.1173732-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A sequence counter write side critical section must be protected by some
form of locking to serialize writers. A plain seqcount_t does not
contain the information of which lock must be held when entering a write
side critical section.

Use the new seqcount_rwlock_t data type, which allows to associate a
rwlock with the sequence counter. This enables lockdep to verify that
the rwlock used for writer serialization is held when the write side
critical section is entered.

If lockdep is disabled this lock association is compiled out and has
neither storage size nor runtime overhead.

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
---
 net/netfilter/nft_set_rbtree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index b6aad3fc46c3..4b2834fd17b2 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -18,7 +18,7 @@
 struct nft_rbtree {
 	struct rb_root		root;
 	rwlock_t		lock;
-	seqcount_t		count;
+	seqcount_rwlock_t	count;
 	struct delayed_work	gc_work;
 };
 
@@ -523,7 +523,7 @@ static int nft_rbtree_init(const struct nft_set *set,
 	struct nft_rbtree *priv = nft_set_priv(set);
 
 	rwlock_init(&priv->lock);
-	seqcount_init(&priv->count);
+	seqcount_rwlock_init(&priv->count, &priv->lock);
 	priv->root = RB_ROOT;
 
 	INIT_DEFERRABLE_WORK(&priv->gc_work, nft_rbtree_gc);
-- 
2.20.1

