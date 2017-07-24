From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2] monitor: Print NEWGEN events
Date: Mon, 24 Jul 2017 19:29:11 +0200
Message-ID: <20170724172911.1611-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:45107 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754142AbdGXR3Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jul 2017 13:29:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now that they contain process information, they're actually interesting.
For backwards compatibility, print process information only if it was
present in the message.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
changes since v1:
- Abort with netlink_abi_error() if attribute validation fails.
- Prefix message with '#' as requested.
- No need to copy the process name around - validation ensures the
  string is NULL-terminated and the netlink message is not altered
  before printing the attribute.
---
 include/linux/netfilter/nf_tables.h |  2 ++
 src/netlink.c                       | 40 +++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 683f6f88fcace..40096de04e963 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1221,6 +1221,8 @@ enum nft_objref_attributes {
 enum nft_gen_attributes {
 	NFTA_GEN_UNSPEC,
 	NFTA_GEN_ID,
+	NFTA_GEN_PROC_ID,
+	NFTA_GEN_PROC_NAME,
 	__NFTA_GEN_MAX
 };
 #define NFTA_GEN_MAX		(__NFTA_GEN_MAX - 1)
diff --git a/src/netlink.c b/src/netlink.c
index e3c90dac8c7a6..977aea81405a9 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -2915,6 +2915,43 @@ static void netlink_events_debug(uint16_t type)
 #endif /* DEBUG */
 }
 
+static int netlink_events_newgen_cb(const struct nlmsghdr *nlh, int type,
+				    struct netlink_mon_handler *monh)
+{
+	const struct nlattr *attr;
+	const char *name = "";
+	int genid, pid = -1;
+
+	mnl_attr_for_each(attr, nlh, sizeof(struct nfgenmsg)) {
+		switch (mnl_attr_get_type(attr)) {
+		case NFTA_GEN_ID:
+			if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+				netlink_abi_error();
+			genid = ntohl(mnl_attr_get_u32(attr));
+			break;
+		case NFTA_GEN_PROC_NAME:
+			if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
+				netlink_abi_error();
+			name = mnl_attr_get_str(attr);
+			break;
+		case NFTA_GEN_PROC_ID:
+			if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+				netlink_abi_error();
+			pid = ntohl(mnl_attr_get_u32(attr));
+			break;
+		}
+	}
+	printf("# new generation %d", genid);
+	if (pid >= 0) {
+		printf(" by process %d", pid);
+		if (!monh->ctx->octx->numeric)
+			printf(" (%s)", name);
+	}
+	printf("\n");
+
+	return MNL_CB_OK;
+}
+
 static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
 {
 	int ret = MNL_CB_OK;
@@ -2955,6 +2992,9 @@ static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
 	case NFT_MSG_DELOBJ:
 		ret = netlink_events_obj_cb(nlh, type, monh);
 		break;
+	case NFT_MSG_NEWGEN:
+		ret = netlink_events_newgen_cb(nlh, type, monh);
+		break;
 	}
 	fflush(stdout);
 
-- 
2.13.1

