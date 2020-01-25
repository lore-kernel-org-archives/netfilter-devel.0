Return-Path: <SRS0=x4bV=3O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5319C2D0DB
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Jan 2020 17:34:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFA4D2070A
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Jan 2020 17:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgAYReZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 25 Jan 2020 12:34:25 -0500
Received: from correo.us.es ([193.147.175.20]:35450 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbgAYReZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Jan 2020 12:34:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 52B6E12C1E6
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Jan 2020 18:34:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 44292DA712
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Jan 2020 18:34:23 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 39CF6DA705; Sat, 25 Jan 2020 18:34:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 18156DA705;
        Sat, 25 Jan 2020 18:34:21 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 25 Jan 2020 18:34:21 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E19C942EE38E;
        Sat, 25 Jan 2020 18:34:20 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 1/7] netfilter: nft_osf: add missing check for DREG attribute
Date:   Sat, 25 Jan 2020 18:34:09 +0100
Message-Id: <20200125173415.191571-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200125173415.191571-1-pablo@netfilter.org>
References: <20200125173415.191571-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

syzbot reports just another NULL deref crash because of missing test
for presence of the attribute.

Reported-by: syzbot+cf23983d697c26c34f60@syzkaller.appspotmail.com
Fixes:  b96af92d6eaf9fadd ("netfilter: nf_tables: implement Passive OS fingerprint module in nft_osf")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_osf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index f54d6ae15bb1..b42247aa48a9 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -61,6 +61,9 @@ static int nft_osf_init(const struct nft_ctx *ctx,
 	int err;
 	u8 ttl;
 
+	if (!tb[NFTA_OSF_DREG])
+		return -EINVAL;
+
 	if (tb[NFTA_OSF_TTL]) {
 		ttl = nla_get_u8(tb[NFTA_OSF_TTL]);
 		if (ttl > 2)
-- 
2.11.0

