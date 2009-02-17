From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: (nfnl_talk: recvmsg over-run) and (nf_queue: full at 1024 	entries,
 dropping packets(s). Dropped: 582) - bug or just some defaults 	increase
 required?
Date: Tue, 17 Feb 2009 20:51:41 +0100
Message-ID: <499B154D.9020805@netfilter.org>
References: <c4b050a10902061014w3df3b2c3xe9e6465be79b4e07@mail.gmail.com>	 <4996FBBE.20009@netfilter.org>	 <200902161819.27630.anton.vazir@gmail.com>	 <49996D49.9050606@netfilter.org>	 <c4b050a10902160638s231bd34by7e90f320dde3e27e@mail.gmail.com>	 <49998504.9020004@netfilter.org>	 <c4b050a10902160733y605a5cc1l710596b0aa658f5d@mail.gmail.com>	 <c4b050a10902160741i6d7a42deqaa41f9e22bdc4484@mail.gmail.com>	 <c4b050a10902170858j698c32c3ye6c58682911c59eb@mail.gmail.com>	 <499AF0B8.5060202@netfilter.org> <c4b050a10902170934q5a70c009i90f921659ce80f96@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010808090200050701040101"
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	Vitaly Bodzhgua <vitaly@eastera.tj>
To: Anton VG <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60313 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751959AbZBQTwA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2009 14:52:00 -0500
In-Reply-To: <c4b050a10902170934q5a70c009i90f921659ce80f96@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010808090200050701040101
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Anton VG wrote:
> As I understand, the previous patch should be applied also?

While testing this a bit more, I notice that there are more race
conditions in the sequence tracking that the previous patch cannot fix.
As a temporary workaround, sequence tracking has been disabled.

I'm going to commit the following patches.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------010808090200050701040101
Content-Type: text/x-diff;
 name="libnfnl.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libnfnl.patch"

nfnl: allow disabling and enabling sequence tracking

This patch adds a couple of functions to enable and disable netlink
sequence tracking. Since nfqueue goes over a unicast socket, the
same channel to receive control messages and packets is used. This
leads to race conditions that may trigger sporious out-of-sequence
errors while creating queues and receiving high load of packets at
the same time.

Reported-by: Anton Vazir <anton.vazir@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 configure.in                        |    2 +-
 include/libnfnetlink/libnfnetlink.h |    4 ++++
 src/libnfnetlink.c                  |   37 +++++++++++++++++++++++++++++++----
 3 files changed, 38 insertions(+), 5 deletions(-)


diff --git a/configure.in b/configure.in
index 27b00c2..f760cd0 100644
--- a/configure.in
+++ b/configure.in
@@ -1,6 +1,6 @@
 dnl Process this file with autoconf to create configure.
 
-AC_INIT(libnfnetlink, 0.0.40)
+AC_INIT(libnfnetlink, 0.0.41)
 
 AC_CANONICAL_SYSTEM
 
diff --git a/include/libnfnetlink/libnfnetlink.h b/include/libnfnetlink/libnfnetlink.h
index b2f3652..10b6478 100644
--- a/include/libnfnetlink/libnfnetlink.h
+++ b/include/libnfnetlink/libnfnetlink.h
@@ -60,6 +60,10 @@ extern struct nfnl_subsys_handle *nfnl_subsys_open(struct nfnl_handle *,
 						   unsigned int);
 extern void nfnl_subsys_close(struct nfnl_subsys_handle *);
 
+/* set and unset sequence tracking */
+void nfnl_set_sequence_tracking(struct nfnl_handle *h);
+void nfnl_unset_sequence_tracking(struct nfnl_handle *h);
+
 /* set receive buffer size (for nfnl_catch) */
 extern void nfnl_set_rcv_buffer_size(struct nfnl_handle *h, unsigned int size);
 
diff --git a/src/libnfnetlink.c b/src/libnfnetlink.c
index d4212f9..a836de1 100644
--- a/src/libnfnetlink.c
+++ b/src/libnfnetlink.c
@@ -78,6 +78,9 @@ struct nfnl_subsys_handle {
 };
 
 #define		NFNL_MAX_SUBSYS			16 /* enough for now */
+
+#define NFNL_F_SEQTRACK_ENABLED		(1 << 0)
+
 struct nfnl_handle {
 	int			fd;
 	struct sockaddr_nl	local;
@@ -86,6 +89,7 @@ struct nfnl_handle {
 	u_int32_t		seq;
 	u_int32_t		dump;
 	u_int32_t		rcv_buffer_size;	/* for nfnl_catch */
+	u_int32_t		flags;
 	struct nlmsghdr 	*last_nlhdr;
 	struct nfnl_subsys_handle subsys[NFNL_MAX_SUBSYS+1];
 };
@@ -202,6 +206,8 @@ struct nfnl_handle *nfnl_open(void)
 		errno = EINVAL;
 		goto err_close;
 	}
+	/* sequence tracking enabled by default */
+	nfnlh->flags |= NFNL_F_SEQTRACK_ENABLED;
 
 	return nfnlh;
 
@@ -213,6 +219,24 @@ err_free:
 }
 
 /**
+ * nfnl_set_sequence_tracking - set netlink sequence tracking
+ * @h: nfnetlink handler
+ */
+void nfnl_set_sequence_tracking(struct nfnl_handle *h)
+{
+	h->flags |= NFNL_F_SEQTRACK_ENABLED;
+}
+
+/**
+ * nfnl_unset_sequence_tracking - set netlink sequence tracking
+ * @h: nfnetlink handler
+ */
+void nfnl_unset_sequence_tracking(struct nfnl_handle *h)
+{
+	h->flags &= ~NFNL_F_SEQTRACK_ENABLED;
+}
+
+/**
  * nfnl_set_rcv_buffer_size - set the size of the receive buffer
  * @h: libnfnetlink handler
  * @size: buffer size
@@ -418,11 +442,16 @@ void nfnl_fill_hdr(struct nfnl_subsys_handle *ssh,
 	nlh->nlmsg_type = (ssh->subsys_id<<8)|msg_type;
 	nlh->nlmsg_flags = msg_flags;
 	nlh->nlmsg_pid = 0;
-	nlh->nlmsg_seq = ++ssh->nfnlh->seq;
 
-	/* check for wraparounds: assume that seqnum 0 is only used by events */
-	if (!ssh->nfnlh->seq)
-		nlh->nlmsg_seq = ssh->nfnlh->seq = time(NULL);
+	if (ssh->nfnlh->flags & NFNL_F_SEQTRACK_ENABLED) {
+		nlh->nlmsg_seq = ++ssh->nfnlh->seq;
+		/* kernel uses sequence number zero for events */
+		if (!ssh->nfnlh->seq)
+			nlh->nlmsg_seq = ssh->nfnlh->seq = time(NULL);
+	} else {
+		/* unset sequence number, ignore it */
+		nlh->nlmsg_seq = 0;
+	}
 
 	nfg->nfgen_family = family;
 	nfg->version = NFNETLINK_V0;

--------------010808090200050701040101
Content-Type: text/x-diff;
 name="libnfq.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libnfq.patch"

nfq: replace nfnl_talk by nfnl_query and disable sequence tracking

This patch replaces the nfnl_talk() calls by the newer nfnl_query().
This patch also disables netlink sequence tracking by default.
Spurious race conditions in the sequence tracking may occur while
creating queues and receiving high load of packets at the same time.

Reported-by: Anton Vazir <anton.vazir@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 configure.in             |    2 +-
 src/libnetfilter_queue.c |    9 ++++++---
 2 files changed, 7 insertions(+), 4 deletions(-)


diff --git a/configure.in b/configure.in
index d3ce4a0..15e03a1 100644
--- a/configure.in
+++ b/configure.in
@@ -18,7 +18,7 @@ case $target in
 esac
 
 dnl Dependencies
-LIBNFNETLINK_REQUIRED=0.0.38
+LIBNFNETLINK_REQUIRED=0.0.41
  
 PKG_CHECK_MODULES(LIBNFNETLINK, libnfnetlink >= $LIBNFNETLINK_REQUIRED,,
 	AC_MSG_ERROR(Cannot find libnfnetlink >= $LIBNFNETLINK_REQUIRED))
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 9e4903b..a2d0de2 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -141,7 +141,7 @@ __build_send_cfg_msg(struct nfq_handle *h, u_int8_t command,
 	cmd.pf = htons(pf);
 	nfnl_addattr_l(&u.nmh, sizeof(u), NFQA_CFG_CMD, &cmd, sizeof(cmd));
 
-	return nfnl_talk(h->nfnlh, &u.nmh, 0, 0, NULL, NULL, NULL);
+	return nfnl_query(h->nfnlh, &u.nmh);
 }
 
 static int __nfq_rcv_pkt(struct nlmsghdr *nlh, struct nfattr *nfa[],
@@ -295,6 +295,9 @@ struct nfq_handle *nfq_open(void)
 	if (!nfnlh)
 		return NULL;
 
+	/* unset netlink sequence tracking by default */
+	nfnl_unset_sequence_tracking(nfnlh);
+
 	qh = nfq_open_nfnl(nfnlh);
 	if (!qh)
 		nfnl_close(nfnlh);
@@ -553,7 +556,7 @@ int nfq_set_mode(struct nfq_q_handle *qh,
 	nfnl_addattr_l(&u.nmh, sizeof(u), NFQA_CFG_PARAMS, &params,
 			sizeof(params));
 
-	return nfnl_talk(qh->h->nfnlh, &u.nmh, 0, 0, NULL, NULL, NULL);
+	return nfnl_query(qh->h->nfnlh, &u.nmh);
 }
 
 /**
@@ -581,7 +584,7 @@ int nfq_set_queue_maxlen(struct nfq_q_handle *qh,
 	nfnl_addattr_l(&u.nmh, sizeof(u), NFQA_CFG_QUEUE_MAXLEN, &queue_maxlen,
 			sizeof(queue_maxlen));
 
-	return nfnl_talk(qh->h->nfnlh, &u.nmh, 0, 0, NULL, NULL, NULL);
+	return nfnl_query(qh->h->nfnlh, &u.nmh);
 }
 
 /**

--------------010808090200050701040101--
