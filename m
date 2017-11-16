From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 2/2] monitor: Make JSON output respect output_fp
Date: Thu, 16 Nov 2017 09:06:29 +0100
Message-ID: <20171116080629.30564-3-phil@nwl.cc>
References: <20171116080629.30564-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:59742 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759387AbdKPIGv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Nov 2017 03:06:51 -0500
In-Reply-To: <20171116080629.30564-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This introduces a rather nasty macro to call nftnl_*_fprintf() only if
output_fp is valid. On the other hand, it allows to pull the common
parts (format argument, event conversion) into a single place.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/netlink.c | 38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 845eeeffd7387..81b92ac1e2d7c 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -40,6 +40,12 @@
 #include <iface.h>
 
 #define nft_mon_print(monh, ...) nft_print(monh->ctx->octx, __VA_ARGS__)
+#define nftnl_mon_print(monh, type, obj, event)				\
+	if (monh->ctx->octx->output_fp) {				\
+		nftnl_##type##_fprintf(monh->ctx->octx->output_fp,	\
+				       obj, monh->format,		\
+				       netlink_msg2nftnl_of(event));	\
+	}
 
 const struct input_descriptor indesc_netlink = {
 	.name	= "netlink",
@@ -2018,9 +2024,8 @@ static int netlink_events_table_cb(const struct nlmsghdr *nlh, int type,
 		break;
 	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
-		nftnl_table_fprintf(stdout, nlt, monh->format,
-				    netlink_msg2nftnl_of(type));
-		fprintf(stdout, "\n");
+		nftnl_mon_print(monh, table, nlt, type);
+		nft_mon_print(monh, "\n");
 		break;
 	}
 
@@ -2060,9 +2065,8 @@ static int netlink_events_chain_cb(const struct nlmsghdr *nlh, int type,
 		break;
 	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
-		nftnl_chain_fprintf(stdout, nlc, monh->format,
-				    netlink_msg2nftnl_of(type));
-		fprintf(stdout, "\n");
+		nftnl_mon_print(monh, chain, nlc, type);
+		nft_mon_print(monh, "\n");
 		break;
 	}
 
@@ -2107,9 +2111,8 @@ static int netlink_events_set_cb(const struct nlmsghdr *nlh, int type,
 		break;
 	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
-		nftnl_set_fprintf(stdout, nls, monh->format,
-				netlink_msg2nftnl_of(type));
-		fprintf(stdout, "\n");
+		nftnl_mon_print(monh, set, nls, type);
+		nft_mon_print(monh, "\n");
 		break;
 	}
 out:
@@ -2256,9 +2259,8 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 		break;
 	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
-		nftnl_set_fprintf(stdout, nls, monh->format,
-				  netlink_msg2nftnl_of(type));
-		fprintf(stdout, "\n");
+		nftnl_mon_print(monh, set, nls, type);
+		nft_mon_print(monh, "\n");
 		break;
 	}
 out:
@@ -2301,9 +2303,8 @@ static int netlink_events_obj_cb(const struct nlmsghdr *nlh, int type,
 		break;
 	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
-		nftnl_obj_fprintf(stdout, nlo, monh->format,
-				  netlink_msg2nftnl_of(type));
-		fprintf(stdout, "\n");
+		nftnl_mon_print(monh, obj, nlo, type);
+		nft_mon_print(monh, "\n");
 		break;
 	}
 
@@ -2357,9 +2358,8 @@ static int netlink_events_rule_cb(const struct nlmsghdr *nlh, int type,
 		break;
 	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
-		nftnl_rule_fprintf(stdout, nlr, monh->format,
-				 netlink_msg2nftnl_of(type));
-		fprintf(stdout, "\n");
+		nftnl_mon_print(monh, rule, nlr, type);
+		nft_mon_print(monh, "\n");
 		break;
 	}
 
@@ -2984,8 +2984,6 @@ static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
 		ret = netlink_events_newgen_cb(nlh, type, monh);
 		break;
 	}
-	fflush(stdout);
-
 	return ret;
 }
 
-- 
2.13.1

