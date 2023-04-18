Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD2EC77B75
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Apr 2023 21:40:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbjDRVka (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Apr 2023 17:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjDRVk3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Apr 2023 17:40:29 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1C24A619E
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Apr 2023 14:40:28 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, stgraber@stgraber.org
Subject: [PATCH nf] netfilter: conntrack: restore IPS_CONFIRMED out of nf_conntrack_hash_check_insert()
Date:   Tue, 18 Apr 2023 23:40:24 +0200
Message-Id: <20230418214024.14653-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

e6d57e9ff0ae ("netfilter: conntrack: fix rmmod double-free race")
consolidates IPS_CONFIRMED bit set in nf_conntrack_hash_check_insert().
However, this breaks ctnetlink:

 # conntrack -I -p tcp --timeout 123 --src 1.2.3.4 --dst 5.6.7.8 --state ESTABLISHED --sport 1 --dport 4 -u SEEN_REPLY
 conntrack v1.4.6 (conntrack-tools): Operation failed: Device or resource busy

This is a partial revert of the aforementioned commit.

Fixes: e6d57e9ff0ae ("netfilter: conntrack: fix rmmod double-free race")
Reported-by: Stéphane Graber <stgraber@stgraber.org>
Tested-by: Stéphane Graber <stgraber@stgraber.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_bpf.c     | 1 +
 net/netfilter/nf_conntrack_core.c    | 1 -
 net/netfilter/nf_conntrack_netlink.c | 3 +++
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index cd99e6dc1f35..34913521c385 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -381,6 +381,7 @@ __bpf_kfunc struct nf_conn *bpf_ct_insert_entry(struct nf_conn___init *nfct_i)
 	struct nf_conn *nfct = (struct nf_conn *)nfct_i;
 	int err;
 
+	nfct->status |= IPS_CONFIRMED;
 	err = nf_conntrack_hash_check_insert(nfct);
 	if (err < 0) {
 		nf_conntrack_free(nfct);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index c6a6a6099b4e..7ba6ab9b54b5 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -932,7 +932,6 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 		goto out;
 	}
 
-	ct->status |= IPS_CONFIRMED;
 	smp_wmb();
 	/* The caller holds a reference to this object */
 	refcount_set(&ct->ct_general.use, 2);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index bfc3aaa2c872..d3ee18854698 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2316,6 +2316,9 @@ ctnetlink_create_conntrack(struct net *net,
 	nfct_seqadj_ext_add(ct);
 	nfct_synproxy_ext_add(ct);
 
+	/* we must add conntrack extensions before confirmation. */
+	ct->status |= IPS_CONFIRMED;
+
 	if (cda[CTA_STATUS]) {
 		err = ctnetlink_change_status(ct, cda);
 		if (err < 0)
-- 
2.30.2

