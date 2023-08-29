Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2A31C71153
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 17:47:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbjH2Rqh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 13:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238195AbjH2RqV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 13:46:21 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2801113
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 10:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CywtvBioyazFSAdgseLP9KD2+k7cu9QewDv8vSPFUNI=; b=dBtV+Gpak93ZmN05SBnTBmBBho
        kOhCLcb2yoqh+mDsYS/wknGH5K/fREbgXs1dNOZR2tk0gbAjCWFKeVdwyW2VQ9Cj3rV63NsJp1DZW
        S3IrHc7eFHGQmfMbusINgHLcnMOSjffzFH4KKoZbAFDpvCmwCZzevG8rAz6QcQCa2xu1eCGLot9h3
        t0CH/yp4tVYB4B1iXDmPQhV+LuoAH+xuFm8nhEax9Mc4MG4/eNsKR2PfJDbKbCOVnEYSuSt75I+cJ
        ywT+IcR0cwNggnuWW+nxUZLd+6VPIEuNfjCnZdnBi6bNI7iRwrVHQLsWMdGLLW2jFWDqi1Br158WH
        EZgQwuDw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qb2n3-000467-IQ; Tue, 29 Aug 2023 19:46:09 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, linux-audit@redhat.com,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [nf PATCH 2/2] netfilter: nf_tables: Audit log rule reset
Date:   Tue, 29 Aug 2023 19:51:58 +0200
Message-ID: <20230829175158.20202-2-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230829175158.20202-1-phil@nwl.cc>
References: <20230829175158.20202-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Resetting rules' stateful data happens outside of the transaction logic,
so 'get' and 'dump' handlers have to emit audit log entries themselves.

Cc: Richard Guy Briggs <rgb@redhat.com>
Fixes: 8daa8fde3fc3f ("netfilter: nf_tables: Introduce NFT_MSG_GETRULE_RESET")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/linux/audit.h         |  1 +
 kernel/auditsc.c              |  1 +
 net/netfilter/nf_tables_api.c | 18 ++++++++++++++++++
 3 files changed, 20 insertions(+)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 192bf03aacc52..51b1b7054a233 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -118,6 +118,7 @@ enum audit_nfcfgop {
 	AUDIT_NFT_OP_FLOWTABLE_REGISTER,
 	AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,
 	AUDIT_NFT_OP_SETELEM_RESET,
+	AUDIT_NFT_OP_RULE_RESET,
 	AUDIT_NFT_OP_INVALID,
 };
 
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 38481e3181975..fc0c7c03eeabe 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -144,6 +144,7 @@ static const struct audit_nfcfgop_tab audit_nfcfgs[] = {
 	{ AUDIT_NFT_OP_FLOWTABLE_REGISTER,	"nft_register_flowtable"   },
 	{ AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,	"nft_unregister_flowtable" },
 	{ AUDIT_NFT_OP_SETELEM_RESET,		"nft_reset_setelem"        },
+	{ AUDIT_NFT_OP_RULE_RESET,		"nft_reset_rule"           },
 	{ AUDIT_NFT_OP_INVALID,			"nft_invalid"		   },
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a1218ea4e0c3d..2aa7b9a55cca4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3432,6 +3432,18 @@ static void nf_tables_rule_notify(const struct nft_ctx *ctx,
 	nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES, -ENOBUFS);
 }
 
+static void audit_log_rule_reset(const struct nft_table *table,
+				 unsigned int base_seq,
+				 unsigned int nentries)
+{
+	char *buf = kasprintf(GFP_ATOMIC, "%s:%u",
+			      table->name, base_seq);
+
+	audit_log_nfcfg(buf, table->family, nentries,
+			AUDIT_NFT_OP_RULE_RESET, GFP_ATOMIC);
+	kfree(buf);
+}
+
 struct nft_rule_dump_ctx {
 	char *table;
 	char *chain;
@@ -3538,6 +3550,9 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 done:
 	rcu_read_unlock();
 
+	if (reset && idx > cb->args[0])
+		audit_log_rule_reset(table, cb->seq, idx - cb->args[0]);
+
 	cb->args[0] = idx;
 	return skb->len;
 }
@@ -3645,6 +3660,9 @@ static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
 	if (err < 0)
 		goto err_fill_rule_info;
 
+	if (reset)
+		audit_log_rule_reset(table, nft_pernet(net)->base_seq, 1);
+
 	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
 
 err_fill_rule_info:
-- 
2.41.0

