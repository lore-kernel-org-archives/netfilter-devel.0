From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: [RFC][LIBNFNETLINK 3/3] API changes
Date: Sun, 12 Feb 2006 22:39:54 +0100
Message-ID: <43EFAB2A.4030204@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030801010306050504010505"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------030801010306050504010505
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

This patch introduces the following changes:

a) nfnl_handle_msg: this function completes the message iterator API.

nlh = nfnl_get_first_msg(h, ...);
while (nlh) {
        int done;

        ...

        ret = nfnl_handle_msg(h, &done);
        if (ret < 0 || done)
                return ret;

        nlh = nfnl_get_next_msg(h, ...);
}

Like this, we can iterate over the netlink messages that compose a
packet. The message is processed by nfnl_handle_msg that calls the
handler that was registered via nfnl_callback_register.

The done flag is set to one if the message is:
        - an ACK/ERROR message
        - a DONE message that notifies the end of a MULTI message.

b) nfnl_handle_packet: This function is simpler interface to handle a
netfilter netlink message. It loops over every message contained in a
packet but, in this case, the programmer has no control on the looping
process. Moreover, this function now has a done flag that is set under
the same circunstances exposed above.

c) nfnl_communicate: This function supersedes nfnl_listen and nfnl_talk.
It provides an interface to communicate with the nfnetlink subsystem.

- If the netlink header passed is null and a handler is registered via
nfnl_callback_register, then it behaves like nfnl_listen.
- If the netlink header passed is non-null and no handler was registered
via nfnl_callback_register, then it behaves like nfnl_talk.

-- 
Pablo

--------------030801010306050504010505
Content-Type: text/plain;
 name="03.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03.patch"

This patch introduces the following changes:

a) nfnl_handle_msg: this function completes the message iterator API.

nlh = nfnl_get_first_msg(h, ...);
while (nlh) {
	int done;

	...

	ret = nfnl_handle_msg(h, &done);
	if (ret < 0 || done)
		return ret;

	nlh = nfnl_get_next_msg(h, ...);
}

Like this, we can iterate over the netlink messages that compose a packet.
The message is processed by nfnl_handle_msg that calls the handler that 
was registered via nfnl_callback_register.

The done flag is set to one if the message is:
	- an ACK/ERROR message
	- a DONE message that notifies the end of a MULTI message.

b) nfnl_handle_packet: This function is simpler interface to handle a 
netfilter netlink message. It loops over every message contained in a 
packet but, in this case, the programmer has no control on the looping
process. Moreover, this function now has a done flag that is set under
the same circunstances exposed above.

c) nfnl_communicate: This function supersedes nfnl_listen and nfnl_talk.
It provides an interface to communicate with the nfnetlink subsystem.

	- If the netlink header passed is null and a handler is registered
	via nfnl_callback_register, then it behaves like nfnl_listen.
	- If the netlink header passed is non-null and no handler was 
	registered via nfnl_callback_register, then it behaves like nfnl_talk.

Index: libnfnetlink/src/libnfnetlink.c
===================================================================
--- libnfnetlink.orig/src/libnfnetlink.c	2006-02-12 19:38:20.000000000 +0100
+++ libnfnetlink/src/libnfnetlink.c	2006-02-12 20:46:46.000000000 +0100
@@ -969,17 +969,28 @@ static int __nfnl_handle_msg(struct nfnl
 	return 0;
 }
 
-int nfnl_handle_packet(struct nfnl_handle *h, char *buf, int len)
+int nfnl_handle_packet(struct nfnl_handle *h, char *buf, int len, int *done)
 {
+	struct nlmsghdr *nlh = (struct nlmsghdr *)buf;
 
-	while (len >= NLMSG_SPACE(0)) {
+	while (NLMSG_OK(nlh, len)) {
 		u_int32_t rlen;
-		struct nlmsghdr *nlh = (struct nlmsghdr *)buf;
 
 		if (nlh->nlmsg_len < sizeof(struct nlmsghdr)
 		    || len < nlh->nlmsg_len)
 			return -1;
 
+		/* This message is an ACK or a DONE */
+		if (done && 
+		    (nlh->nlmsg_type == NLMSG_ERROR ||
+		    (nlh->nlmsg_type == NLMSG_DONE &&
+		     nlh->nlmsg_flags & NLM_F_MULTI))) {
+			int err;
+			*done = 1;
+			memcpy(&err, NLMSG_DATA(nlh), sizeof(int));
+			return err;
+		}
+
 		rlen = NLMSG_ALIGN(nlh->nlmsg_len);
 		if (rlen > len)
 			rlen = len;
@@ -987,7 +998,55 @@ int nfnl_handle_packet(struct nfnl_handl
 		if (__nfnl_handle_msg(h, nlh, rlen) < 0)
 			return -1;
 
-		len -= rlen;
+		nlh = NLMSG_NEXT(nlh, len);
 	}
 	return 0;
 }
+
+int nfnl_handle_msg(struct nfnl_handle *h, int *done)
+{
+	int err = 0;
+
+	if (h->last_nlhdr->nlmsg_len >= NLMSG_SPACE(0)) {
+		int len = NLMSG_ALIGN(h->last_nlhdr->nlmsg_len);
+
+		if (h->last_nlhdr->nlmsg_len < sizeof(struct nlmsghdr)
+		    || len < h->last_nlhdr->nlmsg_len)
+			return -1;
+
+		/* This message is an ACK or a DONE */
+		if (done && (h->last_nlhdr->nlmsg_type == NLMSG_ERROR ||
+		    (h->last_nlhdr->nlmsg_type == NLMSG_DONE &&
+		     h->last_nlhdr->nlmsg_flags & NLM_F_MULTI))) {
+			*done = 1;
+			memcpy(&err, NLMSG_DATA(h->last_nlhdr), sizeof(int));
+			return err;
+		}
+
+		err = __nfnl_handle_msg(h, h->last_nlhdr, len);
+	}
+	return err;
+}
+
+int nfnl_communicate(struct nfnl_handle *h, struct nlmsghdr *nlh)
+{
+	int ret, numbytes, done = 0;
+	char buf[NFNL_BUFFSIZE];
+
+	if (nlh) {
+		ret = nfnl_send(h, nlh);
+		if (ret < 0)
+			return ret;
+	}
+
+	while (1) {
+		numbytes = nfnl_recv(h, buf, sizeof(buf));
+		if (numbytes <= 0)
+			return numbytes;
+
+		ret = nfnl_handle_packet(h, buf, numbytes, &done);
+		if (ret < 0 || done)
+			return ret;
+	}
+	return ret;
+}
Index: libnfnetlink/include/libnfnetlink/libnfnetlink.h
===================================================================
--- libnfnetlink.orig/include/libnfnetlink/libnfnetlink.h	2006-02-12 19:38:20.000000000 +0100
+++ libnfnetlink/include/libnfnetlink/libnfnetlink.h	2006-02-12 19:39:12.000000000 +0100
@@ -71,6 +71,7 @@ extern int nfnl_talk(struct nfnl_handle 
                      unsigned, struct nlmsghdr *,
                      int (*)(struct sockaddr_nl *, struct nlmsghdr *, void *),
                      void *);
+extern int nfnl_communicate(struct nfnl_handle *h, struct nlmsghdr *nlh);
 
 /* simple challenge/response */
 extern int nfnl_listen(struct nfnl_handle *,
@@ -82,7 +83,8 @@ extern ssize_t nfnl_recv(const struct nf
 extern int nfnl_callback_register(struct nfnl_subsys_handle *,
 				  u_int8_t type, struct nfnl_callback *cb);
 extern int nfnl_callback_unregister(struct nfnl_subsys_handle *, u_int8_t type);
-extern int nfnl_handle_packet(struct nfnl_handle *, char *buf, int len);
+extern int nfnl_handle_packet(struct nfnl_handle *, char *buf, int len, int *);
+extern int nfnl_handle_msg(struct nfnl_handle *h, int *done);
 
 /* parsing */
 extern struct nfattr *nfnl_parse_hdr(const struct nfnl_handle *nfnlh, 

--------------030801010306050504010505--
