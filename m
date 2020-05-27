Return-Path: <SRS0=LpWG=7J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E841EC433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 May 2020 10:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA287207CB
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 May 2020 10:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728770AbgE0KVb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 May 2020 06:21:31 -0400
Received: from correo.us.es ([193.147.175.20]:51664 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbgE0KV3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 May 2020 06:21:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 91775197D0A
        for <netfilter-devel@vger.kernel.org>; Wed, 27 May 2020 12:21:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 848B81B3558
        for <netfilter-devel@vger.kernel.org>; Wed, 27 May 2020 12:21:27 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 799F21B3555; Wed, 27 May 2020 12:21:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 758CE6DC6A;
        Wed, 27 May 2020 12:21:05 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 27 May 2020 12:21:05 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4E4F842EE38E;
        Wed, 27 May 2020 12:21:05 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     colin.king@canonical.com
Subject: [PATCH nf,v2] netfilter: nf_conntrack: comparison of unsigned in cthelper confirmation
Date:   Wed, 27 May 2020 12:21:03 +0200
Message-Id: <20200527102103.2114-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

net/netfilter/nf_conntrack_core.c: In function nf_confirm_cthelper:
net/netfilter/nf_conntrack_core.c:2117:15: warning: comparison of unsigned expression in < 0 is always false [-Wtype-limits]
 2117 |   if (protoff < 0 || (frag_off & htons(~0x7)) != 0)
      |               ^

ipv6_skip_exthdr() returns a signed integer.

Reported-by: Colin Ian King <colin.king@canonical.com>
Fixes: 703acd70f249 ("netfilter: nfnetlink_cthelper: unbreak userspace helper support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: incorrect patch subject.

 net/netfilter/nf_conntrack_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index e3b054a2f796..bb72ca5f3999 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2092,7 +2092,7 @@ static int nf_confirm_cthelper(struct sk_buff *skb, struct nf_conn *ct,
 {
 	const struct nf_conntrack_helper *helper;
 	const struct nf_conn_help *help;
-	unsigned int protoff;
+	int protoff;
 
 	help = nfct_help(ct);
 	if (!help)
-- 
2.20.1

