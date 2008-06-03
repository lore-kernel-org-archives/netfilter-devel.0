From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: [PATCH 2/3] libnetlink-log byte alignment
Date: Tue, 03 Jun 2008 11:21:12 +0100
Message-ID: <1212488472.29489.41.camel@pumper.lan.luxnet.ch>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49069 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751762AbYFCKVO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2008 06:21:14 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Aligns buffers to maximum alignment of architecture to make the cast of
char pointers to struct pointers more portable. Packet decoding is still
broken on particular platforms.

Signed-off-by: Fabian Hugelshofer <hugelshofer2006@gmx.ch>


diff -ruN libnfnetlink-0.0.38.orig/src/libnfnetlink.c libnfnetlink-0.0.38/src/libnfnetlink.c
--- libnfnetlink-0.0.38.orig/src/libnfnetlink.c	2008-06-02 18:54:18.000000000 +0100
+++ libnfnetlink-0.0.38/src/libnfnetlink.c	2008-06-02 18:57:32.000000000 +0100
@@ -528,7 +528,7 @@
 			       void *), void *jarg)
 {
 	struct sockaddr_nl nladdr;
-	char buf[NFNL_BUFFSIZE];
+	char buf[NFNL_BUFFSIZE] __attribute__ ((aligned));
 	struct iovec iov;
 	int remain;
 	struct nlmsghdr *h;
@@ -637,7 +637,7 @@
 	      int (*junk)(struct sockaddr_nl *, struct nlmsghdr *n, void *),
 	      void *jarg)
 {
-	char buf[NFNL_BUFFSIZE];
+	char buf[NFNL_BUFFSIZE] __attribute__ ((aligned));
 	struct sockaddr_nl nladdr;
 	struct nlmsghdr *h;
 	unsigned int seq;
@@ -1474,7 +1474,8 @@
 	assert(h);
 
 	while (1) {
-		unsigned char buf[h->rcv_buffer_size];
+		unsigned char buf[h->rcv_buffer_size]
+			__attribute__ ((aligned));
 
 		ret = nfnl_recv(h, buf, sizeof(buf));
 		if (ret == -1) {


