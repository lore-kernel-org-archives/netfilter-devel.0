Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D978984DF1
	for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2024 05:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716529095; cv=none; b=WXKITGiFTot2PNVSOxRNJ4tHcHfSkHF1PhT6Sv470uHDLRimXuqbu+rTymolt3wP3kTaKAGC+MWBHgs5GWAQ+ljiVm8pd2u+nWtpAzg8klZlHnTiOpZakcx2R1iP+iEUndd7HdyZSJWXYP1+5HCJ6ONu3P+XhAYHIdpU/xVw5M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716529095; c=relaxed/simple;
	bh=xLiVJfRHHJxC1A3TC6u1D4Y7SGVM4po4QxDMtojH9Gg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=F2dWjallFATzwR9bWcj8ga37LLVjB2jORAUN2wXVDzXcVmgPy/KqTF2aRG4JX1KRAwhGO0y1+erMFZ7ILteaHm60NNFwLVyMcjLslo4I3oRFjCPDDslXKI9nALKUREJ05aHEn0iTx0yNG7xzRLOfBbnkI/Igb5tR/uX+Dy5tyfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ONLVcm75; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ONLVcm75"
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-245435c02e1so3836785fac.0
        for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2024 22:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716529093; x=1717133893; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wc097ZdK9FKQK0xHnCZX9MymtoL82FjafMgcYdHnZbM=;
        b=ONLVcm75mEEYNWTYKXszwYvAXQG8pxUefzVCcE3w5P96H+Hixz2FcCPL12Klui9ZPu
         JiBnZGsI6+w1jnhjFU430aLkBQPINYYVK1EUyPidUXkpuJjL1HoY/at7n3rvniCP9NyV
         TEWYW41KdfY/JmMeBb6tR+j6zgtT5GnbrfbyjX+64dyHG0JPFA4bUqRq0+u+EesciU7i
         Sr+6bm+geHH6WmZ2W28yNr+5YikHXCep6xqb7ZBNtm8JVxILv0YmmSEXXxlcCcELjH2F
         ToHGhU2/ancuphkLwQm0L/7wnZnf2lnaUIzxgAHeZKk953miSsVrLt+7m+ABhT/TuHB/
         aBtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716529093; x=1717133893;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wc097ZdK9FKQK0xHnCZX9MymtoL82FjafMgcYdHnZbM=;
        b=qFydJWyTf0T72XaNlh5QQMgEt2al6RhzZsuGlmutAiQklwmXvOFRNjI6YImF/VNWNv
         VAEDP+kPiIJmFUVf8vVYOvH8sbSp5y7lc703VYQXCuTRXbgonqerCCYsM9hPi6I3JVu1
         /oZzIqVnEd9v2xhaVnCWa+4ktsKKrU47o9N3uwrjMQvKkgwGH0/I1uy4wf4N/yRvxzPa
         hML0neZqlfVlKu8ocJN0fDagNF6reNJcx83PTsyP3o+A2i4SlN7rgUFe2ZXfVcr1SIr5
         jYu6kAn+XnCyZ9mLs+mGk+20hAgk4sVhH5EH7yr8BuWGAVXZu4e+5BGFKbdnP5TXK8X7
         L5Fw==
X-Gm-Message-State: AOJu0Yxekg2M14kWB2YzS1jAax62NZBessqz+K9BzTdatV6399zodXF9
	dVNSiiWUMK3nMeaGibmupHqGR1K9gpE90QCEnkyt8t+gl8gWUevMRmGRtA==
X-Google-Smtp-Source: AGHT+IFLg+JSFd60dS9L6Tj87GKJr5RKGG/mXqCcncoBio+x2PQTi77cMOBXh5BGA13ZcJncwBF25A==
X-Received: by 2002:a05:6870:d8cf:b0:23c:5f20:83a2 with SMTP id 586e51a60fabf-24ca1195a7amr1511494fac.14.1716529091290;
        Thu, 23 May 2024 22:38:11 -0700 (PDT)
Received: from slk15.local.net ([49.190.141.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f8fcbe9f61sm460374b3a.110.2024.05.23.22.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 22:38:10 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org
Subject: [PATCH libnetfilter_queue v2 13/15] src: Convert all nlif_* functions to use libmnl
Date: Fri, 24 May 2024 15:37:40 +1000
Message-Id: <20240524053742.27294-14-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <20240524053742.27294-1-duncan_roe@optusnet.com.au>
References: <20240524053742.27294-1-duncan_roe@optusnet.com.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In iftable.c, replace calls to functions in rtnetlink.c with inline code
(converted to use libmnl instead of libnfnetlink).
It is essential to offer *all* functions originally provided by
libnfnetlink so that a built program will either take its nlif_*()
functions from libnetfilter_queue or libnfnetlink (depending on the
build-time order in LIBS).

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 v2: created from patches 19/32 & (some of) 32/32

 src/Makefile.am |   1 +
 src/iftable.c   | 311 ++++++++++++++++++++++--------------------------
 2 files changed, 141 insertions(+), 171 deletions(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index 079853e..a6813e8 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -30,6 +30,7 @@ libnetfilter_queue_la_LDFLAGS = -Wc,-nostartfiles \
 				-version-info $(LIBVERSION)
 libnetfilter_queue_la_SOURCES = libnetfilter_queue.c	\
 				nlmsg.c			\
+				iftable.c		\
 				extra/checksum.c	\
 				extra/icmp.c		\
 				extra/ipv6.c		\
diff --git a/src/iftable.c b/src/iftable.c
index 9884a52..54364b3 100644
--- a/src/iftable.c
+++ b/src/iftable.c
@@ -11,19 +11,29 @@
 
 #include <unistd.h>
 #include <stdlib.h>
+#include <time.h>
 #include <stdio.h>
 #include <string.h>
 #include <sys/types.h>
 #include <netinet/in.h>
 #include <arpa/inet.h>
 #include <errno.h>
-#include <assert.h>
 
 #include <linux/netdevice.h>
 
-#include <libnfnetlink/libnfnetlink.h>
-#include "rtnl.h"
-#include "linux_list.h"
+#include <libmnl/libmnl.h>
+#include <linux/rtnetlink.h>
+#include <libnetfilter_queue/linux_list.h>
+#include <linux/netfilter/nfnetlink_queue.h>
+#include <libnetfilter_queue/libnetfilter_queue.h>
+
+#include "internal.h"
+
+#define NUM_NLIF_BITS 4
+#define NUM_NLIF_ENTRIES (1 << NUM_NLIF_BITS)
+#define NLIF_ENTRY_MASK (NUM_NLIF_ENTRIES - 1)
+
+static int data_cb(const struct nlmsghdr *nlh, void *data);
 
 /**
  * \defgroup iftable Functions to manage a table of network interfaces
@@ -86,117 +96,15 @@ struct ifindex_node {
 
 	uint32_t	index;
 	uint32_t	type;
-	uint32_t	alen;
 	uint32_t	flags;
-	char		addr[8];
-	char		name[16];
+	char		name[IFNAMSIZ];
 };
 
 struct nlif_handle {
-	struct list_head ifindex_hash[16];
-	struct rtnl_handle *rtnl_handle;
-	struct rtnl_handler ifadd_handler;
-	struct rtnl_handler ifdel_handler;
+	struct list_head ifindex_hash[NUM_NLIF_ENTRIES];
+	struct mnl_socket *nl;
 };
 
-/* iftable_add - Add/Update an entry to/in the interface table
- * \param n:	netlink message header of a RTM_NEWLINK message
- * \param arg:	not used
- *
- * This function adds/updates an entry in the intrface table.
- * Returns -1 on error, 1 on success.
- */
-static int iftable_add(struct nlmsghdr *n, void *arg)
-{
-	unsigned int hash, found = 0;
-	struct ifinfomsg *ifi_msg = NLMSG_DATA(n);
-	struct ifindex_node *this;
-	struct rtattr *cb[IFLA_MAX+1];
-	struct nlif_handle *h = arg;
-
-	if (n->nlmsg_type != RTM_NEWLINK)
-		return -1;
-
-	if (n->nlmsg_len < NLMSG_LENGTH(sizeof(ifi_msg)))
-		return -1;
-
-	rtnl_parse_rtattr(cb, IFLA_MAX, IFLA_RTA(ifi_msg), IFLA_PAYLOAD(n));
-
-	if (!cb[IFLA_IFNAME])
-		return -1;
-
-	hash = ifi_msg->ifi_index & 0xF;
-	list_for_each_entry(this, &h->ifindex_hash[hash], head) {
-		if (this->index == ifi_msg->ifi_index) {
-			found = 1;
-			break;
-		}
-	}
-
-	if (!found) {
-		this = malloc(sizeof(*this));
-		if (!this)
-			return -1;
-
-		this->index = ifi_msg->ifi_index;
-	}
-
-	this->type = ifi_msg->ifi_type;
-	this->flags = ifi_msg->ifi_flags;
-	if (cb[IFLA_ADDRESS]) {
-		unsigned int alen;
-
-		this->alen = alen = RTA_PAYLOAD(cb[IFLA_ADDRESS]);
-		if (alen > sizeof(this->addr))
-			alen = sizeof(this->addr);
-		memcpy(this->addr, RTA_DATA(cb[IFLA_ADDRESS]), alen);
-	} else {
-		this->alen = 0;
-		memset(this->addr, 0, sizeof(this->addr));
-	}
-	strcpy(this->name, RTA_DATA(cb[IFLA_IFNAME]));
-
-	if (!found)
-		list_add(&this->head, &h->ifindex_hash[hash]);
-
-	return 1;
-}
-
-/* iftable_del - Delete an entry from the interface table
- * \param n:	netlink message header of a RTM_DELLINK nlmsg
- * \param arg:	not used
- *
- * Delete an entry from the interface table.
- * Returns -1 on error, 0 if no matching entry was found or 1 on success.
- */
-static int iftable_del(struct nlmsghdr *n, void *arg)
-{
-	struct ifinfomsg *ifi_msg = NLMSG_DATA(n);
-	struct rtattr *cb[IFLA_MAX+1];
-	struct nlif_handle *h = arg;
-	struct ifindex_node *this, *tmp;
-	unsigned int hash;
-
-	if (n->nlmsg_type != RTM_DELLINK)
-		return -1;
-
-	if (n->nlmsg_len < NLMSG_LENGTH(sizeof(ifi_msg)))
-		return -1;
-
-	rtnl_parse_rtattr(cb, IFLA_MAX, IFLA_RTA(ifi_msg), IFLA_PAYLOAD(n));
-
-	hash = ifi_msg->ifi_index & 0xF;
-	list_for_each_entry_safe(this, tmp, &h->ifindex_hash[hash], head) {
-		if (this->index == ifi_msg->ifi_index) {
-			list_del(&this->head);
-			free(this);
-			return 1;
-		}
-	}
-
-	return 0;
-}
-
 /**
  * nlif_index2name - get the name for an ifindex
  *
@@ -205,6 +113,7 @@ static int iftable_del(struct nlmsghdr *n, void *arg)
  * \param name interface name, pass a buffer of IFNAMSIZ size
  * \return -1 on error, 1 on success
  */
+EXPORT_SYMBOL
 int nlif_index2name(struct nlif_handle *h,
 		    unsigned int index,
 		    char *name)
@@ -212,9 +121,6 @@ int nlif_index2name(struct nlif_handle *h,
 	unsigned int hash;
 	struct ifindex_node *this;
 
-	assert(h != NULL);
-	assert(name != NULL);
-
 	if (index == 0) {
 		strcpy(name, "*");
 		return 1;
@@ -240,6 +146,7 @@ int nlif_index2name(struct nlif_handle *h,
  * \param flags pointer to variable used to store the interface flags
  * \return -1 on error, 1 on success
  */
+EXPORT_SYMBOL
 int nlif_get_ifflags(const struct nlif_handle *h,
 		     unsigned int index,
 		     unsigned int *flags)
@@ -247,9 +154,6 @@ int nlif_get_ifflags(const struct nlif_handle *h,
 	unsigned int hash;
 	struct ifindex_node *this;
 
-	assert(h != NULL);
-	assert(flags != NULL);
-
 	if (index == 0) {
 		errno = ENOENT;
 		return -1;
@@ -269,11 +173,12 @@ int nlif_get_ifflags(const struct nlif_handle *h,
 /**
  * nlif_open - initialize interface table
  *
- * Initialize rtnl interface and interface table
- * Call this before any nlif_* function
+ * Open a netlink socket and initialize interface table
+ * Call this before any other nlif_* function
  *
- * \return file descriptor to netlink socket
+ * \return NULL on error, else valid pointer to an nlif_handle structure
  */
+EXPORT_SYMBOL
 struct nlif_handle *nlif_open(void)
 {
 	int i;
@@ -283,32 +188,21 @@ struct nlif_handle *nlif_open(void)
 	if (h == NULL)
 		goto err;
 
-	for (i = 0; i < 16; i++)
+	for (i = 0; i < NUM_NLIF_ENTRIES; i++)
 		INIT_LIST_HEAD(&h->ifindex_hash[i]);
 
-	h->ifadd_handler.nlmsg_type = RTM_NEWLINK;
-	h->ifadd_handler.handlefn = iftable_add;
-	h->ifadd_handler.arg = h;
-	h->ifdel_handler.nlmsg_type = RTM_DELLINK;
-	h->ifdel_handler.handlefn = iftable_del;
-	h->ifdel_handler.arg = h;
+	h->nl = mnl_socket_open(NETLINK_ROUTE);
+	if (!h->nl)
+		goto err_free;
 
-	h->rtnl_handle = rtnl_open();
-	if (h->rtnl_handle == NULL)
-		goto err;
-
-	if (rtnl_handler_register(h->rtnl_handle, &h->ifadd_handler) < 0)
+	if (mnl_socket_bind(h->nl, RTMGRP_LINK, MNL_SOCKET_AUTOPID) < 0)
 		goto err_close;
 
-	if (rtnl_handler_register(h->rtnl_handle, &h->ifdel_handler) < 0)
-		goto err_unregister;
-
 	return h;
 
-err_unregister:
-	rtnl_handler_unregister(h->rtnl_handle, &h->ifadd_handler);
 err_close:
-	rtnl_close(h->rtnl_handle);
+	mnl_socket_close(h->nl);
+err_free:
 	free(h);
 err:
 	return NULL;
@@ -319,18 +213,15 @@ err:
  *
  * \param h pointer to nlif_handle created by nlif_open()
  */
+EXPORT_SYMBOL
 void nlif_close(struct nlif_handle *h)
 {
 	int i;
 	struct ifindex_node *this, *tmp;
 
-	assert(h != NULL);
+	mnl_socket_close(h->nl);
 
-	rtnl_handler_unregister(h->rtnl_handle, &h->ifadd_handler);
-	rtnl_handler_unregister(h->rtnl_handle, &h->ifdel_handler);
-	rtnl_close(h->rtnl_handle);
-
-	for (i = 0; i < 16; i++) {
+	for (i = 0; i < NUM_NLIF_ENTRIES; i++) {
 		list_for_each_entry_safe(this, tmp, &h->ifindex_hash[i], head) {
 			list_del(&this->head);
 			free(this);
@@ -344,61 +235,139 @@ void nlif_close(struct nlif_handle *h)
 /**
  * nlif_catch - receive message from netlink and update interface table
  *
- * FIXME - elaborate a bit
- *
  * \param h pointer to nlif_handle created by nlif_open()
  * \return 0 if OK
  */
+EXPORT_SYMBOL
 int nlif_catch(struct nlif_handle *h)
 {
-	assert(h != NULL);
-
-	if (h->rtnl_handle)
-		return rtnl_receive(h->rtnl_handle);
-
-	return -1;
-}
-
-static int nlif_catch_multi(struct nlif_handle *h)
-{
-	assert(h != NULL);
-
-	if (h->rtnl_handle)
-		return rtnl_receive_multi(h->rtnl_handle);
+	/*
+	 * Use MNL_SOCKET_BUFFER_SIZE instead of MNL_SOCKET_DUMP_SIZE
+	 * to keep memory footprint same as it was.
+	 */
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	int ret;
+
+	if (!h->nl)                /* The old library had this test */
+		return -1;
 
-	return -1;
+	ret = mnl_socket_recvfrom(h->nl, buf, sizeof(buf));
+	if (ret == -1)
+		return -1;
+	return mnl_cb_run(buf, ret, 0, mnl_socket_get_portid(h->nl),
+			  data_cb, h) == -1 ? -1 : 0;
 }
 
 /**
  * nlif_query - request a dump of interfaces available in the system
  * \param h: pointer to a valid nlif_handler
+ * \return -1 on error with errno set, else >=0
  */
+EXPORT_SYMBOL
 int nlif_query(struct nlif_handle *h)
 {
-	assert(h != NULL);
-
-	if (rtnl_dump_type(h->rtnl_handle, RTM_GETLINK) < 0)
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	uint32_t seq;
+	int ret;
+	struct rtgenmsg *rt;
+
+	nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type = RTM_GETLINK;
+	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_DUMP;
+	nlh->nlmsg_seq = seq = time(NULL);
+	rt = mnl_nlmsg_put_extra_header(nlh, sizeof(struct rtgenmsg));
+	rt->rtgen_family = AF_PACKET;
+	if (mnl_socket_sendto(h->nl, nlh, nlh->nlmsg_len) < 0)
 		return -1;
-
-	return nlif_catch_multi(h);
+	ret = mnl_socket_recvfrom(h->nl, buf, sizeof(buf));
+	while (ret > 0) {
+		ret = mnl_cb_run(buf, ret, seq, mnl_socket_get_portid(h->nl),
+				 data_cb, h);
+		if (ret <= MNL_CB_STOP)
+			break;
+		ret = mnl_socket_recvfrom(h->nl, buf, sizeof(buf));
+	}
+	return ret;
 }
 
 /**
  * nlif_fd - get file descriptor for the netlink socket
  *
  * \param h pointer to nlif_handle created by nlif_open()
- * \return The fd or -1 if there's an error
+ * \return socket fd or -1 on error
  */
+EXPORT_SYMBOL
 int nlif_fd(struct nlif_handle *h)
 {
-	assert(h != NULL);
-
-	if (h->rtnl_handle)
-		return h->rtnl_handle->rtnl_fd;
-
-	return -1;
+	return h->nl ? mnl_socket_get_fd(h->nl) : -1;
 }
 
 /**
  * @}
  */
+
+/*
+ * data_cb - callback for rtnetlink messages
+ *           caller will put nlif_handle in data
+ */
+
+static int data_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct ifinfomsg *ifi_msg = mnl_nlmsg_get_payload(nlh);
+	struct nlif_handle *h = data;
+	struct nlattr *attr;
+	uint32_t hash;
+	struct ifindex_node *this, *tmp;
+
+	if (nlh->nlmsg_type != RTM_NEWLINK && nlh->nlmsg_type != RTM_DELLINK) {
+		errno = EPROTO;
+		return MNL_CB_ERROR;
+	}
+	hash = ifi_msg->ifi_index & NLIF_ENTRY_MASK;
+
+	/* RTM_DELLINK is simple, do it first for less indenting */
+	if (nlh->nlmsg_type == RTM_DELLINK) {
+		/*
+		 * The original code used list_for_each_entry_safe when deleting
+		 * and list_for_each_entry when adding.
+		 * The code is only ever going to delete one entry
+		 * so what does the safe variant achieve?
+		 * In a multi-threaded app,
+		 * I'd suggest a pthread rwlock on all nlif accesses.
+		 */
+		list_for_each_entry_safe(this, tmp, &h->ifindex_hash[hash],
+					 head) {
+			if (this->index == ifi_msg->ifi_index) {
+				list_del(&this->head);
+				free(this);
+			}
+		}
+	return MNL_CB_OK;
+	}
+
+	list_for_each_entry(this, &h->ifindex_hash[hash], head) {
+		if (this->index == ifi_msg->ifi_index)
+			goto found;
+	}
+	this = calloc(1, sizeof(*this));
+	if (!this)
+		return MNL_CB_ERROR;
+	this->index = ifi_msg->ifi_index;
+	this->type = ifi_msg->ifi_type;
+	this->flags = ifi_msg->ifi_flags;
+	list_add(&this->head, &h->ifindex_hash[hash]);
+found:
+	mnl_attr_for_each(attr, nlh, sizeof(*ifi_msg)) {
+		/* All we want is the interface name */
+		if (mnl_attr_get_type(attr) == IFLA_IFNAME) {
+			if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0) {
+				perror("mnl_attr_validate");
+				return MNL_CB_ERROR;
+			}
+			strcpy(this->name, mnl_attr_get_str(attr));
+			break;
+		}
+	}
+	return MNL_CB_OK;
+}
-- 
2.35.8

