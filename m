From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ULOGD 4/4] improve overrun handling NFLOG
Date: Thu, 15 May 2008 15:51:15 +0200
Message-ID: <482C3FD3.7090509@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030707000207020104060707"
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35487 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752982AbYEONvV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 May 2008 09:51:21 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030707000207020104060707
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

[PATCH] improve overrun handling NFLOG

This patch improves the overrun handling. The NFLOG plugin duplicates
the netlink buffer size if the size does not goes after the upper
boundary. This patch also introduces two new clauses, the
netlink_socket_buffer_size and netlink_socket_buffer_maxsize that set
the size of the netlink socket buffer.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------030707000207020104060707
Content-Type: text/x-patch;
 name="03nflog.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03nflog.patch"

[PATCH] improve overrun handling NFLOG

This patch improves the overrun handling. The NFLOG plugin duplicates the
netlink buffer size if the size does not goes after the upper boundary.
This patch also introduces two new clauses, the netlink_socket_buffer_size
and netlink_socket_buffer_maxsize that set the size of the netlink socket
buffer.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: ulogd2/input/packet/ulogd_inppkt_NFLOG.c
===================================================================
--- ulogd2.orig/input/packet/ulogd_inppkt_NFLOG.c	2008-05-15 14:42:18.000000000 +0200
+++ ulogd2/input/packet/ulogd_inppkt_NFLOG.c	2008-05-15 14:58:29.000000000 +0200
@@ -6,8 +6,10 @@
 #include <unistd.h>
 #include <stdlib.h>
 #include <netinet/in.h>
+#include <errno.h>
 
 #include <ulogd/ulogd.h>
+#include <libnfnetlink/libnfnetlink.h>
 #include <libnetfilter_log/libnetfilter_log.h>
 
 #ifndef NFLOG_GROUP_DEFAULT
@@ -29,12 +31,13 @@ struct nflog_input {
 	struct nflog_g_handle *nful_gh;
 	unsigned char *nfulog_buf;
 	struct ulogd_fd nful_fd;
+	int nlbufsiz;
 };
 
 /* configuration entries */
 
 static struct config_keyset libulog_kset = {
-	.num_ces = 8,
+	.num_ces = 10,
 	.ces = {
 		{
 			.key 	 = "bufsize",
@@ -84,7 +87,18 @@ static struct config_keyset libulog_kset
 			.options = CONFIG_OPT_NONE,
 			.u.value = 0,
 		},
-
+		{
+			.key     = "netlink_socket_buffer_size",
+			.type    = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u.value = 0,
+		},
+		{
+			.key     = "netlink_socket_buffer_maxsize",
+			.type    = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u.value = 0,
+		},
 	}
 };
 
@@ -96,6 +110,8 @@ static struct config_keyset libulog_kset
 #define seq_ce(x)	(x->ces[5])
 #define seq_global_ce(x)	(x->ces[6])
 #define label_ce(x)	(x->ces[7])
+#define nlsockbufsize_ce(x) (x->ces[8])
+#define nlsockbufmaxsize_ce(x) (x->ces[9])
 
 enum nflog_keys {
 	NFLOG_KEY_RAW_MAC = 0,
@@ -371,6 +387,23 @@ interp_packet(struct ulogd_pluginstance 
 	return 0;
 }
 
+static int setnlbufsiz(struct ulogd_pluginstance *upi, int size)
+{
+	struct nflog_input *ui = (struct nflog_input *)upi->private;
+
+	if (size < nlsockbufmaxsize_ce(upi->config_kset).u.value) {
+		ui->nlbufsiz = nfnl_rcvbufsiz(nflog_nfnlh(ui->nful_h), size);
+		return 1;
+	}
+
+	ulogd_log(ULOGD_NOTICE, "Maximum buffer size (%d) in NFLOG has been "
+				"reached. Please, consider rising "
+				"`netlink_socket_buffer_size` and "
+				"`netlink_socket_buffer_maxsize` "
+				"clauses.", ui->nlbufsiz);
+	return 0;
+}
+
 /* callback called from ulogd core when fd is readable */
 static int nful_read_cb(int fd, unsigned int what, void *param)
 {
@@ -385,8 +418,26 @@ static int nful_read_cb(int fd, unsigned
 	 * grab all the processing time just for us.  there might be other
 	 * sockets that have pending work */
 	len = recv(fd, ui->nfulog_buf, bufsiz_ce(upi->config_kset).u.value, 0);
-	if (len < 0)
+	if (len < 0) {
+		if (errno == ENOBUFS) {
+			if (nlsockbufmaxsize_ce(upi->config_kset).u.value) {
+				int s = ui->nlbufsiz * 2;
+				if (setnlbufsiz(upi, s)) {
+					ulogd_log(ULOGD_NOTICE,
+						  "We are losing events, "
+						  "increasing buffer size "
+						  "to %d\n", ui->nlbufsiz);
+				}
+			} else {
+				ulogd_log(ULOGD_NOTICE,
+					  "We are losing events. Please, "
+					  "consider using the clauses "
+					  "`netlink_socket_buffer_size' and "
+					  "`netlink_socket_buffer_maxsize'");
+			}
+		}
 		return len;
+	}
 
 	nflog_handle_packet(ui->nful_h, (char *)ui->nfulog_buf, len);
 
@@ -468,9 +519,12 @@ static int start(struct ulogd_pluginstan
 
 	nflog_set_mode(ui->nful_gh, NFULNL_COPY_PACKET, 0xffff);
 
-	//nflog_set_nlbufsiz(&ui->nful_gh, );
-	//nfnl_set_rcvbuf();
-	
+	if (nlsockbufsize_ce(upi->config_kset).u.value) {
+		setnlbufsiz(upi, nlsockbufsize_ce(upi->config_kset).u.value);
+		ulogd_log(ULOGD_NOTICE, "NFLOG netlink buffer size has been "
+					"set to %d\n", ui->nlbufsiz);
+	}
+
 	/* set log flags based on configuration */
 	flags = 0;
 	if (seq_ce(upi->config_kset).u.value != 0)
Index: ulogd2/ulogd.conf.in
===================================================================
--- ulogd2.orig/ulogd.conf.in	2008-05-15 14:51:13.000000000 +0200
+++ ulogd2/ulogd.conf.in	2008-05-15 14:51:28.000000000 +0200
@@ -94,6 +94,8 @@ plugin="@libdir@/ulogd/ulogd_raw2packet_
 [log1]
 # netlink multicast group (the same as the iptables --nflog-group param)
 group=0
+#netlink_socket_buffer_size=217088
+#netlink_socket_buffer_maxsize=1085440
 
 # IPv6 logging through NFLOG
 [log2]

--------------030707000207020104060707--
