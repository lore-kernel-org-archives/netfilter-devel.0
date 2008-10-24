From: Eric Leblond <eric@inl.fr>
Subject: [PATCH] Complete libnetfilter_queue documentation.
Date: Fri, 24 Oct 2008 10:32:20 +0200
Message-ID: <1224837140-4094-1-git-send-email-eric@inl.fr>
References: <4900B33A.5000907@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43610 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750778AbYJXIcY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Oct 2008 04:32:24 -0400
In-Reply-To: <4900B33A.5000907@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds documentation for functions that were not existing
when the documentation was initially made. It also fixes some slight
typo.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 src/libnetfilter_queue.c |  113 +++++++++++++++++++++++++++++++++++++++------
 1 files changed, 98 insertions(+), 15 deletions(-)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 7d0b92f..5db6fd1 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -1,4 +1,4 @@
-/* libnfqnetlink.c: generic library for access to nf_queue
+/* libnetfilter_queue.c: generic library for access to nf_queue
  *
  * (C) 2005 by Harald Welte <laforge@gnumonks.org>
  *
@@ -148,10 +148,10 @@ struct nfnl_handle *nfq_nfnlh(struct nfq_handle *h)
 
 /**
  * nfq_fd - get the file descriptor associated with the nfqueue handler
- * h: Netfilter queue connection handle obtained via call to nfq_open()
+ * @h: Netfilter queue connection handle obtained via call to nfq_open()
  *
  * Returns a file descriptor for the netlink connection associated with the
- * given queue connection handle.  The file descriptor can then be used for
+ * given queue connection handle. The file descriptor can then be used for
  * receiving the queued packets for processing.
  *
  * Example:
@@ -176,7 +176,7 @@ int nfq_fd(struct nfq_handle *h)
  *
  * This function obtains a netfilter queue connection handle. When you are
  * finished with the handle returned by this function, you should destroy
- * it by calling nfq_close().  A new netlink connection is obtained internally
+ * it by calling nfq_close(). A new netlink connection is obtained internally
  * and associated with the queue connection handle returned.
  *
  * This function returns a pointer to a new queue handle or NULL on failure.
@@ -244,7 +244,7 @@ out_free:
  * nfq_close - close a nfqueue handler
  * @h: Netfilter queue connection handle obtained via call to nfq_open()
  *
- * This function close the nfqueue handler and free associated resources.
+ * This function closes the nfqueue handler and free associated resources.
  *
  * This function returns 0 on success, non-zero on failure. 
  */
@@ -261,8 +261,8 @@ int nfq_close(struct nfq_handle *h)
 
 /**
  * nfq_bind_pf - bind a nfqueue handler to a given protocol family
- * h: Netfilter queue connection handle obtained via call to nfq_open()
- * pf: protocol family to bind to nfqueue handler obtained from nfq_open()
+ * @h: Netfilter queue connection handle obtained via call to nfq_open()
+ * @pf: protocol family to bind to nfqueue handler obtained from nfq_open()
  *
  * Binds the given queue connection handle to process packets belonging to 
  * the given protocol family (ie. PF_INET, PF_INET6, etc).
@@ -274,8 +274,8 @@ int nfq_bind_pf(struct nfq_handle *h, u_int16_t pf)
 
 /**
  * nfq_unbind_pf - unbind nfqueue handler from a protocol family
- * h: Netfilter queue connection handle obtained via call to nfq_open()
- * pf: protocol family to unbind family from
+ * @h: Netfilter queue connection handle obtained via call to nfq_open()
+ * @pf: protocol family to unbind family from
  *
  * Unbinds the given queue connection handle from processing packets belonging
  * to the given protocol family.
@@ -367,7 +367,7 @@ int nfq_destroy_queue(struct nfq_q_handle *qh)
  * @len: length of packet data in buffer
  *
  * Triggers an associated callback for the given packet received from the
- * queue.  Packets can be read from the queue using nfq_fd() and recv().  See
+ * queue. Packets can be read from the queue using nfq_fd() and recv(). See
  * example code for nfq_fd().
  *
  * Returns 0 on success, non-zero on failure.
@@ -379,7 +379,6 @@ int nfq_handle_packet(struct nfq_handle *h, char *buf, int len)
 
 /**
  * nfq_set_mode - set the amount of packet data that nfqueue copies to userspace
- *
  * @qh: Netfilter queue handle obtained by call to nfq_create_queue().
  * @mode: the part of the packet that we are interested in
  * @range: size of the packet that we want to get
@@ -413,8 +412,13 @@ int nfq_set_mode(struct nfq_q_handle *qh,
 }
 
 /**
- * nfq_set_queue_maxlen - 
+ * nfq_set_queue_maxlen - Set kernel queue maximum length parameter
+ * @qh: Netfilter queue handle obtained by call to nfq_create_queue().
+ * @queuelen: the length of the queue
  *
+ * Sets the size of the queue in kernel. This fixes the maximum number
+ * of packets the kernel will store before internally before dropping
+ * upcoming packets.
  */
 int nfq_set_queue_maxlen(struct nfq_q_handle *qh,
 				u_int32_t queuelen)
@@ -488,7 +492,6 @@ static int __set_verdict(struct nfq_q_handle *qh, u_int32_t id,
 
 /**
  * nfq_set_verdict - issue a verdict on a packet 
- *
  * @qh: Netfilter queue handle obtained by call to nfq_create_queue().
  * @id:	ID assigned to packet by netfilter.
  * @verdict: verdict to return to netfilter (NF_ACCEPT, NF_DROP)
@@ -516,6 +519,13 @@ int nfq_set_verdict(struct nfq_q_handle *qh, u_int32_t id,
 
 /**
  * nfq_set_verdict_mark - like nfq_set_verdict, but you can set the mark.
+ * @qh: Netfilter queue handle obtained by call to nfq_create_queue().
+ * @id:	ID assigned to packet by netfilter.
+ * @verdict: verdict to return to netfilter (NF_ACCEPT, NF_DROP)
+ * @mark: mark to put on packet
+ * @data_len: number of bytes of data pointed to by <buf>
+ * @buf: the buffer that contains the packet data
+ 
  */
 int nfq_set_verdict_mark(struct nfq_q_handle *qh, u_int32_t id,
 		u_int32_t verdict, u_int32_t mark,
@@ -530,6 +540,7 @@ int nfq_set_verdict_mark(struct nfq_q_handle *qh, u_int32_t id,
 
 /**
  * nfqnl_msg_packet_hdr - return the metaheader that wraps the packet
+ * @nfad: Netlink packet data handle passed to callback function
  *
  * Returns the netfilter queue netlink packet header for the given
  * nfq_data argument.  Typically, the nfq_data value is passed as the 3rd
@@ -551,7 +562,6 @@ struct nfqnl_msg_packet_hdr *nfq_get_msg_packet_hdr(struct nfq_data *nfad)
 
 /**
  * nfq_get_nfmark - get the packet mark
- *
  * @nfad: Netlink packet data handle passed to callback function
  *
  * Returns the netfilter mark currently assigned to the given queued packet.
@@ -563,7 +573,6 @@ uint32_t nfq_get_nfmark(struct nfq_data *nfad)
 
 /**
  * nfq_get_timestamp - get the packet timestamp
- *
  * @nfad: Netlink packet data handle passed to callback function
  * @tv: structure to fill with timestamp info
  *
@@ -642,6 +651,37 @@ u_int32_t nfq_get_physoutdev(struct nfq_data *nfad)
 	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_PHYSOUTDEV, u_int32_t));
 }
 
+/**
+ * nfq_get_indev_name - get the name of the interface the packet
+ * was received through
+ * @nlif_handle: pointer to a nlif interface resolving handle
+ * @nfad: Netlink packet data handle passed to callback function
+ * @name: pointer that will be set to the interface name string 
+ *
+ * The <name> variable will point to the name of the input interface.
+ *
+ * To use a nlif_handle, You need first to call nlif_open() and to open
+ * an handler. Don't forget to store the result as it will be used 
+ * during all your program life:
+ * 	h = nlif_open();
+ * 	if (h == NULL) {
+ * 		perror("nlif_open");
+ * 		exit(EXIT_FAILURE);
+ * 	}
+ * Once the handler is open, you need to fetch the interface table at a
+ * whole via a call to nlif_query.
+ * 	nlif_query(h);
+ * libnfnetlink is able to update the interface mapping when a new interface
+ * appears. To do so, you need to call nlif_catch() on the handler after each
+ * interface related event. The simplest way to get and treat event is to run
+ * a select() or poll() against the nlif file descriptor. To get this file 
+ * descriptor, you need to use nlif_fd:
+ * 	if_fd = nlif_fd(h);
+ * Don't forget to close the handler when you don't need the feature anymore:
+ * 	nlif_close(h);
+ *
+ * Return -1 in case of error, >0 if it succeed. 
+ */
 int nfq_get_indev_name(struct nlif_handle *nlif_handle,
 			struct nfq_data *nfad, char *name)
 {
@@ -649,6 +689,20 @@ int nfq_get_indev_name(struct nlif_handle *nlif_handle,
 	return nlif_index2name(nlif_handle, ifindex, name);
 }
 
+/**
+ * nfq_get_physindev_name - get the name of the physical interface the
+ * packet was received through
+ * @nlif_handle: pointer to a nlif interface resolving handle
+ * @nfad: Netlink packet data handle passed to callback function
+ * @name: pointer that will be set to the interface name string 
+ *
+ * The <name> variable will point to the name of the input physical
+ * interface.
+ *
+ * See nfq_get_indev_name() documentation for nlif_handle usage.
+ *
+ * Return -1 in case of error, >0 if it succeed. 
+ */
 int nfq_get_physindev_name(struct nlif_handle *nlif_handle,
 			   struct nfq_data *nfad, char *name)
 {
@@ -656,6 +710,19 @@ int nfq_get_physindev_name(struct nlif_handle *nlif_handle,
 	return nlif_index2name(nlif_handle, ifindex, name);
 }
 
+/**
+ * nfq_get_outdev_name - get the name of the physical interface the
+ * packet will be sent to
+ * @nlif_handle: pointer to a nlif interface resolving handle
+ * @nfad: Netlink packet data handle passed to callback function
+ * @name: pointer that will be set to the interface name string 
+ *
+ * The <name> variable will point to the name of the output interface.
+ *
+ * See nfq_get_indev_name() documentation for nlif_handle usage.
+ *
+ * Return -1 in case of error, >0 if it succeed. 
+ */
 int nfq_get_outdev_name(struct nlif_handle *nlif_handle,
 			struct nfq_data *nfad, char *name)
 {
@@ -663,6 +730,21 @@ int nfq_get_outdev_name(struct nlif_handle *nlif_handle,
 	return nlif_index2name(nlif_handle, ifindex, name);
 }
 
+/**
+ * nfq_get_physoutdev_name - get the name of the interface the
+ * packet will be sent to
+ * @nlif_handle: pointer to a nlif interface resolving handle
+ * @nfad: Netlink packet data handle passed to callback function
+ * @name: pointer that will be set to the interface name string 
+ *
+ * The <name> variable will point to the name of the physical
+ * output interface.
+ *
+ * See nfq_get_indev_name() documentation for nlif_handle usage.
+ *
+ * Return -1 in case of error, >0 if it succeed. 
+ */
+
 int nfq_get_physoutdev_name(struct nlif_handle *nlif_handle,
 			    struct nfq_data *nfad, char *name)
 {
@@ -697,6 +779,7 @@ struct nfqnl_msg_packet_hw *nfq_get_packet_hw(struct nfq_data *nfad)
 /**
  * nfq_get_payload - get payload 
  * @nfad: Netlink packet data handle passed to callback function
+ * @data: Pointer of pointer that will be pointed to the payload
  *
  * Retrieve the payload for a queued packet. The actual amount and type of
  * data retrieved by this function will depend on the mode set with the
-- 
1.5.6.5

