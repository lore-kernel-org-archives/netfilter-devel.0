Return-Path: <SRS0=FJFf=5X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C4EC2BA80
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Apr 2020 15:37:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E7A82075E
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Apr 2020 15:37:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729441AbgDGPhA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Apr 2020 11:37:00 -0400
Received: from correo.us.es ([193.147.175.20]:58352 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729426AbgDGPhA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Apr 2020 11:37:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 711D5E862B
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Apr 2020 17:36:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 633C6DA736
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Apr 2020 17:36:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 58F0D100A42; Tue,  7 Apr 2020 17:36:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 75B8E100A45
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Apr 2020 17:36:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 07 Apr 2020 17:36:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 58FC442EF42A
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Apr 2020 17:36:56 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf 1/2] netfilter: nf_tables: report EOPNOTSUPP on unsupported flags/object type
Date:   Tue,  7 Apr 2020 17:36:52 +0200
Message-Id: <20200407153653.137377-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

EINVAL should be used for malformed netlink messages. New userspace and
old kernels might easily result in EINVAL when exercising new set
features, which is misleading.

Fixes: 8aeff920dcc9 ("netfilter: nf_tables: add stateful object reference to set elements")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f91e96d8de05..21cbde6ecee3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3963,7 +3963,7 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 			      NFT_SET_INTERVAL | NFT_SET_TIMEOUT |
 			      NFT_SET_MAP | NFT_SET_EVAL |
 			      NFT_SET_OBJECT))
-			return -EINVAL;
+			return -EOPNOTSUPP;
 		/* Only one of these operations is supported */
 		if ((flags & (NFT_SET_MAP | NFT_SET_OBJECT)) ==
 			     (NFT_SET_MAP | NFT_SET_OBJECT))
@@ -4001,7 +4001,7 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 		objtype = ntohl(nla_get_be32(nla[NFTA_SET_OBJ_TYPE]));
 		if (objtype == NFT_OBJECT_UNSPEC ||
 		    objtype > NFT_OBJECT_MAX)
-			return -EINVAL;
+			return -EOPNOTSUPP;
 	} else if (flags & NFT_SET_OBJECT)
 		return -EINVAL;
 	else
-- 
2.11.0

