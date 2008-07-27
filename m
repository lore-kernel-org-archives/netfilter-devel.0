From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 03/11] Suppress unused parameter in ipulog_read.
Date: Sun, 27 Jul 2008 15:51:18 +0200
Message-ID: <1217166686-28508-4-git-send-email-eric@inl.fr>
References: <20080723162746.GB31572@bayen.regit.org>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43793 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751779AbYG0Nv3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Jul 2008 09:51:29 -0400
In-Reply-To: <20080723162746.GB31572@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The function ipulog_read had a timeout parameter which was not
used in the code.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 include/libipulog/libipulog.h    |    2 +-
 input/packet/ulogd_inppkt_ULOG.c |    2 +-
 libipulog/libipulog.c            |    2 +-
 libipulog/ulog_test.c            |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/libipulog/libipulog.h b/include/libipulog/libipulog.h
index a049d27..1f6aee9 100644
--- a/include/libipulog/libipulog.h
+++ b/include/libipulog/libipulog.h
@@ -29,7 +29,7 @@ struct ipulog_handle *ipulog_create_handle(u_int32_t gmask, u_int32_t rmem);
 void ipulog_destroy_handle(struct ipulog_handle *h);
 
 ssize_t ipulog_read(struct ipulog_handle *h,
-		    unsigned char *buf, size_t len, int timeout);
+		    unsigned char *buf, size_t len);
 
 ulog_packet_msg_t *ipulog_get_packet(struct ipulog_handle *h,
 				     const unsigned char *buf,
diff --git a/input/packet/ulogd_inppkt_ULOG.c b/input/packet/ulogd_inppkt_ULOG.c
index c00d9bf..3fdb42e 100644
--- a/input/packet/ulogd_inppkt_ULOG.c
+++ b/input/packet/ulogd_inppkt_ULOG.c
@@ -255,7 +255,7 @@ static int ulog_read_cb(int fd, unsigned int what, void *param)
 		return 0;
 
 	while ((len = ipulog_read(u->libulog_h, u->libulog_buf,
-				 upi->config_kset->ces[0].u.value, 1))) {
+				 upi->config_kset->ces[0].u.value))) {
 		if (len <= 0) {
 			if (errno == EAGAIN)
 				break;
diff --git a/libipulog/libipulog.c b/libipulog/libipulog.c
index 8917bcc..6b7ea35 100644
--- a/libipulog/libipulog.c
+++ b/libipulog/libipulog.c
@@ -190,7 +190,7 @@ int ipulog_set_mode()
 
 /* do a BLOCKING read on an ipulog handle */
 ssize_t ipulog_read(struct ipulog_handle *h, unsigned char *buf,
-		    size_t len, int timeout)
+		    size_t len)
 {
 	return ipulog_netlink_recvfrom(h, buf, len);
 }
diff --git a/libipulog/ulog_test.c b/libipulog/ulog_test.c
index c891764..fd9c925 100644
--- a/libipulog/ulog_test.c
+++ b/libipulog/ulog_test.c
@@ -67,7 +67,7 @@ int main(int argc, char *argv[])
 
 	/* loop receiving packets and handling them over to handle_packet */
 	for (i = 0; i < atoi(argv[1]); i++) {
-		len = ipulog_read(h, buf, MYBUFSIZ, 1);
+		len = ipulog_read(h, buf, MYBUFSIZ);
 		if (len <= 0) {
 			ipulog_perror("ulog_test: short read");
 			exit(1);
-- 
1.5.4.3

