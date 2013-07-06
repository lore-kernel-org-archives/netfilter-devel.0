From: Eric Leblond <eric@regit.org>
Subject: [libnftables PATCH 1/4] rule: add support for position attribute
Date: Sat,  6 Jul 2013 17:33:13 +0200
Message-ID: <1373124796-6810-1-git-send-email-eric@regit.org>
References: <1373124677-6626-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:59752 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab3GFPdf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Jul 2013 11:33:35 -0400
In-Reply-To: <1373124677-6626-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for position attribute which can be used
to insert a rule at a given position.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/libnftables/rule.h          |  1 +
 include/linux/netfilter/nf_tables.h |  1 +
 src/rule.c                          | 23 +++++++++++++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
index 186c82c..ab61eb8 100644
--- a/include/libnftables/rule.h
+++ b/include/libnftables/rule.h
@@ -22,6 +22,7 @@ enum {
 	NFT_RULE_ATTR_FLAGS,
 	NFT_RULE_ATTR_COMPAT_PROTO,
 	NFT_RULE_ATTR_COMPAT_FLAGS,
+	NFT_RULE_ATTR_POSITION,
 };
 
 void nft_rule_attr_unset(struct nft_rule *r, uint16_t attr);
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index c2dae4e..4fe91ef 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -99,6 +99,7 @@ enum nft_rule_attributes {
 	NFTA_RULE_EXPRESSIONS,
 	NFTA_RULE_FLAGS,
 	NFTA_RULE_COMPAT,
+	NFTA_RULE_POSITION,
 	__NFTA_RULE_MAX
 };
 #define NFTA_RULE_MAX		(__NFTA_RULE_MAX - 1)
diff --git a/src/rule.c b/src/rule.c
index 5a4ae91..a56df34 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -39,6 +39,7 @@ struct nft_rule {
 	uint8_t		family;
 	uint32_t	rule_flags;
 	uint64_t	handle;
+	uint64_t	position;
 	struct {
 			uint32_t	flags;
 			uint32_t	proto;
@@ -99,6 +100,7 @@ void nft_rule_attr_unset(struct nft_rule *r, uint16_t attr)
 	case NFT_RULE_ATTR_FLAGS:
 	case NFT_RULE_ATTR_COMPAT_PROTO:
 	case NFT_RULE_ATTR_COMPAT_FLAGS:
+	case NFT_RULE_ATTR_POSITION:
 	case NFT_RULE_ATTR_FAMILY:
 		break;
 	default:
@@ -127,6 +129,9 @@ void nft_rule_attr_set(struct nft_rule *r, uint16_t attr, const void *data)
 	case NFT_RULE_ATTR_HANDLE:
 		r->handle = *((uint64_t *)data);
 		break;
+	case NFT_RULE_ATTR_POSITION:
+		r->position = *((uint64_t *)data);
+		break;
 	case NFT_RULE_ATTR_FLAGS:
 		r->rule_flags = *((uint32_t *)data);
 		break;
@@ -208,6 +213,12 @@ const void *nft_rule_attr_get(const struct nft_rule *r, uint16_t attr)
 		else
 			return NULL;
 		break;
+	case NFT_RULE_ATTR_POSITION:
+		if (r->flags & (1 << NFT_RULE_ATTR_POSITION))
+			return &r->position;
+		else
+			return NULL;
+		break;
 	default:
 		return NULL;
 	}
@@ -273,6 +284,8 @@ void nft_rule_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_rule *r)
 		mnl_attr_put_strz(nlh, NFTA_RULE_CHAIN, r->chain);
 	if (r->flags & (1 << NFT_RULE_ATTR_HANDLE))
 		mnl_attr_put_u64(nlh, NFTA_RULE_HANDLE, htobe64(r->handle));
+	if (r->flags & (1 << NFT_RULE_ATTR_POSITION))
+		mnl_attr_put_u64(nlh, NFTA_RULE_POSITION, htobe64(r->position));
 	if (r->flags & (1 << NFT_RULE_ATTR_FLAGS))
 		mnl_attr_put_u32(nlh, NFTA_RULE_FLAGS, htonl(r->rule_flags));
 
@@ -335,6 +348,12 @@ static int nft_rule_parse_attr_cb(const struct nlattr *attr, void *data)
 			return MNL_CB_ERROR;
 		}
 		break;
+	case NFTA_RULE_POSITION:
+		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0) {
+			perror("mnl_attr_validate");
+			return MNL_CB_ERROR;
+		}
+		break;
 	}
 
 	tb[type] = attr;
@@ -469,6 +488,10 @@ int nft_rule_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_rule *r)
 		ret = nft_rule_parse_expr(tb[NFTA_RULE_EXPRESSIONS], r);
 	if (tb[NFTA_RULE_COMPAT])
 		ret = nft_rule_parse_compat(tb[NFTA_RULE_COMPAT], r);
+	if (tb[NFTA_RULE_POSITION]) {
+		r->position = be64toh(mnl_attr_get_u64(tb[NFTA_RULE_POSITION]));
+		r->flags |= (1 << NFT_RULE_ATTR_POSITION);
+	}
 
 	r->family = nfg->nfgen_family;
 	r->flags |= (1 << NFT_RULE_ATTR_FAMILY);
-- 
1.8.3.2

