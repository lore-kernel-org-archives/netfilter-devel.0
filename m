From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] libnetfilter_queue documentation
Date: Thu, 23 Oct 2008 19:24:10 +0200
Message-ID: <4900B33A.5000907@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020005060600040503050106"
Cc: Eric Leblond <eric@inl.fr>, brad@info-link.net
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54795 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752124AbYJWRYU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Oct 2008 13:24:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020005060600040503050106
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

This patch adds the documentation that Brad Fisher <brad@info-link.net>
made time ago, you can get the original post from:

http://lists.netfilter.org/pipermail/netfilter-devel/2006-February/023286.html

This patch contains documentation that I did not have time to review in
deep yet. However, several developers has refered to this documentation
as a good kick-off to start developing applications for libnetfilter_queue.

I have push it to git. If you want to contribute it, just send a patch
on top of it. Thanks!

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------020005060600040503050106
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index d319b7b..7d0b92f 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -146,11 +146,41 @@ struct nfnl_handle *nfq_nfnlh(struct nfq_handle *h)
 	return h->nfnlh;
 }
 
+/**
+ * nfq_fd - get the file descriptor associated with the nfqueue handler
+ * h: Netfilter queue connection handle obtained via call to nfq_open()
+ *
+ * Returns a file descriptor for the netlink connection associated with the
+ * given queue connection handle.  The file descriptor can then be used for
+ * receiving the queued packets for processing.
+ *
+ * Example:
+ *
+ *	fd = nfq_fd(h);
+ *	while ((rv = recv(fd, buf, sizeof(buf), 0)) && rv >= 0) {
+ * 		printf("pkt received\n");
+ * 		nfq_handle_packet(h, buf, rv);
+ * 	}
+ *
+ * This function returns a file descriptor that can be used for communication
+ * over the netlink connection associated with the given queue connection
+ * handle.
+ */
 int nfq_fd(struct nfq_handle *h)
 {
 	return nfnl_fd(nfq_nfnlh(h));
 }
 
+/**
+ * nfq_open - open a nfqueue handler
+ *
+ * This function obtains a netfilter queue connection handle. When you are
+ * finished with the handle returned by this function, you should destroy
+ * it by calling nfq_close().  A new netlink connection is obtained internally
+ * and associated with the queue connection handle returned.
+ *
+ * This function returns a pointer to a new queue handle or NULL on failure.
+ */
 struct nfq_handle *nfq_open(void)
 {
 	struct nfnl_handle *nfnlh = nfnl_open();
@@ -166,6 +196,16 @@ struct nfq_handle *nfq_open(void)
 	return qh;
 }
 
+/**
+ * nfq_open_nfnl - open a nfqueue handler from a existing nfnetlink handler
+ * @nfnlh: Netfilter netlink connection handle obtained by calling nfnl_open()
+ *
+ * This function obtains a netfilter queue connection handle using an existing
+ * netlink connection. This function is used internally to implement 
+ * nfq_open(), and should typically not be called directly.
+ *
+ * This function returns a pointer to a new queue handle or NULL on failure.
+ */			
 struct nfq_handle *nfq_open_nfnl(struct nfnl_handle *nfnlh)
 {
 	struct nfq_handle *h;
@@ -200,6 +240,14 @@ out_free:
 	return NULL;
 }
 
+/**
+ * nfq_close - close a nfqueue handler
+ * @h: Netfilter queue connection handle obtained via call to nfq_open()
+ *
+ * This function close the nfqueue handler and free associated resources.
+ *
+ * This function returns 0 on success, non-zero on failure. 
+ */
 int nfq_close(struct nfq_handle *h)
 {
 	int ret;
@@ -211,19 +259,59 @@ int nfq_close(struct nfq_handle *h)
 	return ret;
 }
 
-/* bind nf_queue from a specific protocol family */
+/**
+ * nfq_bind_pf - bind a nfqueue handler to a given protocol family
+ * h: Netfilter queue connection handle obtained via call to nfq_open()
+ * pf: protocol family to bind to nfqueue handler obtained from nfq_open()
+ *
+ * Binds the given queue connection handle to process packets belonging to 
+ * the given protocol family (ie. PF_INET, PF_INET6, etc).
+ */
 int nfq_bind_pf(struct nfq_handle *h, u_int16_t pf)
 {
 	return __build_send_cfg_msg(h, NFQNL_CFG_CMD_PF_BIND, 0, pf);
 }
 
-/* unbind nf_queue from a specific protocol family */
+/**
+ * nfq_unbind_pf - unbind nfqueue handler from a protocol family
+ * h: Netfilter queue connection handle obtained via call to nfq_open()
+ * pf: protocol family to unbind family from
+ *
+ * Unbinds the given queue connection handle from processing packets belonging
+ * to the given protocol family.
+ */
 int nfq_unbind_pf(struct nfq_handle *h, u_int16_t pf)
 {
 	return __build_send_cfg_msg(h, NFQNL_CFG_CMD_PF_UNBIND, 0, pf);
 }
 
-/* bind this socket to a specific queue number */
+/**
+ * nfq_create_queue - create a new queue handle and return it.
+ * @h: Netfilter queue connection handle obtained via call to nfq_open()
+ * @num: the number of the queue to bind to
+ * @cb: callback function to call for each queued packet
+ * @data: custom data to pass to the callback function
+ *
+ * Creates a new queue handle, and returns it.  The new queue is identified by
+ * <num>, and the callback specified by <cb> will be called for each enqueued
+ * packet.  The <data> argument will be passed unchanged to the callback.  If
+ * a queue entry with id <num> already exists, this function will return failure
+ * and the existing entry is unchanged.
+ *
+ * The nfq_callback type is defined in libnetfilter_queue.h as:
+ *
+ * typedef int nfq_callback(struct nfq_q_handle *qh,
+ * 			    struct nfgenmsg *nfmsg,
+ * 			    struct nfq_data *nfad, void *data);
+ *
+ * Parameters:
+ * @qh: The queue handle returned by nfq_create_queue
+ * @nfmsg: message objetc that contains the packet
+ * @nfq_data: Netlink packet data handle
+ * @data: the value passed to the data parameter of nfq_create_queue
+ *
+ * The callback should return < 0 to stop processing.
+ */
 struct nfq_q_handle *nfq_create_queue(struct nfq_handle *h, 
 		u_int16_t num,
 		nfq_callback *cb,
@@ -254,7 +342,13 @@ struct nfq_q_handle *nfq_create_queue(struct nfq_handle *h,
 	return qh;
 }
 
-/* unbind this socket from a specific queue number */
+/**
+ * nfq_destroy_queue - destroy a queue handle
+ * @qh: queue handle that we want to destroy created via nfq_create_queue
+ *
+ * Removes the binding for the specified queue handle. This call also unbind
+ * from the nfqueue handler, so you don't have to call nfq_unbind_pf.
+ */
 int nfq_destroy_queue(struct nfq_q_handle *qh)
 {
 	int ret = __build_send_cfg_msg(qh->h, NFQNL_CFG_CMD_UNBIND, qh->id, 0);
@@ -266,11 +360,37 @@ int nfq_destroy_queue(struct nfq_q_handle *qh)
 	return ret;
 }
 
+/**
+ * nfq_handle_packet - handle a packet received from the nfqueue subsystem
+ * @h: Netfilter queue connection handle obtained via call to nfq_open()
+ * @buf: data to pass to the callback
+ * @len: length of packet data in buffer
+ *
+ * Triggers an associated callback for the given packet received from the
+ * queue.  Packets can be read from the queue using nfq_fd() and recv().  See
+ * example code for nfq_fd().
+ *
+ * Returns 0 on success, non-zero on failure.
+ */
 int nfq_handle_packet(struct nfq_handle *h, char *buf, int len)
 {
 	return nfnl_handle_packet(h->nfnlh, buf, len);
 }
 
+/**
+ * nfq_set_mode - set the amount of packet data that nfqueue copies to userspace
+ *
+ * @qh: Netfilter queue handle obtained by call to nfq_create_queue().
+ * @mode: the part of the packet that we are interested in
+ * @range: size of the packet that we want to get
+ *
+ * Sets the amount of data to be copied to userspace for each packet queued
+ * to the given queue.
+ *
+ * - NFQNL_COPY_NONE - do not copy any data
+ * - NFQNL_COPY_META - copy only packet metadata
+ * - NFQNL_COPY_PACKET - copy entire packet
+ */
 int nfq_set_mode(struct nfq_q_handle *qh,
 		u_int8_t mode, u_int32_t range)
 {
@@ -292,6 +412,10 @@ int nfq_set_mode(struct nfq_q_handle *qh,
 	return nfnl_talk(qh->h->nfnlh, &u.nmh, 0, 0, NULL, NULL, NULL);
 }
 
+/**
+ * nfq_set_queue_maxlen - 
+ *
+ */
 int nfq_set_queue_maxlen(struct nfq_q_handle *qh,
 				u_int32_t queuelen)
 {
@@ -362,6 +486,27 @@ static int __set_verdict(struct nfq_q_handle *qh, u_int32_t id,
 	return nfnl_sendiov(qh->h->nfnlh, iov, nvecs, 0);
 }
 
+/**
+ * nfq_set_verdict - issue a verdict on a packet 
+ *
+ * @qh: Netfilter queue handle obtained by call to nfq_create_queue().
+ * @id:	ID assigned to packet by netfilter.
+ * @verdict: verdict to return to netfilter (NF_ACCEPT, NF_DROP)
+ * @data_len: number of bytes of data pointed to by <buf>
+ * @buf: the buffer that contains the packet data
+ *
+ * Can be obtained by: 
+ * 
+ * int id;
+ * struct nfqnl_msg_packet_hdr *ph = nfq_get_msg_packet_hdr(tb);
+ *
+ * if (ph)
+ * 	id = ntohl(ph->packet_id);
+ *
+ * Notifies netfilter of the userspace verdict for the given packet.  Every
+ * queued packet _must_ have a verdict specified by userspace, either by
+ * calling this function, or by calling the nfq_set_verdict_mark() function.
+ */
 int nfq_set_verdict(struct nfq_q_handle *qh, u_int32_t id,
 		u_int32_t verdict, u_int32_t data_len, 
 		unsigned char *buf)
@@ -369,6 +514,9 @@ int nfq_set_verdict(struct nfq_q_handle *qh, u_int32_t id,
 	return __set_verdict(qh, id, verdict, 0, 0, data_len, buf);
 }	
 
+/**
+ * nfq_set_verdict_mark - like nfq_set_verdict, but you can set the mark.
+ */
 int nfq_set_verdict_mark(struct nfq_q_handle *qh, u_int32_t id,
 		u_int32_t verdict, u_int32_t mark,
 		u_int32_t datalen, unsigned char *buf)
@@ -380,17 +528,49 @@ int nfq_set_verdict_mark(struct nfq_q_handle *qh, u_int32_t id,
  * Message parsing functions 
  *************************************************************/
 
+/**
+ * nfqnl_msg_packet_hdr - return the metaheader that wraps the packet
+ *
+ * Returns the netfilter queue netlink packet header for the given
+ * nfq_data argument.  Typically, the nfq_data value is passed as the 3rd
+ * parameter to the callback function set by a call to nfq_create_queue().
+ *
+ * The nfqnl_msg_packet_hdr structure is defined in libnetfilter_queue.h as:
+ *
+ * struct nfqnl_msg_packet_hdr {
+ * 	u_int32_t	packet_id;	// unique ID of packet in queue
+ * 	u_int16_t	hw_protocol;	// hw protocol (network order)
+ * 	u_int8_t	hook;		// netfilter hook
+ * } __attribute__ ((packed));
+ */
 struct nfqnl_msg_packet_hdr *nfq_get_msg_packet_hdr(struct nfq_data *nfad)
 {
 	return nfnl_get_pointer_to_data(nfad->data, NFQA_PACKET_HDR,
 					struct nfqnl_msg_packet_hdr);
 }
 
+/**
+ * nfq_get_nfmark - get the packet mark
+ *
+ * @nfad: Netlink packet data handle passed to callback function
+ *
+ * Returns the netfilter mark currently assigned to the given queued packet.
+ */
 uint32_t nfq_get_nfmark(struct nfq_data *nfad)
 {
 	return ntohl(nfnl_get_data(nfad->data, NFQA_MARK, u_int32_t));
 }
 
+/**
+ * nfq_get_timestamp - get the packet timestamp
+ *
+ * @nfad: Netlink packet data handle passed to callback function
+ * @tv: structure to fill with timestamp info
+ *
+ * Retrieves the received timestamp when the given queued packet.
+ *
+ * Returns 0 on success, non-zero on failure.
+ */
 int nfq_get_timestamp(struct nfq_data *nfad, struct timeval *tv)
 {
 	struct nfqnl_msg_packet_timestamp *qpt;
@@ -405,23 +585,58 @@ int nfq_get_timestamp(struct nfq_data *nfad, struct timeval *tv)
 	return 0;
 }
 
-/* all nfq_get_*dev() functions return 0 if not set, since linux only allows
- * ifindex >= 1, see net/core/dev.c:2600  (in 2.6.13.1) */
+/**
+ * nfq_get_indev - get the interface that the packet was received through
+ * @nfad: Netlink packet data handle passed to callback function
+ *
+ * The index of the device the queued packet was received via.  If the
+ * returned index is 0, the packet was locally generated or the input
+ * interface is not known (ie. POSTROUTING?).
+ *
+ * WARNING: all nfq_get_dev() functions return 0 if not set, since linux
+ * only allows ifindex >= 1, see net/core/dev.c:2600  (in 2.6.13.1)
+ */
 u_int32_t nfq_get_indev(struct nfq_data *nfad)
 {
 	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_INDEV, u_int32_t));
 }
 
+/**
+ * nfq_get_physindev - get the physical interface that the packet was received
+ * @nfad: Netlink packet data handle passed to callback function
+ *
+ * The index of the physical device the queued packet was received via.
+ * If the returned index is 0, the packet was locally generated or the
+ * physical input interface is no longer known (ie. POSTROUTING?).
+ */
 u_int32_t nfq_get_physindev(struct nfq_data *nfad)
 {
 	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_PHYSINDEV, u_int32_t));
 }
 
+/**
+ * nfq_get_outdev - gets the interface that the packet will be routed out
+ * @nfad: Netlink packet data handle passed to callback function
+ *
+ * The index of the device the queued packet will be sent out.  If the
+ * returned index is 0, the packet is destined for localhost or the output
+ * interface is not yet known (ie. PREROUTING?).
+ */
 u_int32_t nfq_get_outdev(struct nfq_data *nfad)
 {
 	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_OUTDEV, u_int32_t));
 }
 
+/**
+ * nfq_get_physoutdev - get the physical interface that the packet output
+ * @nfad: Netlink packet data handle passed to callback function
+ *
+ * The index of the physical device the queued packet will be sent out.
+ * If the returned index is 0, the packet is destined for localhost or the
+ * physical output interface is not yet known (ie. PREROUTING?).
+ * 
+ * Retrieves the physical interface that the packet output will be routed out.
+ */
 u_int32_t nfq_get_physoutdev(struct nfq_data *nfad)
 {
 	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_PHYSOUTDEV, u_int32_t));
@@ -455,12 +670,40 @@ int nfq_get_physoutdev_name(struct nlif_handle *nlif_handle,
 	return nlif_index2name(nlif_handle, ifindex, name);
 }
 
+/**
+ * nfq_get_packet_hw - get hardware address 
+ * @nfad: Netlink packet data handle passed to callback function
+ *
+ * Retrieves the hardware address associated with the given queued packet.
+ * For ethernet packets, the hardware address returned (if any) will be the
+ * MAC address of the packet source host.  The destination MAC address is not
+ * known until after POSTROUTING and a successful ARP request, so cannot
+ * currently be retrieved.
+ *
+ * The nfqnl_msg_packet_hw structure is defined in libnetfilter_queue.h as:
+ *
+ * struct nfqnl_msg_packet_hw {
+ * 	u_int16_t	hw_addrlen;
+ * 	u_int16_t	_pad;
+ * 	u_int8_t	hw_addr[8];
+ * } __attribute__ ((packed));
+ */
 struct nfqnl_msg_packet_hw *nfq_get_packet_hw(struct nfq_data *nfad)
 {
 	return nfnl_get_pointer_to_data(nfad->data, NFQA_HWADDR,
 					struct nfqnl_msg_packet_hw);
 }
 
+/**
+ * nfq_get_payload - get payload 
+ * @nfad: Netlink packet data handle passed to callback function
+ *
+ * Retrieve the payload for a queued packet. The actual amount and type of
+ * data retrieved by this function will depend on the mode set with the
+ * nfq_set_mode() function.
+ *
+ * Returns -1 on error, otherwise > 0.
+ */
 int nfq_get_payload(struct nfq_data *nfad, char **data)
 {
 	*data = nfnl_get_pointer_to_data(nfad->data, NFQA_PAYLOAD, char);

--------------020005060600040503050106--
