Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5FBEC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Feb 2022 17:00:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376648AbiBDRA0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Feb 2022 12:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376704AbiBDRAZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Feb 2022 12:00:25 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8378DC06173E
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Feb 2022 09:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rYAhaes7m7qrwOIMpIf8kdxO9uEeIT+SldhskDed+10=; b=RPolL+1DdCVtM0BajqUl9k8wlC
        SpsTkWRDy110WOqBKzegpZyunaY5Nidl+NYyjDnynz3W/HOvuJ0snx4t4DAql8nbqb/GIV+k29yAb
        BknqP0/0rgjazV/CYtX1P+YhODpBC2Y0hhq9MQQVZruPOkKJfAkU+bAhhxaWdYG3N60r+5fvT+jwp
        vHkx4Qhmzl/DcHHjDd0dqAxHzOORn+xFvv93m6JBV+B0Oh9lBSvmEWtyMnIEPIpnhgiaCXtLnfW3N
        KSDLw6Kyc3Xn70c0sqgHV8MteIOcl9CoGy7Dtu5Pdy/SA3ybvtBfPseePDVJP5R/zN60tWoxd7pM4
        WYmjsDKA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nG1wd-0004AJ-SQ; Fri, 04 Feb 2022 18:00:23 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/4] nft: Add debug output to table creation
Date:   Fri,  4 Feb 2022 18:00:00 +0100
Message-Id: <20220204170001.27198-3-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220204170001.27198-1-phil@nwl.cc>
References: <20220204170001.27198-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This at least allows to inspect how tables are created on demand.
Also requires setting NFTNL_TABLE_FAMILY for clean output.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/iptables/nft.c b/iptables/nft.c
index 301d6c342f982..041e1b8ccd3e5 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -657,6 +657,7 @@ static int nft_table_builtin_add(struct nft_handle *h,
 	if (t == NULL)
 		return -1;
 
+	nftnl_table_set_u32(t, NFTNL_TABLE_FAMILY, h->family);
 	nftnl_table_set_str(t, NFTNL_TABLE_NAME, _t->name);
 
 	ret = batch_table_add(h, NFT_COMPAT_TABLE_ADD, t) ? 0 : - 1;
@@ -2242,6 +2243,7 @@ static int __nft_table_flush(struct nft_handle *h, const char *table, bool exist
 	if (t == NULL)
 		return -1;
 
+	nftnl_table_set_u32(t, NFTNL_TABLE_FAMILY, h->family);
 	nftnl_table_set_str(t, NFTNL_TABLE_NAME, table);
 
 	obj = batch_table_add(h, NFT_COMPAT_TABLE_FLUSH, t);
@@ -2832,6 +2834,18 @@ error:
 	return ret;
 }
 
+static void nft_table_print_debug(struct nft_handle *h,
+				  struct nftnl_table *t, struct nlmsghdr *nlh)
+{
+	if (h->verbose > 1) {
+		nftnl_table_fprintf(stdout, t, 0, 0);
+		fprintf(stdout, "\n");
+	}
+	if (h->verbose > 2)
+		mnl_nlmsg_fprintf(stdout, nlh, nlh->nlmsg_len,
+				  sizeof(struct nfgenmsg));
+}
+
 static void nft_compat_table_batch_add(struct nft_handle *h, uint16_t type,
 				       uint16_t flags, uint32_t seq,
 				       struct nftnl_table *table)
@@ -2841,6 +2855,7 @@ static void nft_compat_table_batch_add(struct nft_handle *h, uint16_t type,
 	nlh = nftnl_table_nlmsg_build_hdr(nftnl_batch_buffer(h->batch),
 					type, h->family, flags, seq);
 	nftnl_table_nlmsg_build_payload(nlh, table);
+	nft_table_print_debug(h, table, nlh);
 }
 
 static void nft_compat_set_batch_add(struct nft_handle *h, uint16_t type,
-- 
2.34.1

