Return-Path: <SRS0=WPBU=CJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ACD2C433E7
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Aug 2020 09:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 357AD2068F
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Aug 2020 09:37:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgHaJhE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 Aug 2020 05:37:04 -0400
Received: from correo.us.es ([193.147.175.20]:40348 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgHaJg5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Aug 2020 05:36:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id ED88015AEA0
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2020 11:36:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DA792DA798
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2020 11:36:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CFD9CDA793; Mon, 31 Aug 2020 11:36:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 76886DA789;
        Mon, 31 Aug 2020 11:36:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 31 Aug 2020 11:36:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 4CFC542EF4E1;
        Mon, 31 Aug 2020 11:36:53 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 1/8] netfilter: delete repeated words
Date:   Mon, 31 Aug 2020 11:36:41 +0200
Message-Id: <20200831093648.20765-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200831093648.20765-1-pablo@netfilter.org>
References: <20200831093648.20765-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Drop duplicated words in net/netfilter/ and net/ipv4/netfilter/.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_nat_pptp.c       | 2 +-
 net/netfilter/nf_conntrack_pptp.c      | 2 +-
 net/netfilter/nf_conntrack_proto_tcp.c | 2 +-
 net/netfilter/xt_recent.c              | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
index 7afde8828b4c..3f248a19faa3 100644
--- a/net/ipv4/netfilter/nf_nat_pptp.c
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -3,7 +3,7 @@
  * nf_nat_pptp.c
  *
  * NAT support for PPTP (Point to Point Tunneling Protocol).
- * PPTP is a a protocol for creating virtual private networks.
+ * PPTP is a protocol for creating virtual private networks.
  * It is a specification defined by Microsoft and some vendors
  * working with Microsoft.  PPTP is built on top of a modified
  * version of the Internet Generic Routing Encapsulation Protocol.
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 1f44d523b512..5105d4250012 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * Connection tracking support for PPTP (Point to Point Tunneling Protocol).
- * PPTP is a a protocol for creating virtual private networks.
+ * PPTP is a protocol for creating virtual private networks.
  * It is a specification defined by Microsoft and some vendors
  * working with Microsoft.  PPTP is built on top of a modified
  * version of the Internet Generic Routing Encapsulation Protocol.
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 6892e497781c..e8c86ee4c1c4 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1152,7 +1152,7 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 		   && (old_state == TCP_CONNTRACK_SYN_RECV
 		       || old_state == TCP_CONNTRACK_ESTABLISHED)
 		   && new_state == TCP_CONNTRACK_ESTABLISHED) {
-		/* Set ASSURED if we see see valid ack in ESTABLISHED
+		/* Set ASSURED if we see valid ack in ESTABLISHED
 		   after SYN_RECV or a valid answer for a picked up
 		   connection. */
 		set_bit(IPS_ASSURED_BIT, &ct->status);
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 19bef176145e..606411869698 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -640,7 +640,7 @@ static void __net_exit recent_proc_net_exit(struct net *net)
 	struct recent_table *t;
 
 	/* recent_net_exit() is called before recent_mt_destroy(). Make sure
-	 * that the parent xt_recent proc entry is is empty before trying to
+	 * that the parent xt_recent proc entry is empty before trying to
 	 * remove it.
 	 */
 	spin_lock_bh(&recent_lock);
-- 
2.20.1

