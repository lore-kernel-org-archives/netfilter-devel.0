Return-Path: <SRS0=FFQ3=2V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C58F4C2D0C3
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Dec 2019 01:49:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96E0420663
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Dec 2019 01:49:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbfLaBtg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Dec 2019 20:49:36 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:58272 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725379AbfLaBtg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Dec 2019 20:49:36 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 50AAE3A1F2B
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Dec 2019 12:49:21 +1100 (AEDT)
Received: (qmail 25081 invoked by uid 501); 31 Dec 2019 01:49:20 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 1/2] src: libnetfilter_queue.c: whitespace: remove trailing spaces
Date:   Tue, 31 Dec 2019 12:49:19 +1100
Message-Id: <20191231014920.25039-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20191230115353.tg3lxjhnckqqs3pj@salvia>
References: <20191230115353.tg3lxjhnckqqs3pj@salvia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=pxVhFHJ0LMsA:10 a=RSmzAf-M6YYA:10
        a=PO7r1zJSAAAA:8 a=3HDBlxybAAAA:8 a=NFchKwDOPmFI7Y3Vh8MA:9
        a=7Ud94Xm7L_IZWYUz:21 a=AOlbmtk4pwwLBw9F:21 a=laEoCiVfU_Unz3mSdgXN:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/libnetfilter_queue.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index cd14825..3f70ba2 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -4,7 +4,7 @@
  * (C) 2005, 2008-2010 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
  *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2 
+ *  it under the terms of the GNU General Public License version 2
  *  as published by the Free Software Foundation (or any later at your option)
  *
  *  This program is distributed in the hope that it will be useful,
@@ -79,7 +79,7 @@
  * to receive from and to send packets to kernel-space.
  *
  * \section using Using libnetfilter_queue
- * 
+ *
  * To write your own program using libnetfilter_queue, you should start by
  * reading (or, if feasible, compiling and stepping through with *gdb*)
  * nf-queue.c source file.
@@ -147,7 +147,7 @@ struct nfq_data {
 EXPORT_SYMBOL int nfq_errno;
 
 /***********************************************************************
- * low level stuff 
+ * low level stuff
  ***********************************************************************/
 
 static void del_qh(struct nfq_q_handle *qh)
@@ -238,12 +238,12 @@ struct nfnl_handle *nfq_nfnlh(struct nfq_handle *h)
  *
  * \defgroup Queue Queue handling [DEPRECATED]
  *
- * Once libnetfilter_queue library has been initialised (See 
+ * Once libnetfilter_queue library has been initialised (See
  * \link LibrarySetup \endlink), it is possible to bind the program to a
  * specific queue. This can be done by using nfq_create_queue().
  *
  * The queue can then be tuned via nfq_set_mode() or nfq_set_queue_maxlen().
- * 
+ *
  * Here's a little code snippet that create queue numbered 0:
  * \verbatim
 	printf("binding this socket to queue '0'\n");
@@ -318,7 +318,7 @@ int nfq_fd(struct nfq_handle *h)
  *
  * Library initialisation is made in two steps.
  *
- * First step is to call nfq_open() to open a NFQUEUE handler. 
+ * First step is to call nfq_open() to open a NFQUEUE handler.
  *
  * Second step is to tell the kernel that userspace queueing is handle by
  * NFQUEUE for the selected protocol. This is made by calling nfq_unbind_pf()
@@ -387,7 +387,7 @@ struct nfq_handle *nfq_open(void)
  * \param nfnlh Netfilter netlink connection handle obtained by calling nfnl_open()
  *
  * This function obtains a netfilter queue connection handle using an existing
- * netlink connection. This function is used internally to implement 
+ * netlink connection. This function is used internally to implement
  * nfq_open(), and should typically not be called directly.
  *
  * \return a pointer to a new queue handle or NULL on failure.
@@ -409,7 +409,7 @@ struct nfq_handle *nfq_open_nfnl(struct nfnl_handle *nfnlh)
 	memset(h, 0, sizeof(*h));
 	h->nfnlh = nfnlh;
 
-	h->nfnlssh = nfnl_subsys_open(h->nfnlh, NFNL_SUBSYS_QUEUE, 
+	h->nfnlssh = nfnl_subsys_open(h->nfnlh, NFNL_SUBSYS_QUEUE,
 				      NFQNL_MSG_MAX, 0);
 	if (!h->nfnlssh) {
 		/* FIXME: nfq_errno */
@@ -446,7 +446,7 @@ out_free:
  *
  * This function closes the nfqueue handler and free associated resources.
  *
- * \return 0 on success, non-zero on failure. 
+ * \return 0 on success, non-zero on failure.
  */
 EXPORT_SYMBOL
 int nfq_close(struct nfq_handle *h)
@@ -830,14 +830,14 @@ static int __set_verdict(struct nfq_q_handle *qh, uint32_t id,
  */
 
 /**
- * nfq_set_verdict - issue a verdict on a packet 
+ * nfq_set_verdict - issue a verdict on a packet
  * \param qh Netfilter queue handle obtained by call to nfq_create_queue().
  * \param id	ID assigned to packet by netfilter.
  * \param verdict verdict to return to netfilter (NF_ACCEPT, NF_DROP)
  * \param data_len number of bytes of data pointed to by #buf
  * \param buf the buffer that contains the packet data
  *
- * Can be obtained by: 
+ * Can be obtained by:
  * \verbatim
 	int id;
 	struct nfqnl_msg_packet_hdr *ph = nfq_get_msg_packet_hdr(tb);
@@ -944,7 +944,7 @@ int nfq_set_verdict_mark(struct nfq_q_handle *qh, uint32_t id,
 
 
 /*************************************************************
- * Message parsing functions 
+ * Message parsing functions
  *************************************************************/
 
 /**
@@ -1065,7 +1065,7 @@ uint32_t nfq_get_outdev(struct nfq_data *nfad)
  * The index of the physical device the queued packet will be sent out.
  * If the returned index is 0, the packet is destined for localhost or the
  * physical output interface is not yet known (ie. PREROUTING?).
- * 
+ *
  * \return The index of physical interface that the packet output will be routed out.
  */
 EXPORT_SYMBOL
@@ -1081,10 +1081,10 @@ uint32_t nfq_get_physoutdev(struct nfq_data *nfad)
  * \param nfad Netlink packet data handle passed to callback function
  * \param name pointer to the buffer to receive the interface name;
  *  not more than \c IFNAMSIZ bytes will be copied to it.
- * \return -1 in case of error, >0 if it succeed. 
+ * \return -1 in case of error, >0 if it succeed.
  *
  * To use a nlif_handle, You need first to call nlif_open() and to open
- * an handler. Don't forget to store the result as it will be used 
+ * an handler. Don't forget to store the result as it will be used
  * during all your program life:
  * \verbatim
 	h = nlif_open();
@@ -1101,7 +1101,7 @@ uint32_t nfq_get_physoutdev(struct nfq_data *nfad)
  * libnfnetlink is able to update the interface mapping when a new interface
  * appears. To do so, you need to call nlif_catch() on the handler after each
  * interface related event. The simplest way to get and treat event is to run
- * a select() or poll() against the nlif file descriptor. To get this file 
+ * a select() or poll() against the nlif file descriptor. To get this file
  * descriptor, you need to use nlif_fd:
  * \verbatim
 	if_fd = nlif_fd(h);
@@ -1130,7 +1130,7 @@ int nfq_get_indev_name(struct nlif_handle *nlif_handle,
  *
  * See nfq_get_indev_name() documentation for nlif_handle usage.
  *
- * \return  -1 in case of error, > 0 if it succeed. 
+ * \return  -1 in case of error, > 0 if it succeed.
  */
 EXPORT_SYMBOL
 int nfq_get_physindev_name(struct nlif_handle *nlif_handle,
@@ -1150,7 +1150,7 @@ int nfq_get_physindev_name(struct nlif_handle *nlif_handle,
  *
  * See nfq_get_indev_name() documentation for nlif_handle usage.
  *
- * \return  -1 in case of error, > 0 if it succeed. 
+ * \return  -1 in case of error, > 0 if it succeed.
  */
 EXPORT_SYMBOL
 int nfq_get_outdev_name(struct nlif_handle *nlif_handle,
@@ -1170,7 +1170,7 @@ int nfq_get_outdev_name(struct nlif_handle *nlif_handle,
  *
  * See nfq_get_indev_name() documentation for nlif_handle usage.
  *
- * \return  -1 in case of error, > 0 if it succeed. 
+ * \return  -1 in case of error, > 0 if it succeed.
  */
 
 EXPORT_SYMBOL
@@ -1184,7 +1184,7 @@ int nfq_get_physoutdev_name(struct nlif_handle *nlif_handle,
 /**
  * nfq_get_packet_hw
  *
- * get hardware address 
+ * get hardware address
  *
  * \param nfad Netlink packet data handle passed to callback function
  *
@@ -1277,7 +1277,7 @@ int nfq_get_secctx(struct nfq_data *nfad, unsigned char **secdata)
 }
 
 /**
- * nfq_get_payload - get payload 
+ * nfq_get_payload - get payload
  * \param nfad Netlink packet data handle passed to callback function
  * \param data Pointer of pointer that will be pointed to the payload
  *
-- 
2.14.5

