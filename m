From: Eric Leblond <eric@regit.org>
Subject: [PATCH 4/4] nfct: add protocol filter
Date: Fri, 28 Dec 2012 18:30:01 +0100
Message-ID: <1356715802-11572-5-git-send-email-eric@regit.org>
References: <1356715802-11572-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:57967 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab2L1RaY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Dec 2012 12:30:24 -0500
In-Reply-To: <1356715802-11572-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a new configuration variable which is used to limit
conntrack event to connection of these protocols:
For example:
   accept_proto_filter=tcp,sctp

Signed-off-by: Eric Leblond <eric@regit.org>
---
 input/flow/ulogd_inpflow_NFCT.c |   60 +++++++++++++++++++++++++++++++++++++--
 ulogd.conf.in                   |    1 +
 2 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index b3e48d7..3889b10 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -36,6 +36,7 @@
 #include <sys/time.h>
 #include <time.h>
 #include <netinet/in.h>
+#include <netdb.h>
 #include <ulogd/linuxlist.h>
 #include <ulogd/jhash.h>
 #include <ulogd/hash.h>
@@ -73,7 +74,7 @@ struct nfct_pluginstance {
 #define EVENT_MASK	NF_NETLINK_CONNTRACK_NEW | NF_NETLINK_CONNTRACK_DESTROY
 
 static struct config_keyset nfct_kset = {
-	.num_ces = 11,
+	.num_ces = 12,
 	.ces = {
 		{
 			.key	 = "pollinterval",
@@ -139,6 +140,11 @@ static struct config_keyset nfct_kset = {
 			.type	 = CONFIG_TYPE_STRING,
 			.options = CONFIG_OPT_NONE,
 		},
+		{
+			.key	 = "accept_proto_filter",
+			.type	 = CONFIG_TYPE_STRING,
+			.options = CONFIG_OPT_NONE,
+		},
 	},
 };
 #define pollint_ce(x)	(x->ces[0])
@@ -152,6 +158,7 @@ static struct config_keyset nfct_kset = {
 #define reliable_ce(x)	(x->ces[8])
 #define src_filter_ce(x)	((x)->ces[9])
 #define dst_filter_ce(x)	((x)->ces[10])
+#define proto_filter_ce(x)	((x)->ces[11])
 
 enum nfct_keys {
 	NFCT_ORIG_IP_SADDR = 0,
@@ -1143,6 +1150,46 @@ static int build_nfct_filter_dir(struct nfct_filter *filter, char* filter_string
 	return 0;
 }
 
+static int build_nfct_filter_proto(struct nfct_filter *filter, char* filter_string)
+{
+	char *from = filter_string;
+	char *comma;
+	struct protoent * pent = NULL;
+
+	while ((comma = strchr(from, ',')) != NULL) {
+		size_t len = comma - from;
+		*comma = 0;
+		pent = getprotobyname(from);
+		if (pent == NULL) {
+			ulogd_log(ULOGD_FATAL, "Unknown protocol\n");
+			endprotoent();
+			return -1;
+		}
+		ulogd_log(ULOGD_NOTICE, "adding proto to filter: \"%s\" (%d)\n",
+			  pent->p_name, pent->p_proto
+		 );
+		nfct_filter_add_attr_u32(filter, NFCT_FILTER_L4PROTO,
+					 pent->p_proto);
+		from += len + 1;
+	}
+	pent = getprotobyname(from);
+	if (pent == NULL) {
+		ulogd_log(ULOGD_FATAL, "Unknown protocol %s\n", from);
+		endprotoent();
+		return -1;
+	}
+	ulogd_log(ULOGD_NOTICE, "adding proto to filter: \"%s (%d)\"\n",
+			pent->p_name, pent->p_proto
+		 );
+	nfct_filter_add_attr_u32(filter, NFCT_FILTER_L4PROTO,
+			pent->p_proto);
+
+
+	endprotoent();
+	return 0;
+}
+
+
 static int build_nfct_filter(struct ulogd_pluginstance *upi)
 {
 	struct nfct_pluginstance *cpi =
@@ -1176,6 +1223,14 @@ static int build_nfct_filter(struct ulogd_pluginstance *upi)
 			goto err_filter;
 		}
 	}
+	if (strlen(proto_filter_ce(upi->config_kset).u.string) != 0) {
+		char *filter_string = proto_filter_ce(upi->config_kset).u.string;
+		if (build_nfct_filter_proto(filter, filter_string) != 0) {
+			ulogd_log(ULOGD_FATAL,
+					"Unable to create proto filter\n");
+			goto err_filter;
+		}
+	}
 
 	if (filter) {
 		if (nfct_filter_attach(nfct_fd(cpi->cth), filter) == -1) {
@@ -1208,7 +1263,8 @@ static int constructor_nfct_events(struct ulogd_pluginstance *upi)
 	}
 
 	if ((strlen(src_filter_ce(upi->config_kset).u.string) != 0) ||
-			(strlen(dst_filter_ce(upi->config_kset).u.string) != 0)
+		(strlen(dst_filter_ce(upi->config_kset).u.string) != 0) ||
+		(strlen(proto_filter_ce(upi->config_kset).u.string) != 0)
 	   ) {
 		if (build_nfct_filter(upi) != 0) {
 			ulogd_log(ULOGD_FATAL, "error creating NFCT filter\n");
diff --git a/ulogd.conf.in b/ulogd.conf.in
index fa1fbf2..783cb2b 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -129,6 +129,7 @@ plugin="@pkglibdir@/ulogd_output_GRAPHITE.so"
 # In this case, you can use the following filters on events:
 #accept_src_filter=192.168.1.0/24,1:2::/64 # source ip of connection must belong to these networks
 #accept_dst_filter=192.168.1.0/24 # destination ip of connection must belong to these networks
+#accept_proto_filter=tcp,sctp # layer 4 proto of connections
 
 [ct2]
 #netlink_socket_buffer_size=217088
-- 
1.7.10.4

