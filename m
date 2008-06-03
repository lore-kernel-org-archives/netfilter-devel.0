From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: [PATCH 1/3] libnfnetlink byte alignment
Date: Tue, 03 Jun 2008 11:20:48 +0100
Message-ID: <1212488448.29489.40.camel@pumper.lan.luxnet.ch>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57685 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751895AbYFCKUu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2008 06:20:50 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Aligns buffers to maximum alignment of architecture to make the cast of
char pointers to struct pointers more portable.

Signed-off-by: Fabian Hugelshofer <hugelshofer2006@gmx.ch>


--- libnetfilter_log-0.0.13.orig/src/libnetfilter_log.c	2008-06-02 09:50:47.000000000 +0100
+++ libnetfilter_log-0.0.13/src/libnetfilter_log.c	2008-06-02 18:22:14.000000000 +0100
@@ -107,7 +107,8 @@
 		     u_int16_t queuenum, u_int8_t pf)
 {
 	char buf[NFNL_HEADER_LEN
-		+NFA_LENGTH(sizeof(struct nfulnl_msg_config_cmd))];
+		+NFA_LENGTH(sizeof(struct nfulnl_msg_config_cmd))]
+		__attribute__ ((aligned));
 	struct nfulnl_msg_config_cmd cmd;
 	struct nlmsghdr *nmh = (struct nlmsghdr *) buf;
 
@@ -292,7 +293,8 @@
 		   u_int8_t mode, u_int32_t range)
 {
 	char buf[NFNL_HEADER_LEN
-		+NFA_LENGTH(sizeof(struct nfulnl_msg_config_mode))];
+		+NFA_LENGTH(sizeof(struct nfulnl_msg_config_mode))]
+		__attribute__ ((aligned));
 	struct nfulnl_msg_config_mode params;
 	struct nlmsghdr *nmh = (struct nlmsghdr *) buf;
 
@@ -309,7 +311,8 @@
 
 int nflog_set_timeout(struct nflog_g_handle *gh, u_int32_t timeout)
 {
-	char buf[NFNL_HEADER_LEN+NFA_LENGTH(sizeof(u_int32_t))];
+	char buf[NFNL_HEADER_LEN+NFA_LENGTH(sizeof(u_int32_t))]
+		__attribute__ ((aligned));
 	struct nlmsghdr *nmh = (struct nlmsghdr *) buf;
 
 	nfnl_fill_hdr(gh->h->nfnlssh, nmh, 0, AF_UNSPEC, gh->id,
@@ -322,7 +325,8 @@
 
 int nflog_set_qthresh(struct nflog_g_handle *gh, u_int32_t qthresh)
 {
-	char buf[NFNL_HEADER_LEN+NFA_LENGTH(sizeof(u_int32_t))];
+	char buf[NFNL_HEADER_LEN+NFA_LENGTH(sizeof(u_int32_t))]
+		__attribute__ ((aligned));
 	struct nlmsghdr *nmh = (struct nlmsghdr *) buf;
 
 	nfnl_fill_hdr(gh->h->nfnlssh, nmh, 0, AF_UNSPEC, gh->id,
@@ -335,7 +339,8 @@
 
 int nflog_set_nlbufsiz(struct nflog_g_handle *gh, u_int32_t nlbufsiz)
 {
-	char buf[NFNL_HEADER_LEN+NFA_LENGTH(sizeof(u_int32_t))];
+	char buf[NFNL_HEADER_LEN+NFA_LENGTH(sizeof(u_int32_t))]
+		__attribute__ ((aligned));
 	struct nlmsghdr *nmh = (struct nlmsghdr *) buf;
 	int status;
 
@@ -355,7 +360,8 @@
 
 int nflog_set_flags(struct nflog_g_handle *gh, u_int16_t flags)
 {
-	char buf[NFNL_HEADER_LEN+NFA_LENGTH(sizeof(u_int16_t))];
+	char buf[NFNL_HEADER_LEN+NFA_LENGTH(sizeof(u_int16_t))]
+		__attribute__ ((aligned));
 	struct nlmsghdr *nmh = (struct nlmsghdr *) buf;
 
 	nfnl_fill_hdr(gh->h->nfnlssh, nmh, 0, AF_UNSPEC, gh->id,


