Return-Path: <SRS0=c7vx=XW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91885C4360C
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Sep 2019 14:05:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 705AB217D7
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Sep 2019 14:05:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbfI0OFM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Sep 2019 10:05:12 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:50006 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbfI0OFM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Sep 2019 10:05:12 -0400
Received: from localhost ([::1]:34864 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iDqru-0006vi-0f; Fri, 27 Sep 2019 16:05:10 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 08/12] nft: Support NFT_COMPAT_SET_ADD
Date:   Fri, 27 Sep 2019 16:04:29 +0200
Message-Id: <20190927140433.9504-9-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190927140433.9504-1-phil@nwl.cc>
References: <20190927140433.9504-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Implement the required infrastructure to create sets as part of a batch
job commit.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/iptables/nft.c b/iptables/nft.c
index f46f13c2501e2..7cab4a236aaa7 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -306,6 +306,7 @@ enum obj_update_type {
 	NFT_COMPAT_RULE_REPLACE,
 	NFT_COMPAT_RULE_DELETE,
 	NFT_COMPAT_RULE_FLUSH,
+	NFT_COMPAT_SET_ADD,
 };
 
 enum obj_action {
@@ -323,6 +324,7 @@ struct obj_update {
 		struct nftnl_table	*table;
 		struct nftnl_chain	*chain;
 		struct nftnl_rule	*rule;
+		struct nftnl_set	*set;
 		void			*ptr;
 	};
 	struct {
@@ -350,6 +352,7 @@ static int mnl_append_error(const struct nft_handle *h,
 		[NFT_COMPAT_RULE_REPLACE] = "RULE_REPLACE",
 		[NFT_COMPAT_RULE_DELETE] = "RULE_DELETE",
 		[NFT_COMPAT_RULE_FLUSH] = "RULE_FLUSH",
+		[NFT_COMPAT_SET_ADD] = "SET_ADD",
 	};
 	char errmsg[256];
 	char tcr[128];
@@ -390,6 +393,10 @@ static int mnl_append_error(const struct nft_handle *h,
 		}
 #endif
 		break;
+	case NFT_COMPAT_SET_ADD:
+		snprintf(tcr, sizeof(tcr), "set %s",
+			 nftnl_set_get_str(o->set, NFTNL_SET_NAME));
+		break;
 	}
 
 	return snprintf(buf, len, "%s: %s", errmsg, tcr);
@@ -419,6 +426,13 @@ batch_table_add(struct nft_handle *h, enum obj_update_type type,
 	return batch_add(h, type, t);
 }
 
+static struct obj_update *
+batch_set_add(struct nft_handle *h, enum obj_update_type type,
+	      struct nftnl_set *s)
+{
+	return batch_add(h, type, s);
+}
+
 static int batch_chain_add(struct nft_handle *h, enum obj_update_type type,
 			   struct nftnl_chain *c)
 {
@@ -2995,6 +3009,39 @@ static void nft_compat_table_batch_add(struct nft_handle *h, uint16_t type,
 	nftnl_table_nlmsg_build_payload(nlh, table);
 }
 
+static void nft_compat_set_batch_add(struct nft_handle *h, uint16_t type,
+				     uint16_t flags, uint32_t seq,
+				     struct nftnl_set *set)
+{
+	struct nlmsghdr *nlh;
+
+	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(h->batch),
+					type, h->family, flags, seq);
+	nftnl_set_nlmsg_build_payload(nlh, set);
+}
+
+static void nft_compat_setelem_batch_add(struct nft_handle *h, uint16_t type,
+					 uint16_t flags, uint32_t *seq,
+					 struct nftnl_set *set)
+{
+	struct nftnl_set_elems_iter *iter;
+	struct nlmsghdr *nlh;
+
+	iter = nftnl_set_elems_iter_create(set);
+	if (!iter)
+		return;
+
+	while (nftnl_set_elems_iter_cur(iter)) {
+		(*seq)++;
+		mnl_nft_batch_continue(h->batch);
+		nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(h->batch),
+					    type, h->family, flags, *seq);
+		if (nftnl_set_elems_nlmsg_build_payload_iter(nlh, iter) <= 0)
+			break;
+	}
+	nftnl_set_elems_iter_destroy(iter);
+}
+
 static void nft_compat_chain_batch_add(struct nft_handle *h, uint16_t type,
 				       uint16_t flags, uint32_t seq,
 				       struct nftnl_chain *chain)
@@ -3044,6 +3091,9 @@ static void batch_obj_del(struct nft_handle *h, struct obj_update *o)
 	case NFT_COMPAT_RULE_FLUSH:
 		nftnl_rule_free(o->rule);
 		break;
+	case NFT_COMPAT_SET_ADD:
+		nftnl_set_free(o->set);
+		break;
 	}
 	h->obj_list_num--;
 	list_del(&o->head);
@@ -3110,6 +3160,7 @@ static void nft_refresh_transaction(struct nft_handle *h)
 		case NFT_COMPAT_RULE_REPLACE:
 		case NFT_COMPAT_RULE_DELETE:
 		case NFT_COMPAT_RULE_FLUSH:
+		case NFT_COMPAT_SET_ADD:
 			break;
 		}
 	}
@@ -3200,6 +3251,13 @@ retry:
 			nft_compat_rule_batch_add(h, NFT_MSG_DELRULE, 0,
 						  n->seq, n->rule);
 			break;
+		case NFT_COMPAT_SET_ADD:
+			nft_compat_set_batch_add(h, NFT_MSG_NEWSET,
+						 NLM_F_CREATE, n->seq, n->set);
+			nft_compat_setelem_batch_add(h, NFT_MSG_NEWSETELEM,
+						     NLM_F_CREATE, &n->seq, n->set);
+			seq = n->seq;
+			break;
 		}
 
 		mnl_nft_batch_continue(h->batch);
-- 
2.23.0

