From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 7/8] Add code for duplication of message in ULOG
Date: Sun,  9 Mar 2008 23:36:28 +0100
Message-ID: <12051021901513-git-send-email-eric@inl.fr>
References: <12051021893015-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:57598 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753318AbYCIWgc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Mar 2008 18:36:32 -0400
In-Reply-To: <12051021893015-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In case of multiple usage of the same instance, this patch adds support for duplication
of the message to be able to have multiple use of the same ULOG instance.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/packet/ulogd_inppkt_ULOG.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/input/packet/ulogd_inppkt_ULOG.c b/input/packet/ulogd_inppkt_ULOG.c
index cf44474..c49345d 100644
--- a/input/packet/ulogd_inppkt_ULOG.c
+++ b/input/packet/ulogd_inppkt_ULOG.c
@@ -215,6 +215,7 @@ static int interp_packet(struct ulogd_pluginstance *ip, ulog_packet_msg_t *pkt)
 static int ulog_read_cb(int fd, unsigned int what, void *param)
 {
 	struct ulogd_pluginstance *upi = (struct ulogd_pluginstance *)param;
+	struct ulogd_pluginstance *npi = NULL;
 	struct ulog_input *u = (struct ulog_input *) &upi->private;
 	ulog_packet_msg_t *upkt;
 	int len;
@@ -239,6 +240,10 @@ static int ulog_read_cb(int fd, unsigned int what, void *param)
 		while ((upkt = ipulog_get_packet(u->libulog_h,
 						 u->libulog_buf, len))) {
 			ulogd_log(ULOGD_DEBUG, "==> ulog packet received\n");
+			/* ok let's feed the bird (other instance) */
+			llist_for_each_entry(npi, &upi->plist, plist) {
+				interp_packet(npi, upkt);
+			}
 			interp_packet(upi, upkt);
 		}
 	}
-- 
1.5.4.3

