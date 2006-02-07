From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: [LIBNFNETLINK] Introduce nfnl_listen_for_msecs
Date: Tue, 07 Feb 2006 02:47:38 +0100
Message-ID: <43E7FC3A.4050209@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000807050408050704090703"
Cc: Harald Welte <laforge@netfilter.org>
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
--------------000807050408050704090703
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi Harald,

The patch attached introduces a new function called
nfnl_listen_for_msecs. This is useful for polling netlink events.

I have enqueued a patch for libnetfilter_conntrack that implements
nfct_event_conntrack_for_msecs. I apply it by myself once this gets
applied ;)

cheers,

-- 
Pablo

--------------000807050408050704090703
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: include/libnfnetlink/libnfnetlink.h
===================================================================
--- include/libnfnetlink/libnfnetlink.h	(revision 6450)
+++ include/libnfnetlink/libnfnetlink.h	(working copy)
@@ -76,6 +76,11 @@
 extern int nfnl_listen(struct nfnl_handle *,
                       int (*)(struct sockaddr_nl *, struct nlmsghdr *, void *),
                       void *);
+/* simple challenge/response with timeout (polling) */
+extern int nfnl_listen_for_msecs(struct nfnl_handle *,
+				 int (*)(struct sockaddr_nl *, 
+					 struct nlmsghdr *, void *),
+				 void *, int timeout);
 
 /* receiving */
 extern ssize_t nfnl_recv(const struct nfnl_handle *h, unsigned char *buf, size_t len);
Index: src/libnfnetlink.c
===================================================================
--- src/libnfnetlink.c	(revision 6450)
+++ src/libnfnetlink.c	(working copy)
@@ -24,6 +24,9 @@
  * 2006-01-26 Harald Welte <laforge@netfilter.org>:
  * 	remove bogus nfnlh->local.nl_pid from nfnl_open ;)
  * 	add 16bit attribute functions
+ *
+ * 2006-02-07 Pablo Neira Ayuso <pablo@netfilter.org>:
+ * 	introduce nfnl_listen_for_msecs
  */
 
 #include <stdlib.h>
@@ -36,6 +39,7 @@
 
 #include <sys/types.h>
 #include <sys/socket.h>
+#include <poll.h>
 
 #include <linux/netlink.h>
 
@@ -397,27 +401,11 @@
 
 	return status;
 }
-/**
- * nfnl_listen: listen for one or more netlink messages
- *
- * nfnhl: libnfnetlink handle
- * handler: callback function to be called for every netlink message
- *          - the callback handler should normally return 0
- *          - but may return a negative error code which will cause
- *            nfnl_listen to return immediately with the same error code
- *          - or return a postivie error code which will cause 
- *            nfnl_listen to return after it has finished processing all
- *            the netlink messages in the current packet
- *          Thus a positive error code will terminate nfnl_listen "soon"
- *          without any loss of data, a negative error code will terminate
- *          nfnl_listen "very soon" and throw away data already read from
- *          the netlink socket.
- * jarg: opaque argument passed on to callback
- *
- */
-int nfnl_listen(struct nfnl_handle *nfnlh,
-		int (*handler)(struct sockaddr_nl *, struct nlmsghdr *n,
-			       void *), void *jarg)
+
+int nfnl_listen_for_msecs(struct nfnl_handle *nfnlh,
+			  int (*handler)(struct sockaddr_nl *, 
+				  	 struct nlmsghdr *n, void *), 
+			  void *jarg, int timeout)
 {
 	struct sockaddr_nl nladdr;
 	char buf[NFNL_BUFFSIZE];
@@ -434,12 +422,26 @@
 		0
 	};
 
+	struct pollfd ufds = {
+		.fd = nfnlh->fd,
+		.events = POLLIN | POLLPRI | POLLERR,
+		.revents = 0
+	};
+
 	memset(&nladdr, 0, sizeof(nladdr));
 	nladdr.nl_family = AF_NETLINK;
 	iov.iov_base = buf;
 	iov.iov_len = sizeof(buf);
 
 	while (! quit) {
+		if (poll(&ufds, 1, timeout) == -1) {
+			perror("poll error");
+			return -errno;
+		}
+		if (ufds.revents & POLLERR)
+			break;
+		if (!(ufds.revents & (POLLIN | POLLPRI)))
+			break;
 		remain = recvmsg(nfnlh->fd, &msg, 0);
 		if (remain < 0) {
 			if (errno == EINTR)
@@ -510,6 +512,31 @@
 	return quit;
 }
 
+/**
+ * nfnl_listen: listen for one or more netlink messages
+ *
+ * nfnhl: libnfnetlink handle
+ * handler: callback function to be called for every netlink message
+ *          - the callback handler should normally return 0
+ *          - but may return a negative error code which will cause
+ *            nfnl_listen to return immediately with the same error code
+ *          - or return a postivie error code which will cause 
+ *            nfnl_listen to return after it has finished processing all
+ *            the netlink messages in the current packet
+ *          Thus a positive error code will terminate nfnl_listen "soon"
+ *          without any loss of data, a negative error code will terminate
+ *          nfnl_listen "very soon" and throw away data already read from
+ *          the netlink socket.
+ * jarg: opaque argument passed on to callback
+ *
+ */
+int nfnl_listen(struct nfnl_handle *nfnlh,
+		int (*handler)(struct sockaddr_nl *, struct nlmsghdr *n,
+			       void *), void *jarg)
+{
+	return nfnl_listen_for_msecs(nfnlh, handler, jarg, -1);
+}
+
 int nfnl_talk(struct nfnl_handle *nfnlh, struct nlmsghdr *n, pid_t peer,
 	      unsigned groups, struct nlmsghdr *answer,
 	      int (*junk)(struct sockaddr_nl *, struct nlmsghdr *n, void *),

--------------000807050408050704090703--
