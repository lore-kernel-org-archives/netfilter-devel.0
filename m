From: Eric Leblond <eric@regit.org>
Subject: [PATCH 3/4] nfct: implement src and dst filter
Date: Fri, 28 Dec 2012 18:30:00 +0100
Message-ID: <1356715802-11572-4-git-send-email-eric@regit.org>
References: <1356715802-11572-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:57966 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab2L1RaX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Dec 2012 12:30:23 -0500
In-Reply-To: <1356715802-11572-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch implements two filtering options in NFCT input plugin.
If 'accept_src_filter' is set to a network it will only catch the
event where the source is that specific network. 'accept_dst_filter'
does the same for the destination.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 input/flow/ulogd_inpflow_NFCT.c |  216 ++++++++++++++++++++++++++++++++++++++-
 ulogd.conf.in                   |    4 +
 2 files changed, 218 insertions(+), 2 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index 489c9e0..b3e48d7 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -43,6 +43,7 @@
 #include <ulogd/ulogd.h>
 #include <ulogd/timer.h>
 #include <ulogd/ipfix_protocol.h>
+#include <ulogd/addr.h>
 
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 
@@ -72,7 +73,7 @@ struct nfct_pluginstance {
 #define EVENT_MASK	NF_NETLINK_CONNTRACK_NEW | NF_NETLINK_CONNTRACK_DESTROY
 
 static struct config_keyset nfct_kset = {
-	.num_ces = 9,
+	.num_ces = 11,
 	.ces = {
 		{
 			.key	 = "pollinterval",
@@ -128,6 +129,16 @@ static struct config_keyset nfct_kset = {
 			.options = CONFIG_OPT_NONE,
 			.u.value = 0,
 		},
+		{
+			.key	 = "accept_src_filter",
+			.type	 = CONFIG_TYPE_STRING,
+			.options = CONFIG_OPT_NONE,
+		},
+		{
+			.key	 = "accept_dst_filter",
+			.type	 = CONFIG_TYPE_STRING,
+			.options = CONFIG_OPT_NONE,
+		},
 	},
 };
 #define pollint_ce(x)	(x->ces[0])
@@ -139,6 +150,8 @@ static struct config_keyset nfct_kset = {
 #define nlsockbufmaxsize_ce(x) (x->ces[6])
 #define nlresynctimeout_ce(x) (x->ces[7])
 #define reliable_ce(x)	(x->ces[8])
+#define src_filter_ce(x)	((x)->ces[9])
+#define dst_filter_ce(x)	((x)->ces[10])
 
 enum nfct_keys {
 	NFCT_ORIG_IP_SADDR = 0,
@@ -993,11 +1006,200 @@ static void overrun_timeout(struct ulogd_timer *a, void *data)
 	nfct_send(cpi->ovh, NFCT_Q_DUMP, &family);
 }
 
+
+#define NFCT_SRC_DIR 1
+#define NFCT_DST_DIR 2
+
+static inline int nfct_set_dir(int dir, int *filter_dir_ipv4, int *filter_dir_ipv6)
+{
+	switch (dir) {
+		case NFCT_DST_DIR:
+			*filter_dir_ipv4 = NFCT_FILTER_DST_IPV4;
+			*filter_dir_ipv6 = NFCT_FILTER_DST_IPV6;
+			break;
+		case NFCT_SRC_DIR:
+			*filter_dir_ipv4 = NFCT_FILTER_SRC_IPV4;
+			*filter_dir_ipv6 = NFCT_FILTER_SRC_IPV6;
+			break;
+		default:
+			ulogd_log(ULOGD_FATAL,
+					"Invalid direction %d\n",
+					dir);
+			return -1;
+	}
+	return 0;
+}
+
+static int nfct_add_to_filter(struct nfct_filter *filter,
+			      struct ulogd_addr *addr,
+			      int l3, int dir)
+{
+	int filter_dir_ipv4;
+	int filter_dir_ipv6;
+
+	if (nfct_set_dir(dir, &filter_dir_ipv4, &filter_dir_ipv6) == -1)
+		return -1;
+
+	switch (l3) {
+		case AF_INET6:
+			{
+				struct nfct_filter_ipv6 filter_ipv6;
+				/* BSF always wants data in host-byte order */
+				ulogd_ipv6_addr2addr_host(addr->in.ipv6, filter_ipv6.addr);
+				ulogd_ipv6_cidr2mask_host(addr->netmask, filter_ipv6.mask);
+
+				nfct_filter_set_logic(filter,
+						filter_dir_ipv6,
+						NFCT_FILTER_LOGIC_POSITIVE);
+				nfct_filter_add_attr(filter,
+						filter_dir_ipv6,
+						&filter_ipv6);
+			}
+			break;
+		case AF_INET:
+			{
+				/* BSF always wants data in host-byte order */
+				struct nfct_filter_ipv4 filter_ipv4 = {
+					.addr = ntohl(addr->in.ipv4),
+					.mask = ulogd_bits2netmask(addr->netmask),
+				};
+
+				nfct_filter_set_logic(filter,
+						filter_dir_ipv4,
+						NFCT_FILTER_LOGIC_POSITIVE);
+				nfct_filter_add_attr(filter, filter_dir_ipv4,
+						&filter_ipv4);
+			}
+			break;
+		default:
+			ulogd_log(ULOGD_FATAL, "Invalid protocol %d\n", l3);
+			return -1;
+	}
+	return 0;
+}
+
+static int build_nfct_filter_dir(struct nfct_filter *filter, char* filter_string, int dir)
+{
+	char *from = filter_string;
+	char *comma;
+	struct ulogd_addr addr;
+	int has_ipv4 = 0;
+	int has_ipv6 = 0;
+
+	while ((comma = strchr(from, ',')) != NULL) {
+		size_t len = comma - from;
+		switch(ulogd_parse_addr(from, len, &addr)) {
+			case AF_INET:
+				nfct_add_to_filter(filter, &addr, AF_INET, dir);
+				has_ipv4 = 1;
+				break;
+			case AF_INET6:
+				nfct_add_to_filter(filter, &addr, AF_INET6, dir);
+				has_ipv6 = 1;
+				break;
+			default:
+				return -1;
+		}
+		from += len + 1;
+	}
+	switch(ulogd_parse_addr(from, strlen(from), &addr)) {
+		case AF_INET:
+			nfct_add_to_filter(filter, &addr, AF_INET, dir);
+			has_ipv4 = 1;
+			break;
+		case AF_INET6:
+			nfct_add_to_filter(filter, &addr, AF_INET6, dir);
+			has_ipv6 = 1;
+			break;
+		default:
+			return -1;
+	}
+
+	if (!has_ipv6) {
+		struct nfct_filter_ipv6 filter_ipv6;
+		int filter_dir_ipv4;
+		int filter_dir_ipv6;
+		if (nfct_set_dir(dir, &filter_dir_ipv4, &filter_dir_ipv6) == -1)
+			return -1;
+		nfct_filter_set_logic(filter,
+				filter_dir_ipv6,
+				NFCT_FILTER_LOGIC_NEGATIVE);
+		nfct_filter_add_attr(filter, filter_dir_ipv6,
+				&filter_ipv6);
+	}
+	if (!has_ipv4) {
+		struct nfct_filter_ipv4 filter_ipv4;
+		int filter_dir_ipv4;
+		int filter_dir_ipv6;
+		if (nfct_set_dir(dir, &filter_dir_ipv4, &filter_dir_ipv6) == -1)
+			return -1;
+		nfct_filter_set_logic(filter,
+				filter_dir_ipv4,
+				NFCT_FILTER_LOGIC_NEGATIVE);
+		nfct_filter_add_attr(filter, filter_dir_ipv4,
+				&filter_ipv4);
+	}
+
+	return 0;
+}
+
+static int build_nfct_filter(struct ulogd_pluginstance *upi)
+{
+	struct nfct_pluginstance *cpi =
+			(struct nfct_pluginstance *)upi->private;
+	struct nfct_filter *filter = NULL;
+
+	if (!cpi->cth) {
+		ulogd_log(ULOGD_FATAL, "Refusing to attach NFCT filter to NULL handler\n");
+		goto err_init;
+	}
+
+	filter = nfct_filter_create();
+	if (!filter) {
+		ulogd_log(ULOGD_FATAL, "error creating NFCT filter\n");
+		goto err_init;
+	}
+
+	if (strlen(src_filter_ce(upi->config_kset).u.string) != 0) {
+		char *filter_string = src_filter_ce(upi->config_kset).u.string;
+		if (build_nfct_filter_dir(filter, filter_string, NFCT_SRC_DIR) != 0) {
+			ulogd_log(ULOGD_FATAL,
+					"Unable to create src filter\n");
+			goto err_filter;
+		}
+	}
+	if (strlen(dst_filter_ce(upi->config_kset).u.string) != 0) {
+		char *filter_string = dst_filter_ce(upi->config_kset).u.string;
+		if (build_nfct_filter_dir(filter, filter_string, NFCT_DST_DIR) != 0) {
+			ulogd_log(ULOGD_FATAL,
+					"Unable to create dst filter\n");
+			goto err_filter;
+		}
+	}
+
+	if (filter) {
+		if (nfct_filter_attach(nfct_fd(cpi->cth), filter) == -1) {
+			ulogd_log(ULOGD_FATAL, "nfct_filter_attach");
+		}
+
+		/* release the filter object, this does not detach the filter */
+		nfct_filter_destroy(filter);
+	}
+
+	return 0;
+
+err_filter:
+	nfct_filter_destroy(filter);
+err_init:
+	return -1;
+}
+
 static int constructor_nfct_events(struct ulogd_pluginstance *upi)
 {
 	struct nfct_pluginstance *cpi =
 			(struct nfct_pluginstance *)upi->private;
 
+
 	cpi->cth = nfct_open(NFNL_SUBSYS_CTNETLINK,
 			     eventmask_ce(upi->config_kset).u.value);
 	if (!cpi->cth) {
@@ -1005,9 +1207,19 @@ static int constructor_nfct_events(struct ulogd_pluginstance *upi)
 		goto err_cth;
 	}
 
+	if ((strlen(src_filter_ce(upi->config_kset).u.string) != 0) ||
+			(strlen(dst_filter_ce(upi->config_kset).u.string) != 0)
+	   ) {
+		if (build_nfct_filter(upi) != 0) {
+			ulogd_log(ULOGD_FATAL, "error creating NFCT filter\n");
+			goto err_cth;
+		}
+	}
+
+
 	if (usehash_ce(upi->config_kset).u.value != 0) {
 		nfct_callback_register(cpi->cth, NFCT_T_ALL,
-				       &event_handler_hashtable, upi);
+				&event_handler_hashtable, upi);
 	} else {
 		nfct_callback_register(cpi->cth, NFCT_T_ALL,
 				       &event_handler_no_hashtable, upi);
diff --git a/ulogd.conf.in b/ulogd.conf.in
index 6aff802..fa1fbf2 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -125,6 +125,10 @@ plugin="@pkglibdir@/ulogd_output_GRAPHITE.so"
 #netlink_socket_buffer_maxsize=1085440
 #netlink_resync_timeout=60 # seconds to wait to perform resynchronization
 #pollinterval=10 # use poll-based logging instead of event-driven
+# If pollinterval is not set, NFCT plugin will work in event mode
+# In this case, you can use the following filters on events:
+#accept_src_filter=192.168.1.0/24,1:2::/64 # source ip of connection must belong to these networks
+#accept_dst_filter=192.168.1.0/24 # destination ip of connection must belong to these networks
 
 [ct2]
 #netlink_socket_buffer_size=217088
-- 
1.7.10.4

