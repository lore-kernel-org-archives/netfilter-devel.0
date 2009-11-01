From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/2] Add new input plugin UNIXSOCK
Date: Sun, 1 Nov 2009 13:45:45 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0911011336330.22807@obet.zrqbmnf.qr>
References: <1257072828-11028-1-git-send-email-chifflier@inl.fr> <1257072828-11028-2-git-send-email-chifflier@inl.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, eleblond@inl.fr
To: Pierre Chifflier <chifflier@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59266 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037AbZKAMpl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Nov 2009 07:45:41 -0500
In-Reply-To: <1257072828-11028-2-git-send-email-chifflier@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2009-11-01 11:53, Pierre Chifflier wrote:

>This input plugins creates a unix socket which can be used to log packets.
>Scripts or applications can connect to the socket (only one client allowed
>per socket) and send data in a Key-Length-Value format (including the
>payload).
>
>+#define UNIX_PATH_MAX	108

This is nowhere used and can be removed. (Also since 108 may be
wrong for a given arch.)

>+#define unixpath_ce(x)		(x->ces[0])
>+#define bufsize_ce(x)		(x->ces[1])
>+#define perms_ce(x)		(x->ces[2])
>+#define owner_ce(x)		(x->ces[3])
>+#define group_ce(x)		(x->ces[4])

x should be guarded with ((x)->ces[0])

>+static int handle_packet(struct ulogd_pluginstance *upi, char *packet_buf, u_int16_t total_len)
>+{
>+	char *data;
>+	struct iphdr *ip;
>+	struct ulogd_key *ret = upi->output.keys;
>+	u_int8_t oob_family;
>+	u_int16_t payload_len;
>+	u_int16_t option_number;
>+	u_int16_t option_length;
>+	char *buf;
>+
>+	ulogd_log(ULOGD_DEBUG,
>+			"ulogd2: handling packet\n");
>+
>+	data = packet_buf + sizeof(u_int16_t);
>+
>+	payload_len = ntohs(*(u_int16_t*)data);
>+	data += sizeof(u_int16_t);
>+
>+
>+	ip = (struct iphdr *) data;

If data is not aligned, later dereferencing can fail :(

>+	if (ip->version == 4)
>+		oob_family = AF_INET;
>+	else if (ip->version == 6)
>+		oob_family = AF_INET6;
>+	else oob_family = 0;
>+
>+	okey_set_u8(&ret[UNIXSOCK_KEY_OOB_FAMILY], oob_family);
>+
>+	okey_set_ptr(&ret[UNIXSOCK_KEY_RAW_PCKT], ip);
>+	okey_set_u32(&ret[UNIXSOCK_KEY_RAW_PCKTLEN], payload_len);
>+
>+	/* options */
>+	if (total_len > payload_len + sizeof(u_int16_t)) {
>+		data = packet_buf + payload_len + 2*sizeof(u_int16_t);
>+		total_len -= 2*sizeof(u_int16_t);
>+
>+		while ( (data - packet_buf) < total_len) {
>+
>+			option_number = ntohs(*(u_int16_t*)(data));

This can fail even if packet_buf _is_ aligned, all it takes
is that payload_len is an odd number.
Unfortunately, I see no way to easily address this without
lame bitshifting :(

>+static int _unix_socket_set_permissions(struct ulogd_pluginstance *upi)
>+{
>+	const char *socket_path;
>+	char *owner = owner_ce(upi->config_kset).u.string;
>+	char *group = group_ce(upi->config_kset).u.string;

const char *, I guess

>+	int uid = -1;
>+	int gid = -1;

uit_t, gid_t.

>+	if (uid >= 0 || gid >= 0) {

Subsequently, uid != -1 || gid != -1. However, you could also ignore
this check entirely since chown checks for -1 already.
