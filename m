From: Eric Leblond <eric@inl.fr>
Subject: [libnetfilter_queue 4/4] Switch documentation style to doxygen.
Date: Fri, 19 Dec 2008 22:36:31 +0100
Message-ID: <1229722591-7836-5-git-send-email-eric@inl.fr>
References: <1229722591-7836-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:57389 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751623AbYLSVgf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:36:35 -0500
In-Reply-To: <1229722591-7836-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch modifies the documentation format to switch to doxygen
format. This leads to a interesting and useful output. An example
can be found at the following url:
	http://www.nufw.org/doc/libnetfilter_queue/

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 src/libnetfilter_queue.c |  432 ++++++++++++++++++++++++++++++++-------------
 1 files changed, 307 insertions(+), 125 deletions(-)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index f5611dd..9e4903b 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -32,6 +32,36 @@
 #include <libnfnetlink/libnfnetlink.h>
 #include <libnetfilter_queue/libnetfilter_queue.h>
 
+/**
+ * \mainpage
+ *
+ * libnetfilter_queue is a userspace library providing an API to packets that
+ * have been queued by the kernel packet filter. It is is part of a system that
+ * deprecates the old ip_queue / libipq mechanism.
+ *
+ * libnetfilter_queue homepage is:
+ * 	http://netfilter.org/projects/libnetfilter_queue/
+ *
+ * \section Dependencies
+ * libnetfilter_queue requires libnfnetlink and a kernel that includes the
+ * nfnetlink_queue subsystem (i.e. 2.6.14 or later).
+ *
+ * \section Main Features
+ *  - receiving queued packets from the kernel nfnetlink_queue subsystem
+ *  - issuing verdicts and/or reinjecting altered packets to the kernel
+ *  nfnetlink_queue subsystem
+ * 
+ * \section Git Tree
+ * The current development version of libnetfilter_queue can be accessed
+ * at https://git.netfilter.org/cgi-bin/gitweb.cgi?p=libnetfilter_queue.git;a=summary.
+ *
+ * \section Using libnetfilter_queue
+ * 
+ * To write your own program using libnetfilter_queue, you should start by reading
+ * the doxygen documentation (start by \link LibrarySetup \endlink page) and nfqnl_test.c source file.
+ * 
+ */
+
 struct nfq_handle
 {
 	struct nfnl_handle *nfnlh;
@@ -147,22 +177,58 @@ struct nfnl_handle *nfq_nfnlh(struct nfq_handle *h)
 }
 
 /**
+ *
+ * \defgroup Queue Queue handling
+ *
+ * Once libnetfilter_queue library has been initialised (See 
+ * \link LibrarySetup \endlink), it is possible to bind the program to a
+ * specific queue. This can be done by using nfq_create_queue().
+ *
+ * The queue can then be tuned via nfq_set_mode() or nfq_set_queue_maxlen().
+ * 
+ * Here's a little code snippet that create queue numbered 0:
+ * \verbatim
+	printf("binding this socket to queue '0'\n");
+	qh = nfq_create_queue(h,  0, &cb, NULL);
+	if (!qh) {
+		fprintf(stderr, "error during nfq_create_queue()\n");
+		exit(1);
+	}
+
+	printf("setting copy_packet mode\n");
+	if (nfq_set_mode(qh, NFQNL_COPY_PACKET, 0xffff) < 0) {
+		fprintf(stderr, "can't set packet_copy mode\n");
+		exit(1);
+	}
+\endverbatim
+ *
+ * Next step is the handling of incoming packets which can be done via a loop:
+ *
+ * \verbatim
+	fd = nfq_fd(h);
+
+	while ((rv = recv(fd, buf, sizeof(buf), 0)) && rv >= 0) {
+		printf("pkt received\n");
+		nfq_handle_packet(h, buf, rv);
+	}
+\endverbatim
+ * When the decision on a packet has been choosed, the verdict has to be given
+ * by calling nfq_set_verdict() or nfq_set_verdict_mark().
+ *
+ * Data and information about the packet can be fetch by using message parsing
+ * functions (See \link Parsing \endlink).
+ * @{
+ */
+
+/**
  * nfq_fd - get the file descriptor associated with the nfqueue handler
- * @h: Netfilter queue connection handle obtained via call to nfq_open()
+ * \param h Netfilter queue connection handle obtained via call to nfq_open()
  *
- * Returns a file descriptor for the netlink connection associated with the
+ * \return a file descriptor for the netlink connection associated with the
  * given queue connection handle. The file descriptor can then be used for
  * receiving the queued packets for processing.
  *
- * Example:
- *
- *	fd = nfq_fd(h);
- *	while ((rv = recv(fd, buf, sizeof(buf), 0)) && rv >= 0) {
- * 		printf("pkt received\n");
- * 		nfq_handle_packet(h, buf, rv);
- * 	}
- *
- * This function returns a file descriptor that can be used for communication
+  * This function returns a file descriptor that can be used for communication
  * over the netlink connection associated with the given queue connection
  * handle.
  */
@@ -172,6 +238,46 @@ int nfq_fd(struct nfq_handle *h)
 }
 
 /**
+ * @}
+ */
+
+/**
+ * \defgroup LibrarySetup Library setup
+ *
+ * Library initialisation is made in two steps.
+ *
+ * First step is to call nfq_open() to open a NFQUEUE handler. 
+ *
+ * Second step is to tell the kernel that userspace queueing is handle by
+ * NFQUEUE for the selected protocol. This is made by calling nfq_unbind_pf()
+ * and nfq_bind_pf() with protocol information. The idea behind this is to
+ * enable simultaneously loaded modules to be used for queuing.
+ *
+ * Here's a little code snippet that bind with AF_INET:
+ * \verbatim
+	h = nfq_open();
+	if (!h) {
+		fprintf(stderr, "error during nfq_open()\n");
+		exit(1);
+	}
+
+	printf("unbinding existing nf_queue handler for AF_INET (if any)\n");
+	if (nfq_unbind_pf(h, AF_INET) < 0) {
+		fprintf(stderr, "error during nfq_unbind_pf()\n");
+		exit(1);
+	}
+
+	printf("binding nfnetlink_queue as nf_queue handler for AF_INET\n");
+	if (nfq_bind_pf(h, AF_INET) < 0) {
+		fprintf(stderr, "error during nfq_bind_pf()\n");
+		exit(1);
+	}
+\endverbatim
+ * Once this is done, you can setup and use a \link Queue \endlink.
+ * @{
+ */
+
+/**
  * nfq_open - open a nfqueue handler
  *
  * This function obtains a netfilter queue connection handle. When you are
@@ -179,7 +285,7 @@ int nfq_fd(struct nfq_handle *h)
  * it by calling nfq_close(). A new netlink connection is obtained internally
  * and associated with the queue connection handle returned.
  *
- * This function returns a pointer to a new queue handle or NULL on failure.
+ * \return a pointer to a new queue handle or NULL on failure.
  */
 struct nfq_handle *nfq_open(void)
 {
@@ -197,15 +303,19 @@ struct nfq_handle *nfq_open(void)
 }
 
 /**
+ * @}
+ */
+
+/**
  * nfq_open_nfnl - open a nfqueue handler from a existing nfnetlink handler
- * @nfnlh: Netfilter netlink connection handle obtained by calling nfnl_open()
+ * \param nfnlh Netfilter netlink connection handle obtained by calling nfnl_open()
  *
  * This function obtains a netfilter queue connection handle using an existing
  * netlink connection. This function is used internally to implement 
  * nfq_open(), and should typically not be called directly.
  *
- * This function returns a pointer to a new queue handle or NULL on failure.
- */			
+ * \return a pointer to a new queue handle or NULL on failure.
+ */
 struct nfq_handle *nfq_open_nfnl(struct nfnl_handle *nfnlh)
 {
 	struct nfq_handle *h;
@@ -241,12 +351,21 @@ out_free:
 }
 
 /**
+ * \addtogroup LibrarySetup
+ *
+ * When the program has finished with libnetfilter_queue, it has to call
+ * the nfq_close() function to free all associated resources.
+ *
+ * @{
+ */
+
+/**
  * nfq_close - close a nfqueue handler
- * @h: Netfilter queue connection handle obtained via call to nfq_open()
+ * \param h Netfilter queue connection handle obtained via call to nfq_open()
  *
  * This function closes the nfqueue handler and free associated resources.
  *
- * This function returns 0 on success, non-zero on failure. 
+ * \return 0 on success, non-zero on failure. 
  */
 int nfq_close(struct nfq_handle *h)
 {
@@ -260,11 +379,13 @@ int nfq_close(struct nfq_handle *h)
 
 /**
  * nfq_bind_pf - bind a nfqueue handler to a given protocol family
- * @h: Netfilter queue connection handle obtained via call to nfq_open()
- * @pf: protocol family to bind to nfqueue handler obtained from nfq_open()
+ * \param h Netfilter queue connection handle obtained via call to nfq_open()
+ * \param pf protocol family to bind to nfqueue handler obtained from nfq_open()
  *
  * Binds the given queue connection handle to process packets belonging to 
  * the given protocol family (ie. PF_INET, PF_INET6, etc).
+ *
+ * \return integer inferior to 0 in case of failure
  */
 int nfq_bind_pf(struct nfq_handle *h, u_int16_t pf)
 {
@@ -273,8 +394,8 @@ int nfq_bind_pf(struct nfq_handle *h, u_int16_t pf)
 
 /**
  * nfq_unbind_pf - unbind nfqueue handler from a protocol family
- * @h: Netfilter queue connection handle obtained via call to nfq_open()
- * @pf: protocol family to unbind family from
+ * \param h Netfilter queue connection handle obtained via call to nfq_open()
+ * \param pf protocol family to unbind family from
  *
  * Unbinds the given queue connection handle from processing packets belonging
  * to the given protocol family.
@@ -284,33 +405,49 @@ int nfq_unbind_pf(struct nfq_handle *h, u_int16_t pf)
 	return __build_send_cfg_msg(h, NFQNL_CFG_CMD_PF_UNBIND, 0, pf);
 }
 
+
+
+/**
+ * @}
+ */
+
+/**
+ * \addtogroup Queue
+ * @{
+ */
+
 /**
  * nfq_create_queue - create a new queue handle and return it.
- * @h: Netfilter queue connection handle obtained via call to nfq_open()
- * @num: the number of the queue to bind to
- * @cb: callback function to call for each queued packet
- * @data: custom data to pass to the callback function
+ *
+ * \param h Netfilter queue connection handle obtained via call to nfq_open()
+ * \param num the number of the queue to bind to
+ * \param cb callback function to call for each queued packet
+ * \param data custom data to pass to the callback function
+ *
+ * \return a nfq_q_handle pointing to the newly created queue
  *
  * Creates a new queue handle, and returns it.  The new queue is identified by
- * <num>, and the callback specified by <cb> will be called for each enqueued
- * packet.  The <data> argument will be passed unchanged to the callback.  If
- * a queue entry with id <num> already exists, this function will return failure
+ * #num, and the callback specified by #cb will be called for each enqueued
+ * packet.  The #data argument will be passed unchanged to the callback.  If
+ * a queue entry with id #num already exists, this function will return failure
  * and the existing entry is unchanged.
  *
  * The nfq_callback type is defined in libnetfilter_queue.h as:
- *
- * typedef int nfq_callback(struct nfq_q_handle *qh,
- * 			    struct nfgenmsg *nfmsg,
- * 			    struct nfq_data *nfad, void *data);
+ * \verbatim
+typedef int nfq_callback(struct nfq_q_handle *qh,
+		    	 struct nfgenmsg *nfmsg,
+			 struct nfq_data *nfad, void *data);
+\endverbatim
  *
  * Parameters:
- * @qh: The queue handle returned by nfq_create_queue
- * @nfmsg: message objetc that contains the packet
- * @nfq_data: Netlink packet data handle
- * @data: the value passed to the data parameter of nfq_create_queue
+ *  - qh The queue handle returned by nfq_create_queue
+ *  - nfmsg message objetc that contains the packet
+ *  - nfad Netlink packet data handle
+ *  - data the value passed to the data parameter of nfq_create_queue
  *
  * The callback should return < 0 to stop processing.
  */
+
 struct nfq_q_handle *nfq_create_queue(struct nfq_handle *h, 
 		u_int16_t num,
 		nfq_callback *cb,
@@ -342,8 +479,17 @@ struct nfq_q_handle *nfq_create_queue(struct nfq_handle *h,
 }
 
 /**
+ * @}
+ */
+
+/**
+ * \addtogroup Queue
+ * @{
+ */
+
+/**
  * nfq_destroy_queue - destroy a queue handle
- * @qh: queue handle that we want to destroy created via nfq_create_queue
+ * \param qh queue handle that we want to destroy created via nfq_create_queue
  *
  * Removes the binding for the specified queue handle. This call also unbind
  * from the nfqueue handler, so you don't have to call nfq_unbind_pf.
@@ -361,15 +507,15 @@ int nfq_destroy_queue(struct nfq_q_handle *qh)
 
 /**
  * nfq_handle_packet - handle a packet received from the nfqueue subsystem
- * @h: Netfilter queue connection handle obtained via call to nfq_open()
- * @buf: data to pass to the callback
- * @len: length of packet data in buffer
+ * \param h Netfilter queue connection handle obtained via call to nfq_open()
+ * \param buf data to pass to the callback
+ * \param len length of packet data in buffer
  *
  * Triggers an associated callback for the given packet received from the
  * queue. Packets can be read from the queue using nfq_fd() and recv(). See
  * example code for nfq_fd().
  *
- * Returns 0 on success, non-zero on failure.
+ * \return 0 on success, non-zero on failure.
  */
 int nfq_handle_packet(struct nfq_handle *h, char *buf, int len)
 {
@@ -378,9 +524,9 @@ int nfq_handle_packet(struct nfq_handle *h, char *buf, int len)
 
 /**
  * nfq_set_mode - set the amount of packet data that nfqueue copies to userspace
- * @qh: Netfilter queue handle obtained by call to nfq_create_queue().
- * @mode: the part of the packet that we are interested in
- * @range: size of the packet that we want to get
+ * \param qh Netfilter queue handle obtained by call to nfq_create_queue().
+ * \param mode the part of the packet that we are interested in
+ * \param range size of the packet that we want to get
  *
  * Sets the amount of data to be copied to userspace for each packet queued
  * to the given queue.
@@ -412,8 +558,8 @@ int nfq_set_mode(struct nfq_q_handle *qh,
 
 /**
  * nfq_set_queue_maxlen - Set kernel queue maximum length parameter
- * @qh: Netfilter queue handle obtained by call to nfq_create_queue().
- * @queuelen: the length of the queue
+ * \param qh Netfilter queue handle obtained by call to nfq_create_queue().
+ * \param queuelen the length of the queue
  *
  * Sets the size of the queue in kernel. This fixes the maximum number
  * of packets the kernel will store before internally before dropping
@@ -438,6 +584,10 @@ int nfq_set_queue_maxlen(struct nfq_q_handle *qh,
 	return nfnl_talk(qh->h->nfnlh, &u.nmh, 0, 0, NULL, NULL, NULL);
 }
 
+/**
+ * @}
+ */
+
 static int __set_verdict(struct nfq_q_handle *qh, u_int32_t id,
 		u_int32_t verdict, u_int32_t mark, int set_mark,
 		u_int32_t data_len, unsigned char *data)
@@ -490,20 +640,25 @@ static int __set_verdict(struct nfq_q_handle *qh, u_int32_t id,
 }
 
 /**
+ * \addtogroup Queue
+ * @{
+ */
+
+/**
  * nfq_set_verdict - issue a verdict on a packet 
- * @qh: Netfilter queue handle obtained by call to nfq_create_queue().
- * @id:	ID assigned to packet by netfilter.
- * @verdict: verdict to return to netfilter (NF_ACCEPT, NF_DROP)
- * @data_len: number of bytes of data pointed to by <buf>
- * @buf: the buffer that contains the packet data
+ * \param qh Netfilter queue handle obtained by call to nfq_create_queue().
+ * \param id	ID assigned to packet by netfilter.
+ * \param verdict verdict to return to netfilter (NF_ACCEPT, NF_DROP)
+ * \param data_len number of bytes of data pointed to by #buf
+ * \param buf the buffer that contains the packet data
  *
  * Can be obtained by: 
- * 
- * int id;
- * struct nfqnl_msg_packet_hdr *ph = nfq_get_msg_packet_hdr(tb);
- *
- * if (ph)
- * 	id = ntohl(ph->packet_id);
+ * \verbatim
+	int id;
+	struct nfqnl_msg_packet_hdr *ph = nfq_get_msg_packet_hdr(tb);
+	if (ph)
+ 		id = ntohl(ph->packet_id);
+\endverbatim
  *
  * Notifies netfilter of the userspace verdict for the given packet.  Every
  * queued packet _must_ have a verdict specified by userspace, either by
@@ -518,13 +673,12 @@ int nfq_set_verdict(struct nfq_q_handle *qh, u_int32_t id,
 
 /**
  * nfq_set_verdict_mark - like nfq_set_verdict, but you can set the mark.
- * @qh: Netfilter queue handle obtained by call to nfq_create_queue().
- * @id:	ID assigned to packet by netfilter.
- * @verdict: verdict to return to netfilter (NF_ACCEPT, NF_DROP)
- * @mark: mark to put on packet
- * @data_len: number of bytes of data pointed to by <buf>
- * @buf: the buffer that contains the packet data
- 
+ * \param qh Netfilter queue handle obtained by call to nfq_create_queue().
+ * \param id	ID assigned to packet by netfilter.
+ * \param verdict verdict to return to netfilter (NF_ACCEPT, NF_DROP)
+ * \param mark mark to put on packet
+ * \param data_len number of bytes of data pointed to by #buf
+ * \param buf the buffer that contains the packet data
  */
 int nfq_set_verdict_mark(struct nfq_q_handle *qh, u_int32_t id,
 		u_int32_t verdict, u_int32_t mark,
@@ -533,25 +687,38 @@ int nfq_set_verdict_mark(struct nfq_q_handle *qh, u_int32_t id,
 	return __set_verdict(qh, id, verdict, mark, 1, data_len, buf);
 }
 
+/**
+ * @}
+ */
+
+
+
 /*************************************************************
  * Message parsing functions 
  *************************************************************/
 
 /**
+ * \defgroup Parsing Message parsing functions
+ * @{
+ */
+
+/**
  * nfqnl_msg_packet_hdr - return the metaheader that wraps the packet
- * @nfad: Netlink packet data handle passed to callback function
+ * \param nfad Netlink packet data handle passed to callback function
  *
- * Returns the netfilter queue netlink packet header for the given
+ * \return the netfilter queue netlink packet header for the given
  * nfq_data argument.  Typically, the nfq_data value is passed as the 3rd
  * parameter to the callback function set by a call to nfq_create_queue().
  *
  * The nfqnl_msg_packet_hdr structure is defined in libnetfilter_queue.h as:
  *
- * struct nfqnl_msg_packet_hdr {
- * 	u_int32_t	packet_id;	// unique ID of packet in queue
- * 	u_int16_t	hw_protocol;	// hw protocol (network order)
- * 	u_int8_t	hook;		// netfilter hook
- * } __attribute__ ((packed));
+ * \verbatim
+	struct nfqnl_msg_packet_hdr {
+		u_int32_t	packet_id;	// unique ID of packet in queue
+		u_int16_t	hw_protocol;	// hw protocol (network order)
+		u_int8_t	hook;		// netfilter hook
+	} __attribute__ ((packed));
+\endverbatim
  */
 struct nfqnl_msg_packet_hdr *nfq_get_msg_packet_hdr(struct nfq_data *nfad)
 {
@@ -561,9 +728,9 @@ struct nfqnl_msg_packet_hdr *nfq_get_msg_packet_hdr(struct nfq_data *nfad)
 
 /**
  * nfq_get_nfmark - get the packet mark
- * @nfad: Netlink packet data handle passed to callback function
+ * \param nfad Netlink packet data handle passed to callback function
  *
- * Returns the netfilter mark currently assigned to the given queued packet.
+ * \return the netfilter mark currently assigned to the given queued packet.
  */
 uint32_t nfq_get_nfmark(struct nfq_data *nfad)
 {
@@ -572,12 +739,12 @@ uint32_t nfq_get_nfmark(struct nfq_data *nfad)
 
 /**
  * nfq_get_timestamp - get the packet timestamp
- * @nfad: Netlink packet data handle passed to callback function
- * @tv: structure to fill with timestamp info
+ * \param nfad Netlink packet data handle passed to callback function
+ * \param tv structure to fill with timestamp info
  *
  * Retrieves the received timestamp when the given queued packet.
  *
- * Returns 0 on success, non-zero on failure.
+ * \return 0 on success, non-zero on failure.
  */
 int nfq_get_timestamp(struct nfq_data *nfad, struct timeval *tv)
 {
@@ -595,13 +762,13 @@ int nfq_get_timestamp(struct nfq_data *nfad, struct timeval *tv)
 
 /**
  * nfq_get_indev - get the interface that the packet was received through
- * @nfad: Netlink packet data handle passed to callback function
+ * \param nfad Netlink packet data handle passed to callback function
  *
- * The index of the device the queued packet was received via.  If the
+ * \return The index of the device the queued packet was received via.  If the
  * returned index is 0, the packet was locally generated or the input
  * interface is not known (ie. POSTROUTING?).
  *
- * WARNING: all nfq_get_dev() functions return 0 if not set, since linux
+ * \warning all nfq_get_dev() functions return 0 if not set, since linux
  * only allows ifindex >= 1, see net/core/dev.c:2600  (in 2.6.13.1)
  */
 u_int32_t nfq_get_indev(struct nfq_data *nfad)
@@ -611,9 +778,9 @@ u_int32_t nfq_get_indev(struct nfq_data *nfad)
 
 /**
  * nfq_get_physindev - get the physical interface that the packet was received
- * @nfad: Netlink packet data handle passed to callback function
+ * \param nfad Netlink packet data handle passed to callback function
  *
- * The index of the physical device the queued packet was received via.
+ * \return The index of the physical device the queued packet was received via.
  * If the returned index is 0, the packet was locally generated or the
  * physical input interface is no longer known (ie. POSTROUTING?).
  */
@@ -624,9 +791,9 @@ u_int32_t nfq_get_physindev(struct nfq_data *nfad)
 
 /**
  * nfq_get_outdev - gets the interface that the packet will be routed out
- * @nfad: Netlink packet data handle passed to callback function
+ * \param nfad Netlink packet data handle passed to callback function
  *
- * The index of the device the queued packet will be sent out.  If the
+ * \return The index of the device the queued packet will be sent out.  If the
  * returned index is 0, the packet is destined for localhost or the output
  * interface is not yet known (ie. PREROUTING?).
  */
@@ -637,13 +804,13 @@ u_int32_t nfq_get_outdev(struct nfq_data *nfad)
 
 /**
  * nfq_get_physoutdev - get the physical interface that the packet output
- * @nfad: Netlink packet data handle passed to callback function
+ * \param nfad Netlink packet data handle passed to callback function
  *
  * The index of the physical device the queued packet will be sent out.
  * If the returned index is 0, the packet is destined for localhost or the
  * physical output interface is not yet known (ie. PREROUTING?).
  * 
- * Retrieves the physical interface that the packet output will be routed out.
+ * \return The index of physical interface that the packet output will be routed out.
  */
 u_int32_t nfq_get_physoutdev(struct nfq_data *nfad)
 {
@@ -653,33 +820,41 @@ u_int32_t nfq_get_physoutdev(struct nfq_data *nfad)
 /**
  * nfq_get_indev_name - get the name of the interface the packet
  * was received through
- * @nlif_handle: pointer to a nlif interface resolving handle
- * @nfad: Netlink packet data handle passed to callback function
- * @name: pointer that will be set to the interface name string 
+ * \param nlif_handle pointer to a nlif interface resolving handle
+ * \param nfad Netlink packet data handle passed to callback function
+ * \param name pointer that will be set to the interface name string 
+ * \return -1 in case of error, >0 if it succeed. 
  *
- * The <name> variable will point to the name of the input interface.
+ * The #name variable will point to the name of the input interface.
  *
  * To use a nlif_handle, You need first to call nlif_open() and to open
  * an handler. Don't forget to store the result as it will be used 
  * during all your program life:
- * 	h = nlif_open();
- * 	if (h == NULL) {
- * 		perror("nlif_open");
- * 		exit(EXIT_FAILURE);
- * 	}
+ * \verbatim
+	h = nlif_open();
+ 	if (h == NULL) {
+ 		perror("nlif_open");
+ 		exit(EXIT_FAILURE);
+ 	}
+\endverbatim
  * Once the handler is open, you need to fetch the interface table at a
  * whole via a call to nlif_query.
- * 	nlif_query(h);
+ * \verbatim
+  	nlif_query(h);
+\endverbatim
  * libnfnetlink is able to update the interface mapping when a new interface
  * appears. To do so, you need to call nlif_catch() on the handler after each
  * interface related event. The simplest way to get and treat event is to run
  * a select() or poll() against the nlif file descriptor. To get this file 
  * descriptor, you need to use nlif_fd:
- * 	if_fd = nlif_fd(h);
+ * \verbatim
+ 	if_fd = nlif_fd(h);
+\endverbatim
  * Don't forget to close the handler when you don't need the feature anymore:
- * 	nlif_close(h);
+ * \verbatim
+ 	nlif_close(h);
+\endverbatim
  *
- * Return -1 in case of error, >0 if it succeed. 
  */
 int nfq_get_indev_name(struct nlif_handle *nlif_handle,
 			struct nfq_data *nfad, char *name)
@@ -691,16 +866,16 @@ int nfq_get_indev_name(struct nlif_handle *nlif_handle,
 /**
  * nfq_get_physindev_name - get the name of the physical interface the
  * packet was received through
- * @nlif_handle: pointer to a nlif interface resolving handle
- * @nfad: Netlink packet data handle passed to callback function
- * @name: pointer that will be set to the interface name string 
+ * \param nlif_handle pointer to a nlif interface resolving handle
+ * \param nfad Netlink packet data handle passed to callback function
+ * \param name pointer that will be set to the interface name string 
  *
- * The <name> variable will point to the name of the input physical
+ * The #name variable will point to the name of the input physical
  * interface.
  *
  * See nfq_get_indev_name() documentation for nlif_handle usage.
  *
- * Return -1 in case of error, >0 if it succeed. 
+ * \return  -1 in case of error, > 0 if it succeed. 
  */
 int nfq_get_physindev_name(struct nlif_handle *nlif_handle,
 			   struct nfq_data *nfad, char *name)
@@ -712,15 +887,15 @@ int nfq_get_physindev_name(struct nlif_handle *nlif_handle,
 /**
  * nfq_get_outdev_name - get the name of the physical interface the
  * packet will be sent to
- * @nlif_handle: pointer to a nlif interface resolving handle
- * @nfad: Netlink packet data handle passed to callback function
- * @name: pointer that will be set to the interface name string 
+ * \param nlif_handle pointer to a nlif interface resolving handle
+ * \param nfad Netlink packet data handle passed to callback function
+ * \param name pointer that will be set to the interface name string 
  *
- * The <name> variable will point to the name of the output interface.
+ * The #name variable will point to the name of the output interface.
  *
  * See nfq_get_indev_name() documentation for nlif_handle usage.
  *
- * Return -1 in case of error, >0 if it succeed. 
+ * \return  -1 in case of error, > 0 if it succeed. 
  */
 int nfq_get_outdev_name(struct nlif_handle *nlif_handle,
 			struct nfq_data *nfad, char *name)
@@ -732,16 +907,15 @@ int nfq_get_outdev_name(struct nlif_handle *nlif_handle,
 /**
  * nfq_get_physoutdev_name - get the name of the interface the
  * packet will be sent to
- * @nlif_handle: pointer to a nlif interface resolving handle
- * @nfad: Netlink packet data handle passed to callback function
- * @name: pointer that will be set to the interface name string 
- *
- * The <name> variable will point to the name of the physical
+ * \param nlif_handle pointer to a nlif interface resolving handle
+ * \param nfad Netlink packet data handle passed to callback function
+ * \param name pointer that will be set to the interface name string 
+ * The #name variable will point to the name of the physical
  * output interface.
  *
  * See nfq_get_indev_name() documentation for nlif_handle usage.
  *
- * Return -1 in case of error, >0 if it succeed. 
+ * \return  -1 in case of error, > 0 if it succeed. 
  */
 
 int nfq_get_physoutdev_name(struct nlif_handle *nlif_handle,
@@ -752,8 +926,11 @@ int nfq_get_physoutdev_name(struct nlif_handle *nlif_handle,
 }
 
 /**
- * nfq_get_packet_hw - get hardware address 
- * @nfad: Netlink packet data handle passed to callback function
+ * nfq_get_packet_hw
+ *
+ * get hardware address 
+ *
+ * \param nfad Netlink packet data handle passed to callback function
  *
  * Retrieves the hardware address associated with the given queued packet.
  * For ethernet packets, the hardware address returned (if any) will be the
@@ -762,12 +939,13 @@ int nfq_get_physoutdev_name(struct nlif_handle *nlif_handle,
  * currently be retrieved.
  *
  * The nfqnl_msg_packet_hw structure is defined in libnetfilter_queue.h as:
- *
- * struct nfqnl_msg_packet_hw {
- * 	u_int16_t	hw_addrlen;
- * 	u_int16_t	_pad;
- * 	u_int8_t	hw_addr[8];
- * } __attribute__ ((packed));
+ * \verbatim
+	struct nfqnl_msg_packet_hw {
+		u_int16_t	hw_addrlen;
+		u_int16_t	_pad;
+		u_int8_t	hw_addr[8];
+	} __attribute__ ((packed));
+\endverbatim
  */
 struct nfqnl_msg_packet_hw *nfq_get_packet_hw(struct nfq_data *nfad)
 {
@@ -777,14 +955,14 @@ struct nfqnl_msg_packet_hw *nfq_get_packet_hw(struct nfq_data *nfad)
 
 /**
  * nfq_get_payload - get payload 
- * @nfad: Netlink packet data handle passed to callback function
- * @data: Pointer of pointer that will be pointed to the payload
+ * \param nfad Netlink packet data handle passed to callback function
+ * \param data Pointer of pointer that will be pointed to the payload
  *
  * Retrieve the payload for a queued packet. The actual amount and type of
  * data retrieved by this function will depend on the mode set with the
  * nfq_set_mode() function.
  *
- * Returns -1 on error, otherwise > 0.
+ * \return -1 on error, otherwise > 0.
  */
 int nfq_get_payload(struct nfq_data *nfad, char **data)
 {
@@ -794,3 +972,7 @@ int nfq_get_payload(struct nfq_data *nfad, char **data)
 
 	return -1;
 }
+
+/**
+ * @}
+ */
-- 
1.5.6.3

