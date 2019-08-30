Return-Path: <SRS0=JGmF=W2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98B48C3A5A4
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Aug 2019 12:07:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E95821897
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Aug 2019 12:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbfH3MHR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Aug 2019 08:07:17 -0400
Received: from correo.us.es ([193.147.175.20]:36294 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728120AbfH3MHP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Aug 2019 08:07:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 91A1ED2CBF
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Aug 2019 14:07:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 81A16DA801
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Aug 2019 14:07:11 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 80B2DB8019; Fri, 30 Aug 2019 14:07:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5461DFF6EB;
        Fri, 30 Aug 2019 14:07:09 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 30 Aug 2019 14:07:09 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2792A4251481;
        Fri, 30 Aug 2019 14:07:09 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 2/5] netfilter: nf_conntrack_ftp: Fix debug output
Date:   Fri, 30 Aug 2019 14:07:01 +0200
Message-Id: <20190830120704.6147-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190830120704.6147-1-pablo@netfilter.org>
References: <20190830120704.6147-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Thomas Jarosch <thomas.jarosch@intra2net.com>

The find_pattern() debug output was printing the 'skip' character.
This can be a NULL-byte and messes up further pr_debug() output.

Output without the fix:
kernel: nf_conntrack_ftp: Pattern matches!
kernel: nf_conntrack_ftp: Skipped up to `<7>nf_conntrack_ftp: find_pattern `PORT': dlen = 8
kernel: nf_conntrack_ftp: find_pattern `EPRT': dlen = 8

Output with the fix:
kernel: nf_conntrack_ftp: Pattern matches!
kernel: nf_conntrack_ftp: Skipped up to 0x0 delimiter!
kernel: nf_conntrack_ftp: Match succeeded!
kernel: nf_conntrack_ftp: conntrack_ftp: match `172,17,0,100,200,207' (20 bytes at 4150681645)
kernel: nf_conntrack_ftp: find_pattern `PORT': dlen = 8

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_ftp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 0ecb3e289ef2..8d96738b7dfd 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -322,7 +322,7 @@ static int find_pattern(const char *data, size_t dlen,
 		i++;
 	}
 
-	pr_debug("Skipped up to `%c'!\n", skip);
+	pr_debug("Skipped up to 0x%hhx delimiter!\n", skip);
 
 	*numoff = i;
 	*numlen = getnum(data + i, dlen - i, cmd, term, numoff);
-- 
2.11.0

