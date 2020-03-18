Return-Path: <SRS0=WbMd=5D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4703FC10DCE
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 18:55:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A97820724
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 18:55:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgCRSzF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Mar 2020 14:55:05 -0400
Received: from correo.us.es ([193.147.175.20]:50856 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbgCRSzF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Mar 2020 14:55:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 37679E34CB
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2020 19:54:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 27D2FDA38F
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2020 19:54:34 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1D772DA38D; Wed, 18 Mar 2020 19:54:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2D518DA7B2
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2020 19:54:32 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 18 Mar 2020 19:54:32 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 17E6F4251480
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2020 19:54:32 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: add range specified flag setting (missing NF_NAT_RANGE_PROTO_SPECIFIED)
Date:   Wed, 18 Mar 2020 19:54:59 +0100
Message-Id: <20200318185459.66678-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sergey reports:

With nf_tables it is not possible to use port range for masquerading.
Masquerade statement has option "to [:port-port]" which give no effect
to translation behavior. But it must change source port of packet to
one from ":port-port" range.

My network:

        +-----------------------------+
        |   ROUTER                    |
        |                             |
        |                   Masquerade|
        | 10.0.0.1            1.1.1.1 |
        | +------+           +------+ |
        | | eth1 |           | eth2 | |
        +-+--^---+-----------+---^--+-+
             |                   |
             |                   |
        +----v------+     +------v----+
        |           |     |           |
        | 10.0.0.2  |     |  1.1.1.2  |
        |           |     |           |
        |PC1        |     |PC2        |
        +-----------+     +-----------+

For testing i used rule like this:

        rule ip nat POSTROUTING oifname eth2 masquerade to :666

Run netcat for 1.1.1.2 667(UDP) and get dump from PC2:

        15:22:25.591567 a8:f9:4b:aa:08:44 > a8:f9:4b:ac:e7:8f, ethertype IPv4 (0x0800), length 60: 1.1.1.1.34466 > 1.1.1.2.667: UDP, length 1

Address translation works fine, but source port are not belongs to
specified range.

I see in similar source code (i.e. nft_redir.c, nft_nat.c) that
there is setting NF_NAT_RANGE_PROTO_SPECIFIED flag. After adding this,
repeat test for kernel with this patch, and get dump:

        16:16:22.324710 a8:f9:4b:aa:08:44 > a8:f9:4b:ac:e7:8f, ethertype IPv4 (0x0800), length 60: 1.1.1.1.666 > 1.1.1.2.667: UDP, length 1

Now it is works fine.

Reported-by: Sergey Marinkevich <s@marinkevich.ru>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Sergey, could you try this userspace patch instead? Thanks.

 src/evaluate.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 4a23b231c74d..d0e712dc02f0 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -18,6 +18,7 @@
 #include <linux/netfilter_arp.h>
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter/nf_synproxy.h>
+#include <linux/netfilter/nf_nat.h>
 #include <linux/netfilter_ipv4.h>
 #include <netinet/ip_icmp.h>
 #include <netinet/icmp6.h>
@@ -2950,6 +2951,8 @@ static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
 		err = nat_evaluate_transport(ctx, stmt, &stmt->nat.proto);
 		if (err < 0)
 			return err;
+
+		stmt->nat.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
 	}
 
 	stmt->flags |= STMT_F_TERMINAL;
-- 
2.11.0

