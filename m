From: Skylar Chang <chiaweic@codeaurora.org>
Subject: [PATCH] libnfnetlink: Add API support for passing bound file descriptor
Date: Mon,  3 Apr 2017 15:44:27 -0700
Message-ID: <1491259467-21230-1-git-send-email-chiaweic@codeaurora.org>
Cc: Skylar Chang <chiaweic@codeaurora.org>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        npendhar@codeaurora.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37248 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751515AbdDCWod (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Apr 2017 18:44:33 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add API support to accept pre-bound file descriptor from a
privileged process for creating a handle. Also clean-up
the handle without close the passing file descriptor. This
paves the path for privilege separation.

Signed-off-by: Skylar Chang <chiaweic@codeaurora.org>
---
 include/libnfnetlink/libnfnetlink.h |   7 +++
 src/libnfnetlink.c                  | 116 ++++++++++++++++++++++++++++++------
 2 files changed, 106 insertions(+), 17 deletions(-)

diff --git a/include/libnfnetlink/libnfnetlink.h b/include/libnfnetlink/libnfnetlink.h
index cd0be3d..437eb55 100644
--- a/include/libnfnetlink/libnfnetlink.h
+++ b/include/libnfnetlink/libnfnetlink.h
@@ -19,6 +19,7 @@
 #include <sys/socket.h>	/* for sa_family_t */
 #include <linux/netlink.h>
 #include <libnfnetlink/linux_nfnetlink.h>
+#include <stdbool.h>
 
 #ifndef NETLINK_NETFILTER
 #define NETLINK_NETFILTER 12
@@ -67,11 +68,17 @@ extern unsigned int nfnl_portid(const struct nfnl_handle *h);
 
 /* get a new library handle */
 extern struct nfnl_handle *nfnl_open(void);
+extern struct nfnl_handle *nfnl_open2(int fd, bool bind);
 extern int nfnl_close(struct nfnl_handle *);
+extern int nfnl_close2(struct nfnl_handle *);
 
 extern struct nfnl_subsys_handle *nfnl_subsys_open(struct nfnl_handle *, 
 						   uint8_t, uint8_t,
 						   unsigned int);
+extern struct nfnl_subsys_handle *nfnl_subsys_open2(struct nfnl_handle *,
+						   u_int8_t, u_int8_t,
+						   unsigned int,
+						   bool bind);
 extern void nfnl_subsys_close(struct nfnl_subsys_handle *);
 
 /* set and unset sequence tracking */
diff --git a/src/libnfnetlink.c b/src/libnfnetlink.c
index df57533..9fba98e 100644
--- a/src/libnfnetlink.c
+++ b/src/libnfnetlink.c
@@ -161,6 +161,18 @@ static int recalc_rebind_subscriptions(struct nfnl_handle *nfnlh)
 	return 0;
 }
 
+static void recalc_subscriptions(struct nfnl_handle *nfnlh)
+{
+	int i;
+	u_int32_t new_subscriptions = nfnlh->subscriptions;
+
+	for (i = 0; i < NFNL_MAX_SUBSYS; i++)
+		new_subscriptions |= nfnlh->subsys[i].subscriptions;
+
+	nfnlh->local.nl_groups = new_subscriptions;
+	nfnlh->subscriptions = new_subscriptions;
+}
+
 /**
  * nfnl_open - open a nfnetlink handler
  *
@@ -173,16 +185,42 @@ static int recalc_rebind_subscriptions(struct nfnl_handle *nfnlh)
 struct nfnl_handle *nfnl_open(void)
 {
 	struct nfnl_handle *nfnlh;
+	int fd;
+
+	fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_NETFILTER);
+	if (fd == -1)
+		return NULL;
+	nfnlh = nfnl_open2(fd, true);
+	if (nfnlh == NULL)
+		close(fd);
+	return nfnlh;
+}
+
+/**
+ * nfnl_open2 - open a nfnetlink handler
+ * @fd: passing file descriptor
+ * @bind:  indicate the passing fd needs to be binded or not
+ *
+ * This function creates a nfnetlink handler, this is required to establish
+ * a communication between the userspace and the nfnetlink system.
+ *
+ * On success, a valid address that points to a nfnl_handle structure
+ * is returned. On error, NULL is returned and errno is set approapiately.
+ */
+struct nfnl_handle *nfnl_open2(int fd, bool bind)
+{
+	struct nfnl_handle *nfnlh;
 	unsigned int addr_len;
 
+	if (!fd)
+		goto err;
+
 	nfnlh = malloc(sizeof(*nfnlh));
 	if (!nfnlh)
 		return NULL;
 
 	memset(nfnlh, 0, sizeof(*nfnlh));
-	nfnlh->fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_NETFILTER);
-	if (nfnlh->fd == -1)
-		goto err_free;
+	nfnlh->fd = fd;
 
 	nfnlh->local.nl_family = AF_NETLINK;
 	nfnlh->peer.nl_family = AF_NETLINK;
@@ -191,11 +229,11 @@ struct nfnl_handle *nfnl_open(void)
 	getsockname(nfnlh->fd, (struct sockaddr *)&nfnlh->local, &addr_len);
 	if (addr_len != sizeof(nfnlh->local)) {
 		errno = EINVAL;
-		goto err_close;
+		goto err_free;
 	}
 	if (nfnlh->local.nl_family != AF_NETLINK) {
 		errno = EINVAL;
-		goto err_close;
+		goto err_free;
 	}
 	nfnlh->seq = time(NULL);
 	nfnlh->rcv_buffer_size = NFNL_BUFFSIZE;
@@ -204,25 +242,28 @@ struct nfnl_handle *nfnl_open(void)
 	 * binding to pid '0' will default */
 
 	/* let us do the initial bind */
-	if (recalc_rebind_subscriptions(nfnlh) < 0)
-		goto err_close;
+	if (bind) {
+		if (recalc_rebind_subscriptions(nfnlh) < 0)
+			goto err_free;
+	} else {
+		recalc_subscriptions(nfnlh);
+	}
 
 	/* use getsockname to get the netlink pid that the kernel assigned us */
 	addr_len = sizeof(nfnlh->local);
 	getsockname(nfnlh->fd, (struct sockaddr *)&nfnlh->local, &addr_len);
 	if (addr_len != sizeof(nfnlh->local)) {
 		errno = EINVAL;
-		goto err_close;
+		goto err_free;
 	}
 	/* sequence tracking enabled by default */
 	nfnlh->flags |= NFNL_F_SEQTRACK_ENABLED;
 
 	return nfnlh;
 
-err_close:
-	close(nfnlh->fd);
 err_free:
 	free(nfnlh);
+err:
 	return NULL;
 }
 
@@ -276,7 +317,31 @@ struct nfnl_subsys_handle *
 nfnl_subsys_open(struct nfnl_handle *nfnlh, uint8_t subsys_id,
 		 uint8_t cb_count, uint32_t subscriptions)
 {
+	return nfnl_subsys_open2 (nfnlh, subsys_id, cb_count, subscriptions, true);
+}
+
+/**
+ * nfnl_subsys_open2 - open a netlink subsystem
+ * @nfnlh: libnfnetlink handle
+ * @subsys_id: which nfnetlink subsystem we are interested in
+ * @cb_count: number of callbacks that are used maximum.
+ * @subscriptions: netlink groups we want to be subscribed to
+ * @bind: indicate the passing fd needs to be binded or not
+ *
+ * This function creates a subsystem handler that contains the set of
+ * callbacks that handle certain types of messages coming from a netfilter
+ * subsystem. Initially the callback set is empty, you can register callbacks
+ * via nfnl_callback_register().
+ *
+ * On error, NULL is returned and errno is set appropiately. On success,
+ * a valid address that points to a nfnl_subsys_handle structure is returned.
+ */
+struct nfnl_subsys_handle *
+nfnl_subsys_open2(struct nfnl_handle *nfnlh, u_int8_t subsys_id,
+		 u_int8_t cb_count, u_int32_t subscriptions, bool bind)
+{
 	struct nfnl_subsys_handle *ssh;
+	int err = 0;
 
 	assert(nfnlh);
 
@@ -302,12 +367,15 @@ nfnl_subsys_open(struct nfnl_handle *nfnlh, uint8_t subsys_id,
 
 	/* although now we have nfnl_join to subscribe to certain
 	 * groups, just keep this to ensure compatibility */
-	if (recalc_rebind_subscriptions(nfnlh) < 0) {
+	if (bind)
+		err = recalc_rebind_subscriptions(nfnlh);
+	else
+		recalc_subscriptions(nfnlh);
+	if (err < 0) {
 		free(ssh->cb);
 		ssh->cb = NULL;
 		return NULL;
 	}
-	
 	return ssh;
 }
 
@@ -338,16 +406,30 @@ void nfnl_subsys_close(struct nfnl_subsys_handle *ssh)
  */
 int nfnl_close(struct nfnl_handle *nfnlh)
 {
-	int i, ret;
+	int ret;
 
 	assert(nfnlh);
-
-	for (i = 0; i < NFNL_MAX_SUBSYS; i++)
-		nfnl_subsys_close(&nfnlh->subsys[i]);
-
 	ret = close(nfnlh->fd);
 	if (ret < 0)
 		return ret;
+	return nfnl_close2(nfnlh);
+}
+
+/**
+ * nfnl_close2 - close a nfnetlink handler but keep fd
+ * @nfnlh: nfnetlink handler
+ *
+ * This function closes the nfnetlink handler. On success, 0 is returned.
+ * On error, -1 is returned and errno is set appropiately.
+ */
+int nfnl_close2(struct nfnl_handle *nfnlh)
+{
+	int i;
+
+	assert(nfnlh);
+
+	for (i = 0; i < NFNL_MAX_SUBSYS; i++)
+		nfnl_subsys_close(&nfnlh->subsys[i]);
 
 	free(nfnlh);
 
-- 
1.9.1

