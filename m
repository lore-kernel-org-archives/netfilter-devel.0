From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH v2] src: Use snprintf() over strncpy()
Date: Mon,  9 Oct 2017 00:53:43 +0530
Message-ID: <20171008192343.22050-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33220 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753439AbdJHT0C (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 8 Oct 2017 15:26:02 -0400
Received: by mail-pf0-f193.google.com with SMTP id m28so22514573pfi.0
        for <netfilter-devel@vger.kernel.org>; Sun, 08 Oct 2017 12:26:02 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use snprintf() over strncpy() functions as the buffer is not null
terminated in strncpy().

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
Changes in v2:
 -Change subject

 src/datatype.c | 2 +-
 src/iface.c    | 4 ++--
 src/netlink.c  | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index 94b1224..9439ea3 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -858,7 +858,7 @@ static uint32_t str2int(char *tmp, const char *c, int k)
 	if (k == 0)
 		return 0;
 
-	strncpy(tmp, c-k, k+1);
+	snprintf(tmp, k+1, "%s", c-k);
 	return atoi(tmp);
 }
 
diff --git a/src/iface.c b/src/iface.c
index 9936388..d0e1834 100644
--- a/src/iface.c
+++ b/src/iface.c
@@ -53,7 +53,7 @@ static int data_cb(const struct nlmsghdr *nlh, void *data)
 	iface = xmalloc(sizeof(struct iface));
 	iface->ifindex = ifm->ifi_index;
 	mnl_attr_parse(nlh, sizeof(*ifm), data_attr_cb, tb);
-	strncpy(iface->name, mnl_attr_get_str(tb[IFLA_IFNAME]), IFNAMSIZ);
+	snprintf(iface->name, IFNAMSIZ, "%s", mnl_attr_get_str(tb[IFLA_IFNAME]));
 	list_add(&iface->list, &iface_list);
 
 	return MNL_CB_OK;
@@ -139,7 +139,7 @@ char *nft_if_indextoname(unsigned int ifindex, char *name)
 
 	list_for_each_entry(iface, &iface_list, list) {
 		if (iface->ifindex == ifindex) {
-			strncpy(name, iface->name, IFNAMSIZ);
+			snprintf(name, IFNAMSIZ, "%s", iface->name);
 			return name;
 		}
 	}
diff --git a/src/netlink.c b/src/netlink.c
index d5d410a..f69a5b9 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -386,7 +386,7 @@ static void netlink_gen_verdict(const struct expr *expr,
 	switch (expr->verdict) {
 	case NFT_JUMP:
 	case NFT_GOTO:
-		strncpy(data->chain, expr->chain, NFT_CHAIN_MAXNAMELEN);
+		snprintf(data->chain, NFT_CHAIN_MAXNAMELEN, "%s", expr->chain);
 		data->chain[NFT_CHAIN_MAXNAMELEN-1] = '\0';
 		break;
 	}
@@ -2915,7 +2915,7 @@ static int netlink_events_newgen_cb(const struct nlmsghdr *nlh, int type,
 		case NFTA_GEN_PROC_NAME:
 			if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
 				break;
-			strncpy(name, mnl_attr_get_str(attr), sizeof(name));
+			snprintf(name, sizeof(name), "%s", mnl_attr_get_str(attr));
 			break;
 		case NFTA_GEN_PROC_ID:
 			if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
-- 
2.11.0

