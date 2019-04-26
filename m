Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC1BFC43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 00:34:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F685206C1
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 00:34:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730231AbfDZAeZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 20:34:25 -0400
Received: from mail.us.es ([193.147.175.20]:55228 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729798AbfDZAeC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 20:34:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 26808B4996
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 02:34:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1758CDA710
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 02:34:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 056D7DA70A; Fri, 26 Apr 2019 02:34:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 08F96DA704;
        Fri, 26 Apr 2019 02:33:58 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 26 Apr 2019 02:33:58 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A56414265A31;
        Fri, 26 Apr 2019 02:33:57 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@mellanox.com,
        john.hurley@netronome.com, jakub.kicinski@netronome.com,
        ogerlitz@mellanox.com
Subject: [PATCH net-next,RFC 3/9] net: sched: add tcf_block_cb_free()
Date:   Fri, 26 Apr 2019 02:33:40 +0200
Message-Id: <20190426003348.30745-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190426003348.30745-1-pablo@netfilter.org>
References: <20190426003348.30745-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Just a stub to release tcf_block_cb objects, follow up patch extends it
to have a release callback in it for the private data.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/pkt_cls.h | 1 +
 net/sched/cls_api.c   | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 8ddfbe94e253..565775289b41 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -73,6 +73,7 @@ static inline struct Qdisc *tcf_block_q(struct tcf_block *block)
 
 struct tcf_block_cb *tcf_block_cb_alloc(tc_setup_cb_t *cb,
 					void *cb_ident, void *cb_priv);
+void tcf_block_cb_free(struct tcf_block_cb *block_cb);
 void *tcf_block_cb_priv(struct tcf_block_cb *block_cb);
 struct tcf_block_cb *tcf_block_cb_lookup(struct tcf_block *block,
 					 tc_setup_cb_t *cb, void *cb_ident);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index ddfccf31aac9..9f61a2c3cf6f 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -766,6 +766,12 @@ struct tcf_block_cb *tcf_block_cb_alloc(tc_setup_cb_t *cb,
 }
 EXPORT_SYMBOL(tcf_block_cb_alloc);
 
+void tcf_block_cb_free(struct tcf_block_cb *block_cb)
+{
+	kfree(block_cb);
+}
+EXPORT_SYMBOL(tcf_block_cb_free);
+
 struct tcf_block_cb *__tcf_block_cb_register(struct tcf_block *block,
 					     tc_setup_cb_t *cb, void *cb_ident,
 					     void *cb_priv,
-- 
2.11.0

