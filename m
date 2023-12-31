Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC3617D3
	for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2023 09:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VaZH+9bw"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7ba8f139522so395688739f.1
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2023 01:19:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704014347; x=1704619147; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h1Q1AyrsCF7Ivzd/EEyMNUG92mj5I7NeKLUdu4LRfdY=;
        b=VaZH+9bwKK/f3Jo2JHDhU+09eid0xS2hjJkrlkaYxcuEjUEmOiqfcDEMf0o43TbPKD
         gmZjqYpItEwcT/GRV0oYny8WRJgdTtUe0lMeHs4oLJpvHPw6EuoZWv7y2VrO+8HUan1+
         zVV3t/Wxjg39X+w/YUmSd4wFEd4KH71EdGCsC88xzS3+rC9MofNwPy1dq0cPB3puJi3/
         /ZV7lrK3sXtD6dwuOiMs5tlK+At2EMSoPVNtqcAXplq7gVjvatve0+tXo/ROOQjuuF9L
         Pf3KBY8GFmdDm76JFswBEQvjK0HbfCLQPhyJMkLXb/IyAHdj2YAmr5hdWdxxGbQ/X89y
         HY6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704014347; x=1704619147;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h1Q1AyrsCF7Ivzd/EEyMNUG92mj5I7NeKLUdu4LRfdY=;
        b=EzmT05npSqZIsV1cJdi2VMnvNhygI/MS5YLUP8IOevYL3XL7xpmE9ihPvv16TIxWEC
         nnwYpNKficKdLb7cNuKaprx76h3/DwV34x9O/EZNM99vW37Wzoer1OgIXpD4ljFC1jsU
         ZyiTgfb1O2OHPtwgSDJUIfEg4n9bUnooXthAmSPsvT60jdl8Yrkna3rmEASOXtc6fdac
         Hn5IXTkbXgYePGBn15g6BWO8/NfSpVttN0Zo/481YME5LYs4fYFT6HuXgaBsKBAPSbyk
         HADtUcFl7hTxkPUY8fbTopTzyCHYPxsyqb24Nb6osaY99qVAp8QwJNHoa7FN1ZLTPAZM
         MQSw==
X-Gm-Message-State: AOJu0Yzz7zF0oVmdAuiqw/Wu2g5owVcvtFQ7Ww3Doi7UJxG9swLWCYf6
	c/WqS67MQzuLrBesrpFIvXzadH7/+x0=
X-Google-Smtp-Source: AGHT+IHPqpdFafL8cHnW1sZzNj1h6fuOdfxN8/0GSE7ZIgEKfQaC1JVzgx0CoU+sRvA7OC5+Sd2GHg==
X-Received: by 2002:a92:ca4c:0:b0:35f:efdc:f067 with SMTP id q12-20020a92ca4c000000b0035fefdcf067mr22411725ilo.11.1704014346911;
        Sun, 31 Dec 2023 01:19:06 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id l66-20020a633e45000000b005cd86cd9055sm14284999pga.1.2023.12.31.01.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Dec 2023 01:19:06 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH RFC libnetfilter_queue 1/1] utils/nfqnl_test runs without libnfnetlink
Date: Sun, 31 Dec 2023 20:19:00 +1100
Message-Id: <20231231091900.27714-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <20231231091900.27714-1-duncan_roe@optusnet.com.au>
References: <20231231091900.27714-1-duncan_roe@optusnet.com.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The build of utils/nfqnl_test has to ignore unresolved symbols because some
libnfnetlink functions used by libnetfilter_queue are still to be
converted. Specifically, these are:

 nlif_index2name
 nfnl_build_nfa_iovec
 nfnl_sendiov

Of these, nfnl_build_nfa_iovec and nfnl_sendiov replacements belong in
libmnl.

nfq_get_indev_name() has code snippets documenting these libnfnetlink
functions:

 nlif_open
 nlif_catch
 nlif_fd
 nlif_query

libnetfilter_queue will have to provide these.

--------------------------------

Summary of changes (sort-of cleaned up git log):

    Convert nfq_fd()
    Also update build of utils/nfqnl_test to ignore unresolved symbols
    and document nfq_nfnlh().

    Rename element `id` of struct nfq_q_handle to `queue_num`
    This leaves `id` as always referring to packet id.
    `queue_num` is also used in other sources.

    Remove libnfnetlink from the build
    Programs using nfnl-api functions must build with -lnfnetlink.
    Programs using mnl-api functions no longer show libnfnetlink in ldd.

    Incorporate nfnl_rcvbufsiz()

    Remove `struct nfnl_subsys_handle *nfnlssh` from `struct nfq_handle`

    Convert nfq_close()

    Convert non-data verdict functions
    Updated:
     include/libnetfilter_queue/libnetfilter_queue.h:
     - Fix name in 1st line
     - Change name of guardian #define to the conventional one
     - Flag line to be removed (when we can)
     src/libnetfilter_queue.c:
     - include libmnl.h
     - Use real Linux headers
     - __set_verdict() uses mnl_socket_sendto() if no packed data

    Convert more message parsing functioms
    Functions now using libmnl exclusively: nfq_get_msg_packet_hdr(),
    nfq_get_nfmark(), nfq_get_timestamp(), nfq_get_indev(),
    nfq_get_physindev(), nfq_get_outdev(), nfq_get_physoutdev(),
    nfqnl_msg_packet_hw(), nfq_get_uid() & nfq_get_gid().

    About to convert / redo all nfq_get_ functions
    Functions now using libmnl exclusively: nfq_handle_packet(),
    nfq_get_secctx() & nfq_get_payload().
    The opaque struct nfq_data is now an array of struct nlattr instead of
    struct nfattr.
    The difference is: nlattr starts at 0 while nfattr starts at 1.

    Delete nfq_open_nfnl() and __nfq_rcv_pkt()
    nfq_open_nfnl was the last user of static __nfq_rcv_pkt and was slated
    for removal so delete both of them.

    Convert nfq_set_queue_flags() & nfq_set_queue_maxlen() to use libmnl

    Introduce a static function to check response from using NLM_F_ACK
    Code uses nfq_query() where it previously used nfnl_query().
    nfq_query() takes 2 extra args being a buffer / buffer size pair which
    the caller can also use for sending.
    (nfq_query() used to call nfnl_catch() which declared that buffer).
    THIS FUNCTION WILL BE REPLACED by nfq_socket_sendto() if it ever makes
    it out of patchwork.

    Convert nfq_set_mode(), nfq_bind_pf() & nfq_unbind_pf() to use libmnl
    Also remove nfq_errno (incomplete project, never documented).
    Main change is to static function __build_send_cfg_msg().

    Convert nfq_open() to use libmnl

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 Make_global.am                                |   2 +-
 configure.ac                                  |   1 -
 doxygen/doxygen.cfg.in                        |   1 +
 .../libnetfilter_queue/libnetfilter_queue.h   |  12 +-
 libnetfilter_queue.pc.in                      |   1 -
 src/Makefile.am                               |   2 +-
 src/libnetfilter_queue.c                      | 453 ++++++++++--------
 utils/Makefile.am                             |   2 +-
 8 files changed, 271 insertions(+), 203 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index 91da5da..4d8a58e 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -1,2 +1,2 @@
-AM_CPPFLAGS = -I${top_srcdir}/include ${LIBNFNETLINK_CFLAGS} ${LIBMNL_CFLAGS}
+AM_CPPFLAGS = -I${top_srcdir}/include ${LIBMNL_CFLAGS}
 AM_CFLAGS = -Wall ${GCC_FVISIBILITY_HIDDEN}
diff --git a/configure.ac b/configure.ac
index 7359fba..ba7b15f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -42,7 +42,6 @@ case "$host" in
 esac
 
 dnl Dependencies
-PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 0.0.41])
 PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
 
 AS_IF([test "$enable_man_pages" = no -a "$enable_html_doc" = no],
diff --git a/doxygen/doxygen.cfg.in b/doxygen/doxygen.cfg.in
index 97174ff..3e06bd8 100644
--- a/doxygen/doxygen.cfg.in
+++ b/doxygen/doxygen.cfg.in
@@ -13,6 +13,7 @@ EXCLUDE_SYMBOLS        = EXPORT_SYMBOL \
                          nfq_handle \
                          nfq_data \
                          nfq_q_handle \
+                         nfnl_handle \
                          tcp_flag_word
 EXAMPLE_PATTERNS       =
 INPUT_FILTER           = "sed 's/EXPORT_SYMBOL//g'"
diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
index f7e68d8..8932847 100644
--- a/include/libnetfilter_queue/libnetfilter_queue.h
+++ b/include/libnetfilter_queue/libnetfilter_queue.h
@@ -1,4 +1,4 @@
-/* libnfqnetlink.h: Header file for the Netfilter Queue library.
+/* libnetfilter_queue.h: Header file for the Netfilter Queue library.
  *
  * (C) 2005 by Harald Welte <laforge@gnumonks.org>
  *
@@ -10,11 +10,11 @@
  * of the GNU General Public License, incorporated herein by reference.
  */
 
-#ifndef __LIBCTNETLINK_H
-#define __LIBCTNETLINK_H
+#ifndef __LIBNETFILTER_QUEUE_H
+#define __LIBNETFILTER_QUEUE_H
 
 #include <sys/time.h>
-#include <libnfnetlink/libnfnetlink.h>
+#include <libnfnetlink/libnfnetlink.h> /* FIXME: Remove */
 
 #include <libnetfilter_queue/linux_nfnetlink_queue.h>
 
@@ -26,8 +26,6 @@ struct nfq_handle;
 struct nfq_q_handle;
 struct nfq_data;
 
-extern int nfq_errno;
-
 extern struct nfnl_handle *nfq_nfnlh(struct nfq_handle *h);
 extern int nfq_fd(struct nfq_handle *h);
 
@@ -35,6 +33,8 @@ typedef int  nfq_callback(struct nfq_q_handle *gh, struct nfgenmsg *nfmsg,
 		       struct nfq_data *nfad, void *data);
 
 
+extern unsigned int nfnl_rcvbufsiz(const struct nfnl_handle *h,
+				   unsigned int size);
 extern struct nfq_handle *nfq_open(void);
 extern struct nfq_handle *nfq_open_nfnl(struct nfnl_handle *nfnlh);
 extern int nfq_close(struct nfq_handle *h);
diff --git a/libnetfilter_queue.pc.in b/libnetfilter_queue.pc.in
index 9c6c2c4..962c686 100644
--- a/libnetfilter_queue.pc.in
+++ b/libnetfilter_queue.pc.in
@@ -12,5 +12,4 @@ Version: @VERSION@
 Requires: libnfnetlink
 Conflicts:
 Libs: -L${libdir} -lnetfilter_queue
-Libs.private: @LIBNFNETLINK_LIBS@
 Cflags: -I${includedir}
diff --git a/src/Makefile.am b/src/Makefile.am
index 079853e..aa0c3a9 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -38,4 +38,4 @@ libnetfilter_queue_la_SOURCES = libnetfilter_queue.c	\
 				extra/pktbuff.c		\
 				extra/udp.c
 
-libnetfilter_queue_la_LIBADD  = ${LIBNFNETLINK_LIBS} ${LIBMNL_LIBS}
+libnetfilter_queue_la_LIBADD  = ${LIBMNL_LIBS}
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index bf67a19..dea2fc8 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -19,6 +19,7 @@
  *  2006-01-23 Andreas Florath <andreas@florath.net>
  *	Fix __set_verdict() that it can now handle payload.
  */
+//#define __LIBNFNETLINK_H
 
 #include <stdio.h>
 #include <stdlib.h>
@@ -31,7 +32,14 @@
 #include <sys/socket.h>
 #include <linux/netfilter/nfnetlink_queue.h>
 
-#include <libnfnetlink/libnfnetlink.h>
+/* Use real headers since libnfnetlink is going away. */
+/* nfq_pkt_parse_attr_cb only knows attribates up to NFQA_SECCTX */
+/* so won't try to validate them but will store them. */
+/* mnl API programs will then be able to access them. */
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nfnetlink_compat.h>
+
+#include <libmnl/libmnl.h>
 #include <libnetfilter_queue/libnetfilter_queue.h>
 #include "internal.h"
 
@@ -134,33 +142,57 @@ gcc -g3 -ggdb -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
  * burst
  */
 
+/* We need a rump nfnl_handle to support nfnl_rcvbufsiz()
+ * which is documented in libnetfilter_queue(7) and on the HTML main page.
+ * Luckily fd is the 1st item and that's all we need
+ * Because we need to have an fd in struct nfnl_handle,
+ * we don't have one in struct nfq_handle (for e.g. nfq_fd()).
+ */
+
+struct nfnl_handle {
+	int			fd;
+};
+
 struct nfq_handle
 {
+	unsigned int portid;
 	struct nfnl_handle *nfnlh;
-	struct nfnl_subsys_handle *nfnlssh;
 	struct nfq_q_handle *qh_list;
+	struct mnl_socket *nl;
+	struct nfnl_handle rump_nfnl_handle;
 };
 
 struct nfq_q_handle
 {
 	struct nfq_q_handle *next;
 	struct nfq_handle *h;
-	uint16_t id;
+	uint16_t queue_num;
 
 	nfq_callback *cb;
 	void *data;
 };
 
 struct nfq_data {
-	struct nfattr **data;
+	struct nlattr **data;
 };
 
-EXPORT_SYMBOL int nfq_errno;
-
 /***********************************************************************
  * low level stuff
  ***********************************************************************/
 
+static int nfq_query(struct nfq_handle *h, struct nlmsghdr *nlh, char *buf,
+		      size_t bufsiz)
+{
+	int ret;
+
+	ret = mnl_socket_sendto(h->nl, nlh, nlh->nlmsg_len);
+	if (ret != -1)
+		ret = mnl_socket_recvfrom(h->nl, buf, bufsiz);
+	if (ret != -1)
+		ret = mnl_cb_run(buf, ret, 0, h->portid, NULL, NULL);
+	return ret;
+}
+
 static void del_qh(struct nfq_q_handle *qh)
 {
 	struct nfq_q_handle *cur_qh, *prev_qh = NULL;
@@ -183,12 +215,12 @@ static void add_qh(struct nfq_q_handle *qh)
 	qh->h->qh_list = qh;
 }
 
-static struct nfq_q_handle *find_qh(struct nfq_handle *h, uint16_t id)
+static struct nfq_q_handle *find_qh(struct nfq_handle *h, uint16_t queue_num)
 {
 	struct nfq_q_handle *qh;
 
 	for (qh = h->qh_list; qh; qh = qh->next) {
-		if (qh->id == id)
+		if (qh->queue_num == queue_num)
 			return qh;
 	}
 	return NULL;
@@ -199,52 +231,46 @@ static struct nfq_q_handle *find_qh(struct nfq_handle *h, uint16_t id)
 __build_send_cfg_msg(struct nfq_handle *h, uint8_t command,
 		uint16_t queuenum, uint16_t pf)
 {
-	union {
-		char buf[NFNL_HEADER_LEN
-			+NFA_LENGTH(sizeof(struct nfqnl_msg_config_cmd))];
-		struct nlmsghdr nmh;
-	} u;
-	struct nfqnl_msg_config_cmd cmd;
-
-	nfnl_fill_hdr(h->nfnlssh, &u.nmh, 0, AF_UNSPEC, queuenum,
-			NFQNL_MSG_CONFIG, NLM_F_REQUEST|NLM_F_ACK);
-
-	cmd._pad = 0;
-	cmd.command = command;
-	cmd.pf = htons(pf);
-	nfnl_addattr_l(&u.nmh, sizeof(u), NFQA_CFG_CMD, &cmd, sizeof(cmd));
-
-	return nfnl_query(h->nfnlh, &u.nmh);
-}
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
 
-static int __nfq_rcv_pkt(struct nlmsghdr *nlh, struct nfattr *nfa[],
-		void *data)
-{
-	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
-	struct nfq_handle *h = data;
-	uint16_t queue_num = ntohs(nfmsg->res_id);
-	struct nfq_q_handle *qh = find_qh(h, queue_num);
-	struct nfq_data nfqa;
+	nlh = nfq_nlmsg_put2(buf, NFQNL_MSG_CONFIG, queuenum, NLM_F_ACK);
 
-	if (!qh)
-		return -ENODEV;
+	nfq_nlmsg_cfg_put_cmd(nlh, AF_UNSPEC, command);
 
-	if (!qh->cb)
-		return -ENODEV;
-
-	nfqa.data = nfa;
-
-	return qh->cb(qh, nfmsg, &nfqa, qh->data);
+	return nfq_query(h, nlh, buf, sizeof(buf));
 }
 
 /* public interface */
 
+/**
+ * \addtogroup LibrarySetup
+ * @{
+ */
+
+/**
+ *
+ * nfq_nfnlh - obtain a handle for nfnl_rcvbufsiz()
+ *
+ * \param h Netfilter queue connection handle obtained via call to nfq_open()
+ *
+ * \return pointer to struct nfnl_handle
+ *
+ * \warning
+ * The returned handle \b h is for nfnl_rcvbufsiz() only. It is not suitable
+ * for calling other functions in the deprecated \b libnfnetlink library.
+ */
+
 EXPORT_SYMBOL
 struct nfnl_handle *nfq_nfnlh(struct nfq_handle *h)
 {
 	return h->nfnlh;
 }
 
+/**
+ * @}
+ */
+
 /**
  *
  * \defgroup Queue Queue handling [DEPRECATED]
@@ -253,7 +279,7 @@ struct nfnl_handle *nfq_nfnlh(struct nfq_handle *h)
  * \link LibrarySetup \endlink), it is possible to bind the program to a
  * specific queue. This can be done by using nfq_create_queue().
  *
- * The queue can then be tuned via nfq_set_mode() or nfq_set_queue_maxlen().
+ * The queue can then be tuned via nfq_set_mode()
  *
  * Here's a little code snippet that create queue numbered 0:
  * \verbatim
@@ -328,7 +354,7 @@ struct nfnl_handle *nfq_nfnlh(struct nfq_handle *h)
 EXPORT_SYMBOL
 int nfq_fd(struct nfq_handle *h)
 {
-	return nfnl_fd(nfq_nfnlh(h));
+	return h->nfnlh->fd;
 }
 /**
  * @}
@@ -383,75 +409,36 @@ int nfq_fd(struct nfq_handle *h)
 EXPORT_SYMBOL
 struct nfq_handle *nfq_open(void)
 {
-	struct nfnl_handle *nfnlh = nfnl_open();
-	struct nfq_handle *qh;
-
-	if (!nfnlh)
-		return NULL;
-
-	/* unset netlink sequence tracking by default */
-	nfnl_unset_sequence_tracking(nfnlh);
-
-	qh = nfq_open_nfnl(nfnlh);
-	if (!qh)
-		nfnl_close(nfnlh);
-
-	return qh;
-}
-
-/**
- * @}
- */
-
-/**
- * nfq_open_nfnl - open a nfqueue handler from a existing nfnetlink handler
- * \param nfnlh Netfilter netlink connection handle obtained by calling nfnl_open()
- *
- * This function obtains a netfilter queue connection handle using an existing
- * netlink connection. This function is used internally to implement
- * nfq_open(), and should typically not be called directly.
- *
- * \return a pointer to a new queue handle or NULL on failure.
- */
-EXPORT_SYMBOL
-struct nfq_handle *nfq_open_nfnl(struct nfnl_handle *nfnlh)
-{
-	struct nfnl_callback pkt_cb = {
-		.call		= __nfq_rcv_pkt,
-		.attr_count	= NFQA_MAX,
-	};
-	struct nfq_handle *h;
-	int err;
+	struct nfq_handle *h = malloc(sizeof(*h));
 
-	h = malloc(sizeof(*h));
 	if (!h)
 		return NULL;
-
 	memset(h, 0, sizeof(*h));
-	h->nfnlh = nfnlh;
 
-	h->nfnlssh = nfnl_subsys_open(h->nfnlh, NFNL_SUBSYS_QUEUE,
-				      NFQNL_MSG_MAX, 0);
-	if (!h->nfnlssh) {
-		/* FIXME: nfq_errno */
-		goto out_free;
+	h->nl = mnl_socket_open(NETLINK_NETFILTER);
+	if (!h->nl) {
+		free(h);
+		return NULL;
 	}
 
-	pkt_cb.data = h;
-	err = nfnl_callback_register(h->nfnlssh, NFQNL_MSG_PACKET, &pkt_cb);
-	if (err < 0) {
-		nfq_errno = err;
-		goto out_close;
+	if (mnl_socket_bind(h->nl, 0, MNL_SOCKET_AUTOPID) < 0) {
+		mnl_socket_close(h->nl);
+		free(h);
+		return NULL;
 	}
+	h->portid = mnl_socket_get_portid(h->nl);
+
+	/* fudges for nfnl_rcvbufsiz() */
+	h->nfnlh = &h->rump_nfnl_handle;
+	h->rump_nfnl_handle.fd = mnl_socket_get_fd(h->nl);
 
 	return h;
-out_close:
-	nfnl_subsys_close(h->nfnlssh);
-out_free:
-	free(h);
-	return NULL;
 }
 
+/**
+ * @}
+ */
+
 /**
  * \addtogroup LibrarySetup
  *
@@ -469,6 +456,55 @@ out_free:
  * @{
  */
 
+/**
+ * nfnl_rcvbufsiz - set the socket buffer size
+ * \param h nfnetlink connection handle obtained via call to nfq_nfnlh()
+ * \param size size of the buffer we want to set
+ *
+ * This nfnl-API function sets the new size of the socket buffer.
+ * Use this setting
+ * to increase the socket buffer size if your system is reporting ENOBUFS
+ * errors.
+ *
+ * This code snippet achieves the same result from the mnl API:
+ * \verbatim
+	socklen_t wanted_size;     // Set this to number of bytes you want
+	socklen_t read_size;       // Will be number of bytes you got
+	socklen_t socklen = sizeof wanted_size;
+	struct mnl_socket *nl;     // Returned by mnl_socket_open()
+
+	setsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_RCVBUFFORCE,
+	    &wanted_size, sizeof(socklen_t));
+	getsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_RCVBUF, &read_size,
+	    &socklen);
+\endverbatim
+ *
+ * \return new size of kernel socket buffer
+ */
+
+EXPORT_SYMBOL
+unsigned int nfnl_rcvbufsiz(const struct nfnl_handle *h, unsigned int size)
+{
+	int status;
+	socklen_t socklen = sizeof(size);
+	unsigned int read_size = 0;
+
+	/* first we try the FORCE option, which is introduced in kernel
+	 * 2.6.14 to give "root" the ability to override the system wide
+	 * maximum
+	 */
+	status = setsockopt(h->fd, SOL_SOCKET, SO_RCVBUFFORCE, &size, socklen);
+	if (status < 0) {
+		/* if this didn't work, we try at least to get the system
+		 * wide maximum (or whatever the user requested)
+		 */
+		setsockopt(h->fd, SOL_SOCKET, SO_RCVBUF, &size, socklen);
+	}
+	getsockopt(h->fd, SOL_SOCKET, SO_RCVBUF, &read_size, &socklen);
+
+	return read_size;
+}
+
 /**
  * nfq_close - close a nfqueue handler
  * \param h Netfilter queue connection handle obtained via call to nfq_open()
@@ -480,12 +516,18 @@ out_free:
 EXPORT_SYMBOL
 int nfq_close(struct nfq_handle *h)
 {
-	int ret;
+	struct nfq_q_handle *qh;
 
-	ret = nfnl_close(h->nfnlh);
-	if (ret == 0)
-		free(h);
-	return ret;
+	mnl_socket_close(h->nl);
+
+	while (h->qh_list) {
+		qh = h->qh_list;
+		h->qh_list = qh->next;
+		free(qh);
+	}
+	free(h);
+
+	return 0;
 }
 
 /**
@@ -521,7 +563,6 @@ int nfq_unbind_pf(struct nfq_handle *h, uint16_t pf)
 	return __build_send_cfg_msg(h, NFQNL_CFG_CMD_PF_UNBIND, 0, pf);
 }
 
-
 /**
  * @}
  */
@@ -544,7 +585,7 @@ int nfq_unbind_pf(struct nfq_handle *h, uint16_t pf)
  * Creates a new queue handle, and returns it.  The new queue is identified by
  * \b num, and the callback specified by \b cb will be called for each enqueued
  * packet.  The \b data argument will be passed unchanged to the callback.  If
- * a queue entry with id \b num already exists,
+ * a queue entry with queue_num \b num already exists,
  * this function will return failure and the existing entry is unchanged.
  *
  * The nfq_callback type is defined in libnetfilter_queue.h as:
@@ -579,13 +620,12 @@ struct nfq_q_handle *nfq_create_queue(struct nfq_handle *h, uint16_t num,
 
 	memset(qh, 0, sizeof(*qh));
 	qh->h = h;
-	qh->id = num;
+	qh->queue_num = num;
 	qh->cb = cb;
 	qh->data = data;
 
 	ret = __build_send_cfg_msg(h, NFQNL_CFG_CMD_BIND, num, 0);
 	if (ret < 0) {
-		nfq_errno = ret;
 		free(qh);
 		return NULL;
 	}
@@ -598,6 +638,25 @@ struct nfq_q_handle *nfq_create_queue(struct nfq_handle *h, uint16_t num,
  * @}
  */
 
+static int __nfq_handle_msg(const struct nlmsghdr *nlh, void *data)
+{
+	struct nfq_handle *h = data;
+	struct nfq_q_handle *qh;
+	struct nlattr *nfa[NFQA_MAX + 1] = {};
+	struct nfq_data nfad = {nfa};
+	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
+
+	if (nfq_nlmsg_parse(nlh, nfa) < 0)
+		return MNL_CB_ERROR;
+
+	/* Find our queue handler (to get CB fn) */
+	qh = find_qh(h, ntohs(nfmsg->res_id));
+	if (!qh)
+		return MNL_CB_ERROR;
+
+	return qh->cb(qh, nfmsg, &nfad, qh->data);
+}
+
 /**
  * \addtogroup Queue
  * @{
@@ -613,7 +672,8 @@ struct nfq_q_handle *nfq_create_queue(struct nfq_handle *h, uint16_t num,
 EXPORT_SYMBOL
 int nfq_destroy_queue(struct nfq_q_handle *qh)
 {
-	int ret = __build_send_cfg_msg(qh->h, NFQNL_CFG_CMD_UNBIND, qh->id, 0);
+	int ret = __build_send_cfg_msg(qh->h, NFQNL_CFG_CMD_UNBIND,
+				       qh->queue_num, 0);
 	if (ret == 0) {
 		del_qh(qh);
 		free(qh);
@@ -632,12 +692,12 @@ int nfq_destroy_queue(struct nfq_q_handle *qh)
  * queue. Packets can be read from the queue using nfq_fd() and recv(). See
  * example code for nfq_fd().
  *
- * \return 0 on success, non-zero on failure.
+ * \return value returned by callback function specified to nfq_create_queue()
  */
 EXPORT_SYMBOL
 int nfq_handle_packet(struct nfq_handle *h, char *buf, int len)
 {
-	return nfnl_handle_packet(h->nfnlh, buf, len);
+	return mnl_cb_run(buf, len, 0, h->portid, __nfq_handle_msg, h);
 }
 
 /**
@@ -658,22 +718,14 @@ int nfq_handle_packet(struct nfq_handle *h, char *buf, int len)
 EXPORT_SYMBOL
 int nfq_set_mode(struct nfq_q_handle *qh, uint8_t mode, uint32_t range)
 {
-	union {
-		char buf[NFNL_HEADER_LEN
-			+NFA_LENGTH(sizeof(struct nfqnl_msg_config_params))];
-		struct nlmsghdr nmh;
-	} u;
-	struct nfqnl_msg_config_params params;
-
-	nfnl_fill_hdr(qh->h->nfnlssh, &u.nmh, 0, AF_UNSPEC, qh->id,
-			NFQNL_MSG_CONFIG, NLM_F_REQUEST|NLM_F_ACK);
-
-	params.copy_range = htonl(range);
-	params.copy_mode = mode;
-	nfnl_addattr_l(&u.nmh, sizeof(u), NFQA_CFG_PARAMS, &params,
-			sizeof(params));
-
-	return nfnl_query(qh->h->nfnlh, &u.nmh);
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nfq_nlmsg_put2(buf, NFQNL_MSG_CONFIG, qh->queue_num, NLM_F_ACK);
+
+	nfq_nlmsg_cfg_put_params(nlh, mode, range);
+
+	return nfq_query(qh->h, nlh, buf, sizeof(buf));
 }
 
 /**
@@ -707,6 +759,9 @@ int nfq_set_mode(struct nfq_q_handle *qh, uint8_t mode, uint32_t range)
  *   If your application validates checksums (e.g., tcp checksum),
  *   then you must also check if the NFQA_SKB_INFO attribute is present.
  *   If it is, you need to test the NFQA_SKB_CSUMNOTREADY bit:
+ *
+ * FIXME the code below is for the mnl API
+ *       but nfq_set_queue_flags is part of the nfnl API
  * \verbatim
 	if (attr[NFQA_SKB_INFO]) {
 		uint32_t info = ntohl(mnl_attr_get_u32(attr[NFQA_SKB_INFO]));
@@ -747,23 +802,18 @@ int nfq_set_mode(struct nfq_q_handle *qh, uint8_t mode, uint32_t range)
 EXPORT_SYMBOL
 int nfq_set_queue_flags(struct nfq_q_handle *qh, uint32_t mask, uint32_t flags)
 {
-	union {
-		char buf[NFNL_HEADER_LEN
-			+NFA_LENGTH(sizeof(mask)
-			+NFA_LENGTH(sizeof(flags)))];
-		struct nlmsghdr nmh;
-	} u;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
 
 	mask = htonl(mask);
 	flags = htonl(flags);
 
-	nfnl_fill_hdr(qh->h->nfnlssh, &u.nmh, 0, AF_UNSPEC, qh->id,
-		      NFQNL_MSG_CONFIG, NLM_F_REQUEST|NLM_F_ACK);
+	nlh = nfq_nlmsg_put2(buf, NFQNL_MSG_CONFIG, qh->queue_num, NLM_F_ACK);
 
-	nfnl_addattr32(&u.nmh, sizeof(u), NFQA_CFG_FLAGS, flags);
-	nfnl_addattr32(&u.nmh, sizeof(u), NFQA_CFG_MASK, mask);
+	mnl_attr_put_u32(nlh, NFQA_CFG_FLAGS, flags);
+	mnl_attr_put_u32(nlh, NFQA_CFG_MASK, mask);
 
-	return nfnl_query(qh->h->nfnlh, &u.nmh);
+	return nfq_query(qh->h, nlh, buf, sizeof(buf));
 }
 
 /**
@@ -775,25 +825,24 @@ int nfq_set_queue_flags(struct nfq_q_handle *qh, uint32_t mask, uint32_t flags)
  * of packets the kernel will store before internally before dropping
  * upcoming packets.
  *
+ * \note
+ * The kernel already sets this to several times the maximum that other parts
+ * of the system can implement.
+ * For experimenters, setting it to a low value does work.
+ *
  * \return -1 on error; >=0 otherwise.
  */
 EXPORT_SYMBOL
 int nfq_set_queue_maxlen(struct nfq_q_handle *qh, uint32_t queuelen)
 {
-	union {
-		char buf[NFNL_HEADER_LEN
-			+NFA_LENGTH(sizeof(struct nfqnl_msg_config_params))];
-		struct nlmsghdr nmh;
-	} u;
-	uint32_t queue_maxlen = htonl(queuelen);
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
 
-	nfnl_fill_hdr(qh->h->nfnlssh, &u.nmh, 0, AF_UNSPEC, qh->id,
-			NFQNL_MSG_CONFIG, NLM_F_REQUEST|NLM_F_ACK);
+	nlh = nfq_nlmsg_put2(buf, NFQNL_MSG_CONFIG, qh->queue_num, NLM_F_ACK);
 
-	nfnl_addattr_l(&u.nmh, sizeof(u), NFQA_CFG_QUEUE_MAXLEN, &queue_maxlen,
-			sizeof(queue_maxlen));
+	mnl_attr_put_u32(nlh, NFQA_CFG_QUEUE_MAXLEN, htonl(queuelen));
 
-	return nfnl_query(qh->h->nfnlh, &u.nmh);
+	return nfq_query(qh->h, nlh, buf, sizeof(buf));
 }
 
 /**
@@ -805,49 +854,47 @@ static int __set_verdict(struct nfq_q_handle *qh, uint32_t id,
 		uint32_t data_len, const unsigned char *data,
 		enum nfqnl_msg_types type)
 {
-	struct nfqnl_msg_verdict_hdr vh;
-	union {
-		char buf[NFNL_HEADER_LEN
-			+NFA_LENGTH(sizeof(mark))
-			+NFA_LENGTH(sizeof(vh))];
-		struct nlmsghdr nmh;
-	} u;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
 
 	struct iovec iov[3];
 	int nvecs;
 
 	/* This must be declared here (and not inside the data
 	 * handling block) because the iovec points to this. */
-	struct nfattr data_attr;
+	struct nlattr data_attr;
 
 	memset(iov, 0, sizeof(iov));
 
-	vh.verdict = htonl(verdict);
-	vh.id = htonl(id);
-
-	nfnl_fill_hdr(qh->h->nfnlssh, &u.nmh, 0, AF_UNSPEC, qh->id,
-				type, NLM_F_REQUEST);
+	nlh = nfq_nlmsg_put(buf, NFQNL_MSG_VERDICT, qh->queue_num);
 
 	/* add verdict header */
-	nfnl_addattr_l(&u.nmh, sizeof(u), NFQA_VERDICT_HDR, &vh, sizeof(vh));
+	nfq_nlmsg_verdict_put(nlh, id, verdict);
 
 	if (set_mark)
-		nfnl_addattr32(&u.nmh, sizeof(u), NFQA_MARK, mark);
+		nfq_nlmsg_verdict_put_mark(nlh, mark);
+
+	/* Efficiency gain: when there is only 1 iov,
+	 * sendto() is faster than sendmsg() because the kernel only has
+	 * 1 userspace address to validate instead of 2.
+	 */
+	if (!data_len)
+		return mnl_socket_sendto(qh->h->nl, nlh, nlh->nlmsg_len);
 
-	iov[0].iov_base = &u.nmh;
-	iov[0].iov_len = NLMSG_TAIL(&u.nmh) - (void *)&u.nmh;
+	iov[0].iov_base = nlh;
+	iov[0].iov_len = NLMSG_TAIL(nlh) - (void *)nlh;
 	nvecs = 1;
 
 	if (data_len) {
 		/* The typecast here is to cast away data's const-ness: */
-		nfnl_build_nfa_iovec(&iov[1], &data_attr, NFQA_PAYLOAD,
+		nfnl_build_nfa_iovec(&iov[1], (struct nfattr *)&data_attr, NFQA_PAYLOAD,
 				data_len, (unsigned char *) data);
 		nvecs += 2;
 		/* Add the length of the appended data to the message
 		 * header.  The size of the attribute is given in the
-		 * nfa_len field and is set in the nfnl_build_nfa_iovec()
+		 * nla_len field and is set in the nfnl_build_nfa_iovec()
 		 * function. */
-		u.nmh.nlmsg_len += data_attr.nfa_len;
+		nlh->nlmsg_len += data_attr.nla_len;
 	}
 
 	return nfnl_sendiov(qh->h->nfnlh, iov, nvecs, 0);
@@ -1011,8 +1058,10 @@ int nfq_set_verdict_mark(struct nfq_q_handle *qh, uint32_t id,
 EXPORT_SYMBOL
 struct nfqnl_msg_packet_hdr *nfq_get_msg_packet_hdr(struct nfq_data *nfad)
 {
-	return nfnl_get_pointer_to_data(nfad->data, NFQA_PACKET_HDR,
-					struct nfqnl_msg_packet_hdr);
+	if (!nfad->data[NFQA_PACKET_HDR])
+		return NULL;
+
+	return mnl_attr_get_payload(nfad->data[NFQA_PACKET_HDR]);
 }
 
 /**
@@ -1024,6 +1073,10 @@ struct nfqnl_msg_packet_hdr *nfq_get_msg_packet_hdr(struct nfq_data *nfad)
 EXPORT_SYMBOL
 uint32_t nfq_get_nfmark(struct nfq_data *nfad)
 {
+	if (!nfad->data[NFQA_MARK])
+		return 0;
+
+	return ntohl(mnl_attr_get_u32(nfad->data[NFQA_MARK]));
 	return ntohl(nfnl_get_data(nfad->data, NFQA_MARK, uint32_t));
 }
 
@@ -1040,11 +1093,12 @@ EXPORT_SYMBOL
 int nfq_get_timestamp(struct nfq_data *nfad, struct timeval *tv)
 {
 	struct nfqnl_msg_packet_timestamp *qpt;
-	qpt = nfnl_get_pointer_to_data(nfad->data, NFQA_TIMESTAMP,
-					struct nfqnl_msg_packet_timestamp);
-	if (!qpt)
+
+	if (!nfad->data[NFQA_TIMESTAMP])
 		return -1;
 
+	qpt = mnl_attr_get_payload(nfad->data[NFQA_TIMESTAMP]);
+
 	tv->tv_sec = __be64_to_cpu(qpt->sec);
 	tv->tv_usec = __be64_to_cpu(qpt->usec);
 
@@ -1065,7 +1119,10 @@ int nfq_get_timestamp(struct nfq_data *nfad, struct timeval *tv)
 EXPORT_SYMBOL
 uint32_t nfq_get_indev(struct nfq_data *nfad)
 {
-	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_INDEV, uint32_t));
+	if (!nfad->data[NFQA_IFINDEX_INDEV])
+		return 0;
+
+	return ntohl(mnl_attr_get_u32(nfad->data[NFQA_IFINDEX_INDEV]));
 }
 
 /**
@@ -1079,7 +1136,10 @@ uint32_t nfq_get_indev(struct nfq_data *nfad)
 EXPORT_SYMBOL
 uint32_t nfq_get_physindev(struct nfq_data *nfad)
 {
-	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_PHYSINDEV, uint32_t));
+	if (!nfad->data[NFQA_IFINDEX_PHYSINDEV])
+		return 0;
+
+	return ntohl(mnl_attr_get_u32(nfad->data[NFQA_IFINDEX_PHYSINDEV]));
 }
 
 /**
@@ -1093,7 +1153,10 @@ uint32_t nfq_get_physindev(struct nfq_data *nfad)
 EXPORT_SYMBOL
 uint32_t nfq_get_outdev(struct nfq_data *nfad)
 {
-	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_OUTDEV, uint32_t));
+	if (!nfad->data[NFQA_IFINDEX_OUTDEV])
+		return 0;
+
+	return ntohl(mnl_attr_get_u32(nfad->data[NFQA_IFINDEX_OUTDEV]));
 }
 
 /**
@@ -1109,7 +1172,10 @@ uint32_t nfq_get_outdev(struct nfq_data *nfad)
 EXPORT_SYMBOL
 uint32_t nfq_get_physoutdev(struct nfq_data *nfad)
 {
-	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_PHYSOUTDEV, uint32_t));
+	if (!nfad->data[NFQA_IFINDEX_PHYSOUTDEV])
+		return 0;
+
+	return ntohl(mnl_attr_get_u32(nfad->data[NFQA_IFINDEX_PHYSOUTDEV]));
 }
 
 /**
@@ -1244,8 +1310,10 @@ int nfq_get_physoutdev_name(struct nlif_handle *nlif_handle,
 EXPORT_SYMBOL
 struct nfqnl_msg_packet_hw *nfq_get_packet_hw(struct nfq_data *nfad)
 {
-	return nfnl_get_pointer_to_data(nfad->data, NFQA_HWADDR,
-					struct nfqnl_msg_packet_hw);
+	if (!nfad->data[NFQA_HWADDR])
+		return NULL;
+
+	return mnl_attr_get_payload(nfad->data[NFQA_HWADDR]);
 }
 
 /**
@@ -1293,10 +1361,10 @@ uint32_t nfq_get_skbinfo(struct nfq_data *nfad)
 EXPORT_SYMBOL
 int nfq_get_uid(struct nfq_data *nfad, uint32_t *uid)
 {
-	if (!nfnl_attr_present(nfad->data, NFQA_UID))
+	if (!nfad->data[NFQA_UID])
 		return 0;
 
-	*uid = ntohl(nfnl_get_data(nfad->data, NFQA_UID, uint32_t));
+	*uid = ntohl(mnl_attr_get_u32(nfad->data[NFQA_UID]));
 	return 1;
 }
 
@@ -1314,10 +1382,10 @@ int nfq_get_uid(struct nfq_data *nfad, uint32_t *uid)
 EXPORT_SYMBOL
 int nfq_get_gid(struct nfq_data *nfad, uint32_t *gid)
 {
-	if (!nfnl_attr_present(nfad->data, NFQA_GID))
+	if (!nfad->data[NFQA_GID])
 		return 0;
 
-	*gid = ntohl(nfnl_get_data(nfad->data, NFQA_GID, uint32_t));
+	*gid = ntohl(mnl_attr_get_u32(nfad->data[NFQA_GID]));
 	return 1;
 }
 
@@ -1335,14 +1403,13 @@ int nfq_get_gid(struct nfq_data *nfad, uint32_t *gid)
 EXPORT_SYMBOL
 int nfq_get_secctx(struct nfq_data *nfad, unsigned char **secdata)
 {
-	if (!nfnl_attr_present(nfad->data, NFQA_SECCTX))
+	if (!nfad->data[NFQA_SECCTX])
 		return -1;
 
-	*secdata = (unsigned char *)nfnl_get_pointer_to_data(nfad->data,
-							NFQA_SECCTX, char);
+	*secdata = mnl_attr_get_payload(nfad->data[NFQA_SECCTX]);
 
 	if (*secdata)
-		return NFA_PAYLOAD(nfad->data[NFQA_SECCTX-1]);
+		return mnl_attr_get_payload_len(nfad->data[NFQA_SECCTX]);
 
 	return 0;
 }
@@ -1361,10 +1428,12 @@ int nfq_get_secctx(struct nfq_data *nfad, unsigned char **secdata)
 EXPORT_SYMBOL
 int nfq_get_payload(struct nfq_data *nfad, unsigned char **data)
 {
-	*data = (unsigned char *)
-		nfnl_get_pointer_to_data(nfad->data, NFQA_PAYLOAD, char);
+	if (!nfad->data[NFQA_PAYLOAD])
+		return -1;
+
+	*data = mnl_attr_get_payload(nfad->data[NFQA_PAYLOAD]);
 	if (*data)
-		return NFA_PAYLOAD(nfad->data[NFQA_PAYLOAD-1]);
+		return mnl_attr_get_payload_len(nfad->data[NFQA_PAYLOAD]);
 
 	return -1;
 }
diff --git a/utils/Makefile.am b/utils/Makefile.am
index d3147e3..d0d3eb8 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -4,6 +4,6 @@ check_PROGRAMS = nfqnl_test
 
 nfqnl_test_SOURCES = nfqnl_test.c
 nfqnl_test_LDADD = ../src/libnetfilter_queue.la
-nfqnl_test_LDFLAGS = -dynamic
+nfqnl_test_LDFLAGS = -dynamic -Wl,--unresolved-symbols=ignore-all
 
 
-- 
2.35.8

