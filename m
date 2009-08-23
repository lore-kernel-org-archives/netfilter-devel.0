From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/3] Add new input plugin UNIXSOCK
Date: Mon, 24 Aug 2009 00:45:11 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0908240031330.30556@fbirervta.pbzchgretzou.qr>
References: <1251056168-7073-1-git-send-email-chifflier@inl.fr> <1251056168-7073-3-git-send-email-chifflier@inl.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, eleblond@inl.fr
To: Pierre Chifflier <chifflier@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35061 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbZHWWpM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Aug 2009 18:45:12 -0400
In-Reply-To: <1251056168-7073-3-git-send-email-chifflier@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2009-08-23 21:36, Pierre Chifflier wrote:
>+
>+/* Size of the receive buffer for the unix socket. */
>+#define UNIXSOCK_BUFSIZE_DEFAULT	150000

Hm. Would it make some sene to '(ab)use' getsockopt(SO_RCVBUF) as the
(runtime!) value for the default buffer size?

>+/* Default unix socket path */
>+#define UNIXSOCK_UNIXPATH_DEFAULT	"/tmp/ulogd2.sock"
>+
>+
>+#define UNIX_PATH_MAX	108
>...
>+static int _create_unix_socket(const char *unix_path)
>+{
>+	int ret = -1;
>+	struct sockaddr_un server_sock;
>+	int s;
>+	socklen_t len;
>+
>+	s = socket(AF_UNIX, SOCK_STREAM, 0);
>+	if (s < 0)
>+		return -1;
>+
>+	server_sock.sun_family = AF_UNIX;
>+	strncpy(server_sock.sun_path, unix_path, UNIX_PATH_MAX-1);

You can use sizeof(server_sock.sun_path) instead,
obviating the need for UNIX_PATH_MAX.

Also you should - as printf is called in the error case below -
ensure it is '\0'-terminated.

>+	len = strlen(server_sock.sun_path) + sizeof(server_sock.sun_family);

len should be sizeof(server_sock)...

>+	ret = bind(s, (struct sockaddr *)&server_sock, len);

... and since it can be directly passed in:

	ret = bind(s, server_sock, sizeof(server_sock));

>+/* callback called from ulogd core when fd is readable */
>+static int unixsock_instance_read_cb(int fd, unsigned int what, void *param)
>+{
>+	struct ulogd_pluginstance *upi = (struct ulogd_pluginstance *)param;

There is no cast needed for void*s.

>+/* callback called from ulogd core when fd is readable */
>+static int unixsock_server_read_cb(int fd, unsigned int what, void *param)
>+{
>+	struct ulogd_pluginstance *upi = (struct ulogd_pluginstance *)param;

Same

>+	struct sockaddr_storage saddr;
>+
>+	if (!(what & ULOGD_FD_READ))
>+		return 0;
>+
>+	ulogd_log(ULOGD_DEBUG, "New server connected on unixsock socket\n");
>+
>+	len = sizeof(saddr);
>+	s = accept(fd, (struct sockaddr*)&saddr, &len);

Since only unix sockets can connect, one could probably
use sockaddr_un over sockaddr_storage (though _storage is always
a good fallback).

>+struct ulogd_plugin libunixsock_plugin = {
>+	.name = "UNIXSOCK",
>+	.input = {
>+		.type = ULOGD_DTYPE_SOURCE,
>+	},
>+	.output = {
>+		.type = ULOGD_DTYPE_RAW,
>+		.keys = output_keys,
>+		.num_keys = sizeof(output_keys)/sizeof(struct ulogd_key),

Hmmm. Does ulogd have an ARRAY_SIZE that could make .num_keys easier?

>+void __attribute__ ((constructor)) init(void);
>+
>+void init(void)
>+{
>+	ulogd_register_plugin(&libunixsock_plugin);
>+}

This can become

static void __attribute__((constructor)) init(void) { ... }

Modules are always self-contained shared libraries if I read
the Makefiles right, so there should not be any benefit of
giving them 'extern'al linkage.

