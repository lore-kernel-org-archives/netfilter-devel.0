Return-Path: <SRS0=4AXv=6N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E242C8300A
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Apr 2020 21:48:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1590520757
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Apr 2020 21:48:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgD2VsX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Apr 2020 17:48:23 -0400
Received: from correo.us.es ([193.147.175.20]:60676 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726961AbgD2VsX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Apr 2020 17:48:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5EE8112BFF8
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 23:48:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4DD91BAAA1
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 23:48:22 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 430FFBAAA3; Wed, 29 Apr 2020 23:48:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 49069BAAB1;
        Wed, 29 Apr 2020 23:48:20 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 Apr 2020 23:48:20 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2771142EF9E0;
        Wed, 29 Apr 2020 23:48:20 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 2/2] netfilter: nf_osf: avoid passing pointer to local var
Date:   Wed, 29 Apr 2020 23:48:11 +0200
Message-Id: <20200429214811.19941-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200429214811.19941-1-pablo@netfilter.org>
References: <20200429214811.19941-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

gcc-10 points out that a code path exists where a pointer to a stack
variable may be passed back to the caller:

net/netfilter/nfnetlink_osf.c: In function 'nf_osf_hdr_ctx_init':
cc1: warning: function may return address of local variable [-Wreturn-local-addr]
net/netfilter/nfnetlink_osf.c:171:16: note: declared here
  171 |  struct tcphdr _tcph;
      |                ^~~~~

I am not sure whether this can happen in practice, but moving the
variable declaration into the callers avoids the problem.

Fixes: 31a9c29210e2 ("netfilter: nf_osf: add struct nf_osf_hdr_ctx")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_osf.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 9f5dea0064ea..916a3c7f9eaf 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -165,12 +165,12 @@ static bool nf_osf_match_one(const struct sk_buff *skb,
 static const struct tcphdr *nf_osf_hdr_ctx_init(struct nf_osf_hdr_ctx *ctx,
 						const struct sk_buff *skb,
 						const struct iphdr *ip,
-						unsigned char *opts)
+						unsigned char *opts,
+						struct tcphdr *_tcph)
 {
 	const struct tcphdr *tcp;
-	struct tcphdr _tcph;
 
-	tcp = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(struct tcphdr), &_tcph);
+	tcp = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(struct tcphdr), _tcph);
 	if (!tcp)
 		return NULL;
 
@@ -205,10 +205,11 @@ nf_osf_match(const struct sk_buff *skb, u_int8_t family,
 	int fmatch = FMATCH_WRONG;
 	struct nf_osf_hdr_ctx ctx;
 	const struct tcphdr *tcp;
+	struct tcphdr _tcph;
 
 	memset(&ctx, 0, sizeof(ctx));
 
-	tcp = nf_osf_hdr_ctx_init(&ctx, skb, ip, opts);
+	tcp = nf_osf_hdr_ctx_init(&ctx, skb, ip, opts, &_tcph);
 	if (!tcp)
 		return false;
 
@@ -265,10 +266,11 @@ bool nf_osf_find(const struct sk_buff *skb,
 	const struct nf_osf_finger *kf;
 	struct nf_osf_hdr_ctx ctx;
 	const struct tcphdr *tcp;
+	struct tcphdr _tcph;
 
 	memset(&ctx, 0, sizeof(ctx));
 
-	tcp = nf_osf_hdr_ctx_init(&ctx, skb, ip, opts);
+	tcp = nf_osf_hdr_ctx_init(&ctx, skb, ip, opts, &_tcph);
 	if (!tcp)
 		return false;
 
-- 
2.20.1

