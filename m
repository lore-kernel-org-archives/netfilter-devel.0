Return-Path: <SRS0=22nV=3F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECE29C33CB6
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 21:11:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C066E20728
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 21:11:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388558AbgAPVLR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jan 2020 16:11:17 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:42270 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726527AbgAPVLQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jan 2020 16:11:16 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1isCQ6-0002vB-4A; Thu, 16 Jan 2020 22:11:14 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     <netdev@vger.kernel.org>, syzkaller-bugs@googlegroups.com,
        Florian Westphal <fw@strlen.de>,
        syzbot+156a04714799b1d480bc@syzkaller.appspotmail.com
Subject: [PATCH nf] netfilter: nf_tables: check for valid chain type pointer before dereference
Date:   Thu, 16 Jan 2020 22:11:09 +0100
Message-Id: <20200116211109.9119-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <00000000000074ed27059c33dedc@google.com>
References: <00000000000074ed27059c33dedc@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Its possible to create tables in a family that isn't supported/known.
Then, when adding a base chain, the table pointer can be NULL.

This gets us a NULL ptr dereference in nf_tables_addchain().

Fixes: baae3e62f31618 ("netfilter: nf_tables: fix chain type module reference handling")
Reported-by: syzbot+156a04714799b1d480bc@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 65f51a2e9c2a..e8976128cdb1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -953,6 +953,9 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 	struct nft_ctx ctx;
 	int err;
 
+	if (family >= NFPROTO_NUMPROTO)
+		return -EAFNOSUPPORT;
+
 	lockdep_assert_held(&net->nft.commit_mutex);
 	attr = nla[NFTA_TABLE_NAME];
 	table = nft_table_lookup(net, attr, family, genmask);
@@ -1765,6 +1768,9 @@ static int nft_chain_parse_hook(struct net *net,
 	    ha[NFTA_HOOK_PRIORITY] == NULL)
 		return -EINVAL;
 
+	if (family >= NFPROTO_NUMPROTO)
+		return -EAFNOSUPPORT;
+
 	hook->num = ntohl(nla_get_be32(ha[NFTA_HOOK_HOOKNUM]));
 	hook->priority = ntohl(nla_get_be32(ha[NFTA_HOOK_PRIORITY]));
 
@@ -1774,6 +1780,8 @@ static int nft_chain_parse_hook(struct net *net,
 						   family, autoload);
 		if (IS_ERR(type))
 			return PTR_ERR(type);
+	} else if (!type) {
+		return -EOPNOTSUPP;
 	}
 	if (hook->num > NF_MAX_HOOKS || !(type->hook_mask & (1 << hook->num)))
 		return -EOPNOTSUPP;
-- 
2.24.1

