Return-Path: <SRS0=CFkq=5P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78557C2D0ED
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Mar 2020 19:22:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54DDE2072E
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Mar 2020 19:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbgC3TWp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Mar 2020 15:22:45 -0400
Received: from correo.us.es ([193.147.175.20]:48508 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728385AbgC3TWE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Mar 2020 15:22:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 294EFB498F
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2020 21:21:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 03F96FF6FC
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2020 21:21:57 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BD2D512397E; Mon, 30 Mar 2020 21:21:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4BB14FA4F4;
        Mon, 30 Mar 2020 21:21:42 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Mar 2020 21:21:42 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1756142EF4E0;
        Mon, 30 Mar 2020 21:21:42 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 08/28] netfilter: conntrack: Add missing annotations for nf_conntrack_all_lock() and nf_conntrack_all_unlock()
Date:   Mon, 30 Mar 2020 21:21:16 +0200
Message-Id: <20200330192136.230459-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200330192136.230459-1-pablo@netfilter.org>
References: <20200330192136.230459-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jules Irenge <jbi.octave@gmail.com>

Sparse reports warnings at nf_conntrack_all_lock()
	and nf_conntrack_all_unlock()

warning: context imbalance in nf_conntrack_all_lock()
	- wrong count at exit
warning: context imbalance in nf_conntrack_all_unlock()
	- unexpected unlock

Add the missing __acquires(&nf_conntrack_locks_all_lock)
Add missing __releases(&nf_conntrack_locks_all_lock)

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index a18f8fe728e3..f82d4a802acc 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -143,6 +143,7 @@ static bool nf_conntrack_double_lock(struct net *net, unsigned int h1,
 }
 
 static void nf_conntrack_all_lock(void)
+	__acquires(&nf_conntrack_locks_all_lock)
 {
 	int i;
 
@@ -162,6 +163,7 @@ static void nf_conntrack_all_lock(void)
 }
 
 static void nf_conntrack_all_unlock(void)
+	__releases(&nf_conntrack_locks_all_lock)
 {
 	/* All prior stores must be complete before we clear
 	 * 'nf_conntrack_locks_all'. Otherwise nf_conntrack_lock()
-- 
2.11.0

