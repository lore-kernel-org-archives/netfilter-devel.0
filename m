Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9607C433E6
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 21:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 811F465250
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 21:02:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhCIVCU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Mar 2021 16:02:20 -0500
Received: from correo.us.es ([193.147.175.20]:60920 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230431AbhCIVBu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Mar 2021 16:01:50 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 465FDE1227
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Mar 2021 22:01:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 31EA9DA78A
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Mar 2021 22:01:49 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 268D3DA722; Tue,  9 Mar 2021 22:01:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D4650DA72F;
        Tue,  9 Mar 2021 22:01:46 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 09 Mar 2021 22:01:46 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id AAD3C42DF562;
        Tue,  9 Mar 2021 22:01:46 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, fmyhr@fhmtech.com, stefanh@hafenthal.de
Subject: [PATCH nf-next 2/2] netfilter: nftables: add NFT_CT_HELPER_OBJNAME
Date:   Tue,  9 Mar 2021 22:01:34 +0100
Message-Id: <20210309210134.13620-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210309210134.13620-1-pablo@netfilter.org>
References: <20210309210134.13620-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Conntrack helper assignments refer to the helper object name, while
NFT_CT_HELPER (now NFT_CT_HELPER_TYPE) refers to the helper type.

This patch allows to match on helper object name so the ct helper
matching and the assignment are consistent.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_helper.h |  1 +
 include/uapi/linux/netfilter/nf_tables.h    |  2 ++
 net/netfilter/nf_conntrack_helper.c         |  1 +
 net/netfilter/nft_ct.c                      | 26 ++++++++++++++++++---
 4 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 37f0fbefb060..c0020d5206cd 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -70,6 +70,7 @@ struct nf_conntrack_helper {
 struct nf_conn_help {
 	/* Helper. if any */
 	struct nf_conntrack_helper __rcu *helper;
+	const char *objname;
 
 	struct hlist_head expectations;
 
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 481e32c1b1b2..1cca009858bf 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1065,6 +1065,7 @@ enum nft_socket_keys {
  * @NFT_CT_SRC_IP6: conntrack layer 3 protocol source (IPv6 address)
  * @NFT_CT_DST_IP6: conntrack layer 3 protocol destination (IPv6 address)
  * @NFT_CT_ID: conntrack id
+ * @NFT_CT_HELPER_OBJNAME: connection tracking helper object assigned to conntrack
  */
 enum nft_ct_keys {
 	NFT_CT_STATE,
@@ -1092,6 +1093,7 @@ enum nft_ct_keys {
 	NFT_CT_SRC_IP6,
 	NFT_CT_DST_IP6,
 	NFT_CT_ID,
+	NFT_CT_HELPER_OBJNAME,
 	__NFT_CT_MAX
 };
 #define NFT_CT_MAX		(__NFT_CT_MAX - 1)
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 118f415928ae..c14b0733485b 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -311,6 +311,7 @@ void nf_ct_helper_destroy(struct nf_conn *ct)
 		if (helper && helper->destroy)
 			helper->destroy(ct);
 		rcu_read_unlock();
+		kfree(help->objname);
 	}
 }
 
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index a9041dce9345..a412de6de9ca 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -219,6 +219,17 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 			goto err;
 		memcpy(dest, tuple->dst.u3.ip6, sizeof(struct in6_addr));
 		return;
+	case NFT_CT_HELPER_OBJNAME:
+		if (!ct->master)
+			goto err;
+		help = nfct_help(ct->master);
+		if (!help)
+			goto err;
+		helper = rcu_dereference(help->helper);
+		if (!helper || !help->objname)
+			goto err;
+		strncpy((char *)dest, help->objname, NF_CT_HELPER_NAME_LEN);
+		return;
 	default:
 		break;
 	}
@@ -1063,6 +1074,7 @@ static void nft_ct_helper_obj_eval(struct nft_object *obj,
 	struct nf_conn *ct = (struct nf_conn *)skb_nfct(pkt->skb);
 	struct nf_conntrack_helper *to_assign = NULL;
 	struct nf_conn_help *help;
+	const char *objname;
 
 	if (!ct ||
 	    nf_ct_is_confirmed(ct) ||
@@ -1088,11 +1100,19 @@ static void nft_ct_helper_obj_eval(struct nft_object *obj,
 	if (test_bit(IPS_HELPER_BIT, &ct->status))
 		return;
 
+	objname = kstrdup(obj->key.name, GFP_ATOMIC);
+	if (!objname)
+		return;
+
 	help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
-	if (help) {
-		rcu_assign_pointer(help->helper, to_assign);
-		set_bit(IPS_HELPER_BIT, &ct->status);
+	if (!help) {
+		kfree(objname);
+		return;
 	}
+
+	help->objname = objname;
+	rcu_assign_pointer(help->helper, to_assign);
+	set_bit(IPS_HELPER_BIT, &ct->status);
 }
 
 static int nft_ct_helper_obj_dump(struct sk_buff *skb,
-- 
2.20.1

