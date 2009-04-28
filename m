From: Eric Leblond <eric@inl.fr>
Subject: [PATCH] iftable: make library thread-safe.
Date: Tue, 28 Apr 2009 23:45:27 +0200
Message-ID: <1240955127-13723-2-git-send-email-eric@inl.fr>
References: <1240955127-13723-1-git-send-email-eric@inl.fr>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: pablo@netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:38067 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752982AbZD1Vpb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Apr 2009 17:45:31 -0400
In-Reply-To: <1240955127-13723-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds some locking on the interface hash to make libnfnetlink
thread-safe. The interface hash could be accessed via nlif_index2name()
function and modified simultaneously via event treatment.

This introduces a depedencies on libpthread. Thus, the compilation
tools have been modified.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 configure.in                        |    2 ++
 include/libnfnetlink/libnfnetlink.h |    2 +-
 src/Makefile.am                     |    2 +-
 src/iftable.c                       |   26 ++++++++++++++++++++++++--
 4 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/configure.in b/configure.in
index f760cd0..9febde0 100644
--- a/configure.in
+++ b/configure.in
@@ -11,6 +11,8 @@ AC_EXEEXT
 AM_PROG_LIBTOOL
 AC_SUBST(LIBTOOL_DEPS)
 
+AC_CHECK_LIB([pthread], [pthread_mutex_init])
+
 case $target in 
 *-*-linux*) ;;
 *) AC_MSG_ERROR([Linux only, dude!]);;
diff --git a/include/libnfnetlink/libnfnetlink.h b/include/libnfnetlink/libnfnetlink.h
index f689ab0..7984c08 100644
--- a/include/libnfnetlink/libnfnetlink.h
+++ b/include/libnfnetlink/libnfnetlink.h
@@ -209,7 +209,7 @@ int nlif_catch(struct nlif_handle *nlif_handle);
 int nlif_index2name(struct nlif_handle *nlif_handle, 
 		    unsigned int if_index, 
 		    char *name);
-int nlif_get_ifflags(const struct nlif_handle *h,
+int nlif_get_ifflags(struct nlif_handle *h,
 		     unsigned int index,
 		     unsigned int *flags);
 
diff --git a/src/Makefile.am b/src/Makefile.am
index cc400b9..68301af 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -6,7 +6,7 @@ LIBS=
 lib_LTLIBRARIES = libnfnetlink.la
 
 libnfnetlink_la_LDFLAGS = -Wc,-nostartfiles	\
-			  -version-info $(LIBVERSION)
+			  -version-info $(LIBVERSION) -lpthread
 libnfnetlink_la_SOURCES = libnfnetlink.c iftable.c rtnl.c
 
 noinst_HEADERS = iftable.h rtnl.h
diff --git a/src/iftable.c b/src/iftable.c
index f316217..7dc5d27 100644
--- a/src/iftable.c
+++ b/src/iftable.c
@@ -17,6 +17,7 @@
 #include <arpa/inet.h>
 #include <errno.h>
 #include <assert.h>
+#include <pthread.h>
 
 #include <linux/netdevice.h>
 
@@ -40,6 +41,7 @@ struct nlif_handle {
 	struct rtnl_handle *rtnl_handle;
 	struct rtnl_handler ifadd_handler;
 	struct rtnl_handler ifdel_handler;
+	pthread_mutex_t mutex;
 };
 
 /* iftable_add - Add/Update an entry to/in the interface table
@@ -69,6 +71,7 @@ static int iftable_add(struct nlmsghdr *n, void *arg)
 		return -1;
 
 	hash = ifi_msg->ifi_index & 0xF;
+	pthread_mutex_lock(&(h->mutex));
 	list_for_each_entry(this, &h->ifindex_hash[hash], head) {
 		if (this->index == ifi_msg->ifi_index) {
 			found = 1;
@@ -78,8 +81,10 @@ static int iftable_add(struct nlmsghdr *n, void *arg)
 
 	if (!found) {
 		this = malloc(sizeof(*this));
-		if (!this)
+		if (!this) {
+			pthread_mutex_unlock(&(h->mutex));
 			return -1;
+		}
 
 		this->index = ifi_msg->ifi_index;
 	}
@@ -101,6 +106,8 @@ static int iftable_add(struct nlmsghdr *n, void *arg)
 	if (!found)
 		list_add(&this->head, &h->ifindex_hash[hash]);
 
+	pthread_mutex_unlock(&(h->mutex));
+
 	return 1;
 }
 
@@ -128,13 +135,16 @@ static int iftable_del(struct nlmsghdr *n, void *arg)
 	rtnl_parse_rtattr(cb, IFLA_MAX, IFLA_RTA(ifi_msg), IFLA_PAYLOAD(n));
 
 	hash = ifi_msg->ifi_index & 0xF;
+	pthread_mutex_lock(&(h->mutex));
 	list_for_each_entry_safe(this, tmp, &h->ifindex_hash[hash], head) {
 		if (this->index == ifi_msg->ifi_index) {
 			list_del(&this->head);
 			free(this);
+			pthread_mutex_unlock(&(h->mutex));
 			return 1;
 		}
 	}
+	pthread_mutex_unlock(&(h->mutex));
 
 	return 0;
 }
@@ -162,12 +172,15 @@ int nlif_index2name(struct nlif_handle *h,
 	}
 
 	hash = index & 0xF;
+	pthread_mutex_lock(&(h->mutex));
 	list_for_each_entry(this, &h->ifindex_hash[hash], head) {
 		if (this->index == index) {
 			strcpy(name, this->name);
+			pthread_mutex_unlock(&(h->mutex));
 			return 1;
 		}
 	}
+	pthread_mutex_unlock(&(h->mutex));
 
 	errno = ENOENT;
 	return -1;
@@ -180,7 +193,7 @@ int nlif_index2name(struct nlif_handle *h,
  * \param flags pointer to variable used to store the interface flags
  * \return -1 on error, 1 on success 
  */
-int nlif_get_ifflags(const struct nlif_handle *h,
+int nlif_get_ifflags(struct nlif_handle *h,
 		     unsigned int index,
 		     unsigned int *flags)
 {
@@ -196,12 +209,15 @@ int nlif_get_ifflags(const struct nlif_handle *h,
 	}
 
 	hash = index & 0xF;
+	pthread_mutex_lock(&(h->mutex));
 	list_for_each_entry(this, &h->ifindex_hash[hash], head) {
 		if (this->index == index) {
 			*flags = this->flags;
+			pthread_mutex_unlock(&(h->mutex));
 			return 1;
 		}
 	}
+	pthread_mutex_unlock(&(h->mutex));
 	errno = ENOENT;
 	return -1;
 }
@@ -232,6 +248,8 @@ struct nlif_handle *nlif_open(void)
 	h->ifdel_handler.handlefn = iftable_del;
 	h->ifdel_handler.arg = h;
 
+	pthread_mutex_init(&(h->mutex), NULL);
+
 	h->rtnl_handle = rtnl_open();
 	if (h->rtnl_handle == NULL)
 		goto err;
@@ -269,12 +287,16 @@ void nlif_close(struct nlif_handle *h)
 	rtnl_handler_unregister(h->rtnl_handle, &h->ifdel_handler);
 	rtnl_close(h->rtnl_handle);
 
+	pthread_mutex_lock(&(h->mutex));
 	for (i=0; i<16; i++) {
 		list_for_each_entry_safe(this, tmp, &h->ifindex_hash[i], head) {
 			list_del(&this->head);
 			free(this);
 		}
 	}
+	pthread_mutex_unlock(&(h->mutex));
+
+	pthread_mutex_destroy(&(h->mutex));
 
 	free(h);
 	h = NULL; /* bugtrap */
-- 
1.6.1

