From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [RFC]libnfnetlink new API #3
Date: Mon, 21 Aug 2006 11:01:23 +0200
Message-ID: <44E97663.8040904@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050502010109010004040303"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>, Harald Welte <laforge@netfilter.org>
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
--------------050502010109010004040303
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

This patch follows from:
http://patchwork.netfilter.org/netfilter-devel/patch.pl?id=3695

Now we do sequence tracking for queries, I assume that sequence number 0 
is only used by events.

Wait for your comments,
Pablo

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------050502010109010004040303
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="x"

Index: include/libnfnetlink/libnfnetlink.h
===================================================================
--- include/libnfnetlink/libnfnetlink.h	(revisión: 6652)
+++ include/libnfnetlink/libnfnetlink.h	(copia de trabajo)
@@ -98,6 +98,35 @@
 					  const unsigned char *buf,
 					  size_t len);
 
+/* join a certain netlink multicast group */
+extern int nfnl_join(const struct nfnl_handle *nfnlh, unsigned int group);
+
+/* process a netlink message */
+extern int nfnl_process(struct nfnl_handle *h,
+			const unsigned char *buf,
+			size_t len);
+
+/* iterator API */
+
+extern struct nfnl_iterator *
+nfnl_iterator_create(const struct nfnl_handle *h,
+		     const char *buf,
+		     size_t len);
+
+extern void nfnl_iterator_destroy(struct nfnl_iterator *it);
+
+extern int nfnl_iterator_process(struct nfnl_handle *h,
+				 struct nfnl_iterator *it);
+
+extern int nfnl_iterator_next(const struct nfnl_handle *h,
+			      struct nfnl_iterator *it);
+
+/* replacement for nfnl_listen */
+extern int nfnl_catch(struct nfnl_handle *h);
+
+/* replacement for nfnl_talk */
+extern int nfnl_query(struct nfnl_handle *h, struct nlmsghdr *nlh);
+
 #define nfnl_attr_present(tb, attr)			\
 	(tb[attr-1])
 
Index: src/libnfnetlink.c
===================================================================
--- src/libnfnetlink.c	(revisión: 6652)
+++ src/libnfnetlink.c	(copia de trabajo)
@@ -1,6 +1,7 @@
 /* libnfnetlink.c: generic library for communication with netfilter
  *
  * (C) 2002-2006 by Harald Welte <laforge@gnumonks.org>
+ * (C) 2006 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * Based on some original ideas from Jay Schulist <jschlst@samba.org>
  *
@@ -24,6 +25,13 @@
  * 2006-01-26 Harald Welte <laforge@netfilter.org>:
  * 	remove bogus nfnlh->local.nl_pid from nfnl_open ;)
  * 	add 16bit attribute functions
+ *
+ * 2006-07-03 Pablo Neira Ayuso <pablo@netfilter.org>:
+ * 	add iterator API
+ * 	add replacements for nfnl_listen and nfnl_talk
+ * 	fix error handling
+ * 	add assertions
+ * 	add documentation
  */
 
 #include <stdlib.h>
@@ -33,7 +41,7 @@
 #include <string.h>
 #include <time.h>
 #include <netinet/in.h>
-
+#include <assert.h>
 #include <sys/types.h>
 #include <sys/socket.h>
 
@@ -50,7 +58,7 @@
 #define SOL_NETLINK 270
 #endif
 
-
+/* FIXME: this should vanish, but it is used by listen() and talk() */
 #define nfnl_error(format, args...) \
 	fprintf(stderr, "%s: " format "\n", __FUNCTION__, ## args)
 
@@ -104,8 +112,16 @@
 	}
 }
 
+/**
+ * nfnl_fd - returns the descriptor that identifies the socket
+ * @nfnlh: nfnetlink handler
+ *
+ * Use this function if you need to interact with the socket. Common
+ * scenarios are the use of poll()/select() to achieve multiplexation.
+ */
 int nfnl_fd(struct nfnl_handle *h)
 {
+	assert(h);
 	return h->fd;
 }
 
@@ -117,14 +133,11 @@
 	for (i = 0; i < NFNL_MAX_SUBSYS; i++)
 		new_subscriptions |= nfnlh->subsys[i].subscriptions;
 
-
 	nfnlh->local.nl_groups = new_subscriptions;
 	err = bind(nfnlh->fd, (struct sockaddr *)&nfnlh->local,
 		   sizeof(nfnlh->local));
-	if (err < 0) {
-		nfnl_error("bind(netlink): %s", strerror(errno));
-		return err;
-	}
+	if (err == -1)
+		return -1;
 
 	nfnlh->subscriptions = new_subscriptions;
 
@@ -132,10 +145,13 @@
 }
 
 /**
- * nfnl_open - open a netlink socket
+ * nfnl_open - open a nfnetlink handler
  *
- * nfnlh: libnfnetlink handle to be allocated by user
+ * This function creates a nfnetlink handler, this is required to establish
+ * a communication between the userspace and the nfnetlink system.
  *
+ * On success, a valid address that points to a nfnl_handle structure
+ * is returned. On error, NULL is returned and errno is set approapiately.
  */
 struct nfnl_handle *nfnl_open(void)
 {
@@ -149,10 +165,8 @@
 
 	memset(nfnlh, 0, sizeof(*nfnlh));
 	nfnlh->fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_NETFILTER);
-	if (nfnlh->fd < 0) {
-		nfnl_error("socket(netlink): %s", strerror(errno));
+	if (nfnlh->fd == -1)
 		goto err_free;
-	}
 
 	nfnlh->local.nl_family = AF_NETLINK;
 	nfnlh->peer.nl_family = AF_NETLINK;
@@ -161,12 +175,11 @@
 	err = getsockname(nfnlh->fd, (struct sockaddr *)&nfnlh->local, 
 			  &addr_len);
 	if (addr_len != sizeof(nfnlh->local)) {
-		nfnl_error("Bad address length (%u != %zd)", addr_len,
-			   sizeof(nfnlh->local));
+		errno = EINVAL;
 		goto err_close;
 	}
 	if (nfnlh->local.nl_family != AF_NETLINK) {
-		nfnl_error("Bad address family %d", nfnlh->local.nl_family);
+		errno = EINVAL;
 		goto err_close;
 	}
 	nfnlh->seq = time(NULL);
@@ -183,8 +196,7 @@
 	err = getsockname(nfnlh->fd, (struct sockaddr *)&nfnlh->local, 
 			  &addr_len);
 	if (addr_len != sizeof(nfnlh->local)) {
-		nfnl_error("Bad address length (%u != %zd)", addr_len,
-			   sizeof(nfnlh->local));
+		errno = EINVAL;
 		goto err_close;
 	}
 
@@ -199,11 +211,18 @@
 
 /**
  * nfnl_subsys_open - open a netlink subsystem
+ * @nfnlh: libnfnetlink handle
+ * @subsys_id: which nfnetlink subsystem we are interested in
+ * @cb_count: number of callbacks that are used maximum.
+ * @subscriptions: netlink groups we want to be subscribed to
  *
- * nfnlh: libnfnetlink handle
- * subsys_id: which nfnetlink subsystem we are interested in
- * cb_count: number of callbacks that are used maximum.
- * subscriptions: netlink groups we want to be subscribed to
+ * This function creates a subsystem handler that contains the set of 
+ * callbacks that handle certain types of messages coming from a netfilter
+ * subsystem. Initially the callback set is empty, you can register callbacks
+ * via nfnl_callback_register().
+ *
+ * On error, NULL is returned and errno is set appropiately. On success,
+ * a valid address that points to a nfnl_subsys_handle structure is returned.
  */
 struct nfnl_subsys_handle *
 nfnl_subsys_open(struct nfnl_handle *nfnlh, u_int8_t subsys_id,
@@ -211,30 +230,30 @@
 {
 	struct nfnl_subsys_handle *ssh;
 
+	assert(nfnlh);
+
 	if (subsys_id > NFNL_MAX_SUBSYS) { 
-
+		errno = ENOENT;
 		return NULL;
 	}
 
 	ssh = &nfnlh->subsys[subsys_id];
 	if (ssh->cb) {
-
+		errno = EBUSY;
 		return NULL;
 	}
 
 	ssh->cb = malloc(sizeof(*(ssh->cb)) * cb_count);
-	if (!ssh->cb) {
-		
+	if (!ssh->cb)
 		return NULL;
-	}
 
 	ssh->nfnlh = nfnlh;
 	ssh->cb_count = cb_count;
 	ssh->subscriptions = subscriptions;
 	ssh->subsys_id = subsys_id;
 
-	/* FIXME: reimplement this based on 
-	 * setsockopt(nfnlh->fd, SOL_NETLINK, NETLINK_ADD_MEMBERSHIP,,) */
+	/* although now we have nfnl_join to subscribe to certain
+	 * groups, just keep this to ensure compatibility */
 	if (recalc_rebind_subscriptions(nfnlh) < 0) {
 		free(ssh->cb);
 		ssh->cb = NULL;
@@ -244,8 +263,16 @@
 	return ssh;
 }
 
+/**
+ * nfnl_subsys_close - close a nfnetlink subsys handler 
+ * @ssh: nfnetlink subsystem handler
+ *
+ * Release all the callbacks registered in a subsystem handler.
+ */
 void nfnl_subsys_close(struct nfnl_subsys_handle *ssh)
 {
+	assert(ssh);
+
 	ssh->subscriptions = 0;
 	ssh->cb_count = 0;
 	if (ssh->cb) {
@@ -255,15 +282,18 @@
 }
 
 /**
- * nfnl_close - close netlink socket
+ * nfnl_close - close a nfnetlink handler
+ * @nfnlh: nfnetlink handler
  *
- * nfnlh: libnfnetlink handle
- *
+ * This function closes the nfnetlink handler. On success, 0 is returned.
+ * On error, -1 is returned and errno is set appropiately.
  */
 int nfnl_close(struct nfnl_handle *nfnlh)
 {
 	int i, ret;
 
+	assert(nfnlh);
+
 	for (i = 0; i < NFNL_MAX_SUBSYS; i++)
 		nfnl_subsys_close(&nfnlh->subsys[i]);
 
@@ -277,13 +307,37 @@
 }
 
 /**
+ * nfnl_join - join a nfnetlink multicast group
+ * @nfnlh: nfnetlink handler
+ * @group: group we want to join
+ *
+ * This function is used to join a certain multicast group. It must be
+ * called once the nfnetlink handler has been created. If any doubt, 
+ * just use it if you have to listen to nfnetlink events.
+ *
+ * On success, 0 is returned. On error, -1 is returned and errno is set
+ * approapiately.
+ */
+int nfnl_join(const struct nfnl_handle *nfnlh, unsigned int group)
+{
+	assert(nfnlh);
+	return setsockopt(nfnlh->fd, SOL_NETLINK, NETLINK_ADD_MEMBERSHIP,
+			  &group, sizeof(group));
+}
+
+/**
  * nfnl_send - send a nfnetlink message through netlink socket
+ * @nfnlh: nfnetlink handler
+ * @n: netlink message
  *
- * nfnlh: libnfnetlink handle
- * n: netlink message
+ * On success, 0 is returned. On error, -1 is returned and errno is set
+ * appropiately.
  */
 int nfnl_send(struct nfnl_handle *nfnlh, struct nlmsghdr *n)
 {
+	assert(nfnlh);
+	assert(n);
+
 	nfnl_debug_dump_packet(n, n->nlmsg_len+sizeof(*n), "nfnl_send");
 
 	return sendto(nfnlh->fd, n, n->nlmsg_len, 0, 
@@ -293,6 +347,9 @@
 int nfnl_sendmsg(const struct nfnl_handle *nfnlh, const struct msghdr *msg,
 		 unsigned int flags)
 {
+	assert(nfnlh);
+	assert(msg);
+
 	return sendmsg(nfnlh->fd, msg, flags);
 }
 
@@ -301,6 +358,8 @@
 {
 	struct msghdr msg;
 
+	assert(nfnlh);
+
 	msg.msg_name = (struct sockaddr *) &nfnlh->peer;
 	msg.msg_namelen = sizeof(nfnlh->peer);
 	msg.msg_iov = (struct iovec *) iov;
@@ -314,18 +373,17 @@
 
 /**
  * nfnl_fill_hdr - fill in netlink and nfnetlink header
+ * @nfnlh: nfnetlink handle
+ * @nlh: netlink message to be filled in
+ * @len: length of _payload_ bytes (not including nfgenmsg)
+ * @family: AF_INET / ...
+ * @res_id: resource id
+ * @msg_type: nfnetlink message type (without subsystem)
+ * @msg_flags: netlink message flags
  *
- * nfnlh: libnfnetlink handle
- * nlh: netlink header to be filled in
- * len: length of _payload_ bytes (not including nfgenmsg)
- * family: AF_INET / ...
- * res_id: resource id
- * msg_type: nfnetlink message type (without subsystem)
- * msg_flags: netlink message flags
- *
- * NOTE: the nlmsghdr must point to a memory region of at least
- * the size of struct nlmsghdr + struct nfgenmsg
- *
+ * This function sets up appropiately the nfnetlink header. See that the
+ * pointer to the netlink message passed must point to a memory region of
+ * at least the size of struct nlmsghdr + struct nfgenmsg.
  */
 void nfnl_fill_hdr(struct nfnl_subsys_handle *ssh,
 		    struct nlmsghdr *nlh, unsigned int len, 
@@ -334,6 +392,9 @@
 		    u_int16_t msg_type,
 		    u_int16_t msg_flags)
 {
+	assert(ssh);
+	assert(nlh);
+
 	struct nfgenmsg *nfg = (struct nfgenmsg *) 
 					((void *)nlh + sizeof(*nlh));
 
@@ -343,6 +404,10 @@
 	nlh->nlmsg_pid = 0;
 	nlh->nlmsg_seq = ++ssh->nfnlh->seq;
 
+	/* check for wraparounds: assume that seqnum 0 is only used by events */
+	if (!ssh->nfnlh->seq)
+		nlh->nlmsg_seq = ssh->nfnlh->seq = time(NULL);
+
 	nfg->nfgen_family = family;
 	nfg->version = NFNETLINK_V0;
 	nfg->res_id = htons(res_id);
@@ -368,6 +433,22 @@
 	return ((void *)nlh + NLMSG_LENGTH(sizeof(struct nfgenmsg)));
 }
 
+/**
+ * nfnl_recv - receive data from a nfnetlink subsystem
+ * @h: nfnetlink handler
+ * @buf: buffer where the data will be stored
+ * @len: size of the buffer
+ *
+ * This function doesn't perform any sanity checking. So do no expect
+ * that the data is well-formed. Such checkings are done by the parsing
+ * functions.
+ *
+ * On success, 0 is returned. On error, -1 is returned and errno is set
+ * appropiately.
+ *
+ * Note that ENOBUFS is returned in case that nfnetlink is exhausted. In
+ * that case is possible that the information requested is incomplete.
+ */
 ssize_t 
 nfnl_recv(const struct nfnl_handle *h, unsigned char *buf, size_t len)
 {
@@ -375,6 +456,10 @@
 	int status;
 	struct nlmsghdr *nlh;
 	struct sockaddr_nl peer;
+
+	assert(h);
+	assert(buf);
+	assert(len > 0);
 	
 	if (len < sizeof(struct nlmsgerr)
 	    || len < sizeof(struct nlmsghdr))
@@ -400,9 +485,8 @@
 }
 /**
  * nfnl_listen: listen for one or more netlink messages
- *
- * nfnhl: libnfnetlink handle
- * handler: callback function to be called for every netlink message
+ * @nfnhl: libnfnetlink handle
+ * @handler: callback function to be called for every netlink message
  *          - the callback handler should normally return 0
  *          - but may return a negative error code which will cause
  *            nfnl_listen to return immediately with the same error code
@@ -413,8 +497,14 @@
  *          without any loss of data, a negative error code will terminate
  *          nfnl_listen "very soon" and throw away data already read from
  *          the netlink socket.
- * jarg: opaque argument passed on to callback
+ * @jarg: opaque argument passed on to callback
  *
+ * This function is used to receive and process messages coming from an open
+ * nfnetlink handler like events or information request via nfnl_send().
+ *
+ * On error, -1 is returned, unfortunately errno is not always set
+ * appropiately. For that reason, the use of this function is DEPRECATED. 
+ * Please, use nfnl_receive_process() instead.
  */
 int nfnl_listen(struct nfnl_handle *nfnlh,
 		int (*handler)(struct sockaddr_nl *, struct nlmsghdr *n,
@@ -511,6 +601,20 @@
 	return quit;
 }
 
+/**
+ * nfnl_talk - send a request and then receive and process messages returned
+ * @nfnlh: nfnetelink handler
+ * @n: netlink message that contains the request
+ * @peer: peer PID
+ * @groups: netlink groups
+ * @junk: callback called if out-of-sequence messages were received
+ * @jarg: data for the junk callback
+ *
+ * This function is used to request an action that does not returns any
+ * information. On error, a negative value is returned, errno could be
+ * set appropiately. For that reason, the use of this function is DEPRECATED.
+ * Please, use nfnl_send_received_process() instead.
+ */
 int nfnl_talk(struct nfnl_handle *nfnlh, struct nlmsghdr *n, pid_t peer,
 	      unsigned groups, struct nlmsghdr *answer,
 	      int (*junk)(struct sockaddr_nl *, struct nlmsghdr *n, void *),
@@ -629,13 +733,11 @@
 
 /**
  * nfnl_addattr_l - Add variable length attribute to nlmsghdr
- *
- * n: netlink message header to which attribute is to be added
- * maxlen: maximum length of netlink message header
- * type: type of new attribute
- * data: content of new attribute
- * alen: attribute length
- *
+ * @n: netlink message header to which attribute is to be added
+ * @maxlen: maximum length of netlink message header
+ * @type: type of new attribute
+ * @data: content of new attribute
+ * @len: attribute length
  */
 int nfnl_addattr_l(struct nlmsghdr *n, int maxlen, int type, void *data,
 		   int alen)
@@ -643,9 +745,12 @@
 	int len = NFA_LENGTH(alen);
 	struct nfattr *nfa;
 
+	assert(n);
+	assert(maxlen > 0);
+	assert(type >= 0);
+
 	if ((NLMSG_ALIGN(n->nlmsg_len) + len) > maxlen) {
-		nfnl_error("%d greater than maxlen (%d)\n",
-			   NLMSG_ALIGN(n->nlmsg_len) + len, maxlen);
+		errno = ENOSPC;
 		return -1;
 	}
 
@@ -673,8 +778,14 @@
 	struct nfattr *subnfa;
 	int len = NFA_LENGTH(alen);
 
-	if ((NFA_OK(nfa, nfa->nfa_len) + len) > maxlen)
+	assert(nfa);
+	assert(maxlen > 0);
+	assert(type >= 0);
+
+	if ((NFA_OK(nfa, nfa->nfa_len) + len) > maxlen) {
+		errno = ENOSPC;
 		return -1;
+	}
 
 	subnfa = (struct nfattr *)(((char *)nfa) + NFA_OK(nfa, nfa->nfa_len));
 	subnfa->nfa_type = type;
@@ -697,6 +808,9 @@
 int nfnl_nfa_addattr16(struct nfattr *nfa, int maxlen, int type, 
 		       u_int16_t data)
 {
+	assert(nfa);
+	assert(maxlen > 0);
+	assert(type >= 0);
 
 	return nfnl_nfa_addattr_l(nfa, maxlen, type, &data, sizeof(data));
 }
@@ -713,6 +827,10 @@
 int nfnl_addattr16(struct nlmsghdr *n, int maxlen, int type,
 		   u_int16_t data)
 {
+	assert(n);
+	assert(maxlen > 0);
+	assert(type >= 0);
+
 	return nfnl_addattr_l(n, maxlen, type, &data, sizeof(data));
 }
 
@@ -728,6 +846,9 @@
 int nfnl_nfa_addattr32(struct nfattr *nfa, int maxlen, int type, 
 		       u_int32_t data)
 {
+	assert(nfa);
+	assert(maxlen > 0);
+	assert(type >= 0);
 
 	return nfnl_nfa_addattr_l(nfa, maxlen, type, &data, sizeof(data));
 }
@@ -744,6 +865,10 @@
 int nfnl_addattr32(struct nlmsghdr *n, int maxlen, int type,
 		   u_int32_t data)
 {
+	assert(n);
+	assert(maxlen > 0);
+	assert(type >= 0);
+
 	return nfnl_addattr_l(n, maxlen, type, &data, sizeof(data));
 }
 
@@ -758,6 +883,10 @@
  */
 int nfnl_parse_attr(struct nfattr *tb[], int max, struct nfattr *nfa, int len)
 {
+	assert(tb);
+	assert(max > 0);
+	assert(nfa);
+
 	memset(tb, 0, sizeof(struct nfattr *) * max);
 
 	while (NFA_OK(nfa, len)) {
@@ -765,8 +894,7 @@
 			tb[NFA_TYPE(nfa)-1] = nfa;
                 nfa = NFA_NEXT(nfa,len);
 	}
-	if (len)
-		nfnl_error("deficit (%d) len (%d).\n", len, nfa->nfa_len);
+	assert(len == 0);
 
 	return 0;
 }
@@ -784,6 +912,9 @@
 void nfnl_build_nfa_iovec(struct iovec *iov, struct nfattr *nfa, 
 			  u_int16_t type, u_int32_t len, unsigned char *val)
 {
+	assert(iov);
+	assert(nfa);
+
         /* Set the attribut values */ 
         nfa->nfa_len = sizeof(struct nfattr) + len;
         nfa->nfa_type = type;
@@ -798,12 +929,25 @@
 #define SO_RCVBUFFORCE	(33)
 #endif
 
+/**
+ * nfnl_rcvbufsiz - set the socket buffer size
+ * @h: nfnetlink handler
+ * @size: size of the buffer we want to set
+ *
+ * This function sets the new size of the socket buffer. Use this setting
+ * to increase the socket buffer size if your system is reporting ENOBUFS
+ * errors.
+ *
+ * This function returns the new size of the socket buffer.
+ */
 unsigned int nfnl_rcvbufsiz(struct nfnl_handle *h, unsigned int size)
 {
 	int status;
 	socklen_t socklen = sizeof(size);
 	unsigned int read_size = 0;
 
+	assert(h);
+
 	/* first we try the FORCE option, which is introduced in kernel
 	 * 2.6.14 to give "root" the ability to override the system wide
 	 * maximum */
@@ -818,13 +962,28 @@
 	return read_size;
 }
 
-
+/**
+ * nfnl_get_msg_first - get the first message of a multipart netlink message
+ * @h: nfnetlink handle
+ * @buf: data received that we want to process
+ * @len: size of the data received
+ *
+ * This function returns a pointer to the first netlink message contained
+ * in the chunk of data received from certain nfnetlink subsystem.
+ *
+ * On success, a valid address that points to the netlink message is returned.
+ * On error, NULL is returned.
+ */
 struct nlmsghdr *nfnl_get_msg_first(struct nfnl_handle *h,
 				    const unsigned char *buf,
 				    size_t len)
 {
 	struct nlmsghdr *nlh;
 
+	assert(h);
+	assert(buf);
+	assert(len > 0);
+
 	/* first message in buffer */
 	nlh = (struct nlmsghdr *)buf;
 	if (!NLMSG_OK(nlh, len))
@@ -841,6 +1000,10 @@
 	struct nlmsghdr *nlh;
 	size_t remain_len;
 
+	assert(h);
+	assert(buf);
+	assert(len > 0);
+
 	/* if last header in handle not inside this buffer, 
 	 * drop reference to last header */
 	if (!h->last_nlhdr ||
@@ -872,9 +1035,21 @@
 	return nlh;
 }
 
+/**
+ * nfnl_callback_register - register a callback for a certain message type
+ * @ssh: nfnetlink subsys handler
+ * @type: subsys call
+ * @cb: nfnetlink callback to be registered
+ *
+ * On success, 0 is returned. On error, -1 is returned and errno is set
+ * appropiately.
+ */
 int nfnl_callback_register(struct nfnl_subsys_handle *ssh,
 			   u_int8_t type, struct nfnl_callback *cb)
 {
+	assert(ssh);
+	assert(cb);
+
 	if (type >= ssh->cb_count)
 		return -EINVAL;
 
@@ -883,8 +1058,18 @@
 	return 0;
 }
 
+/**
+ * nfnl_callback_unregister - unregister a certain callback
+ * @ssh: nfnetlink subsys handler
+ * @type: subsys call
+ *
+ * On sucess, 0 is returned. On error, -1 is returned and errno is
+ * set appropiately.
+ */
 int nfnl_callback_unregister(struct nfnl_subsys_handle *ssh, u_int8_t type)
 {
+	assert(ssh);
+
 	if (type >= ssh->cb_count)
 		return -EINVAL;
 
@@ -897,6 +1082,10 @@
 			 const struct nlmsghdr *nlh,
 			 struct nfattr *nfa[])
 {
+	assert(h);
+	assert(nlh);
+	assert(nfa);
+
 	int min_len;
 	u_int8_t type = NFNL_MSG_TYPE(nlh->nlmsg_type);
 	u_int8_t subsys_id = NFNL_SUBSYS_ID(nlh->nlmsg_type);
@@ -997,3 +1186,351 @@
 	}
 	return 0;
 }
+
+static int nfnl_is_error(struct nfnl_handle *h, struct nlmsghdr *nlh)
+{
+	/* This message is an ACK or a DONE */
+	if (nlh->nlmsg_type == NLMSG_ERROR ||
+	    (nlh->nlmsg_type == NLMSG_DONE &&
+	     nlh->nlmsg_flags & NLM_F_MULTI)) {
+		if (nlh->nlmsg_len < NLMSG_ALIGN(sizeof(struct nlmsgerr))) {
+			errno = EBADMSG;
+			return 1;
+		}
+		errno = *((int *)NLMSG_DATA(nlh));
+		return 1;
+	}
+	return 0;
+}
+
+/* On error, -1 is returned and errno is set appropiately. On success, 
+ * 0 is returned if there is no more data to process, >0 if there is
+ * more data to process */
+static int nfnl_step(struct nfnl_handle *h, struct nlmsghdr *nlh)
+{
+	struct nfnl_subsys_handle *ssh;
+	u_int8_t type = NFNL_MSG_TYPE(nlh->nlmsg_type);
+	u_int8_t subsys_id = NFNL_SUBSYS_ID(nlh->nlmsg_type);
+
+	/* Is this an error message? */
+	if (nfnl_is_error(h, nlh)) {
+		/* This is an ACK */
+		if (errno == 0)
+			return 0;
+		/* This an error message */
+		return -1;
+	}
+	
+	/* nfnetlink sanity checks: check for nfgenmsg size */
+	if (nlh->nlmsg_len < NLMSG_SPACE(sizeof(struct nfgenmsg))) {
+		errno = ENOSPC;
+		return -1;
+	}
+
+	if (subsys_id > NFNL_MAX_SUBSYS) {
+		errno = ENOENT;
+		return -1;
+	}
+
+	ssh = &h->subsys[subsys_id];
+	if (!ssh) {
+		errno = ENOENT;
+		return -1;
+	}
+
+	if (type >= ssh->cb_count) {
+		errno = ENOENT;
+		return -1;
+	}
+
+	if (ssh->cb[type].attr_count) {
+		int err;
+		struct nfattr *tb[ssh->cb[type].attr_count];
+		struct nfattr *attr = NFM_NFA(NLMSG_DATA(nlh));
+		int min_len = NLMSG_SPACE(sizeof(struct nfgenmsg));
+		int len = nlh->nlmsg_len - NLMSG_ALIGN(min_len);
+
+		err = nfnl_parse_attr(tb, ssh->cb[type].attr_count, attr, len);
+		if (err == -1)
+			return -1;
+
+		if (ssh->cb[type].call) {
+			/*
+			 * On error, the callback returns -1 and errno must 
+			 * be explicitely set. On success, 0 is returned
+			 * and we're done, otherwise >0 is returned that
+			 * means that we want to continue data processing.
+			 */
+			return ssh->cb[type].call(nlh,
+						  tb,
+						  ssh->cb[type].data);
+		}
+	}
+	/* no callback set, continue data processing */
+	return 1;
+}
+
+/**
+ * nfnl_process - process data coming from a nfnetlink system
+ * @h: nfnetlink handler
+ * @buf: buffer that contains the netlink message
+ * @len: size of the data contained in the buffer (not the buffer size)
+ *
+ * This function processes all the nfnetlink messages contained inside a
+ * buffer. It performs the appropiate sanity checks and passes the message
+ * to a certain handler that is registered via register_callback().
+ *
+ * On success, 0 is returned if the data processing has finished. If a
+ * value > 0 is returned, then there is more data to process. On error, 
+ * -1 is returned and errno is set to the appropiate value.
+ *
+ * Note that the callback must return -1 and set errno in case of error.
+ * If your callback decides not to process data anymore for any reason,
+ * then it must return 0. Otherwise, if the callback continues the 
+ * processing 1 is returned.
+ */
+int nfnl_process(struct nfnl_handle *h, const unsigned char *buf, size_t len)
+{
+	int ret = 0;
+	struct nlmsghdr *nlh = (struct nlmsghdr *)buf;
+
+	assert(h);
+	assert(buf);
+	assert(len > 0);
+
+	/* check for out of sequence message */
+	if (nlh->nlmsg_seq && nlh->nlmsg_seq != h->seq) {
+		errno = EILSEQ;
+		return -1;
+	}
+	while (len >= NLMSG_SPACE(0) && NLMSG_OK(nlh, len)) {
+
+		ret = nfnl_step(h, nlh);
+		if (ret <= 0)
+			break;
+
+		nlh = NLMSG_NEXT(nlh, len);
+	}
+	return ret;
+}
+
+/*
+ * New parsing functions based on iterators
+ */
+
+struct nfnl_iterator {
+	struct nlmsghdr *nlh;
+	unsigned int	len;
+};
+
+/**
+ * nfnl_iterator_create: create an nfnetlink iterator
+ * @h: nfnetlink handler
+ * @buf: buffer that contains data received from a nfnetlink system
+ * @len: size of the data contained in the buffer (not the buffer size)
+ *
+ * This function creates an iterator that can be used to parse nfnetlink
+ * message one by one. The iterator gives more control to the programmer
+ * in the messages processing.
+ *
+ * On success, a valid address is returned. On error, NULL is returned
+ * and errno is set to the appropiate value.
+ */
+struct nfnl_iterator *
+nfnl_iterator_create(const struct nfnl_handle *h,
+		     const char *buf,
+		     size_t len)
+{
+	struct nlmsghdr *nlh;
+	struct nfnl_iterator *it;
+
+	assert(h);
+	assert(buf);
+	assert(len > 0);
+
+	it = malloc(sizeof(struct nfnl_iterator));
+	if (!it) {
+		errno = ENOMEM;
+		return NULL;
+	}
+
+	/* first message in buffer */
+	nlh = (struct nlmsghdr *)buf;
+	if (len < NLMSG_SPACE(0) || !NLMSG_OK(nlh, len)) {
+		free(it);
+		errno = EBADMSG;
+		return NULL;
+	}
+	it->nlh = nlh;
+	it->len = len;
+
+	return it;
+}
+
+/**
+ * nfnl_iterator_destroy - destroy a nfnetlink iterator
+ * @it: nfnetlink iterator
+ *
+ * This function destroys a certain iterator. Nothing is returned.
+ */
+void nfnl_iterator_destroy(struct nfnl_iterator *it)
+{
+	assert(it);
+	free(it);
+}
+
+/**
+ * nfnl_iterator_process - process a nfnetlink message
+ * @h: nfnetlink handler
+ * @it: nfnetlink iterator that contains the current message to be proccesed
+ *
+ * This function process just the current message selected by the iterator.
+ * On success, a value greater or equal to zero is returned. On error,
+ * -1 is returned and errno is appropiately set.
+ */
+int nfnl_iterator_process(struct nfnl_handle *h, struct nfnl_iterator *it)
+{
+	assert(h);
+	assert(it->nlh);
+
+        /* check for out of sequence message */
+	if (it->nlh->nlmsg_seq && it->nlh->nlmsg_seq != h->seq) {
+		errno = EILSEQ;
+		return -1;
+	}	
+	if (it->len < NLMSG_SPACE(0) || !NLMSG_OK(it->nlh, it->len)) {
+		errno = EBADMSG;
+		return -1;
+	}
+	return nfnl_step(h, it->nlh);
+}
+
+/**
+ * nfnl_iterator_next - get the next message hold by the iterator
+ * @h: nfnetlink handler
+ * @it: nfnetlink iterator that contains the current message processed
+ *
+ * This function update the current message to be processed pointer.
+ * It returns 1 if there is still more messages to be processed, otherwise 
+ * 0 is returned.
+ */
+int nfnl_iterator_next(const struct nfnl_handle *h, struct nfnl_iterator *it)
+{
+	assert(h);
+	assert(it);
+
+	it->nlh = NLMSG_NEXT(it->nlh, it->len);
+	if (!it->nlh)
+		return 0;
+	return 1;
+}
+
+/**
+ * nfnl_catch - get responses from the nfnetlink system and process them
+ * @h: nfnetlink handler
+*
+ * This function handles the data received from the nfnetlink system.
+ * For example, events generated by one of the subsystems. The message
+ * is passed to the callback registered via callback_register(). Note that
+ * this a replacement of nfnl_listen and its use is recommended.
+ * 
+ * On success, 0 is returned. On error, a -1 is returned. If your does not
+ * want to listen to events anymore, then it must return a value equal
+ * to -1 and set errno to 0 (success).
+ *
+ * Note that ENOBUFS is returned in case that nfnetlink is exhausted. In
+ * that case is possible that the information requested is incomplete.
+ */
+int nfnl_catch(struct nfnl_handle *h)
+{
+	int ret;
+	unsigned int size = NFNL_BUFFSIZE;
+
+	assert(h);
+
+	/*
+	 * Since nfqueue can send big packets, we don't know how big
+	 * must be the buffer that have to store the received data.
+	 */
+	{
+		unsigned char buf[size];
+		struct sockaddr_nl peer;
+		struct iovec iov = {
+			.iov_len = size,
+		};
+		struct msghdr msg = {
+			.msg_name = (void *) &peer,
+			.msg_namelen = sizeof(peer),
+			.msg_iov = &iov,
+			.msg_iovlen = 1,
+			.msg_control = NULL,
+			.msg_controllen = 0,
+			.msg_flags = 0
+		};
+
+		memset(&peer, 0, sizeof(peer));
+		peer.nl_family = AF_NETLINK;
+		iov.iov_base = buf;
+		iov.iov_len = size;
+
+retry:		ret = recvmsg(h->fd, &msg, MSG_PEEK);
+		if (ret == -1) {
+			/* interrupted syscall must retry */
+			if (errno == EINTR)
+				goto retry;
+			/* otherwise give up */
+			return -1;
+		}
+
+		if (msg.msg_flags & MSG_TRUNC)
+			/* maximum size of data received from netlink */
+			size = 65535;
+	}
+
+	/* now, receive data from netlink */
+	while (1) {
+		unsigned char buf[size];
+
+		ret = nfnl_recv(h, buf, sizeof(buf));
+		if (ret == -1) {
+			/* interrupted syscall must retry */
+			if (errno == EINTR)
+				continue;
+			break;
+		}
+
+		ret = nfnl_process(h, buf, ret);
+		if (ret <= 0)
+			break; 
+	}
+
+	return ret;
+}
+
+/**
+ * nfnl_query - request/response communication challenge
+ * @h: nfnetlink handler
+ * @nlh: nfnetlink message to be sent
+ *
+ * This function sends a nfnetlink message to a certain subsystem and
+ * receives the response messages associated, such messages are passed to
+ * the callback registered via register_callback(). Note that this function
+ * is a replacement for nfnl_talk, its use is recommended.
+ *
+ * On success, 0 is returned. On error, a negative is returned. If your
+ * does not want to listen to events anymore, then it must return a value
+ * lesser or equal to 0.
+ *
+ * Note that ENOBUFS is returned in case that nfnetlink is exhausted. In
+ * that case is possible that the information requested is incomplete.
+ */
+int nfnl_query(struct nfnl_handle *h, struct nlmsghdr *nlh)
+{
+	assert(h);
+	assert(nlh);
+
+	if (nfnl_send(h, nlh) == -1)
+		return -1;
+
+	return nfnl_catch(h);
+}

--------------050502010109010004040303--
