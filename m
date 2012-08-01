From: Eric Leblond <eric@regit.org>
Subject: [RFC ulogd PATCH] nfct: implement src and dst filter
Date: Wed,  1 Aug 2012 23:33:29 +0200
Message-ID: <1343856809-11585-2-git-send-email-eric@regit.org>
References: <1343856809-11585-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:49565 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938Ab2HAVeh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Aug 2012 17:34:37 -0400
In-Reply-To: <1343856809-11585-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch implements two filtering options in NFCT input plugin.
If 'src_filter' is set to a network it will only catch the event
where the source is that specific network. 'dst_filter' does the
same for the destination. The filters are simple and does only
accept one network at a time. Multiple networks can be handled by
using multiple stacks. To handle connection from and to a network,
two stacks are needed too.
---
 input/flow/ulogd_inpflow_NFCT.c |  239 ++++++++++++++++++++++++++++++++++++++-
 ulogd.conf.in                   |    2 +
 2 files changed, 239 insertions(+), 2 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index dcba58f..49ff66e 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -33,6 +33,10 @@
 #include <string.h>
 #include <errno.h>
 
+#include <sys/socket.h>
+#include <netinet/in.h>
+#include <arpa/inet.h>
+
 #include <sys/time.h>
 #include <time.h>
 #include <netinet/in.h>
@@ -72,7 +76,7 @@ struct nfct_pluginstance {
 #define EVENT_MASK	NF_NETLINK_CONNTRACK_NEW | NF_NETLINK_CONNTRACK_DESTROY
 
 static struct config_keyset nfct_kset = {
-	.num_ces = 9,
+	.num_ces = 11,
 	.ces = {
 		{
 			.key	 = "pollinterval",
@@ -128,6 +132,16 @@ static struct config_keyset nfct_kset = {
 			.options = CONFIG_OPT_NONE,
 			.u.value = 0,
 		},
+		{
+			.key	 = "src_filter",
+			.type	 = CONFIG_TYPE_STRING,
+			.options = CONFIG_OPT_NONE,
+		},
+		{
+			.key	 = "dst_filter",
+			.type	 = CONFIG_TYPE_STRING,
+			.options = CONFIG_OPT_NONE,
+		},
 	},
 };
 #define pollint_ce(x)	(x->ces[0])
@@ -139,6 +153,8 @@ static struct config_keyset nfct_kset = {
 #define nlsockbufmaxsize_ce(x) (x->ces[6])
 #define nlresynctimeout_ce(x) (x->ces[7])
 #define reliable_ce(x)	(x->ces[8])
+#define src_filter_ce(x)	((x)->ces[9])
+#define dst_filter_ce(x)	((x)->ces[10])
 
 enum nfct_keys {
 	NFCT_ORIG_IP_SADDR = 0,
@@ -995,10 +1011,54 @@ static void overrun_timeout(struct ulogd_timer *a, void *data)
 	nfct_send(cpi->ovh, NFCT_Q_DUMP, &family);
 }
 
+static u_int32_t bits2netmask(int bits)
+{
+	u_int32_t netmask, bm;
+
+	if (bits >= 32 || bits < 0)
+		return(~0);
+	for (netmask = 0, bm = 0x80000000; bits; bits--, bm >>= 1)
+		netmask |= bm;
+	return netmask;
+}
+
+
+static void ipv6_cidr2mask_host(uint8_t cidr, uint32_t *res)
+{
+	int i, j;
+
+	memset(res, 0, sizeof(uint32_t)*4);
+	for (i = 0;  i < 4 && cidr > 32; i++) {
+		res[i] = 0xFFFFFFFF;
+		cidr -= 32;
+	}
+	res[i] = 0xFFFFFFFF << (32 - cidr);
+	for (j = i+1; j < 4; j++) {
+		res[j] = 0;
+	}
+}
+
+/* I need this function because I initially defined an IPv6 address as
+ * uint32 u[4]. Using char u[16] instead would allow to remove this. */
+static void ipv6_addr2addr_host(uint32_t *addr, uint32_t *res)
+{
+	int i;
+
+	memset(res, 0, sizeof(uint32_t)*4);
+	for (i = 0;  i < 4; i++) {
+		res[i] = ntohl(addr[i]);
+	}
+}
+
 static int constructor_nfct_events(struct ulogd_pluginstance *upi)
 {
 	struct nfct_pluginstance *cpi =
 			(struct nfct_pluginstance *)upi->private;
+	char filter_addr[128];
+	uint32_t faddr[4];
+	int netmask;
+	char *slash;
+	struct nfct_filter *filter = NULL;
 
 	cpi->cth = nfct_open(NFNL_SUBSYS_CTNETLINK,
 			     eventmask_ce(upi->config_kset).u.value);
@@ -1007,9 +1067,184 @@ static int constructor_nfct_events(struct ulogd_pluginstance *upi)
 		goto err_cth;
 	}
 
+	if ((strlen(src_filter_ce(upi->config_kset).u.string) != 0) ||
+	     (strlen(dst_filter_ce(upi->config_kset).u.string) != 0)
+	   ) {
+		ulogd_log(ULOGD_NOTICE, "adding filter: \"%s\"\n",
+				src_filter_ce(upi->config_kset).u.string
+			 );
+		filter = nfct_filter_create();
+		if (!filter) {
+			ulogd_log(ULOGD_FATAL, "error creating NFCT filter\n");
+			goto err_cth;
+		}
+
+	}
+
+	if (strlen(src_filter_ce(upi->config_kset).u.string) != 0) {
+		char *filter_string = src_filter_ce(upi->config_kset).u.string;
+		if (strchr(filter_string, ':')) {
+			struct nfct_filter_ipv6 src_filter_ipv6;
+			struct nfct_filter_ipv4 src_filter_ipv4;
+
+			slash = strchr(filter_string, '/');
+			if (slash == NULL) {
+				ulogd_log(ULOGD_FATAL,
+					  "No network specified\n");
+				goto err_cth;
+			}
+
+			strncpy(filter_addr, filter_string,
+				slash - filter_string);
+			filter_addr[slash - filter_string] = 0;
+			if (inet_pton(AF_INET6, filter_addr, (void *)faddr)
+				!= 1) {
+				ulogd_log(ULOGD_FATAL,
+					  "error reading address\n");
+				goto err_cth;
+			}
+			netmask = atoi(slash + 1);
+			/* BSF always wants data in host-byte order */
+			ipv6_addr2addr_host(faddr, src_filter_ipv6.addr);
+			ipv6_cidr2mask_host(netmask, src_filter_ipv6.mask);
+
+			nfct_filter_set_logic(filter,
+					NFCT_FILTER_SRC_IPV6,
+					NFCT_FILTER_LOGIC_POSITIVE);
+			nfct_filter_add_attr(filter,
+					     NFCT_FILTER_SRC_IPV6,
+					     &src_filter_ipv6);
+
+			nfct_filter_set_logic(filter,
+					NFCT_FILTER_SRC_IPV4,
+					NFCT_FILTER_LOGIC_NEGATIVE);
+			nfct_filter_add_attr(filter,
+					     NFCT_FILTER_SRC_IPV4,
+					     &src_filter_ipv4);
+		} else if (strchr(filter_string, '.')) {
+			struct nfct_filter_ipv6 src_filter_ipv6;
+
+			slash = strchr(filter_string, '/');
+			if (slash == NULL) {
+				ulogd_log(ULOGD_FATAL,
+					  "No network specified\n");
+				goto err_cth;
+			}
+			strncpy(filter_addr, filter_string,
+				slash - filter_string);
+			filter_addr[slash - filter_string] = 0;
+			netmask = atoi(slash + 1);
+			/* BSF always wants data in host-byte order */
+			struct nfct_filter_ipv4 filter_ipv4 = {
+				.addr = ntohl(inet_addr(filter_addr)),
+				.mask = bits2netmask(netmask),
+			};
+
+			nfct_filter_set_logic(filter,
+					      NFCT_FILTER_SRC_IPV4,
+					      NFCT_FILTER_LOGIC_POSITIVE);
+			nfct_filter_add_attr(filter, NFCT_FILTER_SRC_IPV4,
+					     &filter_ipv4);
+
+			nfct_filter_set_logic(filter,
+					      NFCT_FILTER_SRC_IPV6,
+					      NFCT_FILTER_LOGIC_NEGATIVE);
+			nfct_filter_add_attr(filter, NFCT_FILTER_SRC_IPV6,
+					     &src_filter_ipv6);
+		} else {
+			ulogd_log(ULOGD_FATAL,
+				  "filter does not look like an IP\n");
+			goto err_cth;
+		}
+	}
+
+	if (strlen(dst_filter_ce(upi->config_kset).u.string) != 0) {
+		char *filter_string = dst_filter_ce(upi->config_kset).u.string;
+		if (strchr(filter_string, ':')) {
+			struct nfct_filter_ipv6 dst_filter_ipv6;
+			struct nfct_filter_ipv4 dst_filter_ipv4;
+
+			/* handle dest filter */
+			slash = strchr(filter_string, '/');
+			if (slash == NULL) {
+				ulogd_log(ULOGD_FATAL,
+					  "No network specified\n");
+				goto err_cth;
+			}
+			strncpy(filter_addr, filter_string,
+				slash - filter_string);
+			filter_addr[slash - filter_string] = 0;
+			if (inet_pton(AF_INET6, filter_addr,
+				      (void *)&faddr
+				     ) != 1) {
+				ulogd_log(ULOGD_FATAL,
+					  "error reading address\n");
+				goto err_cth;
+			}
+			netmask = atoi(slash + 1);
+			/* BSF always wants data in host-byte order */
+			ipv6_addr2addr_host(faddr, dst_filter_ipv6.addr);
+			ipv6_cidr2mask_host(netmask, dst_filter_ipv6.mask);
+
+			nfct_filter_set_logic(filter,
+					      NFCT_FILTER_DST_IPV6,
+					      NFCT_FILTER_LOGIC_POSITIVE);
+			nfct_filter_add_attr(filter, NFCT_FILTER_DST_IPV6,
+					     &dst_filter_ipv6);
+
+			nfct_filter_set_logic(filter,
+					      NFCT_FILTER_DST_IPV4,
+					      NFCT_FILTER_LOGIC_NEGATIVE);
+			nfct_filter_add_attr(filter, NFCT_FILTER_DST_IPV4,
+					     &dst_filter_ipv4);
+		} else if (strchr(filter_string, '.')) {
+			struct nfct_filter_ipv6 dst_filter_ipv6;
+
+			slash = strchr(filter_string, '/');
+			if (slash == NULL) {
+				ulogd_log(ULOGD_FATAL, "No network specified\n");
+				goto err_cth;
+			}
+			strncpy(filter_addr, filter_string,
+				slash - filter_string);
+			filter_addr[slash - filter_string] = 0;
+			netmask = atoi(slash + 1);
+			/* BSF always wants data in host-byte order */
+			struct nfct_filter_ipv4 filter_ipv4 = {
+				.addr = ntohl(inet_addr(filter_addr)),
+				.mask = bits2netmask(netmask),
+			};
+
+			nfct_filter_set_logic(filter,
+					NFCT_FILTER_DST_IPV4,
+					NFCT_FILTER_LOGIC_POSITIVE);
+			nfct_filter_add_attr(filter, NFCT_FILTER_DST_IPV4,
+					&filter_ipv4);
+
+			nfct_filter_set_logic(filter,
+					NFCT_FILTER_DST_IPV6,
+					NFCT_FILTER_LOGIC_NEGATIVE);
+			nfct_filter_add_attr(filter, NFCT_FILTER_DST_IPV6,
+					&dst_filter_ipv6);
+		} else {
+			ulogd_log(ULOGD_FATAL,
+				  "filter does not look like an IP\n");
+			goto err_cth;
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
 	if (usehash_ce(upi->config_kset).u.value != 0) {
 		nfct_callback_register(cpi->cth, NFCT_T_ALL,
-				       &event_handler_hashtable, upi);
+				&event_handler_hashtable, upi);
 	} else {
 		nfct_callback_register(cpi->cth, NFCT_T_ALL,
 				       &event_handler_no_hashtable, upi);
diff --git a/ulogd.conf.in b/ulogd.conf.in
index e99212f..7167732 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -121,6 +121,8 @@ plugin="@pkglibdir@/ulogd_inpflow_NFACCT.so"
 #netlink_socket_buffer_maxsize=1085440
 #netlink_resync_timeout=60 # seconds to wait to perform resynchronization
 #pollinterval=10 # use poll-based logging instead of event-driven
+#src_filter=192.168.1.0/24 # source ip of connection must belong to this network 
+#dst_filter=192.168.1.0/24 # destination ip of connection must belong to this network 
 
 [ct2]
 #netlink_socket_buffer_size=217088
-- 
1.7.10.4

