From: Pierre Chifflier <chifflier@inl.fr>
Subject: [PATCH 2/3] Add new input plugin UNIXSOCK
Date: Thu,  3 Sep 2009 23:23:24 +0200
Message-ID: <1252013004-9029-2-git-send-email-chifflier@inl.fr>
References: <alpine.LSU.2.00.0908240031330.30556@fbirervta.pbzchgretzou.qr>
Cc: eleblond@inl.fr, Pierre Chifflier <chifflier@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:46958 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756343AbZICV1X (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Sep 2009 17:27:23 -0400
Received: from smtp1-g21.free.fr (localhost [127.0.0.1])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 38493940165
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2009 23:27:19 +0200 (CEST)
Received: from fydelkass.edenwall.com (fydelkass.inl.fr [88.171.131.12])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 23423940161
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2009 23:27:17 +0200 (CEST)
In-Reply-To: <alpine.LSU.2.00.0908240031330.30556@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This input plugins creates a unix socket which can be used to log packets.
Scripts or applications can connect to the socket (only one client allowed
per socket) and send data in a Key-Length-Value format (including the
payload).

Signed-off-by: Pierre Chifflier <chifflier@inl.fr>
---
 input/packet/Makefile.am             |    5 +-
 input/packet/ulogd_inppkt_UNIXSOCK.c |  694 ++++++++++++++++++++++++++++++++++
 ulogd.conf.in                        |    7 +
 3 files changed, 705 insertions(+), 1 deletions(-)
 create mode 100644 input/packet/ulogd_inppkt_UNIXSOCK.c

diff --git a/input/packet/Makefile.am b/input/packet/Makefile.am
index e90e46e..566b817 100644
--- a/input/packet/Makefile.am
+++ b/input/packet/Makefile.am
@@ -3,7 +3,7 @@ AM_CPPFLAGS = $(all_includes) -I$(top_srcdir)/include
 AM_CFLAGS=-fPIC -Wall
 LIBS=
 
-pkglib_LTLIBRARIES = ulogd_inppkt_NFLOG.la ulogd_inppkt_ULOG.la
+pkglib_LTLIBRARIES = ulogd_inppkt_NFLOG.la ulogd_inppkt_ULOG.la ulogd_inppkt_UNIXSOCK.la
 
 ulogd_inppkt_NFLOG_la_SOURCES = ulogd_inppkt_NFLOG.c
 ulogd_inppkt_NFLOG_la_LDFLAGS = -avoid-version -module $(LIBNETFILTER_LOG_LIBS)
@@ -12,3 +12,6 @@ ulogd_inppkt_NFLOG_la_CFLAGS = $(AM_CFLAGS) $(LIBNETFILTER_LOG_CFLAGS)
 ulogd_inppkt_ULOG_la_SOURCES = ulogd_inppkt_ULOG.c
 ulogd_inppkt_ULOG_la_LDFLAGS = -avoid-version -module
 ulogd_inppkt_ULOG_la_LIBADD = ../../libipulog/libipulog.la
+
+ulogd_inppkt_UNIXSOCK_la_SOURCES = ulogd_inppkt_UNIXSOCK.c
+ulogd_inppkt_UNIXSOCK_la_LDFLAGS = -avoid-version -module
diff --git a/input/packet/ulogd_inppkt_UNIXSOCK.c b/input/packet/ulogd_inppkt_UNIXSOCK.c
new file mode 100644
index 0000000..9720784
--- /dev/null
+++ b/input/packet/ulogd_inppkt_UNIXSOCK.c
@@ -0,0 +1,694 @@
+/*
+ ** Copyright(C) 2008-2009 INL
+ ** Written by  Pierre Chifflier <chifflier@inl.fr>
+*/
+
+#include <unistd.h>
+#include <stdlib.h>
+#include <netinet/in.h>
+#include <netinet/ip.h>
+#include <netinet/ip6.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <sys/un.h>
+#include <errno.h>
+
+#include <ulogd/ulogd.h>
+
+/* Default size of the receive buffer for the unix socket
+   0 means that ulogd will use getsockopt(SO_RCVBUF) to determine it
+   at runtime */
+#define UNIXSOCK_BUFSIZE_DEFAULT	0
+
+/* Default unix socket path */
+#define UNIXSOCK_UNIXPATH_DEFAULT	"/tmp/ulogd2.sock"
+
+
+#define UNIX_PATH_MAX	108
+
+
+struct unixsock_input {
+	char *path;
+	char *unixsock_buf;
+	unsigned int unixsock_buf_avail;
+	unsigned int unixsock_buf_size;
+	struct ulogd_fd unixsock_server_fd;
+	struct ulogd_fd unixsock_instance_fd;
+};
+
+enum nflog_keys {
+	UNIXSOCK_KEY_RAW_MAC = 0,
+	UNIXSOCK_KEY_RAW_PCKT,
+	UNIXSOCK_KEY_RAW_PCKTLEN,
+	UNIXSOCK_KEY_RAW_PCKTCOUNT,
+	UNIXSOCK_KEY_OOB_PREFIX,
+	UNIXSOCK_KEY_OOB_TIME_SEC,
+	UNIXSOCK_KEY_OOB_TIME_USEC,
+	UNIXSOCK_KEY_OOB_MARK,
+	UNIXSOCK_KEY_OOB_IN,
+	UNIXSOCK_KEY_OOB_OUT,
+	UNIXSOCK_KEY_OOB_HOOK,
+	UNIXSOCK_KEY_RAW_MAC_LEN,
+	UNIXSOCK_KEY_OOB_SEQ_LOCAL,
+	UNIXSOCK_KEY_OOB_SEQ_GLOBAL,
+	UNIXSOCK_KEY_OOB_FAMILY,
+	UNIXSOCK_KEY_OOB_PROTOCOL,
+	UNIXSOCK_KEY_OOB_UID,
+	UNIXSOCK_KEY_OOB_GID,
+	UNIXSOCK_KEY_RAW_LABEL,
+	UNIXSOCK_KEY_RAW_TYPE,
+	UNIXSOCK_KEY_RAW_MAC_SADDR,
+	UNIXSOCK_KEY_RAW_MAC_ADDRLEN,
+	UNIXSOCK_KEY_NUFW_USER_NAME,
+	UNIXSOCK_KEY_NUFW_USER_ID,
+	UNIXSOCK_KEY_NUFW_OS_NAME,
+	UNIXSOCK_KEY_NUFW_OS_REL,
+	UNIXSOCK_KEY_NUFW_OS_VERS,
+	UNIXSOCK_KEY_NUFW_APP_NAME,
+};
+
+static struct ulogd_key output_keys[] = {
+	[UNIXSOCK_KEY_RAW_MAC] = {
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw.mac",
+	},
+	[UNIXSOCK_KEY_RAW_MAC_SADDR] = {
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw.mac.saddr",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = IPFIX_sourceMacAddress,
+		},
+	},
+	[UNIXSOCK_KEY_RAW_PCKT] = {
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw.pkt",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_NETFILTER,
+			.field_id = IPFIX_NF_rawpacket,
+		},
+	},
+	[UNIXSOCK_KEY_RAW_PCKTLEN] = {
+		.type = ULOGD_RET_UINT32,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw.pktlen",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_NETFILTER,
+			.field_id = IPFIX_NF_rawpacket_length,
+		},
+	},
+	[UNIXSOCK_KEY_RAW_PCKTCOUNT] = {
+		.type = ULOGD_RET_UINT32,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw.pktcount",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = IPFIX_packetDeltaCount,
+		},
+	},
+	[UNIXSOCK_KEY_OOB_PREFIX] = {
+		.type = ULOGD_RET_STRING,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.prefix",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_NETFILTER,
+			.field_id = IPFIX_NF_prefix,
+		},
+	},
+	[UNIXSOCK_KEY_OOB_TIME_SEC] = {
+		.type = ULOGD_RET_UINT32,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.time.sec",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = IPFIX_flowStartSeconds,
+		},
+	},
+	[UNIXSOCK_KEY_OOB_TIME_USEC] = {
+		.type = ULOGD_RET_UINT32,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.time.usec",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = IPFIX_flowStartMicroSeconds,
+		},
+	},
+	[UNIXSOCK_KEY_OOB_MARK] = {
+		.type = ULOGD_RET_UINT32,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.mark",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_NETFILTER,
+			.field_id = IPFIX_NF_mark,
+		},
+	},
+	[UNIXSOCK_KEY_OOB_IN] = {
+		.type = ULOGD_RET_STRING,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.in",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = IPFIX_ingressInterface,
+		},
+	},
+	[UNIXSOCK_KEY_OOB_OUT] = {
+		.type = ULOGD_RET_STRING,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.out",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = IPFIX_egressInterface,
+		},
+	},
+	[UNIXSOCK_KEY_OOB_HOOK] = {
+		.type = ULOGD_RET_UINT8,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.hook",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_NETFILTER,
+			.field_id = IPFIX_NF_hook,
+		},
+	},
+	[UNIXSOCK_KEY_RAW_MAC_LEN] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw.mac_len",
+	},
+	[UNIXSOCK_KEY_RAW_MAC_ADDRLEN] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw.mac.addrlen",
+	},
+
+	[UNIXSOCK_KEY_OOB_SEQ_LOCAL] = {
+		.type = ULOGD_RET_UINT32,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.seq.local",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_NETFILTER,
+			.field_id = IPFIX_NF_seq_local,
+		},
+	},
+	[UNIXSOCK_KEY_OOB_SEQ_GLOBAL] = {
+		.type = ULOGD_RET_UINT32,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.seq.global",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_NETFILTER,
+			.field_id = IPFIX_NF_seq_global,
+		},
+	},
+	[UNIXSOCK_KEY_OOB_FAMILY] = {
+		.type = ULOGD_RET_UINT8,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.family",
+	},
+	[UNIXSOCK_KEY_OOB_PROTOCOL] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.protocol",
+	},
+	[UNIXSOCK_KEY_OOB_UID] = {
+		.type = ULOGD_RET_UINT32,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.uid",
+	},
+	[UNIXSOCK_KEY_OOB_GID] = {
+		.type = ULOGD_RET_UINT32,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.gid",
+	},
+	[UNIXSOCK_KEY_RAW_LABEL] = {
+		.type = ULOGD_RET_UINT8,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw.label",
+	},
+	[UNIXSOCK_KEY_RAW_TYPE] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw.type",
+	},
+	[UNIXSOCK_KEY_NUFW_USER_NAME] = {
+		.type = ULOGD_RET_STRING,
+		.flags = ULOGD_RETF_NONE,
+		.name = "nufw.user.name",
+	},
+	[UNIXSOCK_KEY_NUFW_USER_ID] = {
+		.type = ULOGD_RET_UINT32,
+		.flags = ULOGD_RETF_NONE,
+		.name = "nufw.user.id",
+	},
+	[UNIXSOCK_KEY_NUFW_OS_NAME] = {
+		.type = ULOGD_RET_STRING,
+		.flags = ULOGD_RETF_NONE,
+		.name = "nufw.os.name",
+	},
+	[UNIXSOCK_KEY_NUFW_OS_REL] = {
+		.type = ULOGD_RET_STRING,
+		.flags = ULOGD_RETF_NONE,
+		.name = "nufw.os.rel",
+	},
+	[UNIXSOCK_KEY_NUFW_OS_VERS] = {
+		.type = ULOGD_RET_STRING,
+		.flags = ULOGD_RETF_NONE,
+		.name = "nufw.os.vers",
+	},
+	[UNIXSOCK_KEY_NUFW_APP_NAME] = {
+		.type = ULOGD_RET_STRING,
+		.flags = ULOGD_RETF_NONE,
+		.name = "nufw.app.name",
+	},
+};
+
+static struct config_keyset libunixsock_kset = {
+	.num_ces = 2,
+	.ces = {
+		{
+			.key 	 = "socket_path",
+			.type 	 = CONFIG_TYPE_STRING,
+			.options = CONFIG_OPT_NONE,
+			.u.string = UNIXSOCK_UNIXPATH_DEFAULT,
+		},
+		{
+			.key 	 = "bufsize",
+			.type 	 = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u.value = UNIXSOCK_BUFSIZE_DEFAULT,
+		},
+	},
+};
+
+#define unixpath_ce(x)		(x->ces[0])
+#define bufsize_ce(x)		(x->ces[1])
+
+
+enum ulogd2_option_type {
+	ULOGD2_OPT_UNUSED = 0,
+	ULOGD2_OPT_PREFIX,	/* log prefix (string) */
+	ULOGD2_OPT_OOB_IN,	/* input device (string) */
+	ULOGD2_OPT_OOB_OUT,	/* output device (string) */
+	ULOGD2_OPT_OOB_TIME_SEC,	/* packet arrival time (u_int32_t) */
+
+	ULOGD2_OPT_USER=200,	/* user name (string) */
+	ULOGD2_OPT_USERID,	/* user id (u_int32_t) */
+	ULOGD2_OPT_OSNAME,	/* OS name (string) */
+	ULOGD2_OPT_OSREL,	/* OS release (string) */
+	ULOGD2_OPT_OSVERS,	/* OS version (string) */
+	ULOGD2_OPT_APPNAME,	/* application name (string) */
+	ULOGD2_OPT_STATE,	/* connection state: 0 (drop), 1 (open), 2 (established), 3 (close), 4 (unknown) */
+};
+
+static int handle_packet(struct ulogd_pluginstance *upi, u_int16_t total_len)
+{
+	struct unixsock_input *ui = (struct unixsock_input *)upi->private;
+	char *data;
+	struct iphdr *ip;
+	struct ulogd_key *ret = upi->output.keys;
+	u_int8_t oob_family;
+	u_int16_t payload_len;
+	u_int16_t option_number;
+	u_int16_t option_length;
+	char *buf;
+
+	ulogd_log(ULOGD_DEBUG,
+			"ulogd2: handling packet\n");
+
+	data = ui->unixsock_buf + sizeof(u_int16_t);
+	payload_len = ntohs(*(u_int16_t*)data);
+	data += sizeof(u_int16_t);
+
+
+	ip = (struct iphdr *) data;
+
+	if (ip->version == 4)
+		oob_family = AF_INET;
+	else if (ip->version == 6)
+		oob_family = AF_INET6;
+	else oob_family = 0;
+
+	okey_set_u8(&ret[UNIXSOCK_KEY_OOB_FAMILY], oob_family);
+
+	okey_set_ptr(&ret[UNIXSOCK_KEY_RAW_PCKT], ip);
+	okey_set_u32(&ret[UNIXSOCK_KEY_RAW_PCKTLEN], payload_len);
+
+	/* options */
+	if (total_len > payload_len + sizeof(u_int16_t)) {
+		data = ui->unixsock_buf + payload_len + 2*sizeof(u_int16_t);
+
+		while ( (data - ui->unixsock_buf) < total_len) {
+
+			option_number = ntohs(*(u_int16_t*)(data));
+			data += sizeof(u_int16_t);
+			option_length = ntohs(*(u_int16_t*)(data));
+			data += sizeof(u_int16_t);
+			buf = data;
+			data += option_length;
+
+			ulogd_log(ULOGD_DEBUG,
+					"ulogd2: option %d (len %d) `%s'\n",
+					option_number, option_length, buf);
+
+			switch(option_number) {
+				case ULOGD2_OPT_PREFIX:
+					okey_set_ptr(&ret[UNIXSOCK_KEY_OOB_PREFIX], buf);
+					break;
+				case ULOGD2_OPT_OOB_IN:
+					okey_set_ptr(&ret[UNIXSOCK_KEY_OOB_IN], buf);
+					break;
+				case ULOGD2_OPT_OOB_OUT:
+					okey_set_ptr(&ret[UNIXSOCK_KEY_OOB_OUT], buf);
+					break;
+				case ULOGD2_OPT_OOB_TIME_SEC:
+					okey_set_u32(&ret[UNIXSOCK_KEY_OOB_TIME_SEC], *(u_int32_t*)buf);
+					break;
+				case ULOGD2_OPT_USER:
+					okey_set_ptr(&ret[UNIXSOCK_KEY_NUFW_USER_NAME], buf);
+					break;
+				case ULOGD2_OPT_USERID:
+					okey_set_u32(&ret[UNIXSOCK_KEY_NUFW_USER_ID], *(u_int32_t*)buf);
+					break;
+				case ULOGD2_OPT_OSNAME:
+					okey_set_ptr(&ret[UNIXSOCK_KEY_NUFW_OS_NAME], buf);
+					break;
+				case ULOGD2_OPT_OSREL:
+					okey_set_ptr(&ret[UNIXSOCK_KEY_NUFW_OS_REL], buf);
+					break;
+				case ULOGD2_OPT_OSVERS:
+					okey_set_ptr(&ret[UNIXSOCK_KEY_NUFW_OS_VERS], buf);
+					break;
+				case ULOGD2_OPT_APPNAME:
+					okey_set_ptr(&ret[UNIXSOCK_KEY_NUFW_APP_NAME], buf);
+					break;
+				case ULOGD2_OPT_STATE:
+					okey_set_u8(&ret[UNIXSOCK_KEY_RAW_LABEL], *(u_int8_t*)buf);
+					break;
+				default:
+					ulogd_log(ULOGD_NOTICE,
+							"ulogd2: unknown option %d\n",
+							option_number);
+					break;
+			};
+		}
+	}
+
+	/* number of packets */
+	okey_set_u32(&ret[UNIXSOCK_KEY_RAW_PCKTCOUNT], 1);
+
+	ulogd_propagate_results(upi);
+
+	/* consume data */
+	ui->unixsock_buf_avail -= total_len;
+	if (ui->unixsock_buf_avail > 0) {
+		/* we need to shift data .. */
+		memmove(ui->unixsock_buf,
+			ui->unixsock_buf + total_len ,
+			ui->unixsock_buf_avail);
+	}
+
+	return 0;
+}
+
+static int _create_unix_socket(const char *unix_path)
+{
+	int ret = -1;
+	struct sockaddr_un server_sock;
+	int s;
+
+	s = socket(AF_UNIX, SOCK_STREAM, 0);
+	if (s < 0)
+		return -1;
+
+	server_sock.sun_family = AF_UNIX;
+	strncpy(server_sock.sun_path, unix_path, sizeof(server_sock.sun_path));
+	server_sock.sun_path[sizeof(server_sock.sun_path)-1] = '\0';
+
+	/* remove existing socket, if any */
+	unlink(unix_path);
+
+	ret = bind(s, (struct sockaddr *)&server_sock, sizeof(server_sock));
+	if (ret < 0) {
+		ulogd_log(ULOGD_ERROR,
+				"ulogd2: could not bind to unix socket \'%s\'\n",
+				server_sock.sun_path);
+		close(s);
+		return -1;
+	}
+
+	ret = listen(s, 10);
+	if (ret < 0) {
+		ulogd_log(ULOGD_ERROR,
+				"ulogd2: could not bind to unix socket \'%s\'\n",
+				server_sock.sun_path);
+		close(s);
+		return -1;
+	}
+
+
+	return s;
+}
+
+/* warning: this code is NOT reentrant ! */
+static void _timer_unregister_cb(struct ulogd_timer *a, void *param)
+{
+	struct unixsock_input *ui = param;
+
+	if (ui->unixsock_instance_fd.fd >= 0) {
+		ulogd_log(ULOGD_DEBUG, "  removing client from list\n");
+		ulogd_unregister_fd(&ui->unixsock_instance_fd);
+		close(ui->unixsock_instance_fd.fd);
+		ui->unixsock_instance_fd.fd = -1;
+	}
+}
+
+/* callback called from ulogd core when fd is readable */
+static int unixsock_instance_read_cb(int fd, unsigned int what, void *param)
+{
+	struct ulogd_pluginstance *upi = param;
+	struct unixsock_input *ui = (struct unixsock_input*)upi->private;
+	int len;
+	u_int16_t needed_len;
+
+	char buf[4096];
+
+	if (!(what & ULOGD_FD_READ))
+		return 0;
+
+	len = read(fd, buf, sizeof(buf));
+	if (len < 0) {
+		ulogd_log(ULOGD_NOTICE, "  read returned %d, errno is %d (%s)\n",
+					len, errno, strerror(errno));
+		exit(-1);
+		return len;
+	}
+	if (len == 0) {
+		struct ulogd_timer *t = malloc(sizeof(struct ulogd_timer));
+
+		ulogd_log(ULOGD_DEBUG, "  client disconnected\n");
+		/* we can't call ulogd_unregister_fd fd, it will segfault
+		 * (unable to remove an entry while inside llist_for_each_entry)
+		 * so we schedule removal for next loop
+		 */
+		ulogd_init_timer(t, ui, _timer_unregister_cb);
+		ulogd_add_timer(t, 0);
+		return 0;
+	}
+
+	buf[len] = '\0';
+
+	ulogd_log(ULOGD_DEBUG, "  read %d bytes\n", len);
+	//ulogd_log(ULOGD_DEBUG, "  buffer [%s]\n", buf);
+
+	if (ui->unixsock_buf_avail + len > ui->unixsock_buf_size) {
+		ulogd_log(ULOGD_NOTICE,
+			  "We are losing events. Please consider using the clause "
+			  "bufsize\n");
+		return -1;
+	}
+
+	memcpy(ui->unixsock_buf + ui->unixsock_buf_avail,
+	       buf,
+	       len);
+	ui->unixsock_buf_avail += len;
+
+	do {
+		needed_len = ntohs(*(u_int16_t*)ui->unixsock_buf);
+
+		if (ui->unixsock_buf_avail >= needed_len) {
+			ulogd_log(ULOGD_DEBUG, "  We have enough data, handling packet\n");
+
+
+			/* do we have only one packet */
+			if (ui->unixsock_buf_avail == needed_len)
+				return handle_packet(upi, needed_len);
+			else {
+				if (handle_packet(upi, needed_len) != 0)
+					return -1;
+			}
+
+		} else {
+			ulogd_log(ULOGD_DEBUG, "  We have %d bytes, but need %d. Requesting more\n",
+					ui->unixsock_buf_avail, needed_len);
+			return 0;
+		}
+
+		/* handle_packet has shifted data in buffer */
+	} while (1);
+
+	return 0;
+}
+
+/* callback called from ulogd core when fd is readable */
+static int unixsock_server_read_cb(int fd, unsigned int what, void *param)
+{
+	struct ulogd_pluginstance *upi = param;
+	struct unixsock_input *ui = (struct unixsock_input*)upi->private;
+	socklen_t len;
+	int s;
+	struct sockaddr_storage saddr;
+
+	if (!(what & ULOGD_FD_READ))
+		return 0;
+
+	ulogd_log(ULOGD_DEBUG, "New server connected on unixsock socket\n");
+
+	len = sizeof(saddr);
+	s = accept(fd, (struct sockaddr*)&saddr, &len);
+	if (s < 0) {
+		ulogd_log(ULOGD_NOTICE,
+				"  error while accepting new unixsock client, errno is %d (%s)\n",
+				errno, strerror(errno));
+		return len;
+	}
+
+	if (ui->unixsock_instance_fd.fd >= 0) {
+		ulogd_log(ULOGD_NOTICE, "a client is already connecting, rejecting new connection");
+		close(s);
+		return 0;
+	}
+
+	ui->unixsock_instance_fd.fd = s;
+	ui->unixsock_instance_fd.cb = &unixsock_instance_read_cb;
+	ui->unixsock_instance_fd.data = upi;
+	ui->unixsock_instance_fd.when = ULOGD_FD_READ;
+
+	if (ulogd_register_fd(&ui->unixsock_instance_fd) < 0) {
+		ulogd_log(ULOGD_ERROR, "unable to register client fd to ulogd\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+
+
+
+static int configure(struct ulogd_pluginstance *upi,
+		     struct ulogd_pluginstance_stack *stack)
+{
+	ulogd_log(ULOGD_DEBUG, "parsing config file section `%s', "
+		  "plugin `%s'\n", upi->id, upi->plugin->name);
+
+	config_parse_file(upi->id, upi->config_kset);
+	return 0;
+}
+
+static int start(struct ulogd_pluginstance *upi)
+{
+	struct unixsock_input *ui = (struct unixsock_input *) upi->private;
+	int fd;
+
+	ulogd_log(ULOGD_DEBUG, "Starting plugin `%s'\n",
+		  upi->plugin->name);
+
+	ui->path = unixpath_ce(upi->config_kset).u.string;
+
+	ulogd_log(ULOGD_DEBUG, "Creating Unix socket `%s'\n",
+		  ui->path);
+	fd = _create_unix_socket(unixpath_ce(upi->config_kset).u.string);
+	if (fd < 0) {
+		ulogd_log(ULOGD_ERROR, "unable to create unix socket on `%s'\n",
+			  ui->path);
+		return -1;
+	}
+
+	ui->unixsock_buf_avail = 0;
+	ui->unixsock_buf_size = bufsize_ce(upi->config_kset).u.value;
+
+	if (ui->unixsock_buf_size == 0) {
+		int fd_bufsize = 0;
+		socklen_t optlen = sizeof(fd_bufsize);
+
+		if (getsockopt(fd, SOL_SOCKET, SO_RCVBUF, &fd_bufsize, &optlen) < 0) {
+			ulogd_log(ULOGD_ERROR,
+					"Could not determine socket buffer size. You have to use the clause "
+					"bufsize\n");
+			return -1;
+		}
+		ulogd_log(ULOGD_DEBUG, "bufsize is %d\n", fd_bufsize);
+
+		ui->unixsock_buf_size = fd_bufsize;
+	}
+	ui->unixsock_buf = malloc(ui->unixsock_buf_size);
+
+	ui->unixsock_server_fd.fd = fd;
+	ui->unixsock_server_fd.cb = &unixsock_server_read_cb;
+	ui->unixsock_server_fd.data = upi;
+	ui->unixsock_server_fd.when = ULOGD_FD_READ;
+
+	ui->unixsock_instance_fd.fd = -1;
+	ui->unixsock_instance_fd.cb = &unixsock_instance_read_cb;
+	ui->unixsock_instance_fd.data = upi;
+	ui->unixsock_instance_fd.when = ULOGD_FD_READ;
+
+	if (ulogd_register_fd(&ui->unixsock_server_fd) < 0) {
+		ulogd_log(ULOGD_ERROR, "unable to register fd to ulogd\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int stop(struct ulogd_pluginstance *upi)
+{
+	struct unixsock_input *ui = (struct unixsock_input *) upi->private;
+	char *unix_path = unixpath_ce(upi->config_kset).u.string;
+
+	ulogd_log(ULOGD_DEBUG, "Stopping plugin `%s'\n",
+		  upi->plugin->name);
+
+	if (unix_path)
+		unlink(unix_path);
+
+	free(ui->unixsock_buf);
+
+	return 0;
+}
+
+
+
+
+struct ulogd_plugin libunixsock_plugin = {
+	.name = "UNIXSOCK",
+	.input = {
+		.type = ULOGD_DTYPE_SOURCE,
+	},
+	.output = {
+		.type = ULOGD_DTYPE_RAW,
+		.keys = output_keys,
+		.num_keys = ARRAY_SIZE(output_keys),
+	},
+	.priv_size 	= sizeof(struct unixsock_input),
+	.configure 	= &configure,
+	.start 		= &start,
+	.stop 		= &stop,
+	.config_kset 	= &libunixsock_kset,
+	.version	= ULOGD_VERSION,
+};
+
+static void __attribute__ ((constructor)) init(void)
+{
+	ulogd_register_plugin(&libunixsock_plugin);
+}
diff --git a/ulogd.conf.in b/ulogd.conf.in
index 4542fc4..323462b 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -27,6 +27,7 @@ loglevel=1
 
 plugin="@libdir@/ulogd/ulogd_inppkt_NFLOG.so"
 #plugin="@libdir@/ulogd/ulogd_inppkt_ULOG.so"
+#plugin="@libdir@/ulogd/ulogd_inppkt_UNIXSOCK.so"
 plugin="@libdir@/ulogd/ulogd_inpflow_NFCT.so"
 plugin="@libdir@/ulogd/ulogd_filter_IFINDEX.so"
 plugin="@libdir@/ulogd/ulogd_filter_IP2STR.so"
@@ -75,6 +76,9 @@ plugin="@libdir@/ulogd/ulogd_raw2packet_BASE.so"
 # this is a stack for logging packets to syslog after a collect via NFLOG
 #stack=log3:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,sys1:SYSLOG
 
+# this is a stack for logging packets to syslog after a collect via NuFW
+#stack=nuauth1:UNIXSOCK,base1:BASE,ip2str1:IP2STR,print1:PRINTPKT,sys1:SYSLOG
+
 # this is a stack for flow-based logging to MySQL
 #stack=ct1:NFCT,ip2bin1:IP2BIN,mysql2:MYSQL
 
@@ -137,6 +141,9 @@ numeric_label=1 # you can label the log info based on the packet verdict
 nlgroup=1
 #numeric_label=0 # optional argument
 
+[nuauth1]
+socket_path="/tmp/nuauth_ulogd2.sock"
+
 [emu1]
 file="/var/log/ulogd_syslogemu.log"
 sync=1
-- 
1.6.3.3

