Return-Path: <SRS0=+tY6=XU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A904C432C2
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 20:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37F2221D7A
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 20:30:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393125AbfIYUa0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Sep 2019 16:30:26 -0400
Received: from correo.us.es ([193.147.175.20]:44670 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393073AbfIYUaY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Sep 2019 16:30:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5EC1CC516C
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2019 22:30:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4E426D2B1E
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2019 22:30:18 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4720EDA7B6; Wed, 25 Sep 2019 22:30:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 096ECA7DAD;
        Wed, 25 Sep 2019 22:30:15 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 25 Sep 2019 22:30:15 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D28B14265A5A;
        Wed, 25 Sep 2019 22:30:14 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 3/5] netfilter: nf_tables: allow lookups in dynamic sets
Date:   Wed, 25 Sep 2019 22:30:01 +0200
Message-Id: <20190925203003.20112-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190925203003.20112-1-pablo@netfilter.org>
References: <20190925203003.20112-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This un-breaks lookups in sets that have the 'dynamic' flag set.
Given this active example configuration:

table filter {
  set set1 {
    type ipv4_addr
    size 64
    flags dynamic,timeout
    timeout 1m
  }

  chain input {
     type filter hook input priority 0; policy accept;
  }
}

... this works:
nft add rule ip filter input add @set1 { ip saddr }

-> whenever rule is triggered, the source ip address is inserted
into the set (if it did not exist).

This won't work:
nft add rule ip filter input ip saddr @set1 counter
Error: Could not process rule: Operation not supported

In other words, we can add entries to the set, but then can't make
matching decision based on that set.

That is just wrong -- all set backends support lookups (else they would
not be very useful).
The failure comes from an explicit rejection in nft_lookup.c.

Looking at the history, it seems like NFT_SET_EVAL used to mean
'set contains expressions' (aka. "is a meter"), for instance something like

 nft add rule ip filter input meter example { ip saddr limit rate 10/second }
 or
 nft add rule ip filter input meter example { ip saddr counter }

The actual meaning of NFT_SET_EVAL however, is
'set can be updated from the packet path'.

'meters' and packet-path insertions into sets, such as
'add @set { ip saddr }' use exactly the same kernel code (nft_dynset.c)
and thus require a set backend that provides the ->update() function.

The only set that provides this also is the only one that has the
NFT_SET_EVAL feature flag.

Removing the wrong check makes the above example work.
While at it, also fix the flag check during set instantiation to
allow supported combinations only.

Fixes: 8aeff920dcc9b3f ("netfilter: nf_tables: add stateful object reference to set elements")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 7 +++++--
 net/netfilter/nft_lookup.c    | 3 ---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4a5d6ef2b706..6dc46f9b5f7b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3562,8 +3562,11 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 			      NFT_SET_OBJECT))
 			return -EINVAL;
 		/* Only one of these operations is supported */
-		if ((flags & (NFT_SET_MAP | NFT_SET_EVAL | NFT_SET_OBJECT)) ==
-			     (NFT_SET_MAP | NFT_SET_EVAL | NFT_SET_OBJECT))
+		if ((flags & (NFT_SET_MAP | NFT_SET_OBJECT)) ==
+			     (NFT_SET_MAP | NFT_SET_OBJECT))
+			return -EOPNOTSUPP;
+		if ((flags & (NFT_SET_EVAL | NFT_SET_OBJECT)) ==
+			     (NFT_SET_EVAL | NFT_SET_OBJECT))
 			return -EOPNOTSUPP;
 	}
 
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index c0560bf3c31b..660bad688e2b 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -73,9 +73,6 @@ static int nft_lookup_init(const struct nft_ctx *ctx,
 	if (IS_ERR(set))
 		return PTR_ERR(set);
 
-	if (set->flags & NFT_SET_EVAL)
-		return -EOPNOTSUPP;
-
 	priv->sreg = nft_parse_register(tb[NFTA_LOOKUP_SREG]);
 	err = nft_validate_register_load(priv->sreg, set->klen);
 	if (err < 0)
-- 
2.11.0

