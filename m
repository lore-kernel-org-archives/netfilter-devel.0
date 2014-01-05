From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftables] set: support new maximum and number of elements attributes
Date: Sun,  5 Jan 2014 22:25:28 +0100
Message-ID: <1388957128-3643-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52220 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbaAEVZk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jan 2014 16:25:40 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds two new attributes NFT_SET_ATTR_MAX_ELEMS and
NFT_SET_ATTR_NUM_ELEMS to set the maximum number of elements per
set and to obtain the current number of elements in the set
respectively.

This requires the kernel patch ("netfilter: nf_tables: limit
maximum number of elements").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftables/set.h           |    2 ++
 include/linux/netfilter/nf_tables.h |    2 ++
 src/internal.h                      |    2 ++
 src/set.c                           |   22 ++++++++++++++++++++--
 4 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/include/libnftables/set.h b/include/libnftables/set.h
index 13ac857..6ea7a54 100644
--- a/include/libnftables/set.h
+++ b/include/libnftables/set.h
@@ -16,6 +16,8 @@ enum {
 	NFT_SET_ATTR_KEY_LEN,
 	NFT_SET_ATTR_DATA_TYPE,
 	NFT_SET_ATTR_DATA_LEN,
+	NFT_SET_ATTR_MAX_ELEMS,
+	NFT_SET_ATTR_NUM_ELEMS,
 	NFT_SET_ATTR_FAMILY,
 };
 
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index e08f80e..45f8695 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -189,6 +189,8 @@ enum nft_set_attributes {
 	NFTA_SET_KEY_LEN,
 	NFTA_SET_DATA_TYPE,
 	NFTA_SET_DATA_LEN,
+	NFTA_SET_MAXELEMS,
+	NFTA_SET_NUMELEMS,
 	__NFTA_SET_MAX
 };
 #define NFTA_SET_MAX		(__NFTA_SET_MAX - 1)
diff --git a/src/internal.h b/src/internal.h
index a10d874..df368c3 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -117,6 +117,8 @@ struct nft_set {
 	uint32_t		key_len;
 	uint32_t		data_type;
 	uint32_t		data_len;
+	uint32_t		max_elems;
+	uint32_t		num_elems;
 	struct list_head	element_list;
 
 	uint32_t		flags;
diff --git a/src/set.c b/src/set.c
index c5204cc..424f383 100644
--- a/src/set.c
+++ b/src/set.c
@@ -129,6 +129,11 @@ void nft_set_attr_set(struct nft_set *s, uint16_t attr, const void *data)
 	case NFT_SET_ATTR_FAMILY:
 		s->family = *((uint32_t *)data);
 		break;
+	case NFT_SET_ATTR_MAX_ELEMS:
+		s->max_elems = *((uint32_t *)data);
+		break;
+	case NFT_SET_ATTR_NUM_ELEMS:	/* cannot be set */
+		break;
 	default:
 		return;
 	}
@@ -205,6 +210,8 @@ void nft_set_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set *s)
 		mnl_attr_put_u32(nlh, NFTA_SET_DATA_TYPE, htonl(s->data_type));
 	if (s->flags & (1 << NFT_SET_ATTR_DATA_LEN))
 		mnl_attr_put_u32(nlh, NFTA_SET_DATA_LEN, htonl(s->data_len));
+	if (s->flags & (1 << NFT_SET_ATTR_MAX_ELEMS))
+		mnl_attr_put_u32(nlh, NFTA_SET_MAXELEMS, htonl(s->max_elems));
 }
 EXPORT_SYMBOL(nft_set_nlmsg_build_payload);
 
@@ -229,6 +236,8 @@ static int nft_set_parse_attr_cb(const struct nlattr *attr, void *data)
 	case NFTA_SET_KEY_LEN:
 	case NFTA_SET_DATA_TYPE:
 	case NFTA_SET_DATA_LEN:
+	case NFTA_SET_MAXELEMS:
+	case NFTA_SET_NUMELEMS:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
 			perror("mnl_attr_validate");
 			return MNL_CB_ERROR;
@@ -275,6 +284,14 @@ int nft_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set *s)
 		s->data_len = ntohl(mnl_attr_get_u32(tb[NFTA_SET_DATA_LEN]));
 		s->flags |= (1 << NFT_SET_ATTR_DATA_LEN);
 	}
+	if (tb[NFTA_SET_MAXELEMS]) {
+		s->max_elems = ntohl(mnl_attr_get_u32(tb[NFTA_SET_MAXELEMS]));
+		s->flags |= (1 << NFT_SET_ATTR_MAX_ELEMS);
+	}
+	if (tb[NFTA_SET_NUMELEMS]) {
+		s->num_elems = ntohl(mnl_attr_get_u32(tb[NFTA_SET_NUMELEMS]));
+		s->flags |= (1 << NFT_SET_ATTR_NUM_ELEMS);
+	}
 	s->family = nfg->nfgen_family;
 	s->flags |= (1 << NFT_SET_ATTR_FAMILY);
 
@@ -574,8 +591,9 @@ static int nft_set_snprintf_default(char *buf, size_t size, struct nft_set *s,
 	int len = size, offset = 0;
 	struct nft_set_elem *elem;
 
-	ret = snprintf(buf, len, "%s %s %x",
-			s->name, s->table, s->set_flags);
+	ret = snprintf(buf, len, "%s %s %x [ %d max=%d ]",
+			s->name, s->table, s->set_flags, s->num_elems,
+			s->max_elems);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	/* Empty set? Skip printinf of elements */
-- 
1.7.10.4

