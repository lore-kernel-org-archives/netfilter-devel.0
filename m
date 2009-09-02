From: Pierre Chifflier <pchifflier@edenwall.com>
Subject: Re: [PATCH 2/3] Add new input plugin UNIXSOCK
Date: Wed, 2 Sep 2009 22:45:39 +0200
Message-ID: <20090902204538.GA1837@piche.inl.fr>
References: <1251056168-7073-1-git-send-email-chifflier@inl.fr>
 <1251056168-7073-3-git-send-email-chifflier@inl.fr>
 <alpine.LSU.2.00.0908240031330.30556@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, eleblond@inl.fr
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:50744 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049AbZIBUsw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Sep 2009 16:48:52 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0908240031330.30556@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi Jan,

Thanks for your feedback.
I'm currently working on a new version of the patch with the changes
(and some other fixes that were found after some real-life tests)
I will send the updated parts ASAP.

Regards,
Pierre

On Mon, Aug 24, 2009 at 12:45:11AM +0200, Jan Engelhardt wrote:
> 
> On Sunday 2009-08-23 21:36, Pierre Chifflier wrote:
> >+
> >+/* Size of the receive buffer for the unix socket. */
> >+#define UNIXSOCK_BUFSIZE_DEFAULT	150000
> 
> Hm. Would it make some sene to '(ab)use' getsockopt(SO_RCVBUF) as the
> (runtime!) value for the default buffer size?
> 
> >+/* Default unix socket path */
> >+#define UNIXSOCK_UNIXPATH_DEFAULT	"/tmp/ulogd2.sock"
> >+
> >+
> >+#define UNIX_PATH_MAX	108
> >...
> >+static int _create_unix_socket(const char *unix_path)
> >+{
> >+	int ret = -1;
> >+	struct sockaddr_un server_sock;
> >+	int s;
> >+	socklen_t len;
> >+
> >+	s = socket(AF_UNIX, SOCK_STREAM, 0);
> >+	if (s < 0)
> >+		return -1;
> >+
> >+	server_sock.sun_family = AF_UNIX;
> >+	strncpy(server_sock.sun_path, unix_path, UNIX_PATH_MAX-1);
> 
> You can use sizeof(server_sock.sun_path) instead,
> obviating the need for UNIX_PATH_MAX.
> 
> Also you should - as printf is called in the error case below -
> ensure it is '\0'-terminated.
> 
> >+	len = strlen(server_sock.sun_path) + sizeof(server_sock.sun_family);
> 
> len should be sizeof(server_sock)...
> 
> >+	ret = bind(s, (struct sockaddr *)&server_sock, len);
> 
> ... and since it can be directly passed in:
> 
> 	ret = bind(s, server_sock, sizeof(server_sock));
> 
> >+/* callback called from ulogd core when fd is readable */
> >+static int unixsock_instance_read_cb(int fd, unsigned int what, void *param)
> >+{
> >+	struct ulogd_pluginstance *upi = (struct ulogd_pluginstance *)param;
> 
> There is no cast needed for void*s.
> 
> >+/* callback called from ulogd core when fd is readable */
> >+static int unixsock_server_read_cb(int fd, unsigned int what, void *param)
> >+{
> >+	struct ulogd_pluginstance *upi = (struct ulogd_pluginstance *)param;
> 
> Same
> 
> >+	struct sockaddr_storage saddr;
> >+
> >+	if (!(what & ULOGD_FD_READ))
> >+		return 0;
> >+
> >+	ulogd_log(ULOGD_DEBUG, "New server connected on unixsock socket\n");
> >+
> >+	len = sizeof(saddr);
> >+	s = accept(fd, (struct sockaddr*)&saddr, &len);
> 
> Since only unix sockets can connect, one could probably
> use sockaddr_un over sockaddr_storage (though _storage is always
> a good fallback).
> 
> >+struct ulogd_plugin libunixsock_plugin = {
> >+	.name = "UNIXSOCK",
> >+	.input = {
> >+		.type = ULOGD_DTYPE_SOURCE,
> >+	},
> >+	.output = {
> >+		.type = ULOGD_DTYPE_RAW,
> >+		.keys = output_keys,
> >+		.num_keys = sizeof(output_keys)/sizeof(struct ulogd_key),
> 
> Hmmm. Does ulogd have an ARRAY_SIZE that could make .num_keys easier?
> 
> >+void __attribute__ ((constructor)) init(void);
> >+
> >+void init(void)
> >+{
> >+	ulogd_register_plugin(&libunixsock_plugin);
> >+}
> 
> This can become
> 
> static void __attribute__((constructor)) init(void) { ... }
> 
> Modules are always self-contained shared libraries if I read
> the Makefiles right, so there should not be any benefit of
> giving them 'extern'al linkage.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
