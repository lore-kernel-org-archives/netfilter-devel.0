From: Eric Leblond <eric@inl.fr>
Subject: [libnetfilter_log PATCH] Add parsing function for raw hardware header.
Date: Thu, 17 Jul 2008 00:29:06 +0200
Message-ID: <1216247346-21553-1-git-send-email-eric@inl.fr>
References: <487CA584.3030200@trash.net>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:56621 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751306AbYGPW3J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Jul 2008 18:29:09 -0400
In-Reply-To: <487CA584.3030200@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for the parsing of NFULA_HWTYPE, NFULA_HWHEADER,
and NFULA_HWLEN part of the NFLOG message. This permits to have a ULOG
like behaviour but thanks to NFULA_HWTYPE we will be able to parse the
message cleanly in userspace.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 include/libnetfilter_log/libnetfilter_log.h    |    5 +++++
 include/libnetfilter_log/linux_nfnetlink_log.h |    3 +++
 src/libnetfilter_log.c                         |   16 ++++++++++++++++
 3 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/include/libnetfilter_log/libnetfilter_log.h b/include/libnetfilter_log/libnetfilter_log.h
index 4e5d763..aa0da72 100644
--- a/include/libnetfilter_log/libnetfilter_log.h
+++ b/include/libnetfilter_log/libnetfilter_log.h
@@ -48,6 +48,11 @@ extern int nflog_handle_packet(struct nflog_handle *h, char *buf, int len);
 
 
 extern struct nfulnl_msg_packet_hdr *nflog_get_msg_packet_hdr(struct nflog_data *nfad);
+
+extern u_int16_t nflog_get_hwtype(struct nflog_data *nfad);
+extern u_int16_t nflog_get_msg_packet_hwhdrlen(struct nflog_data *nfad);
+extern char *nflog_get_msg_packet_hwhdr(struct nflog_data *nfad);
+
 extern u_int32_t nflog_get_nfmark(struct nflog_data *nfad);
 extern int nflog_get_timestamp(struct nflog_data *nfad, struct timeval *tv);
 extern u_int32_t nflog_get_indev(struct nflog_data *nfad);
diff --git a/include/libnetfilter_log/linux_nfnetlink_log.h b/include/libnetfilter_log/linux_nfnetlink_log.h
index f8e174d..4c802c8 100644
--- a/include/libnetfilter_log/linux_nfnetlink_log.h
+++ b/include/libnetfilter_log/linux_nfnetlink_log.h
@@ -54,6 +54,9 @@ enum nfulnl_attr_type {
 	NFULA_SEQ,			/* instance-local sequence number */
 	NFULA_SEQ_GLOBAL,		/* global sequence number */
 	NFULA_GID,			/* group id of socket */
+	NFULA_HWTYPE,			/* hardware type */
+	NFULA_HWHEADER,			/* hardware header */
+	NFULA_HWLEN,			/* hardware header length */
 
 	__NFULA_MAX
 };
diff --git a/src/libnetfilter_log.c b/src/libnetfilter_log.c
index 2019b0c..6c0936e 100644
--- a/src/libnetfilter_log.c
+++ b/src/libnetfilter_log.c
@@ -385,6 +385,22 @@ struct nfulnl_msg_packet_hdr *nflog_get_msg_packet_hdr(struct nflog_data *nfad)
 					 struct nfulnl_msg_packet_hdr);
 }
 
+
+u_int16_t nflog_get_hwtype(struct nflog_data *nfad)
+{
+	return ntohs(nfnl_get_data(nfad->nfa, NFULA_HWTYPE, u_int16_t));
+}
+
+u_int16_t nflog_get_msg_packet_hwhdrlen(struct nflog_data *nfad)
+{
+	return ntohs(nfnl_get_data(nfad->nfa, NFULA_HWLEN, u_int16_t));
+}
+
+char *nflog_get_msg_packet_hwhdr(struct nflog_data *nfad)
+{
+	return nfnl_get_pointer_to_data(nfad->nfa, NFULA_HWHEADER, char);
+}
+
 u_int32_t nflog_get_nfmark(struct nflog_data *nfad)
 {
 	return ntohl(nfnl_get_data(nfad->nfa, NFULA_MARK, u_int32_t));
-- 
1.5.4.3

