From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [libmnl] mmap patch review request
Date: Sun, 23 Feb 2014 18:04:49 +0900
Message-ID: <CAGCkEt27iUktp_uY=8OTxs433T2Zt7r3tk7qv5sq51jfTTb97Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:64008 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaBWJEw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Feb 2014 04:04:52 -0500
Received: by mail-la0-f45.google.com with SMTP id b8so4165377lan.4
        for <netfilter-devel@vger.kernel.org>; Sun, 23 Feb 2014 01:04:51 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  Hello Pablo, lists.

Few people get interest but let me show my current mmaped patch.
I put this and examples

    https://github.com/chamaken/libmnl/tree/mmap


Any advice is welcome.
thanks.

--------

diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
index 223709c..e05bf02 100644
--- a/include/libmnl/libmnl.h
+++ b/include/libmnl/libmnl.h
@@ -7,6 +7,7 @@
 #include <unistd.h>
 #include <sys/socket.h> /* for sa_family_t */
 #include <linux/netlink.h>
+#include <linux/kernel.h> /* for __ALIGN_KERNEL */

 #ifdef __cplusplus
 extern "C" {
@@ -19,10 +20,47 @@ extern "C" {
 #define MNL_SOCKET_AUTOPID     0
 #define MNL_SOCKET_BUFFER_SIZE (getpagesize() < 8192L ? getpagesize() : 8192L)

+#ifndef NETLINK_RX_RING
+struct nl_mmap_hdr {
+       unsigned int    nm_status;
+       unsigned int    nm_len;
+       __u32           nm_group;
+       /* credentials */
+       __u32           nm_pid;
+       __u32           nm_uid;
+       __u32           nm_gid;
+};
+
+enum nl_mmap_status {
+       NL_MMAP_STATUS_UNUSED,
+       NL_MMAP_STATUS_RESERVED,
+       NL_MMAP_STATUS_VALID,
+       NL_MMAP_STATUS_COPY,
+       NL_MMAP_STATUS_SKIP,
+};
+
+#define NL_MMAP_MSG_ALIGNMENT          NLMSG_ALIGNTO
+#define NL_MMAP_MSG_ALIGN(sz)          __ALIGN_KERNEL(sz,
NL_MMAP_MSG_ALIGNMENT)
+#define NL_MMAP_HDRLEN                 NL_MMAP_MSG_ALIGN(sizeof(
struct nl_mmap_hdr))
+#endif /* NETLINK_RX_RING */
+
+enum mnl_ring_types {
+       MNL_RING_RX,
+       MNL_RING_TX,
+};
+
 struct mnl_socket;
+struct mnl_ring;
+
+#define MNL_FRAME_PAYLOAD(frame) ((void *)(frame) + NL_MMAP_HDRLEN)

 extern struct mnl_socket *mnl_socket_open(int type);
 extern int mnl_socket_bind(struct mnl_socket *nl, unsigned int
groups, pid_t pid);
+extern int mnl_socket_set_ringopt(struct mnl_socket *nl, enum
mnl_ring_types type,
+                                 unsigned int block_size, unsigned
int block_nf,
+                                 unsigned int frame_size, unsigned
int frame_nr);
+extern int mnl_socket_map_ring(struct mnl_socket *nl);
+extern int mnl_socket_unmap_ring(struct mnl_socket *nl);
 extern int mnl_socket_close(struct mnl_socket *nl);
 extern int mnl_socket_get_fd(const struct mnl_socket *nl);
 extern unsigned int mnl_socket_get_portid(const struct mnl_socket *nl);
@@ -30,6 +68,9 @@ extern ssize_t mnl_socket_sendto(const struct
mnl_socket *nl, const void *req, s
 extern ssize_t mnl_socket_recvfrom(const struct mnl_socket *nl, void
*buf, size_t siz);
 extern int mnl_socket_setsockopt(const struct mnl_socket *nl, int
type, void *buf, socklen_t len);
 extern int mnl_socket_getsockopt(const struct mnl_socket *nl, int
type, void *buf, socklen_t *len);
+extern struct mnl_ring *mnl_socket_get_ring(const struct mnl_socket
*nl, enum mnl_ring_types type);
+extern void mnl_ring_advance(struct mnl_ring *ring);
+extern struct nl_mmap_hdr *mnl_ring_get_frame(const struct mnl_ring *ring);

 /*
  * Netlink message API
@@ -74,6 +115,7 @@ extern void mnl_nlmsg_batch_reset(struct mnl_nlmsg_batch *b);
 extern void *mnl_nlmsg_batch_head(struct mnl_nlmsg_batch *b);
 extern void *mnl_nlmsg_batch_current(struct mnl_nlmsg_batch *b);
 extern bool mnl_nlmsg_batch_is_empty(struct mnl_nlmsg_batch *b);
+extern void mnl_nlmsg_batch_reset_buffer(struct mnl_nlmsg_batch *b,
void *buf, size_t limit);

 /*
  * Netlink attributes API
diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index ced0e1a..1a85940 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -1,6 +1,7 @@
-#ifndef __LINUX_NETLINK_H
-#define __LINUX_NETLINK_H
+#ifndef _UAPI__LINUX_NETLINK_H
+#define _UAPI__LINUX_NETLINK_H

+#include <linux/kernel.h>
 #include <linux/socket.h> /* for __kernel_sa_family_t */
 #include <linux/types.h>

@@ -78,7 +79,7 @@ struct nlmsghdr {
 #define NLMSG_ALIGNTO  4U
 #define NLMSG_ALIGN(len) ( ((len)+NLMSG_ALIGNTO-1) & ~(NLMSG_ALIGNTO-1) )
 #define NLMSG_HDRLEN    ((int) NLMSG_ALIGN(sizeof(struct nlmsghdr)))
-#define NLMSG_LENGTH(len) ((len)+NLMSG_ALIGN(NLMSG_HDRLEN))
+#define NLMSG_LENGTH(len) ((len) + NLMSG_HDRLEN)
 #define NLMSG_SPACE(len) NLMSG_ALIGN(NLMSG_LENGTH(len))
 #define NLMSG_DATA(nlh)  ((void*)(((char*)nlh) + NLMSG_LENGTH(0)))
 #define NLMSG_NEXT(nlh,len)     ((len) -= NLMSG_ALIGN((nlh)->nlmsg_len), \
@@ -105,11 +106,42 @@ struct nlmsgerr {
 #define NETLINK_PKTINFO                3
 #define NETLINK_BROADCAST_ERROR        4
 #define NETLINK_NO_ENOBUFS     5
+#define NETLINK_RX_RING                6
+#define NETLINK_TX_RING                7

 struct nl_pktinfo {
        __u32   group;
 };

+struct nl_mmap_req {
+       unsigned int    nm_block_size;
+       unsigned int    nm_block_nr;
+       unsigned int    nm_frame_size;
+       unsigned int    nm_frame_nr;
+};
+
+struct nl_mmap_hdr {
+       unsigned int    nm_status;
+       unsigned int    nm_len;
+       __u32           nm_group;
+       /* credentials */
+       __u32           nm_pid;
+       __u32           nm_uid;
+       __u32           nm_gid;
+};
+
+enum nl_mmap_status {
+       NL_MMAP_STATUS_UNUSED,
+       NL_MMAP_STATUS_RESERVED,
+       NL_MMAP_STATUS_VALID,
+       NL_MMAP_STATUS_COPY,
+       NL_MMAP_STATUS_SKIP,
+};
+
+#define NL_MMAP_MSG_ALIGNMENT          NLMSG_ALIGNTO
+#define NL_MMAP_MSG_ALIGN(sz)          __ALIGN_KERNEL(sz,
NL_MMAP_MSG_ALIGNMENT)
+#define NL_MMAP_HDRLEN
NL_MMAP_MSG_ALIGN(sizeof(struct nl_mmap_hdr))
+
 #define NET_MAJOR 36           /* Major 36 is reserved for networking
                                         */

 enum {
@@ -150,4 +182,4 @@ struct nlattr {
 #define NLA_HDRLEN             ((int) NLA_ALIGN(sizeof(struct nlattr)))


-#endif /* __LINUX_NETLINK_H */
+#endif /* _UAPI__LINUX_NETLINK_H */
diff --git a/src/libmnl.map b/src/libmnl.map
index dbc332e..d9b796a 100644
--- a/src/libmnl.map
+++ b/src/libmnl.map
@@ -65,10 +65,16 @@ global:
   mnl_socket_recvfrom;
   mnl_socket_sendto;
   mnl_socket_setsockopt;
-
 local: *;
 };

 LIBMNL_1.1 {
   mnl_attr_parse_payload;
+  mnl_socket_set_ringopt;
+  mnl_socket_map_ring;
+  mnl_socket_unmap_ring;
+  mnl_socket_get_ring;
+  mnl_ring_advance;
+  mnl_ring_get_frame;
+  mnl_nlmsg_batch_reset_buffer;
 } LIBMNL_1.0;
diff --git a/src/nlmsg.c b/src/nlmsg.c
index fdb7af8..5dbe1ba 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -569,5 +569,34 @@ bool mnl_nlmsg_batch_is_empty(struct mnl_nlmsg_batch *b)
 EXPORT_SYMBOL(mnl_nlmsg_batch_is_empty);

 /**
+ * mnl_nlmsg_batch_reset_buffer - reset to the new buffer
+ * \param buf pointer to the new (mmaped tx frame) buffer that will store this
+ *        batch
+ * \param limit maximum size of the batch (should be half of
+ *        nl_mmap_req.frame_size)
+ *
+ * This function is for mmap tx frame, allows to set new buffer (frame) and
+ * reset a batch, so you can reuse it to create a new one. This function moves
+ * the last message which does not fit the batch to the head of the new buffer,
+ * if any.
+ */
+void mnl_nlmsg_batch_reset_buffer(struct mnl_nlmsg_batch *b, void
*buf, size_t limit)
+{
+       if (b->overflow) {
+               struct nlmsghdr *nlh = b->cur;
+               memcpy(buf, b->cur, nlh->nlmsg_len);
+               b->buflen = nlh->nlmsg_len;
+               b->cur = buf + b->buflen;
+               b->overflow = false;
+       } else {
+               b->buflen = 0;
+               b->cur = buf;
+       }
+       b->buf = buf;
+       b->limit = limit;
+}
+EXPORT_SYMBOL(mnl_nlmsg_batch_reset_buffer);
+
+/**
  * @}
  */
diff --git a/src/socket.c b/src/socket.c
index 676a08a..f63bd5e 100644
--- a/src/socket.c
+++ b/src/socket.c
@@ -10,6 +10,7 @@
 #include <libmnl/libmnl.h>
 #include <sys/types.h>
 #include <sys/socket.h>
+#include <sys/mman.h>
 #include <stdlib.h>
 #include <unistd.h>
 #include <time.h>
@@ -66,9 +67,19 @@
  * code tree.
  */

+struct mnl_ring {
+       unsigned int            head;
+       void                    *ring;
+       unsigned int            frame_size;
+       unsigned int            frame_max;
+       unsigned int            block_size;
+};
+
 struct mnl_socket {
        int                     fd;
        struct sockaddr_nl      addr;
+       struct mnl_ring         *rx_ring;
+       struct mnl_ring         *tx_ring;
 };

 /**
@@ -168,6 +179,151 @@ int mnl_socket_bind(struct mnl_socket *nl,
unsigned int groups, pid_t pid)
 }
 EXPORT_SYMBOL(mnl_socket_bind);

+static struct mnl_ring *alloc_ring(const struct nl_mmap_req *req)
+{
+       struct mnl_ring *ring;
+
+       ring = calloc(sizeof(struct mnl_ring), 1);
+       if (ring == NULL)
+               return NULL;
+
+       ring->frame_size        = req->nm_frame_size;
+       ring->frame_max         = req->nm_frame_nr - 1;
+       ring->block_size        = req->nm_block_size;
+
+       return ring;
+}
+
+/**
+ * mnl_socket_set_ringopt - set ring socket option to prepare for
mnl_socket_map_ring()
+ * \param nl netlink socket obtained via mnl_socket_open()
+ * \param type ring type either MNL_RING_RX or MNL_RING_TX
+ * \param block_size ring block size
+ * \param block_nr number of blocks
+ * \param frame_size ring frame size
+ * \param frame_nr number of frames
+ *
+ * On success, 0 is returned. On error, this function returns -1, errno is
+ * appropriately set. See linux/Documentation/networking/netlink_mmap.txt
+ * for detail about block/frame params.
+ */
+int mnl_socket_set_ringopt(struct mnl_socket *nl, enum mnl_ring_types type,
+                          unsigned int block_size, unsigned int block_nr,
+                          unsigned int frame_size, unsigned int frame_nr)
+{
+       int optype, pre_errno, ret;
+       struct mnl_ring **ring;
+       struct nl_mmap_req req = {.nm_block_size = block_size,
.nm_block_nr = block_nr,
+                                 .nm_frame_size = frame_size,
.nm_frame_nr = frame_nr};
+
+       switch (type) {
+       case MNL_RING_RX:
+               ring = &nl->rx_ring;
+               optype = NETLINK_RX_RING;
+               break;
+       case MNL_RING_TX:
+               ring = &nl->tx_ring;
+               optype = NETLINK_TX_RING;
+               break;
+       default:
+               errno = EINVAL;
+               return -1;
+               break;
+       }
+
+       if (*ring != NULL) {
+               errno = EALREADY;
+               return -1;
+       }
+       *ring = alloc_ring(&req);
+       if (*ring == NULL)
+               return -1;
+
+       ret = mnl_socket_setsockopt(nl, optype, &req, sizeof(req));
+       if (ret == -1) {
+               pre_errno = errno;
+               free(*ring);
+               *ring = NULL;
+               errno = pre_errno;
+       }
+       return ret;
+}
+EXPORT_SYMBOL(mnl_socket_set_ringopt);
+
+static inline size_t ring_size(struct mnl_ring *ring)
+{
+       unsigned int frames_per_block = ring->block_size / ring->frame_size;
+       unsigned int block_nr = (ring->frame_max + 1) / frames_per_block;
+       return block_nr * ring->block_size;
+}
+
+/**
+ * mnl_socket_map_ring - setup a ring for mnl_socket
+ * \param nl netlink socket obtained via mnl_socket_open()
+ *
+ * This function must be called after setting ring up by
+ * mnl_socket_set_ringopt(). On success, 0 is returned. On error, this function
+ * returns -1 and errno is appropriately set and req parameter
+ */
+int mnl_socket_map_ring(struct mnl_socket *nl)
+{
+       size_t rx_size = 0, tx_size = 0;
+       struct mnl_ring *rx_ring = nl->rx_ring, *tx_ring = nl->tx_ring;
+       void *ring;
+
+       if (rx_ring == NULL && tx_ring == NULL) {
+               errno = EBADR;
+               return -1;
+       }
+
+       if (rx_ring != NULL)
+               rx_size = ring_size(rx_ring);
+       if (tx_ring != NULL)
+               tx_size = ring_size(tx_ring);
+       ring = mmap(NULL, tx_size + rx_size, PROT_READ | PROT_WRITE,
MAP_SHARED, nl->fd, 0);
+       if (ring == MAP_FAILED)
+               return -1;
+
+       if (rx_ring != NULL && tx_ring != NULL) {
+               nl->rx_ring->ring = ring;
+               nl->tx_ring->ring = ring + rx_size;
+       } else if (rx_ring != NULL) {
+               nl->rx_ring->ring = ring;
+       } else {
+               nl->tx_ring->ring = ring;
+       }
+
+       return 0;
+}
+EXPORT_SYMBOL(mnl_socket_map_ring);
+
+/**
+ * mnl_socket_unmap_ring - unmap a ring for mnl_socket
+ * \param nl netlink socket obtained via mnl_socket_open()
+ *
+ * On error, this function returns -1 and errno is appropriately set.
+ * On success, it returns 0.
+ */
+int mnl_socket_unmap_ring(struct mnl_socket *nl)
+{
+       void *addr = NULL;
+       size_t length = 0;
+
+       if (nl->tx_ring != NULL) {
+               addr = nl->tx_ring->ring;
+               length += ring_size(nl->tx_ring);
+               nl->tx_ring->ring = NULL;
+       }
+       if (nl->rx_ring != NULL) {
+               addr = nl->rx_ring->ring;
+               length += ring_size(nl->rx_ring);
+               nl->rx_ring->ring = NULL;
+       }
+
+       return munmap(addr, length);
+}
+EXPORT_SYMBOL(mnl_socket_unmap_ring);
+
 /**
  * mnl_socket_sendto - send a netlink message of a certain size
  * \param nl netlink socket obtained via mnl_socket_open()
@@ -246,6 +402,10 @@ EXPORT_SYMBOL(mnl_socket_recvfrom);
 int mnl_socket_close(struct mnl_socket *nl)
 {
        int ret = close(nl->fd);
+       if (nl->rx_ring)
+               free(nl->rx_ring);
+       if (nl->tx_ring)
+               free(nl->tx_ring);
        free(nl);
        return ret;
 }
@@ -300,5 +460,69 @@ int mnl_socket_getsockopt(const struct mnl_socket
*nl, int type,
 EXPORT_SYMBOL(mnl_socket_getsockopt);

 /**
+ * mnl_socket_get_ring - get ring from mnl_socket
+ * \param nl netlink socket obtained via mnl_socket_open()
+ * \param type ring type either MNL_RING_RX or MNL_RING_TX
+ *
+ * On error, this function returns NULL and errno is appropriately
set. Otherwise,
+ * it returns a valid pointer to the mnl_ring structure.
+ */
+struct mnl_ring *mnl_socket_get_ring(const struct mnl_socket *nl,
enum mnl_ring_types type)
+{
+       struct mnl_ring *ring = NULL;
+
+       switch (type) {
+       case MNL_RING_RX:
+               ring = nl->rx_ring;
+               break;
+       case MNL_RING_TX:
+               ring = nl->tx_ring;
+               break;
+       default:
+               errno = EINVAL;
+               return NULL;
+               break;
+       }
+       if (ring->ring == NULL) {
+               errno = EBADR;
+               return NULL;
+       }
+       return ring;
+}
+EXPORT_SYMBOL(mnl_socket_get_ring);
+
+/**
+ * mnl_ring_advance - set forward frame pointer
+ * \param ring mnl_ring structure obtained via mnl_socket_get_ring()
+ *
+ * This function adcvances current frame pointer.
+ */
+void mnl_ring_advance(struct mnl_ring *ring)
+{
+       ring->head = ring->head != ring->frame_max ? ring->head + 1 : 0;
+}
+EXPORT_SYMBOL(mnl_ring_advance);
+
+/**
+ * mnl_ring_get_frame - get current frame
+ * \param ring mnl_ring structure obtained via mnl_socket_get_ring()
+ *
+ * This function returns nl_mmap_hdr structure of current frame pointer
+ */
+struct nl_mmap_hdr *mnl_ring_get_frame(const struct mnl_ring *ring)
+{
+       unsigned int frames_per_block, block_pos, frame_off;
+
+       frames_per_block = ring->block_size / ring->frame_size;
+       block_pos = ring->head / frames_per_block;
+       frame_off = ring->head % frames_per_block;
+
+       return (struct nl_mmap_hdr *)(ring->ring
+                                     + block_pos * ring->block_size
+                                     + frame_off * ring->frame_size);
+}
+EXPORT_SYMBOL(mnl_ring_get_frame);
+
+/**
  * @}
  */
