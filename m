From: Pierre Chifflier <chifflier@edenwall.com>
Subject: [PATCH 1/2] Add new input plugin UNIXSOCK
Date: Mon,  1 Mar 2010 23:16:31 +0100
Message-ID: <1267481792-22729-2-git-send-email-chifflier@edenwall.com>
References: <4B8C16A4.9010807@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eleblond@edenwall.com, Pierre Chifflier <chifflier@inl.fr>,
	Pierre Chifflier <chifflier@edenwall.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:42182 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711Ab0CAWRZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Mar 2010 17:17:25 -0500
Received: from smtp1-g21.free.fr (localhost [127.0.0.1])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 264BA94011A
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Mar 2010 23:17:19 +0100 (CET)
Received: from fydelkass.edenwall.com (fydelkass.inl.fr [88.171.131.12])
	by smtp1-g21.free.fr (Postfix) with ESMTP id DF43A94017B
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Mar 2010 23:17:16 +0100 (CET)
In-Reply-To: <4B8C16A4.9010807@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Pierre Chifflier <chifflier@inl.fr>

This input plugins creates a unix socket which can be used to log packe=
ts.
Scripts or applications can connect to the socket (only one client allo=
wed
per socket) and send data in a Key-Length-Value format (including the
payload).

Signed-off-by: Pierre Chifflier <chifflier@edenwall.com>
---
 input/packet/Makefile.am             |    5 +-
 input/packet/ulogd_inppkt_UNIXSOCK.c |  826 ++++++++++++++++++++++++++=
++++++++
 ulogd.conf.in                        |    7 +
 3 files changed, 837 insertions(+), 1 deletions(-)
 create mode 100644 input/packet/ulogd_inppkt_UNIXSOCK.c

diff --git a/input/packet/Makefile.am b/input/packet/Makefile.am
index e90e46e..566b817 100644
--- a/input/packet/Makefile.am
+++ b/input/packet/Makefile.am
@@ -3,7 +3,7 @@ AM_CPPFLAGS =3D $(all_includes) -I$(top_srcdir)/include
 AM_CFLAGS=3D-fPIC -Wall
 LIBS=3D
=20
-pkglib_LTLIBRARIES =3D ulogd_inppkt_NFLOG.la ulogd_inppkt_ULOG.la
+pkglib_LTLIBRARIES =3D ulogd_inppkt_NFLOG.la ulogd_inppkt_ULOG.la ulog=
d_inppkt_UNIXSOCK.la
=20
 ulogd_inppkt_NFLOG_la_SOURCES =3D ulogd_inppkt_NFLOG.c
 ulogd_inppkt_NFLOG_la_LDFLAGS =3D -avoid-version -module $(LIBNETFILTE=
R_LOG_LIBS)
@@ -12,3 +12,6 @@ ulogd_inppkt_NFLOG_la_CFLAGS =3D $(AM_CFLAGS) $(LIBNE=
TFILTER_LOG_CFLAGS)
 ulogd_inppkt_ULOG_la_SOURCES =3D ulogd_inppkt_ULOG.c
 ulogd_inppkt_ULOG_la_LDFLAGS =3D -avoid-version -module
 ulogd_inppkt_ULOG_la_LIBADD =3D ../../libipulog/libipulog.la
+
+ulogd_inppkt_UNIXSOCK_la_SOURCES =3D ulogd_inppkt_UNIXSOCK.c
+ulogd_inppkt_UNIXSOCK_la_LDFLAGS =3D -avoid-version -module
diff --git a/input/packet/ulogd_inppkt_UNIXSOCK.c b/input/packet/ulogd_=
inppkt_UNIXSOCK.c
new file mode 100644
index 0000000..368df93
--- /dev/null
+++ b/input/packet/ulogd_inppkt_UNIXSOCK.c
@@ -0,0 +1,826 @@
+/*
+ * UNIXSOCK input module for ulogd
+ *
+ * Copyright(C) 2008-2010 INL
+ * Written by  Pierre Chifflier <chifflier@edenwall.com>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2=C2=B7
+ * as published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7  USA
+*/
+
+#include <unistd.h>
+#include <stdlib.h>
+#include <netinet/ether.h>
+#include <netinet/in.h>
+#include <netinet/ip.h>
+#include <netinet/ip6.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <sys/un.h>
+#include <pwd.h>
+#include <grp.h>
+#include <errno.h>
+
+#include <ulogd/ulogd.h>
+
+/* Default size of the receive buffer for the unix socket
+   0 means that ulogd will use getsockopt(SO_RCVBUF) to determine it
+   at runtime */
+#define UNIXSOCK_BUFSIZE_DEFAULT	0
+
+#define UNIXSOCK_PERMS_DEFAULT		0600
+
+#define UNIXSOCK_UNIXPATH_DEFAULT	"/var/run/ulogd/ulogd2.sock"
+
+#define ULOGD_SOCKET_MARK	0x41c90fd4
+
+struct unixsock_input {
+	char *path;
+	char *unixsock_buf;
+	unsigned int unixsock_perms;
+	unsigned int unixsock_buf_avail;
+	unsigned int unixsock_buf_size;
+	struct ulogd_fd unixsock_server_fd;
+	struct ulogd_fd unixsock_instance_fd;
+};
+
+enum nflog_keys {
+	UNIXSOCK_KEY_RAW_MAC =3D 0,
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
+	/* Add new keys after this line */
+};
+
+static struct ulogd_key output_keys[] =3D {
+	[UNIXSOCK_KEY_RAW_MAC] =3D {
+		.type =3D ULOGD_RET_RAW,
+		.flags =3D ULOGD_RETF_NONE,
+		.name =3D "raw.mac",
+	},
+	[UNIXSOCK_KEY_RAW_MAC_SADDR] =3D {
+		.type =3D ULOGD_RET_RAW,
+		.flags =3D ULOGD_RETF_NONE,
+		.name =3D "raw.mac.saddr",
+		.ipfix =3D {
+			.vendor =3D IPFIX_VENDOR_IETF,
+			.field_id =3D IPFIX_sourceMacAddress,
+		},
+	},
+	[UNIXSOCK_KEY_RAW_PCKT] =3D {
+		.type =3D ULOGD_RET_RAW,
+		.flags =3D ULOGD_RETF_NONE,
+		.name =3D "raw.pkt",
+		.ipfix =3D {
+			.vendor =3D IPFIX_VENDOR_NETFILTER,
+			.field_id =3D IPFIX_NF_rawpacket,
+		},
+	},
+	[UNIXSOCK_KEY_RAW_PCKTLEN] =3D {
+		.type =3D ULOGD_RET_UINT32,
+		.flags =3D ULOGD_RETF_NONE,
+		.name =3D "raw.pktlen",
+		.ipfix =3D {
+			.vendor =3D IPFIX_VENDOR_NETFILTER,
+			.field_id =3D IPFIX_NF_rawpacket_length,
+		},
+	},
+	[UNIXSOCK_KEY_RAW_PCKTCOUNT] =3D {
+		.type =3D ULOGD_RET_UINT32,
+		.flags =3D ULOGD_RETF_NONE,
+		.name =3D "raw.pktcount",
+		.ipfix =3D {
+			.vendor =3D IPFIX_VENDOR_IETF,
+			.field_id =3D IPFIX_packetDeltaCount,
+		},
+	},
+	[UNIXSOCK_KEY_OOB_PREFIX] =3D {
+		.type =3D ULOGD_RET_STRING,
+		.flags =3D ULOGD_RETF_NONE,
+		.name =3D "oob.prefix",
+		.ipfix =3D {
+			.vendor =3D IPFIX_VENDOR_NETFILTER,
+			.field_id =3D IPFIX_NF_prefix,
+		},
+	},
+	[UNIXSOCK_KEY_OOB_TIME_SEC] =3D {
+		.type =3D ULOGD_RET_UINT32,
+		.flags =3D ULOGD_RETF_NONE,
+		.name =3D "oob.time.sec",
+		.ipfix =3D {
+			.vendor =3D IPFIX_VENDOR_IETF,
+			.field_id =3D IPFIX_flowStartSeconds,
+		},
+	},
+	[UNIXSOCK_KEY_OOB_TIME_USEC] =3D {
+		.type =3D ULOGD_RET_UINT32,
+		.flags =3D ULOGD_RETF_NONE,
+		.name =3D "oob.time.usec",
+		.ipfix =3D {
+			.vendor =3D IPFIX_VENDOR_IETF,
+			.field_id =3D IPFIX_flowStartMicroSeconds,
+		},
+	},
+	[UNIXSOCK_KEY_OOB_MARK] =3D {
+		.type =3D ULOGD_RET_UINT32,
+		.flags =3D ULOGD_RETF_NONE,
+		.name =3D "oob.mark",
+		.ipfix =3D {
+			.vendor =3D IPFIX_VENDOR_NETFILTER,
+			.field_id =3D IPFIX_NF_mark,
+		},
+	},
+	[UNIXSOCK_KEY_OOB_IN] =3D {
+		.type =3D ULOGD_RET_STRING,
+		.flags =3D ULOGD_RETF_NONE,
+		.name =3D "oob.in",
+		.ipfix =3D {
+			.vendor =3D IPFIX_VENDOR_IETF,
+			.field_id =3D IPFIX_ingressInterface,
+		},
+	},
+	[UNIXSOCK_KEY_OOB_OUT] =3D {
+		.type =3D ULOGD_RET_STRING,
+		.flags =3D ULOGD_RETF_NONE,
+		.name =3D "oob.out",
+		.ipfix =3D {
+			.vendor =3D IPFIX_VENDOR_IETF,
+			.field_id =3D IPFIX_egressInterface,
+		},
+	},
+	[UNIXSOCK_KEY_OOB_HOOK] =3D {
+		.type =3D ULOGD_RET_UINT8,
+		.flags =3D ULOGD_RETF_NONE,
+		.name =3D "oob.hook",
+		.ipfix =3D {
+			.vendor =3D IPFIX_VENDOR_NETFILTER,
+			.field_id =3D IPFIX_NF_hook,
+		},
+	},
+	[UNIXSOCK_KEY_RAW_MAC_LEN] =3D {
+		.type =3D ULOGD_RET_UINT16,
+		.flags =3D ULOGD_RETF_NONE,
+		.name =3D "raw.mac_len",
+	},
+	[UNIXSOCK_KEY_RAW_MAC_ADDRLEN] =3D {
+		.type =3D ULOGD_RET_UINT16,
+		.flags =3D ULOGD_RETF_NONE,
+		.name =3D "raw.mac.addrlen",
+	},
+
+	[UNIXSOCK_KEY_OOB_SEQ_LOCAL] =3D {
+		.type =3D ULOGD_RET_UINT32,
+		.flags =3D ULOGD_RETF_NONE,
+		.name =3D "oob.seq.local",
+		.ipfix =3D {
+			.vendor =3D IPFIX_VENDOR_NETFILTER,
+			.field_id =3D IPFIX_NF_seq_local,
+		},
+	},
+	[UNIXSOCK_KEY_OOB_SEQ_GLOBAL] =3D {
+		.type =3D ULOGD_RET_UINT32,
+		.flags =3D ULOGD_RETF_NONE,
+		.name =3D "oob.seq.global",
+		.ipfix =3D {
+			.vendor =3D IPFIX_VENDOR_NETFILTER,
+			.field_id =3D IPFIX_NF_seq_global,
+		},
+	},
+	[UNIXSOCK_KEY_OOB_FAMILY] =3D {
+		.type =3D ULOGD_RET_UINT8,
+		.flags =3D ULOGD_RETF_NONE,
+		.name =3D "oob.family",
+	},
+	[UNIXSOCK_KEY_OOB_PROTOCOL] =3D {
+		.type =3D ULOGD_RET_UINT16,
+		.flags =3D ULOGD_RETF_NONE,
+		.name =3D "oob.protocol",
+	},
+	[UNIXSOCK_KEY_OOB_UID] =3D {
+		.type =3D ULOGD_RET_UINT32,
+		.flags =3D ULOGD_RETF_NONE,
+		.name =3D "oob.uid",
+	},
+	[UNIXSOCK_KEY_OOB_GID] =3D {
+		.type =3D ULOGD_RET_UINT32,
+		.flags =3D ULOGD_RETF_NONE,
+		.name =3D "oob.gid",
+	},
+	[UNIXSOCK_KEY_RAW_LABEL] =3D {
+		.type =3D ULOGD_RET_UINT8,
+		.flags =3D ULOGD_RETF_NONE,
+		.name =3D "raw.label",
+	},
+	[UNIXSOCK_KEY_RAW_TYPE] =3D {
+		.type =3D ULOGD_RET_UINT16,
+		.flags =3D ULOGD_RETF_NONE,
+		.name =3D "raw.type",
+	},
+	[UNIXSOCK_KEY_NUFW_USER_NAME] =3D {
+		.type =3D ULOGD_RET_STRING,
+		.flags =3D ULOGD_RETF_NONE,
+		.name =3D "nufw.user.name",
+	},
+	[UNIXSOCK_KEY_NUFW_USER_ID] =3D {
+		.type =3D ULOGD_RET_UINT32,
+		.flags =3D ULOGD_RETF_NONE,
+		.name =3D "nufw.user.id",
+	},
+	[UNIXSOCK_KEY_NUFW_OS_NAME] =3D {
+		.type =3D ULOGD_RET_STRING,
+		.flags =3D ULOGD_RETF_NONE,
+		.name =3D "nufw.os.name",
+	},
+	[UNIXSOCK_KEY_NUFW_OS_REL] =3D {
+		.type =3D ULOGD_RET_STRING,
+		.flags =3D ULOGD_RETF_NONE,
+		.name =3D "nufw.os.rel",
+	},
+	[UNIXSOCK_KEY_NUFW_OS_VERS] =3D {
+		.type =3D ULOGD_RET_STRING,
+		.flags =3D ULOGD_RETF_NONE,
+		.name =3D "nufw.os.vers",
+	},
+	[UNIXSOCK_KEY_NUFW_APP_NAME] =3D {
+		.type =3D ULOGD_RET_STRING,
+		.flags =3D ULOGD_RETF_NONE,
+		.name =3D "nufw.app.name",
+	},
+};
+
+static struct config_keyset libunixsock_kset =3D {
+	.num_ces =3D 5,
+	.ces =3D {
+		{
+			.key 	 =3D "socket_path",
+			.type 	 =3D CONFIG_TYPE_STRING,
+			.options =3D CONFIG_OPT_NONE,
+			.u.string =3D UNIXSOCK_UNIXPATH_DEFAULT,
+		},
+		{
+			.key 	 =3D "bufsize",
+			.type 	 =3D CONFIG_TYPE_INT,
+			.options =3D CONFIG_OPT_NONE,
+			.u.value =3D UNIXSOCK_BUFSIZE_DEFAULT,
+		},
+		{
+			.key 	 =3D "perms",
+			.type 	 =3D CONFIG_TYPE_INT,
+			.options =3D CONFIG_OPT_NONE,
+			.u.value =3D UNIXSOCK_PERMS_DEFAULT,
+		},
+		{
+			.key 	 =3D "owner",
+			.type 	 =3D CONFIG_TYPE_STRING,
+			.options =3D CONFIG_OPT_NONE,
+		},
+		{
+			.key 	 =3D "group",
+			.type 	 =3D CONFIG_TYPE_STRING,
+			.options =3D CONFIG_OPT_NONE,
+		},
+	},
+};
+
+enum {
+	UNIXSOCK_OPT_UNIXPATH =3D 0,
+	UNIXSOCK_OPT_BUFSIZE,
+	UNIXSOCK_OPT_PERM,
+	UNIXSOCK_OPT_OWNER,
+	UNIXSOCK_OPT_GROUP,
+};
+
+#define unixpath_ce(x)		((x)->ces[UNIXSOCK_OPT_UNIXPATH])
+#define bufsize_ce(x)		((x)->ces[UNIXSOCK_OPT_BUFSIZE])
+#define perms_ce(x)		((x)->ces[UNIXSOCK_OPT_PERM])
+#define owner_ce(x)		((x)->ces[UNIXSOCK_OPT_OWNER])
+#define group_ce(x)		((x)->ces[UNIXSOCK_OPT_GROUP])
+
+enum ulogd2_option_type {
+	ULOGD2_OPT_UNUSED =3D 0,
+	ULOGD2_OPT_PREFIX,	/* log prefix (string) */
+	ULOGD2_OPT_OOB_IN,	/* input device (string) */
+	ULOGD2_OPT_OOB_OUT,	/* output device (string) */
+	ULOGD2_OPT_OOB_TIME_SEC,	/* packet arrival time (u_int32_t) */
+
+	ULOGD2_OPT_USER=3D200,	/* user name (string) */
+	ULOGD2_OPT_USERID,	/* user id (u_int32_t) */
+	ULOGD2_OPT_OSNAME,	/* OS name (string) */
+	ULOGD2_OPT_OSREL,	/* OS release (string) */
+	ULOGD2_OPT_OSVERS,	/* OS version (string) */
+	ULOGD2_OPT_APPNAME,	/* application name (string) */
+	ULOGD2_OPT_STATE,	/* connection state: 0 (drop), 1 (open), 2 (establi=
shed), 3 (close), 4 (unknown) */
+
+	/* Add new options after this line */
+};
+
+struct ulogd_unixsock_packet_t {
+	uint32_t marker;
+	uint16_t total_size;
+	uint32_t version:4,
+		 reserved:28;
+	uint16_t payload_length;
+	struct iphdr payload;
+} __attribute__((packed));
+
+struct ulogd_unixsock_option_t  {
+	uint32_t option_id;
+	uint32_t option_length;
+	char     option_value[0];
+} __attribute__((packed));
+
+#define USOCK_ALIGNTO 8
+#define USOCK_ALIGN(len) ( ((len)+USOCK_ALIGNTO-1) & ~(USOCK_ALIGNTO-1=
) )
+
+static int handle_packet(struct ulogd_pluginstance *upi, struct ulogd_=
unixsock_packet_t *pkt, u_int16_t total_len)
+{
+	char *data =3D NULL;
+	struct iphdr *ip;
+	struct ulogd_key *ret =3D upi->output.keys;
+	u_int8_t oob_family;
+	u_int16_t payload_len;
+	u_int32_t option_number;
+	u_int32_t option_length;
+	char *buf;
+	struct ulogd_unixsock_option_t *option;
+	int new_offset;
+	char *options_start;
+
+	ulogd_log(ULOGD_DEBUG,
+			"ulogd2: handling packet\n");
+
+	payload_len =3D ntohs(pkt->payload_length);
+
+	ip =3D &pkt->payload;
+	if (ip->version =3D=3D 4)
+		oob_family =3D AF_INET;
+	else if (ip->version =3D=3D 6)
+		oob_family =3D AF_INET6;
+	else oob_family =3D 0;
+
+	okey_set_u8(&ret[UNIXSOCK_KEY_OOB_FAMILY], oob_family);
+	okey_set_ptr(&ret[UNIXSOCK_KEY_RAW_PCKT], ip);
+	okey_set_u32(&ret[UNIXSOCK_KEY_RAW_PCKTLEN], payload_len);
+
+	/* options */
+	if (total_len > payload_len + sizeof(u_int16_t)) {
+		/* option starts at the next aligned address after the payload */
+		new_offset =3D USOCK_ALIGN(payload_len);
+		options_start =3D (void*)ip + new_offset;
+		data =3D options_start;
+		total_len -=3D (options_start - (char*)pkt);
+
+		while ( (data - options_start) < total_len) {
+
+			option =3D (void*)data;
+			option_number =3D ntohl(option->option_id);
+			option_length =3D ntohl(option->option_length);
+			buf =3D option->option_value;
+
+			/* next option is also aligned */
+			new_offset =3D USOCK_ALIGN(option_length);
+			data +=3D sizeof(option->option_id) + sizeof(option->option_length)=
 + new_offset;
+
+			ulogd_log(ULOGD_DEBUG,
+					"ulogd2: option %d (len %d) `%s'\n",
+					option_number, option_length, buf);
+
+			switch(option_number) {
+			case ULOGD2_OPT_PREFIX:
+				okey_set_ptr(&ret[UNIXSOCK_KEY_OOB_PREFIX], buf);
+				break;
+			case ULOGD2_OPT_OOB_IN:
+				okey_set_ptr(&ret[UNIXSOCK_KEY_OOB_IN], buf);
+				break;
+			case ULOGD2_OPT_OOB_OUT:
+				okey_set_ptr(&ret[UNIXSOCK_KEY_OOB_OUT], buf);
+				break;
+			case ULOGD2_OPT_OOB_TIME_SEC:
+				okey_set_u32(&ret[UNIXSOCK_KEY_OOB_TIME_SEC], *(u_int32_t*)buf);
+				break;
+			case ULOGD2_OPT_USER:
+				okey_set_ptr(&ret[UNIXSOCK_KEY_NUFW_USER_NAME], buf);
+				break;
+			case ULOGD2_OPT_USERID:
+				okey_set_u32(&ret[UNIXSOCK_KEY_NUFW_USER_ID], *(u_int32_t*)buf);
+				break;
+			case ULOGD2_OPT_OSNAME:
+				okey_set_ptr(&ret[UNIXSOCK_KEY_NUFW_OS_NAME], buf);
+				break;
+			case ULOGD2_OPT_OSREL:
+				okey_set_ptr(&ret[UNIXSOCK_KEY_NUFW_OS_REL], buf);
+				break;
+			case ULOGD2_OPT_OSVERS:
+				okey_set_ptr(&ret[UNIXSOCK_KEY_NUFW_OS_VERS], buf);
+				break;
+			case ULOGD2_OPT_APPNAME:
+				okey_set_ptr(&ret[UNIXSOCK_KEY_NUFW_APP_NAME], buf);
+				break;
+			case ULOGD2_OPT_STATE:
+				okey_set_u8(&ret[UNIXSOCK_KEY_RAW_LABEL], *(u_int8_t*)buf);
+				break;
+			default:
+				ulogd_log(ULOGD_NOTICE,
+						"ulogd2: unknown option %d\n",
+						option_number);
+				break;
+			};
+		}
+	}
+
+	/* number of packets */
+	okey_set_u32(&ret[UNIXSOCK_KEY_RAW_PCKTCOUNT], 1);
+
+	ulogd_propagate_results(upi);
+
+	return 0;
+}
+
+static int _create_unix_socket(const char *unix_path)
+{
+	int ret =3D -1;
+	struct sockaddr_un server_sock;
+	int s;
+	struct stat st_dummy;
+
+	s =3D socket(AF_UNIX, SOCK_STREAM, 0);
+	if (s < 0) {
+		ulogd_log(ULOGD_ERROR,
+				"ulogd2: could not create unix socket\n");
+		return -1;
+	}
+
+	server_sock.sun_family =3D AF_UNIX;
+	strncpy(server_sock.sun_path, unix_path, sizeof(server_sock.sun_path)=
);
+	server_sock.sun_path[sizeof(server_sock.sun_path)-1] =3D '\0';
+
+	if (stat(unix_path, &st_dummy) =3D=3D 0 && st_dummy.st_size > 0) {
+		ulogd_log(ULOGD_ERROR,
+				"ulogd2: unix socket \'%s\' already exists\n",
+				unix_path);
+		close(s);
+		return -1;
+	}
+
+	ret =3D bind(s, (struct sockaddr *)&server_sock, sizeof(server_sock))=
;
+	if (ret < 0) {
+		ulogd_log(ULOGD_ERROR,
+				"ulogd2: could not bind to unix socket \'%s\'\n",
+				server_sock.sun_path);
+		close(s);
+		return -1;
+	}
+
+	ret =3D listen(s, 10);
+	if (ret < 0) {
+		ulogd_log(ULOGD_ERROR,
+				"ulogd2: could not bind to unix socket \'%s\'\n",
+				server_sock.sun_path);
+		close(s);
+		return -1;
+	}
+
+	return s;
+}
+
+static int _unix_socket_set_permissions(struct ulogd_pluginstance *upi=
)
+{
+	const char *socket_path;
+	const char *owner =3D owner_ce(upi->config_kset).u.string;
+	const char *group =3D group_ce(upi->config_kset).u.string;
+	uid_t uid =3D (uid_t)-1;
+	gid_t gid =3D (gid_t)-1;
+
+	socket_path =3D unixpath_ce(upi->config_kset).u.string;
+
+	if (chmod(socket_path, perms_ce(upi->config_kset).u.value) < 0) {
+		ulogd_log(ULOGD_ERROR, "Could not set permissions on unix socket\n")=
;
+		return -1;
+	}
+
+	if (owner && strlen(owner)>0) {
+		struct passwd *p =3D getpwnam(owner);
+
+		if (p =3D=3D NULL) {
+			ulogd_log(ULOGD_ERROR, "Invalid owner specified for unix socket (%s=
)\n", owner);
+			return -1;
+		}
+
+		uid =3D p->pw_uid;
+	}
+
+	if (group && strlen(group)>0) {
+		struct group *g =3D getgrnam(group);
+
+		if (g =3D=3D NULL) {
+			ulogd_log(ULOGD_ERROR, "Invalid group specified for unix socket (%s=
)\n", group);
+			return -1;
+		}
+
+		gid =3D g->gr_gid;
+	}
+
+	if (chown(socket_path, uid, gid) < 0) {
+		ulogd_log(ULOGD_ERROR, "Could not set owner/group of unix socket\n")=
;
+		return -1;
+	}
+
+	return 0;
+}
+
+/* warning: this code is NOT reentrant ! */
+static void _timer_unregister_cb(struct ulogd_timer *a, void *param)
+{
+	struct unixsock_input *ui =3D param;
+
+	if (ui->unixsock_instance_fd.fd >=3D 0) {
+		ulogd_log(ULOGD_DEBUG, "  removing client from list\n");
+		ulogd_unregister_fd(&ui->unixsock_instance_fd);
+		close(ui->unixsock_instance_fd.fd);
+		ui->unixsock_instance_fd.fd =3D -1;
+		ui->unixsock_buf_avail =3D 0;
+	}
+}
+
+static void _disconnect_client(struct unixsock_input *ui)
+{
+	struct ulogd_timer *t =3D malloc(sizeof(struct ulogd_timer));
+
+	/* we can't call ulogd_unregister_fd fd, it will segfault
+	 * (unable to remove an entry while inside llist_for_each_entry)
+	 * so we schedule removal for next loop
+	 */
+	ulogd_init_timer(t, ui, _timer_unregister_cb);
+	ulogd_add_timer(t, 0);
+}
+
+/* callback called from ulogd core when fd is readable */
+static int unixsock_instance_read_cb(int fd, unsigned int what, void *=
param)
+{
+	struct ulogd_pluginstance *upi =3D param;
+	struct unixsock_input *ui =3D (struct unixsock_input*)upi->private;
+	int len;
+	u_int16_t needed_len;
+	u_int32_t packet_sig;
+	struct ulogd_unixsock_packet_t *unixsock_packet;
+
+	char buf[4096];
+
+	if (!(what & ULOGD_FD_READ))
+		return 0;
+
+	len =3D read(fd, buf, sizeof(buf));
+	if (len < 0) {
+		ulogd_log(ULOGD_NOTICE, "  read returned %d, errno is %d (%s)\n",
+					len, errno, strerror(errno));
+		exit(-1);
+		return len;
+	}
+	if (len =3D=3D 0) {
+		_disconnect_client(ui);
+		ulogd_log(ULOGD_DEBUG, "  client disconnected\n");
+		return 0;
+	}
+
+	if (ui->unixsock_buf_avail + len > ui->unixsock_buf_size) {
+		ulogd_log(ULOGD_NOTICE,
+			  "We are losing events. Please consider using the clause "
+			  "bufsize\n");
+		return -1;
+	}
+
+	memcpy(ui->unixsock_buf + ui->unixsock_buf_avail, buf, len);
+	ui->unixsock_buf_avail +=3D len;
+
+	while(1) {
+		unixsock_packet =3D (void*)ui->unixsock_buf;
+		packet_sig =3D ntohl(unixsock_packet->marker);
+		if (packet_sig !=3D ULOGD_SOCKET_MARK) {
+			ulogd_log(ULOGD_ERROR,
+				"ulogd2: invalid packet marked received "
+				"(read %lx, expected %lx), closing socket.\n",
+				packet_sig, ULOGD_SOCKET_MARK);
+			_disconnect_client(ui);
+			return -1;
+
+		}
+
+		needed_len =3D ntohs(unixsock_packet->total_size);
+
+		if (ui->unixsock_buf_avail >=3D needed_len + sizeof(u_int32_t)) {
+			ulogd_log(ULOGD_DEBUG,
+			"  We have enough data (%d bytes required), handling packet\n",
+					needed_len);
+
+			if (handle_packet(upi, unixsock_packet, needed_len) !=3D 0) {
+				return -1;
+			}
+			/* consume data */
+			ui->unixsock_buf_avail -=3D (sizeof(u_int32_t) + needed_len);
+			if (ui->unixsock_buf_avail > 0) {
+				/* we need to shift data .. */
+				memmove(ui->unixsock_buf,
+						ui->unixsock_buf + (sizeof(u_int32_t) + needed_len) ,
+						ui->unixsock_buf_avail);
+			} else {
+				/* input buffer is empty, do not loop */
+				return 0;
+			}
+
+		} else {
+			ulogd_log(ULOGD_DEBUG, "  We have %d bytes, but need %d. Requesting=
 more\n",
+					ui->unixsock_buf_avail, needed_len + sizeof(u_int32_t));
+			return 0;
+		}
+
+		/* handle_packet has shifted data in buffer */
+	};
+
+	return 0;
+}
+
+/* callback called from ulogd core when fd is readable */
+static int unixsock_server_read_cb(int fd, unsigned int what, void *pa=
ram)
+{
+	struct ulogd_pluginstance *upi =3D param;
+	struct unixsock_input *ui =3D (struct unixsock_input*)upi->private;
+	socklen_t len;
+	int s;
+	struct sockaddr_storage saddr;
+
+	if (!(what & ULOGD_FD_READ))
+		return 0;
+
+	ulogd_log(ULOGD_DEBUG, "New server connected on unixsock socket\n");
+
+	len =3D sizeof(saddr);
+	s =3D accept(fd, (struct sockaddr*)&saddr, &len);
+	if (s < 0) {
+		ulogd_log(ULOGD_NOTICE,
+				"  error while accepting new unixsock client, errno is %d (%s)\n",
+				errno, strerror(errno));
+		return len;
+	}
+
+	if (ui->unixsock_instance_fd.fd >=3D 0) {
+		ulogd_log(ULOGD_NOTICE, "a client is already connecting, rejecting n=
ew connection");
+		close(s);
+		return 0;
+	}
+
+	ui->unixsock_instance_fd.fd =3D s;
+	ui->unixsock_instance_fd.cb =3D &unixsock_instance_read_cb;
+	ui->unixsock_instance_fd.data =3D upi;
+	ui->unixsock_instance_fd.when =3D ULOGD_FD_READ;
+
+	if (ulogd_register_fd(&ui->unixsock_instance_fd) < 0) {
+		ulogd_log(ULOGD_ERROR, "unable to register client fd to ulogd\n");
+		return -1;
+	}
+
+	return 0;
+}
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
+	struct unixsock_input *ui =3D (struct unixsock_input *) upi->private;
+	int fd;
+
+	ulogd_log(ULOGD_DEBUG, "Starting plugin `%s'\n",
+		  upi->plugin->name);
+
+	ui->path =3D unixpath_ce(upi->config_kset).u.string;
+
+	ulogd_log(ULOGD_DEBUG, "Creating Unix socket `%s'\n",
+		  ui->path);
+	fd =3D _create_unix_socket(ui->path);
+	if (fd < 0) {
+		ulogd_log(ULOGD_ERROR, "Unable to create unix socket on `%s'\n",
+			  ui->path);
+		return -1;
+	}
+
+	if (_unix_socket_set_permissions(upi) < 0) {
+		return -1;
+	}
+
+	ui->unixsock_buf_avail =3D 0;
+	ui->unixsock_buf_size =3D bufsize_ce(upi->config_kset).u.value;
+
+	if (ui->unixsock_buf_size =3D=3D 0) {
+		int fd_bufsize =3D 0;
+		socklen_t optlen =3D sizeof(fd_bufsize);
+
+		if (getsockopt(fd, SOL_SOCKET, SO_RCVBUF, &fd_bufsize, &optlen) < 0)=
 {
+			ulogd_log(ULOGD_ERROR,
+					"Could not determine socket buffer size. You have to use the clau=
se "
+					"bufsize\n");
+			return -1;
+		}
+		ulogd_log(ULOGD_DEBUG, "bufsize is %d\n", fd_bufsize);
+
+		ui->unixsock_buf_size =3D fd_bufsize;
+	}
+	ui->unixsock_buf =3D malloc(ui->unixsock_buf_size);
+
+	ui->unixsock_server_fd.fd =3D fd;
+	ui->unixsock_server_fd.cb =3D &unixsock_server_read_cb;
+	ui->unixsock_server_fd.data =3D upi;
+	ui->unixsock_server_fd.when =3D ULOGD_FD_READ;
+
+	ui->unixsock_instance_fd.fd =3D -1;
+	ui->unixsock_instance_fd.cb =3D &unixsock_instance_read_cb;
+	ui->unixsock_instance_fd.data =3D upi;
+	ui->unixsock_instance_fd.when =3D ULOGD_FD_READ;
+
+	if (ulogd_register_fd(&ui->unixsock_server_fd) < 0) {
+		ulogd_log(ULOGD_ERROR, "Unable to register fd to ulogd\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int stop(struct ulogd_pluginstance *upi)
+{
+	struct unixsock_input *ui =3D (struct unixsock_input *) upi->private;
+	char *unix_path =3D unixpath_ce(upi->config_kset).u.string;
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
+struct ulogd_plugin libunixsock_plugin =3D {
+	.name =3D "UNIXSOCK",
+	.input =3D {
+		.type =3D ULOGD_DTYPE_SOURCE,
+	},
+	.output =3D {
+		.type =3D ULOGD_DTYPE_RAW,
+		.keys =3D output_keys,
+		.num_keys =3D ARRAY_SIZE(output_keys),
+	},
+	.priv_size 	=3D sizeof(struct unixsock_input),
+	.configure 	=3D &configure,
+	.start 		=3D &start,
+	.stop 		=3D &stop,
+	.config_kset 	=3D &libunixsock_kset,
+	.version	=3D ULOGD_VERSION,
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
@@ -27,6 +27,7 @@ loglevel=3D1
=20
 plugin=3D"@libdir@/ulogd/ulogd_inppkt_NFLOG.so"
 #plugin=3D"@libdir@/ulogd/ulogd_inppkt_ULOG.so"
+#plugin=3D"@libdir@/ulogd/ulogd_inppkt_UNIXSOCK.so"
 plugin=3D"@libdir@/ulogd/ulogd_inpflow_NFCT.so"
 plugin=3D"@libdir@/ulogd/ulogd_filter_IFINDEX.so"
 plugin=3D"@libdir@/ulogd/ulogd_filter_IP2STR.so"
@@ -75,6 +76,9 @@ plugin=3D"@libdir@/ulogd/ulogd_raw2packet_BASE.so"
 # this is a stack for logging packets to syslog after a collect via NF=
LOG
 #stack=3Dlog3:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRIN=
TPKT,sys1:SYSLOG
=20
+# this is a stack for logging packets to syslog after a collect via Nu=
=46W
+#stack=3Dnuauth1:UNIXSOCK,base1:BASE,ip2str1:IP2STR,print1:PRINTPKT,sy=
s1:SYSLOG
+
 # this is a stack for flow-based logging to MySQL
 #stack=3Dct1:NFCT,ip2bin1:IP2BIN,mysql2:MYSQL
=20
@@ -137,6 +141,9 @@ numeric_label=3D1 # you can label the log info base=
d on the packet verdict
 nlgroup=3D1
 #numeric_label=3D0 # optional argument
=20
+[nuauth1]
+socket_path=3D"/tmp/nuauth_ulogd2.sock"
+
 [emu1]
 file=3D"/var/log/ulogd_syslogemu.log"
 sync=3D1
--=20
1.7.0

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
