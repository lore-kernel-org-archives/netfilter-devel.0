From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [libnftables PATCH v2 2/2] table: Add support for NFTA_TABLE_USE nftables attribute
Date: Thu, 12 Dec 2013 15:12:59 +0200
Message-ID: <1386853979-17356-1-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <CAOkSjBjOCcfthVBjt90P0NKx--L-0zzMRijeVe_J7xapmn_19w@mail.gmail.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:34653 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab3LLNNG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Dec 2013 08:13:06 -0500
In-Reply-To: <CAOkSjBjOCcfthVBjt90P0NKx--L-0zzMRijeVe_J7xapmn_19w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adds support for table's attribute "use" which let us know about
how many chains are in the table, if any.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/libnftables/table.h         |  1 +
 include/linux/netfilter/nf_tables.h |  2 ++
 src/table.c                         | 35 +++++++++++++++++++++++++++++------
 3 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/include/libnftables/table.h b/include/libnftables/table.h
index be60da9..1d2be07 100644
--- a/include/libnftables/table.h
+++ b/include/libnftables/table.h
@@ -21,6 +21,7 @@ enum {
 	NFT_TABLE_ATTR_NAME	= 0,
 	NFT_TABLE_ATTR_FAMILY,
 	NFT_TABLE_ATTR_FLAGS,
+	NFT_TABLE_ATTR_USE,
 };
 
 bool nft_table_attr_is_set(const struct nft_table *t, uint16_t attr);
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 256d36b..b25481e 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -110,11 +110,13 @@ enum nft_table_flags {
  *
  * @NFTA_TABLE_NAME: name of the table (NLA_STRING)
  * @NFTA_TABLE_FLAGS: bitmask of enum nft_table_flags (NLA_U32)
+ * @NFTA_TABLE_USE: number of chains in this table (NLA_U32)
  */
 enum nft_table_attributes {
 	NFTA_TABLE_UNSPEC,
 	NFTA_TABLE_NAME,
 	NFTA_TABLE_FLAGS,
+	NFTA_TABLE_USE,
 	__NFTA_TABLE_MAX
 };
 #define NFTA_TABLE_MAX		(__NFTA_TABLE_MAX - 1)
diff --git a/src/table.c b/src/table.c
index 9e20768..ecc57a6 100644
--- a/src/table.c
+++ b/src/table.c
@@ -31,6 +31,7 @@ struct nft_table {
 	const char	*name;
 	uint8_t		family;
 	uint32_t	table_flags;
+	uint32_t	use;
 	uint32_t	flags;
 };
 
@@ -70,6 +71,9 @@ void nft_table_attr_unset(struct nft_table *t, uint16_t attr)
 	case NFT_TABLE_ATTR_FLAGS:
 	case NFT_TABLE_ATTR_FAMILY:
 		break;
+	case NFT_TABLE_ATTR_USE:
+		/* Cannot be unset, ignoring it */
+		return;
 	}
 	t->flags &= ~(1 << attr);
 }
@@ -93,6 +97,9 @@ void nft_table_attr_set(struct nft_table *t, uint16_t attr, const void *data)
 		t->family = *((uint8_t *)data);
 		t->flags |= (1 << NFT_TABLE_ATTR_FAMILY);
 		break;
+	case NFT_TABLE_ATTR_USE:
+		/* Cannot be unset, ignoring it */
+		break;
 	}
 }
 EXPORT_SYMBOL(nft_table_attr_set);
@@ -127,6 +134,8 @@ const void *nft_table_attr_get(struct nft_table *t, uint16_t attr)
 		return &t->table_flags;
 	case NFT_TABLE_ATTR_FAMILY:
 		return &t->family;
+	case NFT_TABLE_ATTR_USE:
+		return &t->use;
 	}
 	return NULL;
 }
@@ -182,6 +191,12 @@ static int nft_table_parse_attr_cb(const struct nlattr *attr, void *data)
 			return MNL_CB_ERROR;
 		}
 		break;
+	case NFTA_TABLE_USE:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
+			perror("mnl_attr_validate");
+			return MNL_CB_ERROR;
+		}
+		break;
 	}
 
 	tb[type] = attr;
@@ -202,6 +217,10 @@ int nft_table_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_table *t)
 		t->table_flags = ntohl(mnl_attr_get_u32(tb[NFTA_TABLE_FLAGS]));
 		t->flags |= (1 << NFT_TABLE_ATTR_FLAGS);
 	}
+	if (tb[NFTA_TABLE_USE]) {
+		t->use = ntohl(mnl_attr_get_u32(tb[NFTA_TABLE_USE]));
+		t->flags |= (1 << NFT_TABLE_ATTR_USE);
+	}
 
 	t->family = nfg->nfgen_family;
 	t->flags |= (1 << NFT_TABLE_ATTR_FAMILY);
@@ -344,23 +363,27 @@ static int nft_table_snprintf_json(char *buf, size_t size, struct nft_table *t)
 			"{\"table\":{"
 			"\"name\":\"%s\","
 			"\"family\":\"%s\","
-			"\"flags\":%d"
+			"\"flags\":%d,"
+			"\"use\":%d"
 			"}"
 			"}" ,
-			t->name, nft_family2str(t->family), t->table_flags);
+			t->name, nft_family2str(t->family),
+			t->table_flags, t->use);
 }
 
 static int nft_table_snprintf_xml(char *buf, size_t size, struct nft_table *t)
 {
 	return snprintf(buf, size, "<table><name>%s</name><family>%s</family>"
-			"<flags>%d</flags></table>",
-			t->name, nft_family2str(t->family), t->table_flags);
+			"<flags>%d</flags><use>%d</use></table>",
+			t->name, nft_family2str(t->family),
+			t->table_flags, t->use);
 }
 
 static int nft_table_snprintf_default(char *buf, size_t size, struct nft_table *t)
 {
-	return snprintf(buf, size, "table %s %s flags %x",
-			t->name, nft_family2str(t->family), t->table_flags);
+	return snprintf(buf, size, "table %s %s flags %x use %d",
+			t->name, nft_family2str(t->family),
+			t->table_flags, t->use);
 }
 
 int nft_table_snprintf(char *buf, size_t size, struct nft_table *t,
-- 
1.8.4.4

